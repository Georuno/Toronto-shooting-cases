#### Preamble ####
# Purpose: Gather data from open data Toronto
# Author: George Zhiqi Chen
# Data: 3 Feb 2021
# Contact: georgezhiqichen.chen@utoronto.ca 
# License: MIT
# Pre-requisites: None


#### Workspace setup ####
# install.packages("opendatatoronto")
# install.packages("tidyverse")
# install.packages("dplyr")
# install.packages("ggplot2")
# install.packages("bookdown")
library(opendatatoronto)
library(tinytex)
library(tidyverse)
library(knitr)
library(dplyr)
library(bookdown)
library(ggplot2)
library(here)


#### Gather data ####
#Based on https://open.toronto.ca/dataset/police-annual-statistical-
#report-shooting-occurrences/
#Each dataset is part of a package of data, these package have
#unique Ids, we can find the unique ID by going to the webpage

package <- show_package("f29feb49-ceb1-44bf-a2b6-5fc6a0e6147a")
package

#Within each package there are a bunch of different resources,
#e.g. datasets. We use the unique id to get them.
# get all resources for this package
resources <- list_package_resources("f29feb49-ceb1-44bf-a2b6-5fc6a0e6147a")

# We want a specific dataset that has information about each case
datastore_resources <- filter(resources, tolower(format) %in% c('csv'))

# Now we get dataset
shoot_data <- filter(datastore_resources, row_number()==1) %>% get_resource()
data

### Save ###
write_csv(shoot_data, "inputs/data/shooting_occurrences_data.csv")

### Clean data ###
shoot_clean <- shoot_data[-c(1, 2)]

#### Descriptive Summaries ####
str(shoot_clean)
summary(shoot_clean)

#### Saving clean data ####
write_csv(shoot_clean, here("inputs/data/clean_shoot_data.csv"))


#Total count of year Table    
shoot_clean |> 
  group_by(OccurredYear) |> 
  summarize(annual_sum = sum(Count_))

#bar graph
shoot_clean |>
  ggplot(mapping = aes(x = OccurredYear, y = Count_, fill = OccurredYear ))+
  geom_col(stat = "identity")+
  labs(title = "Total count of year")

# graph
shoot_clean |>
  ggplot(mapping = aes(x = OccurredYear, y = Count_))+
  geom_point(stat = "identity")


#Total count of Division (Table)
shoot_clean |> 
  group_by(GeoDivision) |> 
  summarize(area_sum = sum(Count_))

#graph
shoot_clean |>     
  ggplot(mapping = aes(x = Count_, y = GeoDivision, fill = OccurredYear))+
  geom_bar(stat = "identity")
         
