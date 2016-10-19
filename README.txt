README.md

Week 4 - peer reviewed assignment
Goal - create a tidy dataset from a desperately complicated set of samsung biometric files and perform some prelim analysis.

Each of the process steps and tables/column variables are detailed below.


******
TIDY TABLES
Generally, I accomplished creating the tidy tables by:
1. Loaded the training result values (columns: 'V1' to 'V561'), training subject numbers ('subject') and training labels ('label') from their respective files. Merged them together into one file. I added a dataset variable to be able to back track which file response data came from.
        data table = "train". 
        columns: 'V1' to 'V561', 'dataset', 'subject', 'label'
        
        Assumption: all 3 files were mergable using row numbers only, i.e. there was
        no key!
        
        Note: the 'dataset' coulumn was inserted to state that the values came from
        the training data file (vs test) 
        
2. Repeated the process for the Test data.
        data table = "test"
        columns:  same as above

3. Combined the Train and Test data (row binding - shared same column names)
        data table = "combined_data"
        
4. Reorganized the combined_data table to move the features column headers to categorical variables (making it very long). 'Interm' contains the categorical variables from the V1to V561 columns.
        data table = "reshaped_data"
        columns: 'dataset', 'label', 'subject', 'interm', 'value'
        
5. Made seperate data table of the features names (i called them 'measurement' and 'interm') and merged them into the combined table using the 'interm' column. Removed 'interm' column.
        data table = "data"
        columns: "dataset" "label"   "subject" "measurement"   
6. I then split the 'measurement' column into 'measure', 'stat', and 'axis'. This eased further analysis. 
        data table = "data" (recycled the name from above)
        columns: "dataset" "label"   "subject" "value"   "measure" "stat"    "axis" 
         
7. I loaded the activity data into a table and merged with 'data' by the 'label' column. This gave me the entire data set which could be further pulled apart for analysis as needed.
        data table = "complete_data"
        columns: "dataset","subject","value","measure","stat","axis","activity"
        
        Note: This is the highest level table with all results.
        
        
******
ANALYSIS
To analyze the data set I:
1. filtered the data to include only values that used 'mean' or 'stdev'as the statistic.
2. from this data I grouped by 'activity', 'subject', ['measure', 'stat', 'axis']
- these last 3 items where previously combined as the "features" (features.txt)
3. summarized the 'values' ,i.e. the numeric response data by the above groupings and exported this file using write.table as text file using " " separator.


******
SOURCE
The files were sourced from the following:
location: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

1. unzipped the files into my local drive - subfolders for 'train' and 'test' data already existed within source
2. set the location (filepath) for the sub folders for easy access to data in the R code
3. used read.table load the .txt files into R (see TIDY)


*** END 
tt101816