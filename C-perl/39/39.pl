#!/usr/bin/perl -w
use strict;

my @array=(1..20);
my @sort=sort @array;
#my @sort_by_number=sort {$a<=>$b} @array;
#my @sort_by_number=reverse sort {$a<=>$b} @array;
my @sort_by_number=sort {$b<=>$a} @array;
print "@sort\n";
print "@sort_by_number\n";

