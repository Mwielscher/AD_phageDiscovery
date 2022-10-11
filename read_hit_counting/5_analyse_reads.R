ibrary(reshape2)
library(dplyr)
library(ggplot2)
library(vegan)
library(Maaslin2)


## get phenotypes
phe.p=read.table("phenotype_file_published.txt",header=T,sep="\t")
phe.med=read.table("phenotype_meduni.txt",header=T,sep="\t")

dat=read.table("allPHAGE_read_counts.txt",header=T,sep=" ")
rownames(dat)=as.character(dat$contigName)
coverage=colSums(dat[,2:ncol(dat)])
table(coverage < 50)
dat1=dat[,2:ncol(dat)]
dat2=dat1[,coverage > 50]
inter=colnames(dat2)
inter=c("contigLen",inter)
inter=inter[!duplicated(inter)]
dat2=dat2[,inter]  
cover2=colSums(dat2[,2:ncol(dat2)])
hist(log(cover2))
##  make {count matrix
dat3=dat2[,2:ncol(dat2)]
total_mapped_reads=colSums((dat3))
####   2. CPM 
inter5 = sweep(dat3, 2, total_mapped_reads, FUN = '/')
inter5=inter5*1e06
#dat5=as.data.frame(cbind(contigName,strain,inter5))
write.table(inter5,file="CPM_table_PHAGES_all_samples_gt50.txt",sep="\t",col.names=T,row.names=T,quote=F)
###   -----------   relab
total_RPKM=colSums(inter5)
inter3=sweep(inter5, 2, total_RPKM, FUN = '/')
contig=as.character(rownames(inter3))
relab=as.data.frame(cbind(inter3,contig))
relab$total=rowSums(relab[,1:(ncol(relab)-1)])
relab=relab[order(-relab$total),]
write.table(relab,file="RELAB_table_PHAGES_all_samples_gt50.txt",sep="\t",col.names=T,row.names=T,quote=F)
#####  phenotype file
phe=read.table("pheno_both_ordered.txt",header=T,sep="\t")
col.rel=c(as.character(phe$ID),"contig","total")
relab=relab[,col.rel]
phe1=read.table("pheno_both_ordered_short.txt",header=T,sep="\t")
col.rel1=c(as.character(phe1$ID),"contig","total")
relab1=relab[,col.rel1]
##### ------------------------------------------    top 15 most abundant phage contigs
long <- melt(relab[,1:ncol(relab)-1], id.vars = c("contig"))
long <- melt(relab1[,1:ncol(relab1)-1], id.vars = c("contig"))
colnames(long)=c("Phagecontig","Patient","Fraction")

bp<- ggplot(long, aes(x=Patient, y=as.numeric(as.character(Fraction)), fill=Phagecontig))+
  geom_bar(width = 1, stat = "identity") +
  #3scale_fill_manual(values=c("#E7EBFA", "#CBB7DB", "#AB7EB8" ,"#8A4E99" ,"#5B5FAF" ,"#4D86C5", 
                       #      "#549EB1", "#65AD97", "#89BB6B" ,"#C1BA46"
                        #     ,"#E1A239", "#E67A32", "#DD3F26", "#A1221C" ,"#521913"))+
  scale_y_continuous(limits = c(0,1), expand = c(0, 0)) +
  theme_bw() +
  theme(axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y = element_text(face = "bold"),
        axis.text.x = element_text(face = "bold",angle = 45, hjust = 1)) +
  ggtitle("distribution of 15 most abundant phage contigs") +
  theme(plot.title = element_text(face="bold",color="darkblue",hjust = 0.5)) +
  theme(legend.position = "none")
bp
#####   ------------------------------------------- Shannon index
shannon=as.data.frame(diversity(t(relab1[,1:(ncol(relab1)-2)])))
shannon$ID=as.character(rownames(shannon))
shannon=shannon[as.character(colnames(relab)[1:(ncol(relab1)-2)] ),]
colnames(shannon)[1]=c("shannon_index")

