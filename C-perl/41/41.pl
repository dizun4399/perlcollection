#!/usr/bin/perl -w
use strict;

my $data=16/3;
print "$data\n";
printf "%g\n","$data";
printf "%d\n","$data";
printf "%10d\n","$data";
printf "%-10d\n","$data";
printf "%12f\n","$data";
printf "the %%g format: %g\n","$data";

my $result=sprintf "%g\n","$data";
#my $result=sprintf "%d\n","$data";
#my $result=sprintf "%10d\n","$data";
#my $result=sprintf "%10d\n","$data";
#my $result=sprintf "%12f\n","$data";
print "$result";

my $date_tag=sprintf "%4d/%02d/%02d %2d:%02d:%02d",2015,07,23,12,12,45;
print "$date_tag\n";
