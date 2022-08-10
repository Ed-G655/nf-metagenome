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

process BOWTIE2 {
	tag "$Sample_name"

	publishDir "${intermediates_dir}/bowtie2/",mode:"symlink"
	input:
	tuple val(Sample_name), file( Sample_file)
	file Index

	output:
	tuple val(Sample_name), file( "${Sample_name}*.fq.*.gz"), emit: host_rm_fq
	path "*summary.txt", emit: bt2_multiqc

	shell:
"""
bowtie2 -x Mix -1 ${Sample_name}paired_trim_1.fq.gz \
							 -2 ${Sample_name}paired_trim_2.fq.gz \
							 -p $task.cpus \
							 -q --un-conc-gz ${Sample_name}bt2.fq.gz \
            	 2> ${Sample_name}bt2_summary.txt
"""

}
