Methodology
-----------

The raw data delivery is put in [`raw/`](raw/).
A tiny bit of preprocssing was done before adding the data:

* `Kunstnere 2.xslx` was converted to `artists.csv` using Numbers `3.5.3`, and
  some summary rows at the end of the file were removed
* `indboeb_pol.csv` was renamed to `purchases.csv` and transcoded from `utf-16`
  to `utf-8` using `iconv -f utf-16 -t utf-8`

[`refined-data/committee-members.csv`](refined-data/committee-members.csv)
was collected by me personally at the HACK4DK 2015. The methodology used for
that is described as comments at the top of the file.

Everything else is reproducible using `process.jl` using Julia `0.3.10`
