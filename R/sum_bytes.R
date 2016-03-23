sum_bytes <-function(x, round=0)
{
   x <- sum(x, na.rm=TRUE)
   ifelse(x < 2^10,  x,
     ifelse(x < 2^20,     paste(round( x/ 2^10, round), "KB"),
       ifelse(x < 2^30,   paste(round( x/ 2^20, round), "MB"), 
         ifelse(x < 2^40, paste(round( x/ 2^30, round), "GB"), 
                         paste(round( x/ 2^40, round), "TB") ))))
}
