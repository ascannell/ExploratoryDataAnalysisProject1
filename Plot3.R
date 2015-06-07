# Script to create Plot 3, which plots sub_metering 1, 2, and 3 vs day of week

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

# Save sub metering data to temp variables to save on typing later
a <- Datadf$Sub_metering_1
b <- Datadf$Sub_metering_2
c <- Datadf$Sub_metering_3

# Print plot to PNG file, width of 480 pixels, height of 480 pixels
png("plot3.png",width = 480, height = 480, units = "px")

# Plot sub_metering 1,2, and 3 vs days of week, use line type, and y label
plot(xData,a,type = "l", ylab = "Energy sub metering", xlab = "",ylim=range(a,b,c), col="black")
lines(xData,b,type="l",col="red")
lines(xData,c,type="l",col="blue")
legend("topright",lty=1,col=c("black","red","blue"),legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

# Turn off png device
dev.off()
