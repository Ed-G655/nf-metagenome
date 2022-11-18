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

/* SAM_to_BAM */

process SAM_TO_BAM {
	container 'edugarcia156/nf-metagenome'
	tag "$Sample_name"

	publishDir "${intermediates_dir}/SAM_to_BAM/",mode:"symlink"
	input:
	tuple val(Sample_name), file( Sample_file)

	output:
	tuple val(Sample_name), file( "${Sample_name}*.bam"), emit: bt2_bam

	shell:
	"""
	echo "[DEBUG] Convert SAM to BAM"

	samtools view -@ $task.cpus \
							-bS ${Sample_file} > ${Sample_name}raw.bam

	echo "[DEBUG]  Extract unmapped reads (non-host)"

	samtools view -@ $task.cpus \
							-b -f 12 -F 256 ${Sample_name}raw.bam > ${Sample_name}unmap.bam

	echo "[DEBUG]  Sort BAM"

	samtools sort -n ${Sample_name}unmap.bam \
								-o ${Sample_name}sorted.bam

	"""

}

//samtools bam2fq ${Sample_name}sorted.bam > ${Sample_name}.fastq

//echo "[DEBUG] split paired-end reads into separated fastq files"
