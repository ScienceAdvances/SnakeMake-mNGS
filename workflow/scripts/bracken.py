"""Snakemake wrapper for picard MergeSamFiles."""

__author__ = "Victor Wang"
__copyright__ = "Copyright 2023, Victor Wang"
__email__ = "victor@bioquest.cn"
__license__ = "Apache License 2.0"

from snakemake.shell import shell

extra = snakemake.params.get("extra", "")

log = snakemake.log_fmt_shell(stdout=True, stderr=True)

shell(
    "bracken"
    " -d {snakemake.input.db}"
    " -i {snakemake.input.report}"
    " -o {snakemake.output}"
    " {extra}"
    " {log}"
)
