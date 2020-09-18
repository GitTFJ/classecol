#' Biographical classifications of twitter users
#'
#' This function recevies a vector of screen names and user bios, and produces classifications that describe the user. Classification accuracy ~80%
#'
#' @param type Text can be run through three different models: "full"(default), "trimmed person", and "trimmed expert". See 'Value' for details.
#' @param directory Choose directory containing models sourced from download_models function
#' @return A character vector of classifications.
#'
#'
#'
#' full classifications (0.79 accuracy): Expert, Person, Organisations, Nature-organisation
#'
#'
#' trimmed person classifications (0.87 accuracy): Person, Organisations
#'
#'
#' trimmed expert (0.84 accuracy): Expert, Person, Organisations
#'
#'
#'
#' @examples
#' bio_class(type = "full", directory = "models/classecol-models-master/")
#' @export

bio_class = function(type = "full",
                     directory){
  save_dic = getwd()
  if(type == "full"){
    py_run_file(paste(directory,"bio_all_rapid_pred.py", sep = ""))
  } else if (type == "trimmed person"){
    py_run_file(paste(directory,"bio_per_org_rapid_pred.py", sep = ""))
  } else if (type == "trimmed expert"){
    py_run_file(paste(directory,"bio_wldexjoin_rapid_pred.py", sep = ""))
  } else {
    stop("Please specify a valid type")
  }
  setwd(save_dic)
  return_vector = py$pred_comb
  return(return_vector)
}

