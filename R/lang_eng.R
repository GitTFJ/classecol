#' Identify if text language is english
#'
#' This function loads a vector or string and checks if it is english
#'
#' @param text_vector Choose character vector or string
#' @return A trimmed character vector or string
#' @examples
#' lang_eng("hunting")
#' @export
#'
#'

lang_eng = function(text_vector){
  lang = detect_language(text_vector)
  lang = ifelse(lang == "en", 1, 0)
  lang = ifelse(is.na(lang), 0, lang)
  return(lang)
}
