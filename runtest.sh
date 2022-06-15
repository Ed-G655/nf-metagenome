fastq_dir="test/data/"
output_directory="$(dirname $fastq_dir)/results"

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
&& echo -e "======\n Basic pipeline TEST SUCCESSFUL \n======"
