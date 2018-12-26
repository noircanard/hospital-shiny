###xlsx_csv_short.R!###########################################################
#
# The following script converts a series of xlsx files into csv files
# for later use in DV.
# (Note:  drops all columns without name (i.e. NA), these are extra info that
#          im choosing to leave out for now)
#
# ... and generates metadata files as it goes
#           (1 - list of WB, TABS, csv; 2 - list of csv, field names)
#
#
# xlsx files used in this program were previously downloaded from:
# https://www.myhospitals.gov.au/about-the-data/download-data
#
#
# *An idea for imporving this code would be to:
#  a) download the xlsx files directly from the website and convert via the
#      script ...
#       e.g. https://www.myhospitals.gov.au/excel-datasheets/[excelworkbook name]
#
#  b) one loop for ALL sheets
#
#
#
#!############################################################################
# Clear workspace
rm(list = ls())
##############################################################################
# Load packages
#
# openxlsx is used to read in xlsx files
library("openxlsx")
#
# gdata is used to read in xls files (required perl)
library("gdata")
############################################################
# location of perl
perl <- "C:/strawberry/perl/bin/perl5.28.0.exe"
############################################################
# Define working directories
#  wd.1 - unprocessed hospital data ;
#  wd.2 folder for csv files
#
wd.1 <-
  "C:/Users/Romanee/Desktop/DataLibrary/MyHospital/unprocessed_downloaded10082018"
wd.2 <-
  "C:/Users/Romanee/Desktop/DataLibrary/MyHospital/processed_csv"
############################################################
# Set working Dir:
setwd(wd.1)
############################################################
# generate a list of all xlsx files in unprocessed data folder
#
xlsxfiles <- list.files(pattern = "xlsx")
#############################################################################
# Read in ALL xlsx files save as csv
#  + create metadata file as go
#######################
# sheet 1
#######################
#
# Create an empty dataframe to pop with MD
df_tab1 <- data.frame()
############################################################
# loop for first sheet
for (i in 1:8) {
  #1. set working dir. for xlsx files
  setwd(wd.1)
  #2. read xlsx file sheet 1
  wb1 <- read.xlsx(xlsxfiles[i], 1)
  #3. identify first non NA row in column 2
  nms <- min(which(!is.na(wb1[, 2])))
  #4. name columns row identified in step 3
  colnames(wb1) <- wb1[nms,]
  #5. drop all rows before first data row
  wb1.0 <- wb1[-c(1:nms),]
  #6. drop all columns where header is NA
  wb1.1 <- wb1.0[!is.na(names(wb1.0))]
  #7. assign sheet name to "TAB"
  TAB <- gsub(" ", "_", getSheetNames(xlsxfiles[i])[1])
  #8. create dataframe for md entry
  df <- data.frame(
    wb = xlsxfiles[i],
    TAB = TAB,
    TAB2 = "",
    TAB3 = "",
    Rows = dim(wb1.1)[1],
    Columns = dim(wb1.1)[2]
  )
  #9. append new md dataframe to base dataframe
  df_tab1 <- rbind(df_tab1, df)
  #10 set working dir. for csv files
  setwd(wd.2)
  #11. write dataframe to csv file
  write.csv(wb1.1, paste(TAB, ".csv", sep = ""), row.names =   F)
}
#######################
# sheet 2
#######################
#
# THIS REPEATS STEPS IN LOOP ABOVE with exception of sheet number
df_tab2 <- data.frame()
for (i in 3:5) {
  setwd(wd.1)
  wb1 <- read.xlsx(xlsxfiles[i], 2)
  nms <- min(which(!is.na(wb1[, 2])))
  colnames(wb1) <- wb1[nms,]
  wb1.0 <- wb1[-c(1:nms),]
  wb1.1 <- wb1.0[!is.na(names(wb1.0))]
  TAB2 <- gsub(" ", "_", getSheetNames(xlsxfiles[i])[2])
  df <- data.frame(
    wb = xlsxfiles[i],
    TAB = "",
    TAB2 = TAB2,
    TAB3 = "",
    Rows = dim(wb1.1)[1],
    Columns = dim(wb1.1)[2]
  )
  df_tab2 <- rbind(df_tab2, df)
  setwd(wd.2)
  write.csv(wb1.1, paste(TAB2, ".csv", sep = ""), row.names =   F)
}
#######################
# sheet 3
#######################
#
# THIS REPEATS STEPS IN LOOP ABOVE with exception of sheet number
#
df_tab3 <- data.frame()
#
for (i in 4:5) {
  setwd(wd.1)
  wb1 <- read.xlsx(xlsxfiles[i], 3)
  nms <- min(which(!is.na(wb1[, 2])))
  colnames(wb1) <- wb1[nms,]
  wb1.0 <- wb1[-c(1:nms),]
  wb1.1 <- wb1.0[!is.na(names(wb1.0))]
  TAB3 <- gsub(" ", "_", getSheetNames(xlsxfiles[i])[3])
  df <- data.frame(
    wb = xlsxfiles[i],
    TAB = "",
    TAB2 = "",
    TAB3 = TAB3,
    Rows = dim(wb1.1)[1],
    Columns = dim(wb1.1)[2]
  )
  df_tab3 <- rbind(df_tab3, df)
  setwd(wd.2)
  write.csv(wb1.1, paste(TAB3, ".csv", sep = ""), row.names =   F)
}
###############################################################################
# xls file (just the one)
#
# set working dir forxls file
setwd(wd.1)
#
# Genreate a list of all xls files in dir.
xlsfiles <-  list.files(pattern = "xls$")
#
# workbook has 2 sheets - both read in here
dfxls1 <- read.xls(xlsfiles[1], sheet = 1, perl = perl)
dfxls2 <- read.xls(xlsfiles[1], sheet = 2, perl = perl)
#
# Sheets one and two only differ by time period
# Add new column to both for tiem period
dfxls1$'time period' <- "2012-13"
dfxls2$'time period' <- "2011-12"
#
# rename columns for both dataframes
colnames(dfxls1) <-
  data.frame(lapply(dfxls1[2,], as.character), stringsAsFactors = FALSE)
