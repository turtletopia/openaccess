
<!-- README.md is generated from README.Rmd. Please edit that file -->

# openaccess

<!-- badges: start -->
<!-- badges: end -->

openaccess provides a simple check of [open
access](https://en.wikipedia.org/wiki/Open_access) for scientific
papers. The only data required is a DOI. The list of supported journals
grows steadily, see below for the current list of verified sources.

## Installation

You can install the development version of openaccess from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ErdaradunGaztea/openaccess")
```

## How to use

You’d most often check the open access status by passing the DOI.

``` r
library(openaccess)
is_open_access("10.1093/nar/gkac882")
#> [1] TRUE
```

However, if you already have a HTML content, there’s no point in
extracting the DOI to download the site again.

``` r
rvest::read_html("https://academic.oup.com/nar/article/51/D1/D352/6761729") %>%
  is_open_access()
#> [1] TRUE
```

## Verified journals

The following journals were validated against the solution and split
into two groups: supported and unsupported (at least for the time
being).

### Supported sources

-   [Academic
    Press](https://www.elsevier.com/books-and-journals/academic-press)
-   [Biophysical
    Journal](https://www.sciencedirect.com/journal/biophysical-journal)
-   [eLife](https://elifesciences.org)
-   [Elsevier](https://www.elsevier.com)
-   [Frontiers](https://www.frontiersin.org)
-   [Journal of Biological Chemistry](https://www.jbc.org)
-   [Journal of Neuroscience](https://www.jneurosci.org)
-   [MDPI](https://www.mdpi.com)
-   [Nature](https://www.nature.com)
-   [OUP Academic](https://academic.oup.com)
-   [PLOS ONE](https://journals.plos.org/plosone/)
-   [PNAS](https://www.pnas.org)
-   [Portland Press](https://portlandpress.com)
-   [The Royal Society of Chemistry](https://www.rsc.org)
-   [SpringerLink](https://link.springer.com)

### (Confirmed) unsupported sources

The following sites return 403 or 503 code upon accessing; hopefully a
workaround will be implemented in the future versions of openaccess.

## End notes

I believe in equal rights and treatment for everybody, regardless of
their sexuality, gender identity, skin tone, nationality, and other
features beyond human control. Thus, I do not allow openaccess to be
used in any project that promotes hate based on the aforementioned
factors.
