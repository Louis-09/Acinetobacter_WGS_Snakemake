import subprocess
import shutil
from pathlib import Path

def get_genome_size(wildcards):
    sample = wildcards.sample

    # Si la especie ya es conocida, usar su tamaño específico
    for species, samples in config.get("species_groups", {}).items():
        if sample in samples:
            return config["genome_sizes"][species]

    # Si la especie todavía es desconocida, usar tamaño genómico
    # aproximado únicamente para el subsampling previo al ensamblaje
    return config["default_genome_size"]

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
    
    run:

        outdir = Path(output.r1).parent
        outdir.mkdir(parents=True, exist_ok=True)

        cmd = [
            "seqkit",
            "stats",
            "-T",
            input.r1
        ]

        result = subprocess.check_output(cmd).decode().strip().splitlines()

        header = result[0].split("\t")
        values = result[1].split("\t")

        stats = dict(zip(header, values))

        bases = int(stats["sum_len"])

        coverage = (bases * 2) / params.genome

        fraction = 1.0

        if coverage > params.target:
            fraction = params.target / coverage

            subprocess.check_call(
                f"seqtk sample -s100 {input.r1} {fraction} | gzip -c > {output.r1}",
                shell=True
            )

            subprocess.check_call(
                f"seqtk sample -s100 {input.r2} {fraction} | gzip -c > {output.r2}",
                shell=True
            )

        else:

            shutil.copy2(input.r1, output.r1)
            shutil.copy2(input.r2, output.r2)

        with open(output.report, "w") as f:

            f.write("sample\tcoverage\tfraction\n")
            f.write(
                f"{wildcards.sample}\t{coverage:.2f}\t{fraction:.4f}\n"
            )