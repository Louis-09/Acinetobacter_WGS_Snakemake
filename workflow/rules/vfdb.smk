rule vfdb:
    input:
        faa="results/{sample}/bakta/{sample}.faa"

    output:
        tsv="results/{sample}/vfdb/{sample}_vfdb.tsv"

    params:
        db=config["vfdb"]["db"]

    threads: config["vfdb"]["threads"]

    log:
        "logs/vfdb/{sample}.log"

    shell:
        r"""
        mkdir -p results/{wildcards.sample}/vfdb
        mkdir -p logs/vfdb

        blastp \
            -query {input.faa} \
            -db {params.db} \
            -out {output.tsv} \
            -evalue 1e-10 \
            -num_threads {threads} \
            -max_target_seqs 1 \
            -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qcovhsp"
        > {log} 2>&1
        """