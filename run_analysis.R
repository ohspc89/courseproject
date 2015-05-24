test <- read.table("X_test.txt")
train <- read.table("X_train.txt")
complete <- rbind(test, train)
#load test and training sets and put together: step 1

ytest <- read.table("y_test.txt")
ytrain <- read.table("y_train.txt")
y <- rbind(ytest, ytrain)
#load the list of the tasks subjects carried out / put together
colnames(y) <- "task_type"

subject_test <- read.table("subject_test.txt")
subject_train <- read.table("subject_train.txt")
subjects <- rbind(subject_test, subject_train)
#load the list of subjects who participated in the study
colnames(subjects) <- "subject_num"

features <- read.table("features.txt")
colnames(complete) <- features[,1]
#Appropriately labeled the data set with descriptive variable names: step 4
#I did this first so as to facilitate the step 2

par1 <- grep("mean", colnames(complete))
par2 <- grep("std", colnames(complete))
par <- c(par1, par2)
#get the numbers of columns whose names contain either "mean" or "std"
#Then put them together

meanstd <- complete[,sort(par)]
#Extracts only the measurements on the mean and standard deviation 
#for each measurement: step 2

meanstd <- cbind(meanstd, y, subjects)
#Attach the task_type data and subjects data to the extracted data

meanstd$task_type[meanstd$task_type==1] <- "walking"
meanstd$task_type[meanstd$task_type==2] <- "walking_upstairs"
meanstd$task_type[meanstd$task_type==3] <- "walking_downstairs"
meanstd$task_type[meanstd$task_type==4] <- "sitting"
meanstd$task_type[meanstd$task_type==5] <- "standing"
meanstd$task_type[meanstd$task_type==6] <- "laying"
#Uses descriptive activity names to name the activities in the dataset: step 3

meanstd2 <- arrange(meanstd, task_type, subject_num)
#Sort the extracted data by task_type and subject_num

tidied <- group_by(meanstd2, task_type, subject_num) %>% summarise_each(funs(mean))
#Create a second, independent tidy data set with the average of each variable
#for each activity and each subject: step 5

write.table(tidied, "tidied.txt", row.name=FALSE)
