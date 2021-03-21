# nat.utils
<!-- badges: start -->
[![natverse](https://img.shields.io/badge/natverse-Part%20of%20the%20natverse-a241b6)](https://natverse.github.io)
[![Docs](https://img.shields.io/badge/docs-100%25-brightgreen.svg)](https://natverse.github.io/nat.utils/reference/)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/nat.utils)](http://cran.r-project.org/web/packages/nat.utils) 
[![Downloads](http://cranlogs.r-pkg.org/badges/nat.utils?color=brightgreen)](http://www.r-pkg.org/pkg/nat.utils)
[![Release Version](https://img.shields.io/github/release/natverse/nat.utils.svg)](https://github.com/jefferis/nat.utils/releases/latest) 
[![R-CMD-check](https://github.com/natverse/nat.utils/workflows/R-CMD-check/badge.svg)](https://github.com/jefferis/nat.utils/actions)
[![Coverage Status](https://coveralls.io/repos/github/natverse/nat.utils/badge.svg)](https://coveralls.io/r/natverse/nat.utils?branch=master)
<!-- badges: end -->

An R package containing utility functions to support the NeuroAnatomy Toolbox (nat)

## Background
This package provides support functions for the [nat](https://github.com/natverse/nat)
NeuroAnatomy Toolbox package. Some functions may nevertheless be of general 
interest. See the [reference manual](http://cran.r-project.org/web/packages/nat.utils/nat.utils.pdf) 
on [CRAN](http://cran.r-project.org/web/packages/nat.utils/) for a for full function listing.

## Installation

### Released versions
From [CRAN](http://cran.r-project.org/web/packages/nat.utils/)- the recommended
option for simplicity and since this package is not under heavy development:

```r
install.packages("nat.utils")
```

### Bleeding Edge
Straight from github with Hadley Wickham's [devtools](https://github.com/hadley/devtools) package:

```r
if(!require("remotes")) install.packages("remotes")
remotes::install_github('natverse/nat.utils')
```
Note: Windows users need [Rtools](http://www.murdoch-sutherland.com/Rtools/) to
install in this way.
