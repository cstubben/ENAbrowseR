

ena_search <- function( query,  result="sample", fields, offset, sortfields, limit=10000, drop=TRUE, showURL=FALSE, resultcount=FALSE){

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

     if(!missing(offset)) url <- paste0(url, "&offset", offset )
     if(!missing(sortfields)) url <- paste0(url, "&sortfields", sortfields )

     url2 <- URLencode(url)
     if(showURL) message(url2)

     # use read_delim in readr?  too many strains are numbers and read_delim only checks the first 1000 rows,
     # x <- read_delim(url2, "\t")

     x <- read.delim(url2, stringsAsFactors=FALSE, quote="")

     if(drop){  
        # drop empty columns
        n  <- apply(x, 2, function(y) all(is.na(y) | y == "")) 
        # and if germline and env. sample are all "N"
        if(result == "sample"){
           if(all(x$germline == "N") ) n["germline"] <- TRUE
           if(all(x$environmental_sample == "N") ) n["environmental_sample"] <- TRUE
        }
        if(sum(n)>0){
           message("Dropping ", sum(n) , " empty columns")
           #paste(names(n[n]), collapse=", ")
           x <- x[, !n]      
        }
     }
     attr(x, "url") <- url
     message(nrow(x), " rows")
   }
   x
}
