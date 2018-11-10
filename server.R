library(shiny)
library(DBI)
library(RMySQL)
library(shiny)
library(shinydashboard)
library(jsonlite)
library(RMySQL)
library(leaflet)


# Define server logic required to summarize and view the 
# selected dataset
server<-function(input, output) {
  
  db = dbConnect(MySQL(),
                 dbname = "accidents",
                 host = "shinyapp.mysql.database.azure.com", 
                 user = "myadmin@shinyapp", 
                 password = "Shinyapp69")
  
  on.exit(dbDisconnect(db), add = TRUE)
  
  region<- dbReadTable(conn = db,  name = 'region', value = as.data.frame(region))
  
  # table2<- dbReadTable(conn = conn,  name = 'dim_region', value = as.data.frame(table2))
 
 query <- paste0("SELECT d.nom_departement,latitude, longitude, count(distinct num_accident) as nombre
                FROM departement d
                  join accident a on a.departement_id = d.departement_id
                  group by d.departement_id")
  dept<- dbGetQuery(db, query)
  villes <- data.frame(nom = dept$nom_departement,
                       lat = as.double(dept$latitude),
                       long = as.double(dept$longitude),
                       nombre = dept$nombre)
  
  couleurs <- colorNumeric("RdYlBu", dept$nombre, n = 10)
  # Return the requested dataset
  dimensionInput <- reactive({
    switch(input$dimension,
           "region" = region
           #"dim_region" = table2
           
    )
  })
 attributeInput <- reactive({
   db = dbConnect(MySQL(),
                  dbname = "accidents",
                  host = "shinyapp.mysql.database.azure.com", 
                  user = "myadmin@shinyapp", 
                  password = "Shinyapp69")
   query1 <- sprintf ("select %s as attribut, count(distinct num_accident) as nombre FROM
                     %s x 
                     join accident a on a.%s_id = x.%s_id
                     group by 1",input$attribute, input$dimension, input$dimension, input$dimension)
           
   khra <- dbGetQuery(db, query1)
  })
  
  # Show the first "n" observations
  output$view <- renderPlot({
   donnee <- attributeInput()
    barplot(donnee$nombre *1000, 
            main=donnee$attribut,
            ylab="Number of accidents",
            xlab="attribut")
  })
  
  output$mymap <- renderLeaflet({
    yourMap <- leaflet(dept) %>% addTiles() %>%
      addCircles(lng = ~longitude, lat = ~latitude,
                 weight = 1,
                 radius = ~sqrt(nombre) * 300, 
                 popup = ~paste(nom_departement, ":", nombre),
                 color = ~couleurs(nombre), fillOpacity = 0.9) %>%
      addLegend(pal = couleurs, values = ~nombre, opacity = 0.9)
    
    
  })
  
}