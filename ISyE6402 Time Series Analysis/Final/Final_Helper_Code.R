#ISYE 6402 Spring 2020
#Final Helper Code

#Useful Libraries
library(TSA)
library(mgcv)
library(vars)
library(tseries)
library(fGarch)
library(rugarch)

#ARIMA order selection template

# test_modelA <- function(p,d,q){
# mod = arima(?, order=c(p,d,q), method="ML")
# current.aic = AIC(mod)
# df = data.frame(p,d,q,current.aic)
# names(df) <- c("p","d","q","AIC")
# print(paste(p,d,q,current.aic,sep=" "))
# return(df)
# }
# 
# orders = data.frame(Inf,Inf,Inf,Inf)
# names(orders) <- c("p","d","q","AIC")
# 
# 
# for (p in 0:?){
#   for (d in 0:?){
#     for (q in 0:?) {
#       possibleError <- tryCatch(
#         orders<-rbind(orders,test_modelA(p,d,q)),
#         error=function(e) e
#       )
#       if(inherits(possibleError, "error")) next
# 
#     }
#   }
# }
# orders <- orders[order(-orders$AIC),]
# tail(orders)



#ARIMA root calculation template

#For model with order (p,d,q)
#AR Roots
# round(abs( polyroot( c(1 , coef(model.name)[1:p]) )),2)
#MA Roots
# round(abs( polyroot( c(1 , coef(model.name)[(p+1):(p+q)]) )),2)



#ARIMA - GARCH Order Selection

# #Initial GARCH Order
# #ARIMA-GARCH GARCH order
# test_modelAGG <- function(m,n){
#   spec = ugarchspec(variance.model=list(garchOrder=c(m,n)),
#                     mean.model=list(armaOrder=c(?,?), 
#                       include.mean=T), distribution.model="std")    
#                     fit = ugarchfit(spec, ?, solver = 'hybrid')
#                     current.bic = infocriteria(fit)[2]
#                     df = data.frame(m,n,current.bic)
#                     names(df) <- c("m","n","BIC")
#                     print(paste(m,n,current.bic,sep=" "))
#                     return(df)
# }
# 
# orders = data.frame(Inf,Inf,Inf)
# names(orders) <- c("m","n","BIC")
# 
# 
# for (m in 0:?){
#      for (n in 0:?){
#           possibleError <- tryCatch(
#             orders<-rbind(orders,test_modelAGG(m,n)),
#             error=function(e) e
#           )
#           if(inherits(possibleError, "error")) next
#           }
# }
# orders <- orders[order(-orders$BIC),]
# tail(orders)
# 
# #ARMA update
# #ARIMA-GARCH ARIMA order
# test_modelAGA <- function(p,q){
#   spec = ugarchspec(variance.model=list(garchOrder=c(?,?)),
#     mean.model=list(armaOrder=c(p,q), 
#                     include.mean=T), distribution.model="std")    
#     fit = ugarchfit(spec, ?, solver = 'hybrid')
#     current.bic = infocriteria(fit)[2]
#     df = data.frame(p,q,current.bic)
#     names(df) <- c("p","q","BIC")
#     print(paste(p,q,current.bic,sep=" "))
#     return(df)
# }
# 
# orders = data.frame(Inf,Inf,Inf)
# names(orders) <- c("p","q","BIC")
# 
# 
# for (p in 0:?){
#      for (q in 0:?){
#           possibleError <- tryCatch(
#             orders<-rbind(orders,test_modelAGA(p,q)),
#             error=function(e) e
#           )
#           if(inherits(possibleError, "error")) next
#           }
# }
# orders <- orders[order(-orders$BIC),]
# tail(orders)
# 
# 
# #GARCH update
# test_modelAGG <- function(m,n){
#   spec = ugarchspec(variance.model=list(garchOrder=c(m,n)),
#                     mean.model=list(armaOrder=c(?,?), 
#                       include.mean=T), distribution.model="std")    
#                     fit = ugarchfit(spec, ?, solver = 'hybrid')
#                     current.bic = infocriteria(fit)[2]
#                     df = data.frame(m,n,current.bic)
#                     names(df) <- c("m","n","BIC")
#                     print(paste(m,n,current.bic,sep=" "))
#                     return(df)
# }
# 
# orders = data.frame(Inf,Inf,Inf)
# names(orders) <- c("m","n","BIC")
# 
# 
# for (m in 0:?){
#      for (n in 0:?){
#           possibleError <- tryCatch(
#             orders<-rbind(orders,test_modelAGG(m,n)),
#             error=function(e) e
#           )
#           if(inherits(possibleError, "error")) next
#           }
# }
# orders <- orders[order(-orders$BIC),]
# tail(orders)






#ARIMA order selection template

# test_modelA <- function(p,d,q){
# mod = arima(train.ts, order=c(p,d,q), method="ML")
# current.aic = AIC(mod)
# df = data.frame(p,d,q,current.aic)
# names(df) <- c("p","d","q","AIC")
# print(paste(p,d,q,current.aic,sep=" "))
# return(df)
# }
# 
# orders = data.frame(Inf,Inf,Inf,Inf)
# names(orders) <- c("p","d","q","AIC")
# 
# 
# for (p in 0:?){
#   for (d in 0:?){
#     for (q in 0:?) {
#       possibleError <- tryCatch(
#         orders<-rbind(orders,test_modelA(p,d,q)),
#         error=function(e) e
#       )
#       if(inherits(possibleError, "error")) next
# 
#     }
#   }
# }
# orders <- orders[order(-orders$AIC),]
# tail(orders)


#VAR Model Forecast Values

#With VAR model named 'mod'
#preds.all <- as.vector(predict(mod,n.ahead=?))
#preds <- preds.all$fcst$Var.Name[,1]



#ARIMA root calculation template

#For model with order (p,d,q)
#AR Roots
# round(abs( polyroot( c(1 , coef(model.name)[1:p]) )),2)
#MA Roots
# round(abs( polyroot( c(1 , coef(model.name)[(p+1):(p+q)]) )),2)


