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
    menuItem("Maps", icon = icon("globe"), tabName = "maps"),
    menuItem("Pie", icon = icon("chart-pie"), tabName = "pie"), 
    menuItem("Chart Line", tabName = "chartline", icon = icon("stats",lib= "glyphicon"))
    )
)

body <- dashboardBody(
                      
  
  
  #first tab
  tabItems( 
    tabItem ( tabName = "description",fluidRow (
             # Application title
             titlePanel("Analyse descriptive des données"),
                 tabsetPanel(
                  tabPanel("Plot",  br(),
                           sidebarPanel(
                              h3("Filtrage des données"),
                              selectInput("scratterplot", "choisir un attribut",
                                          c("sexe", "securite","gravite_accident","categorie_usager"),
                                          selected ="sexe"
                              )
                            ),
                           
                            mainPanel(
                           column(width=11,
                              fluidRow(height = 200,
                              h1("Scatterplot"),plotOutput("simplePlot"),
                              #width = "80%", height = "400px")
                              h1("Boxplot"),plotOutput("boxPlot")
                            )))
                            ),
                  
                        
                   tabPanel("Descriptive statistics", h1("Statistique descriptive"),verbatimTextOutput("summary")),
                   tabPanel("Table",
                            sidebarPanel(
                                 h3("Filtrage des données"),
                                  numericInput("obs", "Nombre d'observations à afficher sur le tableau:", 10)),
                                mainPanel(
                            h1("Table"), textOutput("NbRows"), tableOutput("tableView"))),
                   
                  tabPanel("Clustering", 
                            sidebarPanel(
                              h3("Filtrage des données"),
                              numericInput("clusters", "Nombre de cluster", 3, min = 1, max = 9)),
                            mainPanel(
                                      h1("K-Means"), textOutput("NbClust"), plotOutput("kmeansPlot")))
                           
                 ) 
             )),
             
    
    
    #Second tab
    tabItem(tabName = "dashboard",
            h2("Indicateur de performance KPI"),
            
            fluidRow(
              # Dynamic infoBoxes
              infoBoxOutput("infobox1", width = 3),
              infoBoxOutput("infobox2", width = 3),
              infoBoxOutput("infobox3", width = 3),
              infoBoxOutput("infobox4", width = 3)
            ),
            
            column(align="center",width = 4,
                   box(flexdashboard::gaugeOutput("plt1"),
                       height=200,width=20, title="Accidents selon la lumière",background ="blue")),
          
            column(align="center",width = 4,
                   box(flexdashboard::gaugeOutput("plt2"),
                       height=200,width=20, title="Accidents selon la méteo",background ="yellow")),
           
            column(align="center",width = 4,
                   box(flexdashboard::gaugeOutput("plt3"),align="center",
                       height=200, width=20, title="Accidents selon la catégorie de véhicules",background ="purple")
          ),
          
             fluidRow(column(12,
              h3("Histogramme : selon différentes dimensions "),
              
              sidebarLayout(
                sidebarPanel(
                  selectInput("dimension", "Choisir une dimension",
                              c("caracteristiques", "lieux", "usager", "vehicule","departement"),
                              selected ="caracteristiques"
                  ),
                  selectInput("attribute", "Choisir un attribut", c("lumiere"), selected ="lumiere"),
                  actionButton("submit", "Go!")
                ),
                mainPanel(
                  
                  plotOutput("view", height = 400)
                )
              )))),
           

  
    #Third tab
    tabItem (tabName = "maps",
                  h1("Classement des régions selon le nombre d'accidents "),
                 column(4,
                        box(flexdashboard::gaugeOutput("plt4"),
                            height=180,width=30,title="Première",background ="navy")),
                 column(4,
                        box(flexdashboard::gaugeOutput("plt5"),
                            height=180,width=30,title="Seconde",background ="teal")),
             column(4,
                    box(flexdashboard::gaugeOutput("plt6"),
                        height=180,width=30,title="Troisième",background ="olive")),
             fluidRow (),
             h2("Répartition du nombre d'accidents selon les départements en France métropolitaine et outre-mer "),
             fluidRow (),
             leafletOutput("mymap")
   
            
    ),

    #fourth tab
    tabItem (tabName = "pie", height = 5000, width= 500,
             box(
               title = "Analyse des caractéristiques des usagers", status = "primary", solidHeader = TRUE,
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
               plotOutput("pie1", height = 242)
             ),
             
             box(
               title = "Analyse des caractéristiques des accidents", status = "warning", solidHeader = TRUE,
             collapsible = TRUE,
             selectInput("caracteristique", "Choisissez un axe d'observation",
                         c("lumiere", "atmosphere", "surface", "categorie"),
                         selected ="lumiere"
             ),

             plotOutput("pie2", height = 350)
             
             )
             
    ),
    
    #Fifth tab
    tabItem(tabName = "chartline",
            sidebarLayout(
              sidebarPanel(
                radioButtons("radio", label = h3("Sélectionnez une période"),
                             choices = list("MONTH" ,"QUARTER"), 
                             selected = "MONTH")
              ),
              mainPanel(
                h1("Évolution temporelle du nombre d'accidents "),
                plotOutput("dates", height = 400)
              )
            )
    )
    
  )
)


ui <- dashboardPage(
 header, sidebar, body ,skin="red"
  
)