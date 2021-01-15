#' Hunting classifications of tweets
#'
#' This function recevies a vector of tweets, and produces classifications that describe the tweets stance on hunting. Classification accuracy ~85%
#'
#' @param text_vector Character vector of text data
#' @param type Text can be run through three different models: "full" (default), "relevance", and "stance". See 'Value' for details.
#' @return A character vector of classifications.
#'
#'
#' relevance classifications (0.89 accuracy): Irrelevant, Relevant
#'
#'
#'
#' stance classifications (0.99 accuracy): Against-hunting, Pro-hunting
#'
#'
#'
#' full classifications (0.87 accuracy): Irrelevant, Against-hunting, Pro-hunting
#'
#'
#'
#' @examples
#'hun_class(text_vector = df$text, type = "full")
#' @export

hun_class = function(text_vector, type = "full"){
  if(is.vector(text_vector)){
    tmp_df = data.frame(text = text_vector)
    data = reticulate::r_to_py(tmp_df)
    directory = paste(find.package("classecol"),"/models/classecol-models-master/", sep = "")
    save_dic = getwd()
    if(type == "full"){
      py_run_file(paste(directory,"hunt_all_rapid_pred.py", sep = ""))
    } else if (type == "relevance"){
      py_run_file(paste(directory,"hunt_relevance_rapid_pred.py", sep = ""))
    } else if (type == "stance"){
      py_run_file(paste(directory,"hunt_stance_rapid_h_pred.py", sep = ""))
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
