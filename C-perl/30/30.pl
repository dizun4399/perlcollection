#!/usr/bin/perl -w
use strict;

my $soapdenovo="SOAPdenovo-63mer";
my $lib=shift @ARGV;

for (my $i=13;$i<=63;$i+=2) {
    my $kmer="kmer"."$i";
    print "$soapdenovo all -s $lib -K $i -u -d 1 -o $kmer >$kmer.log\n";
}

