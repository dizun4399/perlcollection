#!/usr/bin/perl -w
use strict;
my (@seq,$read,$id,);
open FA,"<$ARGV[0]";
$/=">";
<FA>;
while (<FA>) {
    chomp;
    @seq=split /\n/,$_;
    $id=$seq[0];
    $read=$seq[1];
    $read =~ s/(\w{70})/$1\n/g;
    print ">$id\n$read\n";
}
