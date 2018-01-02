getwd()
setwd("C:/Users/shahnur islam/Desktop/UCI HAR Dataset")
training <- read.csv('./train/X_train.txt', sep="", header = FALSE)
training[,562]<- read.csv('./train/Y_train.txt',sep="" ,header = FALSE)
training[,563] <- read.csv('./train/subject_train.txt',sep="" ,header = FALSE)

testing <- read.csv('./test/X_test.txt', sep="", header = FALSE)
testing[,562] <- read.csv('./test/Y_test.txt',sep="" ,header = FALSE)
testing[,563] <- read.csv('./test/subject_test.txt',sep="" ,header = FALSE)

Combined_Data <- rbind(training,testing)
features <- read.csv('./features.txt', sep= "", header = FALSE)
features <- tolower(features[,2])

#filter for mean and std names boolean vector
ColVec <- grep("*mean*| *std",features)
ColVec <- c(ColVec,562,563)
Combined_Data <- Combined_Data[,ColVec]
feature <- c(features,"Activity", "Subject")

#Add header names filtering our feature vector that contains words Activity and Subject
colnames(Combined_Data) <- feature[ColVec]

activity <- read.csv('./activity_labels.txt', sep = "", header = FALSE)

Combined_Data <- merge(Combined_Data, activity, by.x = "Activity", by.y = "V1")
Combined_Data <- Combined_Data[,2:89] # Drop the old Activity columns
colnames(Combined_Data)[colnames(Combined_Data)=="V2"] <- "Activity"

Combined_Data$Activity <- as.factor(Combined_Data$Activity)
Combined_Data$Subject <- as.factor(Combined_Data$Subject)

tidy_data <- melt(Combined_Data, id = c("Subject","Activity"))
tidy_data <- dcast(tidy_data,Subject + Activity ~ variable, mean)
write.table(tidy_data,row.name = FALSE, file = "tidy_data.txt")
