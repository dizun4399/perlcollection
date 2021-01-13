#!/usr/bin/perl -w
use strict;

if (scalar @ARGV==0) {
    die "Usage: This program is used to get seqence by a list
        perl $0 <name list> <fasta sequence>\n";
}

my %hash=();
open IN,"$ARGV[0]";
while (<IN>) {
    chomp;
    my @line=split /\s+/,$_;
    $hash{$line[0]}=1;
}
close IN;

open FA,"<$ARGV[1]";
$/=">";<FA>;
while (<FA>) {
    chomp;
    my $temp=(split /\n/,$_,2)[0];
    my $id=(split /\s+/,$_)[0];
    if (exists $hash{$id}) {
        print ">$_";
    } else {
        next;
    }
}
close FA;

