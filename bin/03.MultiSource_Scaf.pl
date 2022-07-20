#!usr/bin/perl -w
use strict;
die "perl $0 [FC2_MAG.xls][FC3_MAG.xls][FC5_MAG.xls][FC7_MAG.xls][output]" unless @ARGV == 5;
my %sp;
&deal($ARGV[0]);
&deal($ARGV[1]);
&deal($ARGV[2]);
&deal($ARGV[3]);
open(OUT,">$ARGV[4]")||die;
foreach my $k(keys %sp){
	my @sp=@{$sp{$k}};
	if(@sp >1){
		print OUT "$k\t",join("\t",@sp),"\n";
	}
}
close OUT;
sub deal{
	my ($file)=@_;
	open(TMP,$file)||die;
	while(<TMP>){
		chomp;
		my @a=split /\t/;
		push @{$sp{$a[0]}},$a[1];
	}
	close TMP;
}
