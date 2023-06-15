__author__ = "Victor Wang"
__copyright__ = "Copyright 2023, Victor Wang"
__email__ = "victor@bioquest.cn"
__license__ = "Apache License 2.0"

from snakemake.shell import shell
from pathlib import Path
import tempfile

extra = snakemake.params.get("extra", "")

log = snakemake.log_fmt_shell(stdout=True, stderr=True)

if snakemake.params['paired']:
    fastq = "-1 {} -2 {}".format(snakemake.input[0],snakemake.input[1])
else:
    fastq = "-s {}".format(snakemake.input[0])

output_dir=Path(snakemake.output[0]).parent

with tempfile.TemporaryDirectory() as tmpdir:
    shell(
        "spades.py"
        " {extra}"
        " {fastq}"
        " --threads {snakemake.threads}"
        " -o {output_dir}"
        " --tmp-dir {tmpdir}"
        " {log}"
    )