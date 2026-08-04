def get_busco_lineage(sample):
    group = SAMPLES[sample]["group"]

    if group not in config["busco_lineages"]:
        raise ValueError(
            f"No se encontró linaje BUSCO para el grupo {group} "
            f"(muestra {sample})"
        )

    return config["busco_lineages"][group]


rule busco:
    input:
        assembly="results/{sample}/assembly/scaffolds.fasta"

    output:
        summary="results/{sample}/busco/busco_summary.txt"

    params:
        lineage=lambda wildcards: get_busco_lineage(wildcards.sample),
        outdir="results/{sample}/busco"

    conda:
        "../../envs/busco.yaml"

    threads:
        config["busco"]["threads"]

    log:
        "logs/busco/{sample}.log"

    shell:
        r"""
        mkdir -p {params.outdir}
        mkdir -p logs/busco

        python -m busco.run_BUSCO \
            -i {input.assembly} \
            -m genome \
            -l {params.lineage} \
            -o {wildcards.sample} \
            --out_path {params.outdir} \
            --cpu {threads} \
            -f \
            > {log} 2>&1

        cp \
            {params.outdir}/{wildcards.sample}/short_summary.specific.{params.lineage}.{wildcards.sample}.txt \
            {output.summary}
        """