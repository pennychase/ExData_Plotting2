## R Code to construct a plot to answer Question 2: 
## Have total emissions from PM2.5 decreased in the Baltimore City, Maryland from 1999 to 2008?
##
## This script reads in the the National Emissions Inventory (NEI) data for 1999, 2002, 2005, and 2008.
## It subsets the data for Baltimore City, computes the total emissions by year for Baltimore, and uses 
## the base plotting system to plot a time series graph of the total emissions in Baltimore by year.
##
## From the plot we can see that the total emissions in Baltimore decreased between 1999 and 2008
## (from over 3200 tons to less than 2000 tons), although there was an increase between 2003 and 2005.

# Set working diectory
setwd("~/Documents/MOOCs/Data Science Specialization/Course4_Exploratory-Data-Analysis/Projects/ExData_Plotting2")

# Assume the data has been downloaded to exdata-data-NEI_data
# Read in the data and the classification codes from R object files
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

# Subset the data for Baltimore
baltimore <- NEI[NEI$fips == "24510",]

# Compute the total emissions by year
be <- tapply(baltimore$Emissions, baltimore$year, sum)
# Convert result to a data frame
totalEmissionsBaltimore <- data.frame(Year=as.Date(names(be), "%Y"), Emissions=as.vector(be))

# Plot as a time series: type="l" draws lines
with(totalEmissionsBaltimore, plot(Year, Emissions, type="l", xlab="Year", ylab="Emissions (tons)", 
                                   main="Total Emissions from All Sources for Baltimore, 1999-2008"))


###
### Using ggplot 
###
library(ggplot2)

# Create the basic plot of year and Emissions
b <- ggplot(baltimore, aes(year, Emissions))
# Use stat_summary() to plot the summary of the y values (i.e., the Emissions)
# Plot the points as well as the lines to make clear which years we have data
b + stat_summary(fun.y = "sum", geom = "line")

