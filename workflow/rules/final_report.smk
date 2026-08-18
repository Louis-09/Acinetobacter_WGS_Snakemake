rule final_report:
    input:
        assembly_stats=expand(
            "results/{sample}/assembly_stats/{sample}.txt",
            sample=SAMPLE_NAMES
        ),
        busco=expand(
            "results/{sample}/busco/busco_summary.txt",
            sample=SAMPLE_NAMES
        ),
        mlst=expand(
            "results/{sample}/mlst/{sample}.tsv",
            sample=SAMPLE_NAMES
        ),
        amrfinder=expand(
            "results/{sample}/amrfinder/amrfinder.tsv",
            sample=SAMPLE_NAMES
        ),
        vfdb=expand(
            "results/{sample}/vfdb/{sample}_vfdb_filtered.tsv",
            sample=SAMPLE_NAMES
        ),
        mobsuite=expand(
            "results/{sample}/mobsuite/mobtyper_results.txt",
            sample=SAMPLE_NAMES
        ),
        fastani=expand(
            "results/fastani/{species}/fastani.tsv",
            species=FASTANI_SPECIES
        ),
        panaroo=expand(
            "results/panaroo/{species}/gene_presence_absence.csv",
            species=FASTANI_SPECIES
        ),
        tree=expand(
            "results/iqtree/{species}/core_genome.treefile",
            species=FASTANI_SPECIES
        ),
        iqtree=expand(
            "results/iqtree/{species}/core_genome.iqtree",
            species=FASTANI_SPECIES
        )

    output:
        report="results/final_report/genomic_report.xlsx"

    params:
        samples=SAMPLE_NAMES,
        species_groups=AUTO_SPECIES_GROUPS

    conda:
        "../../envs/report.yaml"

    script:
        "../scripts/final_report.py"
# ============================================================
# FINAL REPORT - ACINETOBACTER
# ============================================================

ACINETOBACTER_SPECIES = [
    "acinetobacter_baumannii",
    "acinetobacter_haemolyticus",
    "acinetobacter_pittii",
]

ACINETOBACTER_SAMPLES = [
    sample
    for species in ACINETOBACTER_SPECIES
    for sample in AUTO_SPECIES_GROUPS.get(species, [])
]


rule final_report_acinetobacter:
    input:
        assembly_stats=expand(
            "results/{sample}/assembly_stats/{sample}.txt",
            sample=ACINETOBACTER_SAMPLES
        ),
        busco=expand(
            "results/{sample}/busco/busco_summary.txt",
            sample=ACINETOBACTER_SAMPLES
        ),
        mlst=expand(
            "results/{sample}/mlst/{sample}.tsv",
            sample=ACINETOBACTER_SAMPLES
        ),
        amrfinder=expand(
            "results/{sample}/amrfinder/amrfinder.tsv",
            sample=ACINETOBACTER_SAMPLES
        ),
        vfdb=expand(
            "results/{sample}/vfdb/{sample}_vfdb_filtered.tsv",
            sample=ACINETOBACTER_SAMPLES
        ),
        mobsuite=expand(
            "results/{sample}/mobsuite/mobtyper_results.txt",
            sample=ACINETOBACTER_SAMPLES
        ),
        panaroo="results/panaroo/acinetobacter_baumannii/gene_presence_absence.csv",
        tree="results/iqtree/acinetobacter_baumannii/core_genome.treefile",
        iqtree="results/iqtree/acinetobacter_baumannii/core_genome.iqtree"

    output:
        report="results/final_report/genomic_report_acinetobacter.xlsx"

    params:
        samples=ACINETOBACTER_SAMPLES,
        species_groups={
            species: AUTO_SPECIES_GROUPS.get(species, [])
            for species in ACINETOBACTER_SPECIES
        }

    conda:
        "../../envs/report.yaml"

    script:
        "../scripts/final_report.py"

# ============================================================
# FINAL REPORT - KLEBSIELLA
# ============================================================

KLEBSIELLA_SPECIES = [
    "klebsiella_pneumoniae",
]

KLEBSIELLA_SAMPLES = [
    sample
    for species in KLEBSIELLA_SPECIES
    for sample in AUTO_SPECIES_GROUPS.get(species, [])
]

rule final_report_klebsiella:
    input:
        assembly_stats=expand(
            "results/{sample}/assembly_stats/{sample}.txt",
            sample=KLEBSIELLA_SAMPLES
        ),
        busco=expand(
            "results/{sample}/busco/busco_summary.txt",
            sample=KLEBSIELLA_SAMPLES
        ),
        mlst=expand(
            "results/{sample}/mlst/{sample}.tsv",
            sample=KLEBSIELLA_SAMPLES
        ),
        amrfinder=expand(
            "results/{sample}/amrfinder/amrfinder.tsv",
            sample=KLEBSIELLA_SAMPLES
        ),
        vfdb=expand(
            "results/{sample}/vfdb/{sample}_vfdb_filtered.tsv",
            sample=KLEBSIELLA_SAMPLES
        ),
        mobsuite=expand(
            "results/{sample}/mobsuite/mobtyper_results.txt",
            sample=KLEBSIELLA_SAMPLES
        ),
        panaroo="results/panaroo/klebsiella_pneumoniae/gene_presence_absence.csv",
        tree="results/iqtree/klebsiella_pneumoniae/core_genome.treefile",
        iqtree="results/iqtree/klebsiella_pneumoniae/core_genome.iqtree"

    output:
        report="results/final_report/genomic_report_klebsiella.xlsx"

    params:
        samples=KLEBSIELLA_SAMPLES,
        species_groups={
            species: AUTO_SPECIES_GROUPS.get(species, [])
            for species in KLEBSIELLA_SPECIES
        }

    conda:
        "../../envs/report.yaml"

    script:
        "../scripts/final_report_klebsiella.py"
