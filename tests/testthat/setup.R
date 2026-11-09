
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
tempDir <- file.path(tempdir(), "testthat-module")
if (is_testing()) withr::defer(
  unlink(tempDir, recursive = TRUE),
  envir = teardown_env(), priority = "last")

#cat("GITHUB_REF:",      Sys.getenv("GITHUB_REF"), "\n") # source branch
cat("GITHUB_REF_NAME:", Sys.getenv("GITHUB_REF_NAME"), "\n") # source branch
cat("GITHUB_HEAD_REF:", Sys.getenv("GITHUB_HEAD_REF"), "\n") # source branch of PR
cat("GITHUB_BASE_REF:", Sys.getenv("GITHUB_BASE_REF"), "\n") # target branch of PR
cat("GITHUB_BASE_REF class:", class(Sys.getenv("GITHUB_BASE_REF")), "\n") # target branch of PR
cat("\n\n")

cat("SKIP TESTS:", isTRUE(as.logical(Sys.getenv("CI"))) & !"main" %in% Sys.getenv(c("GITHUB_BASE_REF", "GITHUB_REF_NAME")), "\n")
cat("TEST BRANCH: ", Sys.getenv("GITHUB_BASE_REF", Sys.getenv("GITHUB_REF_NAME", "development")), "\n")
cat("TEST BRANCH: ", na.omit(c(Sys.getenv(c("GITHUB_BASE_REF", "GITHUB_REF_NAME"), unset = NA), "development"))[[1]], "\n")
cat("TEST BRANCH: ", setdiff(c(Sys.getenv(c("GITHUB_BASE_REF", "GITHUB_REF_NAME"), unset = ""), "development"), "")[[1]], "\n")
cat("\n\n")

# Install SpaDES.project
cat("INSTALLING SPADES.PROJECT!\n")
Require::Install("SpaDES.project", repos = "predictiveecology.r-universe.dev")

# Authorize Google Drive
cat("TRYING TO AUTH GOOGLE DRIVE!\n")
#cat("GOOGLE_AUTH: ", Sys.getenv("GOOGLE_AUTH"), "\n")
cat("LIBPATHS: \n", .libPaths(), "\n\n\n")
if (Sys.getenv("GOOGLE_AUTH") == "") stop()
if (Sys.getenv("GOOGLE_AUTH") != ""){
  cat("installing gd!\n\n")
  Require::Install("googledrive")
  googledrive::drive_auth(path = Sys.getenv("GOOGLE_AUTH"))
}

