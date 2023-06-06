# nat.utils 0.6.1
This updates fixes a function signature containing a T value and completely
removes a function marked as defunct that did not have a documented return value.

Of note v0.6.0 fixed a test error in v0.5.1 (the last version on CRAN) due to
changes in the behaviour of normalizePath on Windows. See

  http://cran.r-project.org/web/checks/check_results_nat.utils.html

Failure to address this resulted in the package (and strong reverse
dependencies nat, nat.templatebrains and nat.nblast being archived).

## Test environments
* local OS X install, R 4.3.0
* ubuntu 20.04 (on github actions), R 4.3.0
* winbuilder (devel and release)

## R CMD check results
There were no ERRORs or WARNINGs on any platform.

winbuilder devel reported the following NOTE relating to the archiving of the 
package:

  https://win-builder.r-project.org/gzOq24R3P337/00check.log

Package was archived on CRAN

CRAN repository db overrides:
  X-CRAN-Comment: Archived on 2023-06-05 as issues were not corrected
    in time.
