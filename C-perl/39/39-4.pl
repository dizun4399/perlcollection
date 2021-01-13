#!/usr/bin/perl -w
use strict;

my %score=(
        "barney"=>95,
        "fred"=>92,
        "dino"=>67,
        "bamm"=>81,
        "tom"=>95,
        "kate"=>88,
        "bill"=>99,
    );

#foreach (sort {$a cmp $b} keys %score) {
#foreach (sort {$score{$b} <=> $score{$a}} keys %score) {
foreach (sort {$score{$b} <=> $score{$a} or  $a cmp $b} keys %score) {
    print "$_ => $score{$_}\n";
}
