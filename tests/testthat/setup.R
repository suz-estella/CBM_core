
if (!testthat::is_testing()){
  suppressPackageStartupMessages(library(testthat))
  testthat::source_test_helpers(env = globalenv())
}

# Set temporary output directory
tempDir <- file.path(tempdir(), "testthat-module")
if (is_testing()) withr::defer(
  unlink(tempDir, recursive = TRUE),
  envir = teardown_env(), priority = "last")

cat("spades.useRequire: ", getOption("spades.useRequire"), "\n")
cat("SPADES_USE_REQUIRE: ", Sys.getenv("SPADES_USE_REQUIRE"), "\n")

if (isTRUE(as.logical(Sys.getenv("CI")))){

  # Install SpaDES.project
  Require::Install("SpaDES.project", repos = "predictiveecology.r-universe.dev")

  # Install and authorize Google Drive
  if (Sys.getenv("GOOGLE_AUTH") != ""){
    Require::Install("googledrive")
    googledrive::drive_auth(path = Sys.getenv("GOOGLE_AUTH"))
  }

  # # Install exactextractr
  # Require::Install("exactextractr")

}else{

  # Source module functions
  moduleDir  <- normalizePath(test_path("../.."), winslash = "/")
  moduleName <- basename(moduleDir)

  lapply(list.files(file.path(moduleDir, "R"), pattern = "\\.R$", full.names = TRUE), source)
  for (e in parse(file.path(moduleDir, paste0(moduleName, ".R")))){
    if (is.call(e) && identical(e[[1]], as.name("<-")) && is.name(e[[2]])) eval(e)
  }
}

