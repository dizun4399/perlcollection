#!/usr/bin/perl -w

@number=(1,2,3,4,5);
$value=pop @number; 
print "@number\n";
print "$value\n";

push @number,5;
print "@number\n";

$data=shift @number;
print "@number\n";
print "$data\n";

unshift @number,1;
print "@number\n";
