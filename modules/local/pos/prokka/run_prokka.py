#!/usr/bin/env python3

""" This scrip run prokka on each bin FASTA file from _DASTool_bins

-The script takes a list bin paths

Basic ideas:
    1. Read list with paths
    2. Parse list to run prokka on each FASTA

Autor:  Eduardo García López"""

## Import python libraries
import sys
import subprocess


## Read args from command line
    ## Uncomment For debugging only
    ## Comment for production mode only
#sys.argv = ("0", "test.txt")

##get IDs list
file_list = sys.argv[1]
outdir = sys.argv[2]


#Read file as list
files = open(str(file_list), "r").readlines()

print(file_list)

for file in files:
    path = file.replace('\n', '')
    prefix = file.replace('\n', '').replace('.fa', '_prokka').split('/')
    print ("Run prokka at {}".format(path))
    #Dedine to run prokka
    prokka = "prokka ./{} --outdir {} --prefix {}".format(path, outdir, prefix[1])
    print ("The command used was: " + prokka)
    #Pass command to shell
    subprocess.call(prokka, shell=True)
