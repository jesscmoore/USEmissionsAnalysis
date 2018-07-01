# plot3.R

# Finds emissions by source type by year in Baltimore City to determine which
# source types have increased and decreased, and plots the time series to png file
# Answer:
# Decreasing types: Non-point, non-road, on-road
# Increasing types: Point

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

# Q3. Of the four types of sources indicated by the type (point, nonpoint, 
# onroad, nonroad) variable, which of these four sources have seen decreases 
# in emissions from 1999–2008 for Baltimore City? Which have seen increases 
# in emissions from 1999–2008? 
# Use the ggplot2 plotting system to make a plot answer this question.

## Analysis

# 1. Group by year to find totals by year.
cat("\nSummarizing Baltimore data by source type and year...\n")

Baltimore_by_years <- NEI %>%
  filter(fips=="24510") %>%
  select(type, Emissions, year) %>%
  group_by(type, year) %>% 
  summarize(count = n(), annual.total = sum(Emissions, na.rm = TRUE)) %>% 
  print


# 2. Plot Baltimore fine particulate matter by type and year
cat("\nPlotting data for each type by year...\n")
p <- ggplot(Baltimore_by_years, aes(x=year, y=annual.total, color=type)) +
  geom_point(shape=1) +
  scale_colour_hue(l=50) + # Use a slightly darker palette than normal
  geom_smooth(method=lm,   # Add linear regression lines
              se=FALSE) + # no confidence shading
  labs(x="Year", y="PM2.5 (tons)",
         title="Baltimore PM2.5 Emissions",
         colour = "Type",
         caption = "(Data source: US EPA National Emissions Inventory)") +
  annotate("text", x = 2008, y = 2000, hjust=1, 
           label="Decreasing types: Non-point, non-road, on-road") +
  annotate("text", x = 2008, y = 1850, hjust=1, label="Increasing types: Point")
plot(p)

# Save to PNG file
filename = "plot3.png"
png(file = filename) ## Open PNG device
plot(p)
dev.off() ## Close the PNG file device
cat("\nWrote png of Baltimore emissions for each type by year to ",filename,"\n")

