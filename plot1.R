#Load appropriate Libraries
library(data.table) #For fast data reading and manipulation

#Set Working Directory source file location

#Url of data source
url='https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'

#Set up Temp file for download
temp <- tempfile()

#Download File
download.file(url,temp, method='curl')

#Load Data
epc=fread(unzip(temp,'household_power_consumption.txt'), sep = ';', select=c('Date','Global_active_power'),
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

#Plot histogram of global active power
png('plot1.png', width=480, height=480, units='px')
hist(feb$GAP, col='red',
     xlab='Global Active Power (kilowatts)', ylab='Frequency', 
     main='Global Active Power', axes=FALSE)
axis(1, at=seq(0,6, by=2), labels=seq(0,6, by=2))
axis(2, at=seq(0,1200, by=200), labels=seq(0,1200, by=200))
dev.off()



