# plot1.R

# Finds total emissions by year and plots to png file

setwd("/Users/jesscobrien/Documents/code/Coursera/ExploratoryDataAnalysis/Project2")

# check if dplyr package is installed
if (!"dplyr" %in% installed.packages()) {
  install.packages("dplyr")
}
library(dplyr)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")

# Q1. Have total emissions from PM2.5 decreased in the United States from 
# 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.


## Analysis
# Checks
print(str(NEI))

print(summary(NEI))
## Shows no NAs, and a highly skewed emission distribution

# 1. Group by year to find totals by year.
cat("\nSummarizing data by year...\n")

NEI_by_years <- NEI %>%
  select(Emissions, year) %>%
  group_by(year) %>% 
  summarize(count = n(), annual.total = sum(Emissions, na.rm = TRUE)) %>% 
  print

# Simplify units
NEI_by_years <- NEI_by_years %>%
  mutate(annual.total.megatons = annual.total / 10^6) %>%
  print


# 2. Plot total fine particulate matter by year
cat("\nPlotting data by year...\n")
with(NEI_by_years, plot(year, annual.total.megatons, 
                        xlab="Year", ylab="PM2.5 (million tons)",
                        main="Total PM2.5 Emissions in US"))

# Save to PNG file
filename = "plot1.png"
png(file = filename) ## Open PNG device
with(NEI_by_years, plot(year, annual.total.megatons, 
                        xlab="Year", ylab="PM2.5 (million tons)",
                        main="Total PM2.5 Emissions in US"))
dev.off() ## Close the PNG file device
cat("\nWrote png of emissions by year to ",filename,"\n")

