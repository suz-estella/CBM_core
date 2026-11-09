
if (!testthat::is_testing()) source(testthat::test_path("setup.R"))

test_that("Multi module: SK-small 1985-1986", {

  ## Run simInit and spades ----

  skip_if(isTRUE(as.logical(Sys.getenv("CI"))) & !"main" %in% Sys.getenv(c("GITHUB_BASE_REF", "GITHUB_REF_NAME")))

  # Set up project
  simInitInput <- setupProjectTest(
    projectName = "integration_SK-small_1985-1986",
    times       = list(start = 1985, end = 1986),
    modules     = c(
      paste0("PredictiveEcology/CBM_defaults@",    Sys.getenv("GITHUB_BASE_REF", Sys.getenv("GITHUB_REF_NAME", "development"))),
      paste0("PredictiveEcology/CBM_dataPrep_SK@", Sys.getenv("GITHUB_BASE_REF", Sys.getenv("GITHUB_REF_NAME", "development"))),
      paste0("PredictiveEcology/CBM_dataPrep@",    Sys.getenv("GITHUB_BASE_REF", Sys.getenv("GITHUB_REF_NAME", "development"))),
      paste0("PredictiveEcology/CBM_vol2biomass@", Sys.getenv("GITHUB_BASE_REF", Sys.getenv("GITHUB_REF_NAME", "development"))),
      "CBM_core"
    ),

    params = list(.globals = list(.plots = NA)),

    masterRaster = terra::rast(
      ext  = c(xmin = -687696, xmax = -681036, ymin = 711955, ymax = 716183),
      res  = 30,
      vals = 0L,
      crs  = "EPSG:3979"
    )
  )

  cat("LIBPATHS: \n", .libPaths(), "\n\n\n")

  # Run simInit
  simTestInit <- suppressWarnings(SpaDES.core::simInit2(simInitInput))
  expect_s4_class(simTestInit, "simList")

  # Run spades
  simTest <- suppressWarnings(SpaDES.core::spades(simTestInit))
  expect_s4_class(simTest, "simList")

  # Check outputs
  expect_true(!is.null(simTest$emissionsProducts))

})


