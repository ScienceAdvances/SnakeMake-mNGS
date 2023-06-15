"""Snakemake wrapper for picard MergeSamFiles."""

__author__ = "Victor Wang"
__copyright__ = "Copyright 2023, Victor Wang"
__email__ = "victor@bioquest.cn"
__license__ = "Apache License 2.0"

from snakemake.shell import shell

extra = snakemake.params.get("extra", "")
log = snakemake.log_fmt_shell(stdout=True, stderr=True)

fastq=snakemake.input.fastq
if snakemake.params['paired']:
    fastq = "-1 {} -2 {}".format(fastq[0],fastq[1])
else:
    fastq = "-U {}".format(fastq[0])

idx=snakemake.input.idx
idx=idx[0].split(".")[-3]

shell(
    "centrifuge"
    " {extra}"
    " -x {idx}"
    " {fastq}"
    " -S {snakemake.output.classification}"
    " --report-file {snakemake.output.report}"
    " --threads {snakemake.threads}"
    " {log}"
)
shell(
    "centrifuge-kreport"
    " -x {idx}"
    " {snakemake.output.report}"
    " > {snakemake.output.kreport} 2> /dev/null"
)
