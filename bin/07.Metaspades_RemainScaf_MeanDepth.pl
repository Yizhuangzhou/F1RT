#!usr/bin/perl -w
use strict;
die "perl $0 [Isolates_FinalMAG.xls][FC2357_PossibleScaf.xls][output]" unless @ARGV == 3;
open(IF,$ARGV[0])||die;
open(IN,"data/F1RT_depth_mean_rawdepth_500bp.xls")||die;
open(PF,$ARGV[1])||die;
open(OUT,">$ARGV[2]")||die;
my %used;
while(<IF>){
	chomp;
	my @a=split /\t/;
	$used{$a[0]}=1;
}
close IF;
while(<PF>){
	chomp;
	my @a=split /\t/;
	$used{$a[0]}=1;
}
close PF;
while(<IN>){
	chomp;
	my @a=split /\t/;
	if(!$used{$a[0]}){
		print OUT "$a[0]\t$a[1]\n";
	}
}
close IN;
close OUT;
