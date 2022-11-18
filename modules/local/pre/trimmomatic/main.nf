#!/usr/bin/env nextflow
/*
================================================================

								---- MODULE PIPELINE ---------

================================================================

This module takes one or more FASTQ files and perform
quality trims the reads and adapters

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

/*This directories will be automatically created by the pipeline to store files during the run
*/
results_dir = "${params.output_dir}/${pipeline_name}-results/"
intermediates_dir = "${params.output_dir}/${pipeline_name}-intermediate/"

/*
========================================================================================
    RUN module
========================================================================================
*/

/* PRE1_FASTQC */

process TRIMMOMATIC {
	container 'edugarcia156/nf-metagenome'
	tag "$Sample_name"

	publishDir "${intermediates_dir}/trimmomatic/",mode:"symlink"

	input:
	tuple val( Sample_name ), file( SAMPLE )
	file mk_files

	output:
	tuple val(Sample_name), file( "${Sample_name}*.fq.gz"), emit: trimmed_fq
  path "*.trim*" , emit: trim_multiqc

	shell:
	"""
		export TRIM_AVGQUAL="${params.trim_avgqual}"
		export TRIM_TRAILING="${params.trim_trailing}"
		export TRIM_MINLEN="${params.trim_minlen}"
		bash runmk.sh

	"""
}
