rule mobsuite:
    input:
        assembly="results/{sample}/assembly/scaffolds.fasta"

    output:
        report="results/{sample}/mobsuite/mobtyper_results.txt"

    conda:
        "../../envs/mobsuite.yaml"

    threads:
        config["mobsuite"]["threads"]

    log:
        "logs/mobsuite/{sample}.log"

    shell:
       r"""
       rm -rf results/{wildcards.sample}/mobsuite
       mkdir -p logs/mobsuite

       mob_recon \
          --infile {input.assembly:q} \
          --outdir results/{wildcards.sample}/mobsuite \
          > {log:q} 2>&1
      """
