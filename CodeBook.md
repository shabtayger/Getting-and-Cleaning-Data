Getting and Cleaning Data Project - Code Book for Activity Summary File
=======================================================================

The features selected for this database come from the [original]( https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) Activity data file.  The attached file was created from the original file as follows:
1. Features which are mean or standard deviation (std) of other features were selected. All other features were ignored.
2. Subject id was added to the file.
3. Activity code was replaced by activity labels.
4. Training and test data sets of the original data were appended into a single file.
5. For each included feature, its mean was calculated, grouped by subject and activity.

Since all the data elements in the table  are means of the included features, a redundant 'mean' was excluded from the variable names.

Variables names explanation:
----------------------------
- 'subject' is the subject id. It identifies one of the 30 students participated in the experiment.
- 'activity' is the activity related to the sample. The values are:
..*WALKING
..*WALKING_UPSTAIRS
..*WALKING_DOWNSTAIRS
..*SITTING
..*STANDING
..*LAYING 
- Measurement domains:
..*'time' refers to time domain.
..* 'fft' (Fast Fourier Transform) relates to the frequency domain.
- Acceleration:
..*'body' refers to the body linear acceleration
..*'gravity' refers to the gravity acceleration g.
- Sensors:
..*'acceleration' refers to the accelerometer sensor measurements
..*'gyroscope' refers to the gyroscope sensor
- Axis - x, y, z - the Cartesian components of the measured feature vectors 
- 'magnitude' refers to the length of the measured feature vectors
- 'jerk' is the time derivative of the acceleration (the acceleration of the acceleration)
- Statistical moments
..* mean is the mean of the measured feature
..* std is the standard deviation of the measured feature
- 'frequency' is a frequency in the time domain

Please note:
------------
Features are normalized and bounded within [-1,1]
Examples
--------
- Variable 'time.body.gyroscope.std.z' is the mean of the time domain body gyroscope z component standard deviation, taken over all measurements of a subject's single activity 
- Variable 'fft.bodybody.acceleration.jerk.magnitude.mean' is the mean of the frequency domain body linear acceleration magnitude mean, taken over all measurements of a subject's single activity

List of variables
-----------------
- subject
- activity
- time.body.acceleration.mean.x
- time.body.acceleration.mean.y
- time.body.acceleration.mean.z
- time.body.acceleration.std.x
- time.body.acceleration.std.y
- time.body.acceleration.std.z
- time.gravity.acceleration.mean.x
- time.gravity.acceleration.mean.y
- time.gravity.acceleration.mean.z
- time.gravity.acceleration.std.x
- time.gravity.acceleration.std.y
- time.gravity.acceleration.std.z
- time.body.acceleration.jerk.mean.x
- time.body.acceleration.jerk.mean.y
- time.body.acceleration.jerk.mean.z
- time.body.acceleration.jerk.std.x
- time.body.acceleration.jerk.std.y
- time.body.acceleration.jerk.std.z
- time.body.gyroscope.mean.x
- time.body.gyroscope.mean.y
- time.body.gyroscope.mean.z
- time.body.gyroscope.std.x
- time.body.gyroscope.std.y
- time.body.gyroscope.std.z
- time.body.gyroscope.jerk.mean.x
- time.body.gyroscope.jerk.mean.y
- time.body.gyroscope.jerk.mean.z
- time.body.gyroscope.jerk.std.x
- time.body.gyroscope.jerk.std.y
- time.body.gyroscope.jerk.std.z
- time.body.acceleration.magnitude.mean
- time.body.acceleration.magnitude.std
- time.gravity.acceleration.magnitude.mean
- time.gravity.acceleration.magnitude.std
- time.body.acceleration.jerk.magnitude.mean
- time.body.acceleration.jerk.magnitude.std
- time.body.gyroscope.magnitude.mean
- time.body.gyroscope.magnitude.std
- time.body.gyroscope.jerk.magnitude.mean
- time.body.gyroscope.jerk.magnitude.std
- fft.body.acceleration.mean.x
- fft.body.acceleration.mean.y
- fft.body.acceleration.mean.z
- fft.body.acceleration.std.x
- fft.body.acceleration.std.y
- fft.body.acceleration.std.z
- fft.body.acceleration.mean.frequency.x
- fft.body.acceleration.mean.frequency.y
- fft.body.acceleration.mean.frequency.z
- fft.body.acceleration.jerk.mean.x
- fft.body.acceleration.jerk.mean.y
- fft.body.acceleration.jerk.mean.z
- fft.body.acceleration.jerk.std.x
- fft.body.acceleration.jerk.std.y
- fft.body.acceleration.jerk.std.z
- fft.body.acceleration.jerk.mean.frequency.x
- fft.body.acceleration.jerk.mean.frequency.y
- fft.body.acceleration.jerk.mean.frequency.z
- fft.body.gyroscope.mean.x
- fft.body.gyroscope.mean.y
- fft.body.gyroscope.mean.z
- fft.body.gyroscope.std.x
- fft.body.gyroscope.std.y
- fft.body.gyroscope.std.z
- fft.body.gyroscope.mean.frequency.x
- fft.body.gyroscope.mean.frequency.y
- fft.body.gyroscope.mean.frequency.z
- fft.body.acceleration.magnitude.mean
- fft.body.acceleration.magnitude.std
- fft.body.acceleration.magnitude.mean.frequency
- fft.bodybody.acceleration.jerk.magnitude.mean
- fft.bodybody.acceleration.jerk.magnitude.std
- fft.bodybody.acceleration.jerk.magnitude.mean.frequency
- fft.bodybody.gyroscope.magnitude.mean
- fft.bodybody.gyroscope.magnitude.std
- fft.bodybody.gyroscope.magnitude.mean.frequency
- fft.bodybody.gyroscope.jerk.magnitude.mean
- fft.bodybody.gyroscope.jerk.magnitude.std
- fft.bodybody.gyroscope.jerk.magnitude.mean.frequency


 
 