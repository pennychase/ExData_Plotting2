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

# Plot as a time series: type="o" draws lines and overplotted points
with(totalEmissionsBaltimore, plot(Year, Emissions, type="l", pch=20, ylab="Emissions"))



