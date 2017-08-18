#Set up working directory
setwd("C:/Users/BluePhoenix/Documents/GitHub/NextBigCrypto-Senti/Crawlers")

# install packages if not available
x <- c("tm", "SnowballC", "caTools", "rpart", 
       "rpart.plot", "randomForest","data.table",
       "dplyr","h2o","RedditExtractoR","plyr")

if (length(setdiff(x, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(x, rownames(installed.packages())))
}

x <- as.list(x)
#initializing required libraries
for (i in 1:length(x)){
lapply(x, FUN = function(X) {
  do.call("require", x[i])
})
}

#############################################