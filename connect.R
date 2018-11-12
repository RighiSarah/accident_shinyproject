library(shiny)
library(DBI)
library(RMySQL)
library(shiny)
library(shinydashboard)
library(RMySQL)
library(leaflet)

db = dbConnect(MySQL(),
               dbname = "accidents",
               host = "shinyapp.mysql.database.azure.com", 
               user = "myadmin@shinyapp", 
               password = "Shinyapp69")




col_names <- sprintf ("show columns from departement")
col_names_result <- dbGetQuery(db, col_names)
print(length(col_names_result$Field))

query1 <- sprintf ("select %s as attribut, count(distinct num_accident) as nombre FROM
                     departement x
                   join accident a on a.departement_id = x.departement_id
                   group by 1",col_names_result$Field[2])

result <- dbGetQuery(db, query1)

query <- sprintf("select lumiere , count(distinct num_accident) as nombre FROM
                     caracteristiques x
                   join accident a on a.caracteristiques_id = x.caracteristiques_id
                  
                 group by 1 order by nombre desc ")

result1 <- dbGetQuery(db, query)
print (result1$lumiere[1])
print(ceiling(result1$nombre[1] * 100 / sum(result1$nombre))) 


lumiere <- sprintf("select lumiere , count(distinct num_accident) as nombre FROM
                   caracteristiques x
                   join accident a on a.caracteristiques_id = x.caracteristiques_id
                   
                   group by 1 order by nombre desc ")

lumiere_result <- dbGetQuery(db, lumiere)
lumiere_result_pourecent <- ceiling(lumiere_result$nombre[1] * 100 / sum(lumiere_result$nombre))



atmosphere <- ("select atmosphere , count(distinct num_accident) as nombre FROM
               caracteristiques x
               join accident a on a.caracteristiques_id = x.caracteristiques_id
               group by 1 order by nombre desc ")

atmosphere_result <- dbGetQuery(db, atmosphere)
atmosphere_result_pourecent <- ceiling(atmosphere_result$nombre[1] * 100 / sum(atmosphere_result$nombre))





