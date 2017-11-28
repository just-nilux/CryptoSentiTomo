#Set up working directory
setwd("~/GitHub/NextBigCrypto-Senti/")

# Clear environment
rm(list = ls())
# install packages if not available
packages <- c("dplyr",
              "smbinning", # supervised discretization
              "infotheo")

if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))
}
lapply(packages, require, character.only = TRUE)

#==================================================================
# Convert epoch time
unix2POSIXct <- function(time) structure(time, class = c("POSIXt", "POSIXct"))

####################################################
# Reddit data---------------------------------------
####################################################
clean_reddit <- function(df){
  
  df <- df[ , -which(names(df) %in% c("X","V1"))]
  df <- unique(df)
  
  # Clear all NULL columns 
  df <- df[,colSums(is.na(df))<nrow(df)]
  # Add created_at column (human intepretation date time)
  df$created_at <- unix2POSIXct(df$created_utc)
  df$edited_at <- unix2POSIXct(df$edited)
  
  # Preprocessing ------------------------------------
  
  # Extract subset for EDA
  processed.df <- df[,c('id','created_at',
                                   'title','is_self','selftext',
                                   'link_flair_css_class','link_flair_text','num_comments','score','domain',
                                   'author','author_flair_css_class', #only author classes are relevant
                                   'full_link','url')]
  
  # Extract only non-NA data
  processed.df <- processed.df[complete.cases(processed.df),]
  
  # Clean data 
  # link_flair css -----------------------------
  processed.df$link_flair_css_class[tolower(processed.df$link_flair_css_class) %in% c('general discussion','discussion')] <- 'gdiscussion'
  
  # Delete "mod" flair class data
  processed.df <- processed.df[!(substr(processed.df$link_flair_css_class,0,3) =="mod"),]
  
  # turn all flairs into lower case
  processed.df$link_flair_css_class <- tolower(processed.df$link_flair_css_class)
  processed.df$link_flair_text <- tolower(processed.df$link_flair_text)
  
  # trip whitespace leading/trailing in author flairs
  trim <- function (x) gsub("^\\s+|\\s+$", "", x)
  processed.df$author_flair_css_class <- trim(processed.df$author_flair_css_class)
  
  return(processed.df)
}

crypto.df <- read.csv("~/GitHub/NextBigCrypto-Senti/1. Crawlers/2b. Reddit Report/Crypto_Reddit.csv")
crypto_market.df <- read.csv("~/GitHub/NextBigCrypto-Senti/1. Crawlers/2b. Reddit Report/CryptoMarkets_Reddit.csv")

processed.crypto <- clean_reddit(crypto.df)
processed_market.crypto <- clean_reddit(crypto_market.df)

#======================================================================

# EDA
# link_flair_all <- dplyr::summarize(dplyr::group_by(processed.reddit,link_flair_text,link_flair_css_class),n())
# link_flair_css <- dplyr::summarize(dplyr::group_by(processed.reddit,link_flair_css_class),n())
# link_flair_text <- dplyr::summarize(dplyr::group_by(processed.reddit,link_flair_text),n())
# 
# num_com <- dplyr::summarize(dplyr::group_by(processed.reddit,num_comments),n())
# num_scores <- dplyr::summarize(dplyr::group_by(processed.reddit,score),n())
# 
# # EDA author flairs
# author_flair_css <- dplyr::summarize(dplyr::group_by(processed.reddit,author_flair_css_class),n())
# 
# # ---------------------------------
# # Binning Scores (for later classification results comparison)
# # For scores
# scores <- processed.reddit[,which(names(processed.reddit) %in% c("id","score"))]
# 
# scores_binning <- discretize(scores$score,
#                              disc = "equalfreq",
#                              10)
# scores_binning <- cbind(scores,scores_binning)
# 
# # For No. of comments
# comments <- processed.reddit[,which(names(processed.reddit) %in% c("id","num_comments"))]
# 
# comments_binning <- discretize(comments$num_comments,
#                                disc = "equalfreq",
#                                10)
# comments_binning <- cbind(comments,comments_binning)

# Warning: unable to move temporary installation error
# Due to antivirus + company policy
# Change line 140 from Sys.sleep(0.5) to Sys.sleep(2)
# trace(utils:::unpackPkgZip, edit=TRUE)