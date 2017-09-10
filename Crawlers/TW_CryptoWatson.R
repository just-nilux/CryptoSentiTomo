# Steps
# 1. Get tweets update from @CryptoWatson
# 2. OCR to get data from 1-hr sentiments
# 3. Setup bot to react trade for top 3 sentiments on Bittrex

# Set up working directory
setwd("C:/Users/BluePhoenix/Documents/GitHub/NextBigCrypto-Senti/Crawlers")

# Clear environment
rm(list = ls())

# install packages if not available
packages <- c('rtweet','twitteR','streamR', 'tesseract', 'abbyyR',
              'data.table','dplyr','scales','ggplot2','taskscheduleR',
              'httr','stringr','rvest')
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))
}
lapply(packages, require, character.only = TRUE)

# Twitter Crawler Setup --------------------------------

#Setting the Twitter authentication1
api_key <- 'yO6HMXQfaAazZfdyOQpPicX0M'
api_secret <- 'wT1lq9bd7WWJjoVw3aHKfdHbpdjxd8r8RKc56fGiQPGRaJgILP'
access_token <- '379008223-8gPeX8OJ5wxjILXYUMxKwTSOH30UJbYdUWNqCE53'
access_token_secret <- 'P3anD6dTrrQb6RUP4Me6HAMpgY8RU9QuORCrGI14f1Wis'
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

# #Setting the Twitter authentication2
# api_key="hNgXlxwQYcL71SxCddwvpTEVf"
# api_secret="ZSXtL7Yq5QwkAvyCnm9hACaC6CosyHUOOnewv2ufL6IG8tQBCU"
# access_token="838380485843763200-pAQXVTl89Dn1Pz2GnQzOacBmJnXPZz6"
# access_token_secret="MtqyBbhUxM0zOTJIuRXUWtZMRmVnnjfFT0rs5X4odItdq"
# setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
# 
# #Setting the Twitter authentication3
# api_key <- "zow0fQ6Lv0j79gx4lDhBKVUDu"
# api_secret = "fp33fr0VBkIIoPzpwgbCPemkZJ1E718TFqb8b86DKd0nVgGFEs"
# access_token = "836598863582617600-Tjmc0MqCtcOZVjx9dto5wSBkdRgxDmh"
# access_token_secret = "57THIHAlttLUf3y8x1P5U2JnQmcDIfDqq8xmZrwgD5Qo6"
# setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

df <- userTimeline('CryptoWatson', n = 3200,
                   excludeReplies = TRUE, #get no replies
                   includeRts = FALSE # exclude Retweets
                   )

#convert to df
watson_df <- twListToDF(df)

#clean duplicates
watson_df <- unique(watson_df)

#filter only '1hr Report' tweets
watson_df <- watson_df[substr(watson_df$text,1,10) == '1hr Report',]
watson_df <- watson_df[order(watson_df$created),]

# extract URLs
url_pattern <- "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+"
watson_df$link <- str_extract(watson_df$text, url_pattern)

#write to file
write.table(watson_df,"CryptoWatson.csv", sep = ",")


# Webpage scrapping and image extraction--------------
url <- "https://t.co/nPs4DT8Lbz"

page <- content(GET(url))

sess <- html_session(url)
imgsrc <- sess %>%
  read_html() %>%
  html_node(xpath = '//*/img') %>%
  html_attr('src')
img <- jump_to(sess, paste0(url, imgsrc))

writeBin(img$response$content, basename(imgsrc))



# Execution every 1 hour --------------
update <- userTimeline('CryptoWatson', n = 100,
                            excludeReplies = TRUE, #get no replies
                            includeRts = FALSE) # exclude Retweets
update <- twListToDF(update)

final_watson <- rbind(watson_df,update)
final_watson <- unique(final_watson)
final_watson <- final_watson[substr(final_watson$text,1,10) == '1hr Report',]
