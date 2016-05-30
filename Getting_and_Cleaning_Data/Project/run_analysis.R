#Environment setting
library(plyr)
nameProj <- "Project"
destProj <-paste ("./" , nameProj ,"/", sep = "")
dataDir <-paste(destProj, "UCI HAR Dataset/", sep="")


if(!file.exists(nameProj))
{
  dir.create(nameProj)
}
#LOAD DATA
if(!file.exists( paste( destProj,"Project.zip", sep = "") ))
{
  zipProjectUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  zipProject <- paste( destProj,"Project.zip", sep = "") 
  download.file(zipProjectUrl,zipProject)
  unzip(paste( destProj,"Project.zip", sep = ""), exdir = destProj )
}

#READ DATA

#INFO
activity_label <- read.table(paste(dataDir,"activity_labels.txt", sep = ""))
features <- read.table(paste(dataDir, "features.txt", sep = ""), header = FALSE)

featuresMeanStdIndex <-grep("mean|std",features$V2)

activity_label <- activity_label$V2
activity_label <- tolower(activity_label)
activity_label <- sub("_", " ", activity_label)



##TRAINING
trainDir <- paste(dataDir, "train/", sep = "")
y_train <- read.table(paste(trainDir, "Y_train.txt", sep = ""), header= FALSE)
names(y_train) <- "activity"

x_train <- read.table(paste(trainDir, "X_train.txt", sep = ""),header= FALSE)
names(x_train) <- features$V2 
x_train<- x_train[featuresMeanStdIndex]

subject_train <-  read.table(paste(trainDir, "subject_train.txt", sep = ""),header= FALSE)
names(subject_train)<- "subject"

train <- cbind(subject_train,y_train,x_train)

##TEST
testDir <- paste(dataDir, "test/", sep = "")

y_test <- read.table(paste(testDir, "Y_test.txt", sep = ""),header= FALSE)
names(y_test) <- "activity"

x_test <- read.table(paste(testDir, "X_test.txt", sep = ""),header= FALSE)
names(x_test) <- features$V2 
x_test <- x_test[featuresMeanStdIndex]

subject_test <-  read.table(paste(testDir, "subject_test.txt", sep = ""),header= FALSE)
names(subject_test)<- "subject"

test <- cbind(subject_test,y_test,x_test)



#TEST + TRAINING

data<-rbind(test,train)

data$activity <- mapvalues(data$activity, from= levels(factor(data$activity)),to = activity_label) 


dataMean <- aggregate(data, list(data$subject, data$activity), mean)

# clean up the columns and column names from a result of aggregating
dataMean$subject <- NULL; dataMean$activity <- NULL
names(dataMean)[1] <- "subject"; names(dataMean)[2] <- "activity"

write.table(file = "activitySubjectAverage.txt", x = dataMean, row.names = FALSE)