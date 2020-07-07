#' Biographical classifications of twitter users
#'
#' This function recevies a vector of tweets, and produces classifications that the tweets stance on the environment. Classification accuracy ~80%
#'
#' @param type Do you want the text to split environemntal-based organisations and experts, or join these categories together. Joining categories improved overall classification accuracy ~5%, but the 'expert' category no longer describes experts and is more fairly described as an environmnetal person/organisation. Defaults to 'join'. Alternate is 'split'
#' @param directory Choose directory containing models sourced from download_models function
#' @return A character vector of classifications.
#'
#'
#' For join:
#'
#' Expert - An individual/group/business/lab employed to work with the environment or with qualifications describing expertise. F1 accuracy = 0.90.
#'
#' Person (not expert) - An individual person not meeting the expert critera. F1 accuracy = 0.82.
#'
#' Organisation/Group/Company/Other - Any account not meeting the above criteria. F1 accuracy = 0.75.
#'
#'
#' For split:
#'
#' Expert - An individual employed to work within the envionmental sciences or with qualifications describing expertise. F1 accuracy = 0.87.
#'
#' Wildlife org - An Organisation/Group/Company working within an environmental area. F1 accuracy = 0.62.
#'
#' Person (not expert) - An individual person not meeting the expert critera. F1 accuracy = 0.80.
#'
#' Organisation/Group/Company/Other - Any account not meeting the above criteria. F1 accuracy = 0.77.
#'
#'
#' @examples
#' bio_class(type = "join", directory = "models/classecol-models-master/")
#' @export

bio_class = function(type = "join",
                     directory){
  save_dic = getwd()
  if(type == "join"){
    py_run_file(paste(directory,"bio_wldexjoin_rapid_pred.py", sep = ""))
  } else if (type == "split"){
    py_run_file(paste(directory,"bio_all_rapid_pred.py", sep = ""))
  } else {
    stop("Please specify a valid type: join or split")
  }
  setwd(save_dic)
  return_vector = py$pred_comb
  return(return_vector)
}

