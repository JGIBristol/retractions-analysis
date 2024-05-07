#' Script to download country rank data
#' from SJR (based on scopus counts).
#' 
#' Data can be viewed here:
#' https://www.scimagojr.com/countryrank.php?

library(dplyr)
library(tibble)
library(tidyr)
library(readr)
library(httr)
library(readxl)

dir.create('./data/sjr_rankings')
for (year in 1996:2023){
  url <- paste0("https://www.scimagojr.com/countryrank.php?year=", year, "&order=itp&ord=desc&out=xls")
  response <- GET(url)
  
  writeBin(response$content, paste0("data/sjr_rankings/file_", year, ".xlsx"))
  # Pause for 1 second
  Sys.sleep(1)
}

rankings <- list()
i <- 1
for (year in 1996:2023){
  rankings[[i]] <- read_xlsx(paste0("data/sjr_rankings/file_", 
                                    year, ".xlsx"))
  rankings[[i]]$year <- year
  
  i <- i + 1
}
rankings <- rankings %>% bind_rows()
