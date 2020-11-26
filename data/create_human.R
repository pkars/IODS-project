# Create a dataset of human development indicators
# Petteri Karsisto, 2020
#
# Original data from Human Development Reports by United Nations Development Programme
# See: http://hdr.undp.org/en/content/human-development-index-hdi
# Used datasets were provided by IODS lecturers

library(dplyr)
library(stringr)

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

# Rename the columns with shorter names (names modified in week 5)
new_hd_colnames <- c("HDI.rank", "HDI", "exp.life.years", "exp.edu.years", "mean.edu.years", "GNI", "GNIRankMinusHDIRank")
new_gii_colnames <- c("GII.rank", "GII", "mat.mort.rate", "adol.birth.rate", "parl.F.ratio", "edu2.F", "edu2.M", "lab.F", "lab.M")

# Country is the second column, don't rename that as it is already fine
names(hd)[-2] <- new_hd_colnames
names(gii)[-2] <- new_gii_colnames

# Mutate the “Gender inequality” data and create two new variables: 
# - ratio of Female and Male populations with secondary education in each country
# - ratio of labour force participation of females and males in each country
gii <- gii %>% mutate(edu2.ratio = edu2.F / edu2.M) %>% mutate(lab.ratio = lab.F / lab.M)
#str(gii) # Check that they exist

# Join datasets by country and save the dataframe
human <- inner_join(hd, gii, by="Country")
#write.csv(human, "data/human.csv", row.names=FALSE) # No need to save at this point anymore

# Week 5 data wrangling starts here
# Using a combined dataset based on "Human development" and "Gender inequality" from above
dim(human)
str(human)
summary(human)
# 'data.frame':	195 obs. of  19 variables:
# $ HDI.rank           : int  : Rank of Human Development Index
# $ Country            : chr  : Country name
# $ HDI                : num  : Human Development Index
# $ exp.life.years     : num  : Life expectancy at birth
# $ exp.edu.years      : num  : Expected years in education
# $ mean.edu.years     : num  : Average years in education
# $ GNI                : chr  : Gross National Income per capita
# $ GNIRankMinusHDIRank: int  : Difference of GNI rank and HDI rank
# $ GII.rank           : int  : Rank of Gender Inequality Index
# $ GII                : num  : Gender Inequality Index
# $ mat.mort.rate      : int  : Maternal mortality rate
# $ adol.birth.rate    : num  : Adolescent birth rate
# $ parl.F.ratio       : num  : Ratio of females in the parliament
# $ edu2.F             : num  : Fraction of females with secondary or higher education
# $ edu2.M             : num  : Fraction of males with secondary or higher education
# $ lab.F              : num  : Fraction of females in the work force
# $ lab.M              : num  : Fraction of males in the work force
# $ edu2.ratio         : num  : edu2.F / edu2.M
# $ lab.ratio          : num  : lab.F / lab.M

# GNI has values as strings with a comma as thousands separator
# Remove the comma and convert to number
human$GNI <- str_replace(human$GNI, ",", "") %>% as.numeric

# Exclude unnecessary columns
to_keep = c("Country", "edu2.ratio", "lab.ratio", "exp.edu.years", "exp.life.years", "GNI", 
            "mat.mort.rate", "adol.birth.rate", "parl.F.ratio")

human <- dplyr::select(human, one_of(to_keep))

# Filter rows where is at least one NA element
human <- filter(human, complete.cases(human))

# Remove regions, which are the last 7 rows
tail(human, 8)  # Check that above comment is correct, 8th-to-last row is a country
last <- nrow(human) - 7
human <- human[1:last, ]

# Label rows with Country name, and drop Country column
rownames(human) <- human$Country
human <- select(human, -Country)  # Notice the minus!

# Check result: 155 rows, 8 variables -- OK!
str(human)

# Save with row names!
write.csv(human, "data/human.csv", row.names=TRUE)


