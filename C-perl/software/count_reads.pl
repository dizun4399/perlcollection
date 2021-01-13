#!/usr/bin/perl -w
use strict;
my $seq;
my ($GC,$N,$total_length,$total_number,$all_length);
open SEQ,"$ARGV[0]" or die "usage:perl test2.pl <IN> <OUT>\n";
#open OUT,">>$ARGV[1]";
#open OUT,">>$ARGV[0].out";
$/="@";
my $null=<SEQ>;
while(<SEQ>){
        chomp;
        $seq=(split /\n/,$_)[1];
        $GC+=($seq=~s/G/G/g+$seq=~s/C/C/g);
        $N+=($seq=~s/N/N/g);
        $total_length+=length($seq);
        $total_number++;
	$all_length=length($seq);
}

$GC=$GC/$total_length;
$N=$N/$total_length;
#print OUT "name\ttotal_number\ttotal_length\tGC%\tN%\tread_length\n";

print $ARGV[0],"\t",$total_number,"\t",$total_length,"\t",$GC,"\t",$N,"\t",$all_length,"\n";
close SEQ;

