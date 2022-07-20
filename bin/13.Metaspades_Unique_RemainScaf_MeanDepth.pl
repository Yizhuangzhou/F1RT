#!usr/bin/perl -w
use strict;
die "perl $0 [Metaspades_SOAP_RemainScaf.coords][metaspades_RemainScaf.fa][[output]" unless @ARGV == 3;
open(IF,$ARGV[0])||die;
open(IN,$ARGV[1])||die;
open(TMP,"data/F1RT_depth_mean_rawdepth_500bp.xls")||die;
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
my %depth;
while(<TMP>){
	chomp;
	my @a=split /\t/;
	if($flag{$a[0]}){
		if(!$hash{$a[0]}){
			$depth{$a[0]}=$a[1];
		}
	}
}
close TMP;

foreach my $k(sort {$depth{$b} <=> $depth{$a}} keys %depth){
	print OUT "$k\t$depth{$k}\n";
}
close OUT;
