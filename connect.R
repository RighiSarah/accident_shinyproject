library(shiny)
library(DBI)
library(RMySQL)
library(shiny)
library(shinydashboard)
library(RMySQL)
library(leaflet)
library(Hmisc)

db = dbConnect(MySQL(),
               dbname = "accidents",
               host = "shinyapp.mysql.database.azure.com", 
               user = "myadmin@shinyapp", 
               password = "Shinyapp69")




query <- paste0("SELECT d.nom_departement,r.nom_region,latitude, longitude, count(distinct usager_id) as nombre
                FROM departement d
                join accident a on a.departement_id = d.departement_id
                join region r on r.region_id = d.region_id
                group by r.nom_region order by nombre desc")

dept<- dbGetQuery(db, query)

db = dbConnect(MySQL(),
               dbname = "accidents",
               host = "shinyapp.mysql.database.azure.com", 
               user = "myadmin@shinyapp", 
               password = "Shinyapp69")
df_usager <- sprintf("select u.annee_naissance as annee, count(usager_id) as nombre_usagers
                         from usager u where u.annee_naissance is not null
                         group by 1  ")

df_usager_result <- dbGetQuery(db, df_usager)


df_usager_result$annee <- as.numeric(df_usager_result$annee)
df_usager_result$nombre_usagers <- as.numeric(df_usager_result$nombre_usagers)
#p <- plot_ly(data, labels = ~data$attribut, values = ~data$nombre, type = 'pie') %>%
#  layout(title = 'United States Personal Expenditures by Categories in 1960',
 #        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
 #        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))