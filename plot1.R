library(downloader)
library(dplyr)
library(lubridate)

Url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download(Url, dest="dataset.zip", mode="wb")
unzip ("dataset.zip", exdir = "./")

# read in data
data <- read.table("./household_power_consumption.txt", sep = ";", header = T, stringsAsFactors = F)

# select desired days
data <- filter(data, Date == "1/2/2007" | Date == "2/2/2007")

# convert dates to better format
dates <- data$Date
better_dates <- as.Date(dates, format = "%d/%m/%Y")
data$Date <- better_dates

# convert date and time columns to one column in date format
Date_Time <- paste(data$Date, data$Time)
data <- cbind(Date_Time, data[ ,3:9])

# reformat date and time 
better_Date_Time <- ymd_hms(Date_Time)
data$Date_Time <- better_Date_Time

# convert '?' to NAs
data <- data %>% 
        mutate_at(vars(Global_active_power,Global_reactive_power, Voltage, Global_intensity,Sub_metering_1, Sub_metering_2, Sub_metering_3 ),
                  ~na_if(., '?'))

# convert variable vectors to numeric class
data <- data %>%
        mutate_at(vars(Global_active_power,Global_reactive_power, Voltage, Global_intensity,Sub_metering_1, Sub_metering_2, Sub_metering_3 ),
                  as.numeric)

## plot 1

png(filename = "plot1.png")

hist(data$Global_active_power,
     ylim = c(0,1200),
     col = "red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")

dev.off()

