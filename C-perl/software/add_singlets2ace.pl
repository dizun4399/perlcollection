#!/usr/local/bin/perl -w
#
# Copyright (c) BGI 2005
# Writer:         Liy <liy@genomics.org.cn>
# Program Date:   2005.
# Modifier:       Liy <liy@genomics.org.cn>
# Last Modified:  2005.
$ver="1.0";
#use strict;
#use Getopt::Long;
use Data::Dumper;
#########################################################################################
if (@ARGV<2){
	print "Usage: $0(ver$ver) singlets output min_length\n";
	exit;
}
open (SIN,"$ARGV[0]");
open (OUT,">$ARGV[1]");
#open (LEN,"$ARGV[2]");
##########################################
if (exists $ARGV[2]) {
	$len=$ARGV[2];
}
else {$len=100;}
$/=">";
system ("mkdir singlets_tmp");
while (<SIN>) {
	chomp;
	if ($_ ne "") {
		$info=(split(/\n/,$_,2))[0];
		$name=(split(/\s+/,$info))[4];
		$seq=(split(/\n/,$_,2))[1];
		$seq=~s/\n//g;
		$seq=uc($seq);
		$seq=~s/N//g;
		$seq=~s/X//g;
		$length=length($seq);
		if($length>=$len){
			system ("/disk2/team06/bin/phd2Ace.pl $name");
			$name=~s/.phd.*$//;#print Dumper $name;
			$name=(split(/\//,$name))[-1];
			system ("mv $name.ace singlets_tmp");
			push (@name,"singlets_tmp/$name.ace");
		}
	}
}
$num=@name;
print OUT ("AS $num $num\n");
for($i=0;$i<=@name-1;$i++){
	open (ACE,"$name[$i]");
	$/="AS";
	while (<ACE>) {
		if ($_ ne "AS") {
#			print "AAAAAAAAAAAAA  $_\n";
			@temp=split(/\n/,$_);
			@ctg=split(/\s+/,$temp[2],3);
#			die;
			$j=$i+1;
			$temp[2]="$ctg[0] Contig$j $ctg[2]";
			shift @temp;#print Dumper @temp;
		}
	}
	$t=join ("\n",@temp);
	print OUT ("$t\n");
	close ACE;
}
print OUT "\n\nWA{\nphrap_params phrap 051011:144433\nphrap out.seq -new_ace \nphrap version 0.990329\n}\n\n";
close OUT;

system ("/disk2/team06/bin/change_reads_pathinfo.pl $ARGV[1] $ARGV[1].c");
system ("mv $ARGV[1].c $ARGV[1]");
system ("rm -rf singlets_tmp $ARGV[1].c.log");
