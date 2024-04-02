rule centrifuge:
    input:
        fastq=get_meta(),
        idx=multiext(config["mNGS_idx"]+"/hpvc",".1.cf",".2.cf",".3.cf",".4.cf")
    output:
        report="{O}/Centrifuge/{S}.Report.tsv",
        classification="{O}/Centrifuge/{S}.cf.tsv",
        kreport="{O}/Report/Centrifuge/{S}.kreport.tsv",
    threads: 32
    params:
        is_single_end = SINGLE
    log:
        "{O}/logs/Centrifuge/{S}.log"
    conda: "../envs/mNGS.yaml"
    script:
        "../scripts/centrifuge.py"

rule kraken2:
    input:
        fastq=get_meta(),
        db=config["mNGS_idx"]
    output:
        Report="{O}/Report/Kraken2/{S}.Report.tsv",
        classification="{O}/Kraken2/{S}.cf.tsv",
        unclassified_seq=get_kraken2_unclassified_seq,
    threads: 32
    params:
        extra = "--gzip-compressed",
        is_single_end = SINGLE
    log:
        "{O}/logs/Kraken2/{S}.log"
    conda: "../envs/mNGS.yaml"
    script:
        "../scripts/kraken2.py"

rule bracken:
    input:
        Report="{O}/Report/Kraken2/{S}.Report.tsv",
        db=config["mNGS_idx"]
    output:
        Report="{O}/Report/bracken/{S}.bracken.tsv"
    threads: 32
    params:
        extra = "-l S" #level to estimate abundance at [options: D,P,C,O,F,G,S,S1,etc] (default: S)
    log:
        "{O}/logs/bracken/{S}.log"
    conda: 
        "../envs/mNGS.yaml"
    script:
        "../scripts/bracken.py"

rule kreport2krona:
    input:
        "{O}/Report/Kraken2/{S}.Report.tsv",
    output:
        "{O}/Krona/{S}.kro"
    threads: 32
    params:
        extra = ""
    log:
        "{O}/logs/Krona/{S}.log"
    conda: 
        "../envs/kreport2krona.yaml"
    script:
        "../scripts/kreport2krona.py"

rule Krona:
    input:
        "{O}/Krona/{S}.kro"
    output:
        Report("{O}/Report/Krona/{S}.html",
                caption="../{O}/Report/KronaPlot.rst",
                category="Krona Plot"
            ),
    threads: 32
    params:
        extra = ""
    log:
        "{O}/logs/Krona/{S}.log"
    conda: 
        "../envs/Krona.yaml"
    script:
        "../scripts/Krona.py"

