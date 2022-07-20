cat FC*_MAG_afterStep4.xls >F1RT_MAG_afterStep4.xls
perl bin/18.Classify_FC8-9.pl FC8-9_SCGscaffold_classifiedbyFC2_PP.xls data/metaspades_scaffolds_more500.fasta F1RT_MAG_afterStep4.list F1RT_FinalMAG.xls
