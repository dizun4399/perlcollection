#!/usr/bin/perl -w
use strict;


my @seq=();
my $part||=50;
chomp (my $num=`grep ">" $ARGV[0] |wc -l`);
my $i=1;
my $j=int ($num/$part);


my $outdir="split";
`mkdir $outdir`;

open IN,"$ARGV[0]";
$/=">";<IN>;

while (<IN>) {
    chomp;
    next if (/^>/);
    my ($id,$seq)=(split /\n/,$_,2)[0,1];
    $seq=~ s/\n//g;
    my $out="$id\n"."$seq";
    push @seq,$out;
}
close IN;
$/="\n";
open SH,">blast.sh";
for (my $i=1;$i<=$part;$i++) {
    open OU,">$outdir/split_$i.fa";
    foreach (0..$j-1) {
        my $out=shift @seq;
        print OU ">$out\n";
    }
        print SH "blastall -i $outdir/split_$i.fa -d $ARGV[1] -o $outdir/split_$i.blast -m 8 -e 1e-5 -p blastn -a 2 -F F;\n";
}


