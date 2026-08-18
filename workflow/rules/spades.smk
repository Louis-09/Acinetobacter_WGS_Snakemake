rule spades:
    input:
        r1="results/{sample}/subsampled/{sample}_R1.fastq.gz",
        r2="results/{sample}/subsampled/{sample}_R2.fastq.gz"

    output:
        assembly=directory("results/{sample}/assembly"),
        scaffolds="results/{sample}/assembly/scaffolds.fasta",
        contigs="results/{sample}/assembly/contigs.fasta"

    threads:
        config["threads"]

    resources:
        mem_mb=config["memory_mb"]

    log:
        "logs/spades/{sample}.log"

    conda:
        "../../envs/spades.yaml"

    shell:
        r"""
        mkdir -p logs/spades

        spades.py \
            --isolate \
            -1 {input.r1} \
            -2 {input.r2} \
            -o {output.assembly} \
            --threads {threads} \
            --memory 7 \
            > {log} 2>&1
        """
