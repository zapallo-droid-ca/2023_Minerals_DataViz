### Project: Minerals for Energy Transition

## Definitions:
The project consolidates data on the production and trade of the main minerals required for the energy transition delivering a Power BI Dashboard.

## Project Resources:
* ETL: The main process is in [this project](https://github.com/zapallo-droid-ca/2023.Minerals-ETL)
* Dashboard: The final product can be found in [this link](https://github.com/zapallo-droid-ca/2023.Minerals-DataViz/tree/main/prod)

Further details of the minerals have been written in the [domain research doc](https://github.com/zapallo-droid-ca/2023.Minerals-ETL/blob/main/docs/domain_research/domain_research.md) in the docs section.

## Project Highlights:

The project contains data about the production of Critical minerals for energy transitions as a tool for monitoring and describing the changes and evolution of the topic from 1970 to 2020 with an emphasis on taking one main numeric variable (production) and getting extra information through feature engineering, for this case by decomposing the time series and calculating relative measurements, only as a complement in the last section two new numeric variables have been included just to give context on the trade profile of the countries. The first and main report presents the data as a time series showing the % of yearly change by mineral group and summarizing by a given range of years that can be dynamically changed with a slicer. The report has been designed to allow the user to explore curiously through drill-trough tools.

*Report Sections:*
•	Global View (main page) with % of yearly change by group of minerals
•	Time series view by mineral (access from Global View for each mineral), where the user can find the Time Series Decomposition and producer countries.
•	Production view, where users can analyze the time series and its components (Level, Trend, Seasonal and Residual) with producer countries clustered by component aiming to find patterns among them.
•	Benchmark view, where the production of a given mineral can be compared between two countries (A and B) with some additional highlights of the trade balance for them.

## Dashboard Exploration:

### Main View
Given a period of ten years from 2011 to 2020 the most relevant changes speaking in relative terms were the cumulated -30.2% change for non-metals and the increase of 56.9% in the production of Rare Earths, it is important to not compare the productions among minerals with tones or absolute measures due that the huge differences in their distributions and magnitudes, for example, in that period the tones produced of Rare Earths were only 2.32 Millions, on the other hand 19.28 Billions of Tonnes were produced in the Metals category.

![IMAGE 01](https://github.com/zapallo-droid-ca/2023.Minerals-DataViz/blob/main/prod/screenshots/01.main.png)

*Time series view by mineral*
Looking at the Rare Earths category, it's interesting that even when there have been 11 producers between 2011 and 2020 the differences in term of levels is huge, where China is the biggest producer.

![IMAGE 02](https://github.com/zapallo-droid-ca/2023.Minerals-DataViz/blob/main/prod/screenshots/02.png)

Even when China is the major producer, also the only one with a negative Residual component, this is an interesting thing to take into account due to the nature of the residual component, which means that something happens in that period that decreases the expected level of the time series, is not a seasonal or a trending phenomenon, which in this context and taking into account that the market has been expanding during the period can tell that other players increase their production over its trend or seasonality behaviour, could be the cases of Australia and United States.

China Time Series Decomposition (TSD):
![IMAGE 03](https://github.com/zapallo-droid-ca/2023.Minerals-DataViz/blob/main/prod/screenshots/03.png)

Australia TSD:
![IMAGE 04](https://github.com/zapallo-droid-ca/2023.Minerals-DataViz/blob/main/prod/screenshots/04.png)

United States TSD:
![IMAGE 05](https://github.com/zapallo-droid-ca/2023.Minerals-DataViz/blob/main/prod/screenshots/05.png)

### Production view
Knowing that the Rare Earth market is almost concentred let's change to the Petroleum market to explore the production view which is more interesting given a crowded market considering that allows us to see the data clustered by component.
In this view, we’re not able to see the yearly % of the change in the production but we can see the components cumulated by cluster and get a general idea of what’s happened in the market. This market between 2011 and 2020 had more than 100 with at least one (01) unit of product produced (according to the source) but there are no more than 30 countries with relevant production. In the same period, the production of Petroleum has changed by 4.5% where the biggest producers are Russia, Saudi Arabia, and The United States.

![IMAGE 06](https://github.com/zapallo-droid-ca/2023.Minerals-DataViz/blob/main/prod/screenshots/07.png)

We have two clusters by component, but in general terms, the most relevant issues happened with the main producers, this group have similar behaviour in trend, and have increased in the last decade but there with a negative trend in the past and a tail of negative residual values.
![IMAGE 08](https://github.com/zapallo-droid-ca/2023.Minerals-DataViz/blob/main/prod/screenshots/08.png)

Russia TSD:
![IMAGE 09](https://github.com/zapallo-droid-ca/2023.Minerals-DataViz/blob/main/prod/screenshots/09.png)

Saudi Arabia TSD:
![IMAGE 10](https://github.com/zapallo-droid-ca/2023.Minerals-DataViz/blob/main/prod/screenshots/10.png)

United States TSD:
![IMAGE 11](https://github.com/zapallo-droid-ca/2023.Minerals-DataViz/blob/main/prod/screenshots/11.png)


### Benchmark View
Taking Russia and United States (US) into the benchmark view and comparing both TSD in the period of analysis the level or the TOE of Petroleum produced has relatively similar values but the major difference can be found with the residual component, the Russian series has a steady trend and just a light impact of the residual component from 2011 the history shows that during the last periods, the trend has been under a stabilization process given the changes between 1990 and 2010, on the other hand, the US series has increased far from its trend, which has been driven by the residual component in a 29% during the 10 years range, this means that the changes where stronger for the US production and has not the same “stability” yet than the Russian level considering that there are non-extraordinary or unexpected phenomena in those years but the willingness of the US of increasing their production to secure their supply chain.
The profile in trade is considerably different, even when the US has produced more than Russia in the 10-year range, the first has an export and import profile with a stronger import component, but the second has an almost exporter profile.
![IMAGE 12](https://github.com/zapallo-droid-ca/2023.Minerals-DataViz/blob/main/prod/screenshots/12.png)

## Final thoughts:
Taking one numeric variable which is the production of a mineral (in this case) we can get more information with feature engineering through Time Series Decomposition or using relative measurements such as % of change.






