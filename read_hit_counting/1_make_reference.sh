#!/bin/bash

bin='/home/bowtie2-2.4.1-linux-x86_64/'
dir='/binfl/virome/new22/phage_read_mapping/REF/'

${bin}./bowtie2-build ${dir}PhageDB_cleaned_for_bowtie.fasta ${dir}/phage.ref
