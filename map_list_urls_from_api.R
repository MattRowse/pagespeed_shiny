# https://www.r-bloggers.com/accessing-apis-from-r-and-a-little-r-programming/

# have a go at programmatic api calls pagespeed
library(httr)
library(tidyverse)
library(data.table)

# save the key
key <- ""

# save endpoint
pagespeed <-  "https://www.googleapis.com/pagespeedonline/v5/runPagespeed"

# create list of urls
urls <- c("https://google.com", "https://bing.com")

# desktop or mobile
strategy <- "desktop"

# helper function
makeQuery <- function(classifier) {
  this.query <- list(classifier)
  names(this.query) <- "url"
  return(this.query)
}

# create list of queries
queries <- lapply(as.list(urls), makeQuery)

#this.raw.result <- GET(url = pagespeed, query = queries[[1]],verbose())

# this.raw.result <- GET(url = pagespeed, 
#                        query = queries[[1]],
#                          strategy=strategy,
#                          key=key,
#                          verbose(),
#                        Sys.sleep(5))

#this.result <- fromJSON(rawToChar(this.raw.result$content))

# create location to store results
all.results <- vector(mode   = "list",
                      length = length(urls))
# loop over the calls
for (i in 1:length(all.results)) {
  this.query       <- queries[[i]]
  this.raw.answer  <- GET(url = pagespeed, query = this.query)
  this.answer      <- fromJSON(rawToChar(this.raw.answer$content))
  all.results[[i]] <- this.answer
  message(".", appendLF = FALSE)
  Sys.sleep(time = 10)
}

# helper function to unlist api response
f <- function(x)
  if(is.list(x)) {
    unlist(lapply(x, f))
  } else {
    x[which(is.null(x))] <- NA
    paste(x, collapse = ",")
  }

# unlist response and create data frame
df <- as.data.frame(t(do.call(cbind, lapply(all.results, f))))
view(df)

# select required metrics
df <- df %>% select(lighthouseResult.requestedUrl, loadingExperience.metrics.FIRST_CONTENTFUL_PAINT_MS.percentile, loadingExperience.metrics.FIRST_INPUT_DELAY_MS.percentile, loadingExperience.metrics.LARGEST_CONTENTFUL_PAINT_MS.percentile)
