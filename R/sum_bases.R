sum_bases <-function(x, round=0)
{
x <- sum(as.numeric(x), na.rm=TRUE)
ifelse( x< 10^3, paste(x, "bp"),
 ifelse(x< 10^6, paste(round( x/ 10^3, round) , "kbp"),
   ifelse(x< 10^9, paste(round( x/ 10^6, round) , "Mbp"), 
     ifelse(x< 10^12, paste(round( x/ 10^9, round) , "Gbp"), 
       paste(round( x/ 10^12, round) , "Tbp") ))))
}
