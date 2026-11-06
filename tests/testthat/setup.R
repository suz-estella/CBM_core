
if (!testthat::is_testing()){
  suppressPackageStartupMessages(library(testthat))
  testthat::source_test_helpers(env = globalenv())
}

# # Set module directory and name
# moduleDir  <- normalizePath(test_path("../.."), winslash = "/")
# moduleName <- basename(moduleDir)

# Source module functions
if (!as.logical(Sys.getenv("CI", FALSE))){

  moduleDir  <- normalizePath(test_path("../.."), winslash = "/")
  moduleName <- basename(moduleDir)

  lapply(list.files(file.path(moduleDir, "R"), pattern = "\\.R$", full.names = TRUE), source)
  for (e in parse(file.path(moduleDir, paste0(moduleName, ".R")))){
    if (is.call(e) && identical(e[[1]], as.name("<-")) && is.name(e[[2]])) eval(e)
  }
}

# Set temporary output directory
#tempDir <- tempfile(moduleName)
tempDir <- tempfile("testthat-")
if (is_testing()) withr::defer(
  unlink(tempDir, recursive = TRUE),
  envir = teardown_env(), priority = "last")

# Install SpaDES.project
Require::Install("SpaDES.project", repos = "predictiveecology.r-universe.dev")

# Authorize Google Drive
if (Sys.getenv("GOOGLE_AUTH") != ""){
  Require::Install("googledrive")
  googledrive::drive_auth(path = Sys.getenv("GOOGLE_AUTH"))
}

