#!/usr/bin/perl -w
use strict;

open FA,"<$ARGV[0]";
$/=">";
<FA>;
while (<FA>) {
    chomp;
    my ($id,$seq)=(split /\n/,$_,2);
    $seq=~ s/\n//g;
    $seq =~ s/(\w{70})/$1\n/g;
    print ">$id\n$seq";
}
