# IODS 2020 Week 2 - Data wrangling script
#
# Create a data set for data analysis. 
#
# Data is based on "JYTOPKYS2" study data, available from here:
#  (data)  https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS3-data.txt
#  (metadata) https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS2-meta.txt
#
# Author: Petteri Karsisto
# Year: 2020

# Import external libraries
library(dplyr)

# Task 1 ------------------------------------------------------------------
# Create 'data' folder and a script (i.e. this file) [0pt]


# Task 2 ------------------------------------------------------------------
# Read and explore data, with commentary [1pt]

full_data <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", 
                        sep="\t", header=TRUE)
# Checking the first rows of data...
# Looks like most of the data is numbers - which is expected, as the data is
# questionnaire results. There are also some classification data (Age, gender).
head(full_data, 10)

# See the data structure...
# 183 obs. of 60 variables. I.e. 183 rows and 60 columns of data points.
# "gender" column contains strings, others are integers.
str(full_data)


# Task 3 ------------------------------------------------------------------
# Create analysis dataset [1pt]

# Filter out rows where Points == 0
full_data <- filter(full_data, Points > 0)

# Create combination variables as defined in metadata file
# Deep approach = "Seeking Meaning" + "Relating Ideas" + "Use of Evidence"
#   Seeking Meaning = D03 + D11 + D19 + D27
#   Relating Ideas = D07 + D14 + D22 + D30
#   Use of Evidence = D06 + D15 + D23 + D31
# Note: All columns are of format "D\d\d", so we can use regular expression here
deep <- select(full_data, matches(c("D\\d\\d"), perl = TRUE))
# Sum over "deep" variables and normalize by number of variables
deep_adj <- rowSums(deep) / length(colnames(deep))

# Surface approach:
#   Lack of Purpose = SU02 + SU10 + SU18 + SU26
#   Unrelated Memorising = SU05 + SU13 + SU21 + SU29
#   Syllabus-boundness SU08 + SU16 + SU24 + SU32
surf <- select(full_data, matches(c("SU\\d\\d"), perl = TRUE))
surf_adj <- rowSums(surf) / length(colnames(surf))

# Strategic approach
#   Organized Studying = ST01 + ST09 + ST17 + ST25
#   Time Management = ST04 + ST12 + ST20 + ST28
stra <- select(full_data, matches(c("ST\\d\\d"), perl = TRUE))
stra_adj <- rowSums(stra) / length(colnames(stra))

# Create the dataset (forcing the column order with hard-coding)
dset <- full_data[c("gender", "Age", "Attitude")]
dset$deep <- deep_adj
dset$stra <- stra_adj
dset$surf <- surf_adj
dset$points <- full_data$Points  # Points are renamed with this...

# Age and Attitude have capitalized column names, so need to rename them
dset <- rename_with(dset, tolower, any_of(c("Age", "Attitude")))

# Check the dataset
str(dset)  # 166 obs. of 7 variables

# Task 4 ------------------------------------------------------------------

# Save the data
write.csv(dset, "data/learning2014.csv", row.names=FALSE)

# Read the data
reread_table <- read.csv("data/learning2014.csv")
str(reread_table)
head(reread_table, 5)
# Looks correct :)