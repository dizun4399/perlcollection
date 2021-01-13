#!/usr/bin/perl -w
use strict;

my $total_num=0;
my $total_len=0;
my $total_gap=0;
my $total_gc=0;
my @len_array=();

print "ID\tGeneLength(bp)\tGAPLength(bp)\tGCcontent(%)\n";
open IN,"<$ARGV[0]",or die "can not open the fiel! $!\n";
$/=">";<IN>;
while (<IN>) {
    next if (/^\s+$/);
    chomp;
    my ($id,$seq) = (split /\n/,$_,2)[0,1];
    $seq=~ s/\n//g;
    my $len=length ($seq);
    push @len_array,$len;
    $total_len+=$len;
    my $gc+=($seq=~s/G/G/g+$seq=~s/C/C/g);
    my $gap+=($seq=~s/N/N/g);
    my $GC=($gc/$len)*100;
    $total_gap+=$gap;
    $total_gc+=$gc;
print "$id\t$len\t\t$gap\t";
printf "%.2f\n","$GC";
    $total_num++;
}

my @sort_len=sort {$a<=>$b} @len_array;
my $avg_len=($total_len/$total_num);
my $total_GC=($total_gc/$total_len)*100;

print "\nTotal Stat:\n";
print "Total Number (#):$total_num\n";
print "Total length (bp):$total_len\n";
print "Gap(N)(bp):$total_gap\n";
printf "Average Length (bp): %d\n","$avg_len";
print "Minimum Length (bp):$sort_len[0]\n";
print "Maximum Length (bp):$sort_len[-1]\n";
printf "GC content(%%) : %.2f\n","$total_GC";

