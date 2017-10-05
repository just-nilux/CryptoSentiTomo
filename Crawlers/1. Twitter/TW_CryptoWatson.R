# Steps
# 1. Get tweets update from @CryptoWatson
# 2. OCR to get data from 1-hr sentiments


# Set up working directory
setwd("C:/Users/BluePhoenix/Documents/GitHub/NextBigCrypto-Senti/Crawlers")

# Clear environment
rm(list = ls())

# get functions from pre-defined file
source("1.TW_Functions.R")

# Read from the past
watsondf <- read.csv("CryptoWatson.csv")

# drop 1st column and clean NA
watsondf <- watsondf[,!colnames(watsondf) == "X"]
watsondf <- watsondf[!is.na(watsondf$created_at),]
watsondf$created_at <- parse_date_time(watsondf$created_at, c("ymd HMS"))

# Webpage scrapping and image extraction--------------------------
as.character(watsondf$media_url[nrow(watsondf)])

# Extract test
url <- paste0(as.character(watsondf$media_url[nrow(watsondf)]))

ocr_result <- image_read(url) %>%
              image_resize("5000") %>%
              image_convert(colorspace = 'gray') %>%
              image_trim() %>%
              image_ocr()
print(image_read(url))
cat(ocr_result)

