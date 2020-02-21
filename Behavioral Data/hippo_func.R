hippo_func <- function(subject_id) {
  # getting subject behavioral performance during the sternberg task
  # have to enter subject_id as string
  setwd("~/Documents/vaidya/Block/Imaging data/")
  library(dplyr)
  
  sub <- subject_id
  
  file <- list.files(path = "~/Documents/vaidya/Block/Imaging data/", pattern = "hippocampus_task_SCAN.log")
  allsub <- unlist(strsplit(file, "-hippocampus_task_SCAN.log"))
  
  analyze <- allsub[which(allsub %in% sub)]
  
  for (i in (1:length(analyze))) {
    hippo <- read.csv(paste0(analyze[i], '-hippocampus_task_SCAN.log'), 
                      skip=grep("Event Type", readLines(paste0(analyze[i], '-hippocampus_task_SCAN.log')))[2] - 1,
                      header = T, sep = "\t", stringsAsFactors = F) %>%
      select(Code, Response, RT) %>%
      mutate(RT = RT / 10000)
    hippo <- hippo[grep("PLAATJES", hippo$Code),]
    
    hippo[grep("ass,", hippo$Code),"condition"] <- "AL"
    hippo[grep("recall", hippo$Code),"condition"] <- "RE"
    hippo[grep("singleitem", hippo$Code),"condition"] <- "SI"
    
    hippo[grep("yes,", hippo$Code),"correctresp"] <- 1
    hippo[grep("no,", hippo$Code),"correctresp"] <- 2
    
    hippo$accuracy <- ifelse(hippo$correctresp == hippo$Response, 1, 0)
    
    REacc <- (hippo %>% filter(condition == "RE") %>% summarize(mean(accuracy, na.rm = TRUE)) * 100)[1,]
    SIacc <- (hippo %>% filter(condition == "SI") %>% summarize(mean(accuracy, na.rm = TRUE)) * 100)[1,]
    
    RErt <- (hippo %>% filter(condition == "RE", accuracy == 1) %>% summarize(mean(RT, na.rm = TRUE)))[1,]
    SIrt <- (hippo %>% filter(condition == "SI", accuracy == 1) %>% summarize(mean(RT, na.rm = TRUE)))[1,]
    
    id <- analyze[i]
    
    behav_hippo <- data.frame(id, REacc, SIacc, RErt, SIrt)
    
    write.table(behav_hippo, row.names = F, col.names = F, sep = "\t", quote = F,
                file = "~/Documents/vaidya/Block/behav/hippo.tsv", append = T)
  
}}