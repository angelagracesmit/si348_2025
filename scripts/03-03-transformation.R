# SI 348 - Lecture 03-03
# Data Transformation - R4DS Chapter 3

# Preamble ---------------------------
library(tidyverse)
# install.packages("nycflights13")
library(nycflights13) # data we are using

# Viewing your data ------------------
glimpse(flights)
view(flights)

# Dplyr basics -----------------------
# Structure:
# input data frame , arguments to modify, output new data frame 
# arguments to modify are verbs, easy to understand
# pipe - |> - think of it as "then"
# SETTINGS: tools > global options > code > use native pipe operator

flights |>
  filter(dest == "IAH") |> 
  group_by(year, month, day) |> 
  summarize(
    arr_delay = mean(arr_delay, na.rm = TRUE)
  )

# Rows ------------------------------
# filter, arrange, distinct

# filter() --------------------------
flights |> 
  filter(dep_delay > 120) # also <, >=, <=, ==, !=

# AND: Flights that departed on January 1
flights |> 
  filter(month == 1 & day == 1)

# OR: Flights that departed in January or February
flights |> 
  filter(month == 1 | month == 2)

# NOTE: A shorter way to select multiple conditions with OR
# flights that departed in January or February
flights |> 
  filter(month %in% c(1, 2))

# save it to use later on by assigning it to jan1
jan1 <- flights |> 
  filter(month == 1 & day == 1)

# arrange() -------------------------
# sorts rows based on column values
flights |> 
  arrange(year, month, day, dep_time)

# by default - orders in ascending order 
flights |> 
  arrange(desc(dep_delay)) # make it descending order

# distinct() -----------------------
# Remove duplicate rows, if any
flights |> 
  distinct()

# Find all unique origin and destination pairs
flights |> 
  distinct(origin, dest) # note that this returns only the columns specified

flights |> 
  distinct(origin, dest, .keep_all = TRUE) # returns all columns

# Columns --------------------------
# mutate, select, rename, relocate

# mutate() -------------------------
# add new columns or edit existing columns (overwriting is not advised)
flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / (air_time / 60)
  )

# where to place your new variable
flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / (air_time / 60),
    .after = day # can also use .before and columns position number instead of name
  )

# Keep only specific columns
flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours,
    .keep = "used" # other options: unused, all, none
  )


# rename() -------------------------
# keeps all columns, only renames the columns specified
flights |> 
  rename(tail_num = tailnum) # new_name = old_name

# select() -------------------------
# Often you may only need some of the columns in a data frame
flights |> 
  select(year, month, day)

flights |> 
  select(year:day)

flights |> 
  select(!year:day)

flights |> 
  select(where(is.character))

# also:
# starts_with("abc"): matches column names that begin with “abc”
# ends_with("xyz"): matches names that end with “xyz”
# contains("ijk"): matches names that contain “ijk”

# rename columns as you select them 
flights |> 
  select(tail_num = tailnum) # new_name = old_name

# relocate() -----------------------
# move columns around
flights |> 
  relocate(time_hour, air_time) # default is to move to front

# use .before and .after just like in mutate()
flights |> 
  relocate(year:dep_time, .after = time_hour)

flights |> 
  relocate(starts_with("arr"), .before = dep_time)

