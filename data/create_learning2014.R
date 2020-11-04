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

# Task 1: Create 'data' folder and a script (i.e. this file) [0pt]

# Task 2: Read and explore data, with commentary [1pt]
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
