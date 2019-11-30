# Non-parametric Regression - Kernel Regression
# A data frame giving a series of measurements of head acceleration 
# in a simulated motorcycle accident, used to test crash helmets.

# First, we should plot the data to see whether we should use Non-parametric regression
# Clearly, we could see there is no linear relationship in this plot. 
# So we use Kernel Regression for estimation.
library(MASS)
mcycle
cycleDF <- as.data.frame(mcycle)
X <- cycleDF$times
Y <- cycleDF$accel
plot(X, Y, main = "Scatter Plot", xlab = "Times", ylab = "Acceleration", pch = 19)

# Cross Validation
# Leave-one-out cross validation
n <- dim.data.frame(cycleDF)[1] # n: sample size

h_seq <- seq(from = 1.5,to = 10.0, by= 0.5)

# bandwidths we are using
CV_err_h <- rep(NA, length(h_seq))

for (j in 1:length(h_seq)){
  h_using <- h_seq[j]
  CV_err <- rep(NA, n)
  for (i in 1:n) {
    X_val <- X[i]
    Y_val <- Y[i]
    # Validation set
    X_tr <- X[-i]
    Y_tr <- Y[-i]
    # Training set
    Y_val_predict <- ksmooth(x = X_tr, y = Y_tr,
                            kernel = "normal", bandwidth = h_using, x.points = X_val)
    CV_err[i] <- (Y_val - Y_val_predict$y)^2
  }
  CV_err_h[j] <- mean(CV_err)
}
CV_err_h

# Plot which bandwidth we will use
plot(x=h_seq, y=CV_err_h, type="b", lwd=3, col="blue", xlab="Smoothing bandwidth", ylab="LOOCV prediction error")
which(CV_err_h == min(CV_err_h))

h_seq[which(CV_err_h == min(CV_err_h))]

# We choose 2.5 as our bandwidth in this dataset
Kreg <- ksmooth(x=X,y=Y,kernel = "normal",bandwidth = 0.9) 
plot(X,Y,pch=20)
lines(Kreg, lwd=4, col="purple")
