#1. Raw data
#2. Tidy data set
#3. Code book containing variable descriptions and values in the tidy data set
#4. Recipe to get from raw data to processed data

#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Packages loaded during this course include dplyr, read.table

#Get file from url and unzip
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="dataFiles.zip")
dateDownloaded<-date()
unzip(zipfile = "dataFiles.zip")

#fread is used instead of read.table for efficiency
#Need activityLabels and features put into tables with columns labelled (opening in Notepad++ makes columns obvious)
#featuresSub is created by matching only featureNames with mean or std, () escaped
#measurements pulls out those subsetted featureNames and then () is replaced with nothing
activityLabels <- fread("UCI HAR Dataset/activity_labels.txt",col.names = c("classLabels", "activityName"))
features <- fread("UCI HAR Dataset/features.txt", col.names = c("index", "featureNames"))
featuresSub <- grep("(mean|std)\\(\\)", features[, featureNames])
measurements <- features[featuresSub, featureNames]
measurements <- gsub('[()]', '', measurements)

#Need training data and test data loaded into workspace, and then bound together

train <- fread("UCI HAR Dataset/train/X_train.txt")[, featuresSub, with=FALSE]
data.table::setnames(train, colnames(train), measurements)
trainActivities <- fread( ("UCI HAR Dataset/train/Y_train.txt"),col.names = c("Activity"))
trainSubjects <- fread(("UCI HAR Dataset/train/subject_train.txt"), col.names = c("SubjectNum"))
train <- cbind(trainSubjects, trainActivities, train)
test <- fread("UCI HAR Dataset/test/X_test.txt")[, featuresSub, with=FALSE]
data.table::setnames(test, colnames(test), measurements)
testActivities <- fread("UCI HAR Dataset/test/Y_test.txt", col.names = c("Activity"))
testSubjects <- fread("UCI HAR Dataset/test/subject_test.txt", col.names = c("SubjectNum"))
test <- cbind(testSubjects, testActivities, test)

# Merge datasets together, change Activity to actual name, uses melt to convert to tidy data table, then uses dcast to find means of tidy data by SubjectNum and Activity
combined <- rbind(train, test)
combined[["Activity"]] <- factor(combined[, Activity],levels = activityLabels[["classLabels"]],labels = activityLabels[["activityName"]])
combined[["SubjectNum"]] <- as.factor(combined[, SubjectNum])
combined <- reshape2::melt(data = combined, id = c("SubjectNum", "Activity"))
combined <- reshape2::dcast(data = combined, SubjectNum + Activity ~ variable, fun.aggregate = mean)
data.table::fwrite(x = combined, file = "tidyData.csv", quote = FALSE)