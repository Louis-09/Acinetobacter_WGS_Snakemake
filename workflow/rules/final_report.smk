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
            "results/{sample}/vfdb/{sample}_vfdb.tsv",
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
        species_groups=config["species_groups"]

    conda:
        "../../envs/report.yaml"

    script:
        "../scripts/final_report.py"
