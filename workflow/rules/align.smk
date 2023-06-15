rule align:
    input:
        reads=get_trimmed_fastq,
        reference=genome_prefix+"genome.fa",
        idx=multiext(genome_prefix+"genome.fa", ".0123", ".amb", ".bwt.2bit.64", ".ann",".pac"),
    output:
        temp("results/aligned/{s}{u}.aligned.cram") # Output can be .cram, .bam, or .sam
    log:
        "logs/align/{s}{u}.bwa-mem2.log"
    params:
        bwa="bwa-mem2", # Can be 'bwa-mem, bwa-mem2 or bwa-meme.
        extra=get_read_group,
        sort="picard",
        sort_order="coordinate",
        dedup=config['fastqs']['duplicates'], # Can be 'none' (default), 'mark' or 'remove'.
        dedup_extra=get_dedup_extra(),
        exceed_thread_limit=True,
        embed_ref=False,
    threads: 32
    wrapper:
        config["warpper_mirror"]+"bio/bwa-memx/mem"

rule MergeSamFiles:
    input:
        sam=get_cram,
        ref=genome_prefix+"genome.fa",
    output:
        sam="results/aligned/{s}.cram",
        idx="results/aligned/{s}.cram.crai"
    threads: 32
    params:
        samtools_extra = "-c"
    log:
        "logs/MergeSamFiles/{s}.log"
    conda: "../envs/MergeSamFiles.yaml"
    script:
        "../scripts/MergeSamFiles.py"

rule RemoveHost:
    input:
        sam="results/aligned/{s}.cram",
        ref=genome_prefix+"genome.fa",
    output:
        get_unaligned_fastq()
    threads: 32
    params:
        view_extra = "",
        sort_extra = "-n",
        fastq_extra = "",
        paired=config["fastqs"]['pe']
    log:
        "logs/RemoveHost/{s}.log"
    conda: "../envs/MergeSamFiles.yaml"
    script:
        "../scripts/RemoveHost.py"