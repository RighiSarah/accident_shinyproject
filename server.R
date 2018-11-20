library(shiny)
library(DBI) #A database interface definition for communication between R and relational database management systems
library(RMySQL)
library(shinydashboard)
library(leaflet) #cartographie en ligne
library(ggplot2)
library(scales)
library(lubridate) #Manipulation de dates

#********************************************************#
#function that kills all mysql connections
killDbConnections <- function () {
  all_cons <- dbListConnections(MySQL())
  print(all_cons)
  for(con in all_cons)
    +  dbDisconnect(con)
  print(paste(length(all_cons), " connections killed."))
}

# server code to start the shiny app
server<-function(input, output,session) {
  
  # Kill all mysql connections before starting
  killDbConnections()
#********************************************************# 

  
    #connection to azure mysql database (cloud)
  db = dbConnect(MySQL(),
                 dbname = "accidents",
                 host = "shinyapp.mysql.database.azure.com", 
                 user = "myadmin@shinyapp", 
                 password = "Shinyapp69")
  
  
  #disconnect when exiting the app
  on.exit(dbDisconnect(db), add = TRUE)
  
  # query to import dataframe for the map
 query <- paste0("SELECT d.nom_departement,latitude, longitude, count(distinct num_accident) as nombre
                FROM departement d
                  join accident a on a.departement_id = d.departement_id
                  group by d.departement_id")
 
  dept<- dbGetQuery(db, query)
  
  #we create the data frame 
  villes <- data.frame(nom = dept$nom_departement,
                       lat = as.double(dept$latitude),
                       long = as.double(dept$longitude),
                       nombre = dept$nombre)
  couleurs <- colorNumeric("RdYlBu", dept$nombre, n = 10)
  
  
  # reactive function that creates the map using leaflet library
  output$mymap <- renderLeaflet({
    yourMap <- leaflet(dept) %>% addTiles() %>%
      addCircles(lng = ~longitude, lat = ~latitude,
                 weight = 1,
                 radius = ~sqrt(nombre) * 300, 
                 popup = ~paste(nom_departement, ":", nombre),
                 color = ~couleurs(nombre), fillOpacity = 0.9) %>%
      addLegend(pal = couleurs, values = ~nombre, opacity = 0.9)
  })
  
  dimensionInput <- reactive({
    switch(input$dimension,
           "region" = region
           #"dim_region" = table2
           
    )
  })
  
  if (interactive()) {
    observe  ({
      x <- input$dimension
      db = dbConnect(MySQL(),
                     dbname = "accidents",
                     host = "shinyapp.mysql.database.azure.com", 
                     user = "myadmin@shinyapp", 
                     password = "Shinyapp69", encoding = "windows-1252")
      
      col_names <- sprintf ("show columns from %s", x)
      col_names_result <- dbGetQuery(db, col_names)
      # Can use character(0) to remove all choices
      if (is.null(x))
        x <- character(0)
            # Can also set the label and select items
      updateSelectInput(session, "attribute",
                        label = paste("Select attribute"),
                        choices = col_names_result$Field,
                        selected = tail(col_names_result$Field, 1)
      )
    })
  }
  

  
  attributeInput <-eventReactive(input$submit,{
    db = dbConnect(MySQL(),
                   dbname = "accidents",
                   host = "shinyapp.mysql.database.azure.com", 
                   user = "myadmin@shinyapp", 
                   password = "Shinyapp69")
    query1 <- sprintf ("select %s as attribut, count(distinct num_accident) as nombre FROM
                       %s x
                       join accident a on a.%s_id = x.%s_id
                       group by 1 order by nombre desc",input$attribute, input$dimension, input$dimension, input$dimension)
    
    result <- dbGetQuery(db, query1)
  }
  )

  output$view <- renderPlot({
  donnee <- attributeInput()
  Encoding(donnee$attribut) <- "windows-1252"
    par(mar=c(12,5,5,5))
    my_bar=barplot(donnee$nombre , border=F , names.arg=donnee$attribut , las=2 , col=c(rgb(0.3,0.1,0.4,0.6),
    rgb(0.3,0.5,0.4,0.6) , rgb(0.3,0.9,0.4,0.6) ,  rgb(0.3,0.9,0.4,0.6)) , main="" )
    
    abline(v=c(4.9 , 9.7) , col="grey")
    
    # Add the text 
    text(my_bar, donnee$nombre+0.4 , paste("n = ",donnee$nombre,sep="") ,cex=1) 
    
  })
  
  accident <- sprintf("select  count(distinct num_accident) as nombre FROM accident ")
  accident_result <- dbGetQuery(db, accident)
  output$infobox1 <- renderInfoBox({
    infoBox(
      "Accidents en 2017", accident_result$nombre, icon = icon("road"),
      color = "purple"
    )
  })
  
  
  usager <- sprintf("select  count(distinct usager_id) as nombre FROM accident ")
  usager_result <- dbGetQuery(db, usager)
  output$infobox2 <- renderInfoBox({
    infoBox(
      "Usagers", usager_result$nombre, icon = icon("user"),
      color = "yellow"
    )
  })
  
  
  veh <- sprintf("select  count(distinct vehicule_id) as nombre FROM accident ")
  veh_result <- dbGetQuery(db, veh)
  output$infobox3 <- renderInfoBox({
    infoBox(
      "Vehicules", veh_result$nombre, icon = icon("car")
    
    )
  })
  
  veh1 <- ("select gravite_accident , count(distinct num_accident) as nombre FROM
                   accident x
          join usager a on a.usager_id = x.usager_id
          group by 1 order by nombre asc
          ")
  veh1_result <- dbGetQuery(db, veh1)
  veh1_result_pourecent <- ceiling(veh1_result$nombre[1] * 100 / sum(veh1_result$nombre))
  output$infobox4 <- renderInfoBox({
    infoBox(
      "Nombre de morts", paste0(veh1_result$nombre[1], " morts = ",veh1_result_pourecent, " %"),
      icon = icon("times"),  color = "blue"
    )
  })
  
  
  output$progressBox2 <- renderInfoBox({
    infoBox(
      "Progress", paste0(25 + input$count, "%"), icon = icon("list"),
      color = "purple", fill = TRUE
    )
  })
  
  output$approvalBox2 <- renderInfoBox({
    infoBox(
      "Approval", "80%", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "yellow", fill = TRUE
    )
  })
  
  lumiere <- sprintf("select lumiere , count(distinct num_accident) as nombre FROM
                   caracteristiques x
                   join accident a on a.caracteristiques_id = x.caracteristiques_id
                   group by 1 order by nombre desc ")
  
  
  lumiere_result <- dbGetQuery(db, lumiere)
  lumiere_result_pourecent <- ceiling(lumiere_result$nombre[1] * 100 / sum(lumiere_result$nombre))
   output$plt1 <- flexdashboard::renderGauge({
    gauge(lumiere_result_pourecent, min = 0, max = 100, symbol = '%', label = paste(lumiere_result$lumiere[1]),gaugeSectors(
      success = c(100, 6), warning = c(5,1), danger = c(0, 1), colors = c("#CC6699")
    ))
    
     })
   
   atmosphere <- ("select atmosphere , count(distinct num_accident) as nombre FROM
                  caracteristiques x
                  join accident a on a.caracteristiques_id = x.caracteristiques_id
                  group by 1 order by nombre desc ")
   
   atmosphere_result <- dbGetQuery(db, atmosphere)
   atmosphere_result_pourecent <- ceiling(atmosphere_result$nombre[1] * 100 / sum(atmosphere_result$nombre))
   
   output$plt2 <- flexdashboard::renderGauge({
     gauge(atmosphere_result_pourecent, min = 0, max = 100, symbol = '%', label = paste(atmosphere_result$atmosphere[1]),gaugeSectors(
       success = c(100, 6), warning = c(5,1), danger = c(0, 1), colors = c("#CC6699")
     ))
   })
   
   vehicule <- ("select categorie_vehicule as categorie , count(distinct num_accident) as nombre FROM
                  vehicule x
                  join accident a on a.vehicule_id = x.vehicule_id
                  group by 1 order by nombre desc ")
   
   vehicule_result <- dbGetQuery(db, vehicule)
   vehicule_result_pourecent <- ceiling(vehicule_result$nombre[1] * 100 / sum(vehicule_result$nombre))
   output$plt3 <- flexdashboard::renderGauge({
     gauge(vehicule_result_pourecent, min = 0, max = 100, symbol = '%', label = paste(vehicule_result$categorie[1]),gaugeSectors(
       success = c(100, 6), warning = c(5,1), danger = c(0, 1), colors = c("#CC6699")
     ))
   })
   
   # Evolution du nombre d'accidents par mois (plot)
   date <- ("select d.mois, d.annee , count(distinct num_accident) as nombre FROM
               accident x
         join date d on x.date_id = d.date_id
         group by 1,2 order by d.mois asc
         ")
   date_result <- dbGetQuery(db, date)
   #date_result$date <- ymd(date_result$date)   date_result$mois <- month.abb[date_result$mois]
   
   output$dates <- renderPlot({
     ggplot(date_result, aes(mois, nombre,group =1)) +geom_line() +
       labs(x = "Mois", y = "Nombre d accidents ")
   })
   
}