
###Getting and Cleaning Data Project
Laura Snyder

## Per directions from Coursera, I have created one R script called run_analysis.R that does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Packages loaded during this course and used for this project include dplyr, read.table. Data was downloaded from the url given, and unzipped.
Data available at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
There were 2 folders (test, train) and 4 files (activity>labels.txt,features.txt,features_info.txt,README.txt)imported.
Files were converted into appropriate data tables for ease of manipulation.
Test and training data were combined in a single data talbe named 'combined.'
'combined' only contains measures on the mean and standard deviation measurements collected on test and trainning data.
The 6 activities were appropriately labeled in 'combined.'
Final data set has descriptive variable names.
Finally using melt to create tidy data, then dcast to find means of Activity/Subject groups, create a final independent tidy data set with means.

