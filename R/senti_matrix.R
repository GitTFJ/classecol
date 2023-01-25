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
    jockers_rinker = round(sentimentr::sentiment(text_vector, lexicon::hash_sentiment_jockers_rinker,  question.weight = 0)[["sentiment"]], 2),
    jockers = round(sentimentr::sentiment(text_vector, lexicon::hash_sentiment_jockers, question.weight = 0)[["sentiment"]], 2),
    huliu = round(sentimentr::sentiment(text_vector, lexicon::hash_sentiment_huliu, question.weight = 0)[["sentiment"]], 2),
    loughran_mcdonald = round(sentimentr::sentiment(text_vector, lexicon::hash_sentiment_loughran_mcdonald, question.weight = 0)[["sentiment"]], 2),
    senticnet = round(sentimentr::sentiment(text_vector, lexicon::hash_sentiment_senticnet, question.weight = 0)[["sentiment"]], 2),
    sentiword = round(sentimentr::sentiment(text_vector, lexicon::hash_sentiment_sentiword, question.weight = 0)[["sentiment"]], 2),
    socal_google = round(sentimentr::sentiment(text_vector, lexicon::hash_sentiment_socal_google, question.weight = 0)[["sentiment"]], 2),
    nrc = syuzhet::get_sentiment(text_vector, method="nrc"),
    afinn = syuzhet::get_sentiment(text_vector, method="afinn"),
    bing = syuzhet::get_sentiment(text_vector, method="bing"),
    meanr = meanr::score(text_vector)[['score']]
  )
  return(mat)
}
