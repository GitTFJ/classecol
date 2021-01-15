#' Loads classecol dependencies
#'
#' This function loads the important dependencies of the classecol pacakge. For classecol's text classification models to work, the text models need to be downloaded (download_models = T), the python modules need to be installed (download_modules = T), and python needs to be linked to R (link_py = T). Once the download_models and download_modules functions have ran once, the information will be stored permanently. However, link_py needs be ran every time a fresh R environment is opened.
#'
#' @param download_models Confirm whether the classecol python models should be downloaded (TRUE) or not (FALSE)
#' @param download_modules Confirm whether thepython modules should be downloaded (TRUE) or not (FALSE)
#' @param link_py Link python to R, select TRUE or FALSE
#' @param directory Choose directory containing models sourced from download_models function
#' @return No product returned.

#' @examples
#' load_classecol(download_models = T, download_modules = T, link_py = T)
#' @export


load_classecol = function(
  download_models = F,
  download_modules = F,
  link_py = T){
  message("classecol is reliant on Java 8 or above. Install Java from: https://www.java.com/en/download/")
  direc = paste(find.package("classecol"),"/models", sep = "")
  if(download_models == T){
    message("Model download beginning...")
    download_models(direc)
  } else {
    message("Skipping model download")
  }
  direc = paste(direc, "/classecol-models-master/", sep = "")
  if(download_modules == T){
    message("Python modules downloading...")
    addeR::install_modules(c("keras", "tensorflow", "pandas", "nltk", "bs4", "sklearn", "scikit-learn==0.19.1"))
  } else {
    message("Skipping python module download")
  }
  if(link_py == T){
    message("Linking python to R...")
    link_python()
    model_directory = reticulate::r_to_py(direc)
  } else {
    model_directory = reticulate::r_to_py(direc)
  }
  message("Again, classecol is reliant on Java 8 or above. Install Java from: https://www.java.com/en/download/")
  return(paste0("We connected to ", reticulate::py_config()[1]))
}

load_classecol(download_models = F, download_modules = F, link_py = T)

