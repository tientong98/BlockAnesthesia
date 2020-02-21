sterntiming_func <- function(subject_id) {
  setwd("~/Documents/vaidya/Block/Imaging data/")
  
  library(dplyr)
  library(lessR)
  
  analyze <- subject_id
  
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
}
