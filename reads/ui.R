#library(shiny)

shinyUI(fluidPage(
    ## hack to  align action button  with textInput box
    tags$head(   tags$style(type='text/css', 'button#update{ margin-top: 25px;}') ),

    titlePanel( 'Sequence Read Archive'),
    fluidRow(
             column(8, checkboxGroupInput("tax", "Search", c("metagenomes", "bacteria", "archaea", "viruses", "eukaryota", "humans"), selected="metagenomes", inline=TRUE)),
                    column(2, numericInput("days", "Days <", 7, 1, 30)),
           # color like submitButton  
             column(2, actionButton("update", "Submit",  style="color: #fff; background-color: #337ab7; border-color: #2e6da4" ))
             ),
            
     tabsetPanel(type = "tabs", 
                 tabPanel("Studies",  DT::dataTableOutput("ex2") ) ,
                                        #             br(), downloadButton('downloadData', 'Download') ),
                 tabPanel("Samples",   leaflet::leafletOutput("map")  ),            
                 tabPanel("Runs",  fluidPage(splitLayout( highcharter::highchartOutput("plot1"), highcharter::highchartOutput("plot2") ))  )
           #          tabPanel("Plots",  highchartOutput("plot1")  )
                
     )  
))
