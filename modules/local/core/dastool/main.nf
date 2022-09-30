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

/* DASTOOL */

process DASTOOL {
	container 'quay.io/biocontainers/das_tool:1.1.4--r41hdfd78af_1'
	tag "$Sample_name"

	publishDir "${results_dir}/dastool/",mode:"copy"

	input:
	tuple val(Sample_name), file(TSV_maxbin), file(TSV_metabat), file(TSV_concoct)
	tuple val(Sample_name), file(Contig)

	output:
	tuple val(Sample_name), path("${Sample_name}${params.tool}_DASTool_bins/"), emit: bins_dastool
	tuple val(Sample_name), path("${Sample_name}${params.tool}bins.txt"), emit: bins_txt
	path "*"

	shell:
	"""
	echo "[DEBUG]   Run DAS_tool  for ${TSV_maxbin}, ${TSV_metabat}"
	DAS_Tool -i ${TSV_maxbin},${TSV_metabat} -l maxbin,metabat -c ${Contig} -t ${task.cpus} --write_bins -o ${Sample_name}${params.tool}

	echo "[DEBUG] Write bins list"
	ls ${Sample_name}${params.tool}_DASTool_bins/*.fa | tr " " "\n" > ${Sample_name}${params.tool}bins.txt

	"""

}

//DAS_Tool -i ${TSV_maxbin},${TSV_metabat} -l maxbin,metabat -c ${Contig} -t ${task.cpus} --write_bins -o ${Sample_name}${params.tool}

//sed 's/.concoct_part_*//' -i ${TSV_concoct}
//DAS_Tool -i ${TSV_maxbin},${TSV_metabat},${TSV_concoct} -l maxbin,metabat,concoct -c ${Contig} -t ${task.cpus} --write_bins -o ${Sample_name}${params.tool}
