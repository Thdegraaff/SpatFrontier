library(spdep)
library(maptools)
library(MASS)
library(plyr)

set.seed(1)

Regions<-readShapePoly("Data/RegionsRiE2010.shp")
Regions <- Regions[order(Regions$id),]
coords <- coordinates(Regions)
IDs<-row.names(as(Regions, "data.frame"))
Reg4<-knn2nb(knearneigh(coords, k=4), row.names=IDs)
Reg4_w<- nb2listw(Reg4)
W <- listw2mat(Reg4_w)
nObs <- nrow(W)
e <- NULL

OlsFun <- function(param) {
        sigma <- param[length(param)]
        sigma <- sqrt(sigma^2)
        e <- Y - X%*%param[1:length(param)-1]
        logl <- -(nObs/2)*log(2*pi*sigma^2) - (1/2)*(t(e)%*%e/sigma^2)
        return(logl)     
}

SpatialErrorFun <- function(param){
        sigma <- param[length(param)-1]
        sigma <- sqrt(sigma^2)        
        lambda <- param[length(param)]
        lambda <- (2*exp(lambda))/(1+exp(lambda))-1
        Xb <-  X%*%param[1:(length(param)-2)]
        detA <- det(diag(nObs) - lambda*W)
        e <- (diag(nObs) - lambda*W)%*%(Y - Xb);
        logl 	= -(nObs/2)*log(pi*sigma^2) + log(detA) - (t(e)%*%e)/(2*sigma^2)
        return(logl) 
}

SpatialLagFun <- function(param){
        sigma <- param[length(param)-1]
        sigma <- sqrt(sigma^2)        
        rho <- param[length(param)]
        rho <- 2*(exp(rho)/(1+exp(rho)))-1    
        Xb <-  X%*%param[1:(length(param)-2)]
        detA <- det(diag(nObs) - rho*W)
        e <- Y - rho * W %*% Y - Xb
        logl <- -(nObs/2)*log(pi*sigma^2) + log(detA) - (t(e)%*%e)/(2*sigma^2)
        return(logl)
}

FrontierFun <- function(param){
        alpha <- param[length(param)]
        sigma <- param[length(param)-1]
        sigma <- sqrt(sigma^2)
        Xb <-  X%*%param[1:(length(param)-2)]
        alpha <- - sqrt(alpha^2)        
        delta <<- alpha/(sqrt(1+alpha^2))
        b <- sqrt(2/pi)
        muz <- b*delta
        sigmaz <- sqrt(1 - muz^2)
        z <- muz + (sigmaz/sigma)*(Y - Xb)
        gamma <- (4-pi)/2 *((muz^3) /(1-muz^2)^(3/2))
        term1 <- -(nObs/2)*log(pi) + (nObs)*log(sigmaz/sigma) - (1/2)*(t(z)%*%z)
	term2 <- colSums(log(2*pnorm(alpha*z)))

# 	z <-  (Y - Xb)/sigma
# 	term1 <- -(nObs/2)*log(pi) - (1/2)*(nObs)*log(sigma^2) - (1/2)*(t(z)%*%z)
#         term2 <- colSums(log(2*pnorm(alpha*z)))

        e <<- Y - Xb

        return(term1 + term2)
}

SpatialFrontierErrorFun <- function(param){
        alpha <- param[length(param)-1]
        lambda<- param[length(param)]
        sigma <- param[length(param)-2]
#         sigma <- sqrt(sigma^2)
        alpha  <- - sqrt(alpha^2)
        lambda <- 2*(exp(lambda)/(1+exp(lambda)))-1        
        Xb <-  X%*%param[1:(length(param)-3)]
        B <- (diag(nObs) - lambda*W)
        e <<- Y - Xb
        Be <- B%*%e
        nu <- alpha*(1/sigma)
        term1 <- -(nObs/2)*log(pi*sigma^2)+log(det(B))
        term2 <- -(1/(2*sigma^2)) * (t(Be)%*%Be)
        term3 <- colSums(log(2*pnorm(nu*Be)))
        return(term1+ term2 +term3)/nObs
}

