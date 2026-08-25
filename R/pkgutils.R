#' Check that a suggested package is available, with install instructions
#'
#' @description \code{check_package_available} checks whether a package can be
#'   loaded and, if not, stops with a clearly formatted message telling the user
#'   how to install it. Use it to guard code paths that depend on packages
#'   listed under \code{Suggests}.
#'
#' @details The install command is chosen to match the package's source (given
#'   by \code{repo}) and the best installation tool already available in the
#'   user's library:
#'
#'   \itemize{
#'
#'   \item \strong{CRAN} (\code{repo=NULL}, the default): \code{pak} if
#'   available, otherwise \code{utils::install.packages}.
#'
#'   \item \strong{GitHub} (\code{repo} is an \code{"org/repo"} string):
#'   \code{natmanager} if available (it transparently handles GitHub remotes and
#'   authentication), otherwise \code{pak}, otherwise
#'   \code{remotes::install_github}.
#'
#'   \item \strong{Bioconductor} (\code{repo="Bioconductor"} or \code{"bioc"}):
#'   \code{pak} if available, otherwise \code{BiocManager}. If neither is
#'   installed the suggested command installs \code{BiocManager} first and a note
#'   flags that extra step.
#'
#'   \item \strong{r-universe} (\code{repo} is a universe URL such as
#'   \code{"https://natverse.r-universe.dev"}):
#'   \code{utils::install.packages} pointed at that repository.
#'
#'   }
#'
#'   When the \pkg{cli} package is available (almost always the case) the install
#'   command is shown as a clickable hyperlink in the RStudio console and other
#'   supporting terminals; otherwise a plain-text message is used.
#'
#' @param package Name of the package to check (a single string).
#' @param repo Optional install source: \code{NULL} (CRAN, the default), a
#'   GitHub \code{"org/repo"} string, \code{"Bioconductor"}, or an r-universe URL
#'   (e.g. \code{"https://natverse.r-universe.dev"}). See \bold{Details}.
#' @param error Whether to raise an error when the package is missing (default
#'   \code{TRUE}). When \code{FALSE} the function returns \code{FALSE} invisibly
#'   instead, so it can be used as a plain availability test.
#' @return \code{TRUE} invisibly when the package is available, or \code{FALSE}
#'   invisibly when it is missing and \code{error=FALSE}. Otherwise an error is
#'   raised.
#' @export
#' @examples
#' \dontrun{
#' # CRAN package (the default)
#' check_package_available("arrow")
#'
#' # GitHub package: pass the "org/repo" spec as `repo`
#' check_package_available("hemibrainr", repo = "flyconnectome/hemibrainr")
#'
#' # Bioconductor package
#' check_package_available("Rgraphviz", repo = "Bioconductor")
#'
#' # r-universe: pass the universe URL as `repo`
#' check_package_available("nat.nblast", repo = "https://natverse.r-universe.dev")
#'
#' # Use as a silent availability test rather than an error
#' if (check_package_available("arrow", error = FALSE)) {
#'   # ... code that needs arrow ...
#' }
#' }
check_package_available <- function(package, repo = NULL, error = TRUE) {
  if (requireNamespace(package, quietly = TRUE))
    return(invisible(TRUE))
  if (!isTRUE(error))
    return(invisible(FALSE))

  ic <- install_command(package, repo)
  if (requireNamespace("cli", quietly = TRUE)) {
    msg <- c(
      "The {.pkg {package}} package is required but not installed.",
      i = "Install it with {.run {ic$cmd}}"
    )
    if (!is.null(ic$note))
      msg <- c(msg, i = ic$note)
    cli::cli_abort(msg, call = NULL)
  } else {
    note <- if (!is.null(ic$note)) paste0("\n  Note: ", ic$note) else ""
    stop("The '", package, "' package is required but not installed.\n",
         "  Install it with:  ", ic$cmd, note, call. = FALSE)
  }
}

# Build the best install command for a package given its source (`repo`).
# Returns a list with `cmd` (the command string) and optional `note` (plain
# text flagging anything the user should know, e.g. an extra prerequisite
# install). `available` is the predicate used to decide which install tool is
# present; injectable so tests can exercise each branch deterministically.
# Not exported.
install_command <- function(package, repo = NULL,
                            available = function(p) requireNamespace(p, quietly = TRUE)) {
  source <- if (is.null(repo) || identical(toupper(repo), "CRAN")) "cran"
    else if (grepl("^https?://", repo))                    "universe"
    else if (grepl("/", repo, fixed = TRUE))               "github"
    else if (tolower(repo) %in% c("bioc", "bioconductor")) "bioc"
    else "cran"

  has <- available

  switch(source,
    github = list(cmd = if (has("natmanager"))
        sprintf('natmanager::install(pkgs = "%s")', repo)
      else if (has("pak"))
        sprintf('pak::pkg_install("%s")', repo)
      else
        sprintf('remotes::install_github("%s")', repo)),

    bioc = if (has("pak"))
        list(cmd = sprintf('pak::pkg_install("bioc::%s")', package))
      else if (has("BiocManager"))
        list(cmd = sprintf('BiocManager::install("%s")', package))
      else
        list(cmd = sprintf('install.packages("BiocManager"); BiocManager::install("%s")',
                           package),
             note = "This also installs the BiocManager package first."),

    universe = list(cmd = sprintf(
        "install.packages('%s', repos = c('%s', getOption('repos')))",
        package, repo)),

    cran = list(cmd = if (has("pak"))
        sprintf('pak::pkg_install("%s")', package)
      else
        sprintf('install.packages("%s")', package))
  )
}
