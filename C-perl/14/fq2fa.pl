#!/usr/bin/perl -w

open IN,"zcat  test.fq.gz |";
#open OU,">test.fa";

while ($id=<IN>) {
    chomp ($id);
    chomp ($seq=<IN>);
    <IN>;
    <IN>;
    $id=~ tr /@/>/;
    print "$id\n";
    print "$seq\n";
}
close IN;
