library(shiny)
source("collexeme_viz.R")
source("covarying_viz.R")

rep_con_data <- readRDS("data/rep_con_data.rds")
rep_con_forms <- unique(rep_con_data$construction.name)
rep_var_data <- readRDS("data/rep_var_data.rds")
rep_var_forms <- unique(rep_var_data$construction.name)


ui <- fluidPage(
    titlePanel("Collostruction Analysis"),
    sidebarPanel(
        selectInput("con_var", "構式類型",
                    c(重複變項 = "variable", 重複常項 = "constant")
        ),
        conditionalPanel(
            condition = "input.con_var == 'variable'",
            textInput("pos", "變項詞類", "a"),
            selectInput("rep_var_form", "構式 Form", rep_var_forms)
        ),
        conditionalPanel(
            condition = "input.con_var == 'constant'",
            textInput("word", "常項字詞", "好"),
            selectInput("rep_con_form", "構式 Form", rep_con_forms)
        ),
        width = 3
    ),
    mainPanel(
        conditionalPanel(
            condition = "input.con_var == 'variable'",
            plotOutput("collexemePlot", width = "100%", height = "680px")
        ),
        conditionalPanel(
            condition = "input.con_var == 'constant'",
            plotOutput("covaryingPlot", width = "100%", height = "680px")
        )
    )
)

server <- function(input, output, session) {
    
    observe({
        if(!is.null(input$word))
            updateSelectInput(session, "rep_con_form", 
                              choices = rep_con_forms[grepl(trimws(input$word), rep_con_forms)], 
                              selected = input$word )
    })
    
    observe({
        if(!is.null(input$pos))
            updateSelectInput(session, "rep_var_form", 
                              choices = rep_var_forms[grepl(input$pos, rep_var_forms)], 
                              selected = input$pos )
    })
    
    output$covaryingPlot <- renderPlot({
        covarying_viz(input$rep_con_form)
    })
    
    output$collexemePlot <- renderPlot({
        collexeme_viz(input$rep_var_form)
    })
}

shinyApp(ui, server)
