from pathlib import Path
import csv


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
                f"Advertencia: no se encontró R2 para {r1}"
            )
            continue

        if r2.name.startswith("._"):
            continue

        sample = r1.parent.name
        group = r1.parent.parent.name

        if sample in samples:
            raise ValueError(
                f"Identificador de muestra duplicado: '{sample}'\n"
                f"R1 anterior: {samples[sample]['R1']}\n"
                f"R1 nuevo:    {r1}"
            )

        samples[sample] = {
            "R1": str(r1.resolve()),
            "R2": str(r2.resolve()),
            "group": group,
        }

    if not samples:
        raise ValueError(
            f"No se encontraron muestras en {reads_dir.resolve()}"
        )

    return samples


def discover_species_groups(results_dir="results"):
    """
    Agrupa automáticamente las muestras por especie
    usando los resultados de species_identification.
    """

    results_dir = Path(results_dir)

    groups = {}

    for tsv in results_dir.glob("*/species_identification/best_hit.tsv"):

        sample = tsv.parts[-3]

        with tsv.open() as f:
            reader = csv.DictReader(f, delimiter="\t")
            row = next(reader, None)

        # Archivo vacío
        if row is None:
            continue

        # Solo identificaciones exitosas
        if row.get("status") != "PASS":
            continue

        species = row.get("predicted_species", "").strip()

        if species in ("", "NA", "Unresolved"):
            continue

        key = (
            species.lower()
            .replace(" ", "_")
            .replace(".", "")
        )

        groups.setdefault(key, []).append(sample)

    # Mantener únicamente especies con al menos 2 genomas
    groups = {
        species: samples
        for species, samples in groups.items()
        if len(samples) >= 2
    }

    return groups
