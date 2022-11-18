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

/* PRE3_BOWTIE2 */

process BOWTIE2_INDEX {
	container 'edugarcia156/nf-metagenome'
	publishDir "${intermediates_dir}/bowtie2_index/",mode:"symlink"
	input:
	file host_ref
	file PhiX_ref

	output:
	path "*"

	shell:
	// Generate the mixed fasta and its index
	// Small index if the genome is small
	if ( params.host == false )
	"""

	#Generate a small index
	echo "Small index needs to be generated"
	bowtie2-build ${PhiX_ref} Mix --threads $task.cpus

	"""
	// Large index if the genome is large due to the presence of the host genome
	else
	"""
	cat ${host_ref} ${PhiX_ref}  Mixed.fasta

	echo "Large index needs to be generated"
	bowtie2-build --large-index Mixed.fasta Mix --threads $task.cpus
	"""
}
