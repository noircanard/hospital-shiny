#hp_mod2ndEd_all_else.R!#########################################################
#
# WARNING: This Script cant be run until
# C:\Users\Romanee\Desktop\ScriptLibrary\Hospital_project\t0_xlsx_csv_short
# has been run first
#################################################################################
#
# all files in processed_csv moved to 2ndEd and modified as required
#
# modifications:
#    i) <5 = 1
#    ii) charicater >> numeric where appropriate
#   not done yet
#    iii) Time period has two versions
#               a) yyyy-yy, and
#               b) yyyy-yy Q# (mmm-mmm yyyy))
#  where yyyy-yy rename finYear
#  where yyyy-yy Q# ... split into three fields finYear , Q, and  Quarter
#      finYear =  yyyy-yy ; Q  = Q#, Quarter = mmm-mmm yyyy
#   (or could be four : year = yyyy)
#
# ! date formating for files listed below
# 1 Average_length_of_stay
# 3 Comparable_Cost_of_Care
# 4 Cost_per_NWAU
# 7 Intended_procedure
# 9 Patient_admissions
# 10 Patients_seen_on_time
# 11 Rate_of_SAB
# 12 Specialty_of_surgeon
# 13 Time_in_ED
# 14 Time_in_ED_-_within_4_hrs


# ! Need to rename field Local Hospital Network  LHN to LHN
# 1 Average_length_of_stay
# 3 Comparable_Cost_of_Care
# 4 Cost_per_NWAU
# 5 Hospital_services
# 7 Intended_procedure
# 9 Patient_admissions
# 10 Patients_seen_on_time
# 11 Rate_of_SAB
# 12 Specialty_of_surgeon
# 13 Time_in_ED
# 14 Time_in_ED_-_within_4_hrs
# 15 Urgency_category
#!############################################################################
# Clear workspace
rm(list = ls())
##############################################################################
# assign a workign directory
wd.2 <-
  "C:/Users/Romanee/Desktop/DataLibrary/MyHospital/processed_csv"
wd.3 <-
  "C:/Users/Romanee/Desktop/DataLibrary/MyHospital/processed_csv/2ndEd"
# set wd
setwd(wd.2)
csvfiles <- list.files(pattern = "csv")
# Write over exsiting files to update tiem.period field
# new feild FinYear
for (i in c(1, 3:4, 7, 9:15)) {
  df <- read.csv(csvfiles[i], stringsAsFactors = FALSE)
  df$FinYear <-   substr(df$Time.period, 1, 7)
  df$Q <- substr(df$Time.period, 9, 10)
  df$Quater <- substr(df$Time.period, 13, 20)
  df$Year <- substr(df$Time.period, 21, 24)
  colnames(df)[colnames(df) == "Local.Hospital.Network..LHN."] <-
    "LHN"
  dfn <- df[,apply(df,2,function(df) !all(df==""))]
  write.csv(dfn, csvfiles[i], row.names = F)
}


#####################################################################
# [1] "Average_length_of_stay.csv"
dfa <- read.csv(csvfiles[1], stringsAsFactors = FALSE)

for (i in c(7:10, 12)) {
  dfa[, i][dfa[, i] == "<5"] <- 1
  dfa[, i] <- as.numeric(dfa[, i])
}
write.csv(dfa, paste("2ndEd/", csvfiles[1], sep = ""), row.names = F)
########################################################################
# [2] "CG_LGA_2017_PHN_2017.csv"
write.csv(
  read.csv(csvfiles[2], stringsAsFactors = FALSE),
  paste("2ndEd/", csvfiles[2], sep = ""),
  row.names = F
)

######################################################################
# [3] "Comparable_Cost_of_Care.csv"
dfccc <- read.csv(csvfiles[3], stringsAsFactors = FALSE)

for (i in c(5:7)) {
  dfccc[, i] <- as.numeric(dfccc[, i])
}

write.csv(dfccc, paste("2ndEd/", csvfiles[3], sep = ""), row.names = F)

######################################################################
# [4] "Cost_per_NWAU.csv"
dfcp <- read.csv(csvfiles[4], stringsAsFactors = FALSE)

for (i in c(5:8)) {
  dfcp[, i] <- as.numeric(dfcp[, i])
}

write.csv(dfcp, paste("2ndEd/", csvfiles[4], sep = ""), row.names = F)
########################################################################
# [5] "Hospital_services.csv"
df5 <- read.csv(csvfiles[5], stringsAsFactors = FALSE)
colnames(df5)[colnames(df5) == "Local.Hospital.Network..LHN."] <-
  "LHN"
