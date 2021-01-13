#!/usr/bin/perl -w
use strict;
use Data::Dumper;
use Getopt::Long;

if (scalar @ARGV==0) {
    die "This program is used to sort a matrix by its cow and low
        perl $0 -l <list file> <a.matrix>
        perl $0 -c <row  file> <a.matrix>\n";
}

my ($cow,$low);
GetOptions(
        "l:s"=>\$low,
        "c:s"=>\$cow,
        );

my $file="";
if (defined $low) {
    $file=$low;
} else {
    $file=$cow;
}
my @sort=();
open FI,"$file";
while (<FI>) {
    chomp;
    push @sort,$_;
}
close FI;
my %hash=();
my %table=();
my @lie=();
my @gene=();
open IN,"<$ARGV[0]";
my $temp=<IN>;
my @hang=split /\s+/,$temp;
shift @hang;
#die @name;
while (<IN>) {
    my @line=split /\s+/,$_;
    my $id=shift @line;
    $table{$id}=$_;
    push @lie,$id;
    foreach (0..$#line) {
        my $sample=$hang[$_];
        $hash{$id}{$sample}=[] if (exists $hash{$id}{$sample});
        push @{$hash{$id}{$sample}},"$line[$_]";
    }
}
close IN;
#print Dumper (\%hash);
#print "@hang\n";
if (defined $cow) {
   print "\t",join "\t",@hang,"\n";
    foreach my $sample (@sort) {
        if (exists $table{$sample}) {
            my @out=$table{$sample};
            print "$_\t" for (@out);
        } else {
            next;
        }
    }
} else {
    print "\t",join "\t",@sort,"\n";
    foreach my $sample (@lie) {
       print "$sample\t";
        foreach my $gene_id (@sort) {
            if (exists $hash{$sample}{$gene_id}) {
            my @out=@{$hash{$sample}{$gene_id}};
#            print @out;
           print "$_\t" for @out;
            } else {
                next;
            }
        }
       print "\n";
    }
}



