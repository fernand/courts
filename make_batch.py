import json
import pickle

import utils

def step_1_count_tokens():
    with open('opinions.pkl', 'rb') as f:
        opinions: dict[int, str] = pickle.load(f)
    import tiktoken
    encoding = tiktoken.encoding_for_model('gpt-4o-mini')
    num_tokens = sum([len(encoding.encode(t)) for t in opinions.values()])
    cost = round(num_tokens * 0.075 / 1e6, 2)
    print(f'Cost for batch ${cost}')

PROMPT = "Extract from this court opinion any references to documents of law or regulation as well as briefly what each reference is.\n\n"

def step_2_make_batch():
    with open('opinions.pkl', 'rb') as f:
        opinions: dict[int, str] = pickle.load(f)
    batch = []
    for opinion_id, text in opinions.items():
        if len(text) == 0:
            continue
        batch.append({
            'custom_id': str(opinion_id),
            'method': 'POST',
            'url': '/v1/chat/completions',
            'body': {
                'model': 'gpt-4o-mini',
                'messages': utils.chat_template(PROMPT + text),
                'max_tokens': 10000,
                'response_format': {
                    'type': 'json_schema',
                    'json_schema': {
                        'name': 'references',
                        'schema': {
                            'type': 'array',
                            'items': {
                                'type': 'object',
                                'properties': {
                                    'reference': {'type': 'string'},
                                    'context': {'type': 'string'},
                                },
                                'required': ['reference', 'context'],
                                'additionalProperties': False,
                            }
                        },
                        'strict': True,
                    },
                }
            }
        })
    with open('batch.jsonl', 'w') as f:
        f.write('\n'.join([json.dumps(item) for item in batch]))

if __name__ == '__main__':
    # step_1_count_tokens()
    step_2_make_batch()
