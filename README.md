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
>>* This [script](rVLP_discovery/1_contigQC_with_metaQUAST.sh) runs contig QC using QUAST software     

 ## Discovery of viral like particles (VLP)  
 
We used [Virsorter2](https://microbiomejournal.biomedcentral.com/articles/10.1186/s40168-020-00990-y) and [DeepVir finder](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8172088/) to identify contigs that potentialy contain viral sequences. For both approaches we are using contigs (at least 1500bp long) assembled with metaSpades. Virsorter internally identifies coding sequences (CDS) in input DNA sequenes with Prodigal then annotation of predicted CDS is done with HMMER3 against Pfam and a database developed by the Virsorter. DeepVir finder works similarly. They use slightly different databases and run their classification workflow based on a neural net algorithm instead of a random forest classifier. DeepVir finder returns a Posterior probability for every contig, thus we applied a cut off of 0.95.  
>>* This [script](VLP_discovery/3_VirSorter.sh) runs Virsorter 2  
>>* This [script](VLP_discovery/2_Deep_virfinder.sh) runs DeepVir finder  
>>* This [script](VLP_discovery/4_phage_contig_per_sample.sh) calculates the fraction of phage contig per sample  
>>* This [script](VLP_discovery/5_get_sample_summaries.sh) prepares sample summaries    

## AD phagome database  






