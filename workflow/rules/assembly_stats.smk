rule assembly_stats:
    input:
        "results/{sample}/assembly/scaffolds.fasta"

    output:
        "results/{sample}/assembly_stats/{sample}.txt"

    shell:
        """
        mkdir -p results/{wildcards.sample}/assembly_stats
        assembly-stats {input} > {output}
        """