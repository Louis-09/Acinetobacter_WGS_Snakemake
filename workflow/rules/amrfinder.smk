def get_amrfinder_organism(wildcards):
    sample = wildcards.sample

    for species, samples in config["species_groups"].items():
        if sample in samples:
            organism = config["amrfinder_organisms"].get(species)

            if organism is None:
                raise ValueError(
                    f"No AMRFinder organism configured for species '{species}'"
                )

            return organism

    raise ValueError(
        f"Sample '{sample}' was not found in species_groups"
    )


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