"""Snakemake wrapper for picard MergeSamFiles."""

__author__ = "Victor Wang"
__copyright__ = "Copyright 2023, Victor Wang"
__email__ = "victor@bioquest.cn"
__license__ = "Apache License 2.0"

import tempfile
from snakemake.shell import shell
from snakemake_wrapper_utils.java import get_java_opts

picard_extra = snakemake.params.get("picard_extra", "")
samtools_extra = snakemake.params.get("samtools_extra", "")
java_opts = get_java_opts(snakemake)
log = snakemake.log_fmt_shell(stdout=True, stderr=True)
sam=snakemake.input.get("sam",False)
if not sam:
    raise ValueError("input file is None")
if isinstance(sam,list) & len(sam)>1:
    sam = " ".join("--INPUT {}".format(x) for x in sam)
    run_merger = True
else:
    run_merger = False

ref=snakemake.input.get("ref","")
if ref:
    ref=f"--REFERENCE_SEQUENCE {ref}"
create_idx=snakemake.output.get("idx","")
if create_idx:
    create_idx="--CREATE_INDEX true"
threads=snakemake.threads
threads = "" if threads <= 1 else " -@ {} ".format(snakemake.threads - 1)
if threads:
    use_threads="--USE_THREADING true"

if run_merger:
    with tempfile.TemporaryDirectory() as tmpdir:
        shell(
            "picard MergeSamFiles"
            " {java_opts} {extra}"
            " {ref}"
            " {sam}"
            " --TMP_DIR {tmpdir}"
            " --OUTPUT {snakemake.output.map}"
            " {create_idx}"
            " --SORT_ORDER coordinate"
            " {use_threads}"
            " {log}"
        )
else:
    shell(
        "cp {snakemake.input.sam} {snakemake.output.sam}" 
    )
    shell(
        "samtools index {threads} {samtools_extra} {snakemake.input.sam} {snakemake.output.idx} {log}"
    )
