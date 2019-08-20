# Purpose

Tool for generating coverage boxplots for different GC% windows.

# Dependencies
`snakemake`

`R v3.4.1`

`samtools v1.9`

`bedtools 2.27.1`

`pbmm2`


# Usage

## Login to compute node with 8 cores
`qrsh -q default -pe smp 8`


## Load Dependencies
`module load snakemake/5.4.3-ve`


## Edit config.json

Copy the config.json to the folder you want to run in.
Specify your file paths and tags.


## Run It
`snakemake -s Snakefile --verbose -p`


# Input

1. Reference sequence in fasta format
2. HiFi reads in fasta


# Output

`summary` directory contains `PDF` of boxplots of coverage.
