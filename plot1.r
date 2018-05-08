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
png(file="plot1.png")
hist(a$Global_active_power,col="red",xlab="Global Active Power (kilowatts)",main="Global Active Power")
dev.off()
rm(a)
