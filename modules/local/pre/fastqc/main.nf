#!/usr/bin/env nextflow
/*
================================================================

								---- MODULE PIPELINE ---------

================================================================

This module takes one or more FASTQ files and performs basic QC
with FastQC

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

/* PRE1_FASTQC */

process FASTQC {
	container 'edugarcia156/nf-metagenome'
	tag "$Sample_id"

	publishDir "${intermediates_dir}/fastqc/",mode:"symlink"

	input:
	tuple val( Sample_id ), path( Sample_file )

	output:
	tuple val(Sample_id), path("*.zip"), emit: zip
	path "*"

	shell:
	"""
	echo "[DEBUG] analyze QC for ${Sample_id}"
	fastqc --nogroup --threads $task.cpus ${Sample_id}R1.fastq.gz ${Sample_id}R2.fastq.gz

	"""

}
