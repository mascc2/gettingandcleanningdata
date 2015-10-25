## set working directory
setwd('/home/mascc2/Downloads/R/')
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip','data.zip')
unzip('data.zip')

filenames<-list.files(path="UCI HAR Dataset",all.files=TRUE,full.names=TRUE,recursive=TRUE)

## FEATURES AND ACTIVITIES

featurerows<-grep('features.txt',filenames)
featurenames<-filenames[c(featurerows)]
activityrows<-grep('activity_labels.txt',filenames)
activitynames<-filenames[c(activityrows)]
xnamerows<-grep('X_train',filenames)
xnamenames<-filenames[c(xnamerows)]

## TRAIN

trainrows<-grep('train',filenames)
trainnames<-filenames[c(trainrows)]


for (i in trainnames) 
{
  x<-read.table(i,header=FALSE) 
  assign(i,x)
}

features<-read.table(featurenames)
colnames(`UCI HAR Dataset/train/X_train.txt`) <- features$V2
colnames(`UCI HAR Dataset/train/y_train.txt`) <- 'activityid'
colnames(`UCI HAR Dataset/train/subject_train.txt`) <- 'subjectid'

traindata<-cbind(`UCI HAR Dataset/train/y_train.txt`,`UCI HAR Dataset/train/subject_train.txt`,`UCI HAR Dataset/train/X_train.txt`)

## TEST

testrows<-grep('test',filenames)
testnames<-filenames[c(testrows)]

for (i in testnames) 
{
  x<-read.table(i,header=FALSE) 
  assign(i,x)
}

features<-read.table(featurenames)
colnames(`UCI HAR Dataset/test/X_test.txt`) <- features$V2
colnames(`UCI HAR Dataset/test/y_test.txt`) <- 'activityid'
colnames(`UCI HAR Dataset/test/subject_test.txt`) <- 'subjectid'


testdata<-cbind(`UCI HAR Dataset/test/y_test.txt`,`UCI HAR Dataset/test/subject_test.txt`,`UCI HAR Dataset/test/X_test.txt`)
#################
## item 1########
#################

alldata<-rbind(testdata,traindata)

###################
# item 3 and 4#####
###################

## mean columns
meanrows<- grep('ean',features$V2)
meannames<-features$V2[c(meanrows)]
## std columns
stdrows<- grep('std',features$V2)
stdnames<-features$V2[c(stdrows)]
## mean and std columns
meanstdrows<- grep('std|ean|activityid|subjectid',features$V2)
meanstdnames<-features$V2[c(meanstdrows)]

meandata<-alldata[,as.character(meannames)]
stddata<-alldata[,as.character(stdnames)]

##################
# item 2 #########
##################
meanstddata<-alldata[,as.character(meanstdnames)]

tidydata <- meanstddata
write.table(tidydata,file='tidydata.txt',row.names = FALSE)
