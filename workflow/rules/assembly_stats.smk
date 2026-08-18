rule assembly_stats:
    input:
        fasta="results/{sample}/assembly/scaffolds.fasta"

    output:
        stats="results/{sample}/assembly_stats/{sample}.txt"

    conda:
        "../../envs/assembly_stats.yaml"

    shell:
        r"""
        mkdir -p results/{wildcards.sample}/assembly_stats

        assembly-stats {input.fasta:q} > {output.stats:q}
        """
