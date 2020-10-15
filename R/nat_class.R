#' Nature classifications of tweets
#'
#' This function recevies a vector of tweets, and produces classifications that describe the tweets stance on nature. Classification accuracy ~80%
#'
#' @param type Text can be run through four different models: "Trimmed"(default), "Full", "Relevance", and "Stance". See 'Value' for details.
#' @param directory Choose directory containing models sourced from download_models function
#' @return A character vector of classifications.
#'
#'
#'
#' Trimmed classifications (0.82 accuracy): Irrelevant, Pro-nature positive phrasing, Pro-nature negative phrasing
#'
#'
#' Full classifications (0.81 accuracy): Irrelevant, Pro-nature positive phrasing, Pro-nature negative phrasing, Against-nature
#'
#'
#' Relevance classifications (0.90 accuracy): Irrelevant, Relevant
#'
#'
#' Stance classifications (0.92 accuracy): Pro-nature positive phrasing, Pro-nature negative phrasing
#'
#'
#'
#' @examples
#'nat_class(type = "Trimmed", directory = "models/classecol-models-master/")
#' @export

nat_class = function(type = "Trimmed",
                     directory){
  save_dic = getwd()
  if(type == "Trimmed"){
    py_run_file(paste(directory,"nat_all(not_against)_rapid_pred.py", sep = ""))
  } else if (type == "Full"){
    py_run_file(paste(directory,"nat_all_rapid_pred.py", sep = ""))
  } else if (type == "Relevance"){
    py_run_file(paste(directory,"nat_relevance_rapid_pred.py", sep = ""))
  } else if (type == "Stance"){
    py_run_file(paste(directory,"nat_stance_rapid_pred.py", sep = ""))
  } else {
    stop("Please specify a valid type")
  }
  setwd(save_dic)
  return_vector = py$pred_comb
  return(return_vector)
}
