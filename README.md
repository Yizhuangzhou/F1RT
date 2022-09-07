# F1RT dataset
Constructing metagenome-assembled genomes for all components in a real bacterial consortium for binning benchmarking

# Data description

The data directory contains required data for MAG reconstruction.

The bin directory contains all required Perl programs for MAG reconstruction.

The Scripts directory contains all scripts for MAG reconstruction.

The Isolate directory contains four isolate genomes.

The MAG directory contains nine MAGs.

The Data_4BinningBenckmarking directory contains data required for binning and benckmarking.

For original data including all high-quality reads and assemblies by SOAPdenovo, please refer to http://dx.doi.org/10.5524/100049.

# Reconstruction process

0. Uncompress the files

  ```
  gzip -d data/metaspades_scaffolds_more500.fasta.gz

  gzip -d data/SOAP_scaffold_more500.fasta.gz
  ```

1. Geome alignment between isolate genomes and F1RT metagenome assembled by metaSPAdes

```
sh 01.genomealign_4metaspades.sh
```

2. Get the primary MAGs for isolates

```
sh 02.SingleIsolate_PrimaryMAG.sh
```

The "*.xls" includes primary MAGs, while "*.log" contains the scaffolds with <90% AF.

3. determine whether some scaffolds with mutiple sources, that is a scaffold is mapped into >1 isolote genomes with >90% AF. 

```
sh 03.MultiSource_Scaf.sh
```

Our results showed that there are no scaffolds with multiple sources.

4. Pool all primary MAGs into one file named Isolates_PrimaryMAG.xls

```
sh 04.Isolates_PrimaryMAG.sh
```

5. Get the average depth for each scaffold in primary MAGs

```
sh 05.Isolates_PrimaryMAG_MeanDepth.sh
```

The file "data/F1RT_depth_mean_rawdepth_500bp.xls" contains average depth for all scaffolds assembled by metaSPAdes.

Then use the R code corresponding to "Isolates_PrimaryMAG_MeanDepth.xls" section in Rscript_4Reconstruction.RR script to draw Fig. 1A.

6. Get the scaffolds with <90% AF 

```
sh 06.FC2357_PossibleScaf.sh
```

7. Get the scaffold-level depth for all unaligned scaffolds assembled by metaSPAdes

```
sh 07.Metaspades_RemainScaf_MeanDepth.sh
```

Then use the R code corresponding to "Metaspades_RemainScaf_MeanDepth.xls" section in Rscript_4Reconstruction.RR script to draw Additional file 1: Figure S3. 

8. Geome alignment between isolate genomes and F1RT metagenome assembled by SOAPdenovo

```
sh 08.genomealign_4SOAP.sh
```

9. Get the scaffold-level depth for all unaligned scaffolds assembled by SOAPdenovo

```
sh 09.SOAP_RemainScaf_MeanDepth.sh
```

Then use the R code corresponding to "SOAP_RemainScaf_MeanDepth.xls" section in Rscript_4Reconstruction.RR script to draw Fig. 1C.

10. Get the sequences in fasta format of the unaligned scaffolds assembled by metaSPAdes

```
sh 10.metaspades_RemainScaf.fa.sh
```

11. Get the sequences in fasta format of the unaligned scaffolds assembled by SOAPdenovo

```
sh 11.SOAP_RemainScaf.fa.sh
```

12. Geome alignment between unaligned scaffolds assembled by metaSPAdes and unaligned scaffolds assembled by SOAPdenovo

```
sh 12.Metaspades_SOAP_RemainScaf.coords.sh
```

13. Get the scaffold-level depth for unaligned scaffolds uniquely assembled by metaSPAdes

```
sh 13.Metaspades_Unique_RemainScaf_MeanDepth.sh
```

Then use the R code corresponding to "SOAP_RemainScaf_MeanDepth.xls" section in Rscript_4Reconstruction.RR script to draw Fig. 1C.


14. Classify unaligned scaffolds 

```
sh 14.Classification_RemainScaf.sh
```

15. Classify aligned scaffolds with <90% AF

Create a file named FC.list containning the following information separated by Tab:

|FC1|FC1_PrimaryMAG_withType.xls|
| FC2 | FC2_PrimaryMAG_withType.xls |

FC3     FC3_PrimaryMAG_withType.xls

FC4     FC4_PrimaryMAG_withType.xls

FC5     FC5_PrimaryMAG_withType.xls

FC6     FC6_PrimaryMAG_withType.xls

FC7     FC7_PrimaryMAG_withType.xls

FC8-9   FC8-9_PrimaryMAG_withType.xls

```
sh 15.PossibleScaf_Classification.sh
```

16. Get the MAGs after step 4 (refer to Additional file 1: Figure S1)

```
sh 16.MAG_afterStep4.sh
```

17. Classify SCG scaffolds harboring SCGs with >1 copies based on FC2 MAG

```
sh 17.FC8-9_SCGscaffold_classifiedbyFC2_PP.sh
```

18. Classify FC8 and FC9

```
sh 18.Classify_FC8-9.sh
```

# Affiliation
Guilin Medical University

# Support
If you need some other scripts and other materials or encounter bugs, problems, or have any suggestions, please contact me via zhouyizhuang3@163.com
