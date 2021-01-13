#!/usr/bin/perl -w
use Bio::Perl;
my $gb=Bio::DB::GenBank->new;
my $seq=$gb->get_Seq_by_acc('NC_000962');
print "$seq\n";
