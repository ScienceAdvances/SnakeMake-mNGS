rule fastp:
    input:
        sample=get_fastq
    output:
        trimmed=temp("{O}/Clean/{S}{U}.fastq.gz") if SINGLE else [temp("{O}/Clean/{S}{U}_1.fastq.gz"), temp("trimmed/{S}{U}_2.fastq.gz")],
        html="{O}/Report/fastp/{S}{U}.fastp.html",
        json="{O}/Report/fastp/{S}{U}.fastp.json",
    log:
        "{O}/logs/fastp/{S}{U}.log"
    threads: 32
    wrapper:
        config["warpper_mirror"]+"bio/fastp"

rule fastp_multiqc:
    input:
        expand("{O}/Report/{S}{U}.fastp.json", s=samples.Sample,u=samples.Unit)
    output:
        report(
            "{O}/Report/fastp_multiqc.html",
            caption="../Report/multiqc.rst",
            category="Quality control"
        ),
    log:
        "{O}/logs/qc/fastp_multiqc.log"
    wrapper:
        config["warpper_mirror"]+"bio/multiqc"

rule samtools_stats:
    input:
        "{O}/Align/{S}.bam",
    output:
        temp("{O}/Align/{S}.txt")
    log:
        "{O}/logs/qc/{S}.samtools_stats.log"
    wrapper:
        config["warpper_mirror"]+"bio/samtools/stats"

rule align_multiqc:
    input:
        expand(["{O}/Align/{S}.txt"],s=samples.Sample),
    output:
        Report(
            "{O}/Report/align_multiqc.html",
            caption="../Report/multiqc.rst",
            category="Quality control",
        ),
    log:
        "{O}/logs/qc/align_multiqc.log",
    wrapper:
        config["warpper_mirror"]+"bio/multiqc"