#!/usr/bin/perl -w
use strict;

my @array=qw /A  D k z E G F  a k B c k z/;
my @sort=sort @array;
#my @sort_by_number=sort {$a cmp $b} @array;
my @sort_by_number=sort {"\L$a" cmp "\L$b"} @array;
print "@sort\n";
print "@sort_by_number\n";

