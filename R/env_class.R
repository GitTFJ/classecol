#' Environmental classifications of tweets
#'
#' This function recevies a vector of tweets, and produces classifications that describe the tweets stance on the environment. Classification accuracy ~80%
#'
#' @param type Text can be run through four different models: trim(default), all, relevant, and stance. See 'Value' for details.
#' @param directory Choose directory containing models sourced from download_models function
#' @return A character vector of classifications.
#'
#'
#' For trim:
#'
#' Irrelevant - Message not related to the environment. F1 accuracy = 0.80.
#'
#' Pro-wildlife (positive phrasing) - Mesasage has a positive stance towards the envionment and is talking about it with postivie wording i.e showing interest and enjoyment. F1 accuracy = 0.85.
#'
#' Pro-wildlife (negative phrasing) - Mesasage has a positive stance towards the envionment but is talking about it with negative wording i.e showing concern. F1 accuracy = 0.68.
#'
#'
#' For all :
#'
#' Irrelevant - same as above. F1 accuracy = 0.79.
#'
#' Pro-wildlife (positive phrasing) - same as above. F1 accuracy = 0.86.
#'
#' Pro-wildlife (negative phrasing) - same as above. F1 accuracy = 0.73.
#'
#' Against-wildlife - Message views the envionment negatively i.e showing fear. F1 accuracy = 0.25!
#'
#'
#' For relevant:
#'
#' Irrelevant - same as above. F1 accuracy = 0.76.
#'
#' Relevant - All other categoires combined, where message contains something about the environemnt. F1 accuracy = 0.92.
#'
#'
#' For stance (Model trained on everyhting except irrelevant and Against-wildlife):
#'
#' Pro-wildlife (positive phrasing) - same as above. F1 accuracy = 0.95.
#'
#' Pro-wildlife (negative phrasing) - same as above. F1 accuracy = 0.80.
#'
#'
#'
#' @examples
#'env_class(type = "trim", directory = "models/classecol-models-master/")
#' @export

env_class = function(type = "trim",
                     directory){
  save_dic = getwd()
  if(type == "trim"){
    py_run_file(paste(directory,"wild_all(not_against)_rapid_pred.py", sep = ""))
  } else if (type == "all"){
    py_run_file(paste(directory,"wild_all_rapid_pred.py", sep = ""))
  } else if (type == "relevant"){
    py_run_file(paste(directory,"wild_relevance_rapid_pred.py", sep = ""))
  } else if (type == "stance"){
    py_run_file(paste(directory,"wild_stance_rapid_pred.py", sep = ""))
  } else {
    stop("Please specify a valid type: trim, all, relevant, or stance")
  }
  setwd(save_dic)
  return_vector = py$pred_comb
  return(return_vector)
}
