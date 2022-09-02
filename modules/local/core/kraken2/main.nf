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

/* ASSEMBLY_COVERAGE */

process ASSEMBLY_COVERAGE  {
	container 'quay.io/biocontainers/kraken2:2.1.2--pl5321h7d875b9_1'
	tag "$Sample_name"

	publishDir "${results_dir}/kraken2/", mode:"copy"
	input:
	tuple val(Sample_name), file( Sample_file)

	output:
	tuple val(Sample_name), file("*.{bam,bai}")

	shell:

	"""
	echo "Build index from CONTIG: ${Contig}"
	bowtie2-build ${Contig} final.contigs --threads $task.cpus

	echo "Aligning reads to index and write BAM file"
	bowtie2 -x final.contigs -1 ${Sample_name}R1.fastq.gz -2 ${Sample_name}R2.fastq.gz | \
	samtools view -bS -o ${Sample_name}to_sort.bam
	samtools sort ${Sample_name}to_sort.bam -o ${Sample_name}.bam
	samtools index ${Sample_name}.bam

	"""
}
