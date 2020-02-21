stern_func <- function(subject_id) {
  # getting subject behavioral performance during the sternberg task
  # have to enter subject_id as string
  setwd("~/Documents/vaidya/Block/Imaging data/")
  library(dplyr)
  
  sub <- subject_id
  
  file <- list.files(path = "~/Documents/vaidya/Block/Imaging data/", pattern = "SternbergScanner.log")
  allsub <- unlist(strsplit(file, "-SternbergScanner.log"))
  
  analyze <- allsub[which(allsub %in% sub)]
  
  
  for (i in (1:length(analyze))) {
    stern <- read.csv(paste0(analyze[i], '-SternbergScanner.log'), skip = 8,
                      header = T, sep = "\t", stringsAsFactors = F) %>%
      select(index, RT, type, stimulus,button, condition)
    
    stern$accuracy.type <- ifelse(stern$condition != "RT" & stern$type == "distr" & stern$button == 0, "CorNonResp", 
                           ifelse(stern$condition != "RT" & stern$type == "distr" & stern$button == 1, "CommissErr",
                           ifelse(stern$condition != "RT" & stern$type == "target" & stern$button == 1, "CorResp",
                           ifelse(stern$condition != "RT" & stern$type == "target" & stern$button == 0, "OmissErr",
                           NA))))
    stern$accuracy <- ifelse (stern$accuracy.type == "CorNonResp" | stern$accuracy.type == "CorResp", 1, 0)
    
    NTacc <- (stern %>% filter(condition == "NT") %>% summarize(mean(accuracy, na.rm = TRUE)) * 100)[1,]
    PTacc <- (stern %>% filter(condition == "PT") %>% summarize(mean(accuracy, na.rm = TRUE)) * 100)[1,]
    CTacc <- (stern %>% filter(condition == "CT") %>% summarize(mean(accuracy, na.rm = TRUE)) * 100)[1,]
    
    NTrt <- (stern %>% filter(condition == "NT", accuracy == 1) %>% summarize(mean(RT, na.rm = TRUE)))[1,]
    PTrt <- (stern %>% filter(condition == "PT", accuracy == 1) %>% summarize(mean(RT, na.rm = TRUE)))[1,]
    CTrt <- (stern %>% filter(condition == "CT", accuracy == 1) %>% summarize(mean(RT, na.rm = TRUE)))[1,]
    
    id <- analyze[i]
    behav_stern <- data.frame(id, NTacc, PTacc, CTacc, NTrt, PTrt, CTrt)
    
    write.table(behav_stern, row.names = F, col.names = F, sep = "\t", quote = F,
                file = "~/Documents/vaidya/Block/behav/sternberg.tsv", append = T)
  }
}
