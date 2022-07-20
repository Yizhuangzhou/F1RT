#!usr/bin/perl -w
use strict;
die "perl $0 [data/F1RT_depth_mean_rawdepth_500bp.xls][Isolates_PrimaryMAG.xls][output]" unless @ARGV == 3;
open(IF,$ARGV[0])||die;
open(IN,$ARGV[1])||die;
open(OUT,">$ARGV[2]")||die;
my %sp;
while(<IN>){
	chomp;
	my @a=split /\t/;
	$sp{$a[0]}=$a[1];
}
close IN;
my %depth;
while(<IF>){
	chomp;
	my @a=split /\t/;
	if($sp{$a[0]}){
		$depth{$sp{$a[0]}}{$a[0]}=$a[1];
	}
}
close IF;
print OUT "MAS\tDepth\tIsolate\n";
foreach my $k(qw(FC2 FC3 FC5 FC7)){
	my @scaf=sort {$depth{$k}{$b} <=> $depth{$k}{$a}} keys %{$depth{$k}};
	print STDERR "$k\t$depth{$k}{$scaf[0]}\t$depth{$k}{$scaf[-1]}\n";
	foreach my $k2(@scaf){
		print OUT "$k2\t$depth{$k}{$k2}\t$k\n";
	}
}
close OUT;
