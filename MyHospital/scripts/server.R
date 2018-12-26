########################################################################
#
#    Shiny App (server)- MyHospital base map 
#
#    Basic Hospital location map for MyHospital data 
#
#    includes reactive click for further development
#
#    Source: https://www.myhospitals.gov.au/about-the-data/download-data
#
########################################################################
# call in required packages
library(shiny)    # required for shiny app deployment
library(leaflet)  # required for mapping - inc tiles
#
# read in data stored on github 
df <- read.csv("https://raw.githubusercontent.com/noircanard/hospital-shiny/master/MyHospital/data/processed/Hospital.csv")
# add new vector for map marker colour
#
df$sector_col[df$Sector == "Private"] <- "red"
df$sector_col[df$Sector == "Public"] <- "grey"
########################################################################
# server
server <- function(input, output) {
  
## create a reactive value to hold postion value ###
  
  data_of_click <- reactiveValues(clickedMarker=NULL)
  
## Main leaflet map for which the hospital is to be selected from ###
  
  output$map <- renderLeaflet({
    
    
    leaflet() %>% 
      setView(lng=133 , lat =-25, zoom=4) %>%
      addTiles(options = providerTileOptions(noWrap = TRUE)) %>%
      addCircleMarkers(data=df, ~Long , ~Lat,
                       layerId=~Hospital, 
                       popup=paste(paste( "<b><a href='",df$web_address,"'target='_blank'>", df$Hospital,
                                          "</a></b>",
                        paste("(",df$Sector,")",sep = "")),
                                   paste("No. Beds:", df$Beds),
                                   df$Description,    sep = "<br/>"), 
                       radius=2 ,
                       color="white", fillColor = ~sector_col,  stroke = TRUE, fillOpacity = 0.8)%>% 
      
      addLegend(
        position = 'bottomright',
        colors = c("grey","red"),
        labels = c("Private","Public"), opacity = 0.8,
        title = 'Hospital points'
      )
  }) #END renderLeaflet

## Once point is selected this is where the value is stored ###
  
  observeEvent(input$map_marker_click,{
    data_of_click$clickedMarker <- input$map_marker_click
  }) #END observeEvent
  
  
} # END server
#END server.R ##############################################################
