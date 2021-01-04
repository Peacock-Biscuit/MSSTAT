#ISYE 6402
#Final Exam Solutions - Spring 2020

library(TSA)
library(mgcv)
library(vars)
library(tseries)
library(fGarch)
library(rugarch)

fname <- file.choose()
data <- read.csv(fname)
data <- data[,c(2,3,4,5)]
data.ts <- ts(data)
dif.ts <- data.frame(diff(data.ts))

train <- data[c(1:261),]
train.dif <- dif.ts[c(1:260),]
test <- data[c(262:270),]
test.dif <- dif.ts[c(261:269),]


#Q1

#A
par(mfrow = c(1,2))

ts.plot(train.dif$AAPL,main='AAPL TS')
acf(train.dif$AAPL,Mail='AAPL ACF')

ts.plot(train.dif$AMZN,main='AMZN TS')
acf(train.dif$AMZN,Mail='AMZN ACF')

ts.plot(train.dif$FB,main='FB TS')
acf(train.dif$FB,Mail='FB ACF')

ts.plot(train.dif$GOOG,main='GOOG TS')
acf(train.dif$GOOG,Mail='GOOG ACF')

#B
time.pts = c(1:nrow(train))
time.pts = c(time.pts - min(time.pts))/max(time.pts)


#AMZN Quadtratic Polynomial
x1 = time.pts
x2 = time.pts^2
lm.fit = lm(train$AMZN~x1+x2)
summary(lm.fit)

preds = lm.fit$fitted.values
obs = train$AMZN

#MAE
mean(abs(preds-obs)) #.194

#MSE
mean((preds-obs)^2) #.0746


#FB Splines
gam.fit = gam(train$FB~s(time.pts))
summary(gam.fit)

preds = gam.fit$fitted.values
obs = train$FB

#MAE
mean(abs(preds-obs)) #.0875

#MSE
mean((preds-obs)^2) #.0158


#C
#Polynomial Resids
resids <- lm.fit$residuals
ts.plot(resids,main='Polynomial Resids')
acf(resids,main='Poly Resids ACF')

#Splines Resids
resids <- gam.fit$residuals
ts.plot(resids,main='Splines Resids')
acf(resids,main='Splines Resids ACF')


#2

#A
acf(train.dif$AAPL, main = 'AAPL Dif ACF')
pacf(train.dif$AAPL, main = 'AAPL Dif PACF')

#B

#ARIMA order selection, AAPL
test_modelA <- function(p,d,q){
mod = arima(train$AAPL, order=c(p,d,q), method="ML")
current.aic = AIC(mod)
df = data.frame(p,d,q,current.aic)
names(df) <- c("p","d","q","AIC")
print(paste(p,d,q,current.aic,sep=" "))
return(df)
}

orders = data.frame(Inf,Inf,Inf,Inf)
names(orders) <- c("p","d","q","AIC")


for (p in 0:4){
  for (d in 0:2){
    for (q in 0:4) {
      possibleError <- tryCatch(
        orders<-rbind(orders,test_modelA(p,d,q)),
        error=function(e) e
      )
      if(inherits(possibleError, "error")) next

    }
  }
}
orders <- orders[order(-orders$AIC),]
tail(orders)
#3,1,3


#ARIMA order selection, GOOG
test_modelA <- function(p,d,q){
  mod = arima(train$GOOG, order=c(p,d,q), method="ML")
  current.aic = AIC(mod)
  df = data.frame(p,d,q,current.aic)
  names(df) <- c("p","d","q","AIC")
  print(paste(p,d,q,current.aic,sep=" "))
  return(df)
}

orders = data.frame(Inf,Inf,Inf,Inf)
names(orders) <- c("p","d","q","AIC")


for (p in 0:4){
  for (d in 0:2){
    for (q in 0:4) {
      possibleError <- tryCatch(
        orders<-rbind(orders,test_modelA(p,d,q)),
        error=function(e) e
      )
      if(inherits(possibleError, "error")) next
      
    }
  }
}
orders <- orders[order(-orders$AIC),]
tail(orders)
#2,1,0


#C
aapl.arima <- arima(train$AAPL,order = c(3,1,3), method = "ML")
#AAPL Root Analysis

#AR Roots
round(abs( polyroot( c(1 , coef(aapl.arima)[1:3]) )),2)
#.61, 1.77, 1.77

#MA Roots
round(abs( polyroot( c(1 , coef(aapl.arima)[(3+1):(3+3)]) )),2)
# 1.00, 1.00, 2.53

goog.arima <- arima(train$GOOG,order = c(2,1,0),method="ML")
#GOOG Root Analysis
#AR Roots
round(abs( polyroot( c(1 , coef(goog.arima)[1:2]) )),2)
#2.22, 2.64

#D
#AAPL Accuracy
preds1 <- as.vector(predict(aapl.arima,n.ahead=9))
preds <- preds1$pred
obs <- test$AAPL
#MAPE
mean(abs(preds - obs)/abs(obs)) #.1166
#Precision
sum((preds-obs)^2)/sum((obs-mean(obs))^2) #1.79


#GOOG Accuracy
preds2 <- as.vector(predict(goog.arima,n.ahead=9))
preds <- preds2$pred
obs <- test$GOOG
#MAPE
mean(abs(preds - obs)/abs(obs)) #.1256
#Precision
sum((preds-obs)^2)/sum((obs-mean(obs))^2) #7.12

#E
par(mfrow = c(1,1))

data.ts <- ts(data$AAPL,start = c(2014,1),freq =52)

vol=time(data.ts)
n = length(data.ts)
nfit = n-9

ubound = preds2$pred+1.96*preds2$se
lbound = preds2$pred-1.96*preds2$se
ymin = min(lbound)
ymax = max(max(ubound),max(data.ts))

