#!/usr/bin/perl -w
use strict;
my $seq="ATGAAACTCTACAATCTGAAAGATCACAACGAGCAGG1TAAGCTTTGCGCAAGCCGTAACCCAGGGGT2TAA";
#if ($seq=~ /^ATG(.+)TAA/i) {
if ($seq=~ /^ATG(.+?)TAA/i) {
    print "$1\n";
} else {
    next;
}
