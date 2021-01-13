#!/usr/bin/perl -w
use strict;
use Getopt::Long;

my ($input,$output,$float,$help);

GetOptions(
    "i:s"=>\$input,
    "o|output:s"=>\$output,
    "f=s"=>\$float,
    "h|help!"=>\$help,
    );

die "Usage:  print help message\n" if (defined $help);

open IN,"$input";
while (<IN>) {
    chomp;
    print "$_\n";
}
close IN;
