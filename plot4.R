library(lubridate)
library(chron)

## Download, unzip and read in the data
## setwd("D:/R/R-3.0.3/wd")
fileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if (!file.exists("./data")){dir.create("./data")}
download.file(fileUrl,destfile="./data/electricity.zip",method="internal")
unzip("./data/electricity.zip", exdir="./data")
electricity <- read.csv2("./data/household_power_consumption.txt",stringsAsFactor = FALSE)
for (i in 3:length(names(electricity))){
  electricity[ ,i] <- as.numeric(electricity[ ,i])
}

## Remove missing value and make a subset with data only in 2007-02-01/02
## Convert date and time into date and time types 
electricity_good <- electricity[complete.cases(electricity), ]
subset <- electricity_good[electricity_good[ ,1]=="1/2/2007"|electricity_good[ ,1]=="2/2/2007",]
subset[ ,1] <- as.Date(subset[ ,1],format="%d/%m/%Y")  
subset[ ,2] <- times(subset[ ,2]) 
subset$DateTime <- strptime(paste(subset[ ,1],subset[ ,2]),"%Y-%m-%d %H:%M:%S")

## Make 4 required plots
png(filename="./data/plot4.png",width=480,height=480)
par(mfrow=c(2,2))
##png(filename="./data/plot4.png",width=480,height=480)
## plot1
plot (subset[ ,10], subset[ ,3], type = "l", main="", xlab="",ylab="Global active power")
## plot2
plot (subset[ ,10], subset[ ,5], type = "l", main="", xlab="datetime",ylab="Voltage")
## plot3
plot (subset[ ,10], subset[ ,7], type = "l", main="", xlab="",ylab="Energy sub metering",col="black")
lines (subset[ ,10],subset[ ,8],col="red")
lines (subset[ ,10],subset[ ,9],col="blue")
legend("topright",pch="_",col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"),bty="n")
## plot4
plot (subset[ ,10], subset[ ,4], type = "l", main="", xlab="datetime",ylab="Global_reactive_power")
dev.off()

