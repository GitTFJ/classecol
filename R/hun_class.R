#' Hunting classifications of tweets
#'
#' This function recevies a vector of tweets, and produces classifications that describe the tweets stance on hunting. Classification accuracy ~85%
#'
#' @param type Text can be run through five different models: "full H" (default), "relevance", "stance H", "full FH", and "stance FH". See 'Value' for details.
#' @param directory Choose directory containing models sourced from download_models function
#' @return A character vector of classifications.
#'
#'
#'
#' full H classifications (0.86 accuracy): Irrelevant, Against-hunting, Pro-hunting
#'
#'
#' relevance classifications (0.89 accuracy): Irrelevant, Relevant
#'
#'
#' stance H classifications (0.99 accuracy): Against-hunting, Pro-hunting
#'
#'
#' full FH classifications (0.89 accuracy): Irrelevant, Against-hunting, Pro-hunting, Pro-fishing
#'
#'
#' stance FH classifications (0.97 accuracy): Against-hunting, Pro-hunting, Pro-fishing
#'
#' @examples
#'hun_class(type = "full H", directory = "models/classecol-models-master/")
#' @export

hun_class = function(type = "full H",
                     directory){
  save_dic = getwd()
  if(type == "full H"){
    py_run_file(paste(directory,"hunt_all_rapid_h_pred.py", sep = ""))
  } else if (type == "relevance"){
    py_run_file(paste(directory,"hunt_relevance_rapid_pred.py", sep = ""))
  } else if (type == "stance H"){
    py_run_file(paste(directory,"hunt_stance_rapid_h_pred.py", sep = ""))
  } else if (type == "full FH"){
    py_run_file(paste(directory,"hunt_all_rapid_pred.py", sep = ""))
  } else if (type == "stance FH"){
    py_run_file(paste(directory,"hunt_stance_rapid_pred.py", sep = ""))
  } else {
    stop("Please specify a valid type")
  }
  setwd(save_dic)
  return_vector = py$pred_comb
  return(return_vector)
}
