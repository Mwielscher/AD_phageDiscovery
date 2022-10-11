#!/bin/bash

in='/binfl/virome/new22/published/PHAGE_contigs/CLEANED_PHAGE_CONTIGS/'
out='/binfl/virome/new22/published/'
samp='/binfl/virome/new22/published/study_IDs_after_SPADES.txt'

module load intel/18 intel-mkl/2018 pcre2/10.35 R/4.0.2
R --vanilla <<"EOF"

samp=read.table("/home/lv71395/mwielsch/binfl/virome/new22/published/study_IDs_after_SPADES.txt")

for (k in samp$V1) {
	print(paste("this is ",  as.character(k)))
	info=file.info(paste("/home/lv71395/mwielsch/binfl/virome/new22/published/PHAGE_contigs/CLEANED_PHAGE_CONTIGS/",as.character(k),"final_phage_contig_overview_2",sep=""))
	if (info$size %in% c(0) ) { 
		print(c("skipped" )) }else {
	dat=read.table(paste("/home/lv71395/mwielsch/binfl/virome/new22/published/PHAGE_contigs/CLEANED_PHAGE_CONTIGS/",as.character(k),"final_phage_contig_overview_2",sep=""),sep="\t",fill=T)
	if (ncol(dat) %in% c(4)){
	colnames(dat)=c("short_ID","length","deepVir_score","deepVir_P")
	dat$Sorter_find=rep("",nrow(dat))
        dat$sample=rep(as.character(k),nrow(dat))
	dat$combID=paste(dat$sample,dat$short_ID,sep="_")
        dat$combID=gsub(" .*", "",as.character(dat$combID))
	dat1=dat
	}else {

	colnames(dat)=c("short_ID","length","deepVir_score","deepVir_P","Sorter_find")
	dat$sample=rep(as.character(k),nrow(dat))
	dat$combID=paste(dat$sample,dat$short_ID,sep="_")
	dat$combID=gsub(" .*", "",as.character(dat$combID))
	excl=dat$combID[dat$deepVir_score>0.95 & !(dat$Sorter_find %in% c(""))]
	dat1=dat[!(dat$Sorter_find %in% c("") & dat$combID %in% excl),]
	} # else 4 columns
	if(!exists("res")){
	 	res=dat1
	} else 	{
		res=as.data.frame(rbind(res,dat1))
	}
 } # filesize else
	
}

write.table(res,file="/home/lv71395/mwielsch/binfl/virome/new22/published/summary_phage_contigs_published.txt",sep="\t",col.names=T,row.names=F,quote=F)

EOF
