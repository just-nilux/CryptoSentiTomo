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

crypto_3010     <- get_reddit(
                   search_terms = NA,
                   subreddit = 'CryptoCurrency',
                   page_threshold = 1000,
                   cn_threshold = 0,
                   wait_time = 2 )
# ##############################
# old <- read.csv("./Sub_Crypto_Oct29.csv")
# old <- old[,-1]
# final <- rbind(old,crypto_3010)
# final <- unique(final)
# write.csv(crypto_3010, "Sub_Crypto_Oct30.csv")
# write.csv(final,"Reddit_crypto_full.csv")

#######################

Crypto.Sub <- read.csv("Reddit_crypto_full.csv",
                       as.is = TRUE)
Crypto.Sub <- Crypto.Sub[,-1]

POST("https://ssl.reddit.com/api/v1/access_token",
     body = list(
       grant_type = "password",
       username = "rias_serena",
       password = "147622119!@#"
     ),
     encode = "form",
     authenticate("8BviwD5HYVz1rQ", "	c-BmIfodzs6rSRDOdpsLFEC8amU")
)
