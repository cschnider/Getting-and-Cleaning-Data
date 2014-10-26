##set WD
setwd("~/R/Coursera/04 Getting and Cleaning Data/Assessment1")

##Download File
file_name<-"Dataset.zip"
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists(file_name)) {
          download.file(url,file_name)
}

dateDownloaded<-date()
dateDownloaded

##unzip
for (i in dir(pattern=".zip$"))
          unzip(i)

##Read Column names
col_names<-as.vector(read.csv("UCI HAR Dataset/features.txt", header=FALSE, sep = ""))
col_names<-as.vector(col_names[,2])

##Read TEST
test<-read.csv("UCI HAR Dataset/test/X_test.txt", header=FALSE, sep = "")
test_subject<-read.csv("UCI HAR Dataset/test/subject_test.txt", header=FALSE, sep = "")
test_label<-read.csv("UCI HAR Dataset/test/y_test.txt", header=FALSE, sep = "")

colnames(test)<-col_names
colnames(test_subject)<-c("Subject")
colnames(test_label)<-c("Activity")


##Read TRAIN
train<-read.csv("UCI HAR Dataset/train/X_train.txt", header=FALSE, sep = "")
train_subject<-read.csv("UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep = "")
train_label<-read.csv("UCI HAR Dataset/train/y_train.txt", header=FALSE, sep = "")

colnames(train)<-col_names
colnames(train_subject)<-c("Subject")
colnames(train_label)<-c("Activity")

##Combine TEST and TRAIN --> FULL
data_full<-rbind(test, train)
subject_full<-rbind(test_subject, train_subject)
label_full<-rbind(test_label, train_label)

##Extracts only the measurements on the mean and standard deviation for each measurement. 

# cols corresponding to means 
col_names_Mean = grep("mean", col_names)
# cols corresponding to Std
col_names_Std = grep("std", col_names)

# Extract Measurements
data_full_red<-data_full[,unique(c(col_names_Mean,col_names_Std))]


##Uses descriptive activity names to name the activities in the data set
activity_labels<-read.csv("UCI HAR Dataset/activity_labels.txt", header=FALSE, sep = "")

label_full$Activity<-factor(label_full$Activity,activity_labels[,1],
labels = activity_labels[,2])

##creates a second, independent tidy data set with the average of each variable for each activity and each subject.
data_full_red2<-cbind(label_full,cbind(subject_full,data_full_red))

data_full_red2_melt <- melt(data_full_red2, id=c("Subject", "Activity"))
data_tidy <- dcast(data_full_red2_melt, Activity + Subject ~ variable, mean)

write.csv(data_tidy, "activity_subject_means.txt",row.names=FALSE)
