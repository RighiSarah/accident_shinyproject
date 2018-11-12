library(shiny)
library(DBI)
library(RMySQL)
library(shiny)
library(shinydashboard)
library(jsonlite)
library(RMySQL)
library(leaflet)

# Define UI for dataset viewer application

header <- dashboardHeader(title = "Accidents dashboard")

sidebar <- dashboardSidebar(
  
  sidebarMenu(
    menuItem("Barchart", tabName = "chartbar", icon = icon("bar-chart-o")),
    menuItem("maps", icon = icon("globe"), tabName = "maps"
    )
  )
)
body <- dashboardBody(
  tabItems(
    
   tabItem (tabName = "chartbar",
   titlePanel("Create your barchart"),
  
  sidebarLayout(
    sidebarPanel(
     # selectInput("dimension", "Choose a dimension:", 
            #      choices = c("caracteristiques", "Lieux", "Usagers", "Vehicules","Departement")),
      selectInput("dimension", "Choose a dimension",
                         c("caracteristiques", "lieux", "usagers", "vehicules","departement")),
      
      selectInput("attribute", "Choose an attribute", c()),
      
      submitButton("Update View", icon("refresh"))
    ),
    mainPanel(
      
      plotOutput("view", height = 600)
    )
  )
),

  tabItem (tabName = "maps",
             leafletOutput("mymap")
           )
)

)

ui <- dashboardPage(
  skin= "red", header, sidebar, body 
  
)