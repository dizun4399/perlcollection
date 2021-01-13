#!/usr/bin/perl -w
use strict;

my $line1="Score =  161 bits (407), Expect = 1e-43,   Method: Compositional matrix adjust.";
my $line2="Identities = 141/471 (29%), Positives = 227/471 (48%), Gaps = 41/471 (8%)";

my @result= ($line1=~ m/Score\s*=\s*([\d\.\,]+)\s*bits\s*\(\d+\)\,\s*Expect\s*=\s*(\S+),\.*/);
print "@result\n";
my @result2=( $line2=~ m/(\S+)/g);
print "@result2\n"; 
