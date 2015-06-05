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

plot3<- function (x) {
    
	yl<- c(  min( c(data$Sub_metering_1,data$Sub_metering_2,data$Sub_metering_3))  , max( c(data$Sub_metering_1,data$Sub_metering_2,data$Sub_metering_3)) )
	
	## plot, but without x axis 
	plot(data$DT,data$Sub_metering_1,type="l",col="black",xlab="",ylab="Energy sub metering", xaxt = "n", ylim=yl)
	par(new=T)
	plot(data$DT,data$Sub_metering_2,type="l",col="red",xlab="",ylab="Energy sub metering", yaxt = "n", xaxt = "n", ylim=yl)
	par(new=T)
	plot(data$DT,data$Sub_metering_3,type="l",col="blue",xlab="",ylab="Energy sub metering", xaxt = "n", xaxt = "n", ylim=yl)
	## plot custom x axis
	axis.POSIXct(1,data$DT, xlab="", format = "%a")
	par(new=T)
	legend('topright','groups',c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty = c(1,1,1), col=c('black','red','blue'))
}

## open graph device png
png(filename = "plot3.png", width = 480, height = 480, units = "px",bg = "white")

## draw plots
plot3(data)

## close png file
dev.off()

