# Run Analysis script for "Getting and Cleaning Data", Coursera
# 2015-06-17
#
# Set environment variables
setwd("~/Documents/WGSN/Personal Development/Coursera - data scientists toolbox/Getting & Cleaning Data/Assignment/UCI HAR dataset")

if(!file.exists("./data")){dir.create("./data")}
fileURL1="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileURL1,destfile="./data/GCD_wk3_q1.csv",method="curl")
data_q1<-read.csv("./data/GCD_wk3_q1.csv",stringsAsFactors=False)

# Libraries to load to accomplish task
library(tidyr)
library(dplyr)

# set working directory. assume at UCI HAR dataset
test_sub <- "./test/subject_test.txt"
test_act <- "./test/y_test.txt"
test_val <- "./test/X_test.txt"
train_sub <- "./train/subject_train.txt"
train_act <- "./train/y_train.txt"
train_val <- "./train/X_train.txt"
val_names <- './features.txt'
act_labels <- "./activity_labels.txt"

df_act_labels <- read.csv2(act_labels, stringsAsFactors=FALSE, header=FALSE)
df_val_names <- read.csv2(val_names, stringsAsFactors=FALSE, header=FALSE,col.names="Measurement")
# remove incorrect "BodyBody", "()", "(", ")", "'","-" 
df_val_names$Measurement<-gsub("\\(\\)","_",df_val_names$Measurement)
df_val_names$Measurement<-gsub("\\(","_",df_val_names$Measurement)
df_val_names$Measurement<-gsub("\\)","_",df_val_names$Measurement)
df_val_names$Measurement<-gsub(",","_",df_val_names$Measurement)
df_val_names$Measurement<-gsub("-","_",df_val_names$Measurement)
df_val_names$Measurement<-gsub("BodyBody","Body",df_val_names$Measurement)
df_val_names$Measurement<-gsub("mean","Mean",df_val_names$Measurement)
df_val_names$Measurement<-gsub("std","Std",df_val_names$Measurement)
df_val_names$Measurement<-gsub("\\_\\_","_",df_val_names$Measurement)

# Load in the files with the correct column names


df_test_sub<-read.csv2(test_sub,stringsAsFactors=FALSE, header=FALSE, col.names="Subject")
df_test_act<-read.csv2(test_act,stringsAsFactors=FALSE, header=FALSE, col.names ="Activity")
df_test_val<-read.csv2(test_val,stringsAsFactors=FALSE,header=FALSE, dec=".",col.names=df_val_names$Measurement)
df_train_sub<-read.csv2(train_sub,stringsAsFactors=FALSE, header=FALSE, col.names="Subject")
df_train_act<-read.csv2(train_act,stringsAsFactors=FALSE, header=FALSE, col.names ="Activity")
df_train_val<-read.csv2(train_val,stringsAsFactors=FALSE,header=FALSE, dec=".",col.names=df_val_names$Measurement)

df_act_labels <- read.csv2(act_labels, stringsAsFactors=FALSE, header=FALSE)

# Tidy up the Measurements - df_val_names
# Remove incorrect "BodyBody" in variable names 516:554
df_val_names<-df_val_names %>% separate(Measurement,c("Prefix","Measurement"),sep=" ")  %>% select(Measurement)


# Substitute numbered values in activity with the names from 
# activity_labels.txt file.
# Tidy up variable names first. 
# Split the variable V1 into two - "Prefix" and "Activity".
df_act_labels<-df_act_labels %>% separate(V1,c("Prefix","Activity"),sep=" ") 
y<-nrow(df_act_labels)
# Now loop through the df_act_labels performing the substitutions:
# Prefix           Activity
# 1      1            WALKING
# 2      2   WALKING_UPSTAIRS
# 3      3 WALKING_DOWNSTAIRS
# 4      4            SITTING
# 5      5           STANDING
# 6      6             LAYING
# First for the test activities
for (i in 1:nrow(df_act_labels)){
        df_test_act$Activity<-gsub(df_act_labels[[i,1]],df_act_labels[[i,2]],df_test_act$Activity)
}
# And then for the training activities
for (i in 1:nrow(df_act_labels)){
        df_train_act$Activity<-gsub(df_act_labels[[i,1]],df_act_labels[[i,2]],df_train_act$Activity)
}


# 1. Merge the training and test data sets
#    - load each of the datasets 

tmp<-cbind(df_test_sub,df_test_act)
# Add a column which notes that this are the Test data
tmp$DataSet<-"Test"
tmp<-cbind(tmp,df_test_val)
# Add a column which notes that this are the Train data
tmp2<-cbind(df_train_sub,df_train_act)
tmp2$DataSet<-"Train"
tmp2<-cbind(tmp2,df_train_val)
# Now concatenate the rows 
tmp3<-rbind(tmp,tmp2)

# 


# 2. Extracts the mean and std deviation for each measurement
#    - keep only the 'mean' and 'std' variables from features.txt (column names for x)



# 3. Uses descriptive activity names to name the activities in the data set - 
### DONE




# 4. Appropriately labels the data set with descriptive variable names. 


# 5. From the data set in step 4, creates a second, independent tidy data set
#    with the average of each variable for each activity and each subject.
#    - dplyr might not be best for this. Try aggregate() function.
#    - or summarize_each()
