rule bakta:
    input:
        assembly="results/{sample}/assembly/scaffolds.fasta"

    output:
        gff="results/{sample}/bakta/{sample}.gff3",
        faa="results/{sample}/bakta/{sample}.faa",
        ffn="results/{sample}/bakta/{sample}.ffn",
        gbff="results/{sample}/bakta/{sample}.gbff",
        tsv="results/{sample}/bakta/{sample}.tsv"

    params:
        db=config["bakta"]["db"],
        outdir="results/{sample}/bakta"

    conda:
        "../../envs/bakta.yaml"

    threads: config["bakta"]["threads"]

    log:
        "logs/bakta/{sample}.log"

    shell:
        r"""
        rm -rf {params.outdir}
        mkdir -p logs/bakta

        bakta \
            --db {params.db} \
            --threads {threads} \
            --output {params.outdir} \
            --prefix {wildcards.sample} \
            {input.assembly} \
            > {log} 2>&1
        """