shannon$ID <- factor(shannon$ID,levels = as.character(shannon$ID))
bp<- ggplot(shannon, aes(x=ID, y=shannon_index))+
  geom_bar(width = 1, stat = "identity",fill="#00A087FF") +
  theme_bw() +
  theme(axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y = element_text(face = "bold"),
        axis.text.x = element_text(face = "bold",angle = 45, hjust = 1)) +
  ggtitle("shannon index of diversity based on phage contigs") +
  theme(plot.title = element_text(face="bold",hjust = 0.5))
bp  

shannon1=merge(shannon,phe1,by.x="ID",by.y="ID")
shannon1$case_cont=as.factor(shannon1$case_cont)

median(shannon1$shannon_index[shannon1$case_cont %in% c("contr")])
2.603632
median(shannon1$shannon_index[shannon1$case_cont %in% c("AD")])
2.580772
####  ---------------------------------------------------------------   Maaslin2 
#  cite PLoS Computational Biology, 17(11):e1009442
phe1=read.table("pheno_both_ordered_short.txt",header=T,sep="\t")
cpm =read.table("CPM_table_PHAGES_all_samples_gt50.txt",header=T,sep="\t")
cpm=cpm[,colnames(cpm) %in% phe1$ID]
cpm=cpm[,as.character(phe1$ID)]
phe23=as.data.frame(phe1[,"inflamm_score"])
colnames(phe23)=c("inflamm_score")
rownames(phe23)=as.character(phe1$ID)
phe23$inflamm_score = as.numeric(phe23$inflamm_score)

fit.dat2=Maaslin2(cpm,phe23,"phages_short_score",
                  normalization = "NONE",
                  reference = "inflamm_score",
                  transform = "LOG",
                  analysis_method = "LM",
                  standardize = FALSE)


#######   --------------------------------------    heat map 

phe1=read.table("pheno_both_short.txt",header=T,sep="\t")
cpm =read.table("CPM_table_PHAGES_all_samples_gt50.txt",header=T,sep="\t")
cpm=cpm[,colnames(cpm) %in% phe1$ID]
cpm=cpm[,as.character(phe1$ID)]
phe23=as.data.frame(phe1[,"inflamm_score"])
colnames(phe23)=c("inflamm_score")
rownames(phe23)=as.character(phe1$ID)
phe23$inflamm_score = as.numeric(phe23$inflamm_score)
###  ---------- subset
assoc.list=read.table("assoc_result.txt",header=T,sep="\t")
assoc=assoc.list[assoc.list$qval < 0.001 ,]
assoc=assoc.list[1:30 ,]
assoc=as.data.frame(rbind(assoc,assoc.list[ assoc.list$ID %in% c("JMF_2010_E_0012_NODE_14_length_144375_cov_53.394845","JMF_2010_E_0020_NODE_16_length_85614_cov_671.995372"),]))

table(rownames(cpm) %in% assoc$rownames)
p.dat=cpm[rownames(cpm) %in% assoc$rownames,]

  
library(ggplot2)
library(ComplexHeatmap)
library(circlize)
library(cluster)
####
p.dat1=log(p.dat+0.001)
p.dat2=scale(p.dat1) 
   
Heatmap(as.matrix(p.dat2),show_row_names = TRUE,cluster_columns=F,top_annotation = ha ,show_column_names = FALSE ,show_heatmap_legend=FALSE)
        
ha = HeatmapAnnotation(
  study = as.character(phe1$study),
  inflam = as.character(phe1$inflamm_score),
  col=list(study = c("Byrd" = "#00A087FF","MedUni"="#3C5488FF"),
           inflam=c("0"= "#7E6148FF", "1"= "#4DBBD5FF"   ,"2"="#F39B7FFF" ,"3"="#DC0000FF")),
  na_col = "grey",
  show_legend=FALSE,
  show_annotation_name=FALSE)





