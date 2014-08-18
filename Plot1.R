## R Code to construct a plot to answer Question 1: 
## Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
##
## This script reads in the the National Emissions Inventory (NEI) data for 1999, 2002, 2005, and 2008.
## It computes the total emissions by year, and uses the base plotting system to plot a time series
## graph of the total emissions by year.
##
## From the graph we can see that total emissions declined from over 7,000,000 tons in 1999 to
## below 3,500,000 tons in 2008.

# Set working diectory
setwd("~/Documents/MOOCs/Data Science Specialization/Course4_Exploratory-Data-Analysis/Projects/ExData_Plotting2")

# Assume the data has been downloaded to exdata-data-NEI_data
# Read in the data and the classification codes from R object files
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

# Compute the total emissions by year
te <- tapply(NEI$Emissions, NEI$year, sum)
# Convert result to a data frame
totalEmissions <- data.frame(Year=as.Date(names(te), "%Y"), Emissions=as.vector(te))

# Plot as a time series: type="l" draws lines
with(totalEmissions, plot(Year, Emissions, type="l", ylab="Emissions"))




###
### Using ggplot (project called for base plot)
###
library(ggplot2)

# Create the basic plot of year and Emissions
n <- ggplot(NEI, aes(year, Emissions))
# Use stat_summary() to plot the summary of the y values (i.e., the Emissions)
# Plot the points as well as the lines to make clear which years we have data
n + stat_summary(fun.y = "sum", geom = "line") + stat_summary(fun.y = "sum", geom = "point")