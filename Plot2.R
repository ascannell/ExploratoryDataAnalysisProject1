# Script to create Plot 2, which is a plot of Global active power vs day of week

# Check if data has been downloaded, if not then download and unzip
# This assumes the archive would be unzipped if downloaded
if (!file.exists("./Data/exdata-data-household_power_consumption.zip")){
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl,destfile = "./Data/exdata-data-household_power_consumption.zip", method="curl")
    unzip("./Data/exdata-data-household_power_consumption.zip", exdir = "./Data")
}

# Since this takes time, I'm going to check if data exists. If not, read in data
if (!exists("Datadf")){
    # Read file into R, subsetted by date using SQL command
  
    library(sqldf)  # Load sqldf library to do SQL selects on data frame
    f <- "./Data/household_power_consumption.txt" # Create variable with file name / path
  
    # Use read.csv.sql to read data in subsetted by date
    Datadf <- read.csv.sql(f,sql = "select * from file where Date in ('1/2/2007','2/2/2007')", dbname = tempfile(),sep=";",header=TRUE)
}

# Perform actions on data to get date/time columns together and put them into correct format to plot x axis
dateTime <- paste(Datadf$Date,Datadf$Time) # Combine date and time into single character vector
xData <- strptime(dateTime, format = "%d/%m/%Y %H:%M:%S") # Use strptime to get date and time data into right format

# Print plot to PNG file, width of 480 pixels, height of 480 pixels
png("plot2.png",width = 480, height = 480, units = "px")

# Plot Global Active Power vs days of week, use line type, and y label
plot(xData,Datadf$Global_active_power,type = "l", ylab = "Global Active Power (kilowatts)", xlab = "")

# Turn off png device
dev.off()
