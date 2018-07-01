# Getting and Cleaning Data - Human Activity Data

## Contents
This repository contains 7 R scripts and 6 png plot files:
- CodeBook.md - document that describes the variables, data, and transformations
- downloadData.R - code that downloads and unzips the emissions data
- plot1.R - plots total US emission by year (output: plot1.png)
- plot2.R - plots Baltimore emissions by year (output: plot2.png)
- plot3.R - plots Baltimore emissions by collection source type (output: plot3.png)
- plot4.R - plots US coal combustion related emissions by year (output: plot4.png)
- plot5.R - plots Baltimore motor vehicle related emissions by year (output: plot5.png)
- plot6.R - plots Baltimore and LA motor vehicle related emissions by year (output: plot6.png)

## Analysis

The R ``downloadData.R`` script downloads and unzips the data. While the ```plot*.R``` scripts perform various exploratory data analysis and plotting of the emissions data.


## How to use *.R

Run ```source("downloadData.R")``` to download and unpack the emissions data. 

Unpacked data files:
- summarySCC_PM25.rds - the emissions data by fips location code, SCC emission code, Pollutant, Emissions value, collection type, and year
- Source_Classification_Code.rds - the table explaining each SCC emission code


Run ```plot*.R``` to plot the data and write the output plots to a corresponding png file ```plot*.png``` in your working directory.



### Dependencies
```plot*.R``` depends on ```dplyr``` and ```gpplot2. If not installed, it will download and install the these packages.

