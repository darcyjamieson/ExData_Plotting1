require(lubridate)

#Check if file is missing from the current directory. File too big to keep in git. 
filenames<-data.frame(names=c("household_power_consumption.txt"))

chkfullpath<-function(file){
     fullname<-list.files(pattern=as.character(paste0("^",file)),full.names=TRUE,recursive=TRUE,ignore.case=TRUE)
     if(length(fullname)==0){
          stop("Required raw data file missing from current directory: ",file)
     } else {
          fullname[[1]]
     }
}

filenames$fullname<-lapply(filenames$names,chkfullpath)

#Load data
hpc<-read.table("household_power_consumption.txt",header = TRUE,sep=";",na.strings=c("?"))
hpc$datetime<-dmy_hms(paste(hpc$Date,hpc$Time))
a<-subset(hpc,datetime>="2007-02-01" & datetime<"2007-02-03")
rm(hpc)

#Create plot
png(file="plot4.png")
par(mfrow=c(2,2))
with(a,plot(datetime,Global_active_power,type="l",ylab="Global Active Power",xlab=""))
with(a,plot(datetime,Voltage,type="l"))
with(a,plot(datetime,Sub_metering_1,type="l",xlab="",ylab="Energy sub metering"))
lines(a$datetime,a$Sub_metering_2,col="red")
lines(a$datetime,a$Sub_metering_3,col="blue")
legend("topright",bty="n",lwd=c(1,1,1),col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
with(a,plot(datetime,Global_reactive_power,type="l"))
dev.off()
