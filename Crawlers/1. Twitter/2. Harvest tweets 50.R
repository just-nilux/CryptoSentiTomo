# Objectives
# 1. Obtain list of coins + tickers
# 2. Crawl tweets related (2 weeks backward)
# 3. Store in separate folder for analysis

# Obtain list of coins --> extract tickers + coin names 
# devtools::install_github("amrrs/coinmarketcapr")
library(coinmarketcapr)
latest_marketcap <- get_marketcap_ticker_all('EUR')
str(latest_marketcap)
coins_list <- latest_marketcap[,which(names(latest_marketcap) %in% c("name","symbol"))]
coins_list$ticker <- paste0('$',coins_list$symbol)
# Take only top 100
coins_list <- coins_list[1:50]

#Setting the Twitter authentication0
consumer_key <- 'cdi1LlwgzdXzR4Wxz8T3Gude6'
consumer_secret <- 's3hpLYXs9ULY1YwzyTRP8aRovp3rvkjUM9ue9usi8MotrvUgOG'
access_token <- '240771509-MQiqGMegj3B4ohmRSi7mThfprMg7j9lAYkDB3s9W'
access_token_secret <- 'YZGMyJ6Jz3Ncx1SG59QXJGaRrEkYjvCTC71KPsFH2eaIi'
setup_twitter_oauth(consumer_key,consumer_secret,access_token,access_token_secret)

# Harvest Tweets of tickers
BTC <- search_tweets(coins_list$ticker[1], 
                     n = 10000,
                     type = 'recent',
                     lang = 'en',
                     since = '2017-10-01',
                     include_rts = FALSE,
                     retryonratelimit = TRUE)

BTC2 <- search_tweets(coins_list$ticker[1], 
              n = 10000,
              type = 'recent',
              lang = 'en',
              until = '2017-10-03',
              include_rts = FALSE,
              retryonratelimit = TRUE)