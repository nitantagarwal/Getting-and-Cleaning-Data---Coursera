#Checking if the directory exits or not
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#reading datasets
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
subj_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subj_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#renaming the column names
colnames(y_train) <- c("Activity_ID")
colnames(y_test) <- c("Activity_ID")
colnames(subj_train) <- c("Subject_ID")
colnames(subj_test) <- c("Subject_ID")

#merging test and train datasets
data1 <- cbind(subj_train, y_train, x_train)
data2 <- cbind(subj_test, y_test, X_test)
merged_data <- rbind(data1, data2)

activity <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./data/UCI HAR Dataset/features.txt")
colnames(activity) <- c("Activity_ID", "Activity_Names")
features[,2] = as.character(features[,2])
features$V2 = gsub('-mean', 'Mean', features$V2)
features$V2 = gsub('-std', 'Std', features$V2)
features$V2 <- gsub('[-()]', '', features$V2)

#getting a dataset with only the required features
features.needed <- grepl(".*Mean.*", features$V2) | grepl(".*Std.*", features$V2)
temp_data <-  merged_data[, 1:2]
temp_data2 <- merged_data[, -(1:2)]
temp_data3 <- temp_data2[, features.needed == TRUE]
colnames(temp_data3) <- features$V2[features.needed == TRUE]
temp_data4 <- cbind(temp_data, temp_data3)
final_data <- merge(activity, temp_data4, by = "Activity_ID")

#creating a dataset with the average of each variable for each activity and each subject.
grouped_data <- group_by(final_data, Subject_ID, Activity_ID)
aggregate_data <- aggregate(. ~Subject_ID + Activity_ID + Activity_Names, grouped_data,mean)


