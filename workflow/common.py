from pathlib import Path


def discover_samples(reads_dir="reads"):
    """
    Descubre automáticamente muestras Illumina paired-end.

    Estructura esperada:

    reads/
        grupo/
            muestra/
                xxx_R1_001.fastq.gz
                xxx_R2_001.fastq.gz

    Ejemplos:

    reads/Acinetobacter/AB1/...
    reads/Klebsiella/KN1/...
    reads/Pseudomonas/PA1/...

    El nombre de la carpeta que contiene los FASTQ
    se utiliza como identificador de la muestra.
    """

    reads_dir = Path(reads_dir)

    samples = {}

    for r1 in reads_dir.rglob("*_R1_*.fastq.gz"):

        # Ignorar archivos AppleDouble creados por macOS/exFAT
        if r1.name.startswith("._"):
            continue

        r2 = Path(str(r1).replace("_R1_", "_R2_"))

        if not r2.exists():
            print(
                f"Advertencia: no se encontró R2 para "
                f"{r1}"
            )
            continue

        if r2.name.startswith("._"):
            continue

        # La carpeta que contiene los FASTQ define la muestra
        sample = r1.parent.name

        # Evitar sobrescribir accidentalmente una muestra
        if sample in samples:
            raise ValueError(
                f"Identificador de muestra duplicado: '{sample}'\n"
                f"R1 anterior: {samples[sample]['R1']}\n"
                f"R1 nuevo:    {r1}"
            )

        samples[sample] = {
            "R1": str(r1.resolve()),
            "R2": str(r2.resolve())
        }

    if not samples:
        raise ValueError(
            f"No se encontraron muestras en {reads_dir.resolve()}"
        )

    return samples
