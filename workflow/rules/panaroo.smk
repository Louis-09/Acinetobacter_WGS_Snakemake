def get_panaroo_gffs(wildcards):
    samples = config["species_groups"][wildcards.species]

    return [
        f"results/{sample}/bakta/{sample}.gff3"
        for sample in samples
    ]


rule panaroo:
    input:
        gffs=get_panaroo_gffs
    output:
        presence_absence="results/panaroo/{species}/gene_presence_absence.csv",
        core_alignment="results/panaroo/{species}/core_gene_alignment.aln"
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
            -i {input.gffs} \
            -o results/panaroo/{wildcards.species} \
            --clean-mode strict \
            -a core \
            --aligner mafft \
            -t {threads} \
            > {log} 2>&1
        """
