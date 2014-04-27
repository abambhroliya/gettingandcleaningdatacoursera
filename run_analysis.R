## Following commands read 3 test data files: the test data (X_test.txt), subject list data and activity codes. 
Xtest<-read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
subjecttest<-read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
ytest<-read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")

## Combine the 3 test files in to one dataset test. 
test<-cbind(subjecttest,ytest,Xtest)

## Following commands read 3 train data files: the train data (X_train.txt), subject list data and activity codes. 
Xtrain<-read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
subjecttrain<-read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
ytrain<-read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")


## Combine the 3 test files in to one dataset test.
train<-cbind(subjecttrain,ytrain,Xtrain)

## combine the test and train data sets.
traintest<-rbind(train,test)

## Read the columns  headings from features.txt file.
var<-read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")

## Read activity codes labes from activity_labels.txt file and change the columns names.
activitylables<-read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
colnames(activitylables)<-c("Activity_code","Activity_name")

## Apply the columns names to combined data set.
colnames(traintest)<-c("Subject","Activity_code",as.character(var[,2]))

## Add a column "activitylables" for activity description
traintest<-merge(traintest,activitylables,by=c("Activity_code"))

## Select variables for only mean() and std()
var2<-grep("mean()",as.character(var[,2],value=T,fixed=T))
var3<-grep("std()",as.character(var[,2],value=T,fixed=T))

## Subset data for means() and std() from the traintest data.
traintestsubset2<-traintest[,c("Subject","Activity_code","Activity_name")]
traintestsubset3<-traintest[,c(as.character(var[var2,2]))]
traintestsubset4<-traintest[,c(as.character(var[var3,2]))]
finaldata<-cbind(traintestsubset2,traintestsubset3,traintestsubset4)

## Make a tidy dataset by reshaping the data for one subject and one activity
splitdata<-split(finaldata[4:82],list(finaldata$Activity_name, finaldata$Subject))
tidydata<-sapply(splitdata,colMeans)

## Save a tidy dataset as a text file into current working directory.
write.table(tidydata,file="tidydata.txt")
