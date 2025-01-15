import pickle

import polars as pl

# n = 585754
df_query = pl.read_csv('query.csv', columns=['opinion_id'])
df_query = df_query.sample(n=1000)
unique_opinion_ids = df_query['opinion_id'].unique()

df_opinions = (
    pl.scan_csv(
        r'C:\Users\Fernand\Downloads\opinions-2024-12-31.csv',
        has_header=True,
        quote_char='`',
    )
    .select(['id', 'html'])
    .filter(pl.col('id').cast(pl.Int64).is_in(unique_opinion_ids))
)

filtered_df = df_opinions.collect(streaming=True)

opinion_dict = dict(zip(filtered_df['id'].to_list(), filtered_df['html'].to_list()))

with open('opinions.pkl', 'wb') as f:
    pickle.dump(opinion_dict, f)