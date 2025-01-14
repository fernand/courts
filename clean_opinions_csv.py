import polars as pl

input_file = "/nvme/courtlistener/opinions-2024-12-31.csv"
output_file = "/nvme/courtlistener/opinions_cleaned-2024-12-31.csv"

df = pl.scan_csv(
    input_file,
    separator=",",
    quote_char="`",
    ignore_errors=True  # Skip malformed rows
)

df.sink_csv(output_file)
