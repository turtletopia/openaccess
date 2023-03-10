
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
devtools::install_github("turtletopia/openaccess")
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
site <- rvest::read_html("https://academic.oup.com/nar/article/51/D1/D352/6761729")
is_open_access(site)
#> [1] TRUE
```

Some sites require prior configuration of Selenium remote driver.

``` r
# Settings must match your local setup
start_remote_driver(port = 4567, browserName = "firefox")
#> Starting a new remote driver...
is_open_access("10.1073/pnas.211412398")
#> [1] FALSE
```

## Verified journals

The following journals were validated against the solution and split
into two groups: supported and unsupported. Any journal not specified
here is not supported either, although with the lack of support coming
from not having evaluated the journal yet instead of objective
obstacles.

### Supported sources

-   [Academic
    Press](https://www.elsevier.com/books-and-journals/academic-press)
-   [ACS Publications](https://pubs.acs.org)
-   [Analytical Science
    Journals](https://analyticalsciencejournals.onlinelibrary.wiley.com)
-   [BioMed Central](https://www.biomedcentral.com)
-   [Biophysical
    Journal](https://www.sciencedirect.com/journal/biophysical-journal)
-   [Cambridge Core](https://www.cambridge.org/core/)
-   [Cell Reports](https://www.cell.com/cell-reports/home)
-   [eLife](https://elifesciences.org)
-   [Elsevier](https://www.elsevier.com)
-   [FEBS Press](https://febs.onlinelibrary.wiley.com)
-   [Frontiers](https://www.frontiersin.org)
-   [Hindawi](https://www.hindawi.com)
-   [Journal of Biological Chemistry](https://www.jbc.org)
-   [Journal of Neuroscience](https://www.jneurosci.org)
-   [MDPI](https://www.mdpi.com)
-   [Molecular Cell](https://www.cell.com/molecular-cell/home)
-   [Nature](https://www.nature.com)
-   [OUP Academic](https://academic.oup.com)
-   [PeerJ](https://peerj.com)
-   Pergamon
-   [PLOS ONE](https://journals.plos.org/plosone/)
-   [PNAS](https://www.pnas.org)
-   [Portland Press](https://portlandpress.com)
-   [The Royal Society of Chemistry](https://www.rsc.org)
-   [Science](https://www.science.org)
-   [SpringerLink](https://link.springer.com)
-   [Taylor & Francis](https://www.tandfonline.com)
-   [Wiley Online Library](https://onlinelibrary.wiley.com)

### (Confirmed) unsupported sources

Currently all verified sources are supported.

## End notes

I believe in equal rights and treatment for everybody, regardless of
their sexuality, gender identity, skin tone, nationality, and other
features beyond human control. Thus, I do not allow openaccess to be
used in any project that promotes hate based on the aforementioned
factors.
