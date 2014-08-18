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
with(totalEmissionsBaltimore, plot(Year, Emissions, type="l", ylab="Emissions"))


###
### Using ggplot 
###
library(ggplot2)

# Create the basic plot of year and Emissions
b <- ggplot(baltimore, aes(year, Emissions))
# Use stat_summary() to plot the summary of the y values (i.e., the Emissions)
# Plot the points as well as the lines to make clear which years we have data
b + stat_summary(fun.y = "sum", geom = "line")

