#!/usr/bin/perl -w
use strict;

my @name=();
my %hash=();
my $length=0;
open IN,"<$ARGV[0]";
while (<IN>) {
    chomp;
    my ($id,$seq)=(split /\s+/,$_)[0,1];
    push @name,$id;
    $length=length ($seq) if ($length==0);
    my @phy=();
    for (my $i=0;$i<=($length/10);$i++) {
        my $temp=substr ($seq,$i*10,10);
        push @phy,$temp;
    }
#    my @phy=($seq=~ /\S{10}/g);
#    my @phy=map { /\S{10}/,$seq;
#    print "@phy\n";
#print "@phy\n";
    $hash{$id}=\@phy;
}
close IN;
my $num=@name;
my $flag=0;
my $time=int ($length/50)+1;
#print "$time\n";
print "\t$num\t$length\n";

for (my $i=0;$i<$time;$i++) {
    foreach (@name) {
    if ($flag==0) {
     printf "%-20s",$_;
    } else {
     printf "%-20s"," ";
    }
    my @out=@{$hash{$_}};
    my $j=$i*5;
    my $k=$j+4;
#   print "$time\t$i\t$j\t$k\n";
    my @final=($#out+1-$j >=5) ? (@out[$j..$k]) : (@out[$j..$#out]);
    print "@final\n";
    }
    $flag=1;
    print "\n";

#    print "@out\n";
}

