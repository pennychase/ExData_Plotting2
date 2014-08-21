## R Code to construct a plot to answer Question 6: 
## Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle 
## sources in Los Angeles County, California. Which city has seen greater changes over time in 
## motor vehicle emissions?
##
## First we need to identify motor vehicle sources. The 2008 National Emissions Inventory, 
## version 3 Technical Support Document (http://www.epa.gov/ttn/chief/net/2008neiv3/2008_neiv3_tsd_draft.pdf)
## describes the sectors the EPA uses to summarize emissions sources. The on-road mobile sources consist
## of four sectors which "include emissions from motorized vehicles that are normally operated on 
## public roadways." (p. 113) So we will use the four on-road mobile sources to identify motor vehicles.
##
## To answer the question about trends of motor vehicle emissions, we will look at the trends of
## the four on-road sectors: diesel heavy-duty vehicles, diesel light-duty vehicles, gasoline heavy-duty
## vehicles, and gasoline light-duty vehicles. The four sectors is the way EPA summarizes the data 
## and it strikes a balance: the other SCC hierarchical groupings either offer fewer bins 
## (SCC.Level.Two has 2), more bins (SCC.Level.Three has 13), or no clear relevant categories.
##
## This script reads in the the National Emissions Inventory (NEI) data for 1999, 2002, 2005, and 2008.
## It subsets the Baltimore City data and Los Angeles County data and then subsets the mobile on-road 
## emission sources. It then uses ggplot to plot a matrix of time series of emissions from motor vehicle
## sources by region (Baltimore / Los Angeles) x sector for 1999 - 2008

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
baltimore$region <- "Baltimore"

# Subset the data for Los Angeles
losangeles <- NEI[NEI$fips == "06037", ]
losangeles$region <- "Los Angeles"

# Merge the data for Baltimore and Los Angeles
baltAndLA <- rbind(baltimore, losangeles)

# Merge the baltimore/loasangeles and SCC data sets to add the SCC categories to facilitate 
# subsetting and plotting
baltAndLAFull <- join(baltAndLA, SCC, by="SCC")

# Subset the motor vehicle emission sources (EI.Sector is one of the "Mobile - On-Road" sectors)
baltAndLAOnroadEmissions <- baltAndLAFull[grepl("Mobile - On-Road", baltAndLAFull$EI.Sector), ]

# For creating a horizontal line at the value of the emissions for 1999
# Create the data frame of the 1999 values for each region and sector
hline.data <- ddply(baltAndLAOnroadEmissions[baltAndLAOnroadEmissions$year==1999,], 
                    .(region, EI.Sector), summarize, Emissions=log10(sum(Emissions)))

# logsum is the function that will be used in stat_summary
# stat_summary expects a data frame with three variables: y, ymin, ymax
logsum <- function (x) {
  log10Sum <- log10(sum(x))
  triplet <- data.frame(y=log10Sum, ymin=log10Sum, ymax=log10Sum)
}

# Create a matrix of plots: region by sector
#
# Create the ggplot plot -- tell ggplot about the data and the aesthetics mapping
b.la <- ggplot(baltAndLAOnroadEmissions, aes(year, Emissions))

# Use stat_summary() to plot the sum of the y values (i.e., the total emissions of the sector) 
# Do a log10 transform of the sums because the LA emissions are so much larger than the 
# Baltimore emissions (without the transform the Baltimore values are compressed)
b.la <- b.la + stat_summary(fun.data = logsum, geom = "line")

# Facet by EI.Sector x region so each sector source lines up side by side (to better compare
# the magnitudes of the emissions in each region)
b.la <- b.la + facet_grid(EI.Sector ~ region)

# Add the horizontal line showing the emissions for 1999
b.la <- b.la + geom_hline(aes(yintercept=Emissions), colour="#9999CC", hline.data)

# Add labels
b.la <- b.la + labs(title="Baltimore City and Los Angeles County Motor Vehicle Emissions, 1999-2008", 
                    x="Year", y=expression(paste(log[10], " ", PM[2.5], " Emissions (tons)")))

