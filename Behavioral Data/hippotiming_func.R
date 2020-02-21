hippotiming_func <- function(subject_id) {
  setwd("~/Documents/vaidya/Block/Imaging data/")
  
  library(dplyr)
  library(lessR)
  
  analyze <- subject_id
  
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
}
