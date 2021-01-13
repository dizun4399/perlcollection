#!/usr/bin/perl -w
use strict;
if (@ARGV== 0) {
    die "perl $0 SEQ ID UP DOWN \n";
}
my %hash=();
my $flag=$ARGV[4]||= "0";
open IN,"$ARGV[0]";
$/=">";<IN>;
while (<IN>) {
    chomp;
    my ($temp,$seq) = (split /\n/,$_,2)[0,1];
#    die "$seq\n"
    my $id=(split /\s+/,$temp)[0];
    $seq =~ s/\n//g;
    $hash{$id}=$seq;
}
close IN;
$/="\n";

my $fa=$hash{$ARGV[1]};
my $length=abs ($ARGV[3]-$ARGV[2])+1;
my $out=substr ($fa,$ARGV[2]-1,$length);
if ($flag!=0) {
    my $temp=reverse $out;
     $temp=~ tr/ATCGatcg/TAGCtagc/;
    print "$temp\n";
} else {
    print "$out\n";
}

