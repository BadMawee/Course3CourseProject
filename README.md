# Course3CourseProject
Course Project for Coursera

The units of the data set for every variable having a name associated with acc(accelaration),
accjerk(jerk),gyro(angular velocity),gyrojerk(angular jerk) has a unit of g,g/s, rad/s, rad/s^3 respectively.

To perform the tidying of the data.
First take the rawfile and load the necessary files. These are the training and test set, also the labels for the Feature and the activity.

You can rename the activity now for easier readability or you can do it later.

Since the required file was the mean and the standard deviation, index the columns which has the mean and the standard deviation on the feature label using grep function.
The format used in the data was -mean() & -std(), these are the things to find for the function. 

After indexing, the training data set and the testing data set can be created separately, and then merge after. 
The all Argument is set to TRUE and no specific columns are specified. This data set is named "TestTrainData".

To finish the tidying, the names of the variable were changed into its appropriate names from the Feature labels which were indexed previously.

To produce the next data set which is named TidyMeanSubjectActivity.

Split the Merge data earlier by its subject. Then get the column means per activity. This was done using a nested lapply.

The data retrieved from this is used to create the data set using a for loop. 

Lastly, the names of the activity and the names of the variable were change into its appropriate names using the Activity labels and the Feature labels respectively.
