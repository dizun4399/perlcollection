#!/usr/bin/perl -w
use strict;
use Data::Dumper;

&usage && exit if (@ARGV==0);

my %axt=();
my %indel=();

open IN,"<$ARGV[0]";
my ($ref_file,$qry_file)=(split /\s+/,<IN>)[0,1];
my %ref=&seq_hash ($ref_file);
my %qry=&seq_hash ($qry_file);
<IN>;$/=">";<IN>;  #NUCMER >

my $i=-1;
while (<IN>) {
    chomp;
    my @line=split /\n/,$_;
    my ($rid,$qid)=(split /\s+/,shift @line)[0,1];
    my $r_seq=$ref{$rid} if exists $ref{$rid};
    my $q_seq=$qry{$qid} if exists $qry{$qid};

    foreach (@line) {
        my @num=split /\s+/,$_;
        if (@num==7) {
            $i++;
            my $r_out=&seq_str ($r_seq,$num[0],$num[1]);
            my $q_out;
            my $flag;
            if ($num[2] <$num[3]) {
                $flag="+";
                $q_out=&seq_str ($q_seq,$num[2],$num[3]);
            } else {
                $flag="-";
                $q_out=reverse (&seq_str ($q_seq,$num[3],$num[2]));
                $q_out=~ tr/ATCG/TAGC/;
            } 
            my $temp= ($num[2]<$num[3]) ? ("$i $rid $num[0] $num[1] $qid $num[2] $num[3] $flag 0\n$r_out\n$q_out\n") : ("$i $rid $num[0] $num[1] $qid $num[3] $num[2] $flag 0\n$r_out\n$q_out\n");
            $axt{$i}=$temp;
        } else {
            $indel{$i}=[] unless exists $indel{$i};
            push @{$indel{$i}},$_;
        }
    }
}
close IN;
$/="\n";

my %var=();
foreach (sort {$a<=>$b} keys %indel) {
    my @axtlist=split /\n/,$axt{$_};
    my $loci = 0;
    foreach(@{$indel{$_}}){
        $_ || next;
        $loci += abs ($_);
        if ($_>0) {
            substr($axtlist[2],$loci-1,0) = "-";
        } else {
            substr($axtlist[1],$loci-1,0) = "-";
        }
    }
    $var{$_}=join "\n",@axtlist;
#    print join "\n",@axtlist,"\n";
}

print "#Genome Variation Text format
#Vesion 1.0
#1:ID Ref_ID Ref_Start-Ref_End Query_ID Query_Start-Query_End Strand\tSNP_Number InDel_Number
#2:Reference Sequence
#3:Query Sequence
#4: '*' indicate a SNP and  '-' indicate a GAP
#Contact genomics\@outlook.com
#CopyRight 2012\n\n\n\n";

foreach (sort {$a<=>$b} keys %var) {
    my ($id,$refseq,$qryseq)=(split /\n/,$var{$_})[0,1,2];
    my ($no,$ref_id,$r_up,$r_down,$qry_id,$q_up,$q_down,$direct,)=(split /\s+/,$id)[0,1,2,3,4,5,6,7,];

    my @ref=split //,$refseq;
    my @qry=split //,$qryseq;
    my $block;
    foreach (0..$#ref) {
        $block.=" "  if ($ref[$_] eq $qry[$_]);                             #SAME NONO SNP
        $block.="N"  if ($ref[$_] eq "N" || $qry[$_] eq "N");               #Filter N BASE
        $block.="-"  if ($ref[$_] eq "-" || $qry[$_] eq "-");       #Filter Indel
        $block.="*"  if (($ref[$_] ne $qry[$_] && $ref[$_]=~ /[ATCG]+/ && $qry[$_]=~ /[ATCG]+/));  # A CANDIDATE SNP
#            my $r_locus=$r_up+$_;
#            my $q_locus=$q_up+$_;
#            my $temp=$direct=~ /\+/ ? "1\t1":"1\t-1";
#            print "$r_locus\t$ref[$_]\t$qry[$_]\t$q_locus\t$q_up\t$q_down\t$temp\t$ref_id\t$qry_id\n";
#            print "$ref_id\tSNP\t$direct\t$r_locus\t$ref[$_]\t$qry[$_]\t$qry_id\t$q_locus\n";
#            }
    }
my @snp_num= ($block=~  /(\*+)/g);
my @indel_num=($block=~ /(-+)/g);
my $indelNO=@indel_num;
my $snpNO=@snp_num;
my $out=($snpNO==0 && $indelNO==0 ) ? ("0 0") :("$snpNO $indelNO");
print "$no $ref_id $r_up-$r_down $qry_id $q_up-$q_down $direct\t$out\n";
print "$refseq\n$qryseq\n$block\n";
}


sub seq_str {
    my ($seq,$up,$down)=@_;
    my $out=substr ($seq,$up-1,$down-$up+1);
    return $out;
}

sub seq_hash {
    my %hash=();
    my $file=shift;
    open FI,"<$file";
    my $id;
    while (<FI>) {
        chomp;
        if (/^>(\S+)/) {
            $id=$1;
        } else {
            s/\s+//g;
            $hash{$id}.=$_;
        }
    }
    close FI;
    return %hash;
}

sub usage {
    print "Usage:This program is used to parser Nucmer delta output into \"Genome Variation Text\" format
        perl $0 <*.delta> default output STDOUT
        Copy Right \@wangtong 2012\n";
}

