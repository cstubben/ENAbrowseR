

ena_taxonomy <- function( id ){ 

   url <- paste0("http://www.ebi.ac.uk/ena/data/view/Taxon:", id, "&display=xml")
   doc <-  try(  xmlParse(url, error=NULL) , silent=TRUE  ) 

   if(class(doc)[1] == "try-error"){
      stop("No match to Taxon:", id )
   }
   id   <- xpathSApply(doc, "/ROOT/taxon", xmlGetAttr, "taxId")
   name <- xpathSApply(doc, "/ROOT/taxon", xmlGetAttr, "scientificName") 
   message( name, ", Taxid:", id) 

   ## GET taxonomy status
   url <- paste0("http://www.ebi.ac.uk/ena/data/stats/taxonomy/", id)
   x   <- read.table(url, row.names=1, stringsAsFactors=FALSE)

  #Portal View uses Taxon, Bases, Taxon descendants, Bases (subbases?)
   colnames(x) <- c("direct",  "bases" , "subtree" ,  "subsize")
   x[x == "N/A"] <- "-"
    # add space before Tb, Gb, Kb, Mb
   x$bases <- gsub("([TGKM])", " \\1", x$bases)
   x$subsize <- gsub("([TGKM])", " \\1", x$subsize)

   attr(x, "name") <- name
   attr(x, "taxid") <- id
   x
}


