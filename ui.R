# Load libraries, data -----------------------------------------------
data_muenster <- read.csv("data/data_muenster.csv", sep=";")
# Page 1 - Introduction ----------------------------------------------
intro_panel <- tabPanel(
  "Overview",
  titlePanel("Population Movement in Muenster"),
  img(src = "stadtlogo-muenster.png"),
  br(), br(),
  p("This Shiny App visualizes data of the population movement in the city Muenster. The data is from 
    the website of the city Muenster ", 
    a(href = "https://www.stadt-muenster.de/stadtentwicklung/zahlen-daten-fakten", "(Data Source - Bevoelkerungsbewegung)"), "."),
  p("Motivation: On the website of the city Muenster are graphics visualizing the data of the population movement. 
    These graphics give information about the movements in the individual districts of Muenster over several years. But they 
    don't compare the movements of the different districts. To visualize the differences in the different districts,
    I built an app comparing the population movements in the different districts of Muenster.")
)
# Page 2 - Visualization -------------------------------------------

# Sidebar
sidebar_content <- sidebarPanel(
  # Selector District
  selectInput(inputId = "district",
              label = 'Choose District of Interest:', 
              choices = unique(data_muenster$RAUM),
              multiple = TRUE,
              selected = c("11 Aegidii", "13 Dom", "14 Buddenturm")
  ),
  #Selector Year
  sliderInput(inputId = "year",
              label = "Choose Year of Interest",
              sep = "",
              ticks = FALSE,
              value = 2004, min = 2004, max = 2020),

  #Selector Reason
  checkboxGroupInput(inputId = "reason", "Choose Reason of Movement",
               c("Birth surplus or deficit" = "Birth surplus or deficit",
                 "Other population gains or losses" = "Other population gains or losses",
                 "Relocation gain or loss" = "Relocation gain or loss",
                 "Gain on moving in or loss on moving out" = "Gain on moving in or loss on moving out"),
               selected = "Birth surplus or deficit"
               ),
  br(),
  # Selectors
  checkboxInput("mean", "Mean Population Movement (from 2004 to 2020)"
                , FALSE),
  checkboxInput("accumulated", "Accumulated Population Movement (over all selected reasons)"
                , FALSE),
  br(),
  numericInput("numberTicks", "Number of ticks on the x-axis:", 15, min = 0, max = 60),
)

# Main
main_content <- mainPanel(
  plotOutput("plot")
  
)

# Header
visual_panel <- tabPanel(
  "Visualization",
  titlePanel("Population Movement in Muenster"),
  p("Use the selectors below to configurate your visualization comparing the population movements in the different districts."),
  sidebarLayout(
    sidebar_content, main_content
  )
)

# User Interface -----------------------------------------------------
ui <- navbarPage(
  "Muenster",
  intro_panel,
  visual_panel
)