# plot2.R

# Finds total emissions by year in Baltimore City to determine if they have
# decreased, and plots the time series to png file
# Shows emissions have decreased in Baltimore

setwd("/Users/jesscobrien/Documents/code/Coursera/ExploratoryDataAnalysis/Project2")

# check if dplyr package is installed
if (!"dplyr" %in% installed.packages()) {
  install.packages("dplyr")
}
library(dplyr)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")

# Q2. Have total emissions from PM2.5 decreased in the Baltimore City, 
# Maryland (fips=="24510") from 1999 to 2008? 
# Use the base plotting system to make a plot answering this question.

## Analysis

# 1. Group by year to find totals by year.
cat("\nSummarizing Baltimore data by year...\n")

Baltimore_by_years <- NEI %>%
  filter(fips=="24510") %>%
  select(fips, Emissions, year) %>%
  group_by(year) %>% 
  summarize(count = n(), annual.total = sum(Emissions, na.rm = TRUE)) %>% 
  print

# Simplify units
Baltimore_by_years <- Baltimore_by_years %>%
  mutate(annual.total.kilotons = annual.total / 10^3) %>%
  print


# 2. Plot Baltimore fine particulate matter by year
cat("\nPlotting data by year...\n")
with(Baltimore_by_years, plot(year, annual.total.kilotons, 
                        xlab="Year", ylab="PM2.5 (thousand tons)",
                        main="Baltimore PM2.5 Emissions"))
model <- lm(annual.total.kilotons ~ year, Baltimore_by_years)
abline(model, lwd = 2)

# Save to PNG file
filename = "plot2.png"
png(file = filename) ## Open PNG device
with(Baltimore_by_years, plot(year, annual.total.kilotons, 
                              xlab="Year", ylab="PM2.5 (thousand tons)",
                              main="Baltimore PM2.5 Emissions"))
model <- lm(annual.total.kilotons ~ year, Baltimore_by_years)
abline(model, lwd = 2)
dev.off() ## Close the PNG file device
cat("\nWrote png of Baltimore emissions by year to ",filename,"\n")

