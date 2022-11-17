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
fasta_dir = sys.argv[2]
outdir = sys.argv[3]


#Read file as list
files = open(str(file_list), "r").readlines()

print(file_list)

for file in files:
    path = file.replace('\n', '.fa')
    path_dir = str(fasta_dir) + "/" + path
    out = outdir + "/" + path
    print ("Make simbolyc link at {}".format(path_dir))
    #Dedine to run prokka
    ln = "ln -s ./{} ./{} ".format(path_dir, out)
    print ("The command used was: " + ln)
    #Pass command to shell
    subprocess.call(ln, shell=True)
