##Get Data
if(!file.exists("./data")){dir.create("./data")}
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL,destfile="./data/Dataset.zip",method = "curl")
unzip(zipfile="./data/Dataset.zip", exdir = "./data")
refpath <- file.path("./data", "UCI Har Dataset")
files<-list.files(refpath, recursive = TRUE)
files

##Read files
datTest <- read.table(file.path(refpath, "test", "y_test.txt"), header = FALSE)
datTrain <- read.table(file.path(refpath, "train", "y_train.txt"), header = FALSE)
datSubjTest <- read.table(file.path(refpath, "test", "subject_test.txt"), header = FALSE)
datSubjTrain <- read.table(file.path(refpath, "train", "subject_train.txt"), header = FALSE)
datFeatTest <- read.table(file.path(refpath, "test", "x_test.txt"), header = FALSE)
datFeatTrain <- read.table(file.path(refpath, "train", "x_train.txt"), header = FALSE)

## Merge Tables
datSubj <- rbind(datSubjTrain, datSubjTest)
datAct <- rbind(datTrain, datTest)
datFeat <- rbind(datFeatTrain, datFeatTest)
datSubj <- rbind(datSubjTrain, datSubjTest)
datAct <- rbind(datTrain, datTest)
ddatFeat <- rbind(datFeatTrain, datFeatTest)
names(datSubj) <- c("subject")
names(datAct) <- c("activity")
datFeatName <- read.table(file.path(refpath, "features.txt"), head = FALSE)
names(datFeat) <- datFeatName$V2
datComb <- cbind(datSubj, datAct)
dataAll <- cbind(datFeat, datComb)


## Extract mean and stdev measurements
subdatFeatName <- datFeatName$V2[grep("mean\\(\\)|std\\(\\)", datFeatName$V2)]
selName <- c(as.character(subdatFeatName), "subject", "activity")
selData <- subset(dataAll, select=selName)
actLab <- read.table(file.path(refpath, "activity_labels.txt."), header = FALSE)
selData$activity <- factor(c(selData$activity), levels=1:6, labels = c("Walking", "Walking_Upstairs", "Walking_Downstairs", "Sitting", "Standing", "Laying"))
names(selData) <- gsub("^t", "time", names(selData))
names(selData) <- gsub("^f", "frequency", names(selData))
names(selData) <- gsub("Acc", "Accelerometer", names(selData))
names(selData) <- gsub("Gyro", "Gyroscope", names(selData))
names(selData) <- gsub("Mag", "Magnitude", names(selData))
names(selData) <- gsub("BodyBody", "Body", names(selData))

#output tidy data
selData2 <- aggregate(. ~subject + activity, selData, mean)
selData2 <- selData2[order(selData2$subject, selData2$activity),]
write.table(selData2, file = "run_analysis_tidy.txt", row.name = FALSE)
