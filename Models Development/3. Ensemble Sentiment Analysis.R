#Set up working directory
setwd("~/GitHub/NextBigCrypto-Senti/")

# Clear environment
rm(list = ls())
# install packages if not available
packages <- c("e1071","SnowballC","caTools","rpart","randomForest",
              "h2o","tm","memisc","dplyr","data.table","stringr",
              "qdap","caret","XML")

if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))
}
lapply(packages, require, character.only = TRUE)

#===========================================================

loadAbbrev <- function(filename) {
  # Concates custom abbreviation dataset with the default one from qdap
  #
  # Args:
  #   filename: Filename of the abbreviation lexicon
  #
  # Returns:
  #   A 2-column(abv,rep) data.frame
  
  myAbbrevs <- read.csv(filename, sep = ",", as.is = TRUE)
  return(rbind(abbreviations,myAbbrevs))
}


# Use the file "5.Dataset/abbrev.csv"
myAbbrevs <- loadAbbrev('~/GitHub/NextBigCrypto-Senti/Dict/abbrev.csv')

convertAbbreviations <- function(message){
  # Replaces abbreviation with the corresporending long form
  #
  # Args:
  #   text: Text to remove the abbreviations from
  #
  # Returns:
  #   String
  if(is.na(message) || message == ""){
    return(message)
  } else {
    newText <- message
    for (i in 1:nrow(myAbbrevs)){
      newText <- gsub(paste0('\\<', myAbbrevs[[i,1]], '\\>'), paste(myAbbrevs[[i,2]]), newText)
    }
    return (newText)
  }
}

########################################################