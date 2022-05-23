library(rvest)
library(readr)
library(tidyverse)

# Getting Data of Companies in SP500

sp500_url = "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"

sp500 = read_html(sp500_url) %>% 
  html_node("table") %>%
  html_table() # There can be more than 500 companies in SP500, hence why we see 504

sp500 = sp500 %>% select(Symbol, Security, `GICS Sector`, `GICS Sub-Industry`, `Headquarters Location`, Founded)

names(sp500) = c("Ticker", "Name", "Sector", "Industry", "Location", "Founded")
sp500 = sp500 %>% filter(Ticker == "AAPL"| Ticker == "AMD" | Ticker ==  "AMZN" | Ticker ==  "GOOG" | Ticker == "MSFT" | Ticker == "NVDA" | Ticker == "COST" | Ticker == "WMT")

save(sp500, file = "sp500.csv")

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

save(returns_long, file = "returns_long.csv")


