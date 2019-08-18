There are two scripts that can be used in the project located in the ./Scripts/ folder: Loading Data.R and run_analysis.R

Loading Data.R          This program is used to download the UCI HAR Dataset from the following link:
                        https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
                        
                        This script checks to see if there is a folder "./data" already created. If this folder does not exist,
                        then it is created and the data is downloaded. Additionally, it unzips the downloaded file and then 
                        removes the zip file.
                        
                        If this folder already exists, nothing is done.
                        
                        
run_analysis.R          This script does all of the remaining work of reading the downloaded data and creating tidy data sets. 
                        The final step is saving the following two tidy datasets in the folder ./data/UCI HAR Dataset(tidy)
                        dataset 1: train_test_mean_std
                        dataset 2: variable_means



The following is a more detailed breakdown of run_analysis.R mainly taken from the annotations within the code:

Naming conventions ----------------------------------------------------------
variable names: underscore_separated - all lowercasewords separated by underscores
function names: period.separated - all lowercasewords separated by periods such as as.numeric()
sections of code: The start of new sections is denoted as below:
                        ##[section name] ------- until the end of line

LIBRARY CALLS ---------------------------------------------------------------
library(dplyr)

Ordered steps of run_analysis:

IMPORT DATA -----------------------------------------------------------------
Read in the following files and if they are not there, throw an error:
      Xtrain.txt              Xtest.txt               ytrain.txt
      ytest.txt               features.txt            

MERGE DATA ------------------------------------------------------------------
Merge the activity labels with the corresponding train/test data and then
      merge all the test and train data together

EXTRACT: Mean and Std dev measurements ---------------------------------------
My interpretation is to only get the variables with the text mean() or std().
   I am purposely choosing not to include meanFreq() as I do not think that is desired. 

RELABEL: Activities and Variable Names --------------------------------------

The existing naming convention for the activities (1 through 6) is not helpful. We will relabel 
them with the labels provided in the study:
"WALKING","WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS","SITTING", "STANDING", "LAYING"

We want to rename the variable names as well. For the most part we will reuse the names provided 
in the feature.txt and features_info.txt files with 6 exceptions. It seems to be unintentional, 
but 6 variable names have "BodyBody" in their title. We will replace this with just "Body" as the
feature_info.txt file matches this interpretation.

CREATE a new tidy data set --------------------------------------------------
Make the dataset of the average of each variable for each activity and each subject

SAVE the two dataframes -----------------------------------------------------
We will save both data frames into a new folder called data/UCI HAR Dataset/tidy data folder of the project