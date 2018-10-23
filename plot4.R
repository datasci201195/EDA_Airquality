# Loading packages
library(dplyr)
library(ggplot2)

# Read data files
# read national emissions data
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
# str(NEI)
# dim(NEI)
# head(NEI)
#read source code classification data
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")
# str(SCC)
# dim(SCC)
# head(SCC)
# visualization
number.add.width<-800                             # width length to make the changes faster
number.add.height<-800                             # height length to make the changes faster


png("plot4.png", width=number.add.width, height=number.add.height)

combustion.coal <- grepl("Fuel Comb.*Coal", SCC$EI.Sector)
combustion.coal.sources <- SCC[combustion.coal,]

# Find emissions from coal combustion-related sources
emissions.coal.combustion <- NEI[(NEI$SCC %in% combustion.coal.sources$SCC), ]

emissions.coal.related <- summarise(group_by(emissions.coal.combustion, year), Emissions=sum(Emissions))

ggplot(emissions.coal.related, aes(x=factor(year), y=Emissions/1000,fill=year, label = round(Emissions/1000,2))) +
    geom_bar(stat="identity") +
      xlab("year") +
    ylab(expression("total PM"[2.5]*" emissions in kilotons")) +
    ggtitle("Emissions from coal combustion-related sources in kilotons")+
    geom_label(aes(fill = year),colour = "white", fontface = "bold")

dev.off()