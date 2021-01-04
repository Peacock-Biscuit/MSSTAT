#ISYE 6402 Spring 2020
#Final Initialization Code

#Libraries
library(data.table)


#Loading Data
fname <- file.choose()
data <- read.csv(fname)
data <- data[,c(2,3,4,5)]
data.ts <- ts(data)
dif.ts <- data.frame(diff(data.ts))

train <- data[c(1:261),]
train.dif <- dif.ts[c(1:260),]
test <- data[c(262:270),]
test.dif <- dif.ts[c(261:269),]
