#!/usr/local/bin/perl -w
# 
# Copyright (c) BGI 2003
# Author:         Liudy <liudy@genomics.org.cn>
# Program Date:   2003.08.
# Modifier:       Liudy <liudy@genomics.org.cn>
# Last Modified:  2003.08.
# 

use strict;
use Getopt::Long;
#use Data::Dumper;

#########################################################################################
my %opts;

GetOptions(\%opts,"i=s","o=s","h" );

#&help()if(defined $opts{h});
if(!defined($opts{i})){
	print <<"	Usage End.";
	Description:

		

	Usage:

		-i    infile     must be given

		-o    outfile    must be given

		-h    Help document

	Usage End.

	exit;
}

my $in=$opts{i};
my $out=$opts{o};

################Define main variables here:
my $reads='';
my %hash_reads=();
my @temp=();
my $x='';
my $key='';
my $value='';
################
open (IN,"$in")||die"Can't open $in\n";
open (OUT,">$out");

$/=">";
while (<IN>) {
	chomp;
	if ($_ ne "") {
		$reads=(split(/\n/,$_,2))[1];
		$reads=~s/\n//g;
		@temp=split(/[ATCGatcgxX]+/,$reads);
		foreach $x (@temp) {
			if ($x ne "") {
				if (defined $hash_reads{length($x)}) {
					$hash_reads{length($x)}++;
				}
				else {
					$hash_reads{length($x)}=1;
				}
			}
		}
	}
}
close IN;
while (($key,$value)=each %hash_reads) {
	print OUT "$key\t$value\n";
}
close OUT;