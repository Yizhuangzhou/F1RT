#!usr/bin/perl -w
use strict;
use POSIX qw(strftime);
die "perl $0 [FC2_MAG_afterStep4.xls][data/metaspades_scaffolds_more500.fasta][data/FC8-9_SCGtype_SCGscaffoldDepth_source.xls][output|PP]" unless @ARGV==4;

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
open(IF,$ARGV[0])||die;
open(IN,$ARGV[1])||die;
open(TMP,$ARGV[2]);
open(OF,">$ARGV[3]")||die;
my %seq;
my $id;
while(<IN>){
	chomp;
	if(/>(\S+)/){
		$id=$1;
	}
	else{
		s/[^ATGC]//g;
		$seq{$id}.=$_;
	}
}
close IN;
my $seq="";
while(<IF>){
	chomp;
	my @a=split /\t/;
	$seq.=$seq{$id};
}
close IF;

my %hash_kmer=();
my $sum=0;
my $rev=reverse($seq);
$rev=~tr/ATGC/TACG/;
$seq.=$rev;
my $length=length $seq;
for(my $i=0;$i<=$length-4;$i++){
	my $sub=substr($seq,$i,4);
	$hash_kmer{$sub}++;
}
$sum=$length-4+1;
my %prob=();
foreach(@oligo_kmer){
	my $val;
	if($hash_kmer{$_}){
		$val=$hash_kmer{$_}/$sum;
	}
	else{
		$val=1/$sum;
	}
	$prob{$_}=log($val)/log(10);
}

<TMP>;
while(<TMP>){
	chomp;
	my @a=split /\t/;
	next if($a[1] eq "NA");
	my @b=split /\;/,$a[1];
	next if(@b == 1);
	my %PP=();
	foreach my $k (@b) {
		$k=~s/\([\d\.]+\)//;
		my $seq=$seq{$k};
		my $revseq=reverse($seq);
		$revseq=~tr/ATGC/TACG/;
		$seq.=$revseq;
		my $len=length $seq;
		my %freq=();
		for(my $i=0;$i<=$len-4;$i++){
			my $tetra=substr($seq,$i,4);
			$freq{$tetra}++;
		}
		my $PP=0;
		foreach my $sub (keys %freq) {
			$PP +=$freq{$sub}*$prob{$sub};
		}
		$PP =$PP*500/$len;
		$PP{$k}=$PP;
		printf OF "$k\t%.2f\n",$PP;
	}
}
close TMP;
close OF;

