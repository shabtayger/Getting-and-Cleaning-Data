# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for 
#    each activity and each subject.

read.zip.url <- function(url) {
  zipfile <- tempfile()
  download.file(url = url, destfile = zipfile, quiet = TRUE)
  zipdir <- tempfile()
  dir.create(zipdir)
  unzip(zipfile, exdir = zipdir) # files="" so extract all
  files <- list.files(zipdir)
  if (length(files) > 1 || files[1] != "UCI HAR Dataset")
    stop("UCI HAR Dataset is expected, but multiple files in zip: ", paste(files, collapse = ", "))
  file <- paste(zipdir, files[1], sep="/")
  dirs = c(paste(file, "train", sep="/"), paste(file, "test", sep="/"))
  data <- lapply(dirs, function(x) lapply(list.files(x), readlines))
  data
}


url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dt <- read.zip.url(url)