#' OLS Log-likelihood
#'
#' \code{ols_fun} Gives the OLS likelihood given the parameters
#'
#' @param dat Dataframe to be used
#' @param param Vector of parameters to be inserted
#'
#' @return The Log-likelihood of the OLS
#'
#' @export
#'
#' @examples
#' x <- runif(100, 0, 10)
#' y <- 2*x + rnorm(100,0,1)
#' dat <- data.frame(y,x)
#' ols_fun(dat, c(2,1))
ols_fun <- function(dat, param) {
  y <- dat[,1]
  x <- dat[,2]
  n <- length(y)
  sigma <- param[length(param)]
  sigma <- sqrt(sigma^2)
  e <- y - data.matrix(x)%*%param[1:length(param)-1]
  logl <- -(n/2)*log(2*pi*sigma^2) - (1/2)*(t(e)%*%e/sigma^2)
  return(logl)
}
