#!usr/bin/perl -w
use strict;
die "perl $0 [Isolates_SOAP_coords.list][output]" unless @ARGV == 2;
open(LIST,$ARGV[0])||die;
open(IN,"data/F1RT4SOAP_depth_mean_rawdepth_500bp.xls")||die;
open(OUT,">$ARGV[1]")||die;
my %used;
while(<LIST>){
	chomp;
	my $file=$_;
	open(TMP,$file)||die;
	while(<TMP>){
		chomp;
		my @a=split /\t/;
		$used{$a[-1]}=1;
	}
	close TMP;
}
close LIST;
while(<IN>){
	chomp;
	my @a=split /\t/;
	if(!$used{$a[0]}){
		print OUT "$a[0]\t$a[1]\n";
	}
}
close IN;
close OUT;
