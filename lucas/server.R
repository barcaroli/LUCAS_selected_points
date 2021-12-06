# Load packages
library(shiny)
library(shinythemes)
library(sf)
library(mapview)
library(leaflet)
library(leafpop)

load("LUCAS_sample.RData")
samp <- samp[order(paste0(samp$NUTS0,samp$NUTS2)),]
samp_sf <- st_as_sf(samp, coords = c("X_LAEA", "Y_LAEA"),
                    crs=" +proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs ")
samp_sf$LC <- as.factor(samp_sf$LC)
levels(samp_sf$LC) <- LETTERS[1:8]

server <- function(input, output, session) {
  observeEvent(input$do, {
    # Subset data
    selected_sample <- reactive({
      # req(input$Country)
      # validate(need(!is.na(input$Country) & (input$Country %in% levels(as.factor(samp_sf$NUTS0))), "Error: Please provide a valid country code"))
      # req(input$Region)
      validate(need( (input$Region %in% levels(as.factor(samp_sf$NUTS2))), "Error: Please provide  valid region code"))
      req(input$ObsType)
      validate(need(!is.na(input$ObsType), "Error: Please provide  valid observation type code"))
      req(input$var)
      validate(need(!is.na(input$var), "Error: Please provide  valid variable name"))
      req(input$value_LC)
      validate(need(!is.na(input$value_LC), "Error: Please provide  valid LC value"))
      req(input$value_LU)
      validate(need(!is.na(input$value_LU), "Error: Please provide  valid LU value"))
      samp <- samp_sf
      # if (input$ObsType == "all") 
      #   if (input$value == "all") 
      #     samp[samp$NUTS2 == input$Region,]
      #   else
      #   if (input$var == "LC")
      #     samp[samp$NUTS2 == input$Region & samp$LC == input$value, ]
      #   else
      #     samp[samp$NUTS2 == input$Region & samp$LU == input$value, ]
      # else 
      #   if (input$value == "all") 
      #     samp[samp$PI == input$ObsType & samp$NUTS2 == input$Region, ]
      #   else
      #     if (input$var == "LC")
      #       samp[samp$PI == input$ObsType & samp$NUTS2 == input$Region & samp$LC == input$value, ]
      #     else
      #       samp[samp$PI == input$ObsType & samp$NUTS0 == input$Country & samp$NUTS2 == input$Region & samp$LU == input$value, ]
      if (input$ObsType == "all" & input$var == "LC" & input$value_LC == "all")
        samp[samp$NUTS2 == input$Region,]
      else
        if (input$ObsType == "all" & input$var == "LU" & input$value_LU == "all")
          samp[samp$NUTS2 == input$Region,]
      else
        if (input$ObsType != "all" & input$var == "LC" & input$value_LC == "all")
          samp[samp$NUTS2 == input$Region  & samp$PI == input$ObsType,]
      else
        if (input$ObsType != "all" & input$var == "LU" & input$value_LU == "all")
          samp[samp$NUTS2 == input$Region  & samp$PI == input$ObsType,]
      else
        if (input$ObsType == "all" & input$value_LC != "all" & input$var == "LC")
          samp[samp$NUTS2 == input$Region & samp$LC == input$value_LC,]
      else
        if (input$ObsType == "all" & input$value_LU != "all" & input$var == "LU")
          samp[samp$NUTS2 == input$Region & samp$LU == input$value_LU,]
      else
        if (input$ObsType != "all" & input$value_LC != "all" & input$var == "LC")
          samp[samp$NUTS2 == input$Region & samp$LC == input$value_LC & samp$PI == input$ObsType,]
      else
        if (input$ObsType != "all" & input$value_LU != "all" & input$var == "LU")
          samp[samp$NUTS2 == input$Region & samp$LU == input$value_LU & samp$PI == input$ObsType,]
      
      
    })
    # Pull the map
    output$map <- renderLeaflet({
      if (input$background == "OpenStreetMap") 
        if (input$var == "LC")
          mapView(selected_sample()["LC"], map.types = c("OpenStreetMap"))@map
      else
        mapView(selected_sample()["LU"], map.types = c("OpenStreetMap"))@map
      else
        if (input$background == "Esri.WorldImagery") 
          if (input$var == "LC")
            mapView(selected_sample()["LC"], map.types = c("Esri.WorldImagery"))@map
      else
        mapView(selected_sample()["LU"], map.types = c("Esri.WorldImagery"))@map
      else
        if (input$background == "OpenTopoMap") 
          if (input$var == "LC")
            mapView(selected_sample()["LC"], map.types = c("OpenTopoMap"))@map
      else
        mapView(selected_sample()["LU"], map.types = c("OpenTopoMap"))@map
    })
    # output$desc <- renderText({
    #   paste(trend_text, "The index is set to 1.0 on January 1, 2004 and is calculated only for US search traffic.")
    # })  
  })
}
