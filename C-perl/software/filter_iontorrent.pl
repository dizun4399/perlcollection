#!/usr/bin/perl -w
use strict;
use Data::Dumper;
use Getopt::Long;

my ($ion,$output,$len,$qulity,$start,$end,$help,$number);
GetOptions(
        "i:s"=>\$ion,
        "o:s"=>\$output,
        "l:i"=>\$len,
        "q:i"=>\$qulity,
        "n:i"=>\$number,
#        "s:i"=>\$start,
#        "e:i"=>\$end,
        "h:s"=>\$help,
        );

&usage if (!$ion or $help);

$qulity ||=20; 
$len||=20;
$start ||=0;
$end ||=0;
$number||=1;

open IN,"<$ion";
open OU,">$output";

while (<IN>) {
    chomp;
    chomp (my $seq=<IN>);
    chomp (my $plus=<IN>);
    chomp (my $qual=<IN>);
    my $length = length ($seq);
    next if ($length <=$len);
    my @qual = &qual ($qual);
#    print "@qual\n";
    my $q20=(grep $>=20,@qual);
    my $Q20=$q20/$length;
    next if ($q20 <= $number);
#    my $seq1=substr ($seq
    print  OU "$_\n";
    print  OU "$seq\n";
    print  OU "$plus\n";
    print  OU "$qual\n";


}
close IN;

sub qual {
    my $line=shift @_;
    my @line=split //,$_;
    my @qual=();
    foreach (@line) {
        my $asc=ord ($_)-31;
        push @qual,$asc;
    }
    return @qual;
}

sub usage {
    print  "\e[;32;1m\n","perl $0 -i ion.fastq -l 20 -q 20 -n 1  -o filter.fastq\n","\e[;32;1m\n";
    die "Detail Options
    This program is used to filter IonTorrent fastq data
    -i  input fastq sequence
    -o  output filter sequence
    -l  filter length than [20]
    -q  filter qulity [20]
    -n  filter qulity % [100]
\n";
}
