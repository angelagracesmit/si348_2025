# SI 348 - Lecture 03-02
# Data Transformation - R4DS Chapter 2

# Preamble ---------------------------
library(tidyverse)
library(palmerpenguins)

# Viewing your data ------------------
glimpse(penguins)
view(penguins)

# Exploring Distributions ------------
# Categorical variables - typically we use a bar chart
ggplot(penguins, aes(x = species)) +
  geom_bar()

ggplot(penguins, aes(x = fct_infreq(species))) +
  geom_bar()

# Continuous / Numerical variables - Histogram
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200)

# check how many NAs we have, does it match the warning we got?
sum(is.na(penguins$body_mass_g))

# histogram - adjust the bin width
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 20)

# density plot - a smoothed version of the histogram
ggplot(penguins, aes(x = body_mass_g)) +
  geom_density()

# Exploring Relationships
# Numerical and categorical variables
# Boxplots
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_boxplot()

# Multiple density plots on a sinlge graph
ggplot(penguins, aes(x = body_mass_g, color = species)) +
  geom_density(linewidth = 1)

# adjusting the fill/color settings
ggplot(penguins, aes(x = body_mass_g, color = species, fill = species)) +
  geom_density(linewidth = 1, alpha = 0.5)

# 2 categorical variables
# Bar charts remain a solid option
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar()

ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill") # Do not confuse this "fill" option with the one in aes()

# 2 numerical variables
# Scatterplot
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()

# 3 or more variables
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = island))

# Facet wrap
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = species)) +
  facet_wrap(~island)
