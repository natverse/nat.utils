test_that("check_package_available returns TRUE for installed packages", {
  expect_true(check_package_available("utils"))
  expect_true(check_package_available("utils", error = FALSE))
})

test_that("check_package_available errors for missing packages", {
  expect_error(check_package_available("nosuchpkg12345"))
  expect_false(check_package_available("nosuchpkg12345", error = FALSE))
})

# helpers to force a particular set of install tools to be "available"
none <- function(p) FALSE
only <- function(...) {
  pkgs <- c(...)
  function(p) p %in% pkgs
}

test_that("install_command picks the right source", {
  # CRAN (no repo) -> pak or install.packages, always naming the package
  expect_match(install_command("arrow")$cmd, "arrow")
  expect_match(install_command("arrow", repo = "CRAN")$cmd, "arrow")

  # GitHub org/repo
  gh <- install_command("hemibrainr", repo = "flyconnectome/hemibrainr")$cmd
  expect_match(gh, "flyconnectome/hemibrainr", fixed = TRUE)
  expect_match(gh, "natmanager|pak|remotes")

  # Bioconductor
  bioc <- install_command("Rgraphviz", repo = "Bioconductor")
  expect_match(bioc$cmd, "Rgraphviz")
  expect_match(bioc$cmd, "pak|BiocManager")

  # r-universe URL
  uni <- install_command("nat.nblast", repo = "https://natverse.r-universe.dev")$cmd
  expect_match(uni, "install.packages", fixed = TRUE)
  expect_match(uni, "natverse.r-universe.dev", fixed = TRUE)
  expect_match(uni, "getOption('repos')", fixed = TRUE)
})

test_that("GitHub tool preference is natmanager > pak > remotes", {
  spec <- "flyconnectome/hemibrainr"
  expect_match(install_command("hemibrainr", spec, only("natmanager", "pak"))$cmd,
               "natmanager::install", fixed = TRUE)
  expect_match(install_command("hemibrainr", spec, only("pak"))$cmd,
               "pak::pkg_install", fixed = TRUE)
  expect_match(install_command("hemibrainr", spec, none)$cmd,
               "remotes::install_github", fixed = TRUE)
})

test_that("Bioc tool preference is pak > BiocManager, with a note when neither", {
  expect_match(install_command("Rgraphviz", "Bioconductor", only("pak", "BiocManager"))$cmd,
               "pak::pkg_install(\"bioc::Rgraphviz\")", fixed = TRUE)
  expect_match(install_command("Rgraphviz", "Bioconductor", only("BiocManager"))$cmd,
               "BiocManager::install", fixed = TRUE)
  res <- install_command("Rgraphviz", "Bioconductor", none)
  expect_match(res$cmd, "install.packages(\"BiocManager\")", fixed = TRUE)
  expect_false(is.null(res$note))
})

test_that("CRAN uses pak when available, else install.packages", {
  expect_match(install_command("arrow", available = only("pak"))$cmd,
               "pak::pkg_install(\"arrow\")", fixed = TRUE)
  expect_match(install_command("arrow", available = none)$cmd,
               "install.packages(\"arrow\")", fixed = TRUE)
})
