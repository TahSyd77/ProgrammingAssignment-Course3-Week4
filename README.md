# ProgrammingAssignment-Course3-Week4
## Datasets and files for Course 3, Week 4 programming assignment

The run_analysis.r function will read in 8 different tables of measurement data.  Each row of data, across the tables, contains a subject that is performing an activity, along with the associated measurements taken for the subject/activity combination.  A subject can perform the same activity multiple times resulting in multiple rows of data for that subject and activity combination.  The subjects performing the activities were split into a 'test' group and a 'train'-ing group.  Thus there are 3 tables for each group:
1. List of the subject performing the activity for each row of table data.  There are 1-30 subjects possible.
2. List of the activity being performed for each row of table data.  There are 1-6 activity types.
3. Table of different measurements taken for each subject/activity combination.

There are also 2 additional tables:
1. Table that sequentially numbers each feature (eg. measurement/column in the measurement file), along with the corresponding name of the feature.  There are 2 columns in this table:  1) Feature id/number and 2) Feature Name.
2. Table that identifies the activity that relates to each activity value (1-6) in the list of activities file.  There are 2 columns in this file:  1) the activity value (1-6), and 2) the corresponding activity name.

After reading in the table data, the run_analysis function will:  Extract only the measurements of the mean and standard deviation on each measurement.  The tables will be combined, the 3 within each group, and then the 2 groups' tables.  The column names are made more descriptive, and the activity values(1-6) are replaced with the actual activity name.  This produces one dataset of the mean and standard deviation data.  The final task is to calculate the mean for each subject/activity combination (taking the mean of all rows representing a subject/activity pair), to be captured in a second dataset.
