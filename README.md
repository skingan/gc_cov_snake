# Purpose

Tool for generating coverage boxplots for different GC% windows.

# Dependencies
`snakemake/5.4.3-ve`

`R v3.4.1`

`samtools v1.9`

`bedtools 2.27.1`

`pbmm2/current`


# Usage

## Login to compute node with 8 cores
`qrsh -q default -pe smp 8`


## Load Dependencies
`module load snakemake/5.4.3-ve`


## Edit config.json

Copy the config.json to the folder you want to run in.


## Export path
`export PATH=$PATH:{snakemake clone dir}:{snakemake clone dir/scripts}


## Run It
`snakemake -s /path/to/gc_cov_snake/Snakefile --configfile config.json -d $PWD`


# Input

1. Reference sequence in fasta format
2. FAI index for reference
3. HiFi reads in fasta


# Output

`output` directory contains `PDF` of boxplots of coverage and data file.
