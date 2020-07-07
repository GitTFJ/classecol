#' Lemmatize and stem text
#'
#' This function loads a vector or string and trims the text e.g. hunting = hunt
#'
#' @param text_vector Choose character vector or string
#' @return A trimmed character vector or string
#' @examples
#' contract("hunting")
#' @export
#'
#'
contract = function(text_vector){
  text_vector = qdap::multigsub(
    paste(" ",as.character(mop$contract$contraction), " ", sep = ""),
    paste(" ",as.character(mop$contract$expanded), " ", sep = ""),
    text_vector)
  text_vector = qdap::multigsub(
    paste(" ",as.character(mop$nouns$plural), " ", sep = ""),
    paste(" ",as.character(mop$nouns$singular), " ", sep = ""),
    text_vector)
  text_vector = textstem::lemmatize_strings(text_vector, dictionary = lexicon::hash_lemmas)
  text_vector = paste(" ", text_vector, " ", sep = "")
  return(text_vector)
}
