## Multiply matrix by a vector
## vector can be same length as # columns in a, or can be longer,
## in which case b[kint] is added to a * b[s:length(b)], s=length(b)-ncol(a)+1
## F. Harrell 17 Oct90
## Mod         5 Jul91 - is.vector -> !is.matrix
##            16 Oct91 - as.matrix -> matrix(,nrow=1)
##            29 Oct91 - allow b to be arbitrarily longer than ncol(a), use b(1)
##            13 Nov91 - matrix(,nrow=1) -> matrix(,ncol=1)
##            14 Nov91 - changed to nrow=1 if length(b)>1, ncol=1 otherwise
##            25 Mar93 - changed to use %*%
##            13 Sep93 - added kint parameter
##            22 Jun13 - allowed null kint, matrix b (e.g. bootstrap coefs)

matxv <- function(a, b, kint=1, bmat=FALSE)
{
  if(bmat) {
    if(!is.matrix(a)) stop('a must be a matrix when b is a matrix')
    ca <- ncol(a); cb <- ncol(b)
    if(cb < ca) stop('number of columns in b must be >= number in a')
    if(cb == ca) return(a %*% t(b))
    xx <- matrix(0, nrow=nrow(a), ncol=cb - ca)
    if(length(kint)) xx[, kint] <- 1.
    return(cbind(xx, a) %*% t(b))
  }

  if(!is.matrix(a))
    a <- if(length(b) == 1L) matrix(a, ncol=1L) else matrix(a, nrow=1L)

  nc <- dim(a)[2]
  lb <- length(b)
  if(lb < nc)
    stop(paste("columns in a (", nc, ") must be <= length of b (",
               length(b), ")", sep=""))

  if(nc == lb)
    drop(a %*% b)
  else {
    bkint <- if(length(kint)) b[kint] else 0.
    drop(bkint + (a %*% b[(lb - nc + 1L) : lb]))
  }
}
