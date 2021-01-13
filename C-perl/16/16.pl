#!/usr/bin/perl -w

%hash=();

open IN,"<$ARGV[0]";
while (<IN>) {
    chomp;
    @line=split /\s+/,$_;
    $hash{$line[0]}=$line[1];
}
close IN;

chomp ($province=<STDIN>);
if (exists $hash{$province}) {
    print "The captial of $province is :\t";
    print "$hash{$province}\n";
} else {
    print "there is no data in the hash\n";
}
