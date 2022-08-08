Introduction:

Often times, free charting platforms (for stocks) don't give the user much control over selecting the date range. Most of the time, it gives the choice of 1 day, 5 days, 1 month, 3 or 6 months, and 1 year. This seems like a pretty straightforward problem to fix.

Data:

Unfortunately, Kaggle didn't quite have the data I wanted (not up to date historical data, and I wanted a little bit more information about the company). Interestingly enough, Wikipedia did. There, I found a list of all the companies in the S&P500 (Stock Market Index that tracks the performance of 500 large company stocks; usually considered a standard benchmark for large-cap equities) with the following information:

Ticker Symbol
Company Name
Sector
Industry
Headquarter Location
Date first added into SP500
Year Founded

Great! The only problem is that I don't have the historical price data. Thankfully, Yahoo Finance makes it incredibly easy to scrape through and find the historical data. Now we have our data.

The App:

The main feature of this app really is just allowing for the user to interact with the date. For example, perhaps I want to look at how Nvidia's stock price performed in 2015 to 2016.


Yahoo Finance (and most brokerages) will give me a "Max" chart, but it'd be incredibly difficult to see what the movement was.


I also added a few more details about the company. First, some basic information from our original Wikipedia list: Sector, Industry, HQ Location, and the Year the company was founded.


Second, I also added 1 month, 3 month, 6 month, 1 year, and 5 year returns relative to the most recent date (in this case, 05/20/2022).

For the Future:

If I had more time, I would make the returns section dynamic such that they are relative to the end date user selected.

I would like to add more Financial information about the company such as Revenue, Net Income/EBITDA, Debt, and Cash Flows just to name a few. Unfortunately, acquiring this data isn't that easy.

Another feature that would be interesting is being able to compare companies side by side. Overlaying price performance isn't very difficult, however, unless it's "standardized" and converted to the same base, it doesn't really tell too much. A more interesting aspect, in my opinion, would be to compare the financial data instead. Ratios like Price to Earnings (PE) or Earnings Per Share (EPS) make it a lot easier to see company to company comparisons.  Again, that data isn't easy to acquire. In an ideal world, this would facilitate an investor's due diligence process.
