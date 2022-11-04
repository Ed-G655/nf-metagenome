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

/* DASTOOL */

process PROKKA {
	container 'quay.io/biocontainers/prokka:1.14.6--pl5262hdfd78af_1'
	tag "$Sample_name"

	publishDir "${results_dir}/prokka/", mode:"copy"

	input:
	tuple val(Sample_name), path(Dastool_fasta)
	tuple val(Sample_name), path(BIN_txt)
	file prokka_script

	output:
	path "*"

	shell:
	"""
	echo "[DEBUG]   Run prokka for ${Dastool_fasta}"
	python run_prokka.py ${BIN_txt} ${Dastool_fasta} "./${Sample_name}"


	"""

}
