#!/usr/bin/perl -w
use strict;
use Data::Dumper;
use Getopt::Long;
my ($fna,$output,$pe,$se,$forhead,$back,$all,$help,$qulity,$sam,);
GetOptions(
        "i:s"=>\$fna,
        "o:s"=>\$output,
        "p:s"=>\$pe,
        "s:s"=>\$se,
        "q:i"=>\$qulity,
        "b:i"=>\$back,
        "f:i"=>\$forhead,
        "m:s"=>\$sam,
        "a:s"=>\$all,
        "h:s"=>\$help,
        );

&usage if (!$fna or $help);

my %hash=();
$qulity ||=20; 
$forhead||=0;
$back||=0;
open IN,"<$fna";
$/=">";<IN>;
while (<IN>) {
    chomp;
    my ($id,$seq)=(split /\n/,$_,2)[0,1];
    $seq =~ s/\n//g;
    my $len=length $seq;
    for (1..$len) {
        my $out=substr ($seq,$_-1,1);
        $hash{$id}{$_}="$out"."\t";
    }
}
close IN;
$/="\n";
#print Dumper (\%hash);
if (defined $pe) {
open FI,"<$pe";
while (<FI>) {
    chomp;
    my @line=split /\s+/,$_;
    my @base=split //,$line[1];
    my @qual=split //,$line[2];
    my $len=length ($line[1])-$forhead-$back;
    for (0..$len-1) {
        my $locus=$line[8]+$forhead+$_;
        my $ascii=(ord $qual[$_+$forhead])-64;
        my $add=$base[$_+$forhead];
        $hash{$line[7]}{$locus}.= $add if ($ascii >$qulity);
    }
}
close FI;
}

if (defined $se) {
    open SE,"<$se";
    while (<SE>) {
        chomp;
        my @line=split /\s+/,$_;
        my @base=split //,$line[1];
        my @qual=split //,$line[2];
        my $len=length ($line[1])-$forhead-$back;
        for (0..$len-1) {
            my $locus=$line[8]+$forhead+$_;
            my $ascii=(ord $qual[$_+$forhead])-64;
            my $add=$base[$_+$forhead];
            $hash{$line[7]}{$locus}.= $add if ($ascii >$qulity);
        }
    }
    close SE;
}

if (defined $sam) {
    my $flag=(-B $sam) ? "1" : "0";
    open SAM,"<$sam" if ($flag ==0);
    open SAM,"samtools view $sam |" if ($flag==1) ;
    while (<SAM>) {
        chomp;
#        die "$_\n";
        my @line=split /\s+/,$_;
        my @base=split //,$line[9];
        my @qual=split //,$line[10];
        my $len=length ($line[9])-$forhead-$back;
        for (0..$len-1) {
        my $locus=$line[3]+$forhead+$_;
        my $ascii=(ord $qual[$_+$forhead])-64;
        my $add=$base[$_+$forhead];
        $hash{$line[2]}{$locus}.= $add if ($ascii >$qulity);
        }
    }
close SAM;
}

open OU,">$output";
print OU "ID\tLOCUS\tBASE\tA\tC\tG\tT\n";
foreach my $id (sort keys %hash) {
    foreach my $locus (sort {$a<=>$b} keys %{$hash{$id}}) {
        my $seq=$hash{$id}{$locus};
        my $qes=reverse $seq;
        my $first=chop $qes;
        my $other=reverse $qes;
        my @temp=sort (split //,$other);
        my $final=join "",@temp;
        my $A+=($other=~ s/A/A/gi);
        my $T+=($other=~ s/T/T/gi);
        my $C+=($other=~ s/C/C/gi);
        my $G+=($other=~ s/G/G/gi);
        print OU "$id\t$locus\t$first\t$A\t$C\t$G\t$T\t";
        if (defined $all) {
            print OU "$final\n";
        } else {
            print OU "\n";
        }
    }
}


sub usage {
    print  "\e[;32;1m\n","perl $0 -i fasta -p PE.out -s SE.out -q 20 -o output\n","\e[;32;1m\n";
    die "Detail Options
        This program is used to trans soap or bwa file to human reading
         -i  input fasta sequence
         -p  SOAP pair-end output
         -s  SOAP sinlge output
         -m  BWA sam or bam file
         -q  qulity cut off [Q20]
         -o  output file
         -f  cut reads forhead [0]
         -b  cut reads back [0]
         -a  print detail file

    CopyRight by WangTong 2014
         \n";
}




