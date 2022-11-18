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

/* METASPADES */

process METASPADES {
	container 'staphb/spades'
	tag "$Sample_name"

	publishDir "${results_dir}/metaspades/",mode:"copy"

	input:
	tuple val(Sample_name), file( Sample_file)

	output:
 	path "${Sample_name}metaspades/*"
	tuple val(Sample_name), file( "${Sample_name}metaspades/${Sample_name}metaspades.fasta"), emit: assembly_metaspades

	shell:
	"""

	echo "[DEBUG] Performing PE assembly with files ${Sample_file}"

	spades.py --meta \
            -o "${Sample_name}metaspades" \
            -1 ${Sample_name}R1.fastq.gz \
            -2 ${Sample_name}R2.fastq.gz \
            -t $task.cpus
	cp ${Sample_name}metaspades/contigs.fasta ${Sample_name}metaspades/${Sample_name}metaspades.fasta


	"""

}

//samtools bam2fq ${Sample_name}sorted.bam > ${Sample_name}.fastq

//echo "[DEBUG] split paired-end reads into separated fastq files"
