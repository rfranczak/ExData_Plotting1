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
data$WDname <- format(data$DT,"%a")

##
## make plot
##

plot2<- function (x) {
    
	## plot, but without x axis 
	plot(data$DT,data$Global_active_power,type="l",col="black",xlab="",ylab="Global Active Power (kilowatts)", xaxt = "n")
	## plot custom x axis
	axis.POSIXct(1,data$DT, xlab="", format = "%a")
}

## open graph device png
png(filename = "plot2.png", width = 480, height = 480, units = "px",bg = "white")

## draw histogram
plot2(data)

## close png file
dev.off()

