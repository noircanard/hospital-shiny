###hp_mod2ndEd_hospitals.R!###################################################
#
# WARNING: This Script cant be run until
# C:\Users\Romanee\Desktop\ScriptLibrary\Hospital_project\t0_xlsx_csv_short
# has been run first
#!############################################################################
# Clear workspace
rm(list = ls())
##############################################################################
# load in packages
require(gdata)
# filepath to perl
perl <- "C:/strawberry/perl/bin/perl5.28.0.exe"
# filepath to xls file
# this is a sup file that as all the PHN and LGA
xls <-
  "C:/Users/Romanee/Desktop/DataLibrary/MyHospital/supplimentary_data/CG_LGA_2017_PHN_2017.xls"
#
# sheetNames(xls=xls, perl = perl) xls file has 6 sheets (I want table 3)

# read in workbook
dfx <- read.xls(xls,
                sheet = 4,
                perl = perl,
                stringsAsFactors = FALSE)
# rename headers
colnames(dfx) <-
  data.frame(lapply(dfx[3, ], as.character), stringsAsFactors = FALSE)
# subset colmns i want
dfx.1 <- (dfx[-c(1:3), c(1:6)])
# drop cases where no lga (these are tail NA's)
dfx.2 <- dfx.1[dfx.1$LGA_NAME_2017 != "", ]
# write to csv
write.csv(dfx.2, "CG_LGA_2017_PHN_2017.csv", row.names = F)
# subset for merging with Hospital.csv  # further down
dfx.3 <- unique(dfx.2[, c(1:4)])
#####################################
#
# assign a workign directory
wd.2 <-
  "C:/Users/Romanee/Desktop/DataLibrary/MyHospital/processed_csv"
# set wd
setwd(wd.2)
# read in Hospitals.csv
df <- read.csv("Hospitals.csv", stringsAsFactors = FALSE)
#######################################################
# Create new fields (bed_grp, ED, region, specialist, size)
##############################################
#
# bed group
df$bed_grp <-   ifelse(df$Beds == "<50", 1,
                       ifelse(df$Beds == "50-99", 2,
                              ifelse(
                                df$Beds == "100-199", 3,
                                ifelse(df$Beds == "200-500", 4,
                                       ifelse(df$Beds == ">500", 5,
                                              0))
                              )))
df$bed_grp[is.na(df$bed_grp)] <- 0

#################################################
# Description
#
# emergency department
df$ED <-
  ifelse(grepl("emergency department", df$Description) == T, 1, 0)
#
# regional
df$Regional <-
  ifelse(grepl("REGIONAL", toupper(df$Description)) == T, 1, 0)
#
# Size (1=small, 2= medium, 3=Large, 4= Major, 0 = unknown)
df$Size <- ifelse(grepl("SMALL", toupper(df$Description)) == T, 1,
                  ifelse(grepl("MEDIUM", toupper(df$Description)) == T, 2,
                         ifelse(
                           grepl("LARGE", toupper(df$Description)) == T, 3,
                           ifelse(grepl("MAJOR", toupper(df$Description)) == T, 4,
                                  0)
                         )))
#
# specialist
df$Special <-
  ifelse(grepl("SPECIALIST", toupper(df$Description)) == T, 1, 0)
head(df$Website)
df$web_address <- ifelse(grepl("^w{3}",df$Website) == T, paste("https://", df$Website, sep = ""),
                         ifelse(grepl("^http:", df$Website)==T, gsub("http:","https:", df$Website),
                                ifelse(grepl("w|h",df$Website) == F, "https://www.myhospitals.gov.au",
                                       df$Website)))



head(df)
#################################################################
# Correct names before writting to csv
names(df) <-
  c(
    "Hospital",
    "Ph_no",
    "Street",
    "Suburb",
    "Pcode",
    "State",
    "LHN",
    "PHN",
    "Website",
    "Description",
    "Sector",
    "Beds",
    "Lat",
    "Long",
    "bed_grp",
    "ED",
    "Regional",
    "Size",
    "Special",
    "web_address"
  )
#
# write new Hospital file
write.csv(df, "2ndEd/Hospital.csv", row.names = F)
#######################################################################
#
#  Merge hospital file with PHN/LGA file
################
#
# this will give a full picture as to which LGA a hospital works to +
# what otehr hospitals are in its network
#
# give empty PHN values a name
df$PHN[df$PHN == ""] <- "none"
# merge df and dfx.3 by PHN
df_new <- merge(df, dfx.3 , by.x = "PHN", by.y = "PHN_NAME_2017")
# write to csv
write.csv(df_new, "2ndEd/Hospital_PHN_extra.csv", row.names = F)
#
#################################################################################
#!END   ################hp_mod2ndEd_hospitals.R!################################
#################################################################################