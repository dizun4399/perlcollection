#!/usr/bin/perl -w
use strict;
use Data::Dumper;
use Getopt::Long;
my ($input,$ref,$output,$type,$help,$evalue,$cpu,$mask,$out_type,);

GetOptions(
        "i:s"=>\$input,
        "o:i"=>\$output,
        "d:s"=>\$ref,
        "e:i"=>\$evalue,
        "p:s"=>\$type,
        "m:i"=>\$out_type,
        "F:s"=>\$mask,
        "a:i"=>\$cpu,
        "h:s"=>\$help,
        );

&usage if (!$input or $help);


sub usage {
    print  "\e[;38;1m\n","perl $0 -i scripts.sh -l 1 -t 1 -o outdir \n","\e[;38;1m\n";
    die "Detail Options
        This program is used to cut do multiple blast 
        -i  input the sequence
        -o  outputfile
        -d  reference
        [Optional]
        -e  e-value [1e-5]
        -m  blast output type [8]
        -a  cpu number [a]
        -p  blast alignment type [blastn]
        -h  print help information
        \n";
}


