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


# Create the ggplot plot -- tell ggplot about the data and the aesthetics mapping
b <- ggplot(baltimore, aes(year, Emissions))
# Summarize the emissions data and separate by type
b + stat_summary(fun.y = "sum", geom = "line") + facet_grid(.~type)



# Use color to separate groups
# This is good to understand the relative changes, but harder to see what happens for an
# individual emission type
b <- ggplot(baltimore, aes(year, Emissions, colour=type))
b + stat_summary(fun.y = "sum", geom = "line")
