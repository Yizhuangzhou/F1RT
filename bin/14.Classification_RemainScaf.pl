#!usr/bin/perl -w
use strict;
use POSIX qw(strftime);
die "perl $0 [data/F1RT_CoreDepthInterval.xls][output|len][output|source]" unless @ARGV==3;

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
open(IN,"data/metaspades_scaffolds_more500.fasta")||die;
open(DP,$ARGV[0])||die;
open(OL,">$ARGV[1]")||die;
open(OUT,">$ARGV[2]")||die;
open(TMP,"Isolates_PrimaryMAG.xls")||die;
open(PF,"FC2357_PossibleScaf.xls")||die;
my %min;
my %max;
while(<DP>){
	chomp;
	my @a=split /\t/;
	$min{$a[0]}=$a[1];
	$max{$a[0]}=$a[2];
	print STDERR "$a[0]\t$a[1]\t$a[2]\n";
}
close DP;

my %used;
my %sp;
my %hash=();
my %type;
while(<TMP>){
	chomp;
	my @a=split /\t/;
	$used{$a[0]}=1;
	$sp{$a[0]}=$a[1];
	push @{$hash{$a[1]}},$a[0];
	$type{$a[0]}=">90% AF";
}
close TMP;
while(<PF>){
	chomp;
	my @a=split /\t/;
	$used{$a[0]}=1;
}
close PF;
open(DF,"data/F1RT_depth_mean_rawdepth_500bp.xls")||die;
my %depth;
while(<DF>){
	chomp;
	my @a=split /\t/;
	$depth{$a[0]}=$a[1];
}
close DF;

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

############################## Classification based on coverage ############################################################
my %Slen;
my %clseq;
my @sp=qw(FC1 FC2 FC3 FC4 FC5 FC6 FC7 FC8-9);
my @RemainSP=qw(FC1 FC4 FC6 FC8-9);
foreach my $id (keys %seq) {
	if(!$used{$id}){
		my @refID=();
		foreach my $cl (@RemainSP) {
			my $min=$min{$cl};
			my $max=$max{$cl};
			if($depth{$id} >= $min && $depth{$id} <=$max){
				push @refID,$cl;
			}
		}
		if(@refID == 1){
			$sp{$id}=$refID[0];
			$type{$id}="Coverage";
			push @{$hash{$refID[0]}},$id;
			$used{$id}=1;
			$clseq{$sp{$id}}.=$seq{$id};
			$Slen{$sp{$id}}+=length $seq{$id};
		}
	}
}
foreach my $cl (@RemainSP) {
	if($Slen{$cl}){
		print OL "$cl\t$Slen{$cl}\n";
	}
}
close OL;

############################## Preparation for Classification ############################################################
my %prob=();
foreach my $sp (@RemainSP) {
	my $seq=$clseq{$sp};
	my $revseq=reverse($seq);
	$revseq=~tr/ATGC/TACG/;
	$seq.=$revseq;
	my $len=length $seq;
	my $tmplen=$len/2;
	print STDERR "$sp\t$tmplen\n";
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
	#print STDERR "$current_time: Finishing calculating frequency for $sp\n";
}

############################## Classification for all ############################################################
my %len;
foreach my $id (keys %seq) {
	my $seq=$seq{$id};
	my $len=length $seq;
	$len{$id}=$len;
	next if($used{$id});
	my %freq=();
	for(my $i=0;$i<=$len-4;$i++){
		my $tetra=substr($seq,$i,4);
		$freq{$tetra}++;
	}
	my @refID=();
	foreach my $cl (@RemainSP) {
		my $min=$min{$cl};
		my $max=$max{$cl};
		if($depth{$id} >= $min && $depth{$id} <=$max){
			push @refID,$cl;
		}
	}
	if(@refID == 0){
		print STDERR "$id\t$depth{$id}\n";
	}
	elsif(@refID == 1){
		push @{$hash{$refID[0]}},$id;
		$type{$id}="Coverage";
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
		my $fold=$val{$refID[0]}-$val{$refID[1]};
		push @{$hash{$refID[0]}},$id;
		$type{$id}="Bayesian";
	}
}

############################## Output results ############################################################
foreach my $sp (@sp) {
	next if(!$hash{$sp});
	my @array=@{$hash{$sp}};
	@array=sort {$depth{$b} <=> $depth{$a}} @array;
	open(OR,">$sp\_PrimaryMAG_withType.xls")||die;
	foreach(@array){
		print OUT "$_\t$sp\t$depth{$_}\t$len{$_}\t$type{$_}\n";
		print OR "$_\t$depth{$_}\t$len{$_}\t$type{$_}\n";
	}
	close OR;
}
close OUT;

