# Load packages
library(shiny)
library(shinythemes)
library(sf)
library(mapview)
library(leaflet)
library(leafpop)

# Load packages
library(shiny)
library(shinythemes)
library(sf)
library(mapview)
library(leaflet)
library(leafpop)


# Load data
# load("sample_LUCAS.RData")
# samptot <- samptot[order(paste0(samptot$NUTS0,samptot$NUTS2)),]
# samp_sf <- st_as_sf(samptot, coords = c("X_LAEA", "Y_LAEA"),
#                     crs=" +proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs ")

load("LUCAS_sample.RData")
samp <- samp[order(paste0(samp$NUTS0,samp$NUTS2)),]
samp_sf <- st_as_sf(samp, coords = c("X_LAEA", "Y_LAEA"),
                    crs=" +proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs ")
samp_sf$LC <- as.factor(samp_sf$LC)
levels(samp_sf$LC) <- LETTERS[1:8]


ui <- fluidPage(theme = shinytheme("lumen"),
                titlePanel("LUCAS 2022 Sample"),
                sidebarLayout(
                  sidebarPanel(
                    selectInput(inputId = "background", label = strong("Maps background"),
                                choices = c("OpenStreetMap",
                                            "Esri.WorldImagery",
                                            "OpenTopoMap"),
                                selected = "OpenStreetMap"),
                    # Select countries and regions
                    # selectInput(inputId = "Country", label = strong("Country (NUTS0)"),
                    #             choices = unique(samp_sf$NUTS0),
                    #             selected = "AT"),
                    selectInput(inputId = "Region", label = strong("Region (NUTS2)"),
                                choices = unique(samp_sf$NUTS2),
                                selected = "AT11"),
                    selectInput(inputId = "ObsType", label = strong("Observation type (Field/PI)"),
                                choices = c("All values"="all",
                                            "Field"="FI",
                                            "Photo-Interpreted"="PI"),
                                selected = ""),
                    selectInput(inputId = "var", label = strong("Variable of interest"),
                                choices = c("Land cover"="LC",
                                            "Land use"="LU"),
                                selected = "LC"),
                    # Only show this panel if the variable is Land Cover
                    conditionalPanel(
                      condition = "input.var == 'LC'",
                      selectInput(inputId = "value_LC", label = "Select values of Land Cover:",
                                  choices = c("All values"="all",
                                              "Artificial"="A",
                                              "Cropland"="B",
                                              "Woodland"="C",
                                              "Shrubland"="D",
                                              "Grassland"="E",
                                              "Bareland"="F",
                                              "Water"="G",
                                              "Wetland"="H"),
                                  selected = "")
                    ),
                    # Only show this panel if the variable is Land Use
                    conditionalPanel(
                      condition = "input.var == 'LU'",
                      selectInput(inputId = "value_LU", label = "Select values of Land Use:",
                                  choices = c("All values"="all",
                                              "Primary Sector"="U1",
                                              "Secondary Sector"="U2",
                                              "Tertiary Sector"="U3",
                                              "Abandoned or unused areas"="U4"),
                                  selected = "")
                    ),
                    actionButton("do", "Click button"),
                    width = 3),
                  # Output
                  mainPanel(leafletOutput('map', width = "100%", height = 700))
                )
)