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
### Using ggplot 
###
library(ggplot2)

# Create the basic plot of year and Emissions
n <- ggplot(NEI, aes(year, Emissions))
# Use stat_summary() to plot the summary of the y values (i.e., the Emissions)
# Plot the points as well as the lines to make clear which years we have data
n + stat_summary(fun.y = "sum", geom = "line") + stat_summary(fun.y = "sum", geom = "point")