#' Construct paths to files in the extdata folder of a package
#'
#' @details \code{inst/extdata} is the conventional place to store data this is
#'   not managed directly by the standard R package mechanisms. Unfortunately
#'   its location changes at different stages of the package build/load process,
#'   since in the final package all folders under \code{inst} are installed
#'   directly under the package root.
#'
#' @param ... components of the path (eventually appended to location of
#'   \code{extdata})
#' @param package The package to search
#' @param firstpath A hint for the first place to look
#'
#' @return A character vector containing the constructed path
#' @export
#' @importFrom utils file_test
#' @examples
#' find_extdata(package='nat.utils')
find_extdata <- function(..., package=NULL, firstpath=file.path("inst","extdata")) {
  p <- firstpath
  if (!file_test('-d', p)) {
    p <- try(system.file('extdata',
                         package = package,
                         mustWork = T),
             silent = T)
    if(inherits(p, 'try-error'))
      stop("Cannot find extdata in local file hierarchy or installed package!")
  }
  file.path(p, ...)
}

#' Make a neuronlist object from two separate files
#'
#' @param datapath Path to the data object
#' @param dfpath Path to the data.frame object
#' @param extdata_package Character vector naming a package whose extdata
#'   directory will be sought (with \code{\link{find_extdata}}) and prepended to
#'   the two input paths.
#' @param ... Additional arguments passd to \code{\link{find_extdata}}
#' @return a \code{neuronlist} object
#' @export
make_nl_from_parts <- function(datapath, dfpath, extdata_package=NULL, ...) {
  if(!is.null(extdata_package)) {
    datapath <- find_extdata(datapath, package=extdata_package, ...)
    dfpath <- find_extdata(dfpath, package=extdata_package, ...)
  }
  x <- readRDS(datapath)
  df <- readRDS(dfpath)
  attr(x, 'df') <- df
  x
}