SpatialFrontierLagFun <- function(param){
        alpha <- param[length(param)-1]
        rho<- param[length(param)]
        sigma <- param[length(param)-2]
        sigma <- sqrt(sigma^2)
        alpha  <- -sqrt(alpha^2)
        rho <- 2*(exp(rho)/(1+exp(rho)))-1    
        Xb <-  X%*%param[1:(length(param)-3)]
        B <- (diag(nObs) - rho*W)
        Be <- Y - (rho *W)%*%Y - Xb
        nu <- alpha*(1/sigma)
        term1 <- -(nObs/2)*log(pi*sigma^2)+log(det(B))
        term2 <- -(1/(2*sigma^2)) * (t(Be)%*%Be)
        term3 <- colSums(log(2*pnorm(nu*Be)))
        e <<- Be
        return(term1+ term2 +term3)/nObs
}

FindTEFrontier <- function(s){
        sigma <- s$estimate["$\\sigma$",1]
        alpha <- s$estimate["$\\alpha$",1]
        delta <- alpha/(sqrt(1+alpha^2))
        D <- delta
        Sigma <- sigma^2
        expect <- (1/(D*(1/Sigma)*D+1))*D*(1/Sigma)*e
        variance <- (1/(D*(1/Sigma)*D+1))
        nRepl <- 1000
        countones <- vector(mode = "numeric", length(e))
        tempmat   <- vector(mode = "numeric", length(e))
        for(i in 1:nRepl){
                helpmat <- expect + rnorm(length(e),variance)
                teller <- helpmat >= 0
                countones <- countones + teller
                tempmat <- tempmat + teller*helpmat
        }
        TE <- (-1*tempmat/countones)
        TE <- exp(TE)
        TE[is.na(TE)] <- 1
        return(TE)
}

FindTEFrontierError <- function(s){
        sigma <- s$estimate["$\\sigma$",1]
        alpha <- s$estimate["$\\alpha$",1]
        lambda<- s$estimate["$\\lambda$",1]
        alpha <- rep(alpha, nObs)
        Omega <- sigma^2 * ginv(t(diag(nObs) - lambda*W) %*% (diag(nObs) - lambda*W))
        delta <- ((1 + t(alpha)%*%Omega%*%alpha)^(-0.5))
        delta <- delta[1]*(Omega%*%alpha)
        D <- delta[1]*diag(nObs)
        expect <- ginv(diag(nObs) + t(D)%*%ginv(Omega)%*%D)%*%t(D)%*%ginv(Omega)%*%e
        variance <- ginv(diag(nObs) + t(D)%*%ginv(Omega)%*%D)
        nRepl <- 1000
        countones <- vector(mode = "numeric", length(e))
        tempmat   <- vector(mode = "numeric", length(e))
        for(i in 1:nRepl){
                helpmat <- mvrnorm(1, expect, variance)
                teller <- helpmat >= 0
                countones <- countones + teller
                tempmat <- tempmat + teller*helpmat
        }
        TE <- (-1*tempmat/countones)
        TE <- exp(TE)
        TE[is.na(TE)] <- 1
        return(TE)
}

FindTEFrontierLag <- function(s){
        sigma <- s$estimate["$\\sigma$",1]
        alpha <- s$estimate["$\\alpha$",1]
        rho   <- s$estimate["$\\rho$",1]
        alpha <- rep(alpha, nObs)
        Omega <- sigma^2 * ginv(t(diag(nObs) - rho*W) %*% (diag(nObs) - rho*W))
        delta <- ((1 + t(alpha)%*%Omega%*%alpha)^(-0.5))
        delta <- delta[1]*(Omega%*%alpha)
        D <- delta[1]*diag(nObs)
        expect <- ginv(diag(nObs) + t(D)%*%ginv(Omega)%*%D)%*%t(D)%*%ginv(Omega)%*%e
        variance <- ginv(diag(nObs) + t(D)%*%ginv(Omega)%*%D)
        nRepl <- 1000
        countones <- vector(mode = "numeric", length(e))
        tempmat   <- vector(mode = "numeric", length(e))
        for(i in 1:nRepl){
                helpmat <- mvrnorm(1, expect, variance)
                teller <- helpmat >= 0
                countones <- countones + teller
                tempmat <- tempmat + teller*helpmat
        }
        TE <- (-1*tempmat/countones)
        TE <- exp(TE)
        TE[is.na(TE)] <- 1
        return(TE)
}
  
