library("shiny")
library("bslib")
library("ggplot2")
library("dplyr")

ui <- bslib::page_navbar(
  title = "Shiny live example",
  nav_panel(title = "Chart", 
            page_sidebar(
              sidebar = list(
                selectInput(
                  "vore", "Visualise animals with diet:",
                  choices = na.omit(sort(unique(msleep$vore))),
                  selected = "carni"
                ),
                varSelectInput("variable", "Variable:", msleep %>% 
                                 select(where(is.numeric)),
                               selected = "sleep_rem"),
                selectInput(
                  "model", "Model type:",
                  choices = c("lm", "loess"),
                  selected = "lm"
                )
              ),
              card(plotOutput("gg_plot"))
            )),
  nav_panel(title = "About",
            list(p("This shiny app is part of the", a(href = "https://www.linkedin.com/learning/building-data-apps-with-r-and-shiny-essential-training", "LinkedIn Learning Course: Building Data Apps with R and Shiny."))),
            p("The app demonstrates how it's possible to use shinylive to create shiny apps that work without a server."))
)

server <- function(input, output, session){
  
  output$gg_plot <- renderPlot({
    
    msleep %>% 
      filter(vore == input$vore) %>% 
      ggplot() +
      aes_string(x = "sleep_total",
                 y = input$variable) +
      geom_point(size = 4,
                 colour = "darkblue") +
      stat_smooth(method = input$model, col = "red") +
      theme_minimal(base_size = 18)
    
  })
  
}

shinyApp(ui, server)