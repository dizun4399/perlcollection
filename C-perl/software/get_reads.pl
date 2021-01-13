#!/usr/bin/perl -w
use strict;
use Data::Dumper;
use PerlIO::gzip;

my %hash=();
open IN,"$ARGV[0]";
while (<IN>) {
    chomp;
    my $out="@"."$_";
    $hash{$out}=1;
}
close IN;
#print Dumper (\%hash);
open RE,"<:gzip","$ARGV[1]";
open RT,"<:gzip","$ARGV[2]";
open OU,">:gzip","$ARGV[1].filter.fq.gz";
open OT,">:gzip","$ARGV[2].filter.fq.gz";
while (<RE>) {
    chomp;
    my $id=(split /\s+/,$_)[0];
    my $line2=<RE>;
    my $line3=<RE>;
    my $line4=<RE>;
    my $line5=<RT>;
    my $line6=<RT>;
    my $line7=<RT>;
    my $line8=<RT>;
    if (exists $hash{$id}) {
        next;
    } else {
        print OU "$_\n$line2$line3$line4";
        print OT "$line5$line6$line7$line8";
    }
}
close RE;
close RT;
close OU;
close OT;

