library(descr)
library(dplyr)
library(tidyr)

tidifyActivityData <- function(activityMeanDataFilename=NULL, activitySummaryFilename=NULL) {
  # Downloads https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and cleans
  # the data by performing the following:
  #   1. Extracts only the measurements on the mean and standard deviation for each measurement.
  #   2. Uses descriptive activity names to name the activities in the data set
  #   3. Add subject id
  #   4. Merges the training and the test sets to create one data set.
  #   5. Appropriately labels the data set with descriptive variable names. 
  #   6. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for 
  #      each activity and each subject.
  #   7. Depending on the parameters, saves the data frames returned in 6 and 7.
  # Args:
  #   activityMeanDataFilename: The filename of the Activity Mean data frame.
  #   activitySummaryFilename: The filename of the Activity summary Mean data frame.
  #
  # Returns:
  #   list with 3 elements:
  #     1. originalDataAccessTime:   The time of accessing the original data. The time format is yyyymmdd_hhmmssTZ.
  #     2. activityMeanData: 		A data frame of both the training and test data, which includes only the mean and the std variables 
  #        from the original data.  
  #     3. activitySummaryData:		A data frame which includes the mean of each variable grouped by subject id and activity.
  # Side effect:
  #   When function parameters, activityMeanFilename, activitySummaryFilename, are provided (they must be valid file names),
  #   the data frames generated in (2) and (3) above, will be saved to:
  #   activityMeanDataFilename.yyyymmdd_hhmmssTZ.txt and activitySummaryFilename.yyyymmdd_hhmmssTZ.txt
  #
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  accessTime <- format(Sys.time(), "%Y%m%d_%H%M%S%Z")
  filenames <- downloadAndUnzip(url)
  featureTitles <- cleanFeatureTitles(filenames$features)
  meanStdFeaturs <- getMeanStdFeatures(featureTitles$feature)
  activityLabels <- loadActivityTitles(filenames$activityLabels)
  trainData <- loadData(featureTitles$feature, activityLabels, filenames$train, meanStdFeaturs)
  testData <- loadData(featureTitles$feature, activityLabels, filenames$test, meanStdFeaturs)
  mergedData <- rbind_list(trainData, testData)
  tidyData <- tidify(mergedData)
  if (!is.null(activityMeanDataFilename))
    saveFile(mergedData, accessTime, activityMeanDataFilename)
  if (!is.null(activitySummaryFilename))
    saveFile(tidyData, accessTime, activitySummaryFilename)
  # Clean all the temporary files
  unlink(filenames["zipDir"], recursive = TRUE, force = TRUE)
  list(originalDataAccessTime = accessTime, activityMeanData = mergedData, activitySummaryData = tidyData)
}

downloadAndUnzip <- function(url) {
  # Download and unzip the input data file feom the web, save it in a temp directory and unzip it.
  # The function verifies that the zip file structure is as expected
  #
  # Args:
  #   url: The URL of the original data file
  #
  # Returns:
  #   A list with machine local filenames:
  #     zipDir        The directory of the zip file
  #     features      The filename of the features file
  #     activityLabels The filename of the activity labels
  #     train         A list which includes the X and y filenames of the train directory
  #     test          A list which includes the X and y filenames of the test directory
  # Side effects:
  #   The function creates files in temp directories
  #
  zipfile <- tempfile()
  download.file(url = url, destfile = zipfile, quiet = TRUE)
  zipdir <- tempfile()
  dir.create(zipdir)
  unzip(zipfile, exdir = zipdir) # files="" so extract all
  file.remove(zipfile)
  files <- list.files(zipdir)
  if (length(files) > 1 || files[1] != "UCI HAR Dataset")
    stop("UCI HAR Dataset is expected, but multiple files in zip: ", paste(files, collapse = ", "))
  datadir <- paste(zipdir, files[1], sep="/")
  features <- paste(datadir, "features.txt", sep="/")
  activityLabels <- paste(datadir, "activity_labels.txt", sep="/")
  datafiles <- lapply(c("train", "test"), function(x) getDataFiles(datadir, x))
  lst <-list(zipDir= zipdir, features = features, activityLabels = activityLabels, train = datafiles[1], test = datafiles[2])
  verifyFileExists(lst)
  lst
}

verifyFileExists <- function(lst) {
  # The function verifies whether files in a list exist
  # Args:
  #  lst:  A possible nested list of filenames
  #
  # Returns:
  #   TRUE if all the files in the list exist
  #   Stops if any file does not exists
  #
  if (is.list(lst))
    lapply(lst, verifyFileExists)
  else if (file.exists(lst))
    TRUE
  else stop(paste("File ", lst, " does not exist", sep=""))
}

getDataFiles <- function(base, dir) {
  # Create filenames of the X and y files in a nested directory
  # Args:
  #   base: The path to the directory where data files were unzipped into
  #   dir:  'test' of 'train'
  # Returns:
  #   A list of the X and y filenames
  #
  subject <- paste(base, dir, paste("subject_", dir,".txt", sep=""), sep="/")
  X <- paste(base, dir, paste("X_", dir,".txt", sep=""), sep="/")
  y <- paste(base, dir,paste("y_", dir,".txt", sep=""), sep="/")
  list(subject = subject, X=X, y=y)
}

