#!/usr/bin/perl -w
use strict;
use Data::Dumper;

my %hash=();
open IN,"test.txt";
while (<IN>) {
    chomp;
    my ($city, $country) = split /, /,$_;
    $hash{$country} = [] unless exists $hash{$country};
    push @{$hash{$country}}, $city;
}
close IN;

print Dumper (\%hash);

