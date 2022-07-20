#!usr/bin/perl -w
use strict;
use POSIX qw(strftime);
die "perl $0 [FC.list][FC2357_PossibleScaf.xls][data/F1RT_CoreDepthInterval.xls][output]" unless @ARGV==4;

############################## Intializing for Zvalue ##############################################
my @mono=("A","T","G","C");
our @oligo_kmer=();
foreach(@mono){
	my $word=$_;
	foreach (@mono){
		my $di=$word."$_";
		foreach(@mono){
			my $tri=$di."$_";
			foreach(@mono){
				my $tetra=$tri."$_";
				push @oligo_kmer,$tetra;
			}
		}
	}
}

############################## Main ############################################################
open(LIST,$ARGV[0])||die;
open(DF,$ARGV[2])||die
my %min;
my %max;
while(<DF>){
	chomp;
	my @a=split /\t/;
	my $sp=$a[0];
	$min{$sp}=$a[1];
	$max{$sp}=$a[2];
}
close DF;

my %isolate;
foreach(qw(FC2 FC3 FC5 FC7)){
	$isolate{$_}=1;
}

my @sp=qw(FC1 FC2 FC3 FC4 FC5 FC6 FC7 FC8-9);
my %sp;
while(<LIST>){
	chomp;
	my ($FC,$file)=split /\t/;
	open(TMP,$file)||die;
	while(<TMP>){
		chomp;
		my @a=split /\t/;
		$sp{$a[0]}=$FC;
	}
	close TMP;
}
close LIST;

my %depth;
open(DP,"data/F1RT_depth_mean_rawdepth_500bp.xls")||die;
while(<DP>){
	chomp;
	my @a=split /\t/;
	$depth{$a[0]}=$a[1];
}
close DP;

my %seq;
my $id;
my %clseq;
open(IN,"data/metaspades_scaffolds_more500.fasta")||die;
while(<IN>){
	chomp;
	if(/>(\S+)/){
		$id=$1;
	}
	else{
		s/[^ATGC]//g;
		if($sp{$id}){
			$clseq{$sp{$id}}.=$_;
		}
		$seq{$id}.=$_;
	}
}
close IN;

my %prob=();
foreach my $sp (@sp) {
	my $seq=$clseq{$sp};
	my $revseq=reverse($seq);
	$revseq=~tr/ATGC/TACG/;
	$seq.=$revseq;
	my $len=length $seq;
	my %hash_kmer=();
	for(my $i=0;$i<=$len-4;$i++){
		my $tetra=substr($seq,$i,4);
		$hash_kmer{$tetra}++;
	}
	my $sum=$len-3;
	foreach(@oligo_kmer){
		my $val;
		if($hash_kmer{$_}){
			$val=$hash_kmer{$_}/$sum;
		}
		else{
			$val=1/$sum;
		}
		$prob{$sp}{$_}=log($val)/log(10);
	}
	my $current_time = strftime "%Y-%m-%d %H:%M:%S", localtime;
	print STDERR "$current_time: Finishing calculating frequency for $sp\n";
}

open(PF,$ARGV[1])||die;
open(OUT,">$ARGV[3]")||die;
while(<PF>){
	chomp;
	my @a=split /\t/;
	my $id=shift @a;
	if(!$seq{$id}){
		print STDERR "$id\n";
	}
	else{
		my $seq=$seq{$id};
		my $len=length $seq;
		my %freq=();
		for(my $i=0;$i<=$len-4;$i++){
			my $tetra=substr($seq,$i,4);
			$freq{$tetra}++;
		}
		my @refID=();
		foreach my $sp(@sp){
			my $min=$min{$sp};
			my $max=$max{$sp};
			if($depth{$id} >= $min && $depth{$id} <=$max){
				push @refID,$sp;
			}
		}
		my $num=scalar @refID;
		if($num == 1){
			my $type="<90% AF Cov";
			print OUT "$id\t$refID[0]\t$len\t$depth{$id}\t$type\n";
		}
		else{
			my %val=();
			foreach my $cl (@refID) {
				my $val=0;
				foreach my $sub (keys %freq) {
					$val +=$freq{$sub}*$prob{$cl}{$sub};
				}
				$val{$cl}=$val*500/$len;
			}
			@refID=sort{$val{$b} <=> $val{$a}} @refID;
#my $fold=$val{$refID[0]}-$val{$sp{$id}};
			my $flag =0;
			if($refID[0] eq $a[0]){
				$flag =1;
			}
			my $type="<90% AF Bayesian";
			if($flag == 1){
				print OUT "$id\t$refID[0]\t$len\t$depth{$id}\t$type\n";
			}
			else{
				foreach(@refID){
					#print STDERR "$id\t$_\t$val{$_}\t$depth{$id}\n";
					if(!$isolate{$_}){
						print OUT "$id\t$_\t$len\t$depth{$id}\t$type\n";
						$flag =1;
						last;
					}
				}
				if($flag == 0){
					print OUT "$id\t$refID[0]\t$len\t$depth{$id}\t$type\n";
				}
			}	
		}# num>1
	}
}
close PF;
close OUT;
