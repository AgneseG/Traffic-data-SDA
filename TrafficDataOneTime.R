library(readr)
setwd("~/Desktop/UniUtrecht/Survey data/Group/Utrecht traffic data")
traffic <- read.csv("traffic.csv",
                    header = T, sep =  "", nrows = 300)


library(data.table)
TTraffic<- fread("C:/Users/Camiel/Desktop/Utrecht traffic data/traffic.csv", header = T, 
                 nrows = 300, col.names = c("id", "country", "Class", 
                                            "Camera", "Date" ,"time" ,"noise",
                                            "noiseunits"), fill = T)


library(data.table) #install this yourself lazy buggers

FullTraffic<- fread("traffic.csv",
                    header = T, col.names = c("id", "country", "Class", 
                                              "Camera", "Date" ,"time" ,"noise",
                                              "noiseunits"), fill = T)
library(survey)
library(sampling)
library(ggplot2)
str(FullTraffic)
summary(FullTraffic$time)

range(FullTraffic$time)
#As expected, the time range is between 0 and 23 reflecting the hours in a day

cameratime<-FullTraffic$time
str(cameratime) 

#Randomly selecting 1 time in the day 
sample(cameratime, 1)
#11am

#Creating a subset of the complete dataset with 11am cases only
sub11<-FullTraffic[FullTraffic$time==11]
str(sub11)
summary(sub11)
#The noise units mean for the subsample is 1.0038, with a minimum of 0.8605 and a maximum of 1.2744

#Randomly selecting 50000 cases from the 11am subset
Sample <- sample(sub11$noiseunits, 50000)
str(Sample)

SampleData <- data.frame(Sample, length(sub11$noiseunits))
names(SampleData) <- c("noise","fpc")
str(SampleData)

srs_design <- svydesign(id=~0,fpc=~fpc, data=SampleData)

svymean(~noise,srs_design)
#Estimate of population mean and standard error:
#mean is 1.0042, SE: 2e-04
#The estimated mean is very close to the 'true' population mean of the 11am subset
#We could use that as popualation estimate for the noise unit mean in Utrecht Municipality, but selecting only one time in the 14  days would produce an estimate that is not representative of the true value.
#In fact, we expect the average noise unit to be influenced by the different time in the day. For instance, at night we expect a lower noise unit mean due to the lower amount of traks and big vehicles driving by.
#Also, we expect the noise total to be higher at peak hours given the higher amount of personal cars driving by, but not an higher noise mean because this kind of vehicles keep the mean low.

#Sampling noiseunit distribution at 11AM
#I did it both with hist() and ggplot, let me know what you like better 
hist(sub11$noiseunits, main="Noise Units sample at 11am ", xlab="Noise Unit")
abline(v=1.0039, col="red")

qplot(sub11$noiseunits, main="Noise Units sample at 11am ", xlab="Noise Unit", ylab="Frequency",  geom="histogram", fill=I("grey"), col=I("black"))
abline(v=1.0039, col="red")

str(sub11$Class)

plot(factor(sub11$Class), main="Kind of vehicles driving by at 11am", xlab="Vehicles", ylab="Frequency")
#As we can see, the majority of vechiles are personal cars, followed by Light business vehicle (< 3500KG) 

plot(factor(sub11$Class), sub11$noiseunits, xlab="Kind of vehicle", ylab="Noise Unit", main="Distribution of noise units at 11am with respect to the different kind of vehicle")
#As we can see from the boxplots, the highest noise unit is due to heavy business vehicle >3500KG and buses