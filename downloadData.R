# downloadData.R


setwd("/Users/jesscobrien/Documents/code/Coursera/ExploratoryDataAnalysis/Project2")


## Data download and unzip 
# string variables for file download
fileName <- "EPAdata.zip"
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

# File download verification. If file does not exist, download to working directory.
if(!file.exists(fileName)){
  cat("Downloading data zip file...\n")
  download.file(url,fileName, mode = "wb") # Use "wb" mode for binary file downloads
}

# File unzip verification. Unzip the downloaded file.
cat("Unzipping data file...\n")
unzip(fileName, files = NULL, exdir=".")


