rule fastp:
    input:
        r1=lambda wc: SAMPLES[wc.sample]["R1"],
        r2=lambda wc: SAMPLES[wc.sample]["R2"]

    output:
        r1="results/{sample}/trimmed/{sample}_R1.fastq.gz",
        r2="results/{sample}/trimmed/{sample}_R2.fastq.gz",
        html="results/{sample}/trimmed/{sample}_fastp.html",
        json="results/{sample}/trimmed/{sample}_fastp.json"

    threads:
        config["threads"]

    shell:
        r"""
        mkdir -p results/{wildcards.sample}/trimmed

        fastp \
            -i {input.r1} \
            -I {input.r2} \
            -o {output.r1} \
            -O {output.r2} \
            --html {output.html} \
            --json {output.json} \
            --thread {threads}
        """