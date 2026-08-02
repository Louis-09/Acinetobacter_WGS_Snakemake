rule mlst:
    input:
        assembly="results/{sample}/assembly/scaffolds.fasta"
    output:
        tsv="results/{sample}/mlst/{sample}.tsv"
    conda:
        "../../envs/mlst.yaml"
    threads: 1
    shell:
        r"""
        mkdir -p results/{wildcards.sample}/mlst
        mlst {input.assembly} > {output.tsv}
        """
