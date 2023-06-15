__author__ = "Victor Wang"
__copyright__ = "Copyright 2023, Victor Wang"
__email__ = "victor@bioquest.cn"
__license__ = "Apache License 2.0"

import tempfile
from snakemake.shell import shell

extra = snakemake.params.get("extra", "")
log = snakemake.log_fmt_shell(stdout=True, stderr=True)
output_dir=snakemake.output[0].split(".")[-2]

shell(
    "rgi main"
    " {extra}"
    " --input_sequence {snakemake.input}"
    " --num_threads {snakemake.threads}"
    " --output_file {output_dir}"
    " --alignment_tool BLAST" # DIAMOND or BLAST
    " {log}"
)