#!/usr/bin/env nextflow
/*
================================================================

								---- MODULE PIPELINE ---------

================================================================

This module perform bowtie2 aligment

==================================================================
Version: 0.1
Project repository:
==================================================================
Authors:

- Bioinformatics Design
 Jose Eduardo Garcia-Lopez (jeduardogl655@gmail.com)

- Bioinformatics Development
 Jose Eduardo Garcia-Lopez (jeduardogl655@gmail.com)


- Nextflow Port
 Jose Eduardo Garcia-Lopez (jeduardogl655@gmail.com)

///////////////////////////////////////////////////////////////

  Define pipeline Name
  This will be used as a name to include in the results and intermediates directory names
*/
pipeline_name = "nf-metagenome"
/*
Output directory definition
Default value to create directory is the parent dir of --input_dir
*/
params.output_dir = file(params.fastq_dir).getParent() //!! maybe creates bug, should check

/*
  Results and Intermediate directory definition
  They are always relative to the base Output Directory
  and they always include the pipeline name in the variable pipeline_name defined by this Script

  This directories will be automatically created by the pipeline to store files during the run
*/
results_dir = "${params.output_dir}/${pipeline_name}-results/"
intermediates_dir = "${params.output_dir}/${pipeline_name}-intermediate/"
/*
========================================================================================
    RUN module
========================================================================================
*/

/* QA_FILTER */

process QA_FILTER {
	tag "$Sample_name"

	publishDir "${results_dir}/QA/",mode:"copy"

	input:
	tuple val(Sample_name), file(QA)
	val Max_completeness
	val Max_contamination
	output:
	tuple val(Sample_name), file("*.txt"), emit: filtered_bins
	path "*.tsv"

	"""
	echo "[DEBUG]  Change qa to tsv"
	less -S $QA | tr -d "#-"  | tr -s " " | tr " " "\t" | cut -f2,8,9 | awk -F "\t" '{ if(\$2 >= 80 && \$3 <= 20) { print } }' > $Sample_name'_filtered_bins.tsv'

	echo "[DEBUG]  Filter high QA"
	sed -e "1d" $Sample_name'_filtered_bins.tsv'  | cut -f1 > $Sample_name'_filtered_bins.txt'

	"""

}
