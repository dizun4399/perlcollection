#!/usr/bin/perl -w
use strict;

my $number=1234567.89;

my $result=&comma ($number);
print "$result\n";


sub comma {
    my $data=shift @_;
    1 while $data =~ s/^(-?\d+)(\d\d\d)/$1,$2/;
    return $data;
}

