#!/usr/bin/perl -w
use strict;

my $file=shift @ARGV;

#die "$file is already exists\n" if -e $file;

#print "$file is already a old file\n" if (-M $file > 5);

my @file_list=();
foreach (@file_list) {
    print "$_\n" if (-s $_ > 100_000_000 and -A $_ >90);
}

