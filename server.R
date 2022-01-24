# Load libraries, data ------------------------------------------------
library(ggplot2)
library(dplyr)
dataMuenster <- read.csv("data/data_muenster.csv", sep=";")

# Create server -------------------------------------------------------
server <- function(input, output){
  
  # Get subset of data of interest
  dataMuenster_subset <- reactive({
    subset(dataMuenster, Reason %in% input$reason & RAUM %in% input$district)
  })

  output$plot <- renderPlot({
    # Validation of the UI input
    validate(need(input$district != "", "Please select a district!"))
    validate(need(input$reason != "", "Please select a reason of movement!"))
    
    # Select subset of data set according to inputs from user interface
    axis_min = min(aggregate(dataMuenster_subset()[dataMuenster_subset()$WERT < 0,]$WERT, list(dataMuenster_subset()[dataMuenster_subset()$WERT < 0,]$ZEIT, dataMuenster_subset()[dataMuenster_subset()$WERT < 0,]$RAUM), sum)$x)
    axis_max = max(aggregate(dataMuenster_subset()[dataMuenster_subset()$WERT > 0,]$WERT, list(dataMuenster_subset()[dataMuenster_subset()$WERT > 0,]$ZEIT, dataMuenster_subset()[dataMuenster_subset()$WERT > 0,]$RAUM), sum)$x)
      
    # Plot
    ggplot() +
      geom_bar(data = dataMuenster_subset()[dataMuenster_subset()$ZEIT == input$year, ],
               aes(RAUM, WERT, fill = Reason),
               stat="identity",
               alpha=0.9, width=.4) +
      
      # Design
      coord_flip() +
      xlab("District") + 
      theme(axis.text.x= element_text(size = 12), axis.text.y= element_text(size = 12)) +
      
      scale_y_continuous(name = "Gain/Loss of population (absolut number of people)", 
                           limits = c(min = axis_min, max = axis_max),
                           breaks = scales::pretty_breaks(n=input$numberTicks)
      ) +
      
      # Legend
      theme(legend.position="bottom",
            legend.title = element_text(size=12, face="bold"),
            legend.text = element_text(size=12)) +
      scale_color_manual(name = "", values = c("Mean" = "#005b79")) +
      geom_hline(yintercept = 0)+
               
      # from UI: accumulated movement
        {if (input$accumulated){
          geom_point(data = aggregate(dataMuenster_subset()[dataMuenster_subset()$ZEIT == input$year, ]$WERT, 
                                      list(dataMuenster_subset()[dataMuenster_subset()$ZEIT == input$year, ]$RAUM), 
                                      sum), 
                     aes(Group.1, x),
                     size = 3)
          }}+
      
      # from UI: extra layer for mean over years
      if (input$mean) {
        geom_bar(data = aggregate(dataMuenster_subset()$WERT,
                                  list(dataMuenster_subset()$RAUM), mean),
                 aes(Group.1, x, colour = "Mean"),
                 stat="identity", 
                 fill="#005b79",
                 alpha=0.2,
                 width=.5)
        }
    })


}