library(shiny)
library(DBI) #A database interface definition for communication between R and relational database management systems
library(RMySQL)
library(shinydashboard)
library(leaflet)#cartographie en ligne
library(ggplot2)
library(scales)
library(lubridate)#Manipulation de dates
library(Hmisc)
library(rpart)
library(party)
library(fpc)
library(regplot)


# Define colors
palette(c("#E73032", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFDD33", "#A65628", "#F781BF", "#999999"))

#********************************************************#
#function that kills all mysql connections
killDbConnections <- function () {
  all_cons <- dbListConnections(MySQL())
  for(con in all_cons)
    +  dbDisconnect(con)

}
#********************************************************#  

#connection to azure mysql database (cloud)
connection_sql <- function(){
  
  # Kill all mysql connections before starting
  killDbConnections()
  db <- dbConnect(MySQL(),
                  dbname = "accidents",
                  host = "shinyapp.mysql.database.azure.com", 
                  user = "myadmin@shinyapp", 
                  password = "Shinyapp69")
  
  #disconnect when exiting the app
  on.exit(dbDisconnect(db), add = TRUE)
}




# server code to start the shiny app
server<-function(input, output,session) {
  
  myColors <- reactive({
    switch(input$scratterplot,
           "sexe" = c(palette()[1],palette()[2]),
           "securite" = c(palette()[1],palette()[2]),
           "gravite_accident" = c(palette()[1],palette()[2],palette()[3],palette()[4]),
           "categorie_usager" = c(palette()[1],palette()[2],palette()[3],palette()[4])
    )
  })

  killDbConnections()
  db = dbConnect(MySQL(),
                 dbname = "accidents",
                 host = "shinyapp.mysql.database.azure.com", 
                 user = "myadmin@shinyapp", 
                 password = "Shinyapp69")

  datasetInput <- reactive ({
    killDbConnections()
    db = dbConnect(MySQL(),
                   dbname = "accidents",
                   host = "shinyapp.mysql.database.azure.com", 
                   user = "myadmin@shinyapp", 
                  password = "Shinyapp69")
   
    dataset <- sprintf("select a.num_accident, d.date, count(usager_id) as usagers, r.nom_region, c.lumiere,
                      v.categorie_vehicule
                      from accident a 
                      join caracteristiques c on c.caracteristiques_id = a.caracteristiques_id
                      join vehicule v on v.vehicule_id = a.vehicule_id
                      join date d on d.date_id = a.date_id
                      join departement dpt on dpt.departement_id = a.departement_id
                      join region r on r.region_id = dpt.region_id
                      group by 1 limit %s",input$obs)
    dataset_result<- dbGetQuery(db, dataset)
  })
  
  
  # Show the first n observations (Statistique descriptive)
  output$tableView <- renderTable({
    
    head(datasetInput(), n = input$obs)
  })
  output$NbRows <- renderText({ 
    paste("You have selected to show ", input$obs," lines.")
  })
  
  output$summary <- renderPrint({
    killDbConnections()
    db = dbConnect(MySQL(),
                    dbname = "accidents",
                    host = "shinyapp.mysql.database.azure.com", 
                    user = "myadmin@shinyapp", 
                    password = "Shinyapp69")
    
    dataset <- sprintf("select  u.sexe,  u.gravite_accident,u.securite,
                       v.categorie_vehicule
                       from accident a 
                        join usager u on u.usager_id = a.usager_id
                       join vehicule v on v.vehicule_id = a.vehicule_id
                       join departement dpt on dpt.departement_id = a.departement_id
                       join region r on r.region_id = dpt.region_id
                       ")
    dataset_result<- dbGetQuery(db, dataset)
    describe(dataset_result)
  })
  
  
  
  #ScatterPlot
  output$simplePlot <- renderPlot({
    killDbConnections()
    db = dbConnect(MySQL(),
                   dbname = "accidents",
                   host = "shinyapp.mysql.database.azure.com", 
                  user = "myadmin@shinyapp", 
                 password = "Shinyapp69")

    
    df_usager <- sprintf("select u.%s as attribut , u.annee_naissance as annee , count(usager_id) as nombre_usagers
                  from usager u
                  group by 1 , 2",input$scratterplot)
    
    df_usager_result <- dbGetQuery(db, df_usager)
    reg <- lm(annee~nombre_usagers, data=df_usager_result)
    
    plot( x =  df_usager_result$nombre_usagers,
         y= df_usager_result$annee,
         xlab = "usagers", ylab = "annee de naissance", #abline(reg, col="purple"),
         col = myColors()
        
         )
    
    #legende
    legend("bottomright", legend = unique(df_usager_result[,1]), 
            col = myColors(),
          # title = input$scratterplot,
           pch = 16, bty = "n", pt.cex = 2)
    
  })
  
  
  
  
  # Show boxplot
  output$boxPlot <- renderPlot({
    killDbConnections()
    db = dbConnect(MySQL(),
                   dbname = "accidents",
                   host = "shinyapp.mysql.database.azure.com", 
                   user = "myadmin@shinyapp", 
                   password = "Shinyapp69")
    df_usager <- sprintf("select u.%s ,u.annee_naissance as annee, count(usager_id) as nombre_usagers
                         from usager u
                         group by 1 ,2",input$scratterplot)
    
    df_usager_result <- dbGetQuery(db, df_usager)
      boxplot(df_usager_result[,'nombre_usagers'] ~ df_usager_result[,1], xlab = input$scratterplot,
               ylab = "nombre d'usagers",
      border = "black", col = myColors()
      )
    
  })
  
  
  
  # K-Means Plot
    output$NbClust <- renderText({ 
    paste("K-means clustering performed with ", input$clusters," clusters.")
  })
  
  clusters <- reactive({
    killDbConnections()
    db = dbConnect(MySQL(),
                   dbname = "accidents",
                   host = "shinyapp.mysql.database.azure.com", 
                   user = "myadmin@shinyapp", 
                   password = "Shinyapp69")
    df_usager <- sprintf("select u.annee_naissance as annee_naissance, count(usager_id) as nombre_usagers
                         from usager u where u.annee_naissance is not null
                         group by 1 ")
    
    df_usager_result <- dbGetQuery(db, df_usager)
  
  })
  
  output$kmeansPlot <- renderPlot({
    df_usager_result <- clusters()
   clus<- kmeans(df_usager_result[,1:2], input$clusters)
    plot(df_usager_result[,c('nombre_usagers','annee_naissance')],
         col = clus$cluster,
         pch = 20, cex = 2)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
  
  
  
  #Onglet Map
  # query to import dataframe for the map
 query <- paste0("SELECT d.nom_departement,r.nom_region,latitude, longitude, count(distinct num_accident) as nombre
                FROM departement d
                  join accident a on a.departement_id = d.departement_id
                  join region r on r.region_id = d.region_id
                  group by d.departement_id")
 
  dept<- dbGetQuery(db, query)

  
  couleurs <- colorNumeric("RdYlBu", dept$nombre, n = 10)
  
  # reactive function that creates the map using leaflet library
  output$mymap <- renderLeaflet({
    yourMap <- leaflet(dept) %>% addTiles() %>%
      addCircles(lng = ~longitude, lat = ~latitude,
                 weight = 1,
                 radius = ~sqrt(nombre) * 300, 
                 popup = ~paste(nom_departement, ":", nombre, "\n Region: ", nom_region),
                 color = ~couleurs(nombre), fillOpacity = 0.9) %>%
      addLegend(pal = couleurs, values = ~nombre, opacity = 0.9)
  })
  

  if (interactive()) {
    observe  ({
      x <- input$dimension
      killDbConnections()
      
      db = dbConnect(MySQL(),
                     dbname = "accidents",
                     host = "shinyapp.mysql.database.azure.com", 
                     user = "myadmin@shinyapp", 
                     password = "Shinyapp69", encoding = "UTF-8")
      
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
  

  #Onglet dashboard Histogramme
  attributeInput <-eventReactive(input$submit,{
    killDbConnections()
    
    db = dbConnect(MySQL(),
                   dbname = "accidents",
                   host = "shinyapp.mysql.database.azure.com", 
                   user = "myadmin@shinyapp", 
                   password = "Shinyapp69")
    query1 <- sprintf ("select  %s as attribut, count(distinct num_accident) as nombre FROM
                       %s x 
                       join accident a on a.%s_id = x.%s_id
                       group by 1 order by nombre desc",input$attribute, input$dimension, input$dimension, input$dimension)
    
    result <- dbGetQuery(db, query1)
  }
  )

  output$view <- renderPlot({
  donnee <- attributeInput()
  Encoding(donnee$attribut) <- "UTF-8"
    par(mar=c(12,5,5,5))
    my_bar=barplot(donnee$nombre , border=F , names.arg=donnee$attribut , las=2 , col=c(rgb(0.3,0.1,0.4,0.6) , rgb(0.3,0.5,0.4,0.6) , rgb(0.3,0.9,0.4,0.6) ,  rgb(0.3,0.9,0.4,0.6)) , main="" )
    abline(v=c(4.9 , 9.7) , col="grey")
    
 
  })
  
  #Onglet Dashboard : Infobox1
  accident <- sprintf("select  count(distinct num_accident) as nombre FROM accident ")
  accident_result <- dbGetQuery(db, accident)
  output$infobox1 <- renderInfoBox({
    infoBox(
      "Accidents en 2017", accident_result$nombre, icon = icon("car-crash"),
      color = "purple"
    )
  })
  
  #Onglet Dashboard : Infobox2
  usager <- sprintf("select  count(distinct usager_id) as nombre FROM accident ")
  usager_result <- dbGetQuery(db, usager)
  output$infobox2 <- renderInfoBox({
    infoBox(
      "Usagers", usager_result$nombre, icon = icon("users"),
      color = "yellow"
    )
  })
  
  #Onglet Dashboard : Infobox3
  veh <- sprintf("select  count(distinct vehicule_id) as nombre FROM accident ")
  veh_result <- dbGetQuery(db, veh)
  output$infobox3 <- renderInfoBox({
    infoBox(
      "Vehicules", veh_result$nombre, icon = icon("car")
    
    )
  })
  
  #Onglet Dashboard : Infobox4
  deces <- ("select gravite_accident , count(distinct num_accident) as nombre FROM
                   accident x
          join usager a on a.usager_id = x.usager_id
          group by 1 order by nombre asc
          ")
  deces_result <- dbGetQuery(db, deces)
  deces_result_pourecent <- ceiling(deces_result$nombre[1] * 100 / sum(deces_result$nombre))
  output$infobox4 <- renderInfoBox({
    infoBox(
      "nombre de décès", paste0(deces_result$nombre[1]),
      icon = icon("user"),  color = "blue" 
    )
  })
  
  #Onglet Dashborad : Gauge chart1
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
   
   #Onglet Dashborad : Gauge chart2
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
   
   #Onglet Dashborad : Gauge chart1
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
   
   
   #Onglet Map : Gauge chart1/2/3
   region <- ("select r.nom_region as region , count(distinct num_accident) as nombre FROM
                  accident a
                  join departement d on a.departement_id = d.departement_id
                  join region r on r.region_id = d.region_id
                  group by 1 order by nombre desc ")
   
   region_result <- dbGetQuery(db, region)
   region_result_pourecent <- ceiling(region_result$nombre[1] * 100 / sum(region_result$nombre))
   
   output$plt4 <- flexdashboard::renderGauge({
     gauge(region_result_pourecent, min = 0, max = 100, symbol = '%', label = paste(region_result$region[1]),gaugeSectors(
       success = c(100, 6), warning = c(5,1), danger = c(0, 1), colors = c("#CC6699")
     ))
   })
   region_result_pourecent2 <- ceiling(region_result$nombre[2] * 100 / sum(region_result$nombre))
   output$plt5 <- flexdashboard::renderGauge({
     gauge(region_result_pourecent2, min = 0, max = 100, symbol = '%', 
           label = paste(region_result$region[2]),gaugeSectors(
       success = c(100, 6), warning = c(5,1), danger = c(0, 1), colors = c("#CC6699")
     ))
   })
   region_result_pourecent3 <- ceiling(region_result$nombre[3] * 100 / sum(region_result$nombre))
   output$plt6 <- flexdashboard::renderGauge({
     gauge(region_result_pourecent3, min = 0, max = 100, symbol = '%', 
           label = paste(region_result$region[3]),gaugeSectors(
             success = c(100, 6), warning = c(5,1), danger = c(0, 1), colors = c("#CC6699")
           ))
   })

   
   #Onglet chartline : Graphique evolution temporelle
   dategraphInput <- reactive({
     killDbConnections()
     db = dbConnect(MySQL(),
                    dbname = "accidents",
                    host = "shinyapp.mysql.database.azure.com", 
                    user = "myadmin@shinyapp", 
                    password = "Shinyapp69")
   
     date <- sprintf("select EXTRACT(%s from date) as type_date , count(distinct num_accident) as nombre FROM
               accident x
              join date d on x.date_id = d.date_id
              group by 1 
              ",input$radio)
     date_result <- dbGetQuery(db, date)
     
    #date_result$mois <- month.abb[date_result$type_date]
     

   })

   output$dates <- renderPlot({
     date_result <- dategraphInput()
     if (input$radio =="MONTH"){ date_result$type_date <- month.abb[date_result$type_date] }
     ggplot(date_result, aes(type_date, nombre,group =1)) +geom_line(color = "#00AFBB", size = 2)+
       labs(x = input$radio, y = "Nombre d accidents ")
     
   })
   
   
   #Onglet Pie : Pie1
   pieInput <- eventReactive(input$submitPie,{
     killDbConnections()
     db = dbConnect(MySQL(),
                    dbname = "accidents",
                    host = "shinyapp.mysql.database.azure.com", 
                    user = "myadmin@shinyapp", 
                    password = "Shinyapp69")
     mesure1 <- sprintf ("select x.%s as attribut, count(distinct usager_id) as nombre FROM
                        usager x
                        
                        group by 1 order by nombre desc",input$usager)
     
     mesure_result1 <- dbGetQuery(db, mesure1)
     mesure2 <- sprintf ("select x.%s as attribut, count(distinct num_accident) as nombre FROM
                        usager x
                        join accident a on a.usager_id = x.usager_id
                        group by 1 order by nombre desc",input$usager)
     
     mesure_result2 <- dbGetQuery(db, mesure2)
     switch(input$mesure,
            "nombre d'usagers" = mesure_result2,
            "nombre d'accidents"= mesure_result1
     )
   })
     
   output$pie1 <- renderPlot({
     data <- pieInput()
     Encoding(data$attribut) <- "UTF-8"
     x <-  data$nombre
     labels <-  data$attribut
     piepercent<- round(100*x/sum(x), 1)
     pie(x, labels = paste0(piepercent," %"), main = paste0("Analyse du nombre d'accidents selons l'axe ",input$usager)
         ,radius= 1 ,col = rainbow(length(x)))
     legend("topleft",data$attribut, cex = 0.9,
            fill = rainbow(length(x)))
   })

   
   #Onglet Pie : Pie2
    pieInput2 <- reactive({
      killDbConnections()
      db = dbConnect(MySQL(),
                     dbname = "accidents",
                     host = "shinyapp.mysql.database.azure.com", 
                     user = "myadmin@shinyapp", 
                     password = "Shinyapp69")
      mesure1 <- sprintf ("select %s as attribut, count(distinct x.num_accident) as nombre FROM
                          accident x
                          join caracteristiques c on c.caracteristiques_id= x.caracteristiques_id
                          join lieux l on l.lieux_id = x.lieux_id
                          group by 1 ",input$caracteristique)
      
      mesure_result1 <- dbGetQuery(db, mesure1)

})


      output$pie2 <- renderPlot({
        data <- pieInput2()
        Encoding(data$attribut) <- "UTF-8"
        x <-  data$nombre
        labels <-  data$attribut
        piepercent<- round(100*x/sum(x), 1)
        pie(x, labels = paste0(piepercent," %"), main = paste0("Analyse du nombre d'accidents selons l'axe ",input$caracteristique)
            ,radius= 1 ,col = rainbow(length(x)))
        legend("bottomleft",data$attribut, cex = 0.9,
               fill = rainbow(length(x)))
      })
}