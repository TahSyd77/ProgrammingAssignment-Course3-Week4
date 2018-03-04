### The run_analysis function will read in 8 different tables of measurement data.  Each row of data, across the tables, contains a subject
### that is performing an activity, along with the associated measurments taken for the subject/activity combination.
### A subject can perform the same activity multiple times resulting in multiple rows of data for that subject and activity combination.
### The subjects performing the activities were split into a 'test' group and a 'train'-ing group.    
### Thus there are 3 tables for each group.  
###     1)  List of the subject performing the activity for each row of table data.  There are 1-30 subjects possible.
###     2)  List of the activity being performed for each row of table data.  There are 1-6 activity types.
###     3)  Table of different measurements taken for each subject/activity combination.
###
### There are also 2 additional tables:
###     1) Table that sequentially numbers each feature (e.g.measurement/column in the measurement file), along
###        with the corresponding name of the feature.  There are 2 columns in this table: 1) Feature id/number,
###        2) Feature Name.
###     2) Table that identifies the activity that relates to each activity value (1-6) in the list of activities file.
###        There are 2 colmns in this file:  1) the Activity Value (1-6), and 2) the Activity Name.
### After reading in the table data, the run_analysis function will: Extract only the measurements of the mean and standard
###     deviation on each measurement.  The tables will be combined, the 3 within each group, and then the 2 groups' tables.
###     The column names are made more descriptive, and the activity values(1-6) are replaced with the actual activity name.
###     This produces one dataset of the mean and standard deviation data.  The final task is to calculate the mean for each
###     subject/activity combination (taking the mean of all rows representing a subject/activity pair), 
###     to be captured in a second dataset.

