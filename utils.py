import random
import time
from functools import wraps

import openai
from pydantic import BaseModel

from api_config import *

openai_client = openai.OpenAI(api_key=OPENAI_API_KEY)

def retry_with_exponential_backoff(
    func,
    initial_delay: float = 1,
    exponential_base: float = 2,
    jitter: bool = True,
    max_retries: int = 10,
    errors: tuple = (openai.RateLimitError, ),
):
    """Retry a function with exponential backoff."""
    @wraps(func)
    def wrapper(*args, **kwargs):
        num_retries = 0
        delay = initial_delay
        while True:
            try:
                return func(*args, **kwargs)
            except errors as e:
                num_retries += 1
                if num_retries > max_retries:
                    raise Exception(f"Maximum number of retries ({max_retries}) exceeded.")
                delay *= exponential_base * (1 + jitter * random.random())
                time.sleep(delay)
            except Exception as e:
                raise e

    return wrapper

def chat_template(message, system=None):
    prompts = []
    if system is not None:
        prompts.append({
            'role': 'system',
            'content': system,
        })
    prompts.append({
        'role': 'user',
        'content': message,
    })
    return prompts

class Reference(BaseModel):
    reference: str
    context: str

class References(BaseModel):
    references_and_context: list[Reference]

# Could use chatgpt-4o-latest and then extract the search queries in another step
@retry_with_exponential_backoff
def get_openai_response(message, format=None, model='gpt-4o-mini'):
    if format is None:
        completion = openai_client.beta.chat.completions.parse(
            model=model,
            messages=chat_template(message),
        )
        return completion.choices[0].message.content
    else:
        completion = openai_client.beta.chat.completions.parse(
            model=model,
            messages=chat_template(message),
            response_format=format,
        )
        return completion.choices[0].message.parsed
