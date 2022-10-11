## this file was build from result excel sheets from qPCR Machine undetermied was set to NA
##  remove any spaces from names
dat=read.table("qPCR_result_AUGUST_2022.txt",sep="\t",header=T)


###  ----------------  check NTC
ntc=dat[grepl("NTC",dat$sample),]  # 69 ntc entries
table(is.na(ntc$CT))     #  13 were undtermined anyway
###  ---  set CT with multiple Tm to NA
ntc$CT[!is.na(ntc$Tm2) | !is.na(ntc$Tm3)] = NA  ## if there is 2nd or 3rd Tm value the CT value will be set to NA
table(is.na(ntc$CT))  ## now 28 can be considered as negative
###  ------    set CT with "wrong Tm" to NA
## correct Tm were determined on qPCR Machine and double checked with Fragment length and GC content of Fragment
# 16S RNA   TM 83.5 to 87
# camp      TM 70 to 72
# cory      TM 85.5 to 87
# Cuti      TM 85 to 87
# n12       TM 87.5 to 88.5
# n33       TM 82 to 84
# n4        TM 75 to 78
# n49       TM 75 to 77.5
# n6        TM 85 to 87
# n8        TM 70 to 73
# Prop      TM 85 to 87
# S.epi     TM 75 to 77
###   -----------------------------------------
table(ntc$TargetName)  # check
primer=unique(ntc$TargetName)
primer=primer[-11]  ###   exclude NTC
primer  # get order for TM_low and TM_up right
TM_low=c(83.5,70,85.5,85,87.5,82,75,75,85,70,85,75)
TM_high=c(87,72,87,87,88.5,84,78,77.5,87,73,87,77)
primer.tab=as.data.frame(cbind(primer,TM_low,TM_high))
primer.tab  # double check


for (k in 1:nrow(primer.tab)) {
  
  ntc$CT[grepl(primer.tab$primer[k],ntc$TargetName) & (ntc$Tm1 < primer.tab$TM_low[k] | ntc$Tm1 > primer.tab$TM_high[k] )]=NA
  print(paste("this is ",primer.tab$primer[k], "that many (TRUE) NTC were negative "))
  print(table(is.na(ntc$CT[grepl(primer.tab$primer[k],ntc$TargetName)])))
  
}

###   -------------   set CT with outlying Tm to NA
for (k in 1:nrow(primer.tab)) {
  
  dat1$CT[grepl(primer.tab$primer[k],dat1$TargetName) & (dat1$Tm1 < primer.tab$TM_low[k] | dat1$Tm1 > primer.tab$TM_high[k] )]=NA
  print(paste("this is ",primer.tab$primer[k], "that many (FALSE) valid datapoints were produced for this primer "))
  print(table(is.na(dat1$CT[grepl(primer.tab$primer[k],dat1$TargetName)])))
  
}
####  ------ look for plate position issues
pos=unique(dat1$Well)

for (k in pos) {
  
  print(paste("this is ",k, "that many (FALSE) valid datapoints were produced in this well "))
  print(table(is.na(dat1$CT[grepl(k,dat1$Well)])))
}
####   -----------   handle duplicates
dat1=dat1[order(is.na(dat1$CT)),] # sort and put NA at end
dat2=dat1[!duplicated(dat1$sample),]  # drop second of duplicate pair
###
### make a result matrix and normalize to 16S
dat3=dat2[,c("Sample.Name", "TargetName", "CT")]
library(reshape)
dat4= reshape(dat3, idvar = "Sample.Name", timevar ="TargetName", direction = "wide")
### remove samples with no working 16S product (if we cannot normalize, we cannot analyse)
dat4[is.na(dat4$CT.16S),]    ### check out what has to go
dat5=dat4[!is.na(dat4$CT.16S),]
####  set NA to 40
dat5[is.na(dat5)]=40
#### delta CT now
dat5=(cbind(dat5$Sample.Name, (dat5[,3:ncol(dat5)] - dat5$CT.16S)))
colnames(dat5)[1]=c("Sample.Name")
####  ---------------------------------------------------  make phe
dat5$group=rep(NA,nrow(dat5))
dat5$group[grepl("H",dat5$Sample.Name)]=c("skin_swap")
dat5$group[grepl("AD",dat5$Sample.Name)]=c("atopic_dermatitis")
table(is.na(dat5$group))
###  --------------------------
dat5$goup = as.factor(as.character(dat5$goup))

primer=colnames(dat5)[2:12]
library(ggplot2)
for (k in primer) {
  
  p<-ggplot(dat5, aes_string(x="group", y=k, fill="group")) +
    geom_boxplot() +
    theme_bw() +
    ggtitle(paste("qPCR",k,sep=" ")) +
    theme(plot.title = element_text(hjust = 0.5)) +
    ylab("delta CT")+
    theme(axis.title.x = element_blank()) +
    theme(axis.title.y = element_text(size = 12)) +
    theme(axis.text.y = element_text(size=12)) +
    theme(axis.text.x = element_text(angle = 45, hjust=1,size=14)) 
  p
  
  ggsave(paste0("AUG_raw_view",k,".jpeg"),plot=p)
  
}
###    ------------------------------------------------------------------------------------------
#####  --------------------------------------------------------------------------------
#####  ---------------  delta delta CT now
dat5$ddCT.n6=dat5$CT.n6 - dat5$CT.Cuti
dat5$ddCT.n49=dat5$CT.n49 -dat5$CT.cory
dat5$ddCT.n8=dat5$CT.n8 -dat5$CT.camp
dat5$ddCT.n33=dat5$CT.n33 - dat5$CT.Prop
dat5$ddCT.n4=dat5$CT.n4 -dat5$CT.S.epi
#dat5$ddCT.n4=dat5$CT.n4 -dat5$CT.camp
dat5$ddCT.n12=dat5$CT.n12 --dat5$CT.cory