cleanFeatureTitles <- function(filename) {
  # Loads the features file into a data frame. Modify the features names making them standard, self explanatory in lower case
  # Args:
  #   filename: The file path of the features file
  # Returns:
  #   A data frame with the modified names  
  featuresTitles<-read.csv(filename,head=FALSE,sep=" ", col.names=c("position","feature"))
  from <- c("\\(\\)", "\\)", "\\(", "\\,", "\\-", "^t",      "^f",     "[Gg]yro",       "[Aa]cc",          "[jJ]erk", "[Mm]ag",       "meanFreq",         "tBody",     "gravityMean")
  to <-   c("",       "",    "\\.", "\\.", "\\.", "time\\.", "fft\\.", "\\.gyroscope",  "\\.acceleration", "\\.jerk", "\\.magnitude", "mean\\.Frequency", "time.body", "gravity\\.mean")
  featuresTitles[,"feature"] <- sapply(featuresTitles$feature, function(x) tolower(Reduce(function(y, i) gsub(from[i], to[i], y),c(1:length(from)), x))) 
  featuresTitles
}

loadActivityTitles <- function(filename) {
  # Loads the activity labels into a data frame
  # Args:
  #   filename: The file path of the features file
  # Returns:
  #   A data frames with activity headers
  read.csv(filename,head=FALSE,sep=" ", col.names=c("id","activity"))
}

readMainData <- function(filename, features) {
  # Loads the mesurments data. Since the data file is fixed format, and loading fixed format files with rea.table
  # is extreamly slow, the file is first converted to a csv file, then loaded as csv. The fodified features are added
  # as cloumn heads
  # Args:
  #   filename: the path to the data file
  #   features: a vector with modified features, to be used as column heads
  #
  # Returns:
  #   The resulted data frame
  #
  nvars <- length(features)
  width <- 16
  begin <- c(0:(nvars-1)) * width + 1
  end <- c(1:nvars)*width
  csvfile <- paste(filename,"csv", sep=".")
  fwf2csv(filename, csvfile, names=features, begin, end)
  read.csv(csvfile, sep='\t')
}

loadSubjectsData <- function(filename) {
  # Loads the subject ids into a data frame
  # Args:
  #   filename: The file path of the subjects file
  # Returns:
  #   A data frames with subjects
  read.table(filename, col.names=c("subject"))
}

loadActivityData <- function(filename) {
  # Loads the activity labels into a data frame
  # Args:
  #   filename: The file path of the features file
  # Returns:
  #   A data frames with activity headers
  read.table(filename, col.names=c("activity"))
}

loadData <- function(features, activityLabels, datafiles, meanStdFeaturs) {
  # 
  # Args:
  #
  # Returns:
  #
  mainData <- readMainData(datafiles[[1]]$X, features)
  meanStdMainData <- mainData[, meanStdFeaturs]
  subjects <- loadSubjectsData(datafiles[[1]]$subject)
  activities <- loadActivityData(datafiles[[1]]$y)
  tbl_df(meanStdMainData) %>%
    mutate(subject=subjects$subject) %>%
    mutate(activity = sapply(activities$activity, function(x) activityLabels[x,"activity"])) %>%
    select(subject, activity, time.body.acceleration.mean.x:fft.bodybody.gyroscope.jerk.magnitude.mean.frequency) %>%
    arrange(subject,activity)
}

getMeanStdFeatures <- function(features) {
  # Filters out features which are not mean or std. Angles are filtered as well since they are not mean or std features
  # Args:
  #   features: A vector of the original features
  #
  # Returns:
  #   A vector with the fieltered features
  #
  Filter(function(x) ((length(grep("mean", x)) > 0)  || (length(grep("std", x)) > 0)) && (length(grep("angle", x)) ==0), features)
}

tidify <- function(data) {
  # Group the input data by subject and activity, then calculates the mean value of each variable
  # Args:
  #   data: the input data frame
  #
  # Returns:
  #   a tidified summary of the data frame
  #
  tbl_df(data) %>%
    gather(variable, average, -subject, -activity) %>%
    group_by(subject, activity, variable) %>%
    summarize(mean = mean(average)) %>%
    spread(variable, mean)
}

saveFile <- function(data, accessDate, filename) {
  # Saves a data frame as data table
  # Args:
  #   data: The data frame
  #   accessDate: A string which includes the date when the original file was downloaded
  #   filename: The path to the saved file
  #
  # Returns:
  #   Nothing
  # Side effect:
  #   The data frame is saved as filename.accessDate.txt
  #
  fullFileName <- paste(filename, accessDate, "txt", sep=".")
  if (file.exists(fullFileName))
    file.remove(fullFileName)
  write.table(data, fullFileName, row.names=FALSE)
}
