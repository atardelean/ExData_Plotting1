#Reading data into R
fileURL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
temp<-tempfile()
download.file(fileURL,temp, method="curl")
data<-read.table(unz(temp, "household_power_consumption.txt"), header=TRUE, sep=";", na.strings=c("","?","NA"), colClasses="character")
unlink(temp)

# Keep only two days in February 2007
data_small<-dplyr::filter(data, Date=="2/2/2007" | Date=="1/2/2007")

# Convert variables used in graphs to numeric 
data_small$global_active_power<-as.numeric(data_small$Global_active_power)
data_small$Sub_metering_1<-as.numeric(data_small$Sub_metering_1)
data_small$Sub_metering_2<-as.numeric(data_small$Sub_metering_2)
data_small$Sub_metering_3<-as.numeric(data_small$Sub_metering_3)
data_small$Voltage<-as.numeric(data_small$Voltage)
data_small$Global_reactive_power<-as.numeric(data_small$Global_reactive_power)

#Create a Date Time variable
library(tidyverse)
library(lubridate)

data_small2<-dplyr::mutate(data_small, DateTime=paste(Date,Time, sep=" "))
data_small2$DateTime<-dmy_hms(data_small2$DateTime)

#Plot3
quartz()
par(mar=c(5.1,4.1,4.1,3.1))
with(data_small2, plot(DateTime, Sub_metering_1, type="l", ylab="Energy sub metering", xlab="", col="black"))
with(data_small2, lines(DateTime, Sub_metering_2, col="red"))
with(data_small2, lines(DateTime, Sub_metering_3, col="blue"))
legend("topright",lty=1, col=c("black","red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.copy(png, file="plot3.png")
dev.off()

