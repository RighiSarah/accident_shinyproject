library(shiny)
library(DBI)
library(RMySQL)
library(shiny)
library(shinydashboard)
library(RMySQL)
library(leaflet)
library(flexdashboard)

# Define UI for dataset viewer application

header <- dashboardHeader(title = "Accidents dashboard")

sidebar <- dashboardSidebar(
  
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
              #   infoBox("Nombre d'accidents en 2017",  icon = icon("car-crash")),
              # Dynamic infoBoxes
              infoBoxOutput("infobox1", width = 3),
              infoBoxOutput("infobox2", width = 3),
              infoBoxOutput("infobox3", width = 3),
              infoBoxOutput("infobox4", width = 3)
            ),
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

    tabItem (tabName = "maps",
             h2("Repartition des accidents selon les departement en France metropolitaine et outre-mer "),
             leafletOutput("mymap")
    ),
    tabItem (tabName = "pie",
             h2("Analyser les caracteristiques des usagers impliques dans les accidents"),
             
             box(
               title = "Analyse des caracteristiques des usagers", status = "primary", solidHeader = TRUE,
               collapsible = TRUE,
               selectInput("usager", "Choose an attribute",
                           c("categorie_usager", "gravite_accident", "sexe", "trajet","securite"),
                           selected ="sexe"
               ),
               actionButton("submitPie", "Submit"),
               plotOutput("pie1", height = 400)
             ),
             
             box(
               title = "Inputs", status = "warning", solidHeader = TRUE,heigth = 400,
               "Box content here", br(), "More box content"
               
               
             )
             
             
    ),

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
              plotOutput("dates", height = 400)
            )

    )

    
  )
) 


ui <- dashboardPage(
 header, sidebar, body 
  
)