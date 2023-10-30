dotsViolin. Dot Plots Mimicking Violin Plots
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

<br><a href='https://ko-fi.com/X7X71PZZG' target='_blank'><img height='30' style='border:0px;height:30px;'
  src='man/figures/kofi1.png' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>
<!-- badges: end -->

Modifies dot plots to have different sizes of dots mimicking violin
plots and identifies modes or peaks for them ([Rosenblatt,
1956](#ref-Rosenblatt1956); [Parzen, 1962](#ref-Parzen1962)).

dotsViolin, an R package ([R Core Team, 2023](#ref-R-base)) uses
gridExtra ([Auguie, 2017](#ref-R-gridExtra)), gtools ([Bolker *et al.*,
2022](#ref-R-gtools)), tidyr ([Wickham *et al.*, 2023c](#ref-R-tidyr)),
stringr ([Wickham, 2022](#ref-R-stringr)), dplyr ([Wickham *et al.*,
2023b](#ref-R-dplyr)), ggplot2 ([Wickham *et al.*,
2023a](#ref-R-ggplot2)), lazyeval ([Wickham, 2019](#ref-R-lazyeval)),
magrittr ([Bache and Wickham, 2022](#ref-R-magrittr)), rlang ([Henry and
Wickham, 2023](#ref-R-rlang)), scales ([Wickham and Seidel,
2022](#ref-R-scales)), tidyselect ([Henry and Wickham,
2022](#ref-R-tidyselect))

Documentation was written with R-packages roxygen2 ([Wickham *et al.*,
2022](#ref-R-roxygen2)), knitr ([Xie, 2023](#ref-R-knitr)), Rmarkdown
([Allaire *et al.*, 2023](#ref-R-rmarkdown)).

Academic presentation related ([Roa-Ovalle, 2019](#ref-Roa2019))

<!-- badger -->

## Installation

``` r
devtools::install_gitlab(repo = "ferroao/dotsViolin")
```

#### Releases

[News](https://gitlab.com/ferroao/dotsViolin/-/blob/master/NEWS.md)

## Citation

To cite package ‘dotsViolin’ in publications use:

Roa-Ovalle F, Telles M (2023). *dotsViolin: Integrated tables in dot and
violin R ggplots*. R package version 0.0.1,
<https://gitlab.com/ferroao/dotsViolin>.

To write citation to file:

``` r
sink("dotsViolin.bib")
toBibtex(citation("dotsViolin"))
sink()
```

## Authors

[Fernando Roa](https://ferroao.gitlab.io/curriculumpu/)  
[Mariana PC Telles](http://lattes.cnpq.br/4648436798023532)

## Plot window

Define your plotting window size with something like `par(pin=c(10,6))`,
or with `svg()`, `png()`, etc.

In VSCode, you could use something like this

``` yaml
{
  "r.plot.useHttpgd": false,
  "r.plot.devArgs": {
    "width": 800,
    "height": 600
  }
}
```

# Examples

#### 1 Discrete Data:

``` r
library(dotsViolin)

fabaceae_mode_counts <- get_modes_counts(fabaceae_clade_n_df, "clade", "parsed_n")
```

    fabaceae_mode_counts

| clade                 | m1  | m2   | m3  | count |
|:----------------------|:----|:-----|:----|:------|
| Caesalpinieae         | 12  | NA   | NA  | 29    |
| Cassieae              | 14  | 8    | 12  | 64    |
| Cercidoideae          | 14  | 7    | NA  | 33    |
| Detarioideae          | 12  | 8,17 | NA  | 50    |
| Dialioideae           | 14  | NA   | NA  | 6     |
| Dimorphandra and rel. | 14  | 13   | NA  | 16    |
| Mimosoids             | 13  | 26   | 14  | 221   |
| outgroup              | 8   | 12   | 11  | 145   |
| Papilionoideae        | 8   | 11   | 7   | 1410  |
| Umtiza and rel.       | 14  | NA   | NA  | 7     |

``` r
library(dotsViolin)

fabaceae_clade_n_df_count <- make_legend_with_stats(fabaceae_mode_counts, "label_count", 1, TRUE)
fabaceae_clade_n_df$label_count <- fabaceae_clade_n_df_count$label_count[match(
  fabaceae_clade_n_df$clade,
  fabaceae_clade_n_df_count$clade
)]
desiredorder1 <- unique(fabaceae_clade_n_df$clade)
```

    fabaceae_clade_n_df
                            tip.label          clade parsed_n
    1     KX374504_Abarema_centiflora      Mimosoids       13
    2   KX213142_Adenodolichos_bussei Papilionoideae       11
    3      KX792912_Almaleea_cambagei Papilionoideae        8
    4 KP109982_Amphithalea_cymbifolia Papilionoideae        9
    5 KP230727_Argyrolobium_tuberosum Papilionoideae       13
    6        GU220019_Ateleia_arsenii Papilionoideae       14
                                  label_count
    1 Mimosoids             13   26 14  (221)
    2 Papilionoideae         8   11  7 (1410)
    3 Papilionoideae         8   11  7 (1410)
    4 Papilionoideae         8   11  7 (1410)
    5 Papilionoideae         8   11  7 (1410)
    6 Papilionoideae         8   11  7 (1410)

``` r
par(mar = c(0, 0, 0, 0), omi = rep(0, 4))

dots_and_violin(
  fabaceae_clade_n_df, "clade", "label_count", "parsed_n", 2,
  30, "Chromosome haploid number", desiredorder1, 1, .85, 4,
  "ownwork",
  violin = FALSE
)
```

<img src="man/figures/README-unnamed-chunk-9-1.png" width="70%" />

``` r
par(mar = c(0, 0, 0, 0), omi = rep(0, 4))

dots_and_violin(
  fabaceae_clade_n_df, "clade", "label_count", "parsed_n", 2,
  30, "Chromosome haploid number", desiredorder1, 1, .85, 4,
  dots = FALSE
)
```

<img src="man/figures/README-unnamed-chunk-10-1.png" width="70%" />

``` r
par(mar = c(0, 0, 0, 0), omi = rep(0, 4))

dots_and_violin(
  fabaceae_clade_n_df, "clade", "label_count", "parsed_n", 2,
  30, "Chromosome haploid number", desiredorder1, 1, .85, 4
)
```

<img src="man/figures/README-unnamed-chunk-11-1.png" width="70%" />

#### 2 Continuous Data:

Define your plotting window size with something like `par(pin=c(10,6))`,
or with `svg()`, `png()`, etc.

``` r
library(dotsViolin)

fabaceae_Cx_peak_counts_per_clade_df <- get_peaks_counts_continuous(
  fabaceae_clade_1Cx_df,
  "clade", "Cx", 2, 0.25, 1, 2
)
```

    fabaceae_Cx_peak_counts_per_clade_df

|                     | clade               | m1             | m2        | counts |
|:--------------------|:--------------------|:---------------|:----------|-------:|
| Caesalpinieae       | Caesalpinieae       | 0.85,1.80      |           |      2 |
| Cassieae            | Cassieae            | 0.69           | 0.52,0.56 |      6 |
| Cercidoideae        | Cercidoideae        | 0.60           |           |      5 |
| COM clade           | COM clade           | 0.35,0.50,0.83 |           |      3 |
| Detarioideae        | Detarioideae        | 2.21           | 0.84,2.01 |      4 |
| Dimorphandra & rel. | Dimorphandra & rel. | 0.73,0.79      |           |      2 |
| Malvids             | Malvids             | 0.40           | 0.63      |      8 |
| Mimosoids           | Mimosoids           | 0.70           | 0.43      |     42 |
| outgroups           | outgroups           | 0.48           | 1.38,2.76 |      9 |
| Papilionoideae      | Papilionoideae      | 0.59           |           |    212 |
| Polygala amara      | Polygala amara      | 0.42           |           |      1 |
| Umtiza & rel.       | Umtiza & rel.       | 0.65,1.05      |           |      2 |
| Vitis vinifera      | Vitis vinifera      | 0.43           |           |      1 |

``` r
library(dotsViolin)

namecol <- "labelcountcustom"
fabaceae_clade_1Cx_modes_count_df <- make_legend_with_stats(
  fabaceae_Cx_peak_counts_per_clade_df,
  namecol, 1, TRUE
)
fabaceae_clade_1Cx_df$labelcountcustom <-
  fabaceae_clade_1Cx_modes_count_df$labelcountcustom[match(
    fabaceae_clade_1Cx_df$clade,
    fabaceae_clade_1Cx_modes_count_df$clade
  )]
desiredorder <- unique(fabaceae_clade_1Cx_df$clade)
```

    fabaceae_clade_1Cx_df
                                  name     clade     Cx      genus ownwork
    6      'Silene_latifolia_JF715055' outgroups 2.7000     Silene      no
    7  'Fagopyrum_esculentum_NC010776' outgroups 1.4350  Fagopyrum      no
    11    'Helianthus_annuus_NC007977' outgroups 2.4250 Helianthus      no
    12        'Daucus_carota_NC008325' outgroups 2.8375     Daucus      no
    14        'Olea_europaea_NC013707' outgroups 1.9500       Olea      no
    18       'Coffea_arabica_NC008535' outgroups 0.6000     Coffea      no
                                          labelcountcustom
    6  outgroups                     0.48 1.38,2.76    (9)
    7  outgroups                     0.48 1.38,2.76    (9)
    11 outgroups                     0.48 1.38,2.76    (9)
    12 outgroups                     0.48 1.38,2.76    (9)
    14 outgroups                     0.48 1.38,2.76    (9)
    18 outgroups                     0.48 1.38,2.76    (9)

``` r
par(mar = c(0, 0, 0, 0), omi = rep(0, 4))

dots_and_violin(
  fabaceae_clade_1Cx_df, "clade", "labelcountcustom", "Cx", 3,
  3, "Genome Size", desiredorder, 0.03, 0.25, 2,
  "ownwork"
)
```

<img src="man/figures/README-unnamed-chunk-16-1.png" width="70%" />

``` r
par(mar = c(0, 0, 0, 0), omi = rep(0, 4))

dots_and_violin(
  fabaceae_clade_1Cx_df, "clade", "labelcountcustom", "Cx", 3,
  3, "Genome Size", desiredorder, 0.03, 0.25, 2,
  dots = FALSE
)
```

<img src="man/figures/README-unnamed-chunk-17-1.png" width="70%" />

``` r
par(mar = c(0, 0, 0, 0), omi = rep(0, 4))

dots_and_violin(
  fabaceae_clade_1Cx_df, "clade", "labelcountcustom", "Cx", 3,
  3, "Genome Size", desiredorder, 0.03, 0.25, 2,
  "ownwork",
  violin = FALSE
)
```

<img src="man/figures/README-unnamed-chunk-18-1.png" width="70%" />

## References

## R-packages

<div id="refs_software" class="references csl-bib-body"
entry-spacing="1">

<div id="ref-R-rmarkdown" class="csl-entry">

Allaire J, Xie Y, Dervieux C, McPherson J, Luraschi J, Ushey K, Atkins
A, Wickham H, Cheng J, Chang W, Iannone R. 2023. *Rmarkdown: Dynamic
documents for r*. R package version 2.24.
<https://CRAN.R-project.org/package=rmarkdown>

</div>

<div id="ref-R-gridExtra" class="csl-entry">

Auguie B. 2017. *gridExtra: Miscellaneous functions for "grid"
graphics*. R package version 2.3.
<https://CRAN.R-project.org/package=gridExtra>

</div>

<div id="ref-R-magrittr" class="csl-entry">

Bache SM, Wickham H. 2022. *Magrittr: A forward-pipe operator for r*. R
package version 2.0.3. <https://CRAN.R-project.org/package=magrittr>

</div>

<div id="ref-R-gtools" class="csl-entry">

Bolker B, Warnes GR, Lumley T. 2022. *Gtools: Various r programming
tools*. R package version 3.9.4. <https://github.com/r-gregmisc/gtools>

</div>

<div id="ref-R-tidyselect" class="csl-entry">

Henry L, Wickham H. 2022. *Tidyselect: Select from a set of strings*. R
package version 1.2.0. <https://CRAN.R-project.org/package=tidyselect>

</div>

<div id="ref-R-rlang" class="csl-entry">

Henry L, Wickham H. 2023. *Rlang: Functions for base types and core r
and tidyverse features*. R package version 1.1.1.
<https://CRAN.R-project.org/package=rlang>

</div>

<div id="ref-R-base" class="csl-entry">

R Core Team. 2023. *R: A language and environment for statistical
computing* R Foundation for Statistical Computing, Vienna, Austria.
<https://www.R-project.org/>

</div>

<div id="ref-R-lazyeval" class="csl-entry">

Wickham H. 2019. *Lazyeval: Lazy (non-standard) evaluation*. R package
version 0.2.2. <https://CRAN.R-project.org/package=lazyeval>

</div>

<div id="ref-R-stringr" class="csl-entry">

Wickham H. 2022. *Stringr: Simple, consistent wrappers for common string
operations*. R package version 1.5.0.
<https://CRAN.R-project.org/package=stringr>

</div>

<div id="ref-R-ggplot2" class="csl-entry">

Wickham H, Chang W, Henry L, Pedersen TL, Takahashi K, Wilke C, Woo K,
Yutani H, Dunnington D. 2023a. *ggplot2: Create elegant data
visualisations using the grammar of graphics*. R package version 3.4.4.
<https://CRAN.R-project.org/package=ggplot2>

</div>

<div id="ref-R-roxygen2" class="csl-entry">

Wickham H, Danenberg P, Csárdi G, Eugster M. 2022. *roxygen2: In-line
documentation for r*. R package version 7.2.3.
<https://CRAN.R-project.org/package=roxygen2>

</div>

<div id="ref-R-dplyr" class="csl-entry">

Wickham H, François R, Henry L, Müller K, Vaughan D. 2023b. *Dplyr: A
grammar of data manipulation*. R package version 1.1.3.
<https://CRAN.R-project.org/package=dplyr>

</div>

<div id="ref-R-scales" class="csl-entry">

Wickham H, Seidel D. 2022. *Scales: Scale functions for visualization*.
R package version 1.2.1. <https://CRAN.R-project.org/package=scales>

</div>

<div id="ref-R-tidyr" class="csl-entry">

Wickham H, Vaughan D, Girlich M. 2023c. *Tidyr: Tidy messy data*. R
package version 1.3.0. <https://CRAN.R-project.org/package=tidyr>

</div>

<div id="ref-R-knitr" class="csl-entry">

Xie Y. 2023. *Knitr: A general-purpose package for dynamic report
generation in r*. R package version 1.43. <https://yihui.org/knitr/>

</div>

</div>

## Academia

<div id="refs_docs" class="references csl-bib-body" entry-spacing="1">

<div id="ref-Parzen1962" class="csl-entry">

Parzen E. 1962. On estimation of a probability density function and mode
*The Annals of Mathematical Statistics*, 33: 1065–1076.
<https://doi.org/10.1214/aoms/1177704472>

</div>

<div id="ref-Roa2019" class="csl-entry">

Roa-Ovalle F. 2019. Poliploidia e duplicação genômica nas leguminosas
brasileiras In: Rocha LL da (ed) Sociedade Botânica do Brasil.
<https://70cnbot.botanica.org.br/wp-content/uploads/2019/11/Livro-70%C2%BA-Congresso-Nacional-de-Bot%C3%A2nica..pdf>

</div>

<div id="ref-Rosenblatt1956" class="csl-entry">

Rosenblatt M. 1956. Remarks on some nonparametric estimates of a density
function *The Annals of Mathematical Statistics*, 27: 832–837.
<https://doi.org/10.1214/aoms/1177728190>

</div>

</div>
