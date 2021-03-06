# Script to create Plot 4, which is a panel of 4 plots

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
png("plot4.png",width = 480, height = 480, units = "px")

# Use par() to setup for a panel of 4 plots
par(mfrow = c(2,2), mar=c(4,4,2,1))

# Upper left plot, Global Active Power vs days of the week
plot(xData,Datadf$Global_active_power,type = "l", ylab = "Global Active Power (kilowatts)", xlab = "")

# Upper right plot, Voltage vs days of the week
plot(xData,Datadf$Voltage,type = "l", ylab = "Voltage", xlab = "datetime")

# Lower left plot, sub_metering 1,2, and 3 vs days of week, use line type, and y label, bty="n" gets rid
# of line around the legend
plot(xData,a,type = "l", ylab = "Energy sub metering", xlab = "",ylim=range(a,b,c), col="black")
lines(xData,b,type="l",col="red")
lines(xData,c,type="l",col="blue")
legend("topright",lty=1,col=c("black","red","blue"), bty = "n",
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

# Lower right plot, Global reactive power vs days of the week
plot(xData,Datadf$Global_reactive_power,type = "l", ylab = "Global_reactive_power", xlab = "datetime")

# Turn off png device
dev.off()
