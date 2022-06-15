#!/usr/bin/env nextflow
/*================================================================

								---- MODULE PIPELINE ---------

/*================================================================
The Aguilar Lab presents...

- A pipeline to realize a global aligment between FASTA query sequences and
    FASTA reference sequence file

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
pipeline_name = "nf-align_proteins.nf"

/*This directories will be automatically created by the pipeline to store files during the run
*/
results_dir = "${params.output_dir}/${pipeline_name}-results/"
intermediates_dir = "${params.output_dir}/${pipeline_name}-intermediate/"

/*================================================================/*

/* MODULE START */

/* PRE1_CONVERT_GFF_TO_BED */

process ALIGN_SEQ {
	tag "$REF, $QUERY"

	publishDir "${results_dir}/align-seq/",mode:"copy"

	input:
	tuple val(PROT), file(REF), file(QUERY)
	each Python_script

	output:
	file "*.tsv"

	shell:
	"""
  python3 ${Python_script} ${REF} ${QUERY} ${PROT}.tsv

	"""
	stub:
	"""
	      touch  ${PROT}.tsv
	"""
}
