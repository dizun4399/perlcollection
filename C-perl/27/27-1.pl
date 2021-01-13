#!/usr/bin/perl -w
use strict;

my $condition=10;

if ($condition >= 10) {
    print "The use of if is right\n";
} else {
    print "The condition is less than 10\n";
}

unless ($condition <10) {
    print "The use of unless is right\n";
} else {
    print "The condition is less than 10\n";
}
    
