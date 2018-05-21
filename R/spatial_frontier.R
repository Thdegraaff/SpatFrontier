#' spatial_frontier
#'
#' @param formula Model formula
#' @param data Dataframe to be used
#' @param data_w Spatial weights matrix
#' @param frontier if TRUE a frontier analysis is executed
#'
#' @importFrom stats model.frame model.matrix model.response
#'
#' @return list with fitted elements from a maximum likelihood estimation
#' @export
#'
#' @examples
spatial_frontier <- function(formula, data = NULL, data_w = NULL, frontier = TRUE)
{
  mf <- model.frame(formula, data)
  y <- model.response(mf)
  x <- model.matrix(mf)
  x <- as.matrix(x)
  names_x <- dimnames(x)[[2]]
  w <- as.matrix(data_w)

  # Error messages
  if(!is.vector(y)) stop("y is not a vector")
  if(length(y) != nrow(x)) stop("x and y lengths differ")

  spatial_frontier_fit(y = y, x = x, w=w, fr = TRUE)
}
