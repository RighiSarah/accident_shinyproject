library(shiny)
library(DBI)
library(RMySQL)
library(shiny)
library(shinydashboard)
library(RMySQL)
library(leaflet)

# Define UI for dataset viewer application

header <- dashboardHeader(title = "Accidents dashboard")

sidebar <- dashboardSidebar(
  
  sidebarMenu(
    menuItem("Barchart", tabName = "chartbar", icon = icon("bar-chart-o")),
    menuItem("maps", icon = icon("globe"), tabName = "maps"),
    menuItem("others", icon = icon("th"), tabName = "others")
   
    )
)

body <- dashboardBody(
  
  tabItem(tabName = "Info boxes",
          h2("Informations KPI"),
          fluidRow(
            # A static infoBox
            infoBox("TEST", 10 * 2, icon = icon("credit-card")),
            # Dynamic infoBoxes
            infoBoxOutput("progressBox"),
            infoBoxOutput("approvalBox")
          ),
          
          # infoBoxes with fill=TRUE
          fluidRow(
            infoBox("Nombre d'accidents", 10 * 2, icon = icon("credit-card"), fill = TRUE),
            infoBoxOutput("progressBox2"),
            infoBoxOutput("approvalBox2")
          ),
          
          fluidRow(
            # Clicking this will increment the progress amount
            box(width = 4, actionButton("count", "Incrementer"))#increment progress
          )
  ),
  
  
  
  
  #first tab
  tabItems(

   tabItem (tabName = "chartbar",
     titlePanel("Create your barchart"),
  
  sidebarLayout(
    sidebarPanel(
     # selectInput("dimension", "Choose a dimension:", 
            #      choices = c("caracteristiques", "Lieux", "Usagers", "Vehicules","Departement")),
      selectInput("dimension", "Choose a dimension",
                         c("caracteristiques", "lieux", "usagers", "vehicules","departement"),
                  selected ="caracteristiques"
                  ),
      
      selectInput("attribute", "Choose an attribute", c("lumiere"), selected ="lumiere"),
      
      submitButton("Update View", icon("refresh"))
    ),
    mainPanel(
      
      plotOutput("view", height = 600)
)
)
),
   
    
    
    #Second tab
    tabItem (tabName = "maps",
             leafletOutput("mymap")
    ),
    
    
    
    # Third tab content
    tabItem(tabName = "others",
            # h2("Analyse des accidents")
            
            box(
              title = "Histogram", status = "primary", solidHeader = TRUE,
              collapsible = TRUE,
              plotOutput("plot3", height = 140)
            ),
            
            box(
              title = "Inputs", status = "warning", solidHeader = TRUE,
              "Box content here", br(), "More box content",
              sliderInput("slider", "Slider input:", 1, 100, 50)
              
            )

    )
    
  )
) 


ui <- dashboardPage(
  skin= "red", header, sidebar, body 
  
)