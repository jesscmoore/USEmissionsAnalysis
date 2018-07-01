# plot4.R

# Determine how emissions from coal combustion-related sources changed from 
# 1999–2008 across the US, and plots the time series to png file
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

# Q4. Across the United States, how have emissions from coal 
# combustion-related sources changed from 1999–2008?
# Showing with a plot

## Analysis

# # Create a vector of SCC codes for coal-combustion related sources
cat("\nExtracting the coal codes from the code list...\n")
collist <- names(SCC)
sel <- apply(SCC[,collist],1,function(row) length(grep("Coal",row))>0)
coalOnly <- SCC[sel,c("SCC", "Short.Name")]


# 1. Group by year to find totals by year.
cat("\nSummarizing data by year...\n")
coal_by_years <- NEI %>%
  filter(SCC %in% coalOnly$SCC) %>%
  select(SCC, Emissions, year) %>%
  group_by(year) %>% 
  summarize(count = n(), annual.total = sum(Emissions, na.rm = TRUE)) %>% 
  print


# Simplify units
coal_by_years <- coal_by_years %>%
  mutate(annual.total.kilotons = annual.total / 10^3) %>%
  print

# # Add column with SCC short name # Too many coal SCCs to plot
# cat("\nSCC Add Short.Name from SCC data to the coal subset...\n")
# SCC_group <- factor(coal_by_years$SCC)
# whichCoal <- which(coalOnly$SCC %in% unique(coal_by_years$SCC))
# levels(SCC_group) <- coalOnly$Short.Name[whichCoal]
# coal_by_years$SCC.Name <- SCC_group


# 2. Plot Coal Combustion-related Emissions fine particulate matter by year
cat("\nPlotting data for coal related emissions by year...\n")
p <- ggplot(coal_by_years, aes(x=year, y=annual.total.kilotons)) +
  geom_point() +
  geom_smooth(method = lm, se = FALSE) + 
  labs(x="Year", y="PM2.5 (10^3 tons)",
         title="US PM2.5 Coal Combustion-Related Emissions",
         caption = "(Data source: US EPA National Emissions Inventory)") 
plot(p)

# Save to PNG file
filename = "plot4.png"
png(file = filename, width=400, height=400) ## Open PNG device
plot(p)
dev.off() ## Close the PNG file device
cat("\nWrote png of coal emissions by year to ",filename,"\n")

