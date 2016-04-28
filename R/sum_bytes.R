sum_bytes <-function(x, signif = 3)
{
   x <- sum(as.numeric(x), na.rm=TRUE)

   ifelse(x < 2^10,  x,
     ifelse(x < 2^20,       paste(signif( x/ 2^10, signif), "KB"),
       ifelse(x < 2^30,     paste(signif( x/ 2^20, signif), "MB"), 
         ifelse(x < 2^40,   paste(signif( x/ 2^30, signif), "GB"), 
           ifelse(x < 2^50, paste(signif( x/ 2^40, signif), "TB"), 
                            paste(signif( x/ 2^50, signif), "PB") )))))
}

