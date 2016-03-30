OlsFun <- function(param, x, y) {
        sigma <- param[length(param)]
        sigma <- sqrt(sigma^2)
        e <- y - x%*%param[1:length(param)-1]
        logl <- -(nObs/2)*log(2*pi*sigma^2) - (1/2)*(t(e)%*%e/sigma^2)
        return(logl)
}
