# IODS 2020 Week 3 - Data wrangling script
#
# Create a data set for data analysis. 
#
# Author: Petteri Karsisto
# Year: 2020
#
# Data is "Student Performance Data Set" by P. Cortez and A. Silva.
# https://archive.ics.uci.edu/ml/datasets/Student+Performance
#
# Reference: 
#   P. Cortez and A. Silva. Using Data Mining to Predict Secondary School Student 
#     Performance. In A. Brito and J. Teixeira Eds., Proceedings of 5th 
#     FUture BUsiness TEChnology Conference (FUBUTEC 2008) pp. 5-12, Porto, Portugal, 
#     April, 2008, EUROSIS, ISBN 978-9077381-39-7.
#     http://www3.dsi.uminho.pt/pcortez/student.pdf
#
library(dplyr)

# Read data in
mat <- read.csv("data/student-mat.csv", header=TRUE, sep=";")
head(mat)
str(mat)

por <- read.csv("data/student-por.csv", header=TRUE, sep=";")
head(por)
str(por)

# A list of identifier columns for joining the dataset
# NOTE: There are no id numbers for students, which is why we do this.
join_by_cols <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery", "internet")

joined <- merge(mat, por, by = join_by_cols, suffixes = c(".mat", ".por"))
head(joined)
str(joined)

# Duplicate entry removal
# -- Copypasted solution from Datacamp course --

# print out the column names of 'math_por'
colnames(joined)

# create a new data frame with only the joined columns
alc <- select(joined, one_of(join_by_cols))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(mat)[!colnames(mat) %in% join_by_cols]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(joined, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

### --- ###

# Create a logical value showing high alcohol usage (avg. consumption > 2)
alc$alc_use <- rowMeans(alc[c("Dalc", "Walc")])
alc$high_use <- alc$alc_use > 2

# glimpse at the new combined data
glimpse(alc)

# Save data to disk
# Current working directory is the home folder for the project
write.csv(alc, "data/alc.csv", row.names=FALSE)
