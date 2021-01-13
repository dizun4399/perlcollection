#!/usr/bin/perl -w
use strict;
my $seq="TGAAACTCTACAATCTGAAAGATGCACAACGAGCAGGTAAGCTATGCGCAAGCCGTAACCCAGGGGTTAA";

#my $where=index ($seq,"ATG");
#my $where=index ($seq,"ATG",23);
my $where=index ($seq,"ATG",index ($seq,"ATG")+1);
print "$where\n";