run_analysis<-function(){

        library(data.table)

        # Download and unzip source data file...
        
                fileURLZip<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        
                if(!file.exists("zipfilename.zip")){
                        download.file(fileURLZip, destfile="zipfilename.zip")
                }
                zippath<-"UCI HAR Dataset"
        
                 if(!file.exists("zippath")) {
                       unzip("zipfilename.zip")
                }

        # Read in all 8 tables...

                TestSubjects<-read.table("UCI HAR Dataset/test/subject_test.txt")
                TestMeasurements<-read.table("UCI HAR Dataset/test/X_test.txt")
                TestActivities<-read.table("UCI HAR Dataset/test/y_test.txt")

                TrainSubjects<-read.table("UCI HAR Dataset/train/subject_train.txt")
                TrainMeasurements<-read.table("UCI HAR Dataset/train/X_train.txt")
                TrainActivities<-read.table("UCI HAR Dataset/train/y_train.txt")

        # Convert from Data Frames to Data Tables
                
                TrainMeasurements<-data.table(TrainMeasurements)
                TestMeasurements<-data.table(TestMeasurements)
        
                FeatureList<-read.table("UCI HAR Dataset/features.txt")
                ActivityLabels<-read.table("UCI HAR Dataset/activity_labels.txt")
        
        # Convert columns from factors to character
                
                FeatureList[,2]<-as.character(FeatureList[,2])
                ActivityLabels[,2]<-as.character(ActivityLabels[,2])

        # Identify all instances of 'mean' and 'std', and return the indices of these occurrences
        # Clean-up feature names by replacing abbreviations with full descriptions                
                
                SelectedFeatures<-grep("mean\\(|std",FeatureList[,2]) #Have indices of columns to be retained
                SelectedFeatures.names<-FeatureList[SelectedFeatures,2]
                SelectedFeatures.names<-gsub("t","Time ",SelectedFeatures.names)
                SelectedFeatures.names<-gsub("f","Frequency ",SelectedFeatures.names)
                SelectedFeatures.names<-gsub("Gyro","Gyroscope ",SelectedFeatures.names)
                SelectedFeatures.names<-gsub("Acc","Acceleration ",SelectedFeatures.names)
                SelectedFeatures.names<-gsub("Mag","Magnitude ",SelectedFeatures.names)
                SelectedFeatures.names<-gsub("mean()","Mean ",SelectedFeatures.names)
                SelectedFeatures.names<-gsub("std()","Standard Deviation ",SelectedFeatures.names)
                SelectedFeatures.names<-gsub("BodyBody","Body ",SelectedFeatures.names)
                SelectedFeatures.names<-gsub("Body","Body ",SelectedFeatures.names)

        # Capture only those measurements associated with the mean and std features

                TestMeasurementsMeanSD<-TestMeasurements[,SelectedFeatures,with=FALSE] 
                TrainMeasurementsMeanSD<-TrainMeasurements[,SelectedFeatures,with=FALSE] 

        # Update column names in order to bind and merge cleanly        
                
                colnames(TestSubjects)<-c("Subject")
                colnames(TrainSubjects)<-c("Subject")
                colnames(TestActivities)<-c("Activity Value")
                colnames(TrainActivities)<-c("Activity Value")

        # Combine the test tables (subjects,activities and measurements), and training tables into 2 tables        
                
                TestCombined<-cbind(TestSubjects,TestActivities,TestMeasurementsMeanSD)
                TrainCombined<-cbind(TrainSubjects,TrainActivities,TrainMeasurementsMeanSD)

        # Combine the training and test data tables into one table
                
                TestTrainCombined<-rbind(TestCombined,TrainCombined)

        # Label Variables before merge (merge renames variables)

                colnames(TestTrainCombined)<-c("Subject","Activity",SelectedFeatures.names)
                colnames(ActivityLabels)<-c("Activity Value","Activity")
        
        # Merge the combined data table with the activity labels
                
                FinalCombined<-merge(ActivityLabels,TestTrainCombined,by.x="Activity Value",by.y="Activity",all=TRUE)
        
        # Eliminate the activity value column (column 1)
        
                FinalCombined<-FinalCombined[,2:69]
               
        # Pt.2:  Write table of Average for each subject, activity combination

                library(gdata)
                library(reshape2)
                library(dplyr)
       
        # Convert the table from a wide, to a long table, with variables to be broken out
                
                Final<-data.table(FinalCombined)
                setkey(Final,Activity,Subject)
                Final1<-melt(Final,key(Final))
                Final1$variable<-as.character(Final1$variable)
                
        # For each variable type (time/freq, body/gravity, acceleration/gyroscope, Jerk, Mag, Mean/Std, XYZ), create a new column
        # and populate the column with the appropriate values
                
        # For each variable, find the variable name and return a True or False vector.  Create a new column for the variable
        # (eg. 'tf') in table Final1 that has True wherever there is a match, and false wherever the variable name was not
        # found.  Substitute the first variable value (eg. Time) wherever True appears, and substitute the second variable
        # value (eg.Frequency) wherever False appears.  
                
                TF<-grepl("^Time",Final1$variable)
                Final1$tf<-TF
                Final1$tf<-gsub("TRUE","Time",Final1$tf)
                Final1$tf<-gsub("FALSE","Frequency",Final1$tf)

                BG<-grepl("Body",Final1$variable)
                Final1$bg<-BG
                Final1$bg<-gsub("TRUE","Body",Final1$bg)
                Final1$bg<-gsub("FALSE","Gravity",Final1$bg)

                AG<-grepl("Acceleration",Final1$variable)
                Final1$ag<-AG
                Final1$ag<-gsub("TRUE","Acceleration",Final1$ag)
                Final1$ag<-gsub("FALSE","Gyroscope",Final1$ag)

                Jerk<-grepl("Jerk",Final1$variable)
                Final1$Jerk<-Jerk
                Final1$Jerk<-gsub("TRUE","Jerk",Final1$Jerk)
                Final1$Jerk<-gsub("FALSE","NA",Final1$Jerk)

                Mag<-grepl("Magnitude",Final1$variable)
                Final1$Mag<-Mag
                Final1$Mag<-gsub("TRUE","Magnitude",Final1$Mag)
                Final1$Mag<-gsub("FALSE","NA",Final1$Mag)

                MSD<-grepl("-Mean",Final1$variable)
                Final1$msd<-MSD
                Final1$msd<-gsub("TRUE","Mean",Final1$msd)
                Final1$msd<-gsub("FALSE","Standard Deviation",Final1$msd)
                
        # To populate the variable with 3 values (eg. XYZ Dimension), first locate values that match each, and create separate
        # logical vectors to identify where there are matches. The substitue, within each vector, wherever there is a match (eg True)
        # with the number 1.  Combine the 3 vectors into a matrix of 3 columns.  Wherever there is a false, replace with 0.
        # Sum across each row of the matrix to get a 1,2 or 3 value.  Substitute 1 with X, 2 with Y and 3 with Z.
                
                XDim<-grepl("-X",Final1$variable)
                YDim<-grepl("-Y",Final1$variable)
                ZDim<-grepl("-Z",Final1$variable)

                XDim<-gsub("TRUE",1,XDim)
                YDim<-gsub("TRUE",2,YDim)
                ZDim<-gsub("TRUE",3,ZDim)

                xyz<-matrix(c(XDim,YDim,ZDim),ncol=3)
                xyz<-gsub("FALSE",0,xyz)
                xyz<-matrix(as.numeric(xyz),ncol=3)
                XYZDim<-apply(xyz,1,sum)

                XYZDim<-gsub(1,"X",XYZDim)
                XYZDim<-gsub(2,"Y",XYZDim)
                XYZDim<<-gsub(3,"Z",XYZDim)
                XYZDim<<-gsub(0," ",XYZDim)
               
        # Combine the last variable column (eg. XYZ) to the overall dataset
                
                Final1<<-cbind(Final1,XYZDim)
                Final2<-Final1[,-3]
                
                colnames(Final2)<-c("Activity","Subject","Measurement","Time Freq Domain",
                                    "Body Gravity","Acceleration Gyroscope","Jerk","Mag","Mean StdDev","XYZ Dimension")
                
        # Group the dataset by Subject and Activity, and take the mean - Write the table to a new file.
                
                Averages<<-Final2 %>% group_by(Subject,Activity) %>% summarise(Mean=mean(Measurement))
                write.table(Averages,file="TableofAverages.txt")
}