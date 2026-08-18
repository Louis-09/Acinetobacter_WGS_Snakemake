from pathlib import Path
import shutil


def get_genome_size(wildcards):
    sample = wildcards.sample
    group = SAMPLES[sample]["group"]

    group_to_genome = {
        "Acinetobacter": "abaumannii",
        "Klebsiella": "kpneumoniae",
    }

    species = group_to_genome.get(group)

    if species is None:
        return config["default_genome_size"]

    return config["genome_sizes"][species]


rule subsample:
    input:
        r1="results/{sample}/trimmed/{sample}_R1.fastq.gz",
        r2="results/{sample}/trimmed/{sample}_R2.fastq.gz"

    output:
        r1="results/{sample}/subsampled/{sample}_R1.fastq.gz",
        r2="results/{sample}/subsampled/{sample}_R2.fastq.gz",
        report="results/{sample}/subsampled/coverage.tsv"

    params:
        genome=get_genome_size,
        target=config["target_coverage"]

    conda:
        "../../envs/subsample.yaml"

    shell:
        r"""
        set -euo pipefail

        mkdir -p results/{wildcards.sample}/subsampled

        BASES_R1=$(seqkit stats -T {input.r1:q} | tail -n 1 | cut -f 5)

        COVERAGE=$(awk -v bases="$BASES_R1" \
                       -v genome="{params.genome}" \
                       'BEGIN {{printf "%.6f", (bases * 2) / genome}}')

        FRACTION=$(awk -v cov="$COVERAGE" \
                       -v target="{params.target}" \
                       'BEGIN {{
                           if (cov > target)
                               printf "%.8f", target / cov;
                           else
                               printf "1.00000000";
                       }}')

        echo "Sample: {wildcards.sample}"
        echo "Genome size: {params.genome}"
        echo "Estimated coverage: $COVERAGE x"
        echo "Subsampling fraction: $FRACTION"

        if awk -v cov="$COVERAGE" \
               -v target="{params.target}" \
               'BEGIN {{exit !(cov > target)}}'
        then
            seqtk sample -s100 {input.r1:q} "$FRACTION" | gzip -c > {output.r1:q}
            seqtk sample -s100 {input.r2:q} "$FRACTION" | gzip -c > {output.r2:q}
        else
            cp {input.r1:q} {output.r1:q}
            cp {input.r2:q} {output.r2:q}
        fi

        printf "sample\tcoverage\tfraction\n" > {output.report:q}
        printf "{wildcards.sample}\t%.2f\t%.4f\n" \
            "$COVERAGE" "$FRACTION" >> {output.report:q}
        """
