library(shiny)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(rlang)
library(ggplot2)
library(ggthemes)
library(ggrepel)
library(DT)
#analyticsData<-read.csv("LifeExpectancyData.csv")

# Define server logic required to draw a histogram
function(input, output, session) {
  
  target_year = reactive({
    
    input$typeofyear
    
  })

  
  
  
  target_quo = reactive ({
    
    parse_quosure(input$typeofvariable)
  })
  

  
  
  
  
  dftable<-reactive({
   
    
    analytics=filter(dataAnalytics,Date== target_year())
    
    arrange(analytics,desc(!!target_quo()))
    
    
  
                        
  })
  
  
  
# dftable<-  reactive ({
   
 #  analyticsData%>%
#      arrange(desc(!!target_quo()))
 # }
 
 
 
 dfmap<-reactive ({
   
   analytics2<-filter(dataAnalytics,Date==target_year())
   CountryData_<-left_join(Df1,analytics2,by="Country")
   CountryData_%>%select(input$typeofvariable)
  
   
   })
  
  
  
  ## Interactive Map  liuhongyang###########################################
  
  # Create the map
 
 
 
  output$map <- renderLeaflet({
    leaflet(geojson) %>% addTiles(urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                                  attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>')%>%
      addPolygons(stroke = FALSE, smoothFactor = 0.3, fillOpacity = 0.5,
                  label = paste(CountryData$Country, ":", dfmap()[,1]),
                  color = pal(rescale(dfmap()[,1],na.rm=TRUE))
                 
                  
      )%>%
      setView(lng = 0, lat = 40, zoom = 2) %>%
      addLegend("bottomleft",pal = pal, 
              
                 values =c(0:1), opacity = 0.7)
  })
  
output$data <- renderTable({
  
  head((dftable()[, c("Country", input$typeofvariable), drop = FALSE]) ,10)
  
}, rownames = TRUE)
############################
  
#############################


############################ liuhongyang
output$table <- DT::renderDataTable({
  DT::datatable(dataAnalytics)
})
############################







}
