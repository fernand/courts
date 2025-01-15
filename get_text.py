import polars as pl
import pickle

df_query = pl.read_csv('query.csv', columns=['opinion_id'])
unique_opinion_ids = df_query['opinion_id'].unique().cast(pl.Int64)

df_opinions = (
    pl.scan_csv(
        r'C:\hd2\courtlistener\opinions-2024-12-31.csv',
        has_header=True,
        quote_char='`',
    )
    .select(['id', 'html'])
    .filter(pl.col('id').is_in(unique_opinion_ids))
)

filtered_df = df_opinions.collect()

opinion_dict = dict(zip(filtered_df['id'].to_list(), filtered_df['html'].to_list()))

with open('opinions.pkl', 'wb') as f:
    pickle.dump(opinion_dict, f)