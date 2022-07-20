#!usr/bin/perl -w
use strict;
use File::Basename;
die "perl $0 [FC*_metaspades.coords][output][log]" unless @ARGV == 3;
open(IF,$ARGV[0])||die;
my $sp=basename($ARGV[0],"_metaspades.coords");
open(OUT,">$ARGV[1]")||die;
open(LOG,">$ARGV[2]")||die;
my %hash;
my %len;
while(<IF>){
	chomp;
	my @a=split /\t/;
	$len{$a[-1]}=$a[8];
	if($a[6]<90){
		next;
	}
	else{
		if($a[2] <$a[3]){
			foreach($a[2] .. $a[3]){
				$hash{$a[-1]}{$_}++;
			}
		}
		else{
			foreach($a[3] .. $a[2]){
				$hash{$a[-1]}{$_}++;
			}
		}
	}
}
close IF;
foreach my $k(keys %hash){
	my @array=keys %{$hash{$k}};
	my $n=scalar @array;
	my $len=$len{$k};
	my $AF=sprintf("%.2f",$n*100/$len);
	if($AF>=90){
		print OUT "$k\t$sp\t$n\t$len\t$AF\n";
	}
	else{
		print LOG "$k\t$sp\t$n\t$len\t$AF\n";
	}
}
close OUT;
close LOG;
