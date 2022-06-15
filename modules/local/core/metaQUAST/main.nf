#!/usr/bin/env nextflow
/*
================================================================

								---- MODULE PIPELINE ---------

================================================================

This module evaluate genome assembly with metaQUAST

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

/* METAQUAST */

process METAQUAST {
	container 'quay.io/biocontainers/quast:5.0.1--py27pl526ha92aebf_0'
	tag "$Sample_name"

	publishDir "${results_dir}/metaQUAST/",mode:"copy"

	input:
	tuple val(Sample_name), file(Sample_file)

	output:
 	path "*"

	shell:
	"""

	echo "[DEBUG] evaluate genome assembly with metaQUAST: ${Sample_file}"

	metaquast.py $Sample_file -o $params.tool/$Sample_name --threads $task.cpus --min-contig 50

	"""

}
