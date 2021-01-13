#!/usr/bin/perl  -w
use strict;
use Text::Wrap qw(wrap $columns $huge);

die "perl $0 <input cds file> <output pep file> <translation table No(1 or 11)>\n" unless (@ARGV==3);

my $in_path = shift @ARGV;
my $out_path = shift @ARGV;
my $transl_table = shift @ARGV;

open IN,"$in_path" or die "Cannot open input file: $!";
open OUT,">$out_path" or die "Cannot open output file: $!";

my ($i,$j,$k);
my ($in,$seq,$out);
my ($aas,$starts,$base1,$base2,$base3);
my $temp;
my $flag=0;
my @mod;
my (%hash,%hashStarts);

if($transl_table == 1)
{
	$aas    = "FFLLSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG";
	$starts = "---M---------------M---------------M----------------------------";
	$base1  = "TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG";
	$base2  = "TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG";
	$base3  = "TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG";
}
elsif($transl_table == 11)
{
	$aas    = "FFLLSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG";
	$starts = "---M---------------M------------MMMM---------------M------------";
	$base1  = "TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG";
	$base2  = "TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG";
	$base3  = "TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG";
};

foreach $i (1..(length $aas)) 
{
	$temp =substr($base1,($i-1),1);
	$temp.=substr($base2,($i-1),1);
	$temp.=substr($base3,($i-1),1);
	$hash{$temp}=substr($aas,($i-1),1);
}

foreach $i (1..(length $starts)) 
{
    if(substr($starts,($i-1),1) eq "M")
    {
	$temp =substr($base1,($i-1),1);
	$temp.=substr($base2,($i-1),1);
	$temp.=substr($base3,($i-1),1);
	$hashStarts{$temp}=substr($starts,($i-1),1);
    }
};

$/ = ">";
<IN>;
while(my $line = <IN>){	
    chomp $line;
    my @a = split(/\n/,$line);
    my $head = shift @a;
    print OUT ">$head\n";
    my $seq = join "",@a;

    if($head =~ /Lack\s*5\'\-end/ || $head =~ /Lack\s*both\s*end/){
	for($i=0;$i<length($seq);$i+=3)	{
	    if(exists $hash{substr($seq,$i,3)}){
		$out.=$hash{substr($seq,$i,3)};
	    }else{
		$out.="X";
	    }
	}
    }else{
	if(exists $hashStarts{substr($seq,0,3)}){
	    $out.=$hashStarts{substr($seq,0,3)};
	    for($i=3;$i<length($seq);$i+=3){
		if(exists $hash{substr($seq,$i,3)}){
		    $out.=$hash{substr($seq,$i,3)};
		}else{
		    $out.="X";
		}
	    }			
	}else{
	    for($i=0;$i<length($seq);$i+=3){
		if(exists $hash{substr($seq,$i,3)}){
		    $out.=$hash{substr($seq,$i,3)};
		}else{
		    $out.="X";
		}
	    }
	}

    };
    my @b = split(//,$out);
    if($b[-1] eq "*"){
	pop @b;
    };
    $out = join "",@b;
    $columns = 51;
    print OUT wrap('','', $out),"\n";
    $out = "";
}
