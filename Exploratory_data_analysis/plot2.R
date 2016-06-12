
#dowload Data
dataDir <- "./data/"
if(!dir.exists(dataDir))
{
  dir.create(dataDir)
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  zipFile <-paste(dataDir,"power_consumption.zip")
  zip <- download.file(url, zipFile)
  unzip(zipFile,exdir = dataDir)
}

fileHousePowerConsumption <- paste(dataDir, "household_power_consumption.txt", sep="")

#load file in R
HousePowerConsumption <- read.table( fileHousePowerConsumption, header = TRUE , sep=";",na.strings = "?")

#SubSet
SubSet <-HousePowerConsumption$Date == "1/2/2007" | HousePowerConsumption$Date == "2/2/2007"
HousePowerConsumptionSubSet <- HousePowerConsumption[SubSet,]

#use R date
HousePowerConsumptionSubSet$DateR <-strptime (paste(HousePowerConsumptionSubSet$Date, HousePowerConsumptionSubSet$Time), format = "%d/%m/%Y %T")

par(mfrow = c(1, 1))
#plot histogramme
plot(HousePowerConsumptionSubSet$DateR, HousePowerConsumptionSubSet$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)" )





# copy plot to png file
dev.copy(png, file = "plot2.png")

# close connection to png device
dev.off()