## This script loads the data for this project which can be found at the following link:
#       http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# Check if the data has been set up already
if(!file.exists("./data")){
        dir.create("./data")

        # Download the data if it is not there
        dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(dataUrl, destfile="./data.zip")
        
        # Unzip the downloaded zip file
        zipF<- "./data.zip"
        outDir<-"./data"
        unzip(zipF,exdir=outDir)
        
        # Remove the zip file
        unlink("./data.zip")
}
