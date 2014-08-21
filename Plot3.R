## R Code to construct a plot to answer Question 3: 
## Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
## which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
##
## This script reads in the the National Emissions Inventory (NEI) data for 1999, 2002, 2005, and 2008.
## It subsets the data for Baltimore City and uses ggplot to (compute and) plot the total emissions by 
## type between 1999 and 2008. It facets the data by source and annotates the data with horizontal
## lines showing the 1999 values for each sector, to make the increase/decrease clearer.

library(ggplot2)
library(plyr)

# Set working directory
setwd("~/Documents/MOOCs/Data Science Specialization/Course4_Exploratory-Data-Analysis/Projects/ExData_Plotting2")

# Assume the data has been downloaded to ./exdata-data-NEI_data
# Read in the data and the classification codes from R object files
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

# Subset the data for Baltimore
baltimore <- NEI[NEI$fips == "24510",]


# Create a data frame to add a horizontal line to each facet (showing total emissions by type in 1999)
hline.data <- ddply(baltimore[baltimore$year==1999,], .(type), summarize, sum=sum(Emissions))

# Create the ggplot plot -- tell ggplot about the data and the aesthetics mapping
b <- ggplot(baltimore, aes(year, Emissions))
# Summarize the emissions data and separate by type
b <- b + stat_summary(fun.y = "sum", geom = "line") + facet_grid(.~type)
# Add a horizontal line to show the emissions in 1999 so we can see how emissions changed between 1999-2008
b <- b + geom_hline(aes(yintercept=sum), colour="#9999CC", hline.data)
# Add labels
b <- b + labs(title="Baltimore City Emissions by Type, 1999-2008", x="Year", y="Emissions (tons)")

# Draw the plot
png(file="Plot3.png", height=480, width=640)  # Open graphics device and adjust width
b                                             # Print plot
dev.off()                                     # Close graphics device


###
### Alternatives
###

# Use color to separate groups
# This is good to understand the relative changes, but harder to see what happens for an
# individual emission type
b <- ggplot(baltimore, aes(year, Emissions, colour=type))
b + stat_summary(fun.y = "sum", geom = "line")

###
### Answer
###
### From the plot we can see that between 1999 and 2008, the non-road, non-point, and on-road
### emissions decreased, while point emissions increased slightly (point emissions increased sharply
### betweem 1999 and 2005, and then decreased to just above 1999 levels).
