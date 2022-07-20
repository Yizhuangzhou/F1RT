#!usr/bin/perl -w
use strict;
use POSIX qw(strftime);
use File::Basename;
die "perl $0 [FC8-9_SCGscaffold_classifiedbyFC2_PP.xls][data/metaspades_scaffolds_more500.fasta][F1RT_MAG_afterStep4.list][output]" unless @ARGV==4;

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
open(LIST,$ARGV[2]);
open(OUT,">$ARGV[3]")||die;
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


my %clseq;
my %cllen=();
while(<IF>){
	chomp;
	my @a=split /\t/;
	if($a[1]>-1350){
		$clseq{"FC9"}.=$seq{$a[0]};
		$cllen{"FC9"}+=length $seq{$a[0]};
	}
	else{
		$clseq{"FC8"}.=$seq{$a[0]};
		$cllen{"FC8"}+=length $seq{$a[0]};
	}
}
close IF;
foreach my $FC (qw(FC8 FC9)) {
	print STDERR "$FC\t$cllen{$FC}\n";
}
my %prob=();
foreach my $FC (qw(FC8 FC9)) {
	my $seq=$clseq{$FC};
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
	foreach(@oligo_kmer){
		my $val;
		if($hash_kmer{$_}){
			$val=$hash_kmer{$_}/$sum;
		}
		else{
			$val=1/$sum;
		}
		$prob{$FC}{$_}=log($val)/log(10);
	}
}

my %Size;
while(<LIST>){
	chomp;
	my $file=$_;
	my $sp=basename($file,"_MAG_afterStep4.xls");
	if($sp ne "FC8-9"){
		open(TMP,$file)||die;
		open(OF,">$sp\_FinalMAG.xls")||die;
		while(<TMP>){
			chomp;
			print OF "$_\n";
			my @a=split /\t/;
			print OUT "$a[0]\t$sp\n";
		}
		close TMP;
		close OF;
		print STDERR "Generating $sp\_FinalMAG.xls\n";
	}
	else{
		open(TMP,$file)||die;
		open(OF1,">FC8_FinalMAG.xls")||die;
		open(OF2,">FC9_FinalMAG.xls")||die;
		while(<TMP>){
			chomp;
			my @a=split /\t/;
			my $seq=$seq{$a[0]};
			my $revseq=reverse($seq);
			$revseq=~tr/ATGC/TACG/;
			$seq.=$revseq;
			my $len=length $seq;
			my %freq=();
			for(my $i=0;$i<=$len-4;$i++){
				my $tetra=substr($seq,$i,4);
				$freq{$tetra}++;
			}
			my %PP=();
			foreach my $sub (keys %freq) {
				foreach my $FC (qw(FC8 FC9)) {
					$PP{$FC} +=$freq{$sub}*$prob{$FC}{$sub};
				}
			}
			my @sp=sort {$PP{$b} <=> $PP{$a}} keys %PP;
			$Size{$sp[0]}+=length $seq{$a[0]};
			print OUT "$a[0]\t$sp[0]\n";
			if($sp[0] eq "FC8"){
				print OF1 "$_\n";
			}
			else{
				print OF2 "$_\n";
			}
		}
		close TMP;
		close OF1;
		close OF2;
		print STDERR "Generating FC8\_FinalMAG.xls\n";
		print STDERR "Generating FC9\_FinalMAG.xls\n";
	}
}
close LIST;
close OUT;
foreach my $sp (keys %Size) {
	print STDERR "$sp\t$Size{$sp}\n";
}

