library(dplyr)

rm(list=ls())

#subject <- c(8006, 8013, 8016, 8018, 8019, 8021, 8022, 8023, 8024, 8025, 8028, 8029, 8030, 8031, 8034, 8036, 8041, 8042, 8043, 8045, 8046, 8047, 8048, 8049, 8050, 8052, 8054, 8056, 8058, 8059, 8060, 8061, 8062, 8070)
subject <- c(8024, 8045, 8070)
task <- c("rest", "sternberg", "hippo")

for (i in 1:length(subject)) {
  for (j in 1:length(task)) {
  csf <- read.table(file = paste0("/Shared/rblock_mr/derivatives/fmriprep/sub-",subject[i],"/func/sub-",subject[i],"_task-",task[j],"_CSFts.txt"))  
  wm <- read.table(file = paste0("/Shared/rblock_mr/derivatives/fmriprep/sub-",subject[i],"/func/sub-",subject[i],"_task-",task[j],"_WMts.txt"))  
  df <- merge(csf, wm, by = "row.names") 
  df$Row.names <- as.numeric(df$Row.names)
  df <- df %>% arrange(Row.names) %>% select(2,3)
  
  write.table(df, file = 
              paste0("/Shared/rblock_mr/derivatives/fmriprep/sub-",subject[i],"/func/sub-",subject[i],"_task-",task[j],"_confound.txt"), 
              sep = '\t', row.names = F, col.names = F, quote = F)
}}


