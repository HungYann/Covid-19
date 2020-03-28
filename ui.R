library(jsonlite)
library(geojsonio)
library(dplyr) 
library(leaflet)
library(shiny)
library(RColorBrewer)
library(scales)
library(lattice)
library(DT)
library(googleCharts)
library(ggplot2)
library(ggthemes)
library(rsconnect)

#country不变，year改为date,显示的数字改为confirmed cases

analyticsData<-read.csv("countries-aggregated.csv")






va <- names(dataAnalytics)
vars <-va[-1:-2]



years<-analyticsData$Date
  

xlim <- list(
  min = 0,
  max = 15
)

ylim <- list(
  min = 40,
  max = 100
)

# Define UI for application that draws a histogram
navbarPage("Covid-19 Confirmed Cases", id="nav",
        
            #############################
            # liuhongyang Interactive Map#
           #############################
           tabPanel("Interactive Map",
                    
                    div(class="outer",
                        
                          tags$head
                          (
                          # Include our custom CSS
                            includeCSS("styles.css"),
                            includeScript("gomap.js")
                           ),
                        
                        
                        # If not using custom CSS, set height of leafletOutput to a number instead of percent
                        
                        leafletOutput("map", width="80%", height="100%"),
                        
                        
                        
                        # Shiny versions prior to 0.11 should use class = "modal" instead.
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = FALSE, top = 55, left = "auto", right = 10, bottom = "auto",
                                      width = 400, height = "100%",
                                      
                                      h2("Covid-19 Data Search"),
                                      selectInput("typeofyear", "Select Dates", years),
                                      
                                      selectInput("typeofvariable", "Select variables", vars),
                                      
                                      tableOutput("data")
                                    )
                        )
                    ),
           # tab 'DataSearch'
           tabPanel("DataTable",DTOutput(outputId = "table"))
         
          
)
