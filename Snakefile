from workflow.common import discover_samples

configfile: "config/config.yaml"

SAMPLES = discover_samples()
SAMPLE_NAMES = sorted(SAMPLES.keys())

include: "workflow/rules/fastqc.smk"
include: "workflow/rules/fastp.smk"
include: "workflow/rules/multiqc.smk"  
include: "workflow/rules/subsample.smk"     
include: "workflow/rules/spades.smk"
include: "workflow/rules/assembly_stats.smk"
include: "workflow/rules/busco.smk"
include: "workflow/rules/bakta.smk"
include: "workflow/rules/prokka.smk"
include: "workflow/rules/panaroo.smk"
include: "workflow/rules/mlst.smk"
include: "workflow/rules/amrfinder.smk"
include: "workflow/rules/vfdb.smk"
include: "workflow/rules/mobsuite.smk"
include: "workflow/rules/fastani.smk"
include: "workflow/rules/iqtree.smk"

FASTANI_SPECIES = [
    species
    for species, samples in config["species_groups"].items()
    if len(samples) >= 2
]

include: "workflow/rules/final_report.smk"

rule all:
    input:
        expand(
            "results/{sample}/fastqc",
            sample=SAMPLE_NAMES
        ),

        expand(
            "results/{sample}/trimmed/{sample}_R1.fastq.gz",
            sample=SAMPLE_NAMES
        ),

        expand(
            "results/{sample}/trimmed/{sample}_R2.fastq.gz",
            sample=SAMPLE_NAMES
        ),

        expand(
            "results/{sample}/trimmed/{sample}_fastp.html",
            sample=SAMPLE_NAMES
        ),

        expand(
            "results/{sample}/trimmed/{sample}_fastp.json",
            sample=SAMPLE_NAMES
        ),

        "results/multiqc/multiqc_report.html",

        # NUEVO
        expand(
            "results/{sample}/subsampled/{sample}_R1.fastq.gz",
            sample=SAMPLE_NAMES
        ),

        expand(
            "results/{sample}/subsampled/{sample}_R2.fastq.gz",
            sample=SAMPLE_NAMES
        ),
                
        expand(
            "results/{sample}/assembly/scaffolds.fasta",
            sample=SAMPLE_NAMES
        ),

        expand(
            "results/{sample}/assembly_stats/{sample}.txt",
            sample=SAMPLE_NAMES
        ),

        expand(
            "results/{sample}/busco/busco_summary.txt",
            sample=SAMPLE_NAMES
        ),

        expand(
            "results/{sample}/bakta/{sample}.gff3",
            sample=SAMPLE_NAMES
        ),

        expand(
            "results/{sample}/bakta/{sample}.faa",
        sample=SAMPLE_NAMES
        ),

        expand(
            "results/{sample}/bakta/{sample}.ffn",
            sample=SAMPLE_NAMES
        ),

        expand(
            "results/{sample}/bakta/{sample}.gbff",
            sample=SAMPLE_NAMES
        ),

        expand(
            "results/{sample}/bakta/{sample}.tsv",
        sample=SAMPLE_NAMES
        ),

        expand(
            "results/{sample}/mlst/{sample}.tsv",
            sample=SAMPLE_NAMES
        ),
        expand(
            "results/{sample}/amrfinder/amrfinder.tsv",
            sample=SAMPLE_NAMES
        ), 
        expand(
            "results/{sample}/vfdb/{sample}_vfdb.tsv",
            sample=SAMPLE_NAMES
        ),

        expand(
            "results/{sample}/mobsuite/mobtyper_results.txt",
            sample=SAMPLE_NAMES
        ),

        expand(
            "results/{sample}/prokka/{sample}.gff",
            sample=SAMPLE_NAMES
        ),

        expand(
            "results/fastani/{species}/fastani.tsv",
            species=FASTANI_SPECIES
        ),

        expand(
            "results/panaroo/{species}/gene_presence_absence.csv",
            species=FASTANI_SPECIES
        ),

        expand(
            "results/panaroo/{species}/core_gene_alignment_filtered.aln",
            species=FASTANI_SPECIES
        ),

        expand(
            "results/iqtree/{species}/core_genome.treefile",
            species=FASTANI_SPECIES
        ),

        "results/final_report/genomic_report.xlsx",
        
    
