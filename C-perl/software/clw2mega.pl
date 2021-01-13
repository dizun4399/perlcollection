#!/usr/bin/perl -w
use strict;
use Data::Dumper;

if (@ARGV!=1) {
    die "\tThis program is used to merge muscle result
         Usage:perl $0 <muscle.clw>\n";

}

print "#mega
!Title A 896 bp segment of mtDNA for five primates from Brown et al. (1982);
!Format 
DataType=Nucleotide
NTaxa=4 NSites=896
Identical=. Missing=? Indel=-;
\n";

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
