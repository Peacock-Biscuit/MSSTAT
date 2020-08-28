# Trend Seasonality Estimation
######## harmonic function
harmonic <-
  function (x, m = 1) 
  {
    if (!is.ts(x) || (2 * m) > frequency(x)) 
      stop("x need to be a time series with 2m <= frequency(x)")
    y = outer(2 * pi * time(x), 1:m)
    cosy = apply(y, 2, cos)
    siny = apply(y, 2, sin)
    mult = 2 * (1:m)
    colnames(cosy) = paste(paste("cos(", mult, sep = ""), "*pi*t)", 
                           sep = "")
    colnames(siny) = paste(paste("sin(", mult, sep = ""), "*pi*t)", 
                           sep = "")
    out = cbind(cosy, siny)
    colnames(out) = c(colnames(cosy), colnames(siny))
    if ((2 * m) == frequency(x)) 
      out = out[, -(2 * m)]
    invisible(out)
  }
########
# Parametric
library(zoo)
library(dynlm)
lm_fit_par = dynlm(temp~trend(temp)+harmon(temp,2))
plot(fitted(lm_fit_par), lwd=2, type="l", ylab="Temperature", xlab="Year")

## Polynomial
poly_time.pts = c(1:length(temp))
# poly_time.pts = c(poly_time.pts-min(poly_time.pts))/max(poly_time.pts)
x1_square = poly_time.pts
x2_square = poly_time.pts^2
lm_fit_square = dynlm(temp~x1_square+x2_square+harmon(temp,2))
#### Almost overlap
lines(fitted(lm_fit_square), col='red',lwd=2)

summary(lm_fit_square)
dif.fit.lm = ts((temp-fitted(lm_fit_square)),start=1879,frequency=12)
ts.plot(dif.fit.lm,ylab="Residual Process")


## Fit a non-parametric model for trend and linear model for seasonality
har2 = harmonic(temp, 2) ## needed to be fixed
gam.fit = gam(temp~s(pt.time)+har2)
dif.fit.gam = ts((temp-fitted(gam.fit)),start=1879,frequency=12)
ts.plot(dif.fit.gam,ylab="Residual Process")

acf(temp,lag.max=12*8,main="")
acf(dif.fit.lm,lag.max=12*8,main="")
acf(dif.fit.gam,lag.max=12*8,main="")
