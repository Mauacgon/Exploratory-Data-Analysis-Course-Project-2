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

Baltimore <- filter(NEI, fips == 24510)

#Plot it

ggplot(Baltimore, aes(x = year, y = Emissions), fill = type) + geom_bar(stat = "identity") + facet_grid(.~type) + 
  scale_x_discrete(limits = unique(Baltimore$year), labels = unique(Baltimore$year))
  ggtitle("BALTIMORE PM 2.5 EMMISIONS BY SOURCE") + theme(plot.title = element_text(hjust = 0.5)) + 
  xlab("Year") + ylab("Emissions (tons)")  

#Save it into a png file

png(filename = "Plot3.png")

ggplot(Baltimore, aes(x = year, y = Emissions)) + geom_bar(stat = "identity") + facet_grid(.~type) + 
  scale_x_discrete(limits = unique(Baltimore$year), labels = unique(Baltimore$year)) +
  ggtitle("BALTIMORE PM 2.5 EMMISIONS BY SOURCE") + theme(plot.title = element_text(hjust = 0.5)) + 
  xlab("Year") + ylab("Emissions (tons)")

dev.off()


