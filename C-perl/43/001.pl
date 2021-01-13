#!/usr/bin/perl -w
use strict;
use Bio::Perl;

my $filename="NC_000962.gbk";
my $seq = read_sequence($filename,'genbank');
my @id=$seq_object->display_id;
my @seq=$seq_object->seq;
print "$seq\n";
print "Sequence name is ",$seq_object->display_id,"\n";
