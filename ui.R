library(shiny)
library(DBI)
library(RMySQL)
library(shiny)
library(shinydashboard)
library(leaflet)
library(flexdashboard)#to have an interactive dashboard

# Define UI for dataset viewer application

header <- dashboardHeader(title = "Accidents Analysis")

sidebar <- dashboardSidebar(
  
  # Menu a gauche 
  sidebarMenu(
    menuItem("Description", tabName = "description", icon = icon("list-alt")),
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Barchart", tabName = "chartbar", icon = icon("bar-chart-o")),
    menuItem("Maps", icon = icon("globe"), tabName = "maps"),
    menuItem("Pie", icon = icon("stats-circle",lib ="glyphicon"), tabName = "pie"),
    menuItem("Chart Line", icon = icon("stats",lib= "glyphicon"), tabName = "others")
    )
)

body <- dashboardBody(width= 800,height = 600,
  
  #first tab
  tabItems(
    tabItem (tabName = "description",
             # Application title
             titlePanel("Analyse descriptive de l'entrepot de donnees"),
             
             # Sidebar with controls 
            # sidebarLayout(
             #  sidebarPanel(#width=2,
             #    h3("Filtering data"),
              #    numericInput("obs", "Number of observations to view on table:", 10)
               #            ),
               
               # MainPanel divided into many tabPanel
              # mainPanel(height = 500,width = 500,
                 tabsetPanel(
                   tabPanel("Plot",  br(),
                          
                           sidebarPanel(
                             
                              h3("Filtrer les donnees"),
                              selectInput("scratterplot", "choisir un attribut",
                                          c("sexe", "securite","gravite_accident","categorie_usager"),
                                          selected ="sexe"
                              )
                            ),
                            mainPanel(height="100px",
                              h1("Scatterplot"),fluidPage( plotOutput("simplePlot", width = "80%", height = "400px")),
                              h1("Boxplot"),fluidPage(plotOutput("boxPlot"))
                              
                            )
                            ),
                   tabPanel("Descriptive statistics", h1("Descriptive statistics"),verbatimTextOutput("summary")),
                   tabPanel("Table",
                            
                                sidebarPanel(#width=2,
                                 h3("Filtering data"),
                                  numericInput("obs", "Number of observations to view on table:", 10)
                                          ),
                                mainPanel(width = 500,
                            h1("Table"), textOutput("NbRows"), tableOutput("tableView")
                            )
                            ),
                   tabPanel("Clustering", 
                            sidebarPanel(#width=2,
                              h3("Filtering data"),
                              numericInput("clusters", "Cluster count", 3, min = 1, max = 9)
                              
                            ),
                            mainPanel(width = 500,
                                      h1("K-Means"), textOutput("NbClust"), plotOutput("kmeansPlot"),
                                      h1("Decision tree"), plotOutput("treePlot"))
                                      )
                           
                 ) 
              # )
             ),
             
    
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
         
                 column(5,
                        box(flexdashboard::gaugeOutput("plt4"),
                            height=180,width=30,title="Accident selon la lumiere",background ="aqua")),
                 column(5,
                        box(flexdashboard::gaugeOutput("plt5"),
                            height=180,width=30,title="Accident selon la meteo",background ="aqua")),
             fluidRow (),
             h2("Repartition du nombre d'accidents selon les departements en France metropolitaine et outre-mer "),
             fluidRow (),
             leafletOutput("mymap")
   
            
    ),

    #fourth tab
    tabItem (tabName = "pie", height = 5000, width= 500,
             #h2("Analyser les caracteristiques des usagers impliques dans les accidents"),
             
             box(
               title = "Analyse des caracteristiques des usagers", status = "primary", solidHeader = TRUE,
               collapsible = TRUE,
               selectInput("usager", "Choisissez un axe d'observation",
                           c("categorie_usager", "gravite_accident", "sexe", "trajet","securite"),
                           selected ="sexe"
               ),
               selectInput("mesure", "Choisissez une mesure",
                           c("nombre d'usagers", "nombre d'accidents"),
                           selected ="nombre d'usagers"
               ),
               actionButton("submitPie", "Submit"),
               plotOutput("pie1", height = 280)
             ),
             
             box(
               title = "Analyse des caracteristiques des accidents", status = "warning", solidHeader = TRUE,heigth = 500,
             #  "Box content here", br(), "More box content"
           #  title = "Analyse des caracteristiques des accidents", status = "primary", solidHeader = TRUE,
             collapsible = TRUE,
             selectInput("caracteristique", "Choisissez un axe d'observation",
                         c("lumiere", "atmosphere", "surface", "categorie"),
                         selected ="lumiere"
             ),

             plotOutput("pie2", height = 350)
               
               
             )
             
             
    ),

    tabItem(tabName = "others",
            # h2("Analyse des accidents")
            
          
            sidebarLayout(
              sidebarPanel(
                radioButtons("radio", label = h3("Choisissez le format de date"),
                             choices = list("MONTH" , "WEEK","QUARTER"), 
                             selected = "MONTH")
              ),
              mainPanel(
                h1("Evolution temporelle du nombre d'accidents "),
                plotOutput("dates", height = 400)
              )
            )
    )

    
  )
)


ui <- dashboardPage(
 header, sidebar, body ,skin="red"
  
)