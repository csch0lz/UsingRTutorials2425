#' Glasgow secondary school students.
#'
#' The data belong to the older of the two student cohorts in the 'Teenage
#' Friends and Lifestyle Study', which were followed over their second, third
#' and fourth year at a secondary school in Glasgow. The study was funded by the
#' chief scientist office of the scottish home and health department under their
#' smoking initiative (grant k/opr/17/8), and was executed by lynn michell and
#' patrick west of the medical research council / medical sociology unit,
#' university of Glasgow. The data have been joined and simplified for
#' practicing purposes.
#'
#' @format A data frame with thirteen variables: 
#' \describe{
#'   \item{student}{respondent ID, as a character string}
#'   \item{age}{respondent age, in years with one decimal digit}
#'   \item{sex}{respondent sex, boy or girl}
#'   \item{smoking_at_home}{any smokers at home, yes or no}
#'   \item{smoking_parents}{smoking by at least one parent, yes or no}
#'   \item{smoking_siblings}{smoking by at least one sibling, yes or no}
#'   \item{wave}{time of observation, starting in February 1995, when the pupils were aged 13, and ending in January 1997}
#'   \item{alcohol}{respondent alcohol consumption: 1 (none), 2 (once or twice a year), 3 (once a month), 4 (once a week) and 5 (more than once a week)}
#'   \item{cannabis}{respondent cannabis consumption: 1 (none), 2 (tried once), 3 (occasional) and 4 (regular)}
#'   \item{tobacco}{respondent tobacco consumption: 1 (none), 2 (occasional) and 3 (regular, i.e. more than once per week)}
#'   \item{money}{respondent's pocket money per month, in British pounds}
#'   \item{romantic}{whether the student had a romantic relation, yes or no}
#'   \item{friendships}{number of friendship nominations received by other respondents}
#' }
"Glasgow"

#' Glasgow secondary school students and their (best) friends.
#'
#' The data derive from the same source as the Glasgow data. 
#' The data have been joined and simplified for practicing purposes.
#' A rough classification according of students according to their home 
#' neighbourhood was derived from the distances among students.
#' This data file is very untidy!
#'
#' @format A data frame with thirteen variables: 
#' \describe{
#'   \item{student}{respondent ID, as a character string}
#'   \item{neighbourhood}{student's home neighbourhood (fake)}
#'   \item{schooldist}{average distance from the neighbourhood to the school (in miles)}
#'   \item{hoodname}{(fake) name of the neighbourhood}
#'   \item{age}{respondent age, in years with one decimal digit}
#'   \item{sex}{respondent sex, boy or girl}
#'   \item{smoking_at_home}{any smokers at home, yes or no}
#'   \item{smoking_parents}{smoking by at least one parent, yes or no}
#'   \item{smoking_siblings}{smoking by at least one sibling, yes or no}
#'   \item{alcohol}{respondent alcohol consumption: 1 (none), 2 (once or twice a year), 3 (once a month), 4 (once a week) and 5 (more than once a week)}
#'   \item{cannabis}{respondent cannabis consumption: 1 (none), 2 (tried once), 3 (occasional) and 4 (regular)}
#'   \item{tobacco}{respondent tobacco consumption: 1 (none), 2 (occasional) and 3 (regular, i.e. more than once per week)}
#'   \item{money}{respondent's pocket money per month, in British pounds}
#'   \item{romantic}{whether the student had a romantic relation, yes or no}
#'   \item{wave}{time of observation, starting in February 1995, when the pupils were aged 13, and ending in January 1997}
#'   \item{friend_1}{code of a first student nominated as a friend by the respondent}
#'   \item{friend_2}{code of a second student nominated as a friend by the respondent}
#'   \item{friend_3}{code of a third student nominated as a friend by the respondent}
#'   \item{friend_4}{code of a fourth student nominated as a friend by the respondent}
#'   \item{friend_5}{code of a fifth student nominated as a friend by the respondent}
#'   \item{friend_6}{code of a sixth student nominated as a friend by the respondent}
#'   \item{bestfriend}{code of a student nominated as a/the best friend by the respondent}
#'   \item{bfperiod}{phase in the period of best friendship}
#'   \item{bfperiod}{wave for the phase in the period of best friendship}
#' }
"GlasgowFriends"

#' Articles on Brexit posted on the (former) Dutch news site nujij.nl.
#' 
#' @format A data frame with eight variables:
#' \describe{
#'   \item{id}{Original article ID}
#'   \item{category}{Type of article (Dutch)}
#'   \item{pubDate}{Post date and time}
#'   \item{title}{Article heading}
#'   \item{text}{Article (body) text}
#'   \item{clicks}{Number of clicks received by the article}
#'   \item{votes}{Number of votes received by the article}
#'   \item{reactions}{Number of reactions posted on the article}
#' }
"Brexit"

#' Subset of variables and observations from the first Friends & Families (MIT) weekly survey.
#' 
#' @format A data frame with ten variables:
#' \describe{
#'   \item{participantID}{Original participant ID}
#'   \item{StartDate}{Date and time the participant started this survey}
#'   \item{EndDate}{Date and time the participant submitted this survey}
#'   \item{To the best of your recollection [...] March 8 - Sad or depressed}{Survey question on participant's mood}
#'   \item{To the best of your recollection [...] March 9 - Sad or depressed}{Survey question on participant's mood}
#'   \item{To the best of your recollection [...] March 10 - Sad or depressed}{Survey question on participant's mood}
#'   \item{To the best of your recollection [...] March 11 - Sad or depressed}{Survey question on participant's mood}
#'   \item{To the best of your recollection [...] March 12 - Sad or depressed}{Survey question on participant's mood}
#'   \item{To the best of your recollection [...] March 13 - Sad or depressed}{Survey question on participant's mood}
#'   \item{To the best of your recollection [...] March 14 - Sad or depressed}{Survey question on participant's mood}
#' }
"surveyweek1"