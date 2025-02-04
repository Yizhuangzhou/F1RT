#!usr/bin/perl -w
use strict;
die "perl $0 [reference][qeurey][prefix]" unless @ARGV==3;
my $ref=$ARGV[0];
my $qry=$ARGV[1];
my $prefix=$ARGV[2];
`/data/PROJECT/zhouyzh/software/MUMmer3.23/nucmer --maxmatch -p $prefix $ref $qry`;
my $delta="$prefix.delta";
my $deltafilter="$delta"."filter";
`/data/PROJECT/zhouyzh/software/MUMmer3.23/delta-filter -q -r -l 200 $delta >$deltafilter`;
my $coords="$prefix.coords";
`/data/PROJECT/zhouyzh/software/MUMmer3.23/show-coords -H -c -l -r -T $deltafilter >$coords`;
