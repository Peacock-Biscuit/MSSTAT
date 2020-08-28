###### Case Study: Emergency Department Volume #####
library(tidyverse)
data = read.csv("EGDailyVolume.xls")

### EDA
library(ggplot2)
parse_date = function(data) {
  year = data[1]
  month = data[2]
  day = data[3]
  date = paste(year, month, day, sep="-")
  return(date)
}

dates = apply(data, MARGIN=1, FUN=parse_date)
dates = as.Date(dates, format="%Y-%m-%d")
vol = as.numeric(unlist(data[4]))
ggplot(data=data, aes(dates, vol)) + geom_line() + xlab("Time") + ylab("Daily Emergecy Volume")
## It seems like there is a trend and seasonality pattern

# For linear model assumption normality and non-constant eroor variance
par(mfrow=c(2,2))
hist(vol, nclass = 50, xlab="Volume", col="blue")
hist(log(vol), nclass=50)
hist(sqrt(vol+3/8), nclass=50)
hist(vol^2, nclass=50)

#### Based on plots, we chose log transformation
require(gridExtra)
old = ggplot(data=data, aes(dates, vol)) + geom_line() + xlab("Time") + ylab("Daily EV")
new = ggplot(data=data, aes(dates, log(vol))) + geom_line() + xlab("Time") + ylab("Transformed Daily EV")
grid.arrange(old, new, ncol=1, nrow=2)

### Trend Estimation
dev.off()
vol.tr = log(vol)
time.pts = c(1:length(vol.tr))
time.pts = c(time.pts-min(time.pts))
loc.fit = loess(vol.tr~time.pts)
vol.loc.fit = fitted(loc.fit)
library(mgcv)
gam.fit = gam(vol.tr~s(time.pts))
vol.gam.fit = fitted(gam.fit)
plot(dates, vol.tr, ylab="ED Volume", type="l")
lines(dates, vol.loc.fit, lwd=2, col="red")
lines(dates, vol.gam.fit, lwd=2, col="blue")

summary(loc.fit)
summary(gam.fit)

### Trend & Seasonality 
### Flu season so guess monthly seasonality
library(dynlm)
month = as.factor(format(dates, "%b")) # factor deals with categorical vars
gam_fit_month = dynlm(vol.tr~trend(time.pts) + month)
summary(gam_fit_month)
gam.month.fitted = fitted(gam_fit_month)
plot(dates, vol.tr, ylab="ED Volume", type="l")
lines(dates, gam.month.fitted, lwd=2, col="red")

### day week
week = as.factor(weekdays(dates))
dynlm.week = dynlm(vol.tr~trend(time.pts) + month + week)
summary(dynlm.week)
dynlm.week.fitted = fitted(dynlm.week)
plot(dates, vol.tr, ylab="ED Volume", type="l")
lines(dates, dynlm.week.fitted, lwd=2, col="red")

gam.week = gam(vol.tr~s(time.pts) + month + week)
summary(gam.week)
gam.week.fitted = fitted(gam.week)
plot(dates, vol.tr, ylab="ED Volume", type="l")
lines(dates, gam.week.fitted, lwd=2, col="red")

#### Comparison
plot(dates, gam.month.fitted, ylab="ED Volume", type="l")
lines(dates, gam.week.fitted, lwd=2, col="red")

### model comparison
lm.fit.month = lm(vol.tr~month)
lm.fit.week = lm(vol.tr~month + week)
anova(lm.fit.month, lm.fit.week)

#### Seasonality vs Trend
plot(dates, vol.tr, ylab="ED Volume", type="l")
lines(dates, vol.gam.fit, lwd=2, col="red")
lines(dates, gam.week.fitted, lwd=2, col="blue") ### capture seasonality and trend

### Residual Process
#### Trend Removal
resid_noT = vol.tr - vol.gam.fit
#### Season Removal
resid_noS = vol.tr - fitted(lm.fit.week)
#### Remove boyh
resid_noST = vol.tr - gam.week.fitted

y.min = min(c(resid_noT,resid_noS,resid_noST))
y.max = max(c(resid_noT,resid_noS,resid_noST))
plot(dates, resid_noT, ylab="Residual Process", type="l")
lines(dates, resid_noS, lwd=2, col="red")
lines(dates, resid_noST, lwd=2, col="blue")

### ACF
dev.off()
acf(resid_noT, lag.max = 12*4)
acf(resid_noS, lag.max = 12*4, col="red")
acf(resid_noST, lag.max = 12*4, col="blue")


