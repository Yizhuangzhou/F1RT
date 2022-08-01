# F1RT dataset
Constructing metagenome-assembled genomes for all components in a real bacterial consortium for binning benchmarking

# Data description

The data directory contains data for MAG reconstruction.

The bin directory contains Perl programs for MAG reconstruction.

The Scripts directory contains all scripts for MAG reconstruction.

The Isolate directory contains four isolate genomes.

The MAG directory contains nine MAGs.

For original data including all high-quality reads and original assemblies by SOAPdenovo, please refer to http://dx.doi.org/10.5524/100049.

# Reconstruction process

0. Uncompress the files

  gzip -d data/metaspades_scaffolds_more500.fasta.gz

  gzip -d data/SOAP_scaffold_more500.fasta.gz

1. Geome alignment between isolate genomes and F1RT metagenome assembled by metaSPAdes

sh 01.genomealign_4metaspades.sh

2. Get the primary MAGs for isolates

sh 02.SingleIsolate_PrimaryMAG.sh

The "*.xls" includes primary MAGs, while "*.log" contains the scaffolds with <90% AF.

3. determine whether some scaffolds with mutiple sources, that is a scaffold is mapped into >1 isolote genomes with >90% AF. 

sh 03.MultiSource_Scaf.sh

Our results showed that there are no scaffolds with multiple sources.

4. Pool all primary MAGs into one file named Isolates_PrimaryMAG.xls

sh 04.Isolates_PrimaryMAG.sh


# Affiliation
Guilin Medical University

# Support
If you need some other scripts and other materials or encounter bugs, problems, or have any suggestions, please contact me via zhouyizhuang3@163.com
