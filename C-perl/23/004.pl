#!/usr/bin/perl -w
use strict;

my $seq="TTATCCCTAAAATNGTNNNAGTATAAACATAAGAGTATAACGAGAATGATAATCCCCATGGCCGCAACTAGCAGACCTTGAGCCAAGAGA";
my $r_seq=reverse $seq;
$r_seq=~ tr/ATCG/TAGC/;
print "$seq\n";
print "$r_seq\n";

