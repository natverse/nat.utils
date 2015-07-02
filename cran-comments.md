## Test environments
* local OS X install, R 3.2.1
* ubuntu 12.04 (on travis-ci), R 3.2.1
* winbuilder (devel and release)

## R CMD check results
There were no ERRORs or WARNINGs on any platform.

winbuilder release reported the following NOTE

http://win-builder.r-project.org/S5289h1Fn4JY/00check.log

Possibly mis-spelled words in DESCRIPTION:
  nat (8:59)
  timestamp (10:5)

* nat is flagged even though it is quoted and should be ignored.
* timestamp appears to be a valid spelling

The Title field should be in title case, current version then in title case:
'File System Utility Functions for 'NeuroAnatomy Toolbox''
'File System Utility Functions for 'Neuroanatomy Toolbox''

* 'NeuroAnatomy Toolbox' is flagged in spite of the quotes.

## Downstream dependencies
I have also run R CMD check on downstream dependencies of nat. All packages 
passed.
