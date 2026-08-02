from pathlib import Path
import re

SAMPLE_REGEX = re.compile(r"AB\d+")


def discover_samples(reads_dir="reads"):
    """
    Descubre automáticamente muestras Illumina dentro de reads/.

    Estructura esperada:

    reads/
        carpeta/
            xxx_R1_001.fastq.gz
            xxx_R2_001.fastq.gz
    """

    reads_dir = Path(reads_dir)

    samples = {}

    for r1 in reads_dir.rglob("*_R1_*.fastq.gz"):

        r2 = Path(str(r1).replace("_R1_", "_R2_"))

        if not r2.exists():
            print(f"Advertencia: no se encontró el par para {r1.name}")
            continue

        match = SAMPLE_REGEX.search(r1.name)

        sample = match.group() if match else r1.parent.name

        samples[sample] = {
            "R1": str(r1.resolve()),
            "R2": str(r2.resolve())
        }

    if not samples:
        raise ValueError(
            f"No se encontraron muestras en {reads_dir.resolve()}"
        )

    return samples