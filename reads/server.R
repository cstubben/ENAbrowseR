library(shiny)
library(DT)
library(dplyr)
library(highcharter)
library(ENAbrowseR)
library(leaflet)

ids <- c(metagenomes=408169, bacteria=2, archaea=2157, viruses=10239, eukaryota=2759, humans=9606)

format_q1 <- function(tax, days){
   n <- match(tax, names(ids))
                q1 <- paste0("tax_tree(", ids[n], ")", collapse= " OR ")
                q1 <- paste0("(", q1, ")")
                # IF eukaryote and not human (then skip human)
                if("eukaryota" %in% tax & !"humans" %in% tax) q1 <- paste0( q1, " AND NOT tax_tree(9606)")
   q1 <- paste0(q1, " AND first_public>", Sys.Date()- days)
   q1
}


shinyServer(function(input, output) {

runs <- eventReactive(input$update, {
     # isolate({
         withProgress({
             setProgress(message = "Searching read_run in ENA...")
                req(input$tax)
                q1 <- format_q1(input$tax, input$days)
                ## columns
                Columns <- c("study_accession", "study_title", "first_public", "scientific_name", "sample_accession","base_count")
                      
                r7 <- ena_search(q1,  "read_run", limit=1e5, fields= Columns, drop=FALSE)
                validate(
                  need(nrow(r7) > 0, paste("No results found in last", input$days, "days") )
                )        
                attr(r7, "days") <- input$days
                r7     
            })
     #   })
  })


output$ex2 <- DT::renderDataTable({
        r7 <- runs()
         x1 <- group_by(r7, study_accession)  %>% summarize( title = first(study_title), released=first(first_public),
                        taxonomy= first(scientific_name), samples= n_distinct(sample_accession), runs=n()  )
         names(x1)[1] <- "study"
       # replace underscore in project tiles  - will mess up column widths
          x1$title <- gsub("_+", " ", x1$title) 
           # caption
          capt <- paste( nrow(r7), "runs from", nrow(x1), "studies released in last", attr(r7, "days"), "days.")
        x1 <- x1[order(x1$released, x1$study, decreasing=TRUE),]
        ## link to ENA - many recent projects are missing links
       #   x1$study <- paste0('<a href="http://www.ebi.ac.uk/ena/data/view/', x1$study, '" target="_blank">', x1$study,  '</a>')
        x1$study <- paste0('<a href="http://www.ncbi.nlm.nih.gov/sra/?term=', x1$study, '" target="_blank">', x1$study,  '</a>')

         # release dates all wrap
         DT::datatable(x1, escape=1, caption=capt, options = list(columnDefs = list(list(width = '80px', targets = 3 ))) )
     
    })

   
samples <- eventReactive(input$update, {
         withProgress({
             setProgress(message = "Searching sample in ENA...")
                req(input$tax)
                q1 <- format_q1(input$tax, input$days)
                ## columns
                Columns2 <- c("accession", "scientific_name", "collection_date", "country", "location", "isolation_source", "environment_feature")
             s7 <- ena_search(q1, "sample", limit = 1e5, fields=Columns2, drop=FALSE)
            # setProgress(message = "Geocoding place names with missing location...")
             validate(
                  need(!all(is.na(s7$location)), paste("No sample locations found") )
             )
             ## GEOCODING is very slow 
            s7x <- add_lat_lon(s7, geocode=FALSE)
            # s7x <- add_lat_lon(s7)    
                s7x     
            })
  })



output$map <- renderLeaflet({
    s7 <- samples()
   
    x<- subset(s7, !(lon=="" | is.na(lon)) )
    
    pops <- paste0("<strong>Sample:", x$accession, "</strong><br>name:", x$scientific_name,
               "<br>country:", x$country, "<br>environment:",
               ifelse(x$environment_feature=="", x$isolation_source, x$environment_feature )) 
    leaflet(x)  %>%
        addTiles() %>%
            addCircleMarkers( x$lon, x$lat,  clusterOptions = markerClusterOptions(maxClusterRadius=20) , radius=2,  popup= pops  )

       })



#output$downloadData <- downloadHandler(
#    filename = function() { paste(input$tax[1], '.tsv', sep='') },
#    content = function(file) {
#       r7<- runs()[, c("study_accession", "run_accession", "sra_ftp")]  
#      write.table(r7, file, sep="\t", quote=FALSE, row.names=FALSE)
#    }
#)


output$plot1 <- renderHighchart({
      r7 <- runs()   
       # get zero counts for cross-tabs   
      r7$first_public <- factor( r7$first_public, as.character(seq.Date( (Sys.Date()- attr(r7, "days")+1), Sys.Date() , by=1) ))
      x <- table(r7$first_public)
     hc <- highchart() %>% 
        hc_chart(type = "column") %>% 
          hc_xAxis(categories = names(x), title = list(text = "Released") ) %>%
            hc_yAxis(title = list(text = "Runs"))  %>%
              hc_legend(enabled = FALSE) %>% 
                  hc_add_series(data = x, name="Runs")
    #  hc                                             #dates are always rotated
     # hc %>% hc_add_theme(hc_theme_sandsignika())  
      hc %>% hc_add_theme(hc_theme_google())       
   })

output$plot2 <- renderHighchart({
       r7 <- runs()   
   hc <-  hchart(log10(r7$base_count)) %>%
       hc_legend(enabled = FALSE) %>%
         hc_xAxis( title = list(text = "Bases (log10)") ) %>%
             hc_yAxis(title = list(text = "Runs"))
       hc
     #  hc %>% hc_add_theme(hc_theme_sandsignika())
       hc %>% hc_add_theme(hc_theme_google())
   })
})
