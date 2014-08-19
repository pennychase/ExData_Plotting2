## R Code to construct a plot to answer Question 5: 
## How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
##
## According to the 2008 National Emissions Inventory, version 3 Technical Support Document 
## (http://www.epa.gov/ttn/chief/net/2008neiv3/2008_neiv3_tsd_draft.pdf), the EPA
## defines two categories of mobile emission sources: on-raod and non-road. The non-road sources
## include "lawn and garden equipment, construction equipment, engines used in recreational activities, 
## portable industrial, commercial, and agricultural engines."(p. 107) The on-road mobile sources consist of 
## four sectors, which "include emissions from motorized vehicles that are normally operated on 
## public roadways. This includes passenger cars, motorcycles, minivans, sport-utility vehicles, 
## light- duty trucks, heavy-duty trucks, and buses. The sectors include emissions from parking 
## areas as well as emissions while the vehicles are moving."(p. 113)
## Based on these definitions, we will consider motor vehicles to be mobile on-road emission sources.
##
## This script reads in the the National Emissions Inventory (NEI) data for 1999, 2002, 2005, and 2008.
## It subsets the Balitmore City data, and then subsets the mobile on-road emission sources. It then
## uses ggplot to plot a time series of motir vehicle emissions for Baltimore City, 1999 - 2008.
##
## From the graph we can see that motor vehicles emissions declined slightly from 1999 to 2008, 
## although there was an increase from 1999 to 2005.

library(ggplot2)
library(plyr)

# Set working diectory
setwd("~/Documents/MOOCs/Data Science Specialization/Course4_Exploratory-Data-Analysis/Projects/ExData_Plotting2")

# Assume the data has been downloaded to exdata-data-NEI_data
# Read in the data and the classification codes from R object files
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

# Subset the data for Baltimore
baltimore <- NEI[NEI$fips == "24510",]

# Create the index vector to subset motor vehicles (on-road mobile sector)
onroadMobileSector <- grepl("On-Road", levels(SCC$EI.Sector)) # SCC$EI.Sector groups the sources into sectors
onroadMobileSCC <- SCC$SCC[onroadMobileSector] # Get the SCC codes for the on-road mobile sector

# Subset the motor vehicle emissions from the Baltimore data set 
baltimoreOnroadEmissions <- baltimore[baltimore$SCC %in% onroadMobileSCC ,]

# Create the ggplot plot -- tell ggplot about the data and the aesthetics mapping
b <- ggplot(baltimoreOnroadEmissions, aes(year, Emissions))
# Use stat_summary() to plot the summary of the y values (i.e., the on-road mobile emissions)
b <- b + stat_summary(fun.y = "sum", geom = "line")
# Add labels
b <- b + labs(title="Baltimore Motor Vehicle Emissions, 1999-2008", x="Year", y="Emissions (tons)")

# Draw the plot
b

