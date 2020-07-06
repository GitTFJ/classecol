#' Create a sentiment matrix
#'
#' This function loads a vector or string and produces a sentiment matrix with 11 lexicon metrics: jockers-rinker, jockers, hu-liu, loughran-mcdonald, sentinet, sentiword, socal-google, nrc, bing, afinn, and meanr
#' @param text_vector Choose character vector or string
#' @return A trimmed character vector or string
#' @examples
#' senti_matrix("hunting is really bad I hate it")
#' @export
#'
#'

senti_matrix = function(text_vector){
  mat = data.frame(
    jockers_rinker = round(sentiment(text_vector, lexicon::hash_sentiment_jockers_rinker,  question.weight = 0)[["sentiment"]], 2),
    jockers = round(sentiment(text_vector, lexicon::hash_sentiment_jockers, question.weight = 0)[["sentiment"]], 2),
    huliu = round(sentiment(text_vector, lexicon::hash_sentiment_huliu, question.weight = 0)[["sentiment"]], 2),
    loughran_mcdonald = round(sentiment(text_vector, lexicon::hash_sentiment_loughran_mcdonald, question.weight = 0)[["sentiment"]], 2),
    senticnet = round(sentiment(text_vector, lexicon::hash_sentiment_senticnet, question.weight = 0)[["sentiment"]], 2),
    sentiword = round(sentiment(text_vector, lexicon::hash_sentiment_sentiword, question.weight = 0)[["sentiment"]], 2),
    socal_google = round(sentiment(text_vector, lexicon::hash_sentiment_socal_google, question.weight = 0)[["sentiment"]], 2),
    nrc = get_sentiment(text_vector, method="nrc"),
    afinn = get_sentiment(text_vector, method="afinn"),
    bing = get_sentiment(text_vector, method="bing"),
    meanr = score(text_vector)[['score']]
  )
  return(mat)
}
