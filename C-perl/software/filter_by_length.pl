#!/usr/bin/perl -w
use strict;
if (scalar @ARGV!=5) {
    die "This program is used to filter FastQ file by read length
        perl $0 <Reads1.fq> <Read2.fq> <Filter.1.fq> <Filter.2.fq> <filter length>\n";
}

open FQ1,"$ARGV[0]";
open FQ2,"$ARGV[1]";
open OT1,">$ARGV[2]";
open OT2,">$ARGV[3]";
my $filter=$ARGV[4]||=150;
while (<FQ1>) {
    chomp;
    chomp (my $seq1=<FQ1>);
    chomp (my $plus1=<FQ1>);
    chomp (my $qual1=<FQ1>);
    chomp (my $rd2=<FQ1>);
    chomp (my $seq2=<FQ1>);
    chomp (my $plus2=<FQ1>);
    chomp (my $qual2=<FQ1>);
    my $len1=length ($seq1);
    my $len2=length ($seq2);
    if ($len1>=$filter && $len2>=$filter) {
        print OT1 "$_\n$seq1\n$plus1\n$qual1\n";
        print OT2 "$rd2\n$seq2\n$plus2\n$qual2\n";
    } else {
        next;
    }
}
close FQ1;
close FQ2;
close OT1;
close OT2;
