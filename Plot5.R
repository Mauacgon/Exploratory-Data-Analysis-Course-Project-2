#Download files if didn't yet

URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
DestFile <- paste(getwd(), "/exdata_data_NEI_data.zip", sep = "")
if (!file.exists("exdata_data_NEI_data.zip")) {
  download.file(url = URL, destfile = DestFile)
}

#Download required packages and install them if didn't yet

packages <- list("lubridate", "data.table", "tidyr", "dplyr")

for (i in packages){
  if (is.na(match(i, rownames(installed.packages())))) {
    install.packages(i)
  }
}

for (i in packages) {
  library(i, character.only = TRUE)
}

#Unzip and process data

unzip(DestFile)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

SCCmv <- SCC[grep("[Mm]otor|[Vv]ehicle", SCC$Short.Name),]
NEImv <- merge(NEI, SCCmv, by = "SCC")
NEImv <- filter(NEImv, fips == 24510)
motor_vehicle_evolution <- tapply(NEImv$Emissions, NEImv$year, sum)

#plot it

par(mfrow = c(1,1))

barplot(motor_vehicle_evolution, xlab = "Year", ylab = "Emissions (tons)", main = "Motor|Veichle Emmissions across US")

#Save it into a png file

png(filename = "Plot5.png")

barplot(motor_vehicle_evolution, xlab = "Year", ylab = "Emissions (tons)", main = "Motor|Veichle Emmissions across US")

dev.off()