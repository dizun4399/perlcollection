#!/usr/bin/perl -w
use strict;
print "Enter your score:";
chomp (my $score=<STDIN>);
my $result=
($score==100) ? "Excellent" :
($score >=90 && $score <100 ) ?  "Very Good" :
($score >=80 && $score <90  ) ?  "Good"      :
($score >=70 && $score <80  ) ?  "OK"        :
($score >=60 && $score <70  ) ?  "Pass"      : 
                                 "You need to work hard";
                    
print "$result\n";
