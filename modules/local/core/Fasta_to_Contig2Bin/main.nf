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

/* FASTA_TO_CONTING2BIN */

process FASTA_TO_CONTING2BIN {
	tag "$Sample_name"

	publishDir "${results_dir}/Fasta_to_Contig2Bin/",mode:"copy"

	input:
	tuple val(Sample_name), path(Fasta_bins)

	output:
	tuple val(Sample_name), file("${Sample_name}${params.tool}/${Sample_name}${params.binning_tool}.contig2bin.tsv")

	shell:
	"""
	echo "[DEBUG] Make sample_assembly_tool dir"
	mkdir ${Sample_name}${params.tool}/

	echo "[DEBUG] Converts genome bins in fasta format to scaffolds-to-bin table"
	Fasta_to_Contig2Bin.sh -i $Fasta_bins -e ${params.extension} > ${Sample_name}${params.tool}/${Sample_name}${params.binning_tool}.contig2bin.tsv

	"""

}
