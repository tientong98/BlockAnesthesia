rm(list=ls())
data.dir <- ("~/Documents/vaidya/Block/Imaging data/")
setwd(data.dir)

library(dplyr)
library(lessR)

###########################################################################################
###################################### STERNBERG TASK #####################################
###########################################################################################

# As of Dec 19 2019 -- 37 participants, not analyzing 3 (8005, 8007, 8015) --> 34
# 8005 8007 -- different number of TRs NOT ANALYZE FOR NOW
# 8007 -- Sternberg timing off in Scanner; maybe not even count this one.  They had to manually trigger.
# 8015 -- No data for both hippo and sternberg
# 8013 -- squeezed panic ball 10 minutes in. exclude the first (incomplete) data
# 8047 -- This is the one where the scan trigger values "3" were coming in so behavioral responses may not be logged.  Could still be analyzed 

exclude <- c("8005", "8007", "8015")

file <- list.files(pattern = "SternbergScanner.log")
allsub <- unlist(strsplit(file, "-SternbergScanner.log"))

`%notin%` <- Negate(`%in%`)
analyze <- allsub[which(allsub %notin% exclude)]


for (x in (1:length(analyze))) {
  df <- read.csv(paste0(analyze[x], '-SternbergScanner.log'), skip = 8,
                    header = T, sep = "\t", stringsAsFactors = F)
  df <- df[-c(1,2),]
  rownames(df) <- NULL
  
  onsetinstruct <- df[which(df$type == "ms"),]
  dfnoresp <- df %>% filter(type != "Respons")
  onsetfirststim <- dfnoresp[which(dfnoresp$type == "ms") + 1,]
  
  onsetdf <- merge(onsetinstruct, onsetfirststim, all = T) %>%
    arrange(index) %>% select(time, type, stimulus, condition) %>%
    mutate(blockonset = ifelse(type != "ms", 
                               round((time-df[1,"time"])/1000, digits = 0) - 6, 
                               NA))
  onsetdf[,"duration"] <- 0
  for (i in (1:length(onsetdf$time))) {
    if (onsetdf[i,"type"] != "ms") {
      onsetdf[i,"duration"] = round((onsetdf[i+1,"time"] - onsetdf[i,"time"])/1000, 
                                    digits =0) 
    }}
  onset <- na.omit(onsetdf$blockonset)
  duration <- na.omit(ifelse(onsetdf$duration != 0, onsetdf$duration, NA))
  
  lastblock <- tail(df, 11)
  
  file <- list.files(pattern = paste0(analyze[x],"-Sternberg_SCAN"))
  lastdf <- read.csv(file = file, skip = 3, header = T, sep = "\t", stringsAsFactors = F)
  lastblockdur <- round(((tail(as.numeric(lastdf$ms.str.),1))/10 - as.numeric(lastblock[2,"time"]))/1000,
                        digits = 0)
  duration <- c(duration, lastblockdur)
  trial_type <- onsetdf$condition[c(TRUE,FALSE)]
  response_time <- rep.int("n/a", 24)
  stim_file <- rep.int("n/a", 24)
  timing <- data.frame(onset, duration, trial_type, response_time, stim_file)
  
  write.table(timing, row.names = F, col.names = T, sep = "\t", quote = F,
              file = paste0("~/Documents/vaidya/Block/timingfiles/sternberg/sub-", analyze[x],"_task-sternberg_events.tsv"))}


library(tools)

for (x in (1:(length(analyze)-1))) {
  print(md5sum(paste0("~/Documents/vaidya/Block/timingfiles/sternberg/sub-", analyze[x],"_task-sternberg_events.tsv")) == md5sum(paste0("~/Documents/vaidya/Block/timingfiles/sternberg/sub-", analyze[x+1],"_task-sternberg_events.tsv"))
)}





###########################################################################################
###################################### HIPPOCAMPUS TASK ###################################
###########################################################################################

rm(list=ls())

# As of Dec 19 2019 -- 37 participants, not analyzing 3 (8005, 8007, 8015) --> 34
# 8005 8007 -- different number of TRs NOT ANALYZE FOR NOW
# 8015 -- No data for both hippo and sternberg

