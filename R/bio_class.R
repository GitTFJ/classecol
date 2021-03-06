#' Biographical classifications of twitter users
#'
#' This function recevies a vector of screen names and user bios, and produces classifications that describe the user. Classification accuracy ~80%
#' @param text_vector Character vector of text data describing the the combination of names and descriptions
#' @param type Text can be run through three different models: "full"(default), "person", and "expert". See 'Value' for details.
#' @return A character vector of classifications.
#'
#'
#'
#' full classifications (0.79 accuracy): Expert, Person, Other, Nature organisation
#'
#'
#' person classifications (0.87 accuracy): Person, Other
#'
#'
#' expert classifications (0.94 accuracy): Expert, Person
#'
#'
#'
#' @examples
#'hun_class(text_vector = df$text, type = "full")
#' @export

bio_class = function(text_vector,
                     type = "full"){
  if(is.vector(text_vector)){
    if((sum(nchar(text_vector)) < 5)>0){
      warning("Some of the strings in your text_vector had less than five characters. This may negatively impact on the classifiers performance. Consider removing all short or empty strings") } else {
      }
    tmp_df = data.frame(text = text_vector)
    dat = reticulate::r_to_py(tmp_df)
    list2env(list(data = dat), envir = .GlobalEnv)
    directory = paste(find.package("classecol"),"/models/classecol-models-master/", sep = "")
    model_directory = reticulate::r_to_py(directory)
    assign("model_directory", model_directory, envir = .GlobalEnv)
  save_dic = getwd()
  if(type == "full"){
    py = reticulate::py_run_file(paste(directory,"bio_all_rapid_pred.py", sep = ""))
  } else if (type == "person"){
    py = reticulate::py_run_file(paste(directory,"bio_per_org_rapid_pred.py", sep = ""))
  } else if (type == "expert"){
    py = reticulate::py_run_file(paste(directory,"bio_per_exp_rapid_pred.py", sep = ""))
  } else {
    stop("Please specify a valid type")
  }
  setwd(save_dic)
  return_vector = py$pred_comb
  return(return_vector)
  } else {
    stop("'text_vector' must be a vector")
  }
}

