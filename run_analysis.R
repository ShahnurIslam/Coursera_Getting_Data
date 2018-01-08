getwd()
#Load the reshape2 library which you should have installed from the swirl() course
library(reshape2) 

setwd("C:/Users/shahnur islam/Desktop/UCI HAR Dataset")
#read the training dataset and combine with the relevant subject & activity datasets
training <- read.csv('./train/X_train.txt', sep="", header = FALSE)
training[,562]<- read.csv('./train/Y_train.txt',sep="" ,header = FALSE)
training[,563] <- read.csv('./train/subject_train.txt',sep="" ,header = FALSE)

#read the testing dataset and combine with the relevant subject & activity datasets
testing <- read.csv('./test/X_test.txt', sep="", header = FALSE)
testing[,562] <- read.csv('./test/Y_test.txt',sep="" ,header = FALSE)
testing[,563] <- read.csv('./test/subject_test.txt',sep="" ,header = FALSE)

#Combine the training & tidy data set
Combined_Data <- rbind(training,testing)
features <- read.csv('./features.txt', sep= "", header = FALSE)
features <- tolower(features[,2]) # Convert all labels to lowercase

#filter the features data set for mean and std in the header
ColVec <- grep("*mean*| *std",features)
ColVec <- c(ColVec,562,563) # We add the col numbers for Activity and Subject to our filter vector
Combined_Data <- Combined_Data[,ColVec] #filter Combined data set
feature <- c(features,"Activity", "Subject") #create a vector of column names

#Add our headers to the combined data set
colnames(Combined_Data) <- feature[ColVec]

#read in the activity lablels
activity <- read.csv('./activity_labels.txt', sep = "", header = FALSE)

#Merge the activity labels with the Combined data set on Actiivty
Combined_Data <- merge(Combined_Data, activity, by.x = "Activity", by.y = "V1")
Combined_Data <- Combined_Data[,2:89] # Drop the old Activity columns
colnames(Combined_Data)[colnames(Combined_Data)=="V2"] <- "Activity"

#Turn the activity and Subject into Factors
Combined_Data$Activity <- as.factor(Combined_Data$Activity)
Combined_Data$Subject <- as.factor(Combined_Data$Subject)
#melt the data into useable dataset based on Subject & Activity
tidy_data <- melt(Combined_Data, id = c("Subject","Activity"))
tidy_data <- dcast(tidy_data,Subject + Activity ~ variable, mean)

#Output the tidy data 
write.table(tidy_data,row.name = FALSE, file = "tidy_data.txt")
