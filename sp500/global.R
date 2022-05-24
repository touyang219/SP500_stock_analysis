library(rvest)
library(readr)
library(tidyverse)
library(shiny)
library(shinydashboard)

# Getting Data of Companies in SP500

sp500_url = "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"

sp500 = read_html(sp500_url) %>% 
  html_node("table") %>%
  html_table() # There can be more than 500 companies in SP500, hence why we see 504

sp500 = sp500 %>% select(Symbol, Security, `GICS Sector`, `GICS Sub-Industry`, `Headquarters Location`, Founded)

names(sp500) = c("Ticker", "Name", "Sector", "Industry", "Location", "Founded")
sp500 = sp500 %>% filter(Ticker == "AAPL"| Ticker == "AMD" | Ticker ==  "AMZN" | Ticker ==  "GOOG" | Ticker == "MSFT" | Ticker == "NVDA" | Ticker == "COST" | Ticker == "WMT")

# save(sp500, file = "sp500.csv")

# Creating empty Data

returns = as.data.frame(matrix(NA, ncol = 8, nrow = 0))
names(returns) = c("Date", "Open", "High", "Close", "Adj_Close", "Volume", "Ticker")

# Finding Historical Data (Price) of companies
for (symbol in sp500$Ticker) {
  url = paste0("https://query1.finance.yahoo.com/v7/finance/download/", symbol,"?period1=1337731200&period2=1653264000&interval=1d&events=history&includeAdjustedClose=true")
  #print(url)
  ret = try(read_csv(url)) # Some ticker symbols don't read into Yahoo Finance; don't have to worry for this project
  
  if(mode(ret) != "character"){
    ret$Ticker = symbol
    returns = rbind(returns, ret)
  }
}
names(returns) = c("Date", "Open", "High", "Low", "Close", "Adj_Close", "Volume", "Ticker")
returns = returns %>% select("Date", "Ticker", "Open", "High", "Low", "Close")

returns = returns %>% mutate(
  Open = as.numeric(Open),
  High = as.numeric(High),
  Low = as.numeric(Low),
  Close = as.numeric(Close),
)

returns = returns %>% mutate(
  Movement = ifelse(Close > Open, "Up", "Down")
)

save(returns, file = "historicalreturns.csv")

returns_long = returns %>% gather("Series", "Value", -Date, -Ticker, -Movement)
returns_long = returns_long %>% left_join(sp500, by = c("Ticker" = "Ticker")) 

# save(returns_long, file = "returns_long.csv")

# Calculating Performance

performance_summary = as.data.frame(matrix(NA, ncol = 6, nrow = 0))
names(performance_summary) = c("Ticker", "one_month", "three_months", "six_months", "one_year", "five_years")

i = 1
for(ticker in unique(returns_long$Ticker)){
  returns_long_by_ticker = returns_long %>% filter(Ticker == ticker, Series == "Close") %>% arrange(desc(Date))
  
  one_month = (returns_long_by_ticker$Value[1] - returns_long_by_ticker$Value[21])/returns_long_by_ticker$Value[21]
  three_months = (returns_long_by_ticker$Value[1] - returns_long_by_ticker$Value[63])/returns_long_by_ticker$Value[63]
  six_months = (returns_long_by_ticker$Value[1] - returns_long_by_ticker$Value[126])/returns_long_by_ticker$Value[126]
  one_year = (returns_long_by_ticker$Value[1] - returns_long_by_ticker$Value[253])/returns_long_by_ticker$Value[253]
  five_years = (1 + ((returns_long_by_ticker$Value[1] - returns_long_by_ticker$Value[1265])/returns_long_by_ticker$Value[1265]))^(1/5)-1

  performance_summary[i, 1] = ticker
  performance_summary[i, 2] = one_month
  performance_summary[i, 3] = three_months
  performance_summary[i, 4] = six_months
  performance_summary[i, 5] = one_year
  performance_summary[i, 6] = five_years
  
  i = i+1
}

performance_summary = performance_summary %>% left_join(sp500, by = c("Ticker" = "Ticker"))



