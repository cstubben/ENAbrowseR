

ena_search <- function( query,  result="sample", fields, offset, sortfields, limit=10000, drop=TRUE, n = 0.99, showURL=FALSE, resultcount=FALSE){

   if(missing(fields)){
     if(!exists("usage")) data(usage)
     fields <-  usage$fields[[ result ]]
   }
   if(drop){
     # drop Catalogue of Life taxonomy names and ids (tax_id from NCBI and col_tax_id from CoL)
     fields <- fields[!grepl("^col_", fields)]
   }
     fields <- paste(fields, collapse=",")
 
   base_url <- "http://www.ebi.ac.uk/ena/data/warehouse/search"

   if(resultcount){

      url <- paste0( base_url , "?query=", query, "&result=", result, "&resultcount")
      url2 <- URLencode(url)
      if(showURL) message(url2)
      # suppress warning about incomplete final line 
      x <- suppressWarnings(readLines(url2))
      x <- x[1]
   }else{
      url <- paste0( base_url , "?query=", query, "&result=", result, "&fields=", fields, "&limit=", limit, "&display=report")

      if(!missing(offset)) url <- paste0(url, "&offset=", offset )
      if(!missing(sortfields)) url <- paste0(url, "&sortfields=", sortfields )

      url2 <- URLencode(url)
      if(showURL) message(url2)

      # use read_delim in readr?  too many strains are numbers and read_delim only checks the first 1000 rows,
      # x <- read_delim(url2, "\t")

      x <- read.delim(url2, stringsAsFactors=FALSE, quote="")

      if(result == "sample"){
           x$germline[x$germline == "N"]<- NA
           x$environmental_sample[x$environmental_sample == "N"]<- NA
      }
      if(drop){
         nc1 <- ncol(x)
         n1 <- apply(x, 2, function(y) sum(is.na(y) | y=="") )
         n2 <- n1/nrow(x) < n
         x <- x[, n2]
         nc2 <- ncol(x)
         if(nc1 > nc2) message("Dropping ", nc1-nc2, " columns > ", n, " NAs")  
      }
      attr(x, "url") <- url
      message(nrow(x), " rows")
   }
   x
}
