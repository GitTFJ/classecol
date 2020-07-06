contract = function(text_vector){
  text_vector = multigsub(
    paste(" ",as.character(mop$contract$contraction), " ", sep = ""), 
    paste(" ",as.character(mop$contract$expanded), " ", sep = ""), 
    text_vector)
  text_vector = multigsub(
    paste(" ",as.character(mop$nouns$plural), " ", sep = ""), 
    paste(" ",as.character(mop$nouns$singular), " ", sep = ""), 
    text_vector)
  text_vector = lemmatize_strings(text_vector, dictionary = lexicon::hash_lemmas)
  text_vector = paste(" ", text_vector, " ", sep = "")
  return(text_vector)
}

valence = function(text_vector){
  data(hash_valence_shifters)
  hash_valence_shifters
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
  
  tmp = NULL
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

lang_eng = function(text_vector){
  lang = detect_language(text_vector)
  lang = ifelse(lang == "en", 1, 0)
  lang = ifelse(is.na(lang), 0, lang)
  return(lang)
}


#Load functions - Stage 1
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

