library(dplyr)
library(tidyr)

# loading all the data into R

 subject_test<- read.table("./uci/test/subject_test.txt")
 X_test<- read.table("./uci/test/X_test.txt")
 Y_test<- read.table("./uci/test/Y_test.txt")
 subject_train<- read.table("./uci/train/subject_train.txt")
 X_train<- read.table("./uci/train/X_train.txt")
 Y_train<- read.table("./uci/train/Y_train.txt")
 features<- read.table("./uci/features.txt") # column names 
 Activity_labels<- read.table("./uci/Activity_labels.txt")

# Naming the columns

names(X_train)<- features$V2
names(X_test)<- features$V2
names(Y_train)<- "Activity"
names(Y_test)<- "Activity"
names(subject_train)<- "Subject"
names(subject_test)<- "Subject"

# Converting to tbl_df

X_train <- tbl_df(X_train)
X_test <- tbl_df(X_test)

# Adding activity column to the data to act as filter and adding the corresponding activity name

X_train<- cbind(subject_train,Y_train,X_train)
X_test<- cbind(subject_test,Y_test,X_test)

X_train$Activity <- as.factor(X_train$Activity)
levels(X_train$Activity)<- Activity_labels$V2
X_test$Activity <- as.factor(X_test$Activity)
levels(X_test$Activity)<- Activity_labels$V2

# Merging trainand test data

X<- rbind(X_train,X_test)

# Extracting columns with only mean and std
extract_features<- grep("mean|std" ,names(X)) 
extract_features<-c(1,2,extract_features)
X<-X[,extract_features]

# Giving appropraite names to all variables

names(X) <- gsub("tBody", "Time.Body", names(X))
names(X) <- gsub("tGravity", "Time.Gravity", names(X))

names(X) <- gsub("fBody", "FFT.Body", names(X))
names(X) <- gsub("fGravity", "FFT.Gravity", names(X))

names(X) <- gsub("\\-mean\\(\\)\\-", ".Mean.", names(X))
names(X) <- gsub("\\-std\\(\\)\\-", ".Std.", names(X))

names(X) <- gsub("\\-mean\\(\\)", ".Mean", names(X))
names(X) <- gsub("\\-std\\(\\)", ".Std", names(X))


# Creating the tidy data set

tidydata<- aggregate(x=X[,-c(1,2)], by= list(X$Subject,X$Activity),mean)
# writing the first two row names
names(tidydata) <- gsub("group.1", "Subject.ID", names(tidydata))
names(tidydata) <- gsub("group.2", "Activity", names(tidydata))

write.table(tidydata,"tidydata.txt",row.name=F)
write.table(tidydata,"meandata.txt",row.name=F)