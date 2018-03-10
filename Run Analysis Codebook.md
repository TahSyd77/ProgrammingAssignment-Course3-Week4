## Run_Analysis CodeBook

#### Input files:
1. Subject_test.txt
    1 variable (the subject id) - 2947 obs
    These are for the test group.
2. Features.txt
    2 variables (the feature id, and feature/measurement name)
    These features/measurements are used within the X_test.txt and X_train.txt input files.
3.  X_test.txt
    561 measurement variables defined in Features.txt above - 2947 obs
    These are for the test group.
4. y_test.txt
    1 variable (the activity value/id) - 2947 obs
    These are for the test group.
5. Subject_train.txt
    1 variable (the subject id) - 7352 obs 
    These are for the train group.
6. X_train.txt
    561 measurement variables defined in Features.txt above - 7352 obs
    These are for the train group.
7. y_train.txt
    1 variable (the activity value/id) - 7352 obs
    These are for the train group
8. Activity_labels.txt
   2 variables (the activity value/id, and activity name) -  6 obs
   Used by both groups.
    
#### Output files:
1.  Final2 dataset (Also see snapshot of 'Final2.jpg)
    679,734 obs of 10 variables:
    + Activity  1 of 6 values:  Walking, Walking-Upstairs, Walking-Downstairs, Sitting, Standing, Laying
    + Subject   The id of the test or train subject.
    + Measurement           The measurement result taken for the subject, for the various combinations of measurement variables
                              In this file, there will be multiple measurements for the same set of subject/measurement variables
    + Time Freq Domain      1 of 2 values:  Time or Freq to indicate the domain being tested
    + Body Gravity          1 of 2 values: Body or Gravity to indicate the movement driver
    + Acceleration Gyroscope  1 of 2 values:  Acceleration or Gyroscope to indicate the type of movement
    + Jerk                  1 value:  Jerk to indicate whether there was a jerk movement involved
    + Mag                   1 value:  Mag to indicate the whether magnitude was measured
    + Mean StdDev           1 of 2 values:  Mean or StdDev to indicate whether the measurement was for a mean, or standard deviation
    + XYZ Dimension         3 values:  X, Y, Z to indicate the dimension on which the measurement was taken
    Wherever one of the values indicated were NOT present, a 'NA' was added.
    
 2. Averages dataset/ 'TableofAverages.txt' (See snapshot of 'Averages.jpg')
    180 obs of 10 variables
    The variables for this file are the same as above, in Final2, with the exception of "Measurement".  In this file, all the               measurements were combined to form a mean for the specific combination of measurement variables.   Therefore, the measurement column     is not present, while a Mean column has been added to the far right of the table.
