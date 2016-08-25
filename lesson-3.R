## Libraries and data

library(dplyr)
library(ggplot2)
surveys <- read.csv("data/surveys.csv", na.strings = "") %>%
  filter(!is.na(species_id), !is.na(sex), !is.na(weight))

## Constructing layered graphics in ggplot

ggplot(data = surveys,
       aes(x = species_id, y = weight)) +
  geom_point()

ggplot(data = surveys,
       aes(x = species_id, y = weight)) +
  geom_boxplot() +
  geom_point(stat = "summary",
             fun.y = "mean",
             color = "red")

## Exercise 1

#Using dplyr and ggplot show how the mean weight of individuals of the species DM varies across years and between males and females.

  surveys %>% 
  filter(species_id == "DM") %>%
  ggplot(aes(x = year, y = weight, color = sex)) +
  geom_point(stat = "summary",
             fun.y = "mean")

## Adding and customizing scales

year_wgt <- surveys %>% 
    filter(species_id == "DM") %>%
    ggplot(aes(x = year, y = weight, color = sex)) + 
    geom_point(aes(shape = sex),
               size = 3,
               stat = "summary",
               fun.y = "mean") +
    #geom_smooth(method = "lm")
    geom_smooth(aes(group = sex), method = "lm")
  
year_wgt

year_wgt + scale_color_manual(values = c("darkblue", "orange"),
                              labels = c("Female", "Male"))

year_wgt + scale_color_manual(values = c("black", "red"),
                              labels = c("Female", "Male"))

## Exercise 2

# Create a histogram, using a geom_histogram() layer, of the weights of individuals of species DM and divide the data by sex. Note that instead of using color in the aesthetic, you’ll use fill to distinguish the sexes. Also look at the documentation and determine how to explicitly set the bin width.

surveys %>% 
  filter(species_id == "DM") %>%
  ggplot(aes(x = weight, color = sex)) + 
  geom_histogram(binwidth = 1, aes(fill = sex))


## Axes, labels and themes

histo <- surveys %>% 
  filter(species_id == "DM") %>%
  ggplot(aes(x = weight, fill = sex)) + 
  geom_histogram(binwidth = 1)

histo <- histo +
  labs(title = "Dipodomys merriami weight distribution",
       x = "Weight (g)",
       y = "Count") +
  scale_x_continuous(limits = c(20, 60),
                     breaks = c(20, 30, 40, 50, 60))
histo

histo <- histo +
  theme_bw() +
  theme(legend.position = c(0.2, 0.5),
        plot.title = element_text(face = "bold", vjust = 2),
        axis.title.y = element_text(size = 13, vjust = 1), 
        axis.title.x = element_text(size = 13, vjust = 0))
histo

## Facets

surveys_dm$month <- as.factor(surveys_dm$month)
levels(surveys_dm$month) <- c("January", "February", "March", "April", "May", "June",
                              "July", "August", "September", "October", "November", "December")
ggplot(data = surveys_dm,
       aes(x = weight)) +
  geom_histogram(binwidth = 1) +
  facet_wrap( ~ month) +
  labs(title = "DM weight distribution by month",
       x = "Count",
       y = "Weight (g)")

ggplot(data = surveys_dm,
       aes(x = weight)) +
  geom_histogram(data = select(surveys_dm, -month),
                 alpha = 0.2, binwidth = 1) + # background layer of total histogram
  geom_histogram(binwidth = 1) + 
  facet_wrap( ~ month) +
  labs(title = "DM weight distribution by month",
       x = "Count",
       y = "Weight (g)")


ggplot(data = surveys_dm,
       aes(x = weight, fill = month)) +
  geom_histogram(data = select(surveys_dm, -month),
                 aes(y = ..density..),
                 fill = "black", binwidth =1) +
  geom_histogram(aes(y = ..density..),
                 alpha = 0.8, binwidth =1) +
  facet_wrap( ~ month) +
  labs(title = "DM weight distribution by month",
       x = "Count",
       y = "Weight (g)") +
  guides(fill = FALSE)

## Exercise 3

# Here’s a take-home challenge for you to try later. For records with species_id “DM” and “PB”, create facets along two categorical variables, species_id and sex, using facet_grid instead of facet_wrap.

surveys %>%
  
ggplot(surveys, aes(x = weight)) +
         geom_histogram(binwidth = 1) + 
         facet_wrap( ~ month) +
         labs(title = "DM weight distribution by month",
              x = "Count",
              y = "Weight (g)")

