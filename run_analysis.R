##1.Merges the training and the test sets to create one data set
setwd("/Users/mckayla/Desktop/UCI HAR Dataset")
trainx <- read.table("./train/X_train.txt")
trainy <- read.table("./train/y_train.txt")
trainsub <- read.table("./train/subject_train.txt")

testx <- read.table("./test/X_test.txt")
testy <- read.table("./test/y_test.txt")
testsub <- read.table("./test/subject_test.txt")

train <- cbind(trainsub,trainy,trainx)
test <- cbind(testsub,testy,testx)
alldata <- rbind(train,test)
##2.Extracts only the measurements on the mean and standard deviation for each measurement
feature <- read.table("./features.txt",stringsAsFactors = FALSE)[,2]
featureIndex <- grep(("mean|std"), feature)
extractdata <- alldata[, c(1, 2, featureIndex+2)]
colnames(extractdata) <- c("subject", "activity", feature[featureIndex])

##3.Uses descriptive activity names to name the activities in the data set
activitylabels <- read.table("./activity_labels.txt")
extractdata$activity <- factor(extractdata$activity, levels = activitylabels[,1], labels = activitylabels[,2])

##4.Appropriately labels the data set with descriptive variable names.
names(extractdata) <- gsub("\\()", "", names(extractdata))
names(extractdata) <- gsub("^t", "time", names(extractdata))
names(extractdata) <- gsub("^f", "frequence", names(extractdata))
names(extractdata) <- gsub("-mean", "Mean", names(extractdata))
names(extractdata) <- gsub("-std", "Std", names(extractdata))

##5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
averagedata <- extractdata %>%
        group_by(subject, activity) %>%
        summarise_each(funs(mean))

write.table(averagedata, "./Averagedata.txt",row.name=FALSE)

