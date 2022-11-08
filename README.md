# AD_phageDiscovery  
## Table of contents  
1. [About this Repository](#About-this-Repository)  
2. [Read QC and contigs](#Read-QC-and-contigs)    
3. [Discovery of viral metagenomic assembled genomes](#Discovery-of-viral-metagenomic-assembled-genomes)  
4. [AD phagome database](#AD-phagome-database)  
5. [Read hit counting against vMAGs](#Read-hit-counting-against-vMAGs)  

## About this Repository
This repository accompanies the manuscript __"The skin phageome in Atopic Dermatitis"__ 
<br/><br/> <br/>

<p align="center">
<img src="/img/figure_4_for_github.jpg" alt="candidate genomes" width="600"/>
<br/><br/>





> **_Abstract:_**  Dysbiosis of skin microbiota drives the progression of atopic dermatitis (AD). The contribution of the cutaneous phageome to bacterial community compositions in normal and inflamed skin is unknown. Using shotgun metagenomics from skin swabs of healthy individuals and AD patients, we discovered a total of 13586 potential viral contiguous DNA sequences (contigs) distributed over 182 metagenome samples, which could be combined into 164 putative bacteriophage genomes including integrated prophages (15.2%). While the Shannon diversity index for the viral metagenome-assembled genomes (vMAGs) did not correlate with AD, 28 of them differed significantly between normal and AD skin. qPCR validation of three complete vMAGs revealed a discorrelation between phage and host bacterium abundance. These data suggest that normal and inflamed skin harbor distinct phageomes and that specific bacteriophages may contribute to AD pathogenesis through modulating bacterial fitness.   
<p>
<br/>

 The scripts to perform the analyses presented in the manuscript are deposited in this repository. These are custom scripts, which were  run on my local destop computer or designed to run on a [SGE cluster](http://gridscheduler.sourceforge.net/htmlman/manuals.html). Any script may serve a building block for a process in any workflow language.  
  
  
 ## Read QC and contigs  
 
We combined FASTQ files created in this study (PRJNA890024) with 2132 downloaded FASTQ files from NCBI using SRA toolkit. The files contained paired end reads from Bioproject PRJNA46333. Raw paired-end FASTQ files were then trimmed with Trimmomatic-0.35, adapters were removed using default settings, a sliding window of 4:20 was used and the minimum read length was set to 50. Host sequence contamination was removed with a custom script. We used Bowtie2 to align the FASTQ files against the human reference genome (GRCh38). Subsequently, we use samtools to split the reads into not aligned and aligned to human reference Genome and mouse genome. We used not aligned reads for all further analysis. Where necessary we combined multiple FASTQ files per sample to one file per sample before subjecting FASTQ samples to generating contigs with Spades. 
>>* This [script](read_to_contig/4_run_preProcessing.sh) can be used to download data from SRA sequence archive   
>>* This [script](read_to_contig/4_run_preProcessing.sh) runs preProcesssing including Read trimming and exclusion of host DNA    
>>* This [script](read_to_contig/5_run_meta_SPADES.sh) combines multiple QCed FASTQ files for metaSpades contig generation  
>>* This [script](VLP_discovery/1_contigQC_with_metaQUAST.sh) runs contig QC using QUAST software     

 ## Discovery of viral metagenomic assembled genomes    
 
We used [Virsorter2](https://microbiomejournal.biomedcentral.com/articles/10.1186/s40168-020-00990-y) and [DeepVir finder](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8172088/) to identify contigs that potentialy contain viral sequences. For both approaches we are using contigs (at least 1500bp long) assembled with metaSpades. Virsorter internally identifies coding sequences (CDS) in input DNA sequenes with Prodigal then annotation of predicted CDS is done with HMMER3 against Pfam and a database developed by the Virsorter. DeepVir finder works similarly. They use slightly different databases and run their classification workflow based on a neural net algorithm instead of a random forest classifier. DeepVir finder returns a Posterior probability for every contig, thus we applied a cut off of 0.95.  
>>* This [script](vMAG_discovery/3_VirSorter.sh) runs Virsorter 2  
>>* This [script](vMAG_discovery/2_Deep_virfinder.sh) runs DeepVir finder  
>>* This [script](vMAG_discovery/4_phage_contig_per_sample.sh) calculates the fraction of phage contig per sample  
>>* This [script](vMAG_discovery/5_get_sample_summaries.sh) prepares sample summaries    

## AD phagome database  

Contigs potentially containing viral sequences identified by Virsorter and DeepVir finder for each participant were combined. All contigs were compared pairwise and based on their sequence similarity clustered Best representative genome from any group is selected and similar contigs based on an ANI similarity cut off of 95% are discarded as implemented in dRep. The dereplicated viral contigs were evaluated for quality and completeness using [checkV software](https://www.nature.com/articles/s41587-020-00774-7). To determine completeness and quality for every contig, CDS are compared to viral and bacterial databases and then classified as either microbial, vial or not annotated gene. We used [MASH software](https://mash.readthedocs.io/en/latest/) to generate distance measures between viral contigs, RefSeq viral Genomes and two large scale phage databases. For this we retrieved all complete NCBI viral genomes which had bacterial listed as their host. Furthermore, we downloaded a GutPhage data base described by [Camarillo-Guerrero et al](https://www.sciencedirect.com/science/article/pii/S0092867421000726) and the complete [IMG/VR v3](https://academic.oup.com/nar/article/49/D1/D764/5952208?login=true), this is collection of uncultivated viral genomes across all earth habitats. We generated MASH sketch tables out of the data and ran mash screen with the winner takes all flag to reduce redundancy. We used the mashtree convenience function to get a matrix of sample distances. Those sample distances are based on DNA sequences similarity.  

>>* This [script](vMAG_data_base/1_deReplication.sh) performs derelication of vMAGs found in individual samples 
>>* This [script](vMAG_data_base/2_checkV.sh) runs checkV software  
>>* This [script](vMAG_data_base/3_DRAM_annot.sh) annotates vMAGs using DRAM software  
>>* This [script](vMAG_data_base/4_compare_to_Gut_phageDB.sh) compares vMAG sequences to human Gut phage database     

## Read hit counting against vMAGs    
We removed stretches of bacterial genomes from Prophage contigs and then used all vMAGs as reference. We used [Bowtie2 software](https://bowtie-bio.sourceforge.net/bowtie2/index.shtml) with setting “very sensitive” retrieving the top 10 hits. Reads mapping to multiple genomes or contigs were discarded from quantitative analysis. Aligned reads were counted and averaged with jgi_summarize_bam_depth as implemented by [metabat](https://bitbucket.org/berkeleylab/metabat/src/master/) package. This provides us the sum of exactly aligned bases which is then dived by the contig length. We used this value to calculate a CPM like value. This is the contig length normalized aligned bases times 106 divided by the total number of aligned bases per sample. Regression analysis were performed on CPM data. We used [MaAsLin 2 software](https://github.com/biobakery/Maaslin2). Count data were log transformed and regressed against inflammation score, where skin swaps from unaffected or healthy individual were rated 0.  
qPCR data analysis was as follows: We excluded any Cycle threshold (CT) value with a concordant product showing multiple melting points. We determined the melting point of each PCR amplified product upon visual inspection. Next, we defined a range of +/- 1.5 °C and excluded each CT-value with concordant product specific melting point outside this range. CT values were then normalized to total bacterial DNA measured in sample. For this we subtracted the 16sRNA primer CT values of each sample from the CT value of all other measured genomic loci. Depending on the suspected host bacterium we further normalized the phage contig CT values to the amount of host bacteria.   
>>* This [script](read_hit_counting/1_make_reference.sh) creates a reference for bowtie2 
>>* This [script](read_hit_counting/2_count_reads.sh) counts the reads  
>>* This [R - script](read_hit_counting/5_analyse_reads.R) normalizes reads, runs regressions and visualizations of data    
>>* This [R - script](read_hit_counting/6_qPCR.R) runs QC on qPCR data normalizes and visualizes data  

