## set working directory
setwd('/home/mascc2/Downloads/R/')
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip','data.zip')
unzip('data.zip')

filenames<-list.files(path="UCI HAR Dataset",all.files=TRUE,full.names=TRUE,recursive=TRUE)

## FEATURES AND ACTIVITIES
## find the features and activites files and is filename and path in the list files command
## also find name for the xtrain file
featurerows<-grep('features.txt',filenames)
featurenames<-filenames[c(featurerows)]
activityrows<-grep('activity_labels.txt',filenames)
activitynames<-filenames[c(activityrows)]
xnamerows<-grep('X_train',filenames)
xnamenames<-filenames[c(xnamerows)]

## TRAIN
## find the files from the train set and load the files recursive in R
trainrows<-grep('train',filenames)
trainnames<-filenames[c(trainrows)]


for (i in trainnames) 
{
  x<-read.table(i,header=FALSE) 
  assign(i,x)
}

## NAMING HEADERS
## find the header names and put in the specified variables
features<-read.table(featurenames)
colnames(`UCI HAR Dataset/train/X_train.txt`) <- features$V2
colnames(`UCI HAR Dataset/train/y_train.txt`) <- 'activityid'
colnames(`UCI HAR Dataset/train/subject_train.txt`) <- 'subjectid'

traindata<-cbind(`UCI HAR Dataset/train/y_train.txt`,`UCI HAR Dataset/train/subject_train.txt`,`UCI HAR Dataset/train/X_train.txt`)

## TEST
## find the files from the test set and load the files recursive in R
testrows<-grep('test',filenames)
testnames<-filenames[c(testrows)]

for (i in testnames) 
{
  x<-read.table(i,header=FALSE) 
  assign(i,x)
}


## NAMING HEADERS
## find the header names and put in the specified variables
features<-read.table(featurenames)
colnames(`UCI HAR Dataset/test/X_test.txt`) <- features$V2
colnames(`UCI HAR Dataset/test/y_test.txt`) <- 'activityid'
colnames(`UCI HAR Dataset/test/subject_test.txt`) <- 'subjectid'


testdata<-cbind(`UCI HAR Dataset/test/y_test.txt`,`UCI HAR Dataset/test/subject_test.txt`,`UCI HAR Dataset/test/X_test.txt`)

#################
## item 1########
#################

## unite all rows from test and train data

alldata<-rbind(testdata,traindata)

###################
# item 3 and 4#####
###################

## find mean columns names
meanrows<- grep('ean',names(testdata))
meannames<-names(testdata)[c(meanrows)]
## find id columns names
idrows<- grep('id',names(testdata))
idnames<-names(testdata)[c(idrows)]


## find std columns names
stdrows<- grep('std',names(testdata))
stdnames<-names(testdata)[c(stdrows)]
## find id, mean and std columns names
meanstdrows<- grep('std|ean|activityid|subjectid',names(testdata))
meanstdnames<-names(testdata)[c(meanstdrows)]

meandata<-alldata[,as.character(meannames)]
stddata<-alldata[,as.character(stdnames)]

##################
# item 2 #########
##################

## load all separated values into a data.frames
meanstddata<-alldata[,as.character(meanstdnames)]

## generate tidydata
tidydata <- meanstddata
write.table(tidydata,file='tidydata.txt',row.names = FALSE)
