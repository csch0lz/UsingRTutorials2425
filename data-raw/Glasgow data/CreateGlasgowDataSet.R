# The data have been downloaded from http://www.stats.ox.ac.uk/~snijders/siena/Glasgow_data.htm 
# and unzipped into the working directory.

library(tidyverse)

# Create a tidy data frame.

# Load and count friendship nominations.
load("Glasgow-friendship.RData")
# function to recode friendship variables
friend_dich <- function(x) ifelse(x %in% c(1, 2), 1, 0)
# create data frame with wave indicator
friendships <- rbind(friendship.1, friendship.2, friendship.3) %>%
  #change into a data frame
  broom::fix_data_frame(newcol = "student") %>%
  #add wave indicator
  mutate(wave = c( rep("t1", 160), rep("t2", 160), rep("t3", 160))) %>%
  #dichotomize all friendship variables
  mutate_at(vars(s001:s160), friend_dich) %>%
  #count number of friendship nominations received per wave
  group_by(wave) %>%
  summarise_at(vars(s001:s160), sum) %>%
  #stack students
  pivot_longer(
    -c(wave),
    names_to = "student",
    values_to = "friendships"
  )

# Load demographic variables: age and sex.
load("Glasgow-demographic.RData")

# Load substance use matrices: alcohol, cannabis, tobacco.
load("Glasgow-substances.RData")

# Load various data: .
load("Glasgow-various.RData")

# Create data frame.

Glasgow <- cbind( #create matrix
  age = age,
  sex = sex.F,
  alcohol = alcohol, 
  cannabis = cannabis,
  tobacco = tobacco,
  familysmoking = familysmoking,
  money = money,
  romantic = romantic
  ) %>%
  #change into dataframe with new variable names
  broom::fix_data_frame(
    newcol = "student",
    newnames = list("age", "sex",
                   "alcohol_t1", "alcohol_t2", "alcohol_t3",
                   "cannabis_t1", "cannabis_t2", "cannabis_t3",
                   "tobacco_t1", "tobacco_t2", "tobacco_t3",
                   "smoking_at_home", "smoking_parents", "smoking_siblings",
                   "money_t1", "money_t2", "money_t3",
                   "romantic_t1", "romantic_t2", "romantic_t3"
                   )
    ) %>%
  # stack repeated measurements
  pivot_longer(
    -c(student, age, sex, smoking_at_home, smoking_parents, smoking_siblings), 
    names_to = c(".value", "wave"),
    names_sep = "_"
  ) %>%
  # recode values
  mutate(
    sex = recode(sex, `1` = "boy", `2` = "girl"),
    smoking_at_home = recode(smoking_at_home, `1` = "no", `2` = "yes"),
    smoking_parents = recode(smoking_parents, `1` = "no", `2` = "yes"),
    smoking_siblings = recode(smoking_siblings, `1` = "no", `2` = "yes"),
    alcohol = recode(alcohol,
      `1` = "1 none", `2` = "2 once or twice a year", `3` = "3 once a month", 
      `4` = "4 once a week", `5` = "5 more than once a week"
      ),
    tobacco = recode(tobacco,
      `1` = "1 none", `2` = "2 occasional", `3` = "3 regular"
      ),
    romantic = recode(romantic, `1` = "no", `2` = "yes")
  ) %>%
  #add friendships count
  left_join(friendships, by = c("wave", "student")) %>%
  #sorted by money (rather random)
  arrange(money, friendships)

# save as .RData for inclusion in the package
save(Glasgow, file = "Glasgow.RData")
