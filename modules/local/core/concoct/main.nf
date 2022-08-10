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

/* CONCOCT */

process CONCOCT {
	container 'quay.io/biocontainers/concoct:1.1.0--py38h7be5676_2'
	tag "$Sample_name"

	publishDir "${results_dir}/concoct/",mode:"copy"

	input:
	tuple val(Sample_name), file(Contig)
	tuple val(Sample_name), file(BAM)

	output:
 	path "*"
	tuple val(Sample_name), path( "concoct_${Sample_name}/fasta_bins/"), emit: concoct_bins

	shell:
	"""

	echo "[DEBUG] Slice contigs into smaller sequences"

	cut_up_fasta.py $Contig -c 10000 -o 0 --merge_last -b contigs_10K.bed > contigs_10K.fa

	echo "[DEBUG]  Generate coverage depth"
  concoct_coverage_table.py contigs_10K.bed ${Sample_name}.bam > coverage_table.tsv

	echo "[DEBUG]   Execute CONCOCT"
	concoct --composition_file contigs_10K.fa --coverage_file coverage_table.tsv -b concoct_${Sample_name}/ -t $task.cpus

	echo "[DEBUG]   Merge sub-contig clustering into original contig clustering"
	merge_cutup_clustering.py concoct_${Sample_name}/clustering_gt1000.csv > concoct_${Sample_name}/clustering_merged.csv

	echo "[DEBUG]   Create output folder for bins"
	mkdir concoct_${Sample_name}/fasta_bins

	echo "[DEBUG] Parse bins into different files"
	extract_fasta_bins.py $Contig concoct_${Sample_name}/clustering_merged.csv --output_path concoct_${Sample_name}/fasta_bins

	"""

}
