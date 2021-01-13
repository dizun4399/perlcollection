#!/usr/bin/perl -w

open IN,"blast_m8.out"; #open the file
while (<IN>) {
    chomp; #\n
    my @line=split /\s+/,$_; #1 - 12
    if ($line[2] >=50 && $line[3] >=100) {
        print "$_\n";
    } else {
        next;
    }
}
close IN;

