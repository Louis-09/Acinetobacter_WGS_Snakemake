rule vfdb:
    input:
        faa="results/{sample}/bakta/{sample}.faa"

    output:
        raw="results/{sample}/vfdb/{sample}_vfdb.tsv",
        filtered="results/{sample}/vfdb/{sample}_vfdb_filtered.tsv"

    params:
        db=config["vfdb"]["db"],
        min_identity=config["vfdb"]["min_identity"],
        min_coverage=config["vfdb"]["min_coverage"]

    threads:
        config["vfdb"]["threads"]

    log:
        "logs/vfdb/{sample}.log"

    conda:
        "../../envs/blast.yaml"

    shell:
        r"""
        mkdir -p results/{wildcards.sample}/vfdb
        mkdir -p logs/vfdb

        blastp \
            -query {input.faa:q} \
            -db {params.db:q} \
            -out {output.raw:q} \
            -evalue 1e-10 \
            -num_threads {threads} \
            -max_target_seqs 1 \
            -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qcovhsp" \
            > {log:q} 2>&1

        awk -v min_id={params.min_identity} \
            -v min_cov={params.min_coverage} \
            'BEGIN {{
                OFS="\t";
                print "query_id","vfdb_id","pident","alignment_length","mismatch","gapopen","qstart","qend","sstart","send","evalue","bitscore","qcovhsp"
            }}
            $3 >= min_id && $13 >= min_cov {{
                print
            }}' \
            {output.raw:q} > {output.filtered:q}
        """
