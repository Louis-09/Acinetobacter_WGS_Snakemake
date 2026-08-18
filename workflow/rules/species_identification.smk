def get_reference_list(wildcards):
    group = SAMPLES[wildcards.sample]["group"]

    if group == "Acinetobacter":
        return "/home/louis/databases/references/acinetobacter/reference_genomes.txt"

    elif group == "Klebsiella":
        return "/home/louis/databases/references/klebsiella/reference_genomes.txt"

    else:
        raise ValueError(
            f"No hay panel de referencias configurado para el grupo: {group}"
        )


rule species_identification:
    input:
        assembly="results/{sample}/assembly/scaffolds.fasta",
        references=get_reference_list

    output:
        raw="results/{sample}/species_identification/fastani.tsv",
        best="results/{sample}/species_identification/best_hit.tsv"

    conda:
        "../../envs/fastani.yaml"

    threads:
        config["fastani"]["threads"]

    log:
        "logs/species_identification/{sample}.log"

    shell:
        r"""
        mkdir -p results/{wildcards.sample}/species_identification
        mkdir -p logs/species_identification

        fastANI \
            -q {input.assembly:q} \
            --rl {input.references:q} \
            -o {output.raw:q} \
            -t {threads} \
            > {log:q} 2>&1

        printf 'sample\tpredicted_species\treference_accession\tani\tmapped_fragments\ttotal_fragments\tfragment_coverage\tstatus\n' \
            > {output.best:q}

        sort -t $'\t' -k3,3nr {output.raw:q} \
        | head -1 \
        | awk -F '\t' \
            -v sample="{wildcards.sample}" \
            'BEGIN {{OFS="\t"}}
            {{
                ref=$2
                accession="NA"
                species="Unresolved"

                if (match(ref, /GCF_[0-9]+\.[0-9]+/)) {{
                    accession=substr(ref, RSTART, RLENGTH)
                }}

                if (accession=="GCF_009035845.1") species="Acinetobacter baumannii"
                else if (accession=="GCF_016576965.1") species="Acinetobacter bereziniae"
                else if (accession=="GCF_002055515.1") species="Acinetobacter calcoaceticus"
                else if (accession=="GCF_003323815.1") species="Acinetobacter haemolyticus"
                else if (accession=="GCF_016027055.1") species="Acinetobacter johnsonii"
                else if (accession=="GCF_018336855.1") species="Acinetobacter junii"
                else if (accession=="GCF_013122135.1") species="Acinetobacter lactucae"
                else if (accession=="GCF_029024105.1") species="Acinetobacter lwoffii"
                else if (accession=="GCF_041021905.1") species="Acinetobacter nosocomialis"
                else if (accession=="GCF_000196795.1") species="Acinetobacter oleivorans"
                else if (accession=="GCF_000191145.1") species="Acinetobacter pittii"
                else if (accession=="GCF_003258335.1") species="Acinetobacter radioresistens"
                else if (accession=="GCF_016064815.1") species="Acinetobacter seifertii"
                else if (accession=="GCF_016726205.1") species="Acinetobacter ursingii"

                else if (accession=="GCF_000240185.1") species="Klebsiella pneumoniae"
                else if (accession=="GCF_020525545.1") species="Klebsiella variicola"
                else if (accession=="GCF_020099175.1") species="Klebsiella quasipneumoniae"
                else if (accession=="GCF_002269255.1") species="Klebsiella quasivariicola"
                else if (accession=="GCF_020526085.1") species="Klebsiella africana"
                else if (accession=="GCF_019048125.1") species="Klebsiella aerogenes"
                else if (accession=="GCF_900636985.1") species="Klebsiella oxytoca"
                else if (accession=="GCF_015139575.1") species="Klebsiella michiganensis"
                else if (accession=="GCF_042137965.1") species="Klebsiella grimontii"

                coverage=($5 > 0 ? ($4/$5)*100 : 0)

                if ($3 >= 95.0 && coverage >= 50.0)
                    status="PASS"
                else
                    status="REVIEW"

                print sample, species, accession, $3, $4, $5, coverage, status
            }}' >> {output.best:q}
        """
