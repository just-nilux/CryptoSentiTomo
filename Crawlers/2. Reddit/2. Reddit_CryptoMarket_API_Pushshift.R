# Try APIs call on https://elasticsearch.pushshift.io

#Set up working directory
#setwd("C:/Users/BluePhoenix/Documents/GitHub/NextBigCrypto-Senti/Crawlers")
setwd("~/GitHub/NextBigCrypto-Senti/Crawlers")

# Clear environment
rm(list = ls())

# install packages if not available
packages <- c("jsonlite","httr", # support API call
              "dplyr")

if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))
}
lapply(packages, require, character.only = TRUE)

#--------------------------------#
# GENESIS CODE (run only 1 time) #
#--------------------------------#
# 
# url <- "https://api.pushshift.io"
# path <- "/reddit/search/submission/"
# query <- "?q=&subreddit=cryptomarkets&before=1509647464&stickied=false&locked=false&is_video=false&size=500"
# 
# # Extract Reddit submissions using filters
# # - Subreddit = cryptomarkets
# # - From 1st Jan - Now (epoch time)
# # - No sticked, locked and video submissions
# # - Size = 500 (maximum per call)
# 
# raw_data <- GET(url = url,
#                 path = path,
#                 query = query)
# names(raw_data)
# raw_data$status_code #if status = 200 -> fine
# 
# test <- rawToChar(raw_data$content)
# 
# # extract JSON type from raw_data
# extract.data <- fromJSON(test)
# class(extract.data)
# 
# # convert to dataframe
# reddit.df <- do.call(what = "rbind",
#                      args = lapply(extract.data, as.data.frame))
# # drop nested columns
# reddit.df <- reddit.df[ , -which(names(reddit.df) %in%
#                                    c("media","media_embed","preview",
#                                      "secure_media","secure_media_embed"))]
# report_path <- '2b. Reddit Report/'
# # save genesis dataset
# write.csv(reddit.df,paste0(report_path,'CryptoMarkets_Reddit.csv'))

#---------------------------------------------------------------------

# Convert epoch time
unix2POSIXct <- function(time) structure(time, class = c("POSIXt", "POSIXct"))

# Develop function to re-loop crawl from pushshift.io
# base on last epoch date available in the dataset up to current date

crawl_reddit_pushshift <- function(epoch){
  url <- "https://api.pushshift.io"
  path <- "/reddit/search/submission/"
  query <- "?q=&subreddit=cryptocurrency&stickied=false&locked=false&is_video=false&size=500"
  
  # query results after epoch time
  query <- paste0(query,'&before=',epoch)
  
  # extract data from API
  raw_data <- GET(url = url,
                  path = path,
                  query = query)
  
  # will implement confirm mechanism later if status code <> 200
  raw_data$status_code #if status = 200 -> fine
  
  char_data <- rawToChar(raw_data$content)
  
  # extract JSON type from raw_data
  extract.data <- fromJSON(char_data)
  
  # convert to dataframe
  final.df <- do.call(what = "rbind",
                      args = lapply(extract.data, as.data.frame))
  # drop nested columns 
  final.df <- final.df[ , -which(names(final.df) %in% 
                                   c("media","media_embed","preview",
                                     "secure_media","secure_media_embed"))]
  return(final.df)
}

end_epoch <- as.numeric('1483228800') #1st Jan 00:00

# Continue to crawl Reddit until epoch time reach 1st Nov
repeat{
  
  # Extract data from previous report
  report_path <- '2b. Reddit Report/'
  old.df <- read.csv(paste0(report_path,"CryptoMarkets_Reddit.csv"))
  old.df <- old.df[ , -which(names(old.df) %in% c("X"))]
  
  # extract latest epoch time from old dataset
  min_epoch <- as.numeric(min(old.df$created_utc))
  
  # Start crawling and save to "Crypto_Reddit.csv"
  new.df <- crawl_reddit_pushshift(min_epoch)
  
  final.df <- bind_rows(old.df,new.df)
  
  # Save new.df base on epoch
  write.csv(new.df,paste0(report_path,'CryptoMarkets_Reddit_',
                          substr(unix2POSIXct(min_epoch),0,10)
                          ,'.csv'))
  
  print(substr(unix2POSIXct(min_epoch),0,10))
  
  # Overwrite final file
  write.csv(final.df,paste0(report_path,'CryptoMarkets_Reddit.csv'))
  if(min_epoch <= end_epoch){
    break
  }
}

# -------------------------------------------------------------
# Can only crawl back until 3rd May 2017 due to API limitation
