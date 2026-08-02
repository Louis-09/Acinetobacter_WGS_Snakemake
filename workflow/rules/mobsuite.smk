rule mobsuite:
    input:
        assembly="results/{sample}/assembly/scaffolds.fasta"

    output:
        report="results/{sample}/mobsuite/mobtyper_results.txt"

    conda:
        "../../envs/mobsuite.yaml"

    threads: 8

    log:
        "logs/mobsuite/{sample}.log"

    shell:
        r"""
        mkdir -p results/{wildcards.sample}/mobsuite
        mkdir -p logs/mobsuite

        mob_recon \
            --infile {input.assembly} \
            --outdir results/{wildcards.sample}/mobsuite \
            > {log} 2>&1
        """