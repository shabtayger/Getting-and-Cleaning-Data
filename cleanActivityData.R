library(descr)
library(dplyr)
library(tidyr)

downloadAndUnzip <- function(url) {
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
  if (is.list(lst))
    lapply(lst, verifyFileExists)
  else if (file.exists(lst))
    TRUE
  else stop(paste("File ", lst, " does not exist", sep=""))
}

getDataFiles <- function(base, dir) {
  subject <- paste(base, dir, paste("subject_", dir,".txt", sep=""), sep="/")
  X <- paste(base, dir, paste("X_", dir,".txt", sep=""), sep="/")
  y <- paste(base, dir,paste("y_", dir,".txt", sep=""), sep="/")
  list(subject = subject, X=X, y=y)
}

cleanFeatureTitles <- function(filename) {
  featuresTitles<-read.csv(filename,head=FALSE,sep=" ", col.names=c("position","feature"))
  from <- c("\\(\\)", "\\)", "\\(", "\\,", "\\-", "^t",      "^f",     "[Gg]yro",       "[Aa]cc",          "[jJ]erk", "[Mm]ag",       "meanFreq",         "tBody",     "gravityMean")
  to <-   c("",       "",    "\\.", "\\.", "\\.", "time\\.", "fft\\.", "\\.gyroscope",  "\\.acceleration", "\\.jerk", "\\.magnitude", "mean\\.Frequency", "time.body", "gravity\\.mean")
  featuresTitles[,"feature"] <- sapply(featuresTitles$feature, function(x) tolower(Reduce(function(y, i) gsub(from[i], to[i], y),c(1:length(from)), x))) 
  featuresTitles
}

loadActivityTitles <- function(filename) {
  read.csv(filename,head=FALSE,sep=" ", col.names=c("id","activity"))
}

readMainData <- function(filename, features) {
  nvars <- length(features)
  width <- 16
  begin <- c(0:(nvars-1)) * width + 1
  end <- c(1:nvars)*width
  csvfile <- paste(filename,"csv", sep=".")
  fwf2csv(filename, csvfile, names=features, begin, end)
  read.csv(csvfile, sep='\t')
}

loadSubjectsData <- function(filename) {
  read.table(filename, col.names=c("subject"))
}

loadActivityData <- function(filename) {
  read.table(filename, col.names=c("activity"))
}

loadData <- function(features, activityLabels, datafiles, meanStdFeaturs) {
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
  Filter(function(x) ((length(grep("mean", x)) > 0)  || (length(grep("std", x)) > 0)) && (length(grep("angle", x)) ==0), features)
}

tidify <- function(data) {
  tbl_df(data) %>%
    gather(variable, average, -subject, -activity) %>%
    group_by(subject, activity, variable) %>%
    summarize(mean = mean(average)) %>%
    spread(variable, mean)
}

saveFile <- function(data, accessDate, filename) {
  fullFileName <- paste(filename, accessDate, "txt", sep=".")
  if (file.exists(fullFileName))
    file.remove(fullFileName)
  write.table(data, fullFileName, row.names=FALSE)
}

tidifyActivityData <- function(activityMeanDataFilename=NULL, activitySummaryFilename=NULL) {
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  accessTime <- format(Sys.time(), "%Y%m%d_%H%M%S%Z")
  filenames <- downloadAndUnzip(url)
  featureTitles <- cleanFeatureTitles(filenames$features)
  meanStdFeaturs <- getMeanStdFeatures(featureTitles$feature)
  activityLabels <- loadActivityTitles(filenames$activityLabels)
  trainData <- loadData(featureTitles$feature, activityLabels, filenames$train, meanStdFeaturs)
  testData <- loadData(featureTitles$feature, activityLabels, filenames$test, meanStdFeaturs)
  #mergedData <- rbind(trainData, testData)
  mergedData <- rbind_list(trainData, testData)
  tidyData <- tidify(mergedData)
  if (!is.null(activityFilename))
    saveFile(mergedData, accessTime, activityMeanDataFilename)
  if (!is.null(activitySummaryFilename))
    saveFile(tidyData, accessTime, activitySummaryFilename)
  unlink(filenames["zipDir"], recursive = TRUE, force = TRUE)
  list(originalDataAccessTime = accessTime, activityMeanData = mergedData, activitySummaryData = tidyData)
}
