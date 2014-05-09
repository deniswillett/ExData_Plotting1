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
epc=fread(unzip(temp,'household_power_consumption.txt'), sep = ';', select=c('Date','Time','Global_active_power'),
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

#Convert to numeric
feb[,GAP :=as.numeric(feb$Global_active_power)]

#Add date time variable
feb[,DT :=dmy_hms(paste(Date, Time))]

#Plot time series of global active power
png('plot2.png', width=480, height=480, units='px')
with(feb, 
     plot(DT, GAP, type='l', xlab='',ylab='Global Active Power (kilowatts)'))
dev.off()

