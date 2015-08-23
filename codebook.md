CodeBook for Getting and Cleaning Data Course
---------------------------------------------------------------
This document describes the variables, the data, and any transformations or work that was performed to clean up the data and generate the *Tidy.txt* file.

##Dataset Used

The data set was obtained from "Human Activity Recognition Using Smartphones Data Set", dowloaded from:

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>. 

##Input Data Set

The dataset includes the following files:

- `features_info.txt`: Shows information about the variables used on the feature vector.
- `features.txt`: List of all features.
- `activity_labels.txt`: Links the class labels with their activity name.
- `train/X_train.txt`: Training set.
- `train/y_train.txt`: Training labels.
- `test/X_test.txt`: Test set.
- `test/y_test.txt`: Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- `train/subject_train.txt`: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- `train/Inertial Signals/total_acc_x_train.txt`: The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
- `train/Inertial Signals/body_acc_x_train.txt`: The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
- `train/Inertial Signals/body_gyro_x_train.txt`: The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

##Transformations

Each input data file is read into a specific variable and the subjects in training and test set data are merged to form `subject`. 
The activities in training and test set data are merged to form `activity`. The features of test and training are merged to form 
`features` and the name of the features are set in `features` from `featureNames`.

Than `features`, `activity` and `subject` are merged to form `completeData` and the indices of columns that contain std or mean, 
activity and subject are taken into `requiredColumns`. The `extractedData` is created with data from columns in `requiredColumns`.

`Activity` column in `extractedData` is updated with descriptive names of activities taken from `activityLabels`. `Activity`
column is expressed as a factor variable. Acronyms in variable names in `extractedData`, like 'Acc', 'Gyro', 'Mag', 't' and 'f'
are replaced with descriptive labels such as 'Accelerometer', 'Gyroscpoe', 'Magnitude', 'Time' and 'Frequency'.

And the `tidyData` is created as a set with average for each activity and subject of `extractedData`. Entries in `tidyData` 
are ordered based on activity and subject and the data in `tidyData` is written into `Tidy.txt`.

##Output Data Set

The output data `Tidy.txt` is a a space-delimited value file. It contains the mean and standard deviation values of the
data contained in the input files. 
