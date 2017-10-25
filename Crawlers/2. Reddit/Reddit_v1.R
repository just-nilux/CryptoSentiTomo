#Set up working directory
#setwd("C:/Users/BluePhoenix/Documents/GitHub/NextBigCrypto-Senti/Crawlers")
setwd("~/GitHub/NextBigCrypto-Senti/Crawlers")

# Clear environment
rm(list = ls())

# install packages if not available
packages <- c("RedditExtractoR","httr")

if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))
}
lapply(packages, require, character.only = TRUE)

#############################################


CryptoCurrency_subreddit <- get_reddit(search_terms = NA,
                   subreddit = 'CryptoCurrency',
                   page_threshold = 10)
##############################

POST("https://ssl.reddit.com/api/v1/access_token",
     body = list(
       grant_type = "password",
       username = "rias_serena",
       password = "147622119!@#"
     ),
     encode = "form",
     authenticate("8BviwD5HYVz1rQ", "	c-BmIfodzs6rSRDOdpsLFEC8amU")
)
