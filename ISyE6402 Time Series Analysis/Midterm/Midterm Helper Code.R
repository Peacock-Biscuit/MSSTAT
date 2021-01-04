library(TSA)
library(mgcv)

#Helper code

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



#ARIMA root calculation template

#For model with order (p,d,q)
#AR Roots
# round(abs( polyroot( c(1 , coef(model.name)[1:p]) )),3)
#MA Roots
# round(abs( polyroot( c(1 , coef(model.name)[(p+1):(p+q)]) )),3)
