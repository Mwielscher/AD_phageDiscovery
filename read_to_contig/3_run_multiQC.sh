#!/bin/bash
in='/binfl/virome/new22/published/fastqc'
out='/binfl/virome/new22/published/multiQC'
multiqc ${in} -o ${out}
