
shinyUI(
  dashboardPage(
    dashboardHeader(title = "Stock Performance Analyzer"),
    dashboardSidebar(
      selectInput("ticker_select", "Ticker", sp500$Ticker),
      dateRangeInput("daterange", "Date range:",
                     start = min(returns$Date),
                     end   = max(returns$Date) 
                     )
      
    ),
    dashboardBody(
      
      fluidRow(
        column(
          width = 12, 
          box(
            width = "100%",
            plotOutput('price_chart')
          )
        ),
       
      fluidRow(
        column(
        width = 6,
        box(
          width = "100%",
          plotOutput('performance_chart')
        )
      
      ),
      column(
        width = 6,
        infoBoxOutput("sector", width = 6),
        infoBoxOutput("industry", width = 6),
        infoBoxOutput("location", width = 6), 
        infoBoxOutput("founded", width =6)
        
      )
    ),
      )
    )
  )
)
