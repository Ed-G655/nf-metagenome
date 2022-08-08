cd ..

fastq_dir="/bodega/projects/metagenome_pipeline/data"
output_directory="/bodega/projects/metagenome_pipeline/results"

echo -e "======\n Testing NF execution \n======" \
&& rm -rf $output_directory \
&& nextflow run nf-metagenome.nf \
	--fastq_dir $fastq_dir \
	--output_dir $output_directory \
	-resume \
	-with-report $output_directory/`date +%Y%m%d_%H%M%S`_report.html \
	-with-dag $output_directory/`date +%Y%m%d_%H%M%S`.DAG.html \
	-with-timeline $output_directory/`date +%Y%m%d_%H%M%S`_timeline.html \
	-with-docker \
&& echo -e "======\n  Pipeline  execution SUCCESSFUL \n======"
