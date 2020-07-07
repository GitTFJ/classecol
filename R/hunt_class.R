#' Hunting classifications of tweets
#'
#' This function recevies a vector of tweets, and produces classifications that describe the tweets stance on hunting. Classification accuracy ~85%
#'
#' @param type Text can be run through three different models: all(default), relevant, and stance. See 'Value' for details.
#' @param directory Choose directory containing models sourced from download_models function
#' @return A character vector of classifications.
#'
#'
#' For all :
#'
#' Irrelevant - message not related to hunting animals. F1 accuracy = 0.62.
#'
#' Relevant (against-hunting) - message describes an opposition to hunting. F1 accuracy = 0.94.
#'
#' Relevant (pro-hunting) - message describes an enjoyment of hunting. F1 accuracy = 0.86.
#'
#' Relevant (pro-hunt_fish) - message describes an enjoyment of fishing, and uses the word hunting in conjunction. F1 accuracy = 0.96.
#'
#'
#'
#' For relevant:
#'
#' Irrelevant - same as above. F1 accuracy = 0.59.
#'
#' Relevant - All other categoires combined, where message contains something about hunting. F1 accuracy = 0.93.
#'
#'
#'
#' For stance (Model trained on everyhting except irrelevant):
#'
#' Relevant (against-hunting) - same as above. F1 accuracy = 0.97.
#'
#' Relevant (pro-hunting) - same as above. F1 accuracy = 0.96.
#'
#' Relevant (pro-hunt_fish) - same as above. F1 accuracy = 0.96.
#'
#'
#'
#' @examples
#'env_class(type = "trim", directory = "models/classecol-models-master/")
#' @export

hunt_class = function(type = "all",
                     directory){
  save_dic = getwd()
  if(type == "all"){
    py_run_file(paste(directory,"hunt_all_rapid_pred.py", sep = ""))
  } else if (type == "relevant"){
    py_run_file(paste(directory,"hunt_relevance_rapid_pred.py", sep = ""))
  } else if (type == "stance"){
    py_run_file(paste(directory,"hunt_stance_rapid_pred.py", sep = ""))
  } else {
    stop("Please specify a valid type: all, relevant, or stance")
  }
  setwd(save_dic)
  return_vector = py$pred_comb
  return(return_vector)
}
