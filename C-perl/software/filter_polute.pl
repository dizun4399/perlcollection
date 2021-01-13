#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use Data::Dumper;

my ($reads1,$reads2,$pe,$se,$help,);
GetOptions (
        "1:s"=>\$reads1,
        "2:s"=>\$reads2,
        "p:s"=>\$pe,
        "s:s"=>\$se,
        "h:s"=>\$help,
        );

&usage && exit if ($help || !defined ($reads1 || $reads2));
sub get_readlist {
    my %table=();
    my $file=shift @_;
    open LI,"<$file";
    while (<LI>) {
        chomp;
        my @line=split /\s+/,$_;
        $table{$line[0]}+=1 unless (exists $table{$_});
    }
    return %table;
}
my %list=();
%list = &get_readlist ($pe) if (defined $pe);
%list = &get_readlist ($se) if (defined $se);

#print Dumper (\%list);

open FQ1,"$reads1";
open FQ2,"$reads2";
open OT1,">$reads1.filter.fq";
open OT2,">$reads2.filter.fq";
while (<FQ1>) {
    chomp;
    chomp (my $seq1=<FQ1>);
    chomp (my $plus1=<FQ1>);
    chomp (my $qual1=<FQ1>);
    chomp (my $rd2=<FQ1>);
    chomp (my $seq2=<FQ1>);
    chomp (my $plus2=<FQ1>);
    chomp (my $qual2=<FQ1>);
    s/^@//;
    my $id=(split /\s+/,$_)[0];
    if (exists $list{$id}) {
        next;
    } else {
        print OT1 "\@$_\n$seq1\n$plus1\n$qual1\n";
        print OT2 "$rd2\n$seq2\n$plus2\n$qual2\n";
    }
}
close FQ1;
close FQ2;
close OT1;
close OT2;

sub usage {
        print "Usage:This program is used to filter Polute reads by SOAP result
                    perl $0 
                    -p SOAP PE file
                    -s SOPA SE file
                    -1 reads1
                    -2 reads2
                    -h help
                    Copy Right \@wangtong 2014\n";
}
