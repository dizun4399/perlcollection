#!/usr/local/bin/perl -w
#
# Copyright (c) BGI 2005
# Writer:         Liy <liy@genomics.org.cn>
# Program Date:   2005.
# Modifier:       Liudy <liudy@genomics.org.cn>
# Last Modified:  2006-8-15	增加trim载体功能
$ver="2.0";
#use strict;
#use Getopt::Long;
use Data::Dumper;
#########################################################################################
if (@ARGV<2){
	print "Usage: $0(ver$ver) reads.seq output min_length\n";
	exit;
}
open (SEQ,"$ARGV[0]")||die "$ARGV[0] doesn't exists!";
open (QUAL,"$ARGV[0].qual")||die "$ARGV[0].qual doesn't exists!";
open (OUT,">$ARGV[1]");
##########################################
if (exists $ARGV[2]) {
	$len=$ARGV[2];
}
else {$len=100;}

$/=">";
while (<QUAL>) {
	chomp;
	if ($_ ne "") {
		$name=(split(/\s+/,$_))[0];
		$qual=(split(/\n/,$_,2))[1];
		$hash_qual{$name}=$qual;
	}
}
close QUAL;

$ctg_name=0;
while (<SEQ>) {
	chomp;
	if ($_ ne "") {
		$name=(split(/\s+/,$_))[0];
		$info=(split(/\s+/,(split(/\n/,$_,2))[0],2))[1];
		$seq0=(split(/\n/,$_,2))[1];
		$seq=$seq0;
		$seq=~s/\n//g;
		$seq=uc($seq);
		$seq_notrim=$seq;
		$notrim_length=length($seq_notrim);
		$seq=~s/^N+//;
		$seq=~s/N+$//;
		$seq=~s/^X+//;
		$seq=~s/X+$//;
######################
		$trim_length=length($seq);
		$no_head=$seq_notrim;
		$no_head=~s/^X+//;
		$left_X=length($seq_notrim)-length($no_head);
		$left_trim=1+$left_X;
		$left_out=1-$left_X;
		$no_tail=$seq_notrim;
		$no_tail=~s/X+$//;
		$right_X=length($seq_notrim)-length($no_tail);
		$right_trim=$notrim_length-$right_X;
		$seq=~s/(.{50})/$1\n/g;
		$seq=~s/\n$//;
		$qual=$hash_qual{$name};
		@Q=split(/\s+/,$qual);
#		print Dumper @Q;die;
		$trim_qual="";
		$count=0;
		for ($i=$left_trim-1;$i<$right_trim ;$i++) {
			$trim_qual.=" $Q[$i]";
#			print "$Q[$i]\n";
			$count++;
			$trim_qual.="\n" if($count % 50 == 0);
		}
		$trim_qual=~s/\n$//;
######################
		$length=length($seq);
		if($length>=$len){
			$ctg_name++;
			$out="";
			$out.="CO Contig$ctg_name $trim_length 1 1 U\n";
			$out.="$seq\n\n";
			$out.="BQ\n$trim_qual\n\n";
			$out.="AF $name U $left_out\nBS 1 $notrim_length $name\n\n";
			$out.="RD $name $notrim_length 0 0\n$seq0\n";
			$out.="QA $left_trim $right_trim $left_trim $right_trim\nDS $info\n\n";
			push (@output,$out);
		}
	}
}
close SEQ;

print OUT "AS $ctg_name $ctg_name\n\n";
foreach  (@output) {
	print OUT $_;
}
print OUT "\nWA{\nphrap_params phrap 051011:144433\nphrap out.seq -new_ace \nphrap version 0.990329\n}\n\n";
close OUT;
