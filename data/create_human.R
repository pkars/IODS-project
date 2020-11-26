library(dplyr)

# Read "Human development" and "Gender inequality" datasets
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", 
               stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", 
                stringsAsFactors = F, na.strings = "..")

# Exploration: print dimensions, structure and summary for both datasets
dim(hd)
str(hd)
summary(hd)

dim(gii)
str(gii)
summary(gii)

# Rename the columns with shorter names
new_hd_colnames <- c("rankHDI", "HDI", "lifeExpectAtBirth", "expectedEduYears", "meanEduYears", "GNI", "GNIRankMinusHDIRank")
new_gii_colnames <- c("rankGII", "GII", "maternalMortalityRate", "adolescentBirthRate", "femaleRatioParliament", "edu2F", "edu2M", "labF", "labM")

# Country is the second column, don't rename that as it is already fine
names(hd)[-2] <- new_hd_colnames
names(gii)[-2] <- new_gii_colnames

# Mutate the “Gender inequality” data and create two new variables: 
# - ratio of Female and Male populations with secondary education in each country
# - ratio of labour force participation of females and males in each country
gii <- gii %>% mutate(edu2Ratio = edu2F / edu2M) %>% mutate(labRatio = labF / labM)
#str(gii) # Check that they exist

# Join datasets by country and save the dataframe
human <- inner_join(hd, gii, by="Country")
write.csv(human, "data/human.csv", row.names=FALSE)

# Week 5 data wrangling starts here
