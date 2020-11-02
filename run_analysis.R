temp<-tempfile()

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp,mode="wb")

SubjectTest<-read.table(unz("./Dataset.zip","UCI HAR Dataset/test/subject_test.txt"))


XTest<-read.table(unz("./Dataset.zip","UCI HAR Dataset/test/X_test.txt"))


YTest<-read.table(unz("./Dataset.zip","UCI HAR Dataset/test/y_test.txt"))


SubjectTrain<-read.table(unz("./Dataset.zip","UCI HAR Dataset/train/subject_train.txt"))


XTrain<-read.table(unz("./Dataset.zip","UCI HAR Dataset/train/X_train.txt"))


YTrain<-read.table(unz("./Dataset.zip","UCI HAR Dataset/train/y_train.txt"))


FeatureLabels<-read.table(unz("./Dataset.zip","UCI HAR Dataset/features.txt"))


ActivityLabels<-read.table(unz("./Dataset.zip","UCI HAR Dataset/activity_labels.txt"))


ActivityLabels[,2]<-sub(pattern ="_"," ",tolower(ActivityLabels[,2]))

##mean and standard deviation of index
FeatureIndex<-FeatureLabels[grep(pattern="-mean\\()|std\\()",FeatureLabels[,2]),]

TrainData<-data.frame(subject=SubjectTrain[,1], activity = YTrain[,1],XTrain[,FeatureIndex[,1]] )
TestData<-data.frame(subject=SubjectTest[,1], activity = YTest[,1],XTest[,FeatureIndex[,1]] )
TestTrainData<-merge(TestData,TrainData,all= TRUE)

TestTrainData$activity<-sapply(TestTrainData$activity, function(x)
  sub(pattern=x,replacement = ActivityLabels[x,2],x))

names(TestTrainData)[grep(pattern="^V[0-9]*",names(TestTrainData))]<-
  as.vector(FeatureIndex[,2])


SplitPerSubject<-split(TestTrainData,TestTrainData$subject)

MeanSubjectActivity<-lapply(names(SplitPerSubject),function(y) 
  lapply(ActivityLabels$V2,function(x,z=y) 
    colMeans(SplitPerSubject[[z]][grep(pattern=x,SplitPerSubject[[z]]$activity),as.vector(FeatureIndex[,2])])
  )
  )
ProxyMatrix<-matrix(nrow=0,ncol=length(names(TestTrainData)))

TidyMeanSubjectActivity<-data.frame(ProxyMatrix)

k<-0
for (i in 1:length(MeanSubjectActivity)) {
  for(j in 1:length(ActivityLabels$V2)){
    k<-k+1
    TidyMeanSubjectActivity<-rbind(TidyMeanSubjectActivity,c(i,j,(unname(MeanSubjectActivity[[i]][[j]]))))
  }
}

colnames(TidyMeanSubjectActivity)<-names(TestTrainData)
TidyMeanSubjectActivity$activity<-sapply(TidyMeanSubjectActivity$activity, function(x)
  sub(pattern=x,replacement = ActivityLabels[x,2],x))

write.table(TestTrainData,"./dataset1.txt", row.name= FALSE)
write.table(TidyMeanSubjectActivity,"./dataset2.txt", row.name= FALSE)
