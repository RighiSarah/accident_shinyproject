library(shiny)
library(DBI)
library(shinydashboard)
library(RMySQL)
library(leaflet)
library(flexdashboard) #to have an interactive dashboard

# Define UI for dataset viewer application

header <- dashboardHeader(title = "Accidents dashboard")

sidebar <- dashboardSidebar(
  
  # Menu a gauche 
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Barchart", tabName = "chartbar", icon = icon("bar-chart-o")),
    menuItem("maps", icon = icon("globe"), tabName = "maps"),
    menuItem("Pie", icon = icon("chart-pie"), tabName = "pie"),
    menuItem("others", icon = icon("th"), tabName = "others")
    )
)


body <- dashboardBody(
  
  #first tab
  tabItems(
    tabItem(tabName = "dashboard",
            h2("Informations KPI"),
            fluidRow(
              # A static infoBox
              # infoBox("Nombre d'accidents en 2017",  icon = icon("car-crash")),
              # Dynamic infoBoxes
              infoBoxOutput("infobox1", width = 3),
              infoBoxOutput("infobox2", width = 3),
              infoBoxOutput("infobox3", width = 3),
              infoBoxOutput("infobox4", width = 3)
            ),
            
            #Interactive gauge chart
            fluidRow (),
            column(3,
                   box(flexdashboard::gaugeOutput("plt1"),
                       height=50,width=20,title="Accident selon la lumiere",background ="aqua")),
            column(3,
                   box(flexdashboard::gaugeOutput("plt2"),
                       height=50,width=20,title="Accident selon la meteo",background ="aqua")),
            column(3,
                   box(flexdashboard::gaugeOutput("plt3"),
                       height=50, width=20,title="Accident selon les vehicules",background ="aqua"))
            ),
   
    #Second tab 
   tabItem (tabName = "chartbar",
     titlePanel("Create your barchart"),
  
  sidebarLayout(
    sidebarPanel(
     # selectInput("dimension", "Choose a dimension:", 
            #      choices = c("caracteristiques", "Lieux", "Usagers", "Vehicules","Departement")),
      selectInput("dimension", "Choose a dimension",
                         c("caracteristiques", "lieux", "usager", "vehicule","departement"),
                  selected ="caracteristiques"
                  ),
      
      selectInput("attribute", "Choose an attribute", c("lumiere"), selected ="lumiere"),
      actionButton("submit", "Go!")
    ),
    
    mainPanel(
      plotOutput("view", height = 400)
)
)
),
    
    #Third tab
    tabItem (tabName = "maps",
             leafletOutput("mymap")
    ),
    

    #fourth tab
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
              
            ),
            
            mainPanel(
              h1("Evolution du nombre d'accidents par mois"),
              plotOutput("dates", height = 250)
            )

    )
  )
) 


ui <- dashboardPage(
 header, sidebar, body 
  
)