par(mfrow=c(1,1))
plot(vol[nfit:n],data.ts[nfit:n],type="l", ylim=c(ymin,ymax), xlab="Time", main="GOOG Predictions", ylab = "Price Prop")
points(vol[(nfit+1):n],preds2$pred,col="red")
lines(vol[(nfit+1):n],ubound,lty=3,lwd= 2, col="blue")
lines(vol[(nfit+1):n],lbound,lty=3,lwd= 2, col="blue")

#3
#A
vs <- VARselect(train.dif)
vs$selection

mod <- VAR(train.dif,p=2)


## ARCH, Residual Analysis: Constant Variance Assumption
arch.test(mod)

## J-B, Residual Analysis: Normality Assumption
normality.test(mod)

## Portmantau, Residual Analysis: Uncorrelated Errors Assumption
serial.test(mod)

#B
preds.all <- as.vector(predict(mod,n.ahead=9))

#AAPL
preds <- preds.all$fcst$AAPL[,1]
obs <- test.dif$AAPL

#MAPE
mean(abs(preds - obs)/abs(obs)) #1.72
#Precision
sum((preds-obs)^2)/sum((obs-mean(obs))^2) #1.22


#GOOG
preds <- preds.all$fcst$GOOG[,1]
obs <- test.dif$GOOG

#MAPE
mean(abs(preds - obs)/abs(obs)) #2.98
#Precision
sum((preds-obs)^2)/sum((obs-mean(obs))^2) #.981


#4

#A
#ARIMA - GARCH Order Selection for GOOG

# #Initial GARCH Order
# #ARIMA-GARCH GARCH order
test_modelAGG <- function(m,n){
  spec = ugarchspec(variance.model=list(garchOrder=c(m,n)),
                    mean.model=list(armaOrder=c(1,1),
                      include.mean=T), distribution.model="std")
                    fit = ugarchfit(spec, train$GOOG, solver = 'hybrid')
                    current.bic = infocriteria(fit)[2]
                    df = data.frame(m,n,current.bic)
                    names(df) <- c("m","n","BIC")
                    print(paste(m,n,current.bic,sep=" "))
                    return(df)
}

orders = data.frame(Inf,Inf,Inf)
names(orders) <- c("m","n","BIC")


for (m in 0:2){
     for (n in 0:2){
          possibleError <- tryCatch(
            orders<-rbind(orders,test_modelAGG(m,n)),
            error=function(e) e
          )
          if(inherits(possibleError, "error")) next
          }
}
orders <- orders[order(-orders$BIC),]
tail(orders)
#1,1


# #ARMA update
# #ARIMA-GARCH ARIMA order
test_modelAGA <- function(p,q){
  spec = ugarchspec(variance.model=list(garchOrder=c(1,1)),
    mean.model=list(armaOrder=c(p,q),
                    include.mean=T), distribution.model="std")
    fit = ugarchfit(spec, train$GOOG, solver = 'hybrid')
    current.bic = infocriteria(fit)[2]
    df = data.frame(p,q,current.bic)
    names(df) <- c("p","q","BIC")
    print(paste(p,q,current.bic,sep=" "))
    return(df)
}

orders = data.frame(Inf,Inf,Inf)
names(orders) <- c("p","q","BIC")


for (p in 0:4){
     for (q in 0:4){
          possibleError <- tryCatch(
            orders<-rbind(orders,test_modelAGA(p,q)),
            error=function(e) e
          )
          if(inherits(possibleError, "error")) next
          }
}
orders <- orders[order(-orders$BIC),]
tail(orders)
#3,4 


# #GARCH update
test_modelAGG <- function(m,n){
  spec = ugarchspec(variance.model=list(garchOrder=c(m,n)),
                    mean.model=list(armaOrder=c(3,4),
                      include.mean=T), distribution.model="std")
                    fit = ugarchfit(spec, train$GOOG, solver = 'hybrid')
                    current.bic = infocriteria(fit)[2]
                    df = data.frame(m,n,current.bic)
                    names(df) <- c("m","n","BIC")
                    print(paste(m,n,current.bic,sep=" "))
                    return(df)
}

orders = data.frame(Inf,Inf,Inf)
names(orders) <- c("m","n","BIC")


for (m in 0:2){
     for (n in 0:2){
          possibleError <- tryCatch(
            orders<-rbind(orders,test_modelAGG(m,n)),
            error=function(e) e
          )
          if(inherits(possibleError, "error")) next
          }
}
orders <- orders[order(-orders$BIC),]
tail(orders)


#B,C
final.model = garchFit(~ arma(3,4)+ garch(1,1), data=train$GOOG, trace = FALSE)
summary(final.model)


#D
train.gar = data$GOOG
test = train.gar[(length(train.gar)-51):length(train.gar)]
train = train.gar[1:(length(train.gar)-52)]


nfore = length(test)
fore.series = NULL

spec = ugarchspec(variance.model=list(garchOrder=c(1,1)),
                  mean.model=list(armaOrder=c(3, 4), 
                                  include.mean=T), distribution.model="std")    


for(f in 1: nfore){
  ## Fit models
  data = train
  if(f>=2)
    data = c(train,test[1:(f-1)])  
  
  final.model = ugarchfit(spec, data, solver = 'hybrid')
  
  ## Forecast
  fore = ugarchforecast(final.model, n.ahead=1)
  fore.series = c(fore.series, fore@forecast$seriesFor)
  
}

#Accuracy measures
#GOOG
preds <- fore.series
obs <- tail(train.gar,52)

#MAPE
mean(abs(preds - obs)/abs(obs)) #.057
#Precision
sum((preds-obs)^2)/sum((obs-mean(obs))^2) #.308
