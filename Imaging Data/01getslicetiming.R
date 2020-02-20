########################################################################################################################
##################################################  STERNBERG TASK  ####################################################
########################################################################################################################

# 1-37 = first TR, 38-74 = 2nd TR, 75-111 = 3rd TR, 112-148 = 4th TR, 149-185 = 5th TR, 186-222 = 5th TR

stern <- data.frame(list.files("/Shared/rblock_mr/sourcedata/20200213/4/DICOM", pattern = "1.2.840"), stringsAsFactors = F)
names(stern) <- "info"

stern_first5 <- data.frame(matrix(nrow = 222, ncol = 1))
names(stern_first5) <- "info"
for (i in 1:222) {
  x = paste0("-4-",i,"-")
  stern_first5[i,] <- data.frame(stern$info[grep(x, stern$info)], stringsAsFactors = F)
}


stern_first5$order <- NA
for (i in 1:length(stern_first5$info)) {
  stern_first5$order[i] <- as.numeric(strsplit(stern_first5$info, "-")[[i]][3])
}

library(dplyr)
stern_first5 <- stern_first5 %>% arrange(order) %>% select(info)
write.table(stern_first5, "/Shared/rblock_mr/sourcedata/20200213/4/DICOM/stern.txt", quote = F, col.names = F, row.names = F)


########################################################################################################################
##################################################  HIPPO TASK  ########################################################
########################################################################################################################

hippo <- data.frame(list.files("/Shared/rblock_mr/sourcedata/20200213/5/DICOM", pattern = "1.2.840"), stringsAsFactors = F)
names(hippo) <- "info"

hippo_first5 <- data.frame(matrix(nrow = 222, ncol = 1))
names(hippo_first5) <- "info"
for (i in 1:222) {
  x = paste0("-5-",i,"-")
  hippo_first5[i,] <- data.frame(hippo$info[grep(x, hippo$info)], stringsAsFactors = F)
}


hippo_first5$order <- NA
for (i in 1:length(hippo_first5$info)) {
  hippo_first5$order[i] <- as.numeric(strsplit(hippo_first5$info, "-")[[i]][3])
}

library(dplyr)
hippo_first5 <- hippo_first5 %>% arrange(order) %>% select(info)
write.table(hippo_first5, "/Shared/rblock_mr/sourcedata/20200213/5/DICOM/hippo.txt", quote = F, col.names = F, row.names = F)


########################################################################################################################
######################################################  REST ###########################################################
########################################################################################################################

rest <- data.frame(list.files("/Shared/rblock_mr/sourcedata/20200213/8/DICOM", pattern = "1.2.840"), stringsAsFactors = F)
names(rest) <- "info"

rest_first5 <- data.frame(matrix(nrow = 222, ncol = 1))
names(rest_first5) <- "info"
for (i in 1:222) {
  x = paste0("-8-",i,"-")
  rest_first5[i,] <- data.frame(rest$info[grep(x, rest$info)], stringsAsFactors = F)
}


rest_first5$order <- NA
for (i in 1:length(rest_first5$info)) {
  rest_first5$order[i] <- as.numeric(strsplit(rest_first5$info, "-")[[i]][3])
}

library(dplyr)
rest_first5 <- rest_first5 %>% arrange(order) %>% select(info)
write.table(rest_first5, "/Shared/rblock_mr/sourcedata/20200213/8/DICOM/rest.txt", quote = F, col.names = F, row.names = F)
