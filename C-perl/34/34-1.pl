#!/usr/bin/perl -w
use strict;
use Getopt::Std;
use Data::Dumper;
my %opts=();

getopts ("i:o:h",\%opts);
my $input=$opts{i};
die "Usage:    print help message\n" if (defined $opts{h});
print Dumper (\%opts);
open IN,"$input";
while (<IN>) {
    chomp;
    print "$_\n";
}
close IN;


