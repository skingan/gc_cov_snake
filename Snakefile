shell.prefix( "source env.sh ; set -eo pipefail ; " )

import os

configfile: "config.json"
SAMPLES = config['samples'].keys()
print(SAMPLES)
REFERENCE = config['ref']
FAI = config['fai']
BASENAME = os.path.basename(REFERENCE).replace(".fasta","")
print(REFERENCE)
print(BASENAME)

def _get_input_reads(wildcards):
    print(wildcards.name)
    return config['samples'][wildcards.name]

rule dummy:
   input: expand("output/{name}.pdf", name=SAMPLES) 

rule plot:
   input: DATA="output/{name}.100bp-win.gc.cov.txt"
   output: "output/{name}.pdf"
   shell: """
      boxplot.R --infile {input.DATA} --prefix {wildcards.name}
   """

rule merge:
   input: COV = "bed/{name}.cov.bed", GC = f"bed/{BASENAME}.gc.bed"
   output: DATA = "output/{name}.100bp-win.gc.cov.txt"
   shell: """
      paste -d'\t' {input.GC} {input.COV} | awk '{{print $1, $2, $3, $4, $5, $6, $7, $8, $9, $13}}' > {output.DATA}
   """

rule get_cov:
   input: BAM = "bam/{name}.aln.sort.bam", BED = f"bed/{BASENAME}.100bp-win.bed" 
   output: COV = "bed/{name}.cov.bed"
   shell: """
      bedtools coverage -mean -sorted -b {input.BAM} -a {input.BED} > {output.COV}
   """

rule get_gc:
   input: REF=REFERENCE, BED=f"bed/{BASENAME}.100bp-win.bed"
   output: GC=f"bed/{BASENAME}.gc.bed"
   shell: """
      bedtools nuc -fi {input.REF} -bed {input.BED} | awk '{{print $1, $2, $3, $5, $6/$12, $7/$12, $8/$12, $9/$12, $12}}' > {output.GC}
      tail -n +2 {output.GC} > tmp
      mv tmp {output.GC}
   """

rule make_windows:
   input: GENOME = FAI
   output: BED = f"bed/{BASENAME}.100bp-win.bed"
   shell: """
      bedtools makewindows -g {input.GENOME} -w 100 > {output.BED}
     """

rule aln:
   input: REF=REFERENCE, READS= _get_input_reads
   output: "bam/{name}.aln.sort.bam"
   message: "Mapping reads to ref."
   shell: """
      pbmm2 align --preset CCS --sort -j 8 -J 8 {input.REF} {input.READS} {output}
   """
