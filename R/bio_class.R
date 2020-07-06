#' Clean a text vector
#'
#' This function loads a vector os string of type character and tidies the text
#'
#' @param type Do you want the text to receive a simple or full clean. Default to 'full'
#' @param directory Choose cdirectory containing models
#' @return A character vector or string
#' @examples
#' bio_class(type = "full", directory = "models/classecol-models-master/")
#' @export

bio_class = function(type = "full",
                     directory){
  save_dic = getwd()
  if(type == "full"){
    py_run_file(paste(directory,"bio_all_rapid_pred.py", sep = ""))
  } else if (type == "simple"){
    py_run_file(paste(directory,"bio_wldexjoin_rapid_pred.py", sep = ""))
  } else {
    stop("Please specify a valid type: simple or full")
  }
  setwd(save_dic)
  return_vector = py$pred_comb
  return(return_vector)
}

