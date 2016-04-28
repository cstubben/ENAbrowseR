sum_bases <-function(x, signif = 3)
{
x <- sum(as.numeric(x), na.rm=TRUE)

ifelse( x< 10^3,        paste(x, "bp"),
 ifelse(x< 10^6,        paste(signif( x/ 10^3, signif) , "kb"),
   ifelse(x< 10^9,      paste(signif( x/ 10^6, signif) , "Mb"), 
     ifelse(x< 10^12,   paste(signif( x/ 10^9, signif) , "Gb"), 
       ifelse(x< 10^15, paste(signif( x/ 10^12, signif), "Tb"), 
                        paste(signif( x/ 10^15, signif), "Pb"))))))
}


