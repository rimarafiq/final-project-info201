library(ggplot2)
library(plotly)
library(dplyr)
library(bslib)

pima_indians_diabetes <- read.csv("https://query.data.world/s/omeyqrehjvpxhna3srxvdbh6o5kfv6")

server <- function(input, output) {
  
  output$barGraph <- renderPlotly({
    pima_indians_diabetes$Outcome[pima_indians_diabetes$Outcome == "0"] <- "Does Not Have Type 2 Diabetes"
    pima_indians_diabetes$Outcome[pima_indians_diabetes$Outcome == "1"] <- "Has Type 2 Diabetes"
    pima_indians_diabetes$Glucose <- 0.001 * (pima_indians_diabetes$Glucose)
    pima_indians_diabetes$Insulin <- 0.001 * (pima_indians_diabetes$Insulin)
    avg_pedigree <- pima_indians_diabetes %>% group_by(Outcome) %>% 
      summarize(Average = mean(DiabetesPedigreeFunction))
    avg_glucose <- pima_indians_diabetes %>% group_by(Outcome) %>% 
      summarize(Average = mean(Glucose)) 
    avg_insulin <- pima_indians_diabetes %>% group_by(Outcome) %>% 
      summarize(Average = mean(Insulin))
    
    avg_pedigree$VariableType <- "DiabetesPedigreeFunction" 
    avg_glucose$VariableType <- "Glucose"
    avg_insulin$VariableType <- "Insulin"
    
    merged_table <- rbind(avg_glucose,avg_insulin,avg_pedigree)
    Condition <- merged_table$Outcome
    Metric <- merged_table$VariableType

    filtered_df <- reactive({
      merged_table %>%
        filter(VariableType %in% input$metric_displayed) %>%
        filter(Outcome %in% input$patient_displayed)
    })
    
    first_plot <- ggplot(data = filtered_df(), aes(x = Outcome, y = Average, 
                                                   fill = VariableType)) + 
      geom_bar(position = "dodge", stat = "identity") + 
      labs(title = "Levels of Different Metrics that Affect Development of Type 2 Diabetes", 
           x = "Condition", y = "Metric Value") + 
      scale_fill_manual(values = c("DiabetesPedigreeFunction" = "#141976", 
                                   "Glucose" = "#0D72DA", "Insulin" = "#71C3FF"))
    my_plotly_plot1 <- ggplotly(first_plot)
    return(my_plotly_plot1)
  })
  
  output$histogram <- renderPlotly({
    if (input$patient_type == 1) {
      no_diabetes <- pima_indians_diabetes %>% filter(pima_indians_diabetes$Outcome == "0")
      no_diabetes$Outcome[no_diabetes$Outcome == "0"] <- "Does Not Have Type 2 Diabetes"
      second_plot <- ggplot(no_diabetes, aes(x = BMI, fill = Outcome)) +
        geom_histogram(color = "Black", position = 'identity') +
        scale_fill_manual(values=c("#FFAB53")) +
        labs(title = "The Distribution of BMI's for Patients Without Type 2 Diabetes", x = "BMI", y = "Patient Count")
    } else if (input$patient_type == 2) {
      has_diabetes <- pima_indians_diabetes %>% filter(pima_indians_diabetes$Outcome == "1")
      has_diabetes$Outcome[has_diabetes$Outcome == "1"] <- "Has Type 2 Diabetes"
      second_plot <- ggplot(has_diabetes, aes(x = BMI, fill = Outcome)) +
        geom_histogram(color = "Black", position = 'identity') +
        scale_fill_manual(values=c("#FFF668")) +
        labs(title = "The Distribution of BMI's for Patients With Type 2 Diabetes", x = "BMI", y = "Patient Count")
    } else {
      pima_indians_diabetes$Outcome[pima_indians_diabetes$Outcome == "0"] <- "Does Not Have Type 2 Diabetes"
      pima_indians_diabetes$Outcome[pima_indians_diabetes$Outcome == "1"] <- "Has Type 2 Diabetes"
      second_plot <- ggplot(pima_indians_diabetes, aes(x = BMI, fill = Outcome)) +
        geom_histogram(color = "Black", position = 'identity') +
        scale_fill_manual(values=c("#FFAB53", "#FFF668")) +
        labs(title = "The Distribution of BMI's for Patients With and Without Type 2 Diabetes", x = "BMI", y = "Patient Count")
    }
    my_plotly_plot2 <- ggplotly(second_plot)
    return(my_plotly_plot2)
  })
  
  output$dotPlot <- renderPlotly({
    pima_indians_diabetes$Outcome[pima_indians_diabetes$Outcome == "0"] <- "Does Not Have Type 2 Diabetes"
    pima_indians_diabetes$Outcome[pima_indians_diabetes$Outcome == "1"] <- "Has Type 2 Diabetes"
    
    blood_pressure_diabetes <- pima_indians_diabetes %>% 
      filter(Outcome == "Has Type 2 Diabetes") %>%
      group_by(BloodPressure) %>% 
      summarize(age = mean(Age))
    
    blood_pressure_no_diabetes <- pima_indians_diabetes %>%
      filter(Outcome == "Does Not Have Type 2 Diabetes") %>%
      group_by(BloodPressure) %>%
      summarize(age2 = mean(Age))
    
    avg_blood_pressure <- left_join(blood_pressure_diabetes, 
                                    blood_pressure_no_diabetes, by = 'BloodPressure')
    
    diabetes <- left_join(avg_blood_pressure, pima_indians_diabetes, 
                          by = 'BloodPressure')
    
    third_plot <- ggplot(data = diabetes) +
      geom_point(mapping = aes(x = Age, y = BloodPressure, color = Outcome)) +
      xlim(input$Age) +
      labs(title = "Average Blood Pressure For Patients With and Without Type 2 Diabetes By Age", 
      x = "Age", y = "Average Blood Pressure") 
    
    my_plotly_plot3 <- ggplotly(third_plot)
    return(my_plotly_plot3)
  })
}
