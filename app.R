library(shiny)
library(shinythemes)
library(vroom)
library(dplyr)
library(readr)

options(shiny.maxRequestSize = 15 * 1024^2)

ui <- fluidPage(
  titlePanel("Shinyem"),
  theme = shinytheme("simplex"),
  fileInput("upload", "Carregue um arquivo .csv", accept = ".csv"),
  numericInput("n", "Número de Linhas", value = 6, min = 1, step = 1),
  tableOutput("arquivos")
)

server <- function(input, output, session) {
  
  data <- reactive({
    req(input$upload)
    
    ext <- tools::file_ext(input$upload$name)
    if (ext != "csv") {
      showNotification("Formato inválido, insira um arquivo .csv", type = "error", duration = 6)
    }
    
    df <- vroom::vroom(input$upload$datapath, delim = ";")
    return(df)
  })
  
  output$arquivos <- renderTable({
    data() %>% head(input$n)
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
