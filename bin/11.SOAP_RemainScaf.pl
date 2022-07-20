#!usr/bin/perl -w
use strict;
die "perl $0 [SOAP_RemainScaf_MeanDepth.xls][fa][output]" unless @ARGV == 3;
open(IF,$ARGV[0])||die;
open(FA,$ARGV[1])||die;
open(OUT,">$ARGV[2]")||die;
my %hash;
while(<IF>){
	chomp;
	my @a=split /\t/;
	$hash{$a[0]}=1;
}
close IF;
my $id;
while(<FA>){
	chomp;
	if(/>(\S+)/){
		$id=$1;
		if(!$hash{$id}){
			next;
		}
		else{
			print OUT "$_\n";
		}
	}
	else{
		if(!$hash{$id}){
			next;
		}
		else{
			print OUT "$_\n";
		}
	}
}
close FA;
close OUT;
