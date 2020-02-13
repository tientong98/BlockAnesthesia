#!/usr/bin/env Rscript
suppressPackageStartupMessages(require(optparse))
suppressPackageStartupMessages(require(dplyr))

# organize the re-calculated WM and CSF signals (from unsmoothed denoised BOLD) into a confound txt file - get ready for FEAT

option_list = list(
  optparse::make_option(c("-s", "--svar"), action="store", default=NA, type='character'))

opt = parse_args(OptionParser(option_list=option_list))

subject <- opt$s
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
                sep = '\t', row.names = F, col.names = F, quote = F)}}
