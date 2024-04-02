rule spades:
    input:
        get_meta()
    output:
        "{O}/Spades/{S}/contigs.fasta"
    threads: 32
    params:
        paired = config["fastqs"]['pe'],
        extra = "--meta"
    log:
        "{O}/logs/spades/{S}.log"
    conda: "../envs/mNGS.yaml"
    script:
        "../scripts/spades.py"

rule rgi:
    input:
        "{O}/Spades/{S}/contigs.fasta"
    output:
        "{O}/RGI/{S}.txt"
    threads: 32
    params:
        extra = "--clean",
    log:
        "{O}/logs/RGI/{S}.log"
    conda: "../envs/rgi.yaml"
    script:
        "../scripts/rgi.py"

rule VFDB:
    input:
        db = config["mNGS_idx"] + "/VFDB_setB_nt.fas.dmnd",
        query = "{O}/spades/{S}/contigs.fasta"
    output:
        "{O}/VFDB/{S}.tsv"
    threads: 32
    params:
        extra = "",
    log:
        "{O}/logs/VFDB/{S}.log"
    conda: "../envs/VFDB.yaml"
    script:
        "../scripts/VFDB.py"
