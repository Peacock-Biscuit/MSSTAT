
library(data.table)
library(TSA)
library(mgcv)

#Load data
data=read.csv("HouseData.csv",header=TRUE)
#Split data into training and testing
data.train=data[1:(nrow(data)-4),]
data.test=data[(nrow(data)-3):nrow(data),]

#Original time series
HFS=data.train$Houses_for_Sale
HFS.ts=ts(HFS, frequency = 4, start = 1976)
ts.plot(HFS.ts, ylab = "Houses for Sale", xlab = "Year", main = "Original Time Series of Homes for Sale Over Time")

#Transformed series
HFS.dts= diff(HFS.ts)
ts.plot(HFS.dts, ylab = "Houses for Sale", xlab = "Year", main = "Differenced Time Series of Homes for Sale Over Time")


#ARIMA
final.aic = Inf
final.order = c(0,0,0)
for (p in 0:5) for (q in 0:5) {
	current.aic=AIC(arima(HFS.ts, order=c(p,1,q),method="ML"))
	if (current.aic < final.aic) {
		final.aic = current.aic
		final.order = c(p,1,q)
		final.arima=arima(HFS.ts, order=final.order)
	}
}
par(mfcol=c(1,2))
acf(resid(final.arima),main="ACF: Residuals")
pacf(resid(final.arima),main="PACF: Residuals")
Box.test(final.arima$resid, lag = sum(final.order), type = "Ljung-Box", fitdf = (sum(final.order)-1))


#Predictions
##ARIMA
arima.pred = as.numeric(predict(final.arima,n.ahead=4)$pred)

##Plot
HFS.all=ts(data$Houses_for_Sale, frequency = 4, start = 1976)
plot(time(HFS.all)[160:168],data$Houses_for_Sale[160:168], type="l", xlab="Year", ylab="Housing For Sale", main="Housing for Sale")
lines(time(HFS.all)[165:168],arima.pred,col="blue",lwd=2)
d=par("usr") #grabs the plotting region dimensions
legend(d[1]+.5,d[4]-10,legend=c("ARIMA"),col=c("blue"),lty=1)

##PM
obs = data.test$Houses_for_Sale
sum((arima.pred-obs)^2)/sum((obs-mean(obs))^2)

