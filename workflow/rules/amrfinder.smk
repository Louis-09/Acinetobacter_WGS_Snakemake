def get_amrfinder_organism(wildcards):
    sample = wildcards.sample

    # Excepción específica por muestra, si existe
    overrides = config.get("amrfinder_sample_overrides", {})

    if sample in overrides:
        return overrides[sample]

    # En caso contrario, usar el grupo de la carpeta de reads
    group = SAMPLES[sample]["group"]

    organism = config["amrfinder_organisms"].get(group)

    if organism is None:
        raise ValueError(
            f"No AMRFinder organism configured for group '{group}' "
            f"(sample '{sample}')"
        )

    return organism


rule amrfinder:
    input:
        assembly="results/{sample}/assembly/contigs.fasta"
    output:
        report="results/{sample}/amrfinder/amrfinder.tsv"
    log:
        "logs/amrfinder/{sample}.log"
    conda:
        "../../envs/amrfinder.yaml"
    threads:
        config["amrfinder"]["threads"]
    params:
        organism=get_amrfinder_organism
    shell:
        r"""
        mkdir -p results/{wildcards.sample}/amrfinder
        mkdir -p logs/amrfinder

        amrfinder \
            --database {config[amrfinder][database]} \
            -n {input.assembly} \
            -O {params.organism} \
            -o {output.report} \
            > {log} 2>&1
        """