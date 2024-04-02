import numpy as np
import pandas as pd
from snakemake.utils import validate
from snakemake.utils import min_version

min_version("7.25.0")

report: "../report/workflow.rst"

#=====================================================
# validate config.yaml file and samples.csv file
#=====================================================

configfile: "config/config.yaml"

validate(config, schema="../schemas/config.schema.yaml")

samples = pd.read_csv(config["samples"], dtype=str,sep='\t',header=0).fillna(value="")

if not "Unit" in samples.columns:
    samples.loc[:,"Unit"]=""
samples.loc[:,"Unit"] = [f"_{x}" if x else x for x in samples.Unit]
samples.set_index(keys=["Sample", "Unit"], drop=False,inplace=True)

samples.index = samples.index.set_levels(
    [i.astype(str) for i in samples.index.levels]
)  # enforce str in index

validate(samples, schema="../schemas/samples.schema.yaml")

# if units are not none, add a . prefix
fastqs = config["fastqs"].get("dir")
if SINGLE:
    fq1=[f"{fastqs}/{x}{y}_1.fastq.gz" for x,y in zip(samples.Sample,samples.Unit)]
    fq2=[f"{fastqs}/{x}{y}_2.fastq.gz" for x,y in zip(samples.Sample,samples.Unit)]
    samples.insert(loc=0,column="fq2",value=fq2)
    samples.insert(loc=0,column="fq1",value=fq1)
else:
    fq1=[f"{fastqs}/{x}{y}.fastq.gz" for x,y in zip(samples.Sample,samples.Unit)]
    samples.insert(loc=0,column="fq1",value=fq1)

# Constant
SAMPLE=samples.Sample.tolist()
UNIT=samples.Unit.tolist()
OUTDIR=config['outdir']
SINGLE=config['is_signle_end']

#=====================================================
# Wildcard constraints
#=====================================================
wildcard_constraints:
    S = "|".SAMPLE,
    U = "|".UNIT,
    O = OUTDIR

#=====================================================
# Helper functions
#=====================================================
def get_dedup_extra():
    if SINGLE:
        return "-M --ignoreUnmated"
    else:
        return "-M"

def get_fastq(wildcards):
    """Get fastq files of given sample and unit."""
    fastqs = samples.loc[(wildcards.S, wildcards.U), ]
    if SINGLE:
        return [fastqs.fq1]
    return [fastqs.fq1, fastqs.fq2]

def get_clean_fastq(wildcards):
    """Get Clean reads of given sample and unit."""
    if SINGLE:
        return ["{O}/Clean/{S}{U}.fastq.gz"]
    return expand("{{O}}/Clean/{{S}}{{U}}_{_}.fastq.gz",_=["1","2"])

def get_read_group(wildcards):
    """Denote sample name and platform in read group."""
    return r"-R '@RG\tID:{s}{u}\tSM:{s}\tLB:{s}\tPL:{p}' -M".format(
        s=wildcards.S,
        u=wildcards.U,
        p=config["platform"]
    )

def get_bam(wildcards):
    u=samples.loc[wildcards.S,"Unit"]
    if u.all(axis=None):
        return expand(["{{O}}/Align/{{S}}{u}.Align.bam"],u=u)
    else:
        return "{O}/Align/{S}.Align.bam"

def get_meta(wildcards):
    if SINGLE:
        return ["{O}/Meta/{S}.fastq.gz"]
    return expand("{{O}}/Meta/{{S}}_{_}.fastq.gz",_=["1","2"])

def get_kraken2_unclassified_seq(wildcards):
    if SINGLE:
        return ["{O}/Kraken2/{S}.fastq"]
    return expand("{{O}}/Kraken2/{{S}}_{_}.fastq",_=["1","2"])