rule mobsuite:
    input:
        fasta="results/{sample}/assembly/scaffolds.fasta"

    output:
        mobtyper="results/{sample}/mobsuite/mobtyper_results.txt",
        contig_report="results/{sample}/mobsuite/contig_report.txt",
        mge_report="results/{sample}/mobsuite/mge.report.txt"

    threads:
        config["threads"]

    log:
        "logs/mobsuite/{sample}.log"

    conda:
        "../../envs/mobsuite.yaml"

    shell:
        r"""
        rm -rf results/{wildcards.sample}/mobsuite
        mkdir -p logs/mobsuite

        mob_recon \
            --infile {input.fasta:q} \
            --outdir results/{wildcards.sample}/mobsuite \
            > {log:q} 2>&1

        if [ ! -f {output.mobtyper:q} ]; then
            printf 'sample_id\tnum_contigs\tsize\tgc\trep_type(s)\trelaxase_type(s)\tmpf_type\torit_type(s)\tpredicted_mobility\tmash_nearest_neighbor\tmash_neighbor_distance\tmash_neighbor_identification\tprimary_cluster_id\tsecondary_cluster_id\tpredicted_host_range_overall_rank\n' \
                > {output.mobtyper:q}
        fi
        """
