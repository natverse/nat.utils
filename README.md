# nat.utils

An R package containing utility functions to support the NeuroAnatomy Toolbox (nat)

## Background
This package is part of a primarily R based toolbox for neuroanatomy that has been in continuous development since 2002. Originally a loosely organised collection of R functions and scripts, I am now transitioning some of the code that may be of more general use to formal R packages. As one of the smaller sets of code with minimal dependencies, these utility functions are the first group of functions to be converted.

The main code base is at https://github.com/jefferis/AnalysisSuite.

In the fullness of time, I expect there to be a `nat` package which collects together a number of sub-packages called `nat.*`

## Installation

### Released versions
    install.packages("nat.utils",repos='http://jefferislab.org/R',type='source')
### Bleeding Edge
Straight from github with Hadley Wickham's [devtools](https://github.com/hadley/devtools) package:

    install.packages("devtools")
    library(devtools)
    install_github('nat.utils','jefferis')
