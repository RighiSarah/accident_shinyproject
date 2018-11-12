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

if (interactive()) {
  observe  ({
    x <- input$dimension
    db = dbConnect(MySQL(),
                   dbname = "accidents",
                   host = "shinyapp.mysql.database.azure.com", 
                   user = "myadmin@shinyapp", 
                   password = "Shinyapp69")
    
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
