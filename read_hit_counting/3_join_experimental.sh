#!/bin/bash

###  ---------- first two files outside the loop
#awk '{print $1,$2, $4}' ../JMF_2010_E_0002/JMF_2010_E_0001_depth.txt > JMF_2010_E_0001
#awk '{print $1, $4}' ../JMF_2010_E_0002/JMF_2010_E_0002_depth.txt > JMF_2010_E_0002


outfile=' > PHAGE_counts_not_normalized.txt'
input='/binfl/virome/new22/meduni/data/samples_meduni'
base='join JMF_2010_E_0001 JMF_2010_E_0002'
inter='|join'
dash='-'
while IFS= read -r line
do
awk '{print $1, $4}' ../${line}/${line}_depth.txt >../${line}/inter
mv ../${line}/inter ${line}

base="$base $inter $line $dash"

echo "$base"
done <samples_meduni
