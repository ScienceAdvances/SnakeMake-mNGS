rule spades:
    input:
        get_unaligned_fastq()
    output:
        "results/spades/{s}/contigs.fasta"
    threads: 32
    params:
        paired = config["fastqs"]['pe'],
        extra = "--meta"
    log:
        "logs/spades/{s}.log"
    conda: "../envs/mNGS.yaml"
    script:
        "../scripts/spades.py"

rule rgi:
    input:
        "results/spades/{s}/contigs.fasta"
    output:
        "results/rgi/{s}.txt"
    threads: 32
    params:
        extra = "--clean",
    log:
        "logs/rgi/{s}.log"
    conda: "../envs/rgi.yaml"
    script:
        "../scripts/rgi.py"

rule VFDB:
    input:
        db = config["mNGS_idx"] + "/VFDB_setB_nt.fas.dmnd",
        query = "results/spades/{s}/contigs.fasta"
    output:
        "results/VFDB/{s}.tsv"
    threads: 32
    params:
        extra = "",
    log:
        "logs/VFDB/{s}.log"
    conda: "../envs/VFDB.yaml"
    script:
        "../scripts/VFDB.py"
