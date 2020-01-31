library(dplyr)
rm(list=ls())
data.dir <- ("~/Documents/vaidya/Block/Imaging data/")
setwd(data.dir)

###########################################################################################
###################################### STERNBERG TASK #####################################
###########################################################################################


# As of Dec 19 2019 -- 37 participants, only 15 had behavioral data recorded, additionally exclude 2
# 8047 -- This is the one where the scan trigger values "3" were coming in so behavioral responses may not be logged. Could still be analyzed 
# 8061 -- scan trigger values "3"

sub<- c("8025", "8036", "8041", "8049", "8050", "8052", "8054", "8056", "8058", "8059",
        "8060", "8062", "8070")

file <- list.files(pattern = "SternbergScanner.log")
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
              file = "../behav/sternberg.tsv", append = T)
}

behav_stern <- read.table("../behav/sternberg.tsv", sep = "\t")  
names(behav_stern) <- c("id", "NTacc", "PTacc", "CTacc", "NTrt", "PTrt", "CTrt")
write.table(behav_stern, row.names = F, col.names = T, sep = "\t", quote = F,
            file = "../behav/sternberg.tsv")

boxplot(behav_stern[,2:4])
boxplot(behav_stern[,5:7])


###########################################################################################
###################################### HIPPOCAMPUS TASK ###################################
###########################################################################################

rm(list=ls())
#sub<- c("8054", "8049", "8025", "8056", "8058", "8052", "8050")

# 
# 8015 -- No data for both hippo and sternberg


file <- list.files(pattern = "hippocampus_task_SCAN")
allsub <- unlist(strsplit(file, "-hippocampus_task_SCAN.log"))

analyze <- allsub

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
              file = "../behav/hippo.tsv", append = T)
  }

behav_hippo <- read.table("../behav/hippo.tsv", sep = "\t")  
names(behav_hippo) <- c("id", "REacc", "SIacc", "RErt", "SIrt")
write.table(behav_hippo, row.names = F, col.names = T, sep = "\t", quote = F,
            file = "../behav/hippo.tsv")

boxplot(behav_hippo[,2:3])
boxplot(behav_hippo[,4:5])



