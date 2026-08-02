def get_busco_lineage(sample):
    for species, samples in config["species_groups"].items():
        if sample in samples:
            return config["busco_lineages"][species]

    raise ValueError(
        f"No se encontró grupo de especie para la muestra {sample}"
    )


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