library(forecast)
library(tidyverse) # Get the time range as a mid point. Need to install
library(lubridate)
library(xts) # Get the time-series object
library(imputeTS) # Impute missing data . Need to install
source("utils.R")

#Need to set the working directory current source file : setwd
PROJECT_DIR = dirname(getwd());
DATASET_DIR = paste0(PROJECT_DIR,"/Dataset/");
DATASET_FILE = paste0(DATASET_DIR,"Pedestrian data 2017_to_2021_with_missing_values.csv");
VISUALIZATION_DIR = paste0(PROJECT_DIR, "/Visualize/")
ALERT_LEVEL_FILE = paste0(DATASET_DIR,"covid_alert_levels.csv");


pData <- read.csv(DATASET_FILE, header = TRUE)
alertData <- read.csv(ALERT_LEVEL_FILE, header = TRUE)


######## Data Preparation #######

# Impute the missing values.
pData$X107.Quay.Street <- na_interpolation(pData$X107.Quay.Street, option ="stine")
pData$X7.Custom.Street.East <- na_interpolation(pData$X7.Custom.Street.East, option ="stine")
pData$X30.Queen.Street <- na_interpolation(pData$X30.Queen.Street, option ="stine")
pData$X1.Courthouse.Lane <- na_interpolation(pData$X1.Courthouse.Lane, option ="stine")
pData$X150.K.Road <- na_interpolation(pData$X150.K.Road, option ="stine")

# Create dateTime index
pData$Date <- as.Date(pData$Date, "%d/%m/%Y")
dateTimeColumn <- paste(pData$Date, pData$Time)
pData$dateTime <- as.POSIXlt(dateTimeColumn, format = "%Y-%m-%d %H:%M:%S")

# Average the foot steps of all the roads
pData$avgData <- (pData$X107.Quay.Street+pData$Te.Ara.Tahuhu.Walkway+pData$Commerce.Street.West+pData$X7.Custom.Street.East+pData$X45.Queen.Street+pData$X30.Queen.Street+pData$X19.Shortland.Street+pData$X2.High.Street+pData$X1.Courthouse.Lane+pData$X61.Federal.Street+pData$X59.High.Stret+pData$X210.Queen.Street+pData$X205.Queen.Street+pData$X8.Darby.Street.EW+pData$X8.Darby.Street.NS+pData$X261.Queen.Street+pData$X297.Queen.Street+pData$X150.K.Road+pData$X183.K.Road) / 19

#Remove 4 raws that has NA datetime values
pData <- pData[-c(which(is.na(pData$dateTime))),]

# Get the moving average. Consider one month frame
pData$movingAvg <- forecast::ma(pData$avgData, order = 720, centre = TRUE)
#write.csv(pData, paste0(VISUALIZATION_DIR,"processed_data.csv"), row.names=FALSE)

################ Plot initial data
plot(pData$dateTime, pData$movingAvg, main = "Average Foot traffic", xlab= "Year", ylab = "Foot count", col = "blue")
grid(nx = NULL, ny = NULL,
     lty = 2,      # Grid line type
     col = "gray", # Grid line color
     lwd = 2) 


plot(pData$dateTime, pData$avgData, type="l", lwd=1, xlab = "Variation of foor trafic with Moving average", ylab= "Foot traffic", col="orange")
lines(pData$dateTime, pData$movingAvg, col="blue", lwd=3)


################# Analysis

tsData <- ts(pData$movingAvg, frequency = 8640) # Annual freaquency 8640
ddata <- decompose(tsData, "additive")
plot(ddata)

# Break the data into parts. use new dataframe subData to access the subset

# startTime <- as.POSIXlt("2017-01-01 6:00:00")
# endTime <- as.POSIXlt("2019-12-31 6:30:00") # Considered bit earlier than the actual alerts.
# beforeCovidDF <- get_dataset_in_time_range(pData,startTime, endTime)
# beforeCovidDF$movingAvg <- ts(beforeCovidDF$movingAvg)
# 
# startTime <- as.POSIXlt("2019-12-31 6:30:00") 
# endTime <- as.POSIXlt("2021-09-01 6:30:00")
# afterCovidDF <- get_dataset_in_time_range(pData,startTime, endTime)
# afterCovidDF$movingAvg <- ts(afterCovidDF$movingAvg)


# Forecast pattern for the pandemic.

# This takes more than 3 hours to run. Hence, commenting out 
#model <- auto.arima(tsData, stepwise = FALSE, approximation = FALSE , num.cores = 3)
#forecastValues <- forecast(model, h = 720) # Forecast for one week



############# Alert level data processing
time1 <- as.POSIXlt(alertData[,1], format = "%d/%m/%Y %H:%M")
time2 <- as.POSIXlt(alertData[,2], format = "%d/%m/%Y %H:%M")
pData$alertLevel <- numeric(length(pData$dateTime))

## This runs for while, Hence commenting out 
# for (x in 25000:length(pData$dateTime)) { # Do not need to run from the begining
#   for (y in 1:length(time1)) {
#     if(pData$dateTime[x] > time1[y] && pData$dateTime[x] <= time2[y])
#       pData$alertLevel[x] = alertData$Alert.level[y]
#   }
# }

####### Plots with alert level ranges

par(mfrow = c(2, 1), mar = c(2, 3, 3, 2))

# Alert level 0 :7/10/2018 23:59 
startTime <- as.POSIXlt("2018-10-10 12:00:00") 
endTime <- as.POSIXlt("2018-10-24 12:00:00")
alertLevel0 <- get_dataset_in_time_range(pData,startTime, endTime)
plot(alertLevel0$dateTime, alertLevel0$avgData, main = "Daily pattern before pandemic -2018/10/10 - 2018/10/24", xlab= "Day", ylab = "Foot count",lwd = 3, col = "purple", type = "l")

startTime <- as.POSIXlt("2019-05-10 12:00:00") 
endTime <- as.POSIXlt("2019-05-24 12:00:00")
alertLevel0 <- get_dataset_in_time_range(pData,startTime, endTime)
plot(alertLevel0$dateTime, alertLevel0$avgData, main = "Daily pattern before pandemic -2018/10/10 - 2018/10/24", xlab= "Day", ylab = "Foot count",lwd = 3, col = "pink", type = "l")


# Alert level 1 :7/10/2020 23:59 
startTime <- as.POSIXlt("2020-11-10 12:00:00") 
endTime <- as.POSIXlt("2020-11-24 12:00:00")
alertLevel1 <- get_dataset_in_time_range(pData,startTime, endTime)
plot(alertLevel1$dateTime, alertLevel1$avgData, main = "Alert Level - 1 - 2020/11/10 - 2020/11/24", xlab= "Day", ylab = "Foot count",lwd = 3, col = "red", type = "l")


# Alert level 2 : 13/05/2020 23:59
startTime <- as.POSIXlt("2020-05-13 23:59:00") 
endTime <- as.POSIXlt("2020-05-27 23:59:00")
alertLevel2 <- get_dataset_in_time_range(pData,startTime, endTime)
plot(alertLevel2$dateTime, alertLevel2$avgData, main = "Alert Level - 2  - 2020/05/13 - 2020/05/27", xlab= "Day", ylab = "Foot count", lwd = 3, col = "blue", type = "l")

# Alert level 3 : 12/8/2020 12:00
startTime <- as.POSIXlt("2020-08-15 12:00:00") 
endTime <- as.POSIXlt("2020-08-29 12:00:00")
alertLevel3 <- get_dataset_in_time_range(pData,startTime, endTime)
plot(alertLevel3$dateTime, alertLevel3$avgData, main = "Alert Level - 3 - 2020/08/15 - 2020/08/29", xlab= "Day", ylab = "Foot count",lwd = 3, col = "orange", type = "l")


# Alert level 4 : 25/3/2020 12:00
startTime <- as.POSIXlt("2020-04-01 12:00:00") 
endTime <- as.POSIXlt("2020-04-14 12:00:00")
alertLevel4 <- get_dataset_in_time_range(pData,startTime, endTime)
plot(alertLevel4$dateTime, alertLevel4$avgData, main = "Alert Level - 4 - 2020/04/01 - 2020/04/14", xlab= "Day", ylab = "Foot count",lwd = 3, col = "green", type = "l")
