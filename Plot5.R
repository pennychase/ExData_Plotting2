## R Code to construct a plot to answer Question 5: 
## How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
##
## First we need to identify motor vehicle sources. The 2008 National Emissions Inventory, 
## version 3 Technical Support Document (http://www.epa.gov/ttn/chief/net/2008neiv3/2008_neiv3_tsd_draft.pdf), the EPA
## describes the sectors the EPA uses to summarize emissions sources. The on-road mobile sources consist
## of four sectors which "include emissions from motorized vehicles that are normally operated on 
## public roadways." (p. 113) So we will use the four on-road mobile sources to identify motor vehicles.
##
## To answer the question about trends of motor vehicle emissions, we will look at the trends of
## the four on-road sectors: diesel heavy-duty vehicles, diesel light-duty vehicles, gasoline heavy-duty
## vehicles, and gasoline light-duty vehicles. We could simply look at the total emissions across the four
## sectors, but we already have done that in Plot 3 (the on-road type facet). The four sectors is the
## way EPA summarizes the data and it strikes a balance: the other SCC hierarchical groupings either offer
## fewer bins (SCC.Level.Two has 2), more bins (SCC.Level.Three has 13), or no clear relevant categories.
##
## This script reads in the the National Emissions Inventory (NEI) data for 1999, 2002, 2005, and 2008.
## It subsets the Baltimore City data and then subsets the mobile on-road emission sources. It then
## uses ggplot to plot a time series of emissions from motor vehicle sources by sector for 
## Baltimore City, 1999 - 2008.
##
## From the graph we can see that motor vehicles emissions from all sectors in Baltimore City declined 
## from 1999 to 2008, but at different rates, with some sectors increasing slightly between 2002
## and 2005.

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

# Merge the baltimore and SCC data sets to facilitate subsetting
baltimmoreFull <- join(baltimore, SCC, by="SCC")

# Subset the motor vehicle emission sources (EI.Sector is one of the "Mobile - On-Road" sectors)
baltimoreOnroadEmissions <- baltimoreFull[grepl("Mobile - On-Road", baltimoreFull$EI.Sector), ]

# Create the ggplot plot -- tell ggplot about the data and the aesthetics mapping
# Use color to separate the four motor vehicle sectors
b <- ggplot(baltimoreOnroadEmissions, aes(year, Emissions, colour=EI.Sector))
# Use stat_summary() to plot the sum of the y values (i.e., the total emissions of the sector) 
b <- b + stat_summary(fun.y = "sum", geom = "line")
# Add labels
b <- b + labs(title="Baltimore Motor Vehicle Emissions, 1999-2008", x="Year", y="Emissions (tons)")

# Draw the plot
b

