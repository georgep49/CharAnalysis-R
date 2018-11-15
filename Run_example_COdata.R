rm(list=ls())

# Load data

#### Load packages
library(caTools) # function: runmean()
library(mclust)
library(Matching)


## Load R source files
source("./R/pretreatment_full.r")
source("./R/CHARsm.r")
source("./R/CharThreshLocal.r")
source("./R/CharPeaks.r")


# 1. Load Charcoal data ####
CO <- read.csv("./Cores/CO/CO_charData.csv")

# 2. Pretreatment
CO.I <- pretreatment_full(params=CO[ ,1:5], serie=CO[ ,6], Int=F,
                                 first=-42, last=7444, yrInterp=15)
plot(CO.I)

# 3. Smooth record
CO.sm <- CHARsm(x=CO.I, smoothing.yr=500)
COsm <- as.data.frame(CO.sm[c(1:6,11:16)])
#pdf("CO_smooth.pdf")
plot(CO.sm)
#dev.off()

# 4. Peak detection (Local threshold)
CO.thresh <- CharThreshLocal(x=CO.sm, sm.meth="Moving Median", thresh.yr=500,
                             thresh.values=c(0.95, 0.990, 0.999, 0.990), plot.thresh=T)

# 5. Identify peaks based on Cback and on local threshold
CO.peak <- CharPeaks(x=CO.thresh, minCountP=0.05)

#pdf("CO_peaks.pdf")
plot(CO.peak)
#dev.off()

#pdf("CO_SNI.pdf")
plot.SNI(CO.peak)
#dev.off()

