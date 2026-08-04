rule prokka:
    input:
        assembly="results/{sample}/assembly/scaffolds.fasta"

    output:
        gff="results/{sample}/prokka/{sample}.gff",
        faa="results/{sample}/prokka/{sample}.faa",
        ffn="results/{sample}/prokka/{sample}.ffn",
        gbk="results/{sample}/prokka/{sample}.gbk",
        tsv="results/{sample}/prokka/{sample}.tsv"

    conda:
        "../../envs/prokka.yaml"

    threads:
        config["prokka"]["threads"]

    params:
        outdir="results/{sample}/prokka"

    log:
        "logs/prokka/{sample}.log"

    shell:
        r"""
        rm -rf {params.outdir}
        mkdir -p logs/prokka

        prokka \
            --outdir {params.outdir} \
            --prefix {wildcards.sample} \
            --cpus {threads} \
            --force \
            {input.assembly:q} \
            > {log:q} 2>&1
        """
