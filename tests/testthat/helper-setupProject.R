
setupProjectTest <- function(
    projectName,
    times,
    modules     = moduleName,
    projectPath = getwd(),
    modulePath  = file.path(tempDir, "modules"),
    inputPath   = file.path(tempDir, "inputs"),
    cachePath   = file.path(tempDir, "cache"),
    outputPath  = file.path(tempDir, "outputs", projectName),
    packagePath = Sys.getenv("R_LIBS_USER"),
    ...){

  # Get module directory and name
  moduleDir  <- normalizePath(test_path("../.."), winslash = "/")
  moduleName <- basename(moduleDir)

  # Set temporary directory
  tempDir <- file.path(tempdir(), paste0("testthat-", moduleName))
  if (testthat::is_testing()) withr::defer(
    unlink(tempDir, recursive = TRUE),
    envir = testthat::teardown_env(), priority = "last")

  # Set module path
  if (!testthat::is_testing() & identical(modules, moduleName)){
    modulePath <- dirname(moduleDir) # Test module in place
  }else{
    if (!file.exists(file.path(modulePath, moduleName))){
      dir.create(modulePath, recursive = TRUE, showWarnings = FALSE)
      file.copy(moduleDir, modulePath, recursive = TRUE)
    }
  }

  # Set up project
  simInitInput <- SpaDES.project::setupProject(
    Restart = FALSE,
    updateRprofile = FALSE,
    modules = modules,
    times = times,
    paths = list(
      projectPath = projectPath,
      modulePath  = modulePath,
      packagePath = packagePath,
      inputPath   = inputPath,
      cachePath   = cachePath,
      outputPath  = outputPath,
      testdata    = testthat::test_path("testdata")
    ),
    options = list(
      spades.useRequire = !identical(modules, moduleName)
    )
  )
  simInitInput <- c(simInitInput, list(...))
  return(simInitInput)
}

