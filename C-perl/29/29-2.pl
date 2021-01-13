#!/usr/bin/perl -w
use strict;

my $m=4;
my $n=5;

($m < $n ) && ($m = $n);
print "$m\n";
($m>10) ||print "this time can print!\n";
