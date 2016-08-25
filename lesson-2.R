## Tidy data concept

counts_df <- data.frame(
  day = c("Monday", "Tuesday", "Wednesday"),
  wolf = c(2, 1, 3),
  hare = c(20, 25, 30),
  fox = c(4, 4, 4)
)

## Reshaping multiple columns in category/value pairs

library(tidyr)
counts_gather <- gather(counts_df, 
                        key = "species",
                        value = "count",
                        wolf:fox)

# Reverse gather command
counts_spread <- spread(counts_gather, 
                        key = species,
                        value = count) # no need to use quotes, now already column name

## Exercise 1

# Q: what happens when you remove a row?
counts_gather <- counts_gather[-8, ]

sol1 <- spread(counts_gather, 
       key = species,
       value = count, fill = 0)
# A: replaces value with NA

## Read comma-separated-value (CSV) files

surveys <- read.csv("data/surveys.csv")

str(surveys)

surveys <- read.csv("data/surveys.csv", na.strings = "") # fills in blanks with <NA>
# removes levels of blank IDs for factors

## Subsetting and sorting

library(dplyr)
surveys_1990_winter <- filter(surveys,
                              year == 1990,
                              month %in% 1:3) # comma and & equal
str(surveys_1990_winter)

surveys_1990_winter <- select(surveys_1990_winter, 
                              record_id, month, day, plot_id,
                              species_id, sex, hindfoot_length, weight)

# surveys_1990_winter <- select(surveys_1990_winter, -year) # alternative way to do it

str(surveys_1990_winter)

sorted <- arrange(surveys_1990_winter,
                  desc(species_id), weight) # default is ascending sort
str(sorted)

## Exercise 2

#Write code that returns the record_id, sex, and weight of all RO

sol2 <- select(filter(surveys, 
                      species_id == "RO"), 
               species_id, record_id, sex, weight)
sol2

## Grouping and aggregation

surveys_1990_winter_gb <- group_by(surveys_1990_winter, species_id)
str(surveys_1990_winter_gb)

counts_1990_winter <- summarize(surveys_1990_winter_gb, count = n())
counts_1990_winter

## Exercise 3

# Write code that returns the average weight and hindfoot length of Dipodomys merriami (DM) individuals observed in each month (irrespective of the year). Make sure to exclude NA values.

sol3 <- summarize(group_by(filter(surveys, species_id == "DM"), 
                           month), 
                  weight_avg = mean(weight, na.rm = T),
                  hindfoot_avg = mean(hindfoot_length, na.rm = T))

sol3

## Transformation of variables

prop_1990_winter <- mutate(counts_1990_winter,
                           prop = count / sum(count))

head(prop_1990_winter)
## Exercise 4

# Filter a grouped data frame to return only rows showing the records from surveys_1990_winter with the minimum weight for each species_id.

sol4a <- summarize(filter(group_by(surveys, 
                                  species_id), 
                         year == 1999, 
                         month %in% 1:3), 
                  min_weight = min(weight, na.rm = T))

# For each species in surveys_1990_winter_gb, create a new colum giving the rank order (within that species!) of hindfoot length. (Hint: Read the documentation under ?ranking.)

sol4b <- mutate(surveys_1990_winter_gb, foot_rank = dense_rank(hindfoot_length))

## Chainning with pipes

prop_1990_winter_piped <- surveys %>%
  filter(year == 1990, month %in% 1:3) %>% 
  select(-year) %>% # select all columns but year
  group_by(species_id) %>% # group by species_id
  summarize(count = n()) %>%  # summarize with counts
  mutate(prop = count / sum(count)) # mutate into proportions
