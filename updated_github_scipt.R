library(RJSONIO)
library(gtools)
key <- 
strategy <- "desktop"
#' Speed results for 1 URL
#'
#' The speedfinder function returns the Google Page Speed Insights test results for a single URL as a dataframe.
#' speedfinder("https://www.cars.com","mobile",key)
pagelist <- as.data.frame(c("https://google.com", "https://bing.com"))

speedfinder <- function(url,strategy,key) {
  pid <- RJSONIO::fromJSON(paste0("https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url=",url,"&strategy=",strategy,"&key=",key))
  frame1 <- cbind(as.data.frame(pid[2]),as.data.frame(pid[3]),as.data.frame(pid[5]),as.data.frame(pid[6]))
  rbind.data.frame(data.frame(), frame1,make.row.names=FALSE)
}



speedfinder2 <- function(url,strategy,key) {
  pid <- RJSONIO::fromJSON(paste0("https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url=",url,"&strategy=",strategy,"&key=",key))
  frame1 <- cbind(as.data.frame(pid[2]),as.data.frame(pid[3]),as.data.frame(pid[5]),as.data.frame(pid[6]))
}


speedlist <- function(pagelist,strategy,key) {
  list1 <- lapply(pagelist,speedfinder2,strategy,key)
  suppressWarnings(do.call("smartbind",list1))
}

url <- "https://google.com"
