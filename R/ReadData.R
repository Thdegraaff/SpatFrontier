###########################################################################
## Author:      Thomas de Graaff
## What:        Reads and prepares dataset for analysis spatial frontier
## Edited:      13-06-2014
###########################################################################
library(plyr)
library(reshape)
##########################################################################    
# Read in KL Database
###########################################################################
DataReg <- read.csv("Data/databasis20002010.csv", stringsAsFactors=TRUE)
###########################################################################    
# Read additional data and merge with KL database
###########################################################################
Determinants <- read.csv("Data/Determinants.csv", stringsAsFactors=TRUE)
Determinants <- rename(Determinants, c(Index="id"))
DataReg <- merge(DataReg, Determinants,by="id")
DataReg$gamscode <- NULL
DataReg$Name <- NULL
DataReg$NutsCode <- NULL
DataReg$Region <- NULL
###########################################################################    
# Take the mean of each variable
###########################################################################
DataReg <- aggregate(DataReg, list(id = DataReg$id), mean)
###########################################################################    
# Remove the first id variable
###########################################################################
DataReg[,1] <- NULL
###########################################################################    
# Make sure data is sorted on id (similar as gamscode)
###########################################################################
DataReg <- DataReg[order(DataReg$id),]
DataReg[is.na(DataReg)] <- 1