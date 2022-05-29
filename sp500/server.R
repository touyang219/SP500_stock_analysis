library(plotly)

shinyServer(function(input, output) {

  # Price Chart
  output$price_chart = renderPlot({
  
  price_data = returns_long %>% filter(Ticker == input$ticker_select, Series == "Close")
  
  price_chart = ggplot(price_data) +
    geom_line(aes(x = Date, y = Value), color = "#0066ff") +
    xlab("Date") +
    ylab("Stock Price") +
    labs(
      title = paste0(price_data$Name[1], " (", input$ticker_select, ")"),
      # subtitle = paste0("Sector: ", price_data$Sector[1], "\n", "Industry: ",  price_data$Industry[1]),
      caption = "Source: Yahoo! Finance"
    ) + 
    scale_y_continuous(labels = scales::dollar) +
    theme(
      plot.background = element_rect(fill = "#000000"),
      panel.background = element_rect(fill = "#000000"),
      axis.text.x = element_text(color = "#ffffff", angle = 45, hjust = 1, vjust = 1),
      axis.text.y = element_text(color = "#ffffff"),
      axis.title.y = element_text(color = "#ffffff"),
      axis.title.x = element_text(color = "#ffffff"),
      plot.title = element_text(color = "#ffffff", hjust = 0.5),
      plot.subtitle = element_text(color = "#ffffff"),
      plot.caption = element_text(color = "#ffffff", face = "italic", size = 6),
      panel.grid.major.x = element_blank(),
      panel.grid.major.y = element_line(color = "#273746"),
      panel.grid.minor.x = element_blank(),
      panel.grid.minor.y = element_blank(),
      legend.position = "none",
      
    )
  
  price_chart
  })
  
  
  
  # Performance Charting
  output$performance_chart = renderPlot({
    
  performance_summary_data = performance_summary %>%
    filter(Ticker == input$ticker_select) %>% 
    select(one_month, three_months, six_months, one_year)
  
  performance_summary_data = performance_summary_data %>% gather("Period", "Return")
  
  performance_summary_data = performance_summary_data %>% mutate(
    Period = case_when(
      Period == "one_month" ~ "1 Month",
      Period == "three_months" ~ "3 Months",
      Period == "six_months" ~ "6 Months",
      Period == "one_year" ~ "1 Year",
      
    )
  )
  
  performance_summary_data$Period = factor(performance_summary_data$Period, levels = c("1 Month", "3 Months", "6 Months", "1 Year", "5 Years"))
  
  performance_chart = ggplot(performance_summary_data) +
    geom_bar(aes(x = Period, y = Return), stat = "identity", fill = "#0066ff") +
    xlab(" Time Period") +
    ylab("Returns in Percent") +
    labs(
      title = "Percent Returns over Different Time Periods",
      caption = "Source: Yahoo! Finance"
    ) + 
    scale_y_continuous(labels = scales::percent) +
    theme(
      plot.background = element_rect(fill = "#000000"),
      panel.background = element_rect(fill = "#000000"),
      axis.text.x = element_text(color = "#ffffff", angle = 45, hjust = 1, vjust = 1),
      axis.text.y = element_text(color = "#ffffff"),
      axis.title.y = element_text(color = "#ffffff"),
      axis.title.x = element_text(color = "#ffffff"),
      plot.title = element_text(color = "#ffffff", hjust = 0.5),
      plot.subtitle = element_text(color = "#ffffff"),
      plot.caption = element_text(color = "#ffffff", face = "italic", size = 6),
      panel.grid.major.x = element_blank(),
      panel.grid.major.y = element_line(color = "#273746"),
      panel.grid.minor.x = element_blank(),
      panel.grid.minor.y = element_blank(),
      legend.position = "none",
    )
  
  performance_chart
  })
  
  # Summary Details
  output$sector = renderInfoBox({
    sector = sp500 %>% filter(Ticker == input$ticker_select) %>% pull(Sector)
    infoBox(title = "Sector",value = sector, icon = icon("fa-solid fa-chart-pie"))
  })
  
  output$industry = renderInfoBox({
    industry = sp500 %>% filter(Ticker == input$ticker_select) %>% pull(Industry)
    infoBox(title = "Industry",value = industry, icon = icon("fa-solid fa-industry"))
  })
  
  output$location = renderInfoBox({
    location = sp500 %>% filter(Ticker == input$ticker_select) %>% pull(Location)
    infoBox(title = "HQ Location",value = location, icon = icon("fa-solid fa-building"))
  })
  
  output$founded = renderInfoBox({
    founded = sp500 %>% filter(Ticker == input$ticker_select) %>% pull(Founded)
    infoBox(title = "Year Founded", value = founded, icon = icon("fa-solid fa-calendar"))
  })
  
  
})
