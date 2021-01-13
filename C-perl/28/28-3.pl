#!/usr/bin/perl -w
use strict;
print "Enter your score:";
chomp (my $score=<STDIN>);

if ($score==100) {
    print "Excellent\n";
} elsif ($score >=90 && $score <100 ) {
    print "Very Good\n";
} elsif ($score >=80 && $score <90) {
    print "Good\n";
} elsif ($score >=70 && $score <80) {
    print "OK\n";
} elsif ($score >=60 && $score <70) {
    print "Pass\n";
} else {
    print "You need to work hard\n";
}
