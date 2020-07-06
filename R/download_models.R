#' Clean a text vector
#'
#' This function loads a vector os string of type character and tidies the text
#'
#' @param location Choose a filepath to save the classification models
#' @return A character vector or string
#' @examples
#' @export

download_models = function(location){
  download.file(url = "https://github.com/GitTFJ/classecol-models/archive/master.zip", destfile = paste(location,"models.zip", sep = ""))
  unzip(zipfile = paste(location,"models.zip", sep = ""), exdir = location)
}

