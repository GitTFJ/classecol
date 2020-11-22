#' Hunting classifications of tweets
#'
#' This function recevies a vector of tweets, and produces classifications that describe the tweets stance on hunting. Classification accuracy ~85%
#'
#' @param type Text can be run through three different models: "Full" (default), "Relevance", and "Stance". See 'Value' for details.
#' @param directory Choose directory containing models sourced from download_models function
#' @return A character vector of classifications.
#'
#'
#' Relevance classifications (0.89 accuracy): Irrelevant, Relevant
#'
#'
#'
#' Stance classifications (0.99 accuracy): Against-hunting, Pro-hunting
#'
#'
#'
#' Full classifications (0.86 accuracy): Irrelevant, Against-hunting, Pro-hunting
#'
#'
#'
#' @examples
#'hun_class(type = "Full", directory = "models/classecol-models-master/")
#' @export

hun_class = function(type = "Full",
                     directory){
  save_dic = getwd()
  if(type == "Full"){
    py_run_file(paste(directory,"hunt_all_rapid_pred.py", sep = ""))
  } else if (type == "Relevance"){
    py_run_file(paste(directory,"hunt_relevance_rapid_pred.py", sep = ""))
  } else if (type == "Stance"){
    py_run_file(paste(directory,"hunt_stance_rapid_h_pred.py", sep = ""))
  } else {
    stop("Please specify a valid type")
  }
  setwd(save_dic)
  return_vector = py$pred_comb
  return(return_vector)
}
