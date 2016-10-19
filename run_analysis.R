# Week 4 Peer Reviewed Assignment
# analysis of run data from Galaxy S
# shared on github
#
# Note: Responses to the required Tasks for this assignment are not in order.
# A comment preceeds the final statement that satisfies each Task.

library(dplyr)
library(tidyr)
library(stringr)

# set the file and download paths
setwd("~/Projects/datasciencecoursera/Class 4 Tidy Data")
urlpath <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filepath <- "~/Projects/datasciencecoursera/Class 4 Tidy Data/UCI HAR Dataset/"

# this code only run once to down load the zip file. 
# temp <- tempfile()
# download.file(urlpath,temp,method = "curl")
# unlink(temp)

## Train data
## prepare training data sets
trainfilepath <- paste0(filepath,"train/")
setwd(trainfilepath)

# read in train data
trainfile <- read.table("X_train.txt")
train_data <- tbl_df(trainfile)
train_data <- mutate(train_data,dataset = "train")

# Add the y-train 'labels' to the train data (read in and then column bind)
train_labels <- read.table("y_train.txt", col.names = "label" )
train <- bind_cols(train_data,train_labels)

# add subject numbers to the train data (read in and then column bind)
train_subjects <- read.table("subject_train.txt", col.names = "subject", header = FALSE )
train <- bind_cols(train,train_subjects)

## Test data
## prepare test data set
testfilepath <- paste0(filepath,"test/")
setwd(testfilepath)

#read in train data
testfile <- read.table("X_test.txt")
test_data <- tbl_df(testfile)

# add indicator data is from testing data set
test_data <- mutate(test_data,dataset = "test")
dim(test_data)

# Add the y-test 'labels' to the test data (read in and then column bind)
test_labels <- read.table("y_test.txt", col.names = "label")
test <- bind_cols(test_data,test_labels)

# add subject numbers to the test data (read in and then column bind)
test_subjects <- read.table("subject_test.txt", col.names = "subject", header = FALSE )
test <- bind_cols(test,test_subjects)


### Task #1 - Merges the training and the test sets to create one data set.
## use rowbind to combine train and test data sets - includes labels
combined_data <- bind_rows(train,test)

# reorganize table so columns V1:V561 are factors
reshaped_data<-combined_data %>% gather(interm,value,V1:V561)

# create data frame of 'features' to be added to reshaped_data
setwd(filepath)
features <- read.table("features.txt", col.names = c("interm","measurement"), colClasses = "character")
features <- tbl_df(features)
features <- mutate(features, interm = paste0("V",interm))
# join reshaped_data and features data sets by old 'V1' column names...
data <- left_join(reshaped_data,features, by = "interm")
data <- select(data,-interm)

### Task #4 - Appropriately labels the data set with descriptive variable names.
data <- separate(data,measurement, into = c("measure","stat","axis"),sep = "-", fill = "right")

### Task # 3 - Uses descriptive activity names to name the activities in the data set
# read in activity file data
setwd(filepath)
activity <- read.table("activity_labels.txt", header = FALSE, col.names = c("label","activity"))
activity <- tbl_df(activity)
# join data and activity tables - complete dataset
complete_data <- left_join(data,activity, by = "label")
complete_data <- select(complete_data,-label)

### Task #2. Extracts only the measurements on the mean and standard deviation for each measurement.
mean_stdev_tidy_data <- filter(complete_data,stat == "mean()" | stat == "std()")

### Task #5. From the data set in step 4, creates a second, independent tidy data set with the 
### average of each variable for each activity and each subject.
avg_response_activity_subject <- group_by(mean_stdev_tidy_data, activity, subject, measure, stat, axis)
avg_response_activity_subject <- summarize(avg_response_activity_subject, avg_val = mean(value))

# export tidy data to local drive as txt.
export_path <- paste0(filepath,"wk4_avg_response_activity_subject.txt")
write.table(avg_response_activity_subject, export_path, sep="\ ", row.names = FALSE)
