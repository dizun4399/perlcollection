#!/usr/bin/perl -w
use strict;


open IN,"<$ARGV[0]";
#$/="BLASTP 2.2.23 [Feb-03-2010]";
my $fline = <IN>;
$/= ($fline =~ /BLASTP/) ? "BLASTP" : "BLASTX";

while (<IN>) {
    chomp;
    next if (/\* No hits found \*/m);
    my @line=split />/,$_;
    my ($pointer,$query,$query_len,$subject,$subject_len,);
    if ((shift @line)=~ /Query=\s*(\S+)\s+(.*?)\(([\d\,\.]+)\s+letters\)/s) {
        $query=$1;
        $query_len=$3;
        $query_len =~ s/,//g;  
    }
    foreach (@line) {
        next if (/^\s+$/);
        s/Score/#\nScore/;
        if (/(\S+)\s+(.*?)Length = ([\d\,\.]+)/s) {
            $subject=$1;
            $subject_len=$3;
        }
        my @info=split /#/,$_;
        foreach (@info) {
            my @temp=split /\n/,$_;
        my $q_start=0;
        my $q_end=0;
        my $r_start=0;
        my $r_end=0;
        my ($qseq,$rseq,$align,$sub_len);
        my $is_query = 0;
        my ($score,$expect)=(/Score\s*=\s*([\d\.\,]+)\s*bits\s*\(\d+\)\,\s*Expect\s*=\s*(\d+e-\d+)\.*/s) ? ($1,$2) :next;
#Identities = 59/171 (34%), Positives = 91/171 (53%), Gaps = 16/171 (9%)
        my ($temp,$align_len,$identy)=(/Identities\s*=\s*([\d\,\.]+)\/([\d\,\.]+)\s*\((\S+)\%\).*/s) ? ($1,$2,$3) :next;
        my $miss=$align_len-$temp;
        my $identity=sprintf "%0.2f",($temp/$align_len)*100;
        my $gap=(/Identities.*,\s*Gaps\s*=\s*(\d+)\/\d+\s*\(\S+%\)/)? $1: 0;
#        print "$gap\n";
#        print "$align_len\t$identy\n";
        my $blank_len;
        foreach (@temp) {
            if (/Query:\s+(\d+)\s+(\S+)\s+(\d+)/) {
                $is_query = 1;
                $q_start= ($1>$q_start && $q_start !=0) ? $q_start :$1;
                $sub_len = length $2;
                $qseq.=$2;
                $q_end=($3<$q_end && $q_end !=0) ? $q_end :$3;
                /(Query:\s+\d+\s+)\S+/;
                $blank_len = length $1;
            }elsif (/Sbjct:\s+(\d+)\s+(\S+)\s+(\d+)/) {
                $is_query = 0;
                $r_start= ($1>$r_start && $r_start !=0) ? $r_start :$1;
                $rseq.=$2;
                $r_end=($3<$r_end && $r_end !=0) ? $r_end :$3;
            } elsif($is_query) {
                if(/\S/){
                    chomp;
                    substr($_,0,$blank_len) = "";
                    $align .= $_;
                }else{
                    $align .= " " x $sub_len;
                }
                $is_query = 0;
        } else {
            next;
        }
    }
        $qseq || next;
#            print ">$query $query_len $subject $subject_len\tIdentity=$identity\tAlign_Length=$align_len\tMismatches=$miss\tGaps=$gap\t";
#            print "$q_start-$q_end $r_start-$r_end\tE-value=$expect\tScore=$score\n"; 
            print ">$query\t$query_len\t$subject\t$subject_len\t$identity\t$align_len\t$miss\t$gap\t";
            print "$q_start\t$q_end\t$r_start\t$r_end\t$expect\t$score\n"; 
            print "$qseq\n$align\n$rseq\n\n";
    }
#   print "$query,$query_len,$subject,$subject_len\n";
    }
}
close IN;
