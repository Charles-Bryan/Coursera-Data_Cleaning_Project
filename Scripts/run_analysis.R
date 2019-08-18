## Naming conventions in this document------------------------------------------
# variable names: underscore_separated - all lowercasewords separated by underscores
# function names: period.separated - all lowercasewords separated by periods such as as.numeric()
# sections of code: The start of new sections is denoted as below:
                        ##[section name] ------- until the end of line

## LIBRARY CALLS ---------------------------------------------------------------
library(dplyr)

## IMPORT DATA -----------------------------------------------------------------
# Read in the following files and if they are not there, throw an error:
#       Xtrain.txt              Xtest.txt               ytrain.txt
#       ytest.txt               features.txt            

# xtrain
xtrain_path <- "./data/UCI HAR Dataset/train/X_train.txt"
if(!file.exists(xtrain_path)){
        stop(paste("X_train.txt is not in the location", xtrain_path))}
xtrain <- read.table(xtrain_path)

# ytrain
ytrain_path <- "./data/UCI HAR Dataset/train/y_train.txt"
if(!file.exists(ytrain_path)){
        stop(paste("y_train.txt is not in the location", ytrain_path))}
ytrain <- read.table(ytrain_path)

# xtest
xtest_path <- "./data/UCI HAR Dataset/test/X_test.txt"
if(!file.exists(xtest_path)){
        stop(paste("X_test.txt is not in the location", xtest_path))}
xtest <- read.table(xtest_path)

# ytest
ytest_path <- "./data/UCI HAR Dataset/test/y_test.txt"
if(!file.exists(ytest_path)){
        stop(paste("y_test.txt is not in the location", ytest_path))}
ytest <- read.table(ytest_path)

# features 
features_path <- "./data/UCI HAR Dataset/features.txt"
if(!file.exists(features_path)){
        stop(paste("features.txt is not in the location", features_path))}
features <- read.table(features_path)

## MERGE DATA ------------------------------------------------------------------
# Merge the activity labels with the corresponding the train/test data and then
#       merge all the test and train data together

# Merge xtrain with ytrain and then merge xtest with ytest putting the activity in the last column
#       Last column selected rather than the first column to keep the ordering
#       of the features the same as provided in features.txt
train <- cbind(xtrain, ytrain)
test <- cbind(xtest, ytest)
# Merge the train and test dataframes together with train data appearing on top
train_test <- rbind(train, test)
# Relabel the activity column since it duplicates column V1
colnames(train_test)[length(train_test)] <- "Activity Label"

## EXTRACT: Mean and Std dev measurements ---------------------------------------
# My interpretation is to only get the variables with the text mean() or std().
#    I am purposely choosing not to include meanFreq() as I do not think that is desired.   

# Get a list of the indexes of features we want to keep
features_mean_std <- grep("(mean|std)[(][)]",features$V2)

# Reduce our large train_test dataframe to just the columns of mean and std data and activity
train_test_mean_std <- select(train_test, c(features_mean_std, length(train_test)))

## RELABEL: Activities and Variable Names --------------------------------------
# The existing naming convention for the activities (1 through 6) is not helpful.
#       We will relabel them with the labels provided in the study:
#"WALKING","WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS","SITTING", "STANDING", "LAYING"

# It is possible to automate using the "activity_labels" file to get these names, 
# but that seems a bit overkill for this purpose unless the names are likely to change

# First we convert the activities to factors instead of numeric.
train_test_mean_std$`Activity Label` <- as.factor(train_test_mean_std$`Activity Label`)
# Next we rename the factors to the ones provided in "activity_labels.txt"
levels(train_test_mean_std$`Activity Label`) <- c("WALKING","WALKING_UPSTAIRS",
                                                  "WALKING_DOWNSTAIRS", 
                                                  "SITTING", "STANDING", "LAYING")

# Now we want to rename the variable names as well. For the most part we will 
# reuse the names provided in the feature.txt and features_info.txt files with
# 6 exceptions:
# It seems to be unintentional, but 6 variable names have "BodyBody" in their title.
# We will replace this with just "Body" as the feature_info.txt file matches this interpretation.

feature_names <- as.character(features[features_mean_std,2])
features_names_fixed <- gsub("BodyBody","Body", feature_names)
names(train_test_mean_std) <- c(features_names_fixed, "Activity Label")


## CREATE a new tidy data set --------------------------------------------------
# Make the dataset of the average of each variable for each activity and each subject
variable_means <- aggregate(train_test_mean_std[,2:length(train_test_mean_std)-1], by=list("Activity Label" = train_test_mean_std$`Activity Label`), mean)

## SAVE the two dataframes -----------------------------------------------------
# We will save both data frames into a new folder called data/UCI HAR Dataset/tidy data folder of the project
if(!file.exists("./data/UCI HAR Dataset(tidy)")){dir.create("./data/UCI HAR Dataset(tidy)")}
save(train_test_mean_std,file="./data/UCI HAR Dataset(tidy)/train_test_mean_std.Rda")
save(variable_means,file="./data/UCI HAR Dataset(tidy)/variable_means.Rda")