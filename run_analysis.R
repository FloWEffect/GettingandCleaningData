## run_analysis script

# Download file and unzip in working directory and only do so if the file does not exist already

if (!file.exists("ucidat.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "ucidat.zip")
  if(!file.exists("UCI HAR Dataset")){unzip("ucidat.zip")}
  }

# READ all necessary files
# I tend to import all colclasses as "character" since I made some bad experiences with large integers and character 
# tends to keep the data intact. I'll usually reformat later as needed.

fullfilename <- list.files(c("UCI HAR Dataset/test", "UCI HAR Dataset/train"), pattern="*.txt", full.names = TRUE)
filenames <- gsub("*.txt", "", basename(fullfilename))
data_names <- gsub("[.]txt", "", filenames) 
for(i in 1:length(fullfilename)) {assign(data_names[i], fread(fullfilename[i], colClasses = "character"))}

features <- fread("UCI HAR Dataset/features.txt", colClasses = "character")
activity_labels <- fread("UCI HAR Dataset/activity_labels.txt", colClasses = "character")

# Assign the colnames of the features file to the data

colnames(X_test) <- features$V2
colnames(X_train) <- features$V2

# Bind together the Activities and SubjectIDs to the data and rename them

X_test <- cbind(y_test$V1, X_test)
X_train <- cbind(y_train$V1, X_train)

X_test <- rename(X_test, Activity = V1)
X_train <- rename(X_train, Activity = V1)

X_test <- cbind(subject_test$V1, X_test)
X_train <- cbind(subject_train$V1, X_train)

X_test <- rename(X_test, SubjectID = V1)
X_train <- rename(X_train, SubjectID = V1)

# Bind together the test and training data and select only mean and std columns

alldat <- rbind(X_test,X_train)
meanstdonly <- dplyr::select(alldat, matches("mean\\(\\)|std\\(\\)|SubjectID|Activity")) 
# I had to use "dplyr::" here because the MASS package that is loaded with my other packages messes with the select function

# Change activity labels to appropiate names

meanstdonly$Activity %>% mapvalues(activity_labels$V1, activity_labels$V2) %>% gsub(pattern = "_", replacement = " ") -> meanstdonly$Activity

# Relabeling the date to make i more accessible

names(meanstdonly) <- gsub("Acc", "Accelerator", names(meanstdonly))
names(meanstdonly) <- gsub("Mag", "Magnitude", names(meanstdonly))
names(meanstdonly) <- gsub("Gyro", "Gyroscope", names(meanstdonly))
names(meanstdonly) <- gsub("BodyBody", "Body", names(meanstdonly))
names(meanstdonly) <- gsub("^t", "Time", names(meanstdonly))
names(meanstdonly) <- gsub("^f", "Frequency", names(meanstdonly))
names(meanstdonly) <- gsub("\\(\\)", "", names(meanstdonly))

# Convert all required columns back to numeric

meanstdonly <- meanstdonly[, lapply(.SD,as.numeric), by = "SubjectID,Activity"]

# Create the mean per SubjectId and Activity

TidyMeans <- meanstdonly[, lapply(.SD,mean), by = "SubjectID,Activity"]

# Arrange it by SubjectID and Activity

TidyMeans <- arrange(TidyMeans, as.numeric(SubjectID), Activity)

# And Finally write the whole stuff to a file

write.table(TidyMeans, file = "TidyMeans.txt", row.names = FALSE)