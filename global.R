# libraries
library(dplyr)
library(ggplot2)
library(forcats)
library(ggpubr)
library(plotly)
library(DT)

# Research activities data

# Importing the data
research_url <- "https://healthdata.gov/api/views/x7kq-cyv4/rows.csv?accessType=DOWNLOAD"
research_data <- read.csv("research_areas.csv")

# Selecting and renaming variables
research_data <- research_data[c("Topic", "Agency.and.Office.Name", "Status",
                                 "Country.ies..in.which.research.is.will.be.conducted")]
names(research_data) <- c("Topic", "Agencies", "Status", "Research Region")

# Cleaning the data
research_data$`Research Region` <- substring(research_data$`Research Region`, 0, 13)
research_data$Status  <- gsub(" phases", '', research_data$Status)
research_data$Status  <- gsub(";", '', research_data$Status)


# barplots
topic <- research_data %>%
  count(Topic) %>%
  rename(counts=n)

agencies <- research_data %>%
  count(Agencies) %>%
  rename(counts=n)

region <- research_data %>%
  count(`Research Region`) %>%
  rename(counts=n) 

status <- research_data %>%
  count(Status) %>%
  rename(counts=n)

df_list <- list("topic", "agencies", "region", "status")

# Mpox morbidity and mortality data 

cases_url <- "https://raw.githubusercontent.com/owid/monkeypox/main/owid-monkeypox-data.csv"

daily_cases <- read.csv("daily_mpox_cases.csv")
daily_cases <- daily_cases[c("location", "date", "total_cases", "total_deaths")]
names(daily_cases) <- c("Location", "Date", "Cases", "Deaths")
daily_cases$date <- as.POSIXct(daily_cases$Date)

location_cases <- daily_cases %>%
  group_by(Location) %>%
  summarise(across(Cases:Deaths, sum))

location_cases <- location_cases[location_cases$Location != "World", ]

worlddata <- map_data("world")
mapped_locations <- left_join(worlddata, location_cases, by=c('region'='Location'))

maps_vars  <- list("Cases", "Deaths")

summary(location_cases)
