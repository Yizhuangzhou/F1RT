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

5. Get the average depth for each scaffold in primary MAGs

sh 05.Isolates_PrimaryMAG_MeanDepth.sh

The file "data/F1RT_depth_mean_rawdepth_500bp.xls" contains averge depth for all scaffolds assembled by metaSPAdes

6. Get the scaffolds with <90% AF 

sh 06.FC2357_PossibleScaf.sh

7. Get the average depth for all unaligned scaffolds assembled by metaSPAdes

sh 07.Metaspades_RemainScaf_MeanDepth.sh

Then using R script in to draw Additional file 1: Figure S3. The R code is as follows:
###################################################################################
##                                                                                #
##                    Metaspades_RemainScaf_MeanDepth.xls                         #
##                                                                                #
###################################################################################
d<-read.table("Metaspades_RemainScaf_MeanDepth.xls",sep="\t",header=F)
library(tidyverse)
pdf("Metaspades_RemainScaf_MeanDepth.pdf")
hist(d$V2,breaks=seq(floor(min(d$V2)),ceiling(max(d$V2)),by=1),main="",xlab="Sequencing coverage",ylab="Frequency",xaxt="n")
axis(side=1,at=seq(0,13000,by=1000))
box()
dev.off()

9. 
# Affiliation
Guilin Medical University

# Support
If you need some other scripts and other materials or encounter bugs, problems, or have any suggestions, please contact me via zhouyizhuang3@163.com
