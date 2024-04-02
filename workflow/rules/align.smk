rule align:
    input:
        reads=get_clean_fastq,
        reference=config['reference'],
        idx=multiext(config['reference'], ".0123", ".amb", ".bwt.2bit.64", ".ann",".pac"),
    output:
        temp("{O}/Align/{S}{U}.Align.bam") # Output can be .cram, .bam, or .sam
    log:
        "{O}/logs/Align/{S}{U}.bwa-mem2.log"
    params:
        bwa="bwa-mem2", # Can be 'bwa-mem, bwa-mem2 or bwa-meme.
        extra=get_read_group,
        sort="picard",
        sort_order="coordinate",
        dedup=config['duplicates'], # Can be 'none' (default), 'mark' or 'remove'.
        dedup_extra=get_dedup_extra(),
        exceed_thread_limit=True,
        embed_ref=False,
    threads: 32
    wrapper:
        config["warpper_mirror"]+"bio/bwa-memx/mem"

rule MergeSamFiles:
    input:
        sam=get_bam,
        ref=config['reference'],
    output:
        sam="{O}/Align/{S}.bam",
        idx="{O}/Align/{S}.bam.bai"
    threads: 32
    params:
        samtools_extra = "-b"
    log:
        "{O}/logs/MergeSamFiles/{S}.log"
    conda: "../envs/MergeSamFiles.yaml"
    script:
        "../scripts/MergeSamFiles.py"

rule RemoveHost:
    input:
        sam="{O}/Align/{S}.bam",
        ref=config['reference'],
    output:
        get_meta()
    threads: 32
    params:
        view_extra = "",
        sort_extra = "-n",
        fastq_extra = "",
        is_single_end=SINGLE
    log:
        "{O}/logs/RemoveHost/{S}.log"
    conda: "../envs/MergeSamFiles.yaml"
    script:
        "../scripts/RemoveHost.py"