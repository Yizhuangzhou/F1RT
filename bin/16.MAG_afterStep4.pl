#!usr/bin/perl -w
use strict;
die "perl $0 [FC.list][PossibleScaf_Classification.xls]" unless @ARGV == 2;
open(LIST,$ARGV[0])||die;
open(IF,$ARGV[1])||die;
my %sp;
my %depth;
my %len;
my %type;
while(<IF>){
	chomp;
	my @a=split /\t/;
	push @{$sp{$a[1]}},$a[0];
	$len{$a[0]}=$a[2];
	$depth{$a[0]}=$a[3];
	$type{$a[0]}=$a[4];
}
close IF;
while(<LIST>){
	chomp;
	my ($sp,$file)=split /\t/;
	open(TMP,$file)||die;
	while(<TMP>){
		chomp;
		my @a=split /\t/;
		push @{$sp{$sp}},$a[0];
		if($type{$a[0]}){
			print STDERR "$_\t$sp\n";
		}
		$depth{$a[0]}=$a[1];
		$len{$a[0]}=$a[2];
		$type{$a[0]}=$a[3];
	}
	close TMP;
	my @Scaf=@{$sp{$sp}};
	@Scaf=sort {$depth{$b} <=> $depth{$a}} @Scaf;
	open(OUT,">$sp\_MAG_afterStep4.xls")||die;
	foreach my $k(@Scaf){
		print OUT "$k\t$depth{$k}\t$len{$k}\t$type{$k}\n";
	}
	close OUT;
}
close LIST;
