#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use Pod::Text;

my ($ref,$query,$blast,$identy,$length,$type,$output,$form,$itself,$help,);
GetOptions(
        "r:s"=>\$ref,
        "q:s"=>\$query,
        "i:s"=>\$blast,
        "d:f"=>\$identy,
        "l:i"=>\$length,
        "t:s"=>\$type,
        "f:s"=>\$form,
        "s:i"=>\$itself,
        "o:s"=>\$output,
        "help:s"=>\$help
        );
die `pod2text $0` if ($help || !defined($blast));
#================================================================
$type||="ref";
$form||="blastn";
$itself||=0;
$identy||=0;
$length||=0;

my %hash=();
open BL,"<$blast";
while (<BL>) {
    chomp;
    my @line=split /\s+/,$_;
    next if (($line[0] eq $line[1]) && $itself==1);
    next unless ($line[2] >$identy && $line[3] > $length);
    if ($type eq "ref") {
        my @locus=sort {$a<=>$b} ($line[8],$line[9]);
        $hash{$line[1]}{$line[0]}=[] unless exists $hash{$line[1]}{$line[0]};
        push @{$hash{$line[1]}{$line[0]}},\@locus;
    } 
    if ($type eq "query") {
        my @locus=sort {$a<=>$b} ($line[6],$line[7]);
        $hash{$line[0]}{$line[1]}=[] unless exists $hash{$line[0]}{$line[1]};
        push @{$hash{$line[0]}{$line[1]}},\@locus;
    }
}
close BL;

my %result=&sort_locus (%hash);
my (%ref,%query);
if ($type eq "ref") {
    %ref=&len ($ref);
    %query=&len ($query);
} elsif ( $type eq "query" ) {
    %ref=&len ($query);
    %query=&len ($ref);
}
$/="\n";

open OU,">$output";
foreach (keys %ref) {
    my $r_len=$ref{$_};
    if (exists $result{$_}) {
        my @out=@{$result{$_}};
        my ($id,$len)=(split / /,$out[0])[0,1];
        my $q_len=$query{$id};
        my $q_cov=sprintf ("%0.2f",$len/$q_len*100);
        my $r_cov=sprintf ("%0.2f",$len/$r_len*100);
        $q_cov=100 if ($q_cov >=100.00);
        $r_cov=100 if ($r_cov >=100.00);
        print OU "$_\t$r_cov\t$q_cov\t$len\t$r_len\t$q_len\t";
        print OU join "\t",@out,"\n";
    } else {
        print OU "$_\t0\t0\n";
    }
}

sub sort_locus {
    my %final=();
    my (%hash,)=@_;
    foreach my $first (keys %hash) {
        my %tmp=();
        my @array=();
        foreach my $second(keys %{$hash{$first}}) {
            my @out=sort {$a->[0]<=>$b->[0]} @{$hash{$first}{$second}};
            my ($up,$down)=(0,0);
            my $total=0;
            foreach (@out) {
                my ($left,$right)=@{$_};
                if ( $left >$down) {                                      #1) first situation outside
                    $total+=$right-$left+1;
                    $up=$left;
                    $down=$right;
                } elsif ( $left<=$down && $right>$down) {                 #2) second situation overlap
                    $total+=$right-$down;
                    $down=$right;
                } elsif ( $left<$down && $right <=$down) {                #3) third situation   include
                    next;
                }
            }
            $tmp{$second}=$total;
        }
        foreach (sort {$tmp{$b}<=>$tmp{$a}} keys %tmp) {
            push @array,join " ",($_,$tmp{$_});
        }
        $final{$first}=\@array;
    }
    return %final;
}

sub len {
    my ($input)=@_;
    open IN,"<$input";
    $/=">";<IN>;
    my %sep=();
    while (<IN>) {
        chomp;
        my @line=split /\n/,$_;
        my $id=(split /\s+/,(shift @line))[0];
        my $seq=join "",@line;
        my $num;
        if ($form eq "blastn") {
            $num=($seq=~ s/N/N/gi);
        } else {
            $num=($seq=~ s/X/X/gi);
        }
        my $len=length ($seq);
        my $real_len=$len-$num;
        $sep{$id}=$real_len;
    }
    return %sep;
    close IN;
}


=head1 Program: blast_stat.pl 

=head1 Description: This program is the core "algorithm" of blast_stat.pl

=head1

Usage: perl algorithm.pl [options]

Options:
-r    <str>   input  the reference gene file 
-q    <str>   input  the query gene file 
-i    <str>   input  the blast result
-t    <str>   type "ref" or "query" ["ref"]
-d    <flo>   filter blast by identy [0]
-l    <int>   tilter blast by length [0]
-f    <str>   blast format "blastn" or "blastp" [blastn]
-s    <int>   if filter itself [0]
-o    <str>   output table file
-help <str>   pod this help
=cut



