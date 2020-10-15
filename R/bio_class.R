#' Biographical classifications of twitter users
#'
#' This function recevies a vector of screen names and user bios, and produces classifications that describe the user. Classification accuracy ~80%
#'
#' @param type Text can be run through three different models: "Full"(default), "Person", and "Expert". See 'Value' for details.
#' @param directory Choose directory containing models sourced from download_models function
#' @return A character vector of classifications.
#'
#'
#'
#' Full classifications (0.79 accuracy): Expert, Person, Other, Nature organisation
#'
#'
#' Person classifications (0.87 accuracy): Person, Other
#'
#'
#' Expert (0.94 accuracy): Expert, Person
#'
#'
#'
#' @examples
#' bio_class(type = "Full", directory = "models/classecol-models-master/")
#' @export

bio_class = function(type = "Full",
                     directory){
  save_dic = getwd()
  if(type == "Full"){
    py_run_file(paste(directory,"bio_all_rapid_pred.py", sep = ""))
  } else if (type == "Person"){
    py_run_file(paste(directory,"bio_per_org_rapid_pred.py", sep = ""))
  } else if (type == "Expert"){
    py_run_file(paste(directory,"bio_per_exp_rapid_pred.py", sep = ""))
  } else {
    stop("Please specify a valid type")
  }
  setwd(save_dic)
  return_vector = py$pred_comb
  return(return_vector)
}