# Draw the plot
png(file="Plot6.png", height=960, width=540)    # Open graphics device and adjust width and height
b.la               # Print plot
dev.off()          # Close graphics device


###
### Some exploration (sanity checking) to make sure log10 transform makes sense
###
# Create a data frame showing the total emissions by region x sector for each year
data2008 <- ddply(baltAndLAOnroadEmissions[baltAndLAOnroadEmissions$year==2008,], 
                  .(region, EI.Sector), summarize, sum=sum(Emissions))
data1999 <- ddply(baltAndLAOnroadEmissions[baltAndLAOnroadEmissions$year==1999,], 
                  .(region, EI.Sector), summarize, sum=sum(Emissions))
# Compute the percent change
data2008$change <- (data2008$sum - data1999$sum)/data1999$sum

### Alternative plots
###

# Create a plot separated by region with each plot showing the trends of the sectors
#
# Create the ggplot plot -- tell ggplot about the data and the aesthetics mapping
# Use color to separate the four motor vehicle sectors
b.la <- ggplot(baltAndLAOnroadEmissions, aes(year, Emissions, colour=EI.Sector))
# Use stat_summary() to plot the sum of the y values (i.e., the total emissions of the sector) 
b.la <- b.la + stat_summary(fun.y = sum, geom = "line")
# Facet by region
b.la <- b.la + facet_grid(. ~ region)
# Add labels
b.la <- b.la + labs(title="Baltimore and Los Angeles Motor Vehicle Emissions, 1999-2008", x="Year", y="Emissions (tons)")

# Draw the plot
b.la

# Create a plot separated by sector with each plot showing the trends of each region
#
# Create the ggplot plot -- tell ggplot about the data and the aesthetics mapping
# Use color to separate the regions
b.la <- ggplot(baltAndLAOnroadEmissions, aes(year, Emissions, colour=region))
# Use stat_summary() to plot the sum of the y values (i.e., the total emissions of the sector) 
b.la <- b.la + stat_summary(fun.y = sum, geom = "line")
# Facet by sector
b.la <- b.la + facet_grid(. ~ EI.Sector)
# Add labels
b.la <- b.la + labs(title="Baltimore and Los Angeles Motor Vehicle Emissions, 1999-2008", x="Year", y="Emissions (tons)")

# Draw the plot
b.la

###
### Final Plot (before tweaks)
###

# This was the final alternative, a matrix of plot, region x sector.
# The first problem was that the Emissions for LA were so much larger than for
# Baltimore, that when ggplot drew them on the same, changes in Baltimore were almost flat.
# So we transform the emissions with log10
# The second problem was it was hard to see the relative magintudes of the emissions in
# the region by sector plot matrix, so we switch the matrix to be sector by region
# (so the emissions for each sector are side by side)

# Create a matrix of plots: region by sector
#
# Create the ggplot plot -- tell ggplot about the data and the aesthetics mapping
b.la <- ggplot(baltAndLAOnroadEmissions, aes(year, Emissions))
# Use stat_summary() to plot the sum of the y values (i.e., the total emissions of the sector) 
# Take log10 of the sums because the LA emissions are so much larger than the Baltimore emissions
# (so plotting the sums will compress the Baltimore values since ggplot will fit both on
# the same scale).
b.la <- b.la + stat_summary(fun.y = sum, geom = "line")
# Facet by region x sector
b.la <- b.la + facet_grid(region ~ EI.Sector)
# Add labels
b.la <- b.la + labs(title="Baltimore City and Los Angeles County Motor Vehicle Emissions, 1999-2008", 
                    x="Year", y=expression(paste("Emissions (tons)")))

###
### Answer
###
### From the plots we can see that on-road diesel light duty vehicle emissions and on-road gasoline heavy 
### duty vehicle emissions are low in both regions with little change over the tie period. On-road diesel
### vehicle emissions declined in Baltimore and increased in Los Angeles (though dropping from a high 
### in 2005). On-road Gasoline light duty behicle emissions declined somewhat in Baltimore, and experienced 
### a greater decline in Los Angeles, although it declined, increased, and then declined.