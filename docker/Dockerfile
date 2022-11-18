
################## BASE IMAGE ######################
FROM rocker/tidyverse
################## METADATA ######################
LABEL base_image="rocker/tidyverse"
LABEL version="0.1"
LABEL software="nf-metagenome"
LABEL software.version="0.1"
LABEL about.summary=" Nextflow pipeline to analyse metagenome data "
LABEL about.documentation="https://github.com/Ed-G655/nf-metagenome"
LABEL about.tags="Metagenomics"

################## MAINTAINER ######################
MAINTAINER Jose Eduardo Garcia Lopez <jeduardogl655@gmail.com>

################## INSTALLATION ######################

# install pipeline requirements
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl \
  trimmomatic \
  fastqc \
  git


# install python3 and pip
RUN apt-get install -y --no-install-recommends \
      python3.5 \
      python3-pip \
      && apt-get clean && \
      rm -rf /var/lib/apt/lists/*

# install multiqc
RUN pip install multiqc

# install mk
RUN git clone https://github.com/9fans/plan9port.git
RUN cd plan9port && ./INSTALL
RUN  ln -s /plan9port/bin/mk /bin

# install pipeline requirements
RUN apt-get update && apt-get install -y --no-install-recommends \
  wget \
  zip \
  unzip \
  autoconf \
  automake \
  make

# install bowtie2
RUN wget https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.4.4/bowtie2-2.4.4-source.zip/download -O bowtie2.zip
RUN unzip bowtie2.zip
RUN cd bowtie2-2.4.4 && make
ENV PATH="/bowtie2-2.4.4:${PATH}"

# Install samtools requirements
RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    make \
    gcc \
    perl \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-gnutls-dev \
    libssl-dev \
    bzip2 \
    libncurses5-dev

# Install samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2 -O samtools.tar.bz2
RUN tar -xjvf samtools.tar.bz2
RUN cd samtools-1.3.1 && make && make prefix=/usr/local/bin install
RUN ln -s /usr/local/bin/bin/samtools /usr/bin/samtools

# Install bedtools
RUN apt-get install -y --no-install-recommends bedtools

# Install htslib
RUN wget https://github.com/samtools/htslib/releases/download/1.3.2/htslib-1.3.2.tar.bz2 -O htslib.tar.bz2
RUN tar -xjvf htslib.tar.bz2
RUN cd htslib-1.3.2 && make && make install


# Install Spades
RUN wget http://cab.spbu.ru/files/release3.15.4/SPAdes-3.15.4-Linux.tar.gz
RUN tar -xzf SPAdes-3.15.4-Linux.tar.gz
ENV PATH="/SPAdes-3.15.4-Linux/bin/:${PATH}"

# Change python3 env to python, needed to run spades scripts
RUN apt-get install python-is-python3

# Install megahit
RUN wget https://github.com/voutcn/megahit/releases/download/v1.2.9/MEGAHIT-1.2.9-Linux-x86_64-static.tar.gz
RUN tar zvxf MEGAHIT-1.2.9-Linux-x86_64-static.tar.gz
ENV PATH="/MEGAHIT-1.2.9-Linux-x86_64-static/bin/:${PATH}"

# Install metabat2
RUN apt-get update && apt-get install -y \
  libboost-all-dev\
  gzip \
  build-essential \
  python-setuptools \
  libstdc++6 \
  libboost-all-dev \
  cmake \
  libncurses5-dev \
  zlib1g-dev

# #Install maxbin
#
# RUN cpanm LWP
# RUN cpanm FindBin
# RUN git clone https://git.code.sf.net/p/maxbin/code maxbin-code
# RUN cd maxbin-code && cd src && make && cd ..
# RUN bash ./autobuild_auxiliary
#
# ## Install checkM
# RUN pip install numpy matplotlib pysam checkm-genome
# # Download checkM database TO SLOW Download
# RUN wget --no-check-certificate https://data.ace.uq.edu.au/public/CheckM_databases/checkm_data_2015_01_16.tar.gz
# RUN  mkdir -p /checkm_database && tar xzf checkm_data_2015_01_16.tar.gz -C /checkm_database
# RUN echo /checkm_database | checkm data setRoot /

####  Install Dastool
# Install dependecies
# RUN apt-get install -y --no-install-recommends \
#   libpcre3 \
#   libpcre3-dev \
#   libgsl0-dev \
#   libgomp1 \
#   lzma \
#   ncbi-blast+ \
#   ruby-full
#
# # Prodigal
# RUN cd /tmp && \
#     wget https://github.com/hyattpd/Prodigal/releases/download/v2.6.3/prodigal.linux && \
#     mv prodigal.linux /bin/prodigal && \
#     chmod +x /bin/prodigal
#
# # Pullseq
# RUN cd /tmp && \
#     git clone https://github.com/bcthomas/pullseq.git && \
#     cd pullseq && \
#     ./bootstrap && \
#     ./configure --prefix=/ && \
#     make && \
#     make install && \
#     rm -rf /tmp/pullseq.zip /tmp/pullseq-master
#
# # install R packages
# RUN Rscript -e "install.packages('data.table')"
# RUN Rscript -e "install.packages('magrittr')"
# RUN Rscript -e "install.packages('docopt')"
#
# #Install Dastool
# RUN git clone https://github.com/cmks/DAS_Tool.git
# RUN cd DAS_Tool && unzip db.zip -d db && rm db.zip
# RUN chmod +x DAS_Tool
# ENV PATH="/DAS_Tool/:${PATH}"
#
# # Add src tools to PATH
# ENV PATH="/DAS_Tool/src:${PATH}"

# Install requirements
RUN apt-get install -y --no-install-recommends \
  less
