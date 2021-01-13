#!/usr/bin/perl -w
use strict;
use Getopt::Std;

our ($opt_i,$opt_o,$opt_h);
getopt ("ioh");
#getopts ("1:o:h");
my $input=$opt_i;
my $output=$opt_o;
my $help=$opt_h;

die "Usage:  print help message\n" if (defined $opt_h || !$input);

open IN,"$input";
while (<IN>) {
    chomp;
    print "$_\n";
}
close IN;


