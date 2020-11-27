#' Valence of text
#'
#' This function loads a vector or string and idnetifies valence terms using trinkers lexicon package
#'
#' @param text_vector Choose character vector or string
#' @return A data frame in the same order as the input, with the following columns: negator, amplifier, de-amplifier, and ad-conjunction. See the lexicon package vignette for details.
#' @examples
#' valence("I am not the cat in the hat, I am just a very massive feather")
#' @export
#'
#'

valence = function(text_vector){
  hash_valence_shifters = lexicon::hash_valence_shifters
  neg = subset(hash_valence_shifters, y == "1")$x
  amp = subset(hash_valence_shifters, y == "2")$x
  deamp = subset(hash_valence_shifters, y == "3")$x
  ad_con = subset(hash_valence_shifters, y == "4")$x

  tmp_df = NULL
  for(a in 1:length(neg)){
    tmp = ifelse(grepl(neg[a], text_vector), 1, 0)
    tmp_df = cbind(tmp_df, tmp)
  }
  tmp_df = data.frame(Count = rowSums(tmp_df))
  tmp_df = ifelse(tmp_df$Count > 1, 1, tmp_df$Count)
  neg = tmp_df

  tmp_df = NULL
  for(a in 1:length(amp)){
    tmp = ifelse(grepl(amp[a], text_vector), 1, 0)
    tmp_df = cbind(tmp_df, tmp)
  }
  tmp_df = data.frame(Count = rowSums(tmp_df))
  tmp_df = ifelse(tmp_df$Count > 1, 1, tmp_df$Count)
  amp = tmp_df

  tmp_df = NULL
  for(a in 1:length(deamp)){
    tmp = ifelse(grepl(deamp[a], text_vector), 1, 0)
    tmp_df = cbind(tmp_df, tmp)
  }
  tmp_df = data.frame(Count = rowSums(tmp_df))
  tmp_df = ifelse(tmp_df$Count > 1, 1, tmp_df$Count)
  deamp = tmp_df

  tmp_df = NULL
  for(a in 1:length(ad_con)){
    tmp = ifelse(grepl(ad_con[a], text_vector), 1, 0)
    tmp_df = cbind(tmp_df, tmp)
  }
  tmp_df = data.frame(Count = rowSums(tmp_df))
  tmp_df = ifelse(tmp_df$Count > 1, 1, tmp_df$Count)
  ad_con = tmp_df

  df = data.frame(
    negator = neg,
    amplifier = amp,
    deamplifier = deamp,
    ad_conjunction = ad_con
  )
  return(df)
}
