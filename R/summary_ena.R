summary_ena <- function(x){
  # unique
  x1 <- apply(x, 2, function(y) length(unique(na.omit(y))))
  x2 <- apply(x, 2, function(y) sum(!(is.na(y) | y=="" )))
  y <- data.frame(t( rbind(x1, x2)) )   
   names(y) <- c("unique", "total")
  # y <- subset(y, total > 0)
   y <- y[order(y$unique, y$total, decreasing=TRUE),]
   y
}
