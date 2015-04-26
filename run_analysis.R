# Utility functions

# Transforms activity code to names
rename_activity <- function(activity_id) {
  switch(activity_id,
         "1" = "WALKING",
         "2" = "WALKING_UPSTAIRS",
         "3" = "WALKING_DOWNSTAIRS",
         "4" = "SITTING",
         "5" = "STANDING",
         "6" = "LAYING"
  )
}

# Cleanup variable names
tidy_variables <- function(var) {
  var <- gsub("\\(\\)", "", var)
  var <- gsub("\\)", ".", var)
  var <- gsub("\\(", ".", var)
  var <- gsub(",", ".", var)
  var <- gsub("-", ".", var)
  var <- gsub("\\.\\.", ".", var)
  var <- gsub("\\.$", "", var)
  var
}

# Set working directory
setwd("/Users/abdullah.masud/mooc/coursera/getting_and_cleaning_data/getdata-013")

# Load library
library(dplyr)

# Read feature names
feature_list <- read.table("UCI HAR Dataset/features.txt")
feature_list[2] <- sapply(feature_list[2], tidy_variables)
feature_names <- feature_list[,"V2"]

#
# Read training data contained in 3 files
#
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Assign user friendly names
names(subject_train) <- c("Subject")
names(y_train) <- c("Activity")
names(X_train) <- feature_names

# Select only the mean and std fields
X_train <- X_train[,grep('\\.std\\.|\\.mean\\.',names(X_train))] 

# Combine training dataset
train <- cbind(subject_train, X_train, y_train)

#
# Read test data contained in 3 files
#
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Assign user friendly names
names(subject_test) <- c("Subject")
names(y_test) <- c("Activity")
names(X_test) <- feature_names

# Select only the mean and std fields
X_test <- X_test[,grep('\\.std\\.|\\.mean\\.',names(X_test))] 

# Combine test dataset
test <- cbind(subject_test, X_test, y_test)

#
# Merge training and test datasets
#
dat <- rbind(train, test)

# Rename Acvitity to user friendly names
dat$Activity <- sapply(dat$Activity, rename_activity)

# Calculate means for all variables grouped by Subject and Activity
grp_cols <- c("Subject", "Activity")
dots <- lapply(grp_cols, as.symbol)

output <- dat %>% 
  group_by_(.dots=dots) %>%
  summarise_each(funs(mean))

# Save result
write.table(output, file = "means.txt", row.names = FALSE)


