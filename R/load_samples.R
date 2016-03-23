
load_samples <- function( file.prefix, drop=TRUE, n = 0.99 ){

   x <- list.files(".", pattern= paste0("^", file.prefix ) )
   x <- x[!grepl("rda$", x)]

   nx <- length(x)
   if(nx == 0) stop("No files starting with ", file.prefix)
   y <- vector("list", nx)

   for(i in 1:nx){
      message("Loading ",  x[[i]] )
      x1 <- read.delim(x[[i]], stringsAsFactors=FALSE, quote="")
      # some rows with all NAs (and total rows in file is usually more than limit+1 in ena_download)
      n2 <- nrow(subset(x1, is.na(tax_id)))
      if(n2 > 0){
         x1 <- subset(x1, !is.na(tax_id)) 
         message(" Deleting ", n2, " empty rows")
      }
      y[[i]] <- x1
   }
   z <- do.call("rbind", y)
   z$first_public <- as.Date(z$first_public)
   ## drop columns - this is slow
   if(drop){
      nc1 <- ncol(z)
      # fix columns with "N" for NA in  SAMPLES only
      if(names(z)[2] == "secondary_sample_accession"){
         z$germline[z$germline=="N"] <- NA
         z$environmental_sample[z$environmental_sample=="N"] <- NA
      }
      n1 <- apply(z, 2, function(y) sum(is.na(y) | y=="") )
      n2 <- n1/nrow(z) < n
      z <- z[, n2]
      nc2 <- ncol(z)
      if(nc1 > nc2) message("Dropping ", nc1-nc2, " columns > ", n, " NAs")  
   }
   z

}



