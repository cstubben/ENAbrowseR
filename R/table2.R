table2<- function(x, n=10){
  x[x==""] <- NA  
  y <- sort(table(x), decreasing=TRUE)
  if(length(y) > n) y <- y[1:n]
  data.frame(n=y)
}
