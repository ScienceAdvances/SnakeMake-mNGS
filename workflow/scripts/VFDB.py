"""Snakemake wrapper for picard MergeSamFiles."""

__author__ = "Victor Wang"
__copyright__ = "Copyright 2023, Victor Wang"
__email__ = "victor@bioquest.cn"
__license__ = "Apache License 2.0"

import tempfile
from snakemake.shell import shell

log = snakemake.log_fmt_shell(stdout=True, stderr=True)
extra = snakemake.params.get("extra", "")

with tempfile.TemporaryDirectory() as tmpdir:
    shell(
        "diamond blastx"
        " {extra}"
        " --query {snakemake.input.query}"
        " --threads {snakemake.threads}"
        " --db {snakemake.input.db}"
        " --out {snakemake.output}"
        " --tmpdir {tmpdir}"
        " {log}"
    )
