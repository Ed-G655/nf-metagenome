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

/* BAM_TO_FASTQ */

process BAM_TO_FASTQ {
	tag "$Sample_name"

	publishDir "${results_dir}/BAM_to_FASTQ/",mode:"copy"

	input:
	tuple val(Sample_name), file( Sample_file)

	output:
 	tuple val(Sample_name), file( "${Sample_name}*.fastq.gz"), emit: host_rm_fq

	shell:
	"""
	echo "[DEBUG]   Convert BAM to fastq"

	bedtools bamtofastq -i ${Sample_name}sorted.bam \
											-fq  ${Sample_name}R1.fastq \
											-fq2  ${Sample_name}R2.fastq

	echo "[DEBUG] Compress FASTQ files"

	bgzip -c ${Sample_name}R1.fastq > ${Sample_name}R1.fastq.gz
	bgzip -c ${Sample_name}R1.fastq > ${Sample_name}R2.fastq.gz

	"""

}

//samtools bam2fq ${Sample_name}sorted.bam > ${Sample_name}.fastq

//echo "[DEBUG] split paired-end reads into separated fastq files"
