Human Activity Recognition Using Smartphones Data Set 
=====================================================

This work further refines the data collected by Human Activity Recognition Using Smartphones experiments.
[DetailedExplanations](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) about the project can be found in the original data site.
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity was captured at a constant rate of 50Hz.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 
[The original data]( https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) includes explanations about the experiment and the code book for the original data.

The function tidifyActivityData(activityFilename=NULL, activitySummaryFilename=NULL) included in the [attached R script](https://github.com/shabtayger/Getting-and-Cleaning-Data/blob/master/cleanActivityData.R), downloads the original data, and  returns a list with 3 elements:

1. originalDataAccessTime: 	The time of accessing the original data. The time format is yyyymmdd_hhmmssTZ.
2. activityMeanData: 		A data frame of both the training and test data, which includes only the mean and the std variables from the original data.  
3. activitySummaryData:		A data frame which includes the mean of each variable grouped by subject id and activity. An example of this file is [attached]().

When function parameters, activityMeanFilename, activitySummaryFilename, are provided (they must be valid file names), the data frames generated in (2) and (3) above, will be saved to files activityMeanFilename.yyyymmdd_hhmmssTZ.csv and activitySummaryFilename.yyyymmdd_hhmmssTZ.csv

The [codebook](https://github.com/shabtayger/Getting-and-Cleaning-Data/blob/master/CodeBook.md) for the [activity summary file]() is attached as well.
 
Notes: 
------
- Features are normalized and bounded within [-1,1].
- Angle variables were not included since they are not mean or std fields, but angles between mean vectors of other features. 

License:
--------
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.