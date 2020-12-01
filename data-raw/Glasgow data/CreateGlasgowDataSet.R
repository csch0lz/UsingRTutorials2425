# The data have been downloaded from http://www.stats.ox.ac.uk/~snijders/siena/Glasgow_data.htm 
# and unzipped into the working directory.

library(tidyverse)

# Create a tidy data frame for Session 2. ####

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
    cannabis = recode(cannabis,
                         `1` = "1 none", `2` = "2 tried once", `3` = "3 occasional", 
                         `4` = "4 regular"
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

#cleanup
rm(alcohol, cannabis, familysmoking, friendship.1, friendship.2, friendship.3, friendships, money, romantic, tobacco, age, sex.F, friend_dich, Glasgow)


# Create an untidy data frame for Session 3. ####

# Start with table of Session.
# Load table.
load("Glasgow.RData")

# Create virtual neigbourhoods and add to student with distance to school category
load("Glasgow-geographic.RData")
# distance.1 is student by student matrix with distances at wave 1
# replace NA by overall mean
dist1 <- ifelse(is.na(distance.1), 
           (ifelse(is.na(distance.2), 
             (ifelse(is.na(distance.3), mean(distance.1, na.rm = TRUE), distance.3)), 
              distance.2)), distance.1)
clustering <- hclust(dist(dist1), method = "ward.D")
burrough <- cutree(clustering, k=4) # cut tree into 4 clusters (one contains missings)
# draw dendogram with red borders around the 5 clusters
rect.hclust(clustering, k=4, border="red") 
# add distance from school per group at wave 1 and group label to tidy frame
GlasgowFriends <- as_tibble(cbind(burrough, dist.school), rownames = "student" ) %>%
  select(student, burrough, school.dist = l1) %>%
  group_by(burrough) %>%
  mutate(schooldist = round(mean(school.dist, na.rm = TRUE), 2)) %>%
  mutate(name = case_when(
    burrough == 1 ~ "Burrough A",
    burrough == 2 ~ "Burrough B",
    burrough == 3 ~ "Burrough C",
    TRUE ~ NA_character_,
  ),
    schooldist = ifelse(is.nan(schooldist), NA_real_, schooldist)
  ) %>%
  select(-school.dist) %>%
  right_join(Glasgow, by = "student")
#cleanup
rm(angle.1, angle.2, angle.3, clustering, dist.school, dist1, distance.1, distance.2, distance.3, Glasgow, burrough)

# Add nominated friends (student codes).
# Load and count friendship nominations.
load("Glasgow-friendship.RData")
# Stack waves
friendships <- rbind(friendship.1, friendship.2, friendship.3) %>%
  #change into a data frame
  as_tibble(rownames = "student") %>%
  #add wave indicator
  mutate(wave = c( rep("t1", 160), rep("t2", 160), rep("t3", 160))) %>%
  # stack
  pivot_longer(s001:s160, names_to = "nominated", values_to = "nomination" ) %>%
  # drop nomination score 0 and 10
  filter(nomination %in% c(1, 2))
# add friendship nominations
GlasgowFriends <- friendships %>%
  # add rank number per student
  group_by(wave, student) %>%
  # best friends (coded 1) as first nomination(s)
  arrange(nomination, .by_group = TRUE) %>%
  mutate( constant = 1, nominnr = cumsum(constant)) %>%
  # delete superfluous variables
  select(-nomination, -constant) %>%
  # spread
  pivot_wider( names_from = nominnr, names_prefix = "friend_",  values_from = nominated) %>%
  # add to base file
  full_join(GlasgowFriends, by = c("student", "wave")) %>%
  # reorder variables (and drop friendships)
  select(student, burrough:romantic, wave:friend_6) %>%
  ungroup()
# add best friend (if any) with first and last wave
GlasgowFriends <- friendships %>%
  #select best friends
  filter(nomination == 1) %>%
  #get first and last wave of best friendship
  group_by(student, nominated) %>%
  summarise(from = min(wave), to = max(wave)) %>% 
  #stack
  pivot_longer(from:to, names_to = "bfperiod", values_to = "bfwave" ) %>%
  # add to base file
  full_join(GlasgowFriends, by = "student") %>%
  # reorder and rename
  select(student, burrough:friend_6, bestfriend = nominated, bfperiod, bfwave)
#cleanup
rm(friendship.1, friendship.2, friendship.3, friendships)

# save as .RData for inclusion in the package
save(GlasgowFriends, file = "GlasgowFriends.RData")
