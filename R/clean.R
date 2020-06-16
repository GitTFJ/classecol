#' Clean a text vector
#'
#' This function loads a text vector
#'
#' @param infile text_vector: a character vector
#' @param infile hashtag: do you want to convert common multi-word hashtags into a split string of words e.g. #TrophyHunting = Trophy Hunting. Defaults to TRUE
#' @param infile abbrev: do you want to convert abbreviations into their expanded form. Defaults to TRUE
#' @param infile emoti: do you want to convert unicode and ascii emoticons into a readble format e.g. :/ = unsure. Defaults to TRUE
#' @param infile slang: do you want to convert slang into its expanded form. Defaults to TRUE
#' @param infile grade: do you want to convert grades into a readable form e.g. A+ = Excellent. Defaults to TRUE
#' @param infile rating: do you want to convert ratings into a readable form e.g. 10/10 = Excellent. Defaults to TRUE
#' @param infile url: do you want to remove urls. Defaults to TRUE
#' @param infile special_other: do you want to remove any remaining special characters, punctions and numbers. Defaults to TRUE
#' @return a character vector
#' @export

clean = function(text_vector,
                 hashtag = TRUE,
                 abbrev = TRUE,
                 emoti = TRUE,
                 slang = TRUE,
                 grade = TRUE,
                 rating = TRUE,
                 url = TRUE,
                 special_other = TRUE){
  if(hashtag == TRUE){
    text_vector = multigsub(
      paste(" ",as.character(mop$hash_dic$full), " ", sep = ""),
      paste(" ",as.character(mop$hash_dic$breakdown), " ", sep = ""),
      text_vector)
  } else {
    message("Ignoring hashtags")
  }
  if(abbrev == TRUE){
  text_vector = multigsub(
    paste(" ",as.character(mop$abb$term), " ", sep = ""),
    paste(" ",as.character(mop$abb$correct), " ", sep = ""),
    text_vector)
  } else {
    message("Ignoring abbreviations")
  }
  if(emoti == TRUE){
  text_vector = multigsub(
    paste(" ",as.character(mop$emo_uni$code), " ", sep = ""),
    paste(" ",as.character(mop$emo_uni$description), " ", sep = ""),
    text_vector)
  text_vector = multigsub(
    paste(" ",as.character(mop$emo_asc$x), " ", sep = ""),
    paste(" ",as.character(mop$emo_asc$y), " ", sep = ""),
    text_vector)
  } else {
    message("Ignoring emoticons")
  }
  if(slang == TRUE){
  text_vector = multigsub(
    paste(" ",as.character(mop$slang$x), " ", sep = ""),
    paste(" ",as.character(mop$slang$y), " ", sep = ""),
    text_vector)
  } else {
    message("Ignoring slang")
  }
  if(grade == TRUE){
  text_vector = multigsub(
    paste(" ",as.character(mop$grade$x), " ", sep = ""),
    paste(" ",as.character(mop$grade$y), " ", sep = ""),
    text_vector)
  } else {
    message("Ignoring grade")
  }
  if(rating == TRUE){
  text_vector = multigsub(
    paste(" ",as.character(mop$rating$x), " ", sep = ""),
    paste(" ",as.character(mop$rating$y), " ", sep = ""),
    text_vector)
  } else {
    message("Ignoring rating")
  }
  if(url == TRUE){
  text_vector <- str_replace_all(text_vector, "https://t.co/[a-z,A-Z,0-9]*","")
  text_vector <- str_replace_all(text_vector, "http://t.co/[a-z,A-Z,0-9]*","")
  } else {
    message("Ignoring urls")
  }
  if(special_other == TRUE){
  text_vector <- str_replace_all(text_vector," "," ")
  text_vector <- str_replace(text_vector,"RT@[a-z,A-Z]*: ","")
  text_vector <- str_replace_all(text_vector,"#"," ")
  text_vector <- str_replace_all(text_vector,"@[a-z,A-Z]*","")
  text_vector = gsub("&amp", "", text_vector)
  text_vector = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", text_vector)
  text_vector = gsub("[[:punct:]]", "", text_vector)
  text_vector = gsub("[[:digit:]]", "", text_vector)
  text_vector = gsub("http\\w+", "", text_vector)
  } else {
    message("Ignoring specials")
  }
  return(text_vector)
}
