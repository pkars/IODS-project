# IODS week 6 data wrangling - looking into wide and long table formats
#
# Petteri Karsisto, 2020
#
# Data is the example data from Multivariate Analysis for the Behavioral Sciences, Second Edition
# (Vehkalahti and Everitt, 2019).

library(dplyr)
library(tidyr)

# Get the data (wide tables)
bprs <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt",
                   sep=" ", header = TRUE)
rats <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt",
                   sep="\t", header=TRUE)
# Check the data with some summaries
glimpse(bprs)
head(bprs, 5)

glimpse(rats)
head(rats, 5)

# Understanding the wide tables: here each subject is on their own row
# and each measurement in their own column. In this case the columns correspond 
# to the "time" dimension.

# Convert categorical variables to factors

# Convert to long form, add 'week' to BPRS data and 'Time' to RATS data

# Look at the long forms

# Save the data here
write.csv(bprs, "data/bprs.csv")
write.csv(rats, "data/rats.csv")

# Understanding the difference between wide and long table formats:
