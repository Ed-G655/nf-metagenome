#!/usr/bin/env bash

## find every vcf file
#find: -L option to include symlinks
find -L . \
  -type f \
  -name "*R1.fastq.gz" \
| sed 's#_R1.fastq.gz$#.trimreport.txt#' \
| xargs mk
