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

# Reddit data---------------------------------------
reddit.df <- read.csv("~/GitHub/NextBigCrypto-Senti/Crawlers/2b. Reddit Report/Crypto_Reddit.csv")

reddit.df <- reddit.df[ , -which(names(reddit.df) %in% c("X","V1"))]
reddit.df <- unique(reddit.df)

# Clear all NULL columns 
reddit.df <- reddit.df[,colSums(is.na(reddit.df))<nrow(reddit.df)]
# Add created_at column (human intepretation date time)
reddit.df$created_at <- unix2POSIXct(reddit.df$created_utc)
reddit.df$edited_at <- unix2POSIXct(reddit.df$edited)

# Preprocessing ------------------------------------

# Extract subset for EDA
processed.reddit <- reddit.df[,c('id','created_at',
                                 'title','is_self','selftext',
                                 'link_flair_css_class','link_flair_text','num_comments','score','domain',
                                 'author','author_flair_css_class', #only author classes are relevant
                                 'full_link','url')]

# Extract only non-NA data
processed.reddit <- processed.reddit[complete.cases(processed.reddit),]

# Clean data 
# link_flair css -----------------------------
processed.reddit$link_flair_css_class[tolower(processed.reddit$link_flair_css_class) %in% c('general discussion','discussion')] <- 'gdiscussion'

# Delete "mod" flair class data
processed.reddit <- processed.reddit[!(substr(processed.reddit$link_flair_css_class,0,3) =="mod"),]

# Binning Scores (for later classification results comparison)
# For scores
scores <- processed.reddit[,which(names(processed.reddit) %in% c("id","score"))]

scores_binning <- discretize(scores$score,
                             disc = "equalfreq",
                             10)
scores_binning <- cbind(scores,scores_binning)

# For No. of comments
comments <- processed.reddit[,which(names(processed.reddit) %in% c("id","num_comments"))]

comments_binning <- discretize(comments$num_comments,
                             disc = "equalfreq",
                             10)
comments_binning <- cbind(comments,comments_binning)

#======================================================================

# EDA
link_flair_all <- dplyr::summarize(dplyr::group_by(processed.reddit,link_flair_text,link_flair_css_class),n())
link_flair_css <- dplyr::summarize(dplyr::group_by(processed.reddit,link_flair_css_class),n())
link_flair_text <- dplyr::summarize(dplyr::group_by(processed.reddit,link_flair_text),n())

num_com <- dplyr::summarize(dplyr::group_by(processed.reddit,num_comments),n())
num_scores <- dplyr::summarize(dplyr::group_by(processed.reddit,score),n())

# turn all flairs into lower case
processed.reddit$link_flair_css_class <- tolower(processed.reddit$link_flair_css_class)
processed.reddit$link_flair_text <- tolower(processed.reddit$link_flair_text)

# trip whitespace leading/trailing in author flairs
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
processed.reddit$author_flair_css_class <- trim(processed.reddit$author_flair_css_class)

# EDA author flairs
author_flair_css <- dplyr::summarize(dplyr::group_by(processed.reddit,author_flair_css_class),n())

# Warning: unable to move temporary installation error
# Due to antivirus + company policy
# Change line 140 from Sys.sleep(0.5) to Sys.sleep(2)
# trace(utils:::unpackPkgZip, edit=TRUE)