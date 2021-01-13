#!/usr/bin/perl -w
use strict;

my $line1="Score =  161 bits (407), Expect = 1e-43,   Method: Compositional matrix adjust.";
my $line2="Identities = 141/471 (29%), Positives = 227/471 (48%), Gaps = 41/471 (8%)";

if ($line1=~ m/Score\s*=\s*([\d\.\,]+)\s*(?:bits|Bits)\s*\(\d+\)\,\s*Expect\s*=\s*(\d+e-\d+)\.*/) {
#if ($line1=~ m/Score\s*=\s*([\d\.\,]+)\s*bits\s*\(\d+\)\,\s*Expect\s*=\s*(\S+),\.*/) {
    print "$1\t$2\n";
}
if ($line2=~ m/Identities\s*=\s*([\d\,\.]+)\/([\d\,\.]+)\s*\((\S+)\%\).*/) {
   print "$1\t$2\t$3\n";
} 
