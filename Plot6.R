#Download File if didn't already on wd

URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
DestFile <- paste(getwd(), "/exdata_data_NEI_data.zip", sep = "")
if (!file.exists("exdata_data_NEI_data.zip")) {
  download.file(url = URL, destfile = DestFile)
}

#Download packages if didn't already and require them

packages <- list("lubridate", "data.table", "tidyr", "dplyr", "ggplot2", "gridExtra")

for (i in packages){
  if (is.na(match(i, rownames(installed.packages())))) {
    install.packages(i)
  }
}

for (i in packages) {
  library(i, character.only = TRUE)
}

#Unzip file and process data

unzip(DestFile)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

SCCmvbm <- SCC[grep("[Mm]otor|[Vv]ehicle", SCC$Short.Name),]
NEImvbm <- merge(NEI, SCCmvbm, by = "SCC")
NEImvbm <- filter(NEImvbm, fips == 24510)
motor_vehicle_evolution_Bm <- tapply(NEImvbm$Emissions, NEImvbm$year, sum)

SCCmvla <- SCC[grep("[Mm]otor|[Vv]ehicle", SCC$Short.Name),]
NEImvla <- merge(NEI, SCCmvla, by = "SCC")
NEImvla <- filter(NEImvla, fips== "06037")
motor_vehicle_evolution_LA <- tapply(NEImvla$Emissions, NEImvla$year, sum)


mvebm <- as.data.frame(motor_vehicle_evolution_Bm)
mvela <- as.data.frame(motor_vehicle_evolution_LA)

#plot it

p_mvebm <- ggplot(mvebm, aes(row.names(mvebm), mvebm$motor_vehicle_evolution_Bm)) + geom_bar(stat = "identity") +
  xlab("Year") + ylab("Emissions (tons)") + ggtitle("BALTIMORE") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))
p_mvela <- ggplot(mvela, aes(row.names(mvela), mvela$motor_vehicle_evolution_LA)) + geom_bar(stat = "identity") +
  xlab("Year") + ylab("Emissions (tons)") + ggtitle("LA") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

grid.arrange(p_mvebm, p_mvela, nrow=2, top = "COMPARATIVE. L.A. VS BALTIMORE (MOTOR VEHICLES)")

#save it to a png file

png(filename = "Plot6.png")

p_mvebm <- ggplot(mvebm, aes(row.names(mvebm), mvebm$motor_vehicle_evolution_Bm)) + geom_bar(stat = "identity") +
  xlab("Year") + ylab("Emissions (tons)") + ggtitle("BALTIMORE") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))
p_mvela <- ggplot(mvela, aes(row.names(mvela), mvela$motor_vehicle_evolution_LA)) + geom_bar(stat = "identity") +
  xlab("Year") + ylab("Emissions (tons)") + ggtitle("LA") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

grid.arrange(p_mvebm, p_mvela, nrow=2, top = "COMPARATIVE L.A. VS BALTIMORE (MOTOR VEHICLES)")

dev.off()




