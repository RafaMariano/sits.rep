sits_train <- function (data.tb, ml_method = sits::sits_svm())
{

  train <- NULL
  if (!dir.exists("train"))
    dir.create("train")

  seed <- jsonlite::fromJSON(sits.rep.env$config$METADATA_BASE_NAME)$seed

  model_args <- ls(environment(ml_method))
  model_args <- model_args[!model_args %in% c("result", "result_fun", "...")]

  if(.is_model(model_args, sits::sits_deeplearning)){

    # TODO - Definir uma semente aleatória, salvar no metadado e pegar ela antes de seta
    # no keras e svn
    keras::use_session_with_seed(seed)

    train <- sits::sits_train(data.tb, ml_method = ml_method)

    sits::sits_save_keras(train, "train/model.h5", "train/model.rds")

    # keras::use_session_with_seed(42, disable_gpu = FALSE, disable_parallel_cpu = FALSE)
    # train <- sits::sits_load_keras("train/model.h5", "train/model.rds")
    # device_lib.list_local_devices()
  }
  else{

      set.seed(seed)
      train <- sits::sits_train(data.tb, ml_method = ml_method)
      base::saveRDS(train, file = "train/model.rds")

  }
  # else if (.is_model(model_args, sits::sits_svm)){
  #
  #   set.seed(42)
  #   print("a")
  #   train <- sits::sits_train(data.tb, ml_method = ml_method)
  #   print("b")
  #   e1071::write.svm(train, svm.file = "train/model.svm", scale.file = "train/svm.scale",
  #                    yscale.file = "train/svm.yscale")
  #
  #   # write.svm(object, svm.file = "Rdata.svm",
  #   #           scale.file = "Rdata.scale", yscale.file = "Rdata.yscale")
  #
  # }
  #   return("sits_svm")

  json_save(list(train = list(directory = "train", file = "model.rds")))
  return(train)

}


sits_coverage <- function (service = "RASTER", name, timeline = NULL, bands = NULL,
                           missing_values = NULL, scale_factors = NULL, minimum_values = NULL,
                           maximum_values = NULL, files = NA, tiles_names = NULL, geom = NULL,
                           from = NULL, to = NULL)
{

  if(dir.exists("coverage"))
    unlink("coverage", recursive = TRUE)

  dir.create("coverage/geom", recursive = TRUE)

  if (is.character(geom))
    geom <- sf::read_sf(geom)

  layer <- "geom"
  sf::write_sf(geom, dsn = "coverage/geom", layer = layer, driver = "ESRI Shapefile",
               delete_layer = TRUE, delete_dsn = TRUE)

  json <- list(coverage = list(directory = "coverage",
                               service = service,
                               name = name,
                               timeline = timeline,
                               geom = paste0("geom/", layer, ".shp")))

  json_save(json)
  return(sits::sits_coverage(service, name, timeline, bands,
                             missing_values, scale_factors, minimum_values,
                             maximum_values, files, tiles_names, geom,
                             from, to))
  ##pegar o intervalo
}


# sits_classify_cubes <- function (file = NULL, coverage = NULL, ml_model = NULL, interval = "12 month",
#                                  filter = NULL, memsize = 4, multicores = NULL)
# {
#
#   if (!dir.exists("result") || !dir.exists("result/raster"))
#     dir.create("result/raster", recursive = TRUE)
#
#
#   path <- paste0(sits.rep.env$config$DIR_PRINCIPAL, sep = "/", get_tree(), sep = "/", "classification")
#   path <- paste0(dirname(path), sep = "/", "classification")
#
#   rasters.tb <- sits::sits_classify_cubes(file = paste0(path, sep = "/", "result/raster", sep = "/", base::basename(file)),
#                                           coverage = coverage,
#                                           ml_model = ml_model, interval = interval,
#                                           filter = filter, memsize = memsize,
#                                           multicores = multicores)
#
#   rds_path <- paste0("result", sep = "/", "rds")
#   if (!dir.exists(rds_path))
#     dir.create(rds_path, recursive = TRUE)
#
#   base::saveRDS(list(rasters.tb = rasters.tb),
#                 file = paste0(rds_path, sep = "/", "classify_cubes.rds"))
#
#   json <- list(classification = list(param = list(interval = interval, filter = filter,
#                                                   memsize = memsize, multicores = multicores)),
#                result = list(raster = paste0("result", sep = "/", "raster"),
#                              rds = paste0(rds_path, sep = "/", "classify_cubes.rds")))
#
#
#   json_save(json)
#   return(rasters.tb)
# }

sits_classify_cubes <- function (file = NULL, coverage = NULL, ml_model = NULL, interval = "12 month",
                                 filter = NULL, memsize = 4, multicores = NULL)
{

  if (!dir.exists(sits.rep.env$config$FILE_PATH))
    dir.create(sits.rep.env$config$FILE_PATH, recursive = TRUE)

  path <-  normalizePath(paste0(sits.rep.env$config$DIR_PRINCIPAL,
                                sep = "/",
                                get_tree(),
                                sep = "/",
                                sits.rep.env$config$CLASSIFY_PROCESS_DIR_NAME),
                         mustWork = FALSE)

  raster_path <-  paste0(path, sep = "/", sits.rep.env$config$FILE_PATH, sep = "/", base::basename(file))
  rasters.tb <- sits::sits_classify_cubes(file = raster_path,
                                          coverage = coverage,
                                          ml_model = ml_model, interval = interval,
                                          filter = filter, memsize = memsize,
                                          multicores = multicores)

  if (!dir.exists(sits.rep.env$config$RDS_PATH))
    dir.create(sits.rep.env$config$RDS_PATH, recursive = TRUE)

  base::saveRDS(list(rasters.tb = rasters.tb),
                file = paste0(sits.rep.env$config$RDS_PATH, sep = "/", sits.rep.env$config$RDS_NAME))

  json <- list(result = list(file = TRUE, rds = TRUE))
  # json <- list(classification = list(param = list(interval = interval, filter = filter,
  #                                                 memsize = memsize, multicores = multicores)),
  #              result = list(file = TRUE, rds = TRUE))
  #
  #
  json_save(json)
  return(rasters.tb)
}


.is_model <- function(model_args_unknown, model_sits){

  model_sits_args <- formalArgs(model_sits)
  model_sits_args <- model_sits_args[!model_sits_args %in% c("...")]

  return(.is_arrays_equal(model_args_unknown, model_sits_args))

}


.is_arrays_equal <- function(array_1, array_2){

  length <- length(array_1)

  if(length != length(array_2))
    return(FALSE)

  array_1 <- sort(array_1)
  array_2 <- sort(array_2)

  for(pos in 1:length)
    if(array_1[pos] != array_2[pos])
      return(FALSE)

  return(TRUE)

}


# .get_seed <- function(){
#
#   json <- jsonlite::fromJSON(sits.rep.env$config$METADATA_BASE_NAME)
#
#   return(json$seed)
#
# }


