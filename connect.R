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

dataset <- sprintf("select  r.nom_region, c.lumiere, v.categorie_vehicule, u.sexe
                   from accident a 
                    join usager u on u.usager_id = a.usager_id
                   join caracteristiques c on c.caracteristiques_id = a.caracteristiques_id
                   join vehicule v on v.vehicule_id = a.vehicule_id
                   join date d on d.date_id = a.date_id
                   join departement dpt on dpt.departement_id = a.departement_id
                   join region r on r.region_id = dpt.region_id
                    ")
dataset_result<- dbGetQuery(db, dataset)

describe(dataset_result)


dataset <- sprintf("select  u.sexe, r.nom_region, u.gravite_accident,
                       v.categorie_vehicule
                   from accident a 
                   join usager u on u.usager_id = a.usager_id
                   join vehicule v on v.vehicule_id = a.vehicule_id
                   join departement dpt on dpt.departement_id = a.departement_id
                   join region r on r.region_id = dpt.region_id
                   ")
dataset_result<- dbGetQuery(db, dataset)
describe(dataset_result)

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
df_usager <- ("select u.sexe, u.annee_naissance , count(usager_id) as nombre_usagers
              from usager u
              group by 1 , 2")
df_usager_result <- dbGetQuery(db, df_usager)
#p <- plot_ly(data, labels = ~data$attribut, values = ~data$nombre, type = 'pie') %>%
#  layout(title = 'United States Personal Expenditures by Categories in 1960',
 #        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
 #        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))