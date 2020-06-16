## code to prepare `mop` dataset goes here
#These packages are needed
#library(lexicon)
#library(qdap)
#library(stringr)

###Load data----
data(hash_internet_slang)
data(hash_emoticons)
data(key_grade)
data(key_rating)
hash_internet_slang
hash_emoticons
key_grade
key_rating


#http://www.unicode.org/emoji/charts/full-emoji-list.html V13.0
hash_emoticons_unicode = read.csv("../Manuscript/Package/data/extdata/emoticon_unicode.csv")

#homemade
hashtag_dictionary = read.csv("../Manuscript/Package/data/extdata/hashtag_dictionary.csv")
hashtag_dictionary = subset(hashtag_dictionary, breakdown != "")
hashtag_dictionary$vec = as.character(hashtag_dictionary$full)
hashtag_dictionary$breakdown = as.character(hashtag_dictionary$breakdown)

#https://www.webopedia.com/quick_ref/textmessageabbreviations.asp
abbreviations = read.csv("../Manuscript/Package/data/extdata/abbreviation.csv")

mop = list(hash_dic = hashtag_dictionary,
           abb = abbreviations,
           emo_uni = hash_emoticons_unicode,
           emo_asc = hash_emoticons,
           slang = hash_internet_slang,
           grade = key_grade,
           rating = key_rating)
usethis::use_data(mop)
