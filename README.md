# AD_phageDiscovery

## About this Repository
This repository accompanies the manuscript __"The skin phageome in Atopic Dermatitis"__ 
<br/><br/> <br/>

<p align="center">
<img src="/img/figure_4_for_github.jpg" alt="candidate genomes" width="600"/>
<br/><br/>





> **_Abstract:_**  In this metagenomic investigation we assembled viral sequences from skin swaps of healthy individuals and atopic dermatitis patients (AD). We found a total of 13586 potential viral contigs distributed over 182 metagenome samples from 35 participants, which could be assigned to 162 putative phage genomes. There was high sequence heterogeneity within novel discovered viral like particles (VLP). Shannon diversity index for VLPs did not correlate with AD induced inflammation, however we found 28 VLPs with significant association between AD induced inflammation and phage abundance. qPCR validation of 3 VLPs showed an that the observed association between inflammation and phage abundance was independent of each phage host bacterium abundance. We observed a high fraction of integrated prophages but also detected lytic phages that would be suitable for phage treatment in AD patients. 
<p>
<br/>

 The scripts to perform the analyses presented in the manuscript are deposited in this repository. These are custom scripts, which were  run on my local destop computer or designed to run on a [SGE cluster](http://gridscheduler.sourceforge.net/htmlman/manuals.html). Any script may serve a building block for a process in any workflow language.  
  
  
 ## Read QC and contigs  
 
We combined FASTQ files created in this study with 2132 downloaded FASTQ files from NCBI using SRA toolkit. The files contained paired end reads from Bioproject PRJNA46333. Raw paired-end FASTQ files were then trimmed with Trimmomatic-0.35, adapters were removed using default settings, a sliding window of 4:20 was used and the minimum read length was set to 50. Host sequence contamination was removed with a custom script. We used Bowtie2 to align the FASTQ files against the human reference genome (GRCh38). Subsequently, we use samtools to split the reads into not aligned and aligned to human reference Genome and mouse genome. We used not aligned reads for all further analysis. Where necessary we combined multiple FASTQ files per sample to one file per sample before subjecting FASTQ samples to generating contigs with Spades. 
>>* This [script](read_to_contig/4_run_preProcessing.sh) can be used to download data from SRA sequence archive   
>>* This [script](read_to_contig/4_run_preProcessing.sh) runs preProcesssing including Read trimming and exclusion of host DNA    
>>* This [script](read_to_contig/5_run_meta_SPADES.sh) combines multiple QCed FASTQ files for metaSpades contig generation  

 ## Discover viral like particles (VLP)  
 
 
 
 
