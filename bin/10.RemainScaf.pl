#!usr/bin/perl -w
use strict;
die "perl $0 [Isolates_PrimaryMAG.xls][FC2357_PossibleScaf.xls][fa][output]" unless @ARGV == 4;
open(FA,$ARGV[2])||die;
open(OUT,">$ARGV[3]")||die;
my %hash;
&deal($ARGV[0]);
&deal($ARGV[1]);
my $id;
while(<FA>){
	chomp;
	if(/>(\S+)/){
		$id=$1;
		if($hash{$id}){
			next;
		}
		else{
			print OUT "$_\n";
		}
	}
	else{
		if($hash{$id}){
			next;
		}
		else{
			print OUT "$_\n";
		}
	}
}
close FA;
close OUT;
sub deal{
	my ($file)=@_;
	open(TMP,$file)||die;
	while(<TMP>){
		chomp;
		my @a=split /\t/;
		$hash{$a[0]}=1;
	}
	close TMP;
}
