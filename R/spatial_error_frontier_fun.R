#' Spatial error frontier distribution
#'
#' @param y The endogeneous variable
#' @param X The dataframe
#' @param param The parameters to be estimated
#' @param W The spatial weight matrix
#'
#' @importFrom stats pnorm
#'
#' @return
#' @export
#'
#' @examples
spatial_error_frontier_fun <- function(y, X, param, W){

  n <- length(y)

  alpha <- param[length(param)-1]
  lambda<- param[length(param)]
  sigma <- param[length(param)-2]

  #         sigma <- sqrt(sigma^2)
  alpha  <- - sqrt(alpha^2)
  lambda <- 2*(exp(lambda)/(1+exp(lambda)))-1

  Xb <-  X%*%param[1:(length(param)-3)]
  B <- (diag(n) - lambda*W)
  e <- y - Xb

  Be <- B%*%e
  nu <- alpha*(1/sigma)

  term1 <- -(n/2)*log(pi*sigma^2)+log(det(B))
  term2 <- -(1/(2*sigma^2)) * (t(Be)%*%Be)
  term3 <- colSums(log(2*pnorm(nu*Be)))

  ret <- (term1+ term2 +term3)/n

  names(ret) <- "Spatial error frontier distribution"
  return(ret)
}
