#' Clean a text vector
#'
#' This function loads a vector os string of type character and tidies the text
#'
#' @param text_vector Choose character vector or string
#' @param level Do you want the text to receive a simple or full clean. Default to 'simple'
#' @param hashtag Do you want to convert common multi-word hashtags into a split string of words e.g. #TrophyHunting = Trophy Hunting. Defaults to TRUE
#' @param twitter_syn Do you want to remove twitter specific terms e.g. RTs
#' @param abbrev Do you want to convert abbreviations into their expanded form. Defaults to TRUE
#' @param emoti Do you want to convert unicode and ascii emoticons into a readble format e.g. :/ = unsure. Defaults to TRUE
#' @param slang Do you want to convert slang into its expanded form. Defaults to TRUE
#' @param grade Do you want to convert grades into a readable form e.g. A+ = Excellent. Defaults to TRUE
#' @param rating Do you want to convert ratings into a readable form e.g. 10/10 = Excellent. Defaults to TRUE
#' @param url Do you want to remove urls. Defaults to TRUE
#' @param special_other Do you want to remove any remaining special characters, punctions and numbers. Defaults to TRUE
#' @return A character vector or string
#' @examples
#' clean("cat :(")
#' clean(c("2moro", ":/"))
#' @export

clean = function(text_vector,
                 level = "simple",
                 hashtag = TRUE,
                 twitter_syn = TRUE,
                 abbrev = TRUE,
                 emoti = TRUE,
                 slang = TRUE,
                 grade = TRUE,
                 rating = TRUE,
                 url = TRUE,
                 special_other = TRUE){
  if(level == "simple"){
    if(hashtag == TRUE){
      text_vector = qdap::multigsub(
        paste(" ",as.character(mop$hash_dic$full), " ", sep = ""),
        paste(" ",as.character(mop$hash_dic$breakdown), " ", sep = ""),
        text_vector)
      text_vector = qdap::multigsub(
        paste("",as.character(mop$hash_dic$full), "", sep = ""),
        paste("",as.character(mop$hash_dic$breakdown), "", sep = ""),
        text_vector)
    } else {
      message("Ignoring hashtags")
    }
    if(twitter_syn){
      text_vector <- stringr::str_replace(text_vector,"RT@[a-z,A-Z]*: ","")
      text_vector <- stringr::str_replace_all(text_vector,"#"," ")
      text_vector <- stringr::str_replace_all(text_vector,"@[a-z,A-Z,0-9,_]*","")
      text_vector = gsub("&amp", "", text_vector)
      text_vector = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", text_vector)
    } else {
      message("Ignoring twitter specific syntax")
    }
    if(url == TRUE){
      text_vector <- stringr::str_replace_all(text_vector, "https://t.co/[a-z,A-Z,0-9]*","")
      text_vector <- stringr::str_replace_all(text_vector, "http://t.co/[a-z,A-Z,0-9]*","")
      text_vector = gsub("http\\w+", "", text_vector)
    } else {
      message("Ignoring urls")
    }
    if(emoti == TRUE){
      text_vector = qdap::multigsub(
        paste("",as.character(mop$emo_uni$code), "", sep = ""),
        paste(" ",as.character(mop$emo_uni$description), " ", sep = ""),
        text_vector)
      text_vector = sub("<.*>", "unicode", text_vector)
      text_vector = qdap::multigsub(
        paste("",as.character(mop$emo_asc$x), "", sep = ""),
        paste(" ",as.character(mop$emo_asc$y), " ", sep = ""),
        text_vector)
    } else {
      message("Ignoring emoticons")
    }
    if(special_other == TRUE){
      text_vector <- stringr::str_replace_all(text_vector," "," ")
      text_vector = gsub("[[:punct:]]", "", text_vector)
      text_vector = gsub("[[:digit:]]", "", text_vector)
    } else {
      message("Ignoring specials")
    }
  } else {
    if(hashtag == TRUE){
      text_vector = qdap::multigsub(
        paste(" ",as.character(mop$hash_dic$full), " ", sep = ""),
        paste(" ",as.character(mop$hash_dic$breakdown), " ", sep = ""),
        text_vector)
      text_vector = qdap::multigsub(
        paste("",as.character(mop$hash_dic$full), "", sep = ""),
        paste("",as.character(mop$hash_dic$breakdown), "", sep = ""),
        text_vector)
    } else {
      message("Ignoring hashtags")
    }
    if(twitter_syn){
      text_vector <- stringr::str_replace(text_vector,"RT@[a-z,A-Z]*: ","")
      text_vector <- stringr::str_replace_all(text_vector,"#"," ")
      text_vector <- stringr::str_replace_all(text_vector,"@[a-z,A-Z,0-9,_]*","")
      text_vector = gsub("&amp", "", text_vector)
      text_vector = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", text_vector)
    } else {
      message("Ignoring twitter specific syntax")
    }
    if(url == TRUE){
      text_vector <- stringr::str_replace_all(text_vector, "https://t.co/[a-z,A-Z,0-9]*","")
      text_vector <- stringr::str_replace_all(text_vector, "http://t.co/[a-z,A-Z,0-9]*","")
      text_vector = gsub("http\\w+", "", text_vector)
    } else {
      message("Ignoring urls")
    }
    if(emoti == TRUE){
      text_vector = qdap::multigsub(
        paste("",as.character(mop$emo_uni$code), "", sep = ""),
        paste(" ",as.character(mop$emo_uni$description), " ", sep = ""),
        text_vector)
      text_vector = sub("<.*>", "unicode", text_vector)
      text_vector = qdap::multigsub(
        paste("",as.character(mop$emo_asc$x), "", sep = ""),
        paste(" ",as.character(mop$emo_asc$y), " ", sep = ""),
        text_vector)
    } else {
      message("Ignoring emoticons")
    }
    if(abbrev == TRUE){
      text_vector = qdap::multigsub(
        paste(" ",as.character(mop$abb$term), " ", sep = ""),
        paste(" ",as.character(mop$abb$correct), " ", sep = ""),
        text_vector)
      text_vector = qdap::multigsub(
        paste(" ",as.character(mop$abb$term), "", sep = ""),
        paste(" ",as.character(mop$abb$correct), " ", sep = ""),
        text_vector)
      text_vector = qdap::multigsub(
        paste("",as.character(mop$abb$term), " ", sep = ""),
        paste(" ",as.character(mop$abb$correct), " ", sep = ""),
        text_vector)
    } else {
      message("Ignoring abbreviations")
    }
    if(slang == TRUE){
      text_vector = qdap::multigsub(
        paste("",as.character(mop$slang$x), "", sep = ""),
        paste(" ",as.character(mop$slang$y), " ", sep = ""),
        text_vector)
    } else {
      message("Ignoring slang")
    }
    if(grade == TRUE){
      text_vector = qdap::multigsub(
        paste(" ",as.character(mop$grade$x), " ", sep = ""),
        paste(" ",as.character(mop$grade$y), " ", sep = ""),
        text_vector)
    } else {
      message("Ignoring grade")
    }
    if(rating == TRUE){
      text_vector = qdap::multigsub(
        paste(" ",as.character(mop$rating$x), " ", sep = ""),
        paste(" ",as.character(mop$rating$y), " ", sep = ""),
        text_vector)
    } else {
      message("Ignoring rating")
    }
    if(special_other == TRUE){
      text_vector <- stringr::str_replace_all(text_vector," "," ")
      text_vector = gsub("[[:punct:]]", "", text_vector)
      text_vector = gsub("[[:digit:]]", "", text_vector)
    } else {
      message("Ignoring specials")
    }
  }

  return(text_vector)
}
