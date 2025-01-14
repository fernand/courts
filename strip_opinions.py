import polars as pl

input_file = "/nvme/courtlistener/opinions-2024-12-31.csv"
output_file = "/nvme/courtlistener/opinions_stripped-2024-12-31.csv"

df = pl.scan_csv(
    input_file,
    separator=",",
    quote_char="`",
    ignore_errors=False,
).with_columns([
    pl.lit(' ').alias('plain_text'),
    pl.lit(' ').alias('html'),
    pl.lit(' ').alias('html_lawbox'),
    pl.lit(' ').alias('html_columbia'),
    pl.lit(' ').alias('html_with_citations'),
    pl.lit(' ').alias('extracted_by_ocr'),
]).sink_csv(output_file, quote_char="`")