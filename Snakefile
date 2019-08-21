shell.prefix( "source env.sh ; set -eo pipefail ; " )

configfile: "config.json"
SAMPLES = config['samples'].keys()
print(SAMPLES)
REF = config['ref']
FAI = config['fai']
print(REF)

def _get_input_reads(wildcards):
    print(wildcards.name)
    return config['samples'][wildcards.name]


rule dummy:
     input: expand("{name}.gc.cov.txt", name=SAMPLES)

#rule plot:
#     input: KMERS="merge/{name}.hapmers.counts"
#     output: "summary/{name}.pdf", "summary/{name}.txt"
#     shell: """
#	  Rscript scripts/blobPlot.R --infile {input.KMERS} --prefix summary/{wildcards.name}
#     """

rule get_cov:
   input: BAM = "{name}.aln.sort.bam", BED = config['ref'].replace("fasta","100bp-win.bed") 
   output: {name}.gc.cov.txt
   shell: """
      bedtools coverage -mean -sorted -b {input.BAM} -a {input.BED} > {output}
   """

rule get_gc:
   input: REF=config['ref'], BED={input.REF}.replace("fasta","100bp-win.bed")
   output: {input.BED}.replace("bed","gc.bed")
   shell: """
      bedtools nuc -fi {input.REF} -bed {input.BED} | awk '{print $1, $2, $3, $5, $12}' > {output}
      tail -n +2 {output} > tmp
      mv tmp {output}
   """

rule make_windows:
   input: FAI = config['fai']
   output: BED = {input.REF}.replace("fasta","100bp-win.bed")
   shell: """
      bedtools makewindows -g {input.FAI} -w 100 > {output.BED}
     """

rule aln:
   input: REF=config['ref'], READS= _get_input_reads
   output: "{name}.aln.sort.bam"
   message: "Mapping reads to ref."
   shell: """
      pbmm2 align --preset CCS --sort -j 8 -J 8 {input.REF} {input.READS} {output}
   """
