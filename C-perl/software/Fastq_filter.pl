#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use Pod::Text;

my ($fastq1,$fastq2,$quality,$length,$q,$n,$l,$g_size,$miseq);
GetOptions(
        "i:s"=>\$config_file,
        "h:s"=>\$help,
        "q:s"=>\$q,
        "n:i"=>\$n,
        "l:i"=>\$l,
        "m:i"=>\$miseq,
        "s:i"=>\$g_size,
        "d:s"=>\$detail,
        "o:s"=>\$outdir,
        );
if (defined $detail) {
    &detailed;
}
die `pod2text $0` if ($help || !defined($config_file || $outdir) );
open FQ1,"$ARGV[0]";
open FQ2,"$ARGV[1]";
open OT1,">$ARGV[2]";
open OT2,">$ARGV[3]";
my $filter=$ARGV[4]||=20;
while (<FQ1>) {
    chomp;
    chomp (my $seq1=<FQ1>);
    chomp (my $plus1=<FQ1>);
    chomp (my $qual1=<FQ1>);
    chomp (my $rd2=<FQ1>);
    chomp (my $seq2=<FQ1>);
    chomp (my $plus2=<FQ1>);
    chomp (my $qual2=<FQ1>);
    my @read1=&trans_asc ($qual1);
    my @read2=&trans_asc ($qual2);
    my $r1_num=grep $_<53,@read1;
    my $r2_num=grep $_<53,@read2;
#    print "$r1_num\n";
#    print "@read1\n";
    if ($r1_num<=$filter && $r2_num<=$filter) {
        print OT1 "$_\n$seq1\n$plus1\n$qual1\n";
        print OT2 "$rd2\n$seq2\n$plus2\n$qual2\n";
    } else {
        next;
    }
}
close FQ1;
close FQ2;
close OT1;
close OT2;

sub trans_asc {
    my $seq=shift @_;
    my @ascii=();
    my $len=length $seq;
    for (my $i=0;$i<$len;$i++) {
        my $base=substr ($seq,$i,1);
        my $asc=ord ($base);
        push @ascii,$asc;
    }
    return @ascii;
}




