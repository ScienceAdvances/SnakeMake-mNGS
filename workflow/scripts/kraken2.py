"""Snakemake wrapper for picard MergeSamFiles."""

__author__ = "Victor Wang"
__copyright__ = "Copyright 2023, Victor Wang"
__email__ = "victor@bioquest.cn"
__license__ = "Apache License 2.0"


import tempfile
from snakemake.shell import shell

extra = snakemake.params.get("extra", "")

log = snakemake.log_fmt_shell(stdout=True, stderr=True)

if snakemake.params['paired']:
    is_paired="--paired"
else:
    is_paired=""

unclassified_out = snakemake.output.get("unclassified_seq", "")
if unclassified_out:
    unclassified_out = "--unclassified-out {}#.fq".format(unclassified_out[0].split("_")[-2])

shell(
    "kraken2"
    " {extra}"
    " --db {snakemake.input.db}"
    " --output {snakemake.output.classification}"
    " --report {snakemake.output.report}"
    " --threads {snakemake.threads}"
    " {unclassified_out}"
    " {is_paired}"
    " {snakemake.input.fastq}"
    " {log}"
)
