# plot6.R

# Analysis of emissions from motor vehicle sources in Baltimore and LA over 
# 1999–2008, and plots the time series to png file
# 

setwd("/Users/jesscobrien/Documents/code/Coursera/ExploratoryDataAnalysis/Project2")

# check if dplyr package is installed
if (!"dplyr" %in% installed.packages()) {
  install.packages("dplyr")
}
library(dplyr)

# check if ggplot2 package is installed
if (!"ggplot2" %in% installed.packages()) {
  install.packages("ggplot2")
}
library(ggplot2)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


# Q5. How have emissions from motor vehicle sources changed from 1999–2008 
# in Baltimore City and LA?
# Showing with a plot

## Analysis

# # Create a vector of SCC codes for motor vehicle related sources
cat("\nExtracting the motor vehicle codes from the code list...\n")
collist <- names(SCC)
sel <- apply(SCC[,collist],1,function(row) length(grep("*Vehicle*",row))>0)
MVOnly <- SCC[sel,]


# 1. Group by year to find totals by year.
cat("\nSummarizing data by year...\n")
MV_by_years <- NEI %>%
  filter(SCC %in% MVOnly$SCC & (fips=="24510" | fips=="06037")) %>%
  select(SCC, fips, Emissions, year) %>%
  group_by(fips,year) %>% 
  summarize(count = n(), annual.total = sum(Emissions, na.rm = TRUE)) %>% 
  print

# Calc change over time
la <- MV_by_years[1:4,]
la_delta <- (la$annual.total[4] - la$annual.total[1])
la_deltapc <- la_delta/la$annual.total[1]*100
la_text <- sprintf("Change in LA: %3.1f tons (%2.1f%s)", la_delta, la_deltapc, "%")

ba <- MV_by_years[5:8,]
ba_delta <- (ba$annual.total[4] - ba$annual.total[1])
ba_deltapc <- ba_delta/ba$annual.total[1]*100
ba_text <- sprintf("Change in Baltimore: %3.1f tons (%2.1f%s)", ba_delta, ba_deltapc, "%")

# 2. Plot motor vehicle related Emissions in Baltimore by year
cat("\nPlotting data for motor vehicle related emissions by year...\n")
p <- ggplot(MV_by_years, aes(x=year, y=annual.total, colour=fips)) +
  geom_point() +
  geom_smooth(method = lm, se = FALSE) + 
  labs(x="Year", y="PM2.5 (tons)",
         title="PM2.5 Motor Vehicle Related Emissions",
         colour="FIPS",
         caption = "(Data source: US EPA National Emissions Inventory)") +
  annotate("text", x = 2008, y = 6000, hjust=1, 
           label=la_text) +
  annotate("text", x = 2008, y = 900, hjust=1, label=ba_text)
plot(p)

# Save to PNG file
filename = "plot6.png"
png(file = filename, width=400, height=400) ## Open PNG device
plot(p)
dev.off() ## Close the PNG file device
cat("\nWrote png of motor vehicle related emissions by year to ",filename,"\n")

