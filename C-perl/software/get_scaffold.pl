#!/usr/bin/perl -w
use strict;
if (@ARGV==0) {
    die "perl $0 seq Scaffold_ID\n";
}

my %hash=();
my $fa=shift @ARGV;
open IN,"$fa";
$/=">";<IN>;
while (<IN>) {
    chomp;
    my ($temp,$seq) = (split /\n/,$_,2)[0,1];
    my $id=(split /\s+/,$temp)[0];

#    die "$seq\n";
    $seq =~ s/\n//g;
    $hash{$id}=$seq;
}
close IN;

foreach (@ARGV) {
    my $seq=$hash{$_};
    print ">$_\n";
    print "$seq\n";
}
