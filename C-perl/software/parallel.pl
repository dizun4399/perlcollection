#!/usr/bin/perl -w
use strict;
use Data::Dumper;
use Getopt::Long;
my ($input,$line,$prefix,$time,$help);
GetOptions(
        "i:s"=>\$input,
        "l:i"=>\$line,
        "t:i"=>\$time,
        "p:s"=>\$prefix,
        "h:s"=>\$help,
        );

&usage if (!$input or $help);
$prefix||="work0000";
chomp (my $pwd=`pwd`);
#$prefix||="work";
$line||=1;
$time||=1;
my $j=1;
my $k=0;
my $all=$line*$time;
my $outdir="$pwd/$input\_$$.multi";
system "mkdir $pwd/$input\_$$.multi";# unless -d "$pwd/$outdir";
open IN,"<$input";
#open OU,">$input\_$$.all.sh";
while (<IN>) {
    chomp;
    if ($k >= $all) {
        $j++;
        $k=1;
    } else {
       $k++;
    }
#    print "$k\n";
    open FI,">>$outdir/$prefix$j.sh";
    print FI "$_\n";
    close FI;
#    print OU "sh $outdir/$prefix$j.sh\n";
}
close IN;

`ls -1 $outdir/$prefix*.sh |awk '{ print "sh "\$1 " &"}' >$input\_$$.all.sh` unless (!$input or $help);
sub usage {
    print  "\e[;32;1m\n","perl $0 -i scripts.sh -l 1 -t 1 -o outdir \n","\e[;32;1m\n";
    die "Detail Options
        This program is used to cut scrips.sh
         -i  input the scripts
         -l  the line to seperate
         -t  cut times
         -p  prefix
         -h  print help information

    CopyRight by WangTong 2014
         \n";
}




