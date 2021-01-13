#!/usr/bin/perl -w
use strict;

my $dir="./filelist";
#my @allfile=glob "$dir/*.fna";
#print "@allfile\n";

opendir DIR,"$dir",or die "can not open the dir\n";
while (readdir DIR) {
    next if /^\.{1,2}/;
    unlink "test.fna";
    print "$_\n";
}
