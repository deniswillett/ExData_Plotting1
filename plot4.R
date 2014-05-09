#Load appropriate Libraries
library(data.table) #For fast data reading and manipulation
library(lubridate)  #For Date Time

#Set Working Directory source file location

#Url of data source
url='https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'

#Set up Temp file for download
temp <- tempfile()

#Download File
download.file(url,temp, method='curl')

#Load Data
epc=fread(unzip(temp,'household_power_consumption.txt'), sep = ';', 
          drop='Global_intensity',
          colClasses='character', header=TRUE, showProgress=TRUE, stringsAsFactors=FALSE)

#Unlink Temp File
unlink(temp)

#Select time period from 2-1-2007 until 2-2-2007
setkey(epc, Date)

feb=epc[J(c('1/2/2007', '2/2/2007'))]

#Replace Question marks with NA
#Could have done this with na.strings argument in fread, but 
#it seemed to have some problems
feb[which(feb == "?", arr.ind=TRUE)] = NA

#Add date time variable
feb[,DT :=dmy_hms(paste(Date, Time))]

#Convert to numeric
feb[,GAP := as.numeric(Global_active_power)]
feb[,GRP := as.numeric(Global_reactive_power)]
feb[,Volt := as.numeric(Voltage)]
feb[,SM1 :=as.numeric(Sub_metering_1)]
feb[,SM2 :=as.numeric(Sub_metering_2)]
feb[,SM3 :=as.numeric(Sub_metering_3)]

png('plot4.png', width=480, height=480, units='px')
par(mfrow=c(2,2), mar=c(4,4,2,2))
with(feb, 
     plot(DT, GAP, type='l', xlab='',ylab='Global Active Power (kilowatts)'))

with(feb, {
  plot(DT, Volt, type='l', xlab='', ylab='Voltage')
})

with(feb, {
  plot(DT, SM1, type='n', xlab='', ylab='Energy sub metering')
  lines(DT, SM1, col='black')
  lines(DT, SM2, col='red')
  lines(DT, SM3, col='blue')
  legend('topright', lty=1, col=c('black','red','blue'), legend=names(feb)[6:8])
})

with(feb, {
  plot(DT, GRP, type='l', xlab='', ylab='Global Reactive Power (kilowatts)')
})
dev.off()



