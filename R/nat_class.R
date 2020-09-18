#' Nature classifications of tweets
#'
#' This function recevies a vector of tweets, and produces classifications that describe the tweets stance on nature. Classification accuracy ~80%
#'
#' @param type Text can be run through four different models: "trimmed"(default), "full", "relevance", and "stance". See 'Value' for details.
#' @param directory Choose directory containing models sourced from download_models function
#' @return A character vector of classifications.
#'
#'
#'
#' trimmed classifications (0.82 accuracy): Irrelevant, Pro-nature positive phrasing, Pro-nature negative phrasing
#'
#'
#' full classifications (0.81 accuracy): Irrelevant, Pro-nature positive phrasing, Pro-nature negative phrasing, Against-nature
#'
#'
#' relevance classifications (0.90 accuracy): Irrelevant, Relevant
#'
#'
#' stance classifications (0.92 accuracy): Pro-nature positive phrasing, Pro-nature negative phrasing
#'
#'
#'
#' @examples
#'nat_class(type = "trimmed", directory = "models/classecol-models-master/")
#' @export

nat_class = function(type = "trimmed",
                     directory){
  save_dic = getwd()
  if(type == "trimmed"){
    py_run_file(paste(directory,"nat_all(not_against)_rapid_pred.py", sep = ""))
  } else if (type == "full"){
    py_run_file(paste(directory,"nat_all_rapid_pred.py", sep = ""))
  } else if (type == "relevance"){
    py_run_file(paste(directory,"nat_relevance_rapid_pred.py", sep = ""))
  } else if (type == "stance"){
    py_run_file(paste(directory,"nat_stance_rapid_pred.py", sep = ""))
  } else {
    stop("Please specify a valid type")
  }
  setwd(save_dic)
  return_vector = py$pred_comb
  return(return_vector)
}