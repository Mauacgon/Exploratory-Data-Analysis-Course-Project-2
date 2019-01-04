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

SCCCoal <- SCC[grep("[Cc][Oo][Aa][Ll]", SCC$Short.Name),]
NEICoal <- merge(SCCCoal, NEI, by = "SCC")
coalevolution <- tapply(NEICoal$Emissions, NEICoal$year, sum)

#Plot it

par(mfrow =c(1,1))

barplot(coalevolution, xlab = "Year", ylab = "Emissions (Tons)", main = "Coal PM 2.5 Emmissions across US")

#Save it into a png file

png(filename = "Plot4.png")

barplot(coalevolution, xlab = "Year", ylab = "Emissions (Tons)", main = "Coal PM 2.5 Emmissions across US")

dev.off()

