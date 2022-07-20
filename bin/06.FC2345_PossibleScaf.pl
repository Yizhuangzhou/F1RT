#!usr/bin/perl -w
use strict;
die "perl $0 [FC2_PrimaryMAG.xls][FC2_PrimaryMAG.log][FC3_PrimaryMAG.xls][FC3_PrimaryMAG.log][FC5_PrimaryMAG.xls][FC5_PrimaryMAG.log][FC7_PrimaryMAG.xls][FC7_PrimaryMAG.log][output]" unless @ARGV ==9;
open(OUT,">$ARGV[8]")||die;
my %hash;
&Deal($ARGV[0]);
&Deal($ARGV[2]);
&Deal($ARGV[4]);
&Deal($ARGV[6]);
&Output($ARGV[1]);
&Output($ARGV[3]);
&Output($ARGV[5]);
&Output($ARGV[7]);
close OUT;
sub Output{
	my ($file)=@_;
	open(TMP,$file)||die;
	while(<TMP>){
		chomp;
		my @a=split /\t/;
		if($hash{$a[0]}){
			next;
		}
		else{
			print OUT "$_\n";
		}
	}
	close TMP;
}
sub Deal{
	my ($file)=@_;
	open(TMP,$file)||die;
	while(<TMP>){
		chomp;
		my @a=split /\t/;
		$hash{$a[0]}=1;
	}
	close TMP;
}
