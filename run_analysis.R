## first I verified my repositoty
getwd()
## I made the download and the unzip action outside R and verified its existence
file.exists("UCI HAR Dataset")

## R instruction : You should create one R script called run_analysis.R 
## that does the following.  
        ## Step 1: Merges the training and the test sets to create one data set.
        ## Step 2: Extracts only the measurements on the mean and standard deviation
        ## for each measurement. 
        ## Step 3: Uses descriptive activity names to name the activities in the data set.
        ## Step 4: Appropriately labels the data set with descriptive variable names. 
        ## Step 5: From the data set in step 4, creates a second, independent tidy data 
        ## set with the average of each variable for each activity and each subject.

## Inside the file UCI HAR Dataset, we have other 2 files, test and train
## The first step asks for merge both, but first we need to read all the data
## Let's start with the test files
x_test <- read.table("C:/Users/Gabriella Regina/Documents/DirectoryR/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("C:/Users/Gabriella Regina/Documents/DirectoryR/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("C:/Users/Gabriella Regina/Documents/DirectoryR/UCI HAR Dataset/test/subject_test.txt")

## Now let's read the train files
x_train <- read.table("C:/Users/Gabriella Regina/Documents/DirectoryR/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("C:/Users/Gabriella Regina/Documents/DirectoryR/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("C:/Users/Gabriella Regina/Documents/DirectoryR/UCI HAR Dataset/train/subject_train.txt")

## We also need to read the features file and the activity labels
features <- read.table("C:/Users/Gabriella Regina/Documents/DirectoryR/UCI HAR Dataset/features.txt")
activity_labels <- read.table("C:/Users/Gabriella Regina/Documents/DirectoryR/UCI HAR Dataset/activity_labels.txt")

## STEP 1
## Naming the columns
colnames(x_train) <- features[,2]
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activity_labels) <- c('activityId','activityType')

## Now we merge the data by X, Y and Subject
Merged_train <- cbind(y_train, subject_train, x_train)
Merged_test <- cbind(y_test, subject_test, x_test)
## Merge it all
All_Merged <- rbind(Merged_train, Merged_test)

##Let's see the dim of All_Merged
dim(All_Merged)
# [1] 10299   563

## STEP 2
## The next step is: "Extracts only the measurements on the mean and standard 
## deviation for each measurement."
## Read the column names
colNames <- colnames(All_Merged)

## Let's create a vector for the ID, mean and SD
mean_SD <- (grepl("activityId" , colNames) | 
                         grepl("subjectId" , colNames) | 
                         grepl("mean.." , colNames) | 
                         grepl("std.." , colNames) 
)

## Defining a subset
set_Mean_SD <- All_Merged[ , mean_SD == TRUE]

## STEP 3
## Uses descriptive activity names to name the activities in the data set
Activity_Names <- merge(set_Mean_SD, activity_labels, by = "activityId", 
                        all.x = TRUE)

## STEP 4 
## I chose to name the labels during the other steps, because it was
## easier to organize the data for me
## See:
        ## Merged_train <- cbind(y_train, subject_train, x_train)
        ## Merged_test <- cbind(y_test, subject_test, x_test)
        ## All_Merged <- rbind(Merged_train, Merged_test)

        ## mean_SD <- (grepl("activityId" , colNames) | 
                ## grepl("subjectId" , colNames) | 
                ## grepl("mean.." , colNames) | 
                ## grepl("std.." , colNames) 
        ## )

        ## set_Mean_SD <- All_Merged[ , mean_SD == TRUE]

## STEP 5 - finally
## From the data set in step 4, creates a second, independent tidy data set with
## the average of each variable for each activity and each subject.
TheLastData <- aggregate(. ~subjectId + activityId, Activity_Names, mean)
TheLastData <- TheLastData[order(TheLastData$subjectId, TheLastData$activityId),]
write.table(TheLastData, "TheLastData.txt", row.name=FALSE)