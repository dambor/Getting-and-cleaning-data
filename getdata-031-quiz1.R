# Question 1
# 
# The American Community Survey distributes downloadable data about United States communities. Download the 
# 2006 microdata survey about housing for the state of Idaho using download.file() from here: 
#  
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv 
#
# and load the data into R. The code book, describing the variable names is here: 
#  
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf 
#
# How many properties are worth $1,000,000 or more?

setwd("/Users/damasceno/datascience")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(url=fileUrl, destfile="idaho.csv", mode="w", method="curl")

idaho <- read.csv("idaho.csv")
length(idaho$VAL[!is.na(idaho$VAL) & idaho$VAL==24])

# The answer is 53

# -----------------------------------------------------------------------------------

# Question 2
# 
# Use the data you loaded from Question 1. Consider the variable FES in the code book. Which of the "tidy data" 
# principles does this variable violate?

# -----------------------------------------------------------------------------------

# Question 3
#
# Download the Excel spreadsheet on Natural Gas Aquisition Program here: 
#  
#  https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx 
#
# Read rows 18-23 and columns 7-15 into R and assign the result to a variable called: dat 
#
# What is the value of:
#  sum(dat$Zip*dat$Ext,na.rm=T) 
#
# (original data source: http://catalog.data.gov/dataset/natural-gas-acquisition-program)

setwd("/Users/damasceno/datascience")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(url = fileUrl, destfile = "NGAP.csv", mode = "w", method = "curl")

library(xlsx)
dat <- read.xlsx(file = "NGAP.xlsx", sheetIndex = 1, colIndex = 7:15, startRow = 18, endRow = 23, header = TRUE)
sum(dat$Zip*dat$Ext,na.rm=T) 

# [1] 36534720

# The answer is 36534720

# -----------------------------------------------------------------------------------

# Question 4 
# 
# Read the XML data on Baltimore restaurants from here: 
#  
#   https://d396qusza40orc.cloudfront.net/getdata/data/restaurants.xml 
#
# How many restaurants have zipcode 21231?

library(XML)
library(RCurl)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
xData <- getURL(fileUrl)
doc <- xmlParse(xData)
rootNode <- xmlRoot(doc)
# [1] "response"

xmlName(rootNode)
#   row 
# "row" 

rootNode[[1]][[1]]
# <row _id="1" _uuid="93CACF6F-C8C2-4B87-95A8-8177806D5A6F" _position="1" _address="http://data.baltimorecity.gov/resource/k5ry-ef3g/1">
#  <name>410</name>
#  <zipcode>21206</zipcode>
#  <neighborhood>Frankford</neighborhood>
#  <councildistrict>2</councildistrict>
#  <policedistrict>NORTHEASTERN</policedistrict>
#  <location_1 human_address="{&quot;address&quot;:&quot;4509 BELAIR ROAD&quot;,&quot;city&quot;:&quot;Baltimore&quot;,&quot;state&quot;:&quot;MD&quot;,&quot;zip&quot;:&quot;&quot;}" needs_recoding="true"/>
#  </row> 

zipcode <- xpathSApply(rootNode,"//zipcode",xmlValue)
length(zipcode[zipcode==21231])
# [1] 127

# Answer is 127

# -----------------------------------------------------------------------------------

# Question 5

# The American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() 
# from here: 
#
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv 
#
# using the fread() command load the data into an R object 
# 
# DT 
# 
# Which of the following is the fastest way to calculate the average value of the variable
# 
# pwgtp15 
#
# broken down by sex using the data.table package?

library(data.table)
setwd("/Users/damasceno/datascience")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(url = fileUrl, destfile = "fsspid.csv", mode = "w", method = "curl")
DT <- fread(input = "fsspid.csv", sep = ",")
system.time(DT[,mean(pwgtp15), by=SEX])

system.time(mean(DT[DT$SEX==1,]$pwgtp15)) 
# user  system elapsed 
# 0.039   0.001   0.042 

system.time(mean(DT[DT$SEX==2,]$pwgtp15))
#    user  system elapsed 
# 0.034   0.001   0.036 

system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
# user  system elapsed 
# 0.007   0.000   0.006 

system.time(mean(DT$pwgtp15,by=DT$SEX))
# user  system elapsed 
# 0       0       0 

# system.time(rowMeans(DT)[DT$SEX==1])
# system.time(rowMeans(DT)[DT$SEX==2])
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
# user  system elapsed 
# 0.007   0.000   0.007 

system.time(tapply(DT$pwgtp15,DT$SEX,mean))
# user  system elapsed 
# 0.012   0.000   0.013 

system.time(DT[,mean(pwgtp15),by=SEX])
# user  system elapsed 
# 0.002   0.000   0.001 

