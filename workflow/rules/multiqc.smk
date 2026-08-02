rule multiqc:
    input:
        expand(
            "results/{sample}/fastqc",
            sample=SAMPLE_NAMES
        )

    output:
        html="results/multiqc/multiqc_report.html"

    threads: 1

    shell:
        r"""
        mkdir -p results/multiqc

        multiqc results \
            --force \
            -o results/multiqc
        """