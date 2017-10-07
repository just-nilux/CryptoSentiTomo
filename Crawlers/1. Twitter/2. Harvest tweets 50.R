# Objectives
# 1. Obtain list of coins + tickers
# 2. Crawl tweets related (2 weeks backward)
# 3. Store in separate folder for analysis


# Set up working directory
setwd("C:/Users/BluePhoenix/Documents/GitHub/NextBigCrypto-Senti/Crawlers")
source("1.TW_Functions.R")
# 1. Get coin list --------------------------------------------
# Obtain list of coins --> extract tickers + coin names 
# devtools::install_github("amrrs/coinmarketcapr")
library(coinmarketcapr)

# latest_marketcap <- get_marketcap_ticker_all('EUR')
# 
# coins_list <- latest_marketcap[,which(names(latest_marketcap) %in% c("name","symbol"))]
# coins_list$ticker <- paste0('$',coins_list$symbol)s
# 
# # Take only top 50 (Oct 7)
# coins_list <- coins_list[1:50,]
# write.csv(coins_list,"Top50_Oct7.csv")

coins_list <- read.csv("Top50_Oct7.csv")
#---------------------------------------------------------------

# Function to crawl tweets for top 50 tickers
get_tweets <- function(ticker,n){
  since7 = Sys.Date()-7
  path = '1b. Report/'
  df <- search_tweets(ticker,
                      n,
                      type = 'recent',
                      lang = 'en',
                      since = since7,
                      include_rts = FALSE,
                      retryonratelimit = TRUE)
  write.csv(df,paste0(path,ticker,'_',Sys.Date(),'.csv'))
}

for (i in 1:nrow(coins_list)){
  get_tweets(coins_list$ticker[i],100000)
}


# # loop to collect more tweets (>18k)
# n <- 5 #number of loops
# s <- vector("list", n)
# max_id <- NULL
# for (i in seq_len(n)) {
#   s[[i]] <- search_tweets("supermax", n = 20000, since_id = max_id)
#   since_id <- tail(s[[i]]$user_id, 1)
#   sys.Sleep(60 * 15)
# }
# # should use this instead of normal rbind
# do.call(rbind.data.frame, s)