import polars as pl

input_file = "/nvme/courtlistener/opinions-2024-12-31.csv"
output_file = "/nvme/courtlistener/opinions_cleaned-2024-12-31.csv"

df = pl.scan_csv(
    input_file,
    separator=",",
    quote_char="`",
    ignore_errors=False,
).with_columns([
    pl.col("plain_text").str.replace_all("\n", "\/n"),
    pl.col("html").str.replace_all("\n", "\/n"),
    pl.col("html_lawbox").str.replace_all("\n", "\/n"),
    pl.col("html_columbia").str.replace_all("\n", "\/n"),
    pl.col("html_with_citations").str.replace_all("\n", "\/n"),
    pl.col("extracted_by_ocr").str.replace_all("\n", "\/n"),
]).sink_csv(output_file, quote_char="`")