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

emmbyy <- tapply(NEI$Emissions, NEI$year, sum)

#Plot it

barplot(emmbyy, xlab = "Year", main = "Total PM2.5 em. Across US", 
        ylab = "Emissions (tons)", beside = TRUE)

#Save to in a PNG file

png(filename = "Plot1.png")
barplot(emmbyy, xlab = "Year", main = "Total PM2.5 em. Across US", 
        ylab = "Emissions (tons)", beside = TRUE)
dev.off()



