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

# Plot as a time series: type="o" draws lines and overplotted points
# Scale Emissions to thousands of tons by dividing by 1000 to make the y-axis values easier to read
with(totalEmissions, plot(Year, Emissions/1000, type="o", pch=20, ylab="Emissions (1000s of tons)"))
