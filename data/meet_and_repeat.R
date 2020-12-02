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
bprs$treatment <- as.factor(bprs$treatment)
bprs$subject <- as.factor(bprs$subject)
rats$ID <- as.factor(rats$ID)
rats$Group <- as.factor(rats$Group)

# Convert to long form, add 'week' to BPRS data and 'Time' to RATS data
bprs <- gather(bprs, key=weeks, value=bprs, -treatment, -subject) %>% 
  mutate(week = as.integer(substr(weeks, 5, 5)))

# Convert data to long form
rats <- rats %>%
  gather(key = WD, value = weight, -ID, -Group) %>%
  mutate(time = as.integer(substr(WD, 3, 5))) 

# Look at the long forms
glimpse(bprs)
head(bprs, 5)

glimpse(rats)
head(rats, 5)

# Save the data here
write.csv(bprs, "data/bprs.csv", row.names = FALSE)
write.csv(rats, "data/rats.csv", row.names = FALSE)

# Understanding the difference between wide and long table formats:
# Long tables have all measurements in one column, while other columns are
# the dimensions. Or coordinates of that measurement, if you will. So where
# the wide tables had each individual on one row, here we have multiple rows
# for each individual. Also in wide tables we had the time dimension aligned
# with columns (in these specific datasets, that is), while in long tables 
# the time information is contained in one column - as a coordinate.
#
# In essence: 
#   wide table = measurement is represented as a list of variables
#   long table = measurement is represented as key=value pairs
