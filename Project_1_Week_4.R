#downloading data and loading tidyverse package
#getting data and assigning variables
library(tidyverse)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              "my_data.zip",
              "curl")
my_data <-unzip('my_data.zip')
head(my_data)

train_x <- read.table('./UCI HAR Dataset/train/X_train.txt')
train_activity <- read.csv('./UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
train_subject <- read.csv('./UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ')
features <- read.csv('./UCI HAR Dataset/features.txt', header = FALSE, sep = ' ')
features <- as.character(features[,2])
data_train <-  data.frame(train_subject, train_activity, train_x)
names(data_train) <- c(c('subject', 'activity'), features)
test_x <- read.table('./UCI HAR Dataset/test/X_test.txt')
test_activity <- read.csv('./UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
test_subject <- read.csv('./UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')
data_test <-  data.frame(test_subject,test_activity, test_x)
names(data_test) <- c(c('subject', 'activity'), features)


### Part 1: Merges the training and the test sets to create one data set.
data_1<-rbind(data_train,data_test)
head(data_1)

###Part 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
mean_std_position<-grep("std|mean",data_1)
std_mean_ex_data<- data_1[,mean_std_position]
data_2<-rbind(data_1,std_mean_ex_data)
head(data_2)

###Part 3: Uses descriptive activity names to name the activities in the data set
activity_lab <- read.table("./UCI HAR Dataset/activity_labels.txt", header = F)
activity_lab <- as.character(activity_lab[,2])
data_2$activity <- activity_lab[data_2$activity]
head(data_2$activity)

###Part 4: Appropriately labels the data set with descriptive variable names. 
names(data_2)<-gsub("Acc", "Accelerometer", names(data_2))
names(data_2)<-gsub("angle", "Angle", names(data_2))
names(data_2)<-gsub("Gyro", "Gyroscope", names(data_2))
names(data_2)<-gsub("^f", "Frequency", names(data_2))
names(data_2)<-gsub("tBody", "TimeBody", names(data_2))
names(data_2)<-gsub("BodyBody", "Body", names(data_2))
names(data_2)<-gsub("^t", "Time", names(data_2))
names(data_2)<-gsub("-mean()", "Mean", names(data_2))
names(data_2)<-gsub("-std()", "STD", names(data_2))
names(data_2)<-gsub("gravity", "Gravity", names(data_2))

### Part 5: From the data set in step 4,
# creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject.
data_3 <- data_2 %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))
head(data_3)
write.csv(data_3, "Getting_and_cleaning_data_project_1.csv", rownames= F, sep = ",")

