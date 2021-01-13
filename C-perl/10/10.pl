#!/usr/bin/perl 

$scalar="abc:def:g:h";
@array=split /:/,$scalar;
print "@array\n";

$new_scalar=join ":",@array;
print "$new_scalar\n";
