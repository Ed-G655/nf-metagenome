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

/* QA_FILTER */

process QA_FILTER {
	container 'edugarcia156/nf-metagenome'
	tag "$Sample_name"

	publishDir "${results_dir}/QA/${params.quality}", mode:"symlink"

	input:
	tuple val(Sample_name), file(QA)
	tuple val(Sample_name), path(Dastool_fasta)
	val Min_completeness
	val Max_contamination
	file filter_script

	output:
	tuple val(Sample_name), file("*.txt"), emit: filtered_bins
	tuple val(Sample_name), path("${params.tool}_${params.quality}_bins/*"), emit: fasta_bins
	path "*.tsv"

	"""
	echo "[DEBUG]  Change qa to tsv"
	less -S $QA | tr -d "#-"  | tr -s " " | tr " " "\t" | cut -f2,8,9 | awk -F "\t" '{ if(\$2 >= $Min_completeness && \$3 <= $Max_contamination) { print } }' > $params.tool'_'$Sample_name$params.quality'.tsv'

	echo "[DEBUG]  Filter high QA"
	less -S $params.tool'_'$Sample_name$params.quality'.tsv'  | cut -f1 > $params.tool'_'$Sample_name$params.quality'.txt'

	echo "[DEBUG]   Filter bins files ${Dastool_fasta}"
	mkdir $params.tool'_'$params.quality'_bins'
	python filter_files_bins.py $params.tool'_'$Sample_name$params.quality'.txt' ${Dastool_fasta} $params.tool'_'$params.quality'_bins'

	"""

}
