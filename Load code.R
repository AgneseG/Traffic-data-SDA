library(readr)
traffic <- read.csv("C:/Users/Camiel/Desktop/Utrecht traffic data/traffic.csv",
                    header = T, sep =  "", nrows = 300)


library(data.table)
TTraffic<- fread("C:/Users/Camiel/Desktop/Utrecht traffic data/traffic.csv", header = T, 
                 nrows = 300, col.names = c("id", "country", "Class", 
                                            "Camera", "Date" ,"time" ,"noise",
                                            "noiseunits"), fill = T)


library(data.table) #install this yourself lazy buggers

FullTraffic<- fread("C:/Users/Camiel/Desktop/Utrecht traffic data/traffic.csv",
                    header = T, col.names = c("id", "country", "Class", 
                                            "Camera", "Date" ,"time" ,"noise",
                                            "noiseunits"), fill = T)


table(FullTraffic$country)
table(FullTraffic$Class)
table(FullTraffic$time)
table(FullTraffic$Date)
mean(FullTraffic$noise)
range(FullTraffic$noiseunits)
range(FullTraffic$time)


length(FullTraffic$Camera)
