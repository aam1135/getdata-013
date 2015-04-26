# getdata-013
Getting and Cleaning Data Coursera Project

The provided script run_analysis.R performs the following.

1. Read the training and test data files (X variables, y variable, subject identifiers)
2. Read the feature names
3. Perform cleanup procedure on column names
4. Bind 3 files for each of training and test datasets
5. Append training and test datasets together
6. Performs mean calculation on "mean" and "sd" labeled measurement variables broken down by "Subject" and "Activity"
7. Update the "Activity" field to user friendly names
8. Saves the means to a file
