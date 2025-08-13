# SI 348 - Lecture 03-03
# Data Transformation - R4DS Chapter 3

# Preamble ---------------------------
library(tidyverse)
# install.packages("nycflights13")
library(nycflights13) # data we are using

# Viewing your data ------------------
glimpse(flights)
# view(flights)

# Dplyr basics -----------------------
# Structure:
# input data frame , arguments to modify, output new data frame 
# arguments to modify are verbs, easy to understand
# pipe - |> - think of it as "then"
# SETTINGS: tools > global options > code > use native pipe operator

flights |>
  filter(dest == "IAH") |> 
  group_by(year, month, day) |> 
  summarize( # reduces data frame to a single summary stat per group
    arr_delay = mean(arr_delay, na.rm = TRUE)
  )

# output to new data frame by assigning it using <- 
flight_delays <- flights |>
  filter(dest == "IAH") |> 
  group_by(year, month, day) |> 
  summarize( # reduces data frame to a single summary stat per group
    arr_delay = mean(arr_delay, na.rm = TRUE)
  )

view(flight_delays)

# Rows ------------------------------
# filter, arrange, distinct

# filter() --------------------------
flights |> 
  filter(dep_delay > 120) # also <, >=, <=, ==, !=

# ! is used in this way in other cases too!
sum(!is.na(flights$dep_delay))

# AND: Flights that departed on January 1
flights |> 
  filter(month == 12 & day == 25)

# OR: Flights that departed in January or February
jan_feb_flights <- flights |> 
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
delay_order <- flights |> 
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

# don't overwrite unless you are sure
flights <- flights |> 
  mutate(
    # air_time = air_time / 60
    air_time_hrs = air_time / 60
  )

# where to place your new variable, by default it gets added to the end
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
  select(year, month, day) # specify exact columns

flights |> 
  select(year:day) # specify a range between 2 column names

flights |> 
  select(!year:day) # drop a range of columns

flights |> 
  select(where(is.character))

flights |> 
  select(where(is.numeric))

flights |> 
   select(starts_with("arr"))

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

# Groups --------------------------
# group_by, summarize, slice

# group_by() -------------------------
flights |> 
  group_by(month)

# summarize() -----------------------
flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE)
  )

# include as many summary variables as needed
flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE), 
    n = n()
  )

# slice functions
# df |> slice(1:20) returns the first 20 rows.
# for groups:
# df |> slice_head(n = 1) takes the first row from each group.
# df |> slice_tail(n = 1) takes the last row in each group.
# df |> slice_min(x, n = 1) takes the row with the smallest value of column x.
# df |> slice_max(x, n = 1) takes the row with the largest value of column x.
# df |> slice_sample(n = 1) takes one random row.
# NOTE:
# You can vary n to select more than one row, 
# or instead of n =, you can use prop = 0.1 to select (e.g.) 10% of the rows in each group.

flights |> 
  group_by(dest) |> 
  slice_max(arr_delay, n = 1) # will give back one row for each destination with the maximum arrival delay


flights |> 
  group_by(dest) |> 
  slice_min(dep_delay, n = 1) # will give back one row for each destination with the minimum departure delay


# ungrouping
flights |> 
  ungroup()