exclude <- c("8005", "8007", "8015")


file <- list.files(pattern = "-hippocampus_task_SCAN.log")
allsub <- unlist(strsplit(file, "-hippocampus_task_SCAN.log"))

`%notin%` <- Negate(`%in%`)
analyze <- allsub[which(allsub %notin% exclude)]

for (x in (1:length(analyze))) {
  df <- read.csv(paste0(analyze[x], '-hippocampus_task_SCAN.log'), skip = 3,
                 header = T, sep = "\t", stringsAsFactors = F)
  df <- df[-(which(df$Subject == "Event Type"):length(df$Subject)),]
  df[which(df$type == "ms"),]
  onsetdf <- df %>%
    filter(Event.Type == "Picture") %>%
    select(Subject, Trial, Code, file_name.str., Time)
  onsetdf <- mutate_at(onsetdf, vars(Trial,Time), funs(as.numeric))
  onsetdf <- mutate_at(onsetdf, vars(Time), funs( . / 10000))
  
  onsetdf[,"blockonset"] <- NA
  for (i in (1:length(onsetdf$Subject))) {
    if (onsetdf[i,"Code"] == "rest"| 
        onsetdf[i,"Code"] == "ins,instructions1_AL.bmp,5" |
        onsetdf[i,"Code"] == "ins,instructions2_SI.bmp,5" | 
        onsetdf[i,"Code"] == "ins,instructions3_RE.bmp,5") {
      onsetdf[i+1,"blockonset"] = round((onsetdf$Time[i+1] - onsetdf$Time[1]), digits = 0) - 6
    }}
  onset <- na.omit(onsetdf$blockonset)  
  
  onsetdf[,"duration"] <- NA
  for (i in (1:length(onsetdf$Subject))) {
    if (onsetdf[i,"Code"] == "rest"| 
        onsetdf[i,"Code"] == "ins,instructions1_AL.bmp,5" |
        onsetdf[i,"Code"] == "ins,instructions2_SI.bmp,5" | 
        onsetdf[i,"Code"] == "ins,instructions3_RE.bmp,5") {
      onsetdf[i,"duration"] = round((onsetdf$Time[i+9] - onsetdf$Time[i+1]), digits = 0)
    }}
  duration <- na.omit(onsetdf$duration) 
  
  lastblock <- df[((which(df$Code == "ins,instructions3_RE.bmp,5")[3]+1):length(df$Subject)),]
  lastblock$Time <- as.numeric(lastblock$Time)
  lastblockdur <- round((lastblock[which(lastblock$Trial == 109 & lastblock$Event.Type == "Pulse")[1],"Time"] - lastblock[4,"Time"]) / 10000, digits = 0 )
  duration <- c(duration, lastblockdur)
  
  
  onsetdf$trial_type <- ifelse(onsetdf$Code == "rest", "rest", 
                        ifelse(onsetdf$Code == "ins,instructions1_AL.bmp,5", "AL",
                        ifelse(onsetdf$Code == "ins,instructions2_SI.bmp,5", "SI",
                        ifelse(onsetdf$Code == "ins,instructions3_RE.bmp,5", "RE",
                               NA))))
  trial_type <-  na.omit(onsetdf$trial_type)
  
  response_time <- rep.int("n/a", 12)
  stim_file <- rep.int("n/a", 12)
  timing <- data.frame(onset, duration, trial_type, response_time, stim_file)
  
  write.table(timing, row.names = F, col.names = T, sep = "\t", quote = F, 
              file = paste0("~/Documents/vaidya/Block/timingfiles/hippo/sub-", analyze[x],"_task-hippo_events.tsv"))}


library(tools)

for (x in (1:(length(analyze)-1))) {
  print(md5sum(paste0("~/Documents/vaidya/Block/timingfiles/hippo/sub-", analyze[x],"_task-hippo_events.tsv")) == md5sum(paste0("~/Documents/vaidya/Block/timingfiles/hippo/sub-", analyze[x+1],"_task-hippo_events.tsv"))
  )}



