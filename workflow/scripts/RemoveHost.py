"""Snakemake wrapper for samtools fastq."""

__author__ = "Victor Wang"
__copyright__ = "Copyright 2023, Victor Wang"
__email__ = "yehior@qq.com"
__license__ = "Apache License 2.0"


import tempfile
from snakemake.shell import shell

view_extra = snakemake.params.get("view_extra", "")
sort_extra = snakemake.params.get("sort_extra", "")
fastq_extra = snakemake.params.get("fastq_extra", "")

log = snakemake.log_fmt_shell(stdout=True, stderr=True)

fastq=snakemake.output

if snakemake.params["is_single_end"]:
    fastq = "-1 {}".format(fastq[0])
else:
    fastq = "-1 {} -2 {}".format(fastq[0],fastq[1])

threads="--threads {snakemake.threads}"
shell(
    "samtools view -b -f 12 -F 256"
    " {view_extra} {threads}"
    " --reference {snakemake.input.ref}"
    " {snakemake.input.sam} |"
    " samtools sort"
    " {threads}"
    " {sort_extra} - |"
    " samtools fastq"
    " -n {fastq_extra} {threads}"
    " {fastq}"
    " - {log}"
)
