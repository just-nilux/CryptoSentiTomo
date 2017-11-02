#Set up working directory
setwd("~/GitHub/NextBigCrypto-Senti/")

# Clear environment
rm(list = ls())

# Convert epoch time
unix2POSIXct <- function(time) structure(time, class = c("POSIXt", "POSIXct"))

# Reddit data---------------------------------------
reddit.df <- read.csv("~/GitHub/NextBigCrypto-Senti/Crawlers/2b. Reddit Report/Crypto_Reddit.csv")

reddit.df <- reddit.df[ , -which(names(reddit.df) %in% c("X"))]
reddit.df <- unique(reddit.df)

# Clear all NULL columns 
reddit.df <- reddit.df[,colSums(is.na(reddit.df))<nrow(reddit.df)]
# Add created_at column (human intepretation date time)
reddit.df$created_at <- unix2POSIXct(reddit.df$created_utc)
reddit.df$edited_at <- unix2POSIXct(reddit.df$edited)

# Preprocessing ------------------------------------

# Extract subset for EDA
processed.reddit <- reddit.df[,c('id','title','is_self','selftext',
                                 'link_flair_css_class','link_flair_text','num_comments','score','domain',
                                 'author','author_flair_css_class', #only author classes are relevant
                                 'created_at','edited_at',
                                 'full_link','url')]
# EDA
link_flair_all <- dplyr::summarize(dplyr::group_by(processed.reddit,link_flair_text,link_flair_css_class),n())
link_flair_css <- dplyr::summarize(dplyr::group_by(processed.reddit,link_flair_css_class),n())
link_flair_text <- dplyr::summarize(dplyr::group_by(processed.reddit,link_flair_text),n())

# turn all flairs into lower case
processed.reddit$link_flair_css_class <- tolower(processed.reddit$link_flair_css_class)
processed.reddit$link_flair_text <- tolower(processed.reddit$link_flair_text)

# trip whitespace leading/trailing in author flairs
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
processed.reddit$author_flair_css_class <- trim(processed.reddit$author_flair_css_class)

# EDA author flairs
author_flair_css <- dplyr::summarize(dplyr::group_by(processed.reddit,author_flair_css_class),n())

