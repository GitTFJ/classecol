#' Download classecol models
#'
#' This function downloads the required models to run the classecol package
#'
#' @param location Choose a filepath to save the classification models
#' @return A character vector or string
#' @examples download_models("user_specified_directory")
#' @export

download_models = function(location){
  download.file(url = "https://github.com/GitTFJ/classecol-models/archive/master.zip", destfile = paste(location,"_zp.zip", sep = ""))
  unzip(zipfile = paste(location,"_zp.zip", sep = ""), exdir = location)
}

