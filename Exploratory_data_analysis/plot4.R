
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

par(mfrow = c(2, 2))
with(HousePowerConsumptionSubSet, {
  plot(DateR, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")
  plot(DateR, Voltage, type = "l", xlab = "datetime", ylab = "Voltage")
  plot(DateR, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
  lines(DateR, Sub_metering_2, col = "red")
  lines(DateR, Sub_metering_3, col = "blue")
  legend("topright", col = c("black", "red", "blue"), cex = 0.7, lty = 1, bty = "n",
         legend = c("Sub_metering_1             ", 
                    "Sub_metering_2             ",
                    "Sub_metering_3             "))
  plot(DateR, Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global Reactive Power")
})



# copy plot to png file
dev.copy(png, file = "plot4.png")

# close connection to png device
dev.off()