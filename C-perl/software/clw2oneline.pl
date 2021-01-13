#!/usr/bin/perl -w
use strict;
use Data::Dumper;

if (@ARGV!=1) {
    die "\tThis program is used to merge muscle result
         Usage:perl $0 <muscle.clw>\n";

}

my %hash=();
open IN,"<$ARGV[0]",or die "can not open file :$!\n";
while (<IN>) {
    chomp;
    next if (/^\s+/ or /^MUSCLE/);
    my @line = (split /\s+/,$_)[0,1];
    next if (@line!=2);
#        print "$line[0]\n";
    $hash{$line[0]}.=$line[1] #if (exists $hash{$line[0]});
}
close IN;
#print Dumper (\%hash);    
foreach (keys %hash) {
    my $seq=$hash{$_};
    printf "%-20s\t","$_";
    print "$seq\n";
}

