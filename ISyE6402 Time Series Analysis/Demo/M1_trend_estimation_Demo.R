# Module 1 Practice Example
data = read.table("AvTempAtlanta.txt", header=TRUE)

# plot time series
temp = as.vector(t(data[, -c(1, 14)]))
ts_a = ts(data=temp, start=1879, end=1949, frequency = 12)
plot(ts_a, ylab="Temperature")

# Trend: Moving Average Filter
# check width
q = c(1:length(temp)) # 1656 even
#q = c(q-min(q))/max(q) # Scale or not -> we want to see the trend
maf = ksmooth(q, temp, kernel = "box", bandwidth=1656)
maf_fit = ts(maf$y, start=1879, frequency = 12)

plot(ts_a, ylab="Temperature")
lines(maf_fit, lwd=2, col='red')
abline(maf_fit[1],0,lwd=2, col='blue')

# Trend: Parametric Regression
x1 = q
x2 = q^2

par_reg = lm(temp~x1+x2)
summary(par_reg)

lm_fit = ts(fitted(par_reg),start=1879, frequency=12)
plot(ts_a, ylab="Temperature")
lines(lm_fit, lwd=2, col="green")
abline(lm_fit[1], 0, lwd=2, col='blue')

# Trend: Non-Parametric
# loess
loc_fit = loess(temp~q)
temp_loc_fit = ts(fitted(loc_fit), start=1879, frequency = 12)
# splines
library(mgcv)
sp_fit = gam(temp~s(q))
temp_sp_fit = ts(fitted(sp_fit), start=1879, frequency=12)

plot(ts_a, ylab="Temperature")
lines(temp_loc_fit, lwd=2, col="red")
lines(temp_sp_fit, lwd=2, col='blue')
abline(temp_loc_fit[1], 0, lwd=2, col="brown")

# all comparison
all_val = c(maf_fit, lm_fit, temp_loc_fit, temp_sp_fit)
y_bound = c(min(all_val), max(all_val))
plot(lm_fit, lwd=2, col="green", ylim=y_bound,ylab="Temperature")
lines(maf_fit, lwd=2, col="purple")
lines(temp_sp_fit, lwd=2, col="red")
lines(temp_loc_fit, lwd=2, col="brown")
legend(x=1900, y=64,legend=c("MAV","LM","GAM","LOESS"),lty=1, col=c("purple","green","red","brown"))


