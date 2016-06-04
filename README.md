# Getting and Cleaning Data - An Overview

Hi Fellows,

I created one "big" script to do the following:

1. Check whether the data file or the unzipped folder already exist in your current working directory. You may have to set a working directory before if you did not do so already
2. Depending on, whether the files/directory exists or not, it is downloaded and unzipped.
3. Next, all required files for the analysis are read via a for-loop and the fread-function from data.table
4. Column names are assigned as in the feature.txt file. Unfortunately the data description does not indicate clearly if the ordering of the values corresponds to the variable labels. Same is true for the subjects so this has to be assumed to proceed. Furthermore the data should not be reordered before the respective labes have been added to the file!
5. The respective SubjectIDs and Activites are added to the training and test data sets and renamed to appropiate column names.
6. Test and training sets are combined and only mean() and std() columns are selected. This has been another interpretation issue. I did exclude the meanFreq() and the angle vectors as it is no direct mean or std of each measurement itself. At least thats how I understood the data.
7. After that I relabeled and removed the "_" the Activity column in the resulting data set, using the pipe operateor %>%. 
8. The invidual variable names have also been reformatted to make them more readable.
9. Finally the Tidy data set is created, ordered and written in a csv-file as indicated in the assignment description. Every row corresponds to a SubjectID/Activity combinations and has been aggregated using the mean() function.

I hope this, together with the comments in the script, makes everything easier to understand.

BR,
Florian
