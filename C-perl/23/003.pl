#!/usr/bin/perl -w
use strict;

my $line="hello,world!";
$line=~ s/world/China/;
$line=~ s/(\w+),(\w+)!/$2,$1!/;
$line=~ s/^/Nihao,/;
$line=~ s/$/hello!/;
#$line=~ s/hello!//g;
my $num+=($line=~ s/hello!//g);
print "$line\n";
print "$num\n";
