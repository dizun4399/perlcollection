#!/usr/bin/perl -w
use strict;

open IN,"<$ARGV[0]",or die "can not open the file\n$!";
while (<IN>) {
    chomp;
    if (!/^ATG.*TAA$/i) {
        print "$_\n";
    } else {
        next;
    }
}
close IN;