write.csv(df5,
          paste("2ndEd/", csvfiles[5], sep = ""), row.names = F)
# [6] "Hospitals.csv" # already gone
######################################################################
# [7] "Intended_procedure.csv"
dfip <- read.csv(csvfiles[7], stringsAsFactors = FALSE)

for (i in c(8:12)) {
  dfip[, i][dfip[, i] == "<5"] <- 1
  dfip[, i] <- as.numeric(dfip[, i])
}

write.csv(dfip, paste("2ndEd/", csvfiles[7], sep = ""), row.names = F)
########################################################################
# [8] "myhospitals_cancer_surgery_waiting_times_data.csv"
write.csv(
  read.csv(csvfiles[8], stringsAsFactors = FALSE),
  paste("2ndEd/", csvfiles[8], sep = ""),
  row.names = F
)

######################################################################
# [9] "Patient_admissions.csv"
dfpa <- read.csv(csvfiles[9], stringsAsFactors = FALSE)

for (i in 6) {
  dfpa[, i][dfpa[, i] == "<5"] <- 1
  dfpa[, i] <- as.numeric(dfpa[, i])
}

write.csv(dfpa, paste("2ndEd/", csvfiles[9], sep = ""), row.names = F)

######################################################################
# [10] "Patients_seen_on_time.csv"
dfpot <- read.csv(csvfiles[10], stringsAsFactors = FALSE)

for (i in c(8:9)) {
  dfpot[, i][dfpot[, i] == "<5"] <- 1
  dfpot[, i] <- as.numeric(dfpot[, i])
}

write.csv(dfpot, paste("2ndEd/", csvfiles[10], sep = ""), row.names = F)
######################################################################
# [11] "Rate_of_SAB.csv"
dfsab <- read.csv(csvfiles[11], stringsAsFactors = FALSE)

for (i in c(7:10)) {
  dfsab[, i][dfsab[, i] == "<5"] <- 1
  dfsab[, i] <- as.numeric(dfsab[, i])
}

write.csv(dfsab, paste("2ndEd/", csvfiles[11], sep = ""), row.names = F)
##########################################################################
# [12] "Specialty_of_surgeon.csv"
dfss <- read.csv(csvfiles[12], stringsAsFactors = FALSE)

for (i in c(8:12)) {
  dfss[, i][dfss[, i] == "<5"] <- 1
  dfss[, i] <- as.numeric(dfss[, i])
}

write.csv(dfss, paste("2ndEd/", csvfiles[12], sep = ""), row.names = F)
# #############################################################################
# [13] "Time_in_ED.csv"
dfted <- read.csv(csvfiles[13], stringsAsFactors = FALSE)

for ( i in 9:11) {
x <- dfted[,i]
h <- as.numeric(sub("\\s.*","",x))
m <-  as.numeric(gsub("([0-9]+).*$", "\\1",sub(".*hrs", "", x)))
dfted[,i] <- sprintf("%02d:%02d", h,m)
}
head(dfted)
write.csv(dfted, paste("2ndEd/", csvfiles[13], sep = ""), row.names = F)
# #############################################################################
# [14] "Time_in_ED_-_within_4_hrs.csv"
dfted4 <- read.csv(csvfiles[14], stringsAsFactors = FALSE)

for (i in c(8:10)) {
  dfted4[, i][dfted4[, i] == "<5"] <- 1
  dfted4[, i] <- as.numeric(dfted4[, i])
}

write.csv(dfted4, paste("2ndEd/", csvfiles[14], sep = ""), row.names = F)
#############################################################################
# [15] "Urgency_category.csv"
dfuc <- read.csv(csvfiles[15], stringsAsFactors = FALSE)

for (i in c(8:12)) {
  dfuc[, i][dfuc[, i] == "<5"] <- 1
  dfuc[, i] <- as.numeric(dfuc[, i])
}

write.csv(dfuc, paste("2ndEd/", csvfiles[15], sep = ""), row.names = F)
#
############################################################################
# metadata
# create empty dataframe
setwd(wd.3)
csvfiles <- list.files(pattern = "csv")
df <- data.frame()
# loop for all field names and classes


for (i in 1:length(csvfiles)) {
  cldf <- data.frame(FieldName = names(read.csv(csvfiles[i])))
  # second column is each variables class [using sapply (dataframe, function)]
  cldf$Class <- sapply(read.csv(csvfiles[i]), class)
  cldf$filename <- csvfiles[i]
  df <- rbind(df, cldf)
}
write.csv(df , "metadata/metadata_2ndEd.csv", row.names =   F)
#!END###########################################################################