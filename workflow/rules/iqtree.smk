rule iqtree:
    input:
        alignment="results/Panaroo/core_gene_alignment_filtered.aln"
    output:
        tree="results/IQTree/final/core_genome.treefile",
        report="results/IQTree/final/core_genome.iqtree",
        log_file="results/IQTree/final/core_genome.log"
    log:
        "logs/iqtree/core_genome.log"
    conda:
        "../../envs/iqtree.yaml"
    threads:
        config["iqtree"]["threads"]
    shell:
        r"""
        mkdir -p results/IQTree/final
        mkdir -p logs/iqtree

        iqtree3 \
            -s {input.alignment} \
            -m MFP \
            -T {threads} \
            -pre results/IQTree/final/core_genome \
            > {log} 2>&1
        """
