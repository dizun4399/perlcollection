#!/usr/bin/perl -w
use strict;

open IN,"<$ARGV[0]";
while (<IN>) {
    chomp;
    chomp (my $seq=<IN>);
    chomp (my $plus=<IN>);
    chomp (my $qual=<IN>);
    s/^@/>/;
    print "$_\n";
    print "$seq\n";
}
close IN;
