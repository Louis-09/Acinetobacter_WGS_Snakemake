def get_panaroo_gffs(wildcards):
    samples = config["species_groups"][wildcards.species]

    return [
        f"results/{sample}/prokka/{sample}.gff"
        for sample in samples
    ]


rule panaroo:
    input:
        gffs=get_panaroo_gffs
    output:
        presence_absence="results/panaroo/{species}/gene_presence_absence.csv",
        core_alignment="results/panaroo/{species}/core_gene_alignment.aln",
        core_alignment_filtered="results/panaroo/{species}/core_gene_alignment_filtered.aln"

    log:
        "logs/panaroo/{species}.log"

    conda:
        "../../envs/panaroo.yaml"

    threads:
        config["panaroo"]["threads"]

    shell:
        r"""
        mkdir -p results/panaroo/{wildcards.species}
        mkdir -p logs/panaroo

        panaroo \
            -i {input.gffs:q} \
            -o results/panaroo/{wildcards.species} \
            --clean-mode strict \
            -a core \
            --aligner mafft \
            -t {threads} \
            > {log:q} 2>&1
        """
