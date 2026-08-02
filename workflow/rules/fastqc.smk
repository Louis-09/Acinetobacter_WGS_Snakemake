rule fastqc:
    input:
        r1=lambda wc: SAMPLES[wc.sample]["R1"],
        r2=lambda wc: SAMPLES[wc.sample]["R2"]

    output:
        directory("results/{sample}/fastqc")

    threads:
        config["threads"]

    shell:
        r"""
        mkdir -p {output}

        fastqc \
            -t {threads} \
            {input.r1} \
            {input.r2} \
            -o {output}
        """