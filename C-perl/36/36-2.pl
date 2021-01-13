#!/usr/bin/perl -w
use strict;

open IN,"$ARGV[0]",or die "can not open the file\n";
while (<IN>) {
    chomp;
    my ($id,$file) =(split /=/,$_)[0,1];
    if (-e $file && -s $file >100_000) {
        next;
    } else {
        print "$id=$file\n";
    }
}
close IN;
