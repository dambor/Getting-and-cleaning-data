## Question 1
## 
## Register an application with the Github API here https://github.com/settings/applications. 
## Access the API to get information on your instructors repositories (hint: this is the url 
## you want "https://api.github.com/users/jtleek/repos"). Use this data to find the time that 
## the datasharing repo was created. What time was it created? This tutorial may be useful 
## (https://github.com/hadley/httr/blob/master/demo/oauth2-github.r). 
## You may also need to run the code in the base R package and not R studio.

library(httr)
oauth_endpoints("github")
myapp <- oauth_app("github",
                   key = "xxxxxxxxxxxxxxx",
                   secret = "xxxxxxxxxxxxxxxxxxxxxxxxxx")
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
dat <- content(req)

json <- jsonlite::fromJSON(toJSON(dat))
names(json)
json$created_at[json$name=="datasharing"]

## Question 2
## The sqldf package allows for execution of SQL commands on R data frames. We will use the 
## sqldf package to practice the queries we might send with the dbSendQuery command in RMySQL. 
## Download the American Community Survey data and load it into an R object called
## acs
##
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv 
##
## Which of the following commands will select only the data for the probability weights pwgtp1 
## with ages less than 50?

setwd("/Users/damasceno/Coursera/Data-Science/Getting-and-cleaning-data/quiz2")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(url=fileUrl, destfile="survey.csv", mode="w", method="curl")
acs <- data.table(read.csv("survey.csv"))
query1 <- sqldf("select pwgtp1 from acs where AGEP < 50")
query2 <- sqldf("select pwgtp1 from acs")  ## NO
query3 <- sqldf("select * from acs where AGEP < 50 and pwgtp1")  ## NO
query4 <- sqldf("select * from acs where AGEP < 50")  ## NO
identical(query3, query4)

## Question 3
## Using the same data frame you created in the previous problem, what is the equivalent 
## function to unique(acs$AGEP)

gold <- unique(acs$AGEP)
query1 <- sqldf("select distinct AGEP from acs")
query2 <- sqldf("select AGEP where unique from acs")
query3 <- sqldf("select unique * from acs")
query4 <- sqldf("select unique AGEP from acs")
identical(gold, query1)
identical(gold, query2)
identical(gold, query3)
identical(gold, query4)

## Question 4
## How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page: 
##  
##  http://biostat.jhsph.edu/~jleek/contact.html 
##
## (Hint: the nchar() function in R may be helpful)

connection <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(connection)
close(connection)
c(nchar(htmlCode[10]), nchar(htmlCode[20]), nchar(htmlCode[30]), nchar(htmlCode[100]))

require(httr)
require(XML)
htmlCode <- GET("http://biostat.jhsph.edu/~jleek/contact.html")
content <- content(htmlCode, as="text")
htmlParsed <- htmlParse(content, asText=TRUE)
xpathSApply(htmlParsed, "//title", xmlValue)

## Question 5
## Read this data set into R and report the sum of the numbers in the fourth of the nine columns. 
##
## https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for 
##
## Original source of the data: http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for 
##
## (Hint this is a fixed width file format)

x <- read.fwf(
  file=url("http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for"),
  skip=4,
  widths=c(12, 7,4, 9,4, 9,4, 9,4))
head(x)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
lines <- readLines(url, n=10)
w <- c(1, 9, 5, 4, 1, 3, 5, 4, 1, 3, 5, 4, 1, 3, 5, 4, 1, 3)
colNames <- c("filler", "week", "filler", "sstNino12", "filler", "sstaNino12", "filler", "sstNino3", "filler", "sstaNino3", "filler", "sstNino34", "filler", "sstaNino34", "filler", "sstNino4", "filler", "sstaNino4")
d <- read.fwf(url, w, header=FALSE, skip=4, col.names=colNames)
d <- d[, grep("^[^filler]", names(d))]
sum(d[, 4])