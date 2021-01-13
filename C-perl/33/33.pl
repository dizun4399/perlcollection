#!/usr/bin/perl -w
use strict;
use File::Basename;

my $path="../33/test.txt";
my($filename, $directories,$suffix) = fileparse($path, qr /\..*/);
#print "$file_name\n";
#print "$dir_name\n";
print "$suffix\n";
