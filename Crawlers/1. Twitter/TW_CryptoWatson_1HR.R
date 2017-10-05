# Plan to execute in 1-hr cycle --> OCR --> but fail (since the tesseract was not good)


# Set up working directory
setwd("C:/Users/BluePhoenix/Documents/GitHub/NextBigCrypto-Senti/Crawlers")

# Clear environment
rm(list = ls())

# get functions from pre-defined file
source("1.TW_Functions.R")

# Get update reports (will set hourly)
update <- get_report(500)

# Read from the past
watsondf <- read.csv("CryptoWatson.csv")

# drop 1st column and clean NA
watsondf <- watsondf[,!colnames(watsondf) == "X"]
watsondf <- watsondf[!is.na(watsondf$created_at),]
watsondf$created_at <- parse_date_time(watsondf$created_at, c("ymd HMS"))
watsondf <- watsondf[order(watsondf$created_at),]

# Get the latest date in the existing file
max_date <- watsondf$created_at[nrow(watsondf)]

# Obtain only update parts
update$created_at <- parse_date_time(update$created_at, c("ymd HMS"))
update <- update[update$created_at > max_date,]
update <- data.frame(lapply(update, as.character), stringsAsFactors = FALSE)

# Merge to get up-to-date list
watson_final <- rbind(watsondf,update)
watson_final <- unique(watson_final)

#write to file
write.csv(watson_final, "CryptoWatson.csv")
