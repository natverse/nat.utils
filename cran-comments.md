# nat.utils 0.5.1
This update fixes a bug in gzip.crc on big endian plaforms revealared by a test 
error on Solaris Sparc for nat 0.5.0 noted by Brian Ripley.

  http://cran.r-project.org/web/checks/check_results_nat.utils.html

## Test environments
* local OS X install, R 3.2.1
* ubuntu 12.04 (on travis-ci), R 3.2.1
* winbuilder (devel and release)

## R CMD check results
There were no ERRORs or WARNINGs on any platform.

winbuilder devel reported the following NOTE

  http://win-builder.r-project.org/8YUZnybzk4fu/00check.log

Possibly mis-spelled words in DESCRIPTION:
  timestamp (10:5)

* timestamp appears to be a valid spelling

The Title field should be in title case, current version then in title case:
'File System Utility Functions for 'NeuroAnatomy Toolbox''
'File System Utility Functions for 'Neuroanatomy Toolbox''

* 'NeuroAnatomy Toolbox' is flagged in spite of the quotes. It is the full name
of CRAN package 'nat'.

## Downstream dependencies
I have also run R CMD check on downstream dependencies of nat. All packages 
passed.
