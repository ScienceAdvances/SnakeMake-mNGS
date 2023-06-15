rule centrifuge:
    input:
        fastq=get_unaligned_fastq(),
        idx=multiext(config["mNGS_idx"]+"/hpvc",".1.cf",".2.cf",".3.cf",".4.cf")
    output:
        report="results/centrifuge/{s}.report.tsv",
        classification="results/centrifuge/{s}.cf.tsv",
        kreport="report/centrifuge/{s}.kreport.tsv",
    threads: 32
    params:
        paired=config["fastqs"]['pe']
    log:
        "logs/centrifuge/{s}.log"
    conda: "../envs/mNGS.yaml"
    script:
        "../scripts/centrifuge.py"

rule kraken2:
    input:
        fastq=get_unaligned_fastq(),
        db=config["mNGS_idx"]
    output:
        report="report/kraken2/{s}.report.tsv",
        classification="results/kraken2/{s}.cf.tsv",
        unclassified_seq=get_unclassified_seq(),
    threads: 32
    params:
        extra = "--gzip-compressed",
        paired = config["fastqs"]['pe']
    log:
        "logs/kraken2/{s}.log"
    conda: "../envs/mNGS.yaml"
    script:
        "../scripts/kraken2.py"

rule bracken:
    input:
        report="report/kraken2/{s}.report.tsv",
        db=config["mNGS_idx"]
    output:
        report="report/bracken/{s}.bracken.tsv"
    threads: 32
    params:
        extra = "-l S" #level to estimate abundance at [options: D,P,C,O,F,G,S,S1,etc] (default: S)
    log:
        "logs/bracken/{s}.log"
    conda: 
        "../envs/mNGS.yaml"
    script:
        "../scripts/bracken.py"

rule kreport2krona:
    input:
        "report/kraken2/{s}.report.tsv",
    output:
        "results/kreport2krona/{s}.kro"
    threads: 32
    params:
        extra = ""
    log:
        "logs/kreport2krona/{s}.log"
    conda: 
        "../envs/kreport2krona.yaml"
    script:
        "../scripts/kreport2krona.py"

rule Krona:
    input:
        "results/kreport2krona/{s}.kro"
    output:
        report(
                "report/Krona/{s}.html",
                caption="../report/KronaPlot.rst",
                category="Krona Plot"
            ),
    threads: 32
    params:
        extra = ""
    log:
        "logs/Krona/{s}.log"
    conda: 
        "../envs/Krona.yaml"
    script:
        "../scripts/Krona.py"

