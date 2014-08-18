library(ggplot2)

# Set working diectory
setwd("~/Documents/MOOCs/Data Science Specialization/Course4_Exploratory-Data-Analysis/Projects/ExData_Plotting2")

# Assume the data has been downloaded to exdata-data-NEI_data
# Read in the data and the classification codes from R object files
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

# Create index vector to subset coal combustion-related sources
coalSector <- grepl("Coal", levels(SCC$EI.Sector)) # SCC$EI.Sector groups the sources into sectors
coalSCC <- SCC$SCC[coalSector] # Get the SCC codes for the coal sector

# Subset the NEI data set 
coalEmissions <- NEI[NEI$SCC %in% coalSCC,]

# Plot coal emission
# Create the mapping to aesthetics (emissions by year)
coal <- ggplot(coalEmissions, aes(year, Emissions))
# Use stat_summary() to plot the summary of the y values (i.e., the emissions)
coal <- coal + stat_summary(fun.y = "sum", geom = "line") 
# Add labels
coal <- coal + labs(title="Emissions from Coal Sources, 1999-2008", x="Year", y="Emissions (tons)")

# Plot graph
coal


