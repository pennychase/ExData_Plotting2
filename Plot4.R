## R Code to construct a plot to answer Question 4: 
## Across the United States, how have emissions from coal combustion-related sources changed 
## from 1999–2008?
##
## First we need to identify coal combustion-related sources. The 2008 National Emissions Inventory, 
## version 3 Technical Support Document (http://www.epa.gov/ttn/chief/net/2008neiv3/2008_neiv3_tsd_draft.pdf), the EPA
## describes the sectors the EPA uses to summarize emissions sources. The relevant sectors are Fuel Combusiotn 
## Commercial - Coal, Fuel Combustion Electric Generation - Coal, Fuel Combustion Industrial Boiler - Coal,
## and Fuel Combustion Residential - Other. The last sector includes liquid petroleum as well as coal, so
## we'll need to look at the SCCs to separate those out.
##
## To answer the question, we'll actually look at the trends of the different sectors, not just 
## the total emissions.
##
## This script reads in the the National Emissions Inventory (NEI) data for 1999, 2002, 2005, and 2008.
## It subsets the coal combustion related sources using first the EI.Sector variable and then the 
## SCC Short Name variable to remove the liquid petroleum sources. It then uses ggplot to plot a time 
## series of emissions from coal combustion related sources separated by sector for 1999 - 2008. 

library(ggplot2)
library(plyr)

# Set working directory
setwd("~/Documents/MOOCs/Data Science Specialization/Course4_Exploratory-Data-Analysis/Projects/ExData_Plotting2")

# Assume the data has been downloaded to ./exdata-data-NEI_data
# Read in the data and the classification codes from R object files
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

# Create index vector to subset coal combustion-related sources
# SCC$EI.Sector groups the sources into sectors and we want the Fuel Combustion Coal sectors
# In addition, Fuel Combustion Residential Other includes coal sources, as well as liquid petroleum.
coalSCC <- SCC$SCC[grepl("Coal|Residential - Other", SCC$EI.Sector)] 
# Remove the liquid petroleum source SCC
coalSCC <- coalSCC[!coalSCC==SCC$SCC[grepl("Residential.*Petroleum", SCC$Short.Name)]]

# Subset the NEI data set 
coalEmissions <- NEI[NEI$SCC %in% coalSCC,]

# Merge coalEmissions with SCC to add the SCC categories to facilitate plotting
coalEmissionsFull <- join(coalEmissions, SCC, by="SCC")
# Change the name of sector "Fuel Comb - Residential - Other" to "Fuel Comb - Residential - Coal"
levels(coalEmissionsFull$EI.Sector)[levels(coalEmissionsFull$EI.Sector)=="Fuel Comb - Residential - Other"] <- "Fuel Comb - Residential - Coal"

# Plot coal emissions
# Create the mapping to aesthetics (emissions by year separated by EI Sector)
coal <- ggplot(coalEmissionsFull, aes(year, Emissions, colour=EI.Sector))
# Use stat_summary() to plot the summary of the y values (i.e., the emissions)
coal <- coal + stat_summary(fun.y = sum, geom = "line") 
# Add labels
coal <- coal + labs(title="Emissions from Coal Sources, 1999-2008", x="Year", y="Emissions (tons)")

# Plot graph
png(file="Plot4.png", height=480, width=640)   # Open graphics device and adjust width
coal                    # Print the plot
dev.off()               # Close graphics device



###
### Finding coal combustion sources
###

# The EI.Sector for "Fuel Comb - Residential - Other" includes coal. To find out how to identify
# the coal sources first make a subset of the sector
otherSCC <- SCC$SCC[grepl("Fuel Comb - Residential - Other", SCC$EI.Sector)]
other <- NEI[NEI$SCC %in% otherSCC,]
otherFull <- join(other, SCC, by="SCC")

# Get all the short names corresponding to the SCC codes in the sector
x <- table(otherFull$Short.Name) > 0   # Create logical vector of the Short Names that are used
which(x == TRUE)  # Show the Short Names 

# There are three types, two of which are Coal sources:
#
# Stationary Fuel Comb /Residential /Anthracite Coal /Total: All Combustor Types 
# 9568 
# Stationary Fuel Comb /Residential /Bituminous/Subbituminous Coal /Total: All Combustor Types 
# 9570 
# Stationary Fuel Comb /Residential /Liquified Petroleum Gas /Total: All Combustor Types 
# 9574 


###
### Answer
###
### From the graph we can see that commercial and residential sources declines slightly (almost level)
### and were low to begin with. Electric generation declines steeply. Industrial boiler increased,
### leveled, and then decreased, ending up slightly higher in 2008.
