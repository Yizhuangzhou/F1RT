#!usr/bin/perl -w
use strict;
die "perl $0 [Metaspades_SOAP_RemainScaf.coords][RemainScaf.fa][[output]" unless @ARGV == 3;
open(IF,$ARGV[0])||die;
open(IN,$ARGV[1])||die;
open(TMP,"/data/PROJECT/zhouyzh/F1RT/data/Assembly/Mapping/Metaspades/F1RT_depth_mean_rawdepth_500bp.xls")||die;
open(OUT,">$ARGV[2]")||die;
my %hash;
while(<IF>){
	chomp;
	my @a=split /\t/;
	$hash{$a[11]}=1;
}
close IF;
my %flag;
while(<IN>){
	chomp;
	if(/>(\S+)/){
		$flag{$1}=1;
	}
}
close IN;
while(<TMP>){
	chomp;
	my @a=split /\t/;
	if($flag{$a[0]}){
		if(!$hash{$a[0]}){
			print OUT "$a[0]\t$a[1]\n";
		}
	}
}
close TMP;
close OUT;