colnames(dfxls2) <- names(dfxls1)

#
# drop first two rows of both dataframes
dfxls1.1 <- (dfxls1[-c(1, 2),])
dfxls2.1 <- (dfxls2[-c(1, 2),])
#
# append one df to the other
can_wait <- rbind(dfxls1.1, dfxls2.1)
colnames(can_wait)[1] <- "Hospital"
#
# assign sheet name to "TAB"
TABx <-  gsub("-", "_", gsub(".xls", "", xlsfiles[1]))
#
# Create dataframe for md
df_tabx <-
  data.frame(
    wb = xlsfiles[1],
    TAB = TABx,
    TAB2 = "",
    TAB3 = "",
    Rows = dim(can_wait)[1],
    Columns = dim(can_wait)[2]
  )
#
# set working dir for csv files
setwd(wd.2)
#
# write new dataframe to csv
write.csv(can_wait, paste(TABx, ".csv", sep = ""), row.names =   F)
#
################################################################################
# Metadata
#
##############################
# md1
##############################
# list of excel files - Tabs# - csvfiles -  rows - cols - raw data location
#
# append each md dataframe create in the four cases above (sheet1,2,3 and xls)
md <- rbind(df_tab1, df_tab2, df_tab3, df_tabx)
# new field for csv name (2 out of 3 will be empty)
md$CSVfile <- paste(md$TAB, md$TAB2, md$TAB3, ".csv", sep = "")
# rename col1
names(md)[1] <- "Excelfile"
# create new field for raw data file location
md$rawdata_loc <- wd.1
# rearange columns
md <- md[, c(1:4, 7, 5, 6, 8)]
#
# write to csv
write.csv(md, "metadata/metadata_pt1.csv", row.names =   F)
#
###############################
# md2
###########
# list of field names - name class - file name
# set working dir:
setwd(wd.2)
# list of all csv files
#
csvfiles <- list.files(pattern = "csv")
# create empty dataframe
df <- data.frame()
# loop for all field names and classes
#
for (i in 1:length(csvfiles)) {
  cldf <- data.frame(FieldName = names(read.csv(csvfiles[i])))
  # second column is each variables class [using sapply (dataframe, function)]
  cldf$Class <- sapply(read.csv(csvfiles[i]), class)
  cldf$filename <- csvfiles[i]
  df <- rbind(df, cldf)
}

# write as csv
write.csv(df , "metadata/metadata_pt2.csv", row.names =   F)
#
#################################################################################
#!END ############################xlsx_csv_short.R!#############################
#################################################################################