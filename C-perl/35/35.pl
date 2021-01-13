#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use Pod::Text;

my ($libfile,$soft,$cov,$identy,$length,$e_value,$ratio,$help,$Sub_name,);
GetOptions( 
        "lib:s"=>\$libfile,
        "c:i"=>\$cov,
        "e:s"=>\$e_value,
        "s:s"=>\$soft,
        "r:f"=>\$ratio,
        "d:f"=>\$identy,
        "l:i"=>\$length,
#        "a:i"=>\$core,
        "P:s"=>\$Sub_name,
        "help:s"=>\$help,

        );
die `pod2text $0` if ($help || !$libfile ||!$cov ||$e_value);
#&usage if ($help || !$libfile ||!$cov ||$e_value);

#====================================================================================

=head1 Name: real_CorePanGene.pl 

=head1 Desciption: This program is used to get CorePanGenes Sets

=head2 
    Usage:perl real_CorePanGeme.pl <options>
    Version 1.10 Feb 02,2012
    Version 1.20 Mar 12,2012
    Version 2.00 Apr 12,2012 Beta

        Options:
        -lib    <str> Input the lib file "name=file path";
        -s      <str> Blastn or blastp [blastn] 
        -c      <int> Estimate homology by coverage [50]
        *This is the most important parameter*
        -r      <flo> Filter Gene with N or X more than this ratio [0.3]
        -e      <str> Blast e-value [1e-5]
        -d      <flo> Filter blast result by identy [0]
        -l      <int> Filter blast result by length [0]
        -P      <str> Sub Project name
        -help   <str> Pod this help
        eg:perl real_CorePanGene.pl -lib all_gene.list -s blastp -e 1e-5 -r 0.3
=cut

sub usage {
    die "
        Usage:perl real_CorePanGeme.pl <options>
        Version 1.10 Feb 02,2012
        Version 1.20 Mar 12,2012
        Version 2.00 Apr 12,2012 Beta

        Options:
        -lib    <str> Input the lib file \"name=file path\";
    -s      <str> Blastn or blastp [blastn] 
        -c      <int> Estimate homology by coverage [50]
        *This is the most important parameter*
        -r      <flo> Filter Gene with N or X more than this ratio [0.3]
        -e      <str> Blast e-value [1e-5]
        -d      <flo> Filter blast result by identy [0]
        -l      <int> Filter blast result by length [0]
        -P      <str> Sub Project name
        -help   <str> Pod this help
        eg:perl real_CorePanGene.pl -lib all_gene.list -s blastp -e 1e-5 -r 0.3\n";
}
