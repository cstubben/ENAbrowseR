

add_lat_lon <- function(x, geocode = TRUE){

   # SPLIT locations 33.55 N 118.4 W

   y <- strsplit(x$location, " ")

   n <- sapply(y, "[", 4)  =="W"
   longs <- as.numeric( sapply(y, "[", 3) )
   longs <- ifelse(n, longs*(-1), longs)
   x$lon <- longs

   n <- sapply(y, "[", 2)  =="S"
   lats <- as.numeric( sapply(y, "[", 1) )
   lats <- ifelse(n, lats*(-1), lats)
   x$lat <- lats

   if(geocode){

      #countries to geocode
      z1 <-  sort( unique(m1$country[m1$location=="" & m1$country!=""] ) )

      message("Geocoding missing locations for\n ", paste(z1, collapse="\n "))
      z2 <- suppressMessages( geocode(z1, output="more") )
      z2$geocode <- z1

      n <- match(x$country, z2$geocode)
      # don't overwrite lat long if present
      n[!is.na(x$lon)] <- NA
      n2 <- which(!is.na(n) )
      x$lat[n2] <-    z2$lat[n[n2]]
      x$lon[n2] <-    z2$lon[n[n2]]
   }
   x
}

