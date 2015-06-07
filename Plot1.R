# Script to create Plot 1, which is a histogram of Global Active Power

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

# Print histogram to PNG file, width of 480 pixels, height of 480 pixels
png("plot1.png",width = 480, height = 480, units = "px")

# Plot histogram of Global Active Power, with red columns, main title, and x axis label
hist(Datadf$Global_active_power, col = "red",main = "Global Active Power",xlab = "Global Active Power (kilowatts)")

# Turn off png device
dev.off()