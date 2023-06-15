mNGS Pipeline summary

Metagenomic next-generation sequencing

=============================================
Reference
=============================================

Genome refence for {{ snakemake.config["genome"]["species"] }} build {{ snakemake.config["genome"]["build"] }} release {{ snakemake.config["genome"]["release"] }} was download from Ensembl_

=============================================
Alignment
=============================================
1. Adapter trimming (Fastp_)
2. Aligner (`BWA mem2`_)
3. Mark duplicates (samblaster_)
4. Merge CRAMs of every sample, repesectly (Picard_)
5. Create CRAM index (samtools_)

=============================================
Quality control report
=============================================
1. Fastp report (MultiQC_)
2. Alignment report (MultiQC_)

=============================================
Taxonomic classification
=============================================
1. Taxonomic classification using exact k-mer matches. (Kraken2_)
2. Classifier for metagenomic sequences. (Centrifuge_)
3. Computes the abundance of species in DNA sequences (Bracken_)
4. Krona plot (Krona_)

=============================================
Assemble
=============================================
1. Metagenome assemblier (Spades_)
2. Resistance Gene Identifier (RGI_)
3. Virulence factor predication (diamond_)

.. _Ensembl: https://asia.ensembl.org/index.html
.. _fastp: https://github.com/OpenGene/fastp
.. _BWA mem2: http://bio-bwa.sourceforge.net
.. _samblaster: https://github.com/GregoryFaust/samblaster
.. _MultiQC: https://multiqc.info
.. _samtools: http://www.htslib.org
.. _Picard: https://broadinstitute.github.io/picard
.. _Centrifuge: https://ccb.jhu.edu/software/centrifuge/index.shtml
.. _RGI: https://card.mcmaster.ca
.. _diamond: https://github.com/bbuchfink/diamond
.. _Spades: https://github.com/ablab/spades
.. _Kraken2: https://ccb.jhu.edu/software/kraken2
.. _Bracken: https://github.com/jenniferlu717/Bracken
.. _Krona: https://github.com/marbl/Krona
