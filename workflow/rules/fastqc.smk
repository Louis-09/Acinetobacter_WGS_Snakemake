rule fastqc:
    input:
        r1=lambda wc: SAMPLES[wc.sample]["R1"],
        r2=lambda wc: SAMPLES[wc.sample]["R2"]

    output:
        directory("results/{sample}/fastqc")

    threads:
        config["threads"]

    conda:
        "../../envs/fastqc.yaml"

    shell:
        r"""
        mkdir -p {output:q}

        fastqc \
            -t {threads} \
            {input.r1:q} \
            {input.r2:q} \
            -o {output:q}
        """
