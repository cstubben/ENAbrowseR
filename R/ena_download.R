

ena_download <- function( query,  result="sample", fields, file="ena.tsv", limit=100000, offset=1){

   if(missing(fields)){
     if(!exists("usage")) data(usage)
     fields <-  usage$fields[[ result ]]
   }
   # drop Catalogue of Life taxonomy names and ids (tax_id from NCBI and col_tax_id from CoL)
   fields <- fields[!grepl("^col_", fields)]
   fields <- paste(fields, collapse=",")

 
   base_url <- "http://www.ebi.ac.uk/ena/data/warehouse/search"
   url <- paste0( base_url , "?query=", query, "&result=", result, "&fields=", fields, "&limit=", limit, "&offset=", offset, "&display=report")


   url2 <- URLencode(url)

    # use read_delim in readr?  too many strains are numbers and read_delim only checks the first 1000 rows,
   # x <- read_delim(url2, "\t")

   x <- read.delim(url2, stringsAsFactors=FALSE, quote="")

   download.file(url2, destfile = file)

}
