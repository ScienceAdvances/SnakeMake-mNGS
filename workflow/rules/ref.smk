rule get_genome:
    output:
        genome_prefix+".fna"
    log:
        "{O}/logs/ref/get_genome.log"
    retries: 50
    params:
        species=config["genome"].get("species"),
        datatype=config["genome"].get("datatype"),
        build=config["genome"].get("build"),
        release=config["genome"].get("release"),
    cache: True
    wrapper:
        config["warpper_mirror"]+"bio/reference/ensembl-sequence"

rule .fnaidx:
    input:
        genome_prefix+".fna"
    output:
        genome_prefix+".fna.fai"
    cache: True
    log:
        "{O}/logs/ref/.fnaidx.log"
    wrapper:
        config["warpper_mirror"]+"bio/samtools/faidx"

rule picard_create_dict:
    input:
        genome_prefix+".fna"
    output:
        genome_prefix+"genome.dict"
    log:
        "{O}/logs/ref/picard_create_dict.log"
    resources:
        mem_mb=1024
    cache: True
    wrapper:
        config["warpper_mirror"]+"bio/picard/createsequencedictionary"

rule bwa_mem2_index:
    input:
        genome_prefix+".fna"
    output:
        multiext(
            genome_prefix+".fna",
            ".0123",
            ".amb",
            ".ann",
            ".bwt.2bit.64",
            ".pac",
        ),
    log:
        "{O}/logs/ref/bwa_mem2_index.log"
    params:
        bwa="bwa-mem2"
    threads: 16
    cache: True
    wrapper:
        config["warpper_mirror"]+"bio/bwa-memx/index"