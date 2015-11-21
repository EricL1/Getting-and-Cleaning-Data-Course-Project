## Read in data

ActivityTest <- read.table("./UCI HAR Dataset/test/Y_test.txt")
ActivityTrain <- read.table("./UCI HAR Dataset/train/Y_train.txt")
SubjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
SubjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
FeaturesTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
FeaturesTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")

## Concatenate the data table by rows

Subject <- rbind(SubjectTrain, SubjectTest)
Activity <- rbind(ActivityTrain, ActivityTest)
Features <- rbind(FeaturesTrain, FeaturesTest)

## Set names to variables

colnames(Subject) <- c("subject")
colnames(Activity) <- c("activity")
FeaturesNames <- read.table("./UCI HAR Dataset/features.txt")
names(Features) <- FeaturesNames$V2

## Merge columns to get the data frame Data for all data

Data <- cbind(Features, Subject, Activity)

## Extract variables for mean & std
FeaturesNamessubset <- FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]

## Extract data for mean & std
selectedNames <- c(as.character(FeaturesNamessubset), "subject", "activity" )
Data <- subset(Data,select=selectedNames)

## read in activity names & label activities in the dataset
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
Data$activity <- as.factor(Data$activity)
levels(Data$activity) <- activityLabels$V2

## label the variables with descriptive names

colnames(Data) <- gsub("^t", "time", colnames(Data))
colnames(Data) <- gsub("^f", "frequency", colnames(Data))
colnames(Data) <- gsub("Acc", "Accelerometer", colnames(Data))
colnames(Data) <- gsub("Gyro", "Gyroscope", colnames(Data))
colnames(Data) <- gsub("Mag", "Magnitude", colnames(Data))
colnames(Data) <- gsub("BodyBody", "Body", colnames(Data))

library(plyr);
Data2 <- aggregate(. ~subject + activity, Data, mean)
Data2 <- Data2[order(Data2$subject,Data2$activity),]
write.csv(Data2, file = "tidydata.csv")
write.table(Data2, file = "tidydata.txt",row.name=FALSE)



















