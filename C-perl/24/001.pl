#!/usr/bin/perl -w
use strict;

my $seq="TTATCCCTAAAATNGTNNNAGTATAAACATAAGAGTATAACGAGAATGATAATCCCCATGGCCGCAACTAGCAGACCTTGAGCCAAGAGA";
$seq=~ tr/ATCGN/atcgn/;
print "$seq\n";
$seq=~ s/(\w+)/\U$1/g;
$seq=~ s/(\w+)/\L$1/g;
$seq=~ s/(\w+)/\u$1/g;
$seq=~ s/(\w+)/\L$1/g;
print "$seq\n";
#print "$r_seq\n";

