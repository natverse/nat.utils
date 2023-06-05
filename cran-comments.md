# nat.utils 0.6
This update fixes a test error in v0.5.1 due to changes in the behaviour of
normalizePath on Windows. See

  http://cran.r-project.org/web/checks/check_results_nat.utils.html

## Test environments
* local OS X install, R 4.2.3
* ubuntu 20.04 (on github actions), R 4.3
* winbuilder (devel and release)

## R CMD check results
There were no ERRORs or WARNINGs on any platform.

winbuilder devel reported the following NOTE relating to the archiving of the 
package:

  https://win-builder.r-project.org/9A0IbtenSosU/00check.log

Package was archived on CRAN

CRAN repository db overrides:
  X-CRAN-Comment: Archived on 2023-06-05 as issues were not corrected
    in time.
