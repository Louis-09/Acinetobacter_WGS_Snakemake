SPECIES_GROUPS = config["species_groups"]


def get_species_assemblies(wildcards):
    samples = SPECIES_GROUPS[wildcards.species]

    return [
        f"results/{sample}/assembly/scaffolds.fasta"
        for sample in samples
    ]


rule fastani_species:
    input:
        assemblies=get_species_assemblies

    output:
        tsv="results/fastani/{species}/fastani.tsv"

    conda:
        "../../envs/fastani.yaml"

    threads:
        config["fastani"]["threads"]

    log:
        "logs/fastani/{species}.log"

    shell:
        r"""
        mkdir -p results/fastani/{wildcards.species}
        mkdir -p logs/fastani

        printf "%s\n" {input.assemblies} \
            > results/fastani/{wildcards.species}/genomes.txt

        fastANI \
            --ql results/fastani/{wildcards.species}/genomes.txt \
            --rl results/fastani/{wildcards.species}/genomes.txt \
            -o {output.tsv} \
            -t {threads} \
            > {log} 2>&1
        """