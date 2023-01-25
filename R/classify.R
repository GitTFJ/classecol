#' Twitter text classifier
#'
#' @param text_vector Character vector of text data describing the the combination of names and descriptions
#' @param type Choice of classifier (see below): "Hunting - full", "Hunting - relevance", "Hunting - stance", "Nature - full", "Nature - trim", "Nature - relevance", "Nature - stance", "Bio - full", "Bio - person", Bio - expert"
#' @param sentiment Additonal sentiment matrix. Only needed with the Nature classifiers. See examples
#' @return A character vector of classifications.
#'
#'
#'There are 10 choices of classier, falling into three groups (Hunting, Nature, Bio), each with varying classification levels and accuracy
#'
#'
#' "Hunting - full" classification (0.87 accuracy): Irrelevant, Against-hunting, Pro-hunting
#'
#'
#' "Hunting - relevance" classification (0.89 accuracy): Irrelevant, Relevant
#'
#'
#' "Hunting - stance" classification (0.99 accuracy): Against-hunting, Pro-hunting
#'
#'
#' "Nature - trim" classification (0.82 accuracy; recommended over Nature - full): Irrelevant, Pro-nature positive phrasing, Pro-nature negative phrasing
#'
#'
#' "Nature - full" classification (0.81 accuracy): Irrelevant, Pro-nature positive phrasing, Pro-nature negative phrasing, Against-nature
#'
#'
#' "Nature - relevance" classification (0.90 accuracy): Irrelevant, Relevant
#'
#'
#' "Nature - stance" classification (0.92 accuracy): Pro-nature positive phrasing, Pro-nature negative phrasing
#'
#'
#' "Bio - full" classification (0.79 accuracy): Expert, Person, Other, Nature organisation
#'
#'
#' "Bio - person" classification (0.87 accuracy): Person, Other
#'
#'
#' "Bio - expert" classification (0.94 accuracy): Expert, Person
#'
#'
#'
#' @examples
#' text_vector = c("a collection of text", "another collection of text")
#' classify(text_vector, "Hunting - full")
#'
#' text_vector = c("a collection of text", "another collection of text")
#' sm = as.matrix(cbind(valence(text_vector),lang_eng(text_vector),senti_matrix(text_vector)))
#' classify(text_vector, "Nature - full", sentiment = sm)
#'
#' text_vector = c("a collection of text", "another collection of text")
#' classify(text_vector, "Bio - full")
#' @export


classify = function(text, classifier, sentiment){

  if(classifier == "Hunting - full"){
    model = hun_mod_full
  } else if (classifier == "Hunting - relevance"){
    model = hun_mod_rel
  } else if (classifier == "Hunting - stance"){
    model = hun_mod_sta
  } else if (classifier == "Nature - full"){
    model = nat_mod_full
  } else if (classifier == "Nature - trim"){
    model = nat_mod_trim
  } else if (classifier == "Nature - relevance"){
    model = nat_mod_rel
  } else if (classifier == "Nature - stance"){
    model = nat_mod_sta
  } else if (classifier == "Bio - full"){
    model = bio_mod_full
  } else if (classifier == "Bio - person"){
    model = bio_mod_pers
  } else if (classifier == "Bio - expert"){
    model = bio_mod_exp
  } else {
    warning("Unrecognised classifier")
    stop()
  }

  for(a in c(1:length(text))){
    text[a] = paste(intersect(strsplit(text, "\\s")[[a]], model[[3]]), collapse=" ")
  }
  text[length(text) + 1] = paste(model[[3]], collapse =  "  ")

  #Create dtm
  matrix = RTextTools::create_matrix(text, language="english", removeNumbers=TRUE, weighting=tm::weightTfIdf)

  #Place data into model-friendly structure
  container = RTextTools::create_container(matrix, labels = NA, testSize = c(1:length(text)), virgin = F)

  #Predict outputs
  results = RTextTools::classify_models(container, model[[1]])

  #Train the ensemble
  if(grepl("Nature", classifier)){
    colnames(sentiment) = paste("sm_",c(1:ncol(sentiment)), sep = "")
    sentiment = rbind(sentiment, rep(0,ncol(sentiment)))
    ensem = predict(model[[2]], cbind(results[,c(TRUE,FALSE)], sentiment))
  } else {
    ensem = predict(model[[2]], results[,c(TRUE,FALSE)])
  }

  ensem = head(ensem, -1)

  return(ensem)
}
