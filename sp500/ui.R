
shinyUI(
  dashboardPage(
    dashboardHeader(title = "Stock Performance Analyzer"),
    dashboardSidebar(
      selectInput("ticker_select", "Ticker", sp500$Ticker)
    ),
    dashboardBody(
      
      fluidRow(
        column(
          width = 12,
          box(
            width = "100%",
            plotOutput('price_chart')
          )
        )
      ),
      fluidRow(
        column(
        width = 6,
        box(
          width = "100%",
          plotOutput('performance_chart')
        )
      
      )
    ),
  )
)
)
