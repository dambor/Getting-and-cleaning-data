### Getting and Cleaning Data final course project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

#### Loading the data.table and dplyr packages
library(data.table)
library(dplyr)

setwd("/Users/damasceno/Coursera/Data-Science/Getting-and-cleaning-data/Project/UCI HAR Dataset")

#### Read supporting metadata
featureNames <- read.table("features.txt")
activityLabels <- read.table("activity_labels.txt", header = FALSE)

### 1. Merges the training and the test sets to create one data set.

#### Read training data
subjectTrain <- read.table("train/subject_train.txt", header = FALSE)
activityTrain <- read.table("train/y_train.txt", header = FALSE)
featuresTrain <- read.table("train/X_train.txt", header = FALSE)

#### Read test data
subjectTest <- read.table("test/subject_test.txt", header = FALSE)
activityTest <- read.table("test/y_test.txt", header = FALSE)
featuresTest <- read.table("test/X_test.txt", header = FALSE)

#### Combine the respective data in training and test data sets
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)

#### Naming the columns
colnames(features) <- t(featureNames[2])

#### Merge the data
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
completeData <- cbind(features,activity,subject)

### 2. Extracts only the measurements on the mean and standard deviation for each measurement

columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)
requiredColumns <- c(columnsWithMeanSTD, 562, 563)
dim(completeData)
extractedData <- completeData[,requiredColumns]
dim(extractedData)

### 3. Uses descriptive activity names to name the activities in the data set

extractedData$Activity <- as.character(extractedData$Activity)
for (i in 1:6){
  extractedData$Activity[extractedData$Activity == i] <- as.character(activityLabels[i,2])
}
extractedData$Activity <- as.factor(extractedData$Activity)

### 4. Appropriately labels the data set with descriptive variable names

names(extractedData)

#### Replacing the names by descriptive variable names

names(extractedData)<-gsub("Acc", "Accelerometer", names(extractedData))
names(extractedData)<-gsub("Gyro", "Gyroscope", names(extractedData))
names(extractedData)<-gsub("BodyBody", "Body", names(extractedData))
names(extractedData)<-gsub("Mag", "Magnitude", names(extractedData))
names(extractedData)<-gsub("^t", "Time", names(extractedData))
names(extractedData)<-gsub("^f", "Frequency", names(extractedData))
names(extractedData)<-gsub("tBody", "TimeBody", names(extractedData))
names(extractedData)<-gsub("-mean()", "Mean", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-std()", "STD", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-freq()", "Frequency", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("angle", "Angle", names(extractedData))
names(extractedData)<-gsub("gravity", "Gravity", names(extractedData))

#### Printing the updated names

names(extractedData)

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

extractedData$Subject <- as.factor(extractedData$Subject)
extractedData <- data.table(extractedData)

#### Creating the Tidy.txt file
tidyData <- aggregate(. ~Subject + Activity, extractedData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)
