spatial_frontier_fit <- function(y = y, x = x, w=w, fr = TRUE){

  ols <- lm(y~0+x)
  start <- coefficients(ols)




  if(!is.null(w)){
    if(fr == TRUE){
      # This is the spatial error frontier model
      param <- c(start, 0.2, 0.2, 0.2)
      res.err <- maxLik(spatial_error_frontier_fun, start=param, print.level=1, method = "BFGS", y = y, X = x, W = w)
      summary(res.err)
    }
  }
}
