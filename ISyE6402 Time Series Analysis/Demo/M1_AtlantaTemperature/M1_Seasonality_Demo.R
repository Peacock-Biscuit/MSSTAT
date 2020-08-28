# Seasonality Estimation

library(dynlm)
# Seasonal Means Model
model1 = dynlm(ts_a~season(ts_a))
summary(model1)

## without intercept
model2 = dynlm(ts_a~season(ts_a)+0)
summary(model2)

## harmonic
model3 = dynlm(ts_a~harmon(ts_a, 1))
summary(model3)

model4 = dynlm(ts_a~harmon(ts_a, 2))
summary(model4)

series1 = coef(model2)
series2 = fitted(model4)[1:12]
plot(1:12, series1, lwd=2, type="l",xlab="Month", ylab="Temperature")
lines(1:12, series2, lwd=2, col="blue")
