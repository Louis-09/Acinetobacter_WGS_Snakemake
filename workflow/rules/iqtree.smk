rule iqtree:
    input:
        alignment="results/panaroo/{species}/core_gene_alignment_filtered.aln"

    output:
        tree="results/iqtree/{species}/core_genome.treefile",
        report="results/iqtree/{species}/core_genome.iqtree",
        log_file="results/iqtree/{species}/core_genome.log"

    log:
        "logs/iqtree/{species}.log"

    conda:
        "../../envs/iqtree.yaml"

    threads:
        config["iqtree"]["threads"]

    shell:
        r"""
        mkdir -p results/iqtree/{wildcards.species}
        mkdir -p logs/iqtree

        iqtree3 \
            -s {input.alignment:q} \
            -m MFP \
            -T {threads} \
            -pre results/iqtree/{wildcards.species}/core_genome \
            > {log:q} 2>&1
        """
