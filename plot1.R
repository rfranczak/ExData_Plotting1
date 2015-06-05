library(sqldf)

sourceURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
localFile <- "exdata%2Fdata%2Fhousehold_power_consumption.zip"
srcLocalFile <- "household_power_consumption.txt"

## download dataset
download.file(sourceURL, dest=localFile, mode="wb")
## unpack
unzip(localFile,exdir=".")

##
## We will only be using data from the dates 2007-02-01 and 2007-02-02. 
## One alternative is to read the data from just those dates rather than reading in the entire dataset and subsetting to those dates.
##
data <- read.csv.sql(srcLocalFile , 
                     sql = "select * from file where Date in ('1/2/2007','2/2/2007') ", 
					 header = TRUE, sep = ";",
					 eol = "\n", 
					 colClasses=c("character","character",rep("numeric",7))
					 )

data$DT <- strptime(paste(data$Date,data$Time,sep=" "),format="%d/%m/%Y %H:%M:%S")

##
## make histogram
##
plot1<- function (x) {
    
	hist(x$Global_active_power,main="Global Active Power",xlab="Global Active Power (kilowatts)",col="red")
}

## open graph device png
png(filename = "plot1.png", width = 480, height = 480, units = "px",bg = "white")

## draw histogram
plot1(data)

## close png file
dev.off()


