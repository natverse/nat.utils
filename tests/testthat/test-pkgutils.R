test_that("check_package_available returns TRUE for installed packages", {
  expect_true(check_package_available("utils"))
  expect_true(check_package_available("utils", error = FALSE))
})

test_that("check_package_available errors for missing packages", {
  expect_error(check_package_available("nosuchpkg12345"))
  expect_false(check_package_available("nosuchpkg12345", error = FALSE))
})

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

test_that("bioc install advice matches available tooling", {
  res <- install_command("Rgraphviz", repo = "Bioconductor")
  have_pak <- requireNamespace("pak", quietly = TRUE)
  have_bioc <- requireNamespace("BiocManager", quietly = TRUE)
  if (have_pak) {
    expect_match(res$cmd, "pak::pkg_install", fixed = TRUE)
    expect_null(res$note)
  } else if (have_bioc) {
    expect_match(res$cmd, "BiocManager::install", fixed = TRUE)
    expect_null(res$note)
  } else {
    # neither installer present: command bootstraps BiocManager and flags it
    expect_match(res$cmd, "install.packages(\"BiocManager\")", fixed = TRUE)
    expect_false(is.null(res$note))
  }
})
