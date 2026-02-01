# neovim colorscheme golded dark
# Chart of gold daily for past 12 months 
# Shows the difference between simple and compound returns

import polars as pl
import typst
from pathlib import Path

imgdir = Path(__file__).parent / "images"
imgdir.mkdir(exist_ok=True)
datadir = Path(__file__).parent / "data"

gold = pl.read_csv(datadir / "gold.csv")

firstprint = gold["close"][0]

goldidxs = (gold.rename({"close": "gold"})
            .with_columns((pl.col("gold")/pl.col("gold").shift())
                          .fill_null(1)
                          .alias("geom_ret"))
            .with_columns(pl.col("gold").pct_change()
                          .fill_null(0).alias("simple_ret"))
            .with_columns(pl.col("geom_ret").cum_prod()
                          .alias("geom_idx"))
            .with_columns((pl.col("simple_ret").cum_sum())
                          .add(1)
                          .alias("simple_idx"))
            .with_columns(pl.col("simple_idx")
                          .mul(firstprint)
                          .alias("simple_gold"),
                          pl.col("geom_idx")
                          .mul(firstprint)
                          .alias("geom_gold"))
            .with_columns((pl.col("date").str.strptime(pl.Date, "%Y-%m-%d"))))

goldidxs.write_csv(datadir / "goldidxs.csv")
#typst.compile(input = "gold.typ", output = imgdir / "gold.pdf")





    

