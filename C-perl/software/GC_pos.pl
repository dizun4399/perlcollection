#!/usr/local/bin/perl -w
# 
# Copyright (c) BGI 2003
# Author:         Liudy <liudy@genomics.org.cn>
# Program Date:   2004.01.
# Modifier:       Liudy <liudy@genomics.org.cn>
# Last Modified:  2004.01.
# Version:        1.0


#use strict;
#use Getopt::Long;
#use Data::Dumper;
#########################################################################################
if (@ARGV!=3){
	print "To plot GC content and make a GC list\n";
	print "Usage: program Seq Window Slide\n";
	exit;
}
open (IN,"$ARGV[0]")||die"Can't open $ARGV[0]\n";
$Note=$ARGV[0];
$win=$ARGV[1];
$slide=$ARGV[2];
open (LST,">$ARGV[0].$win\_$slide.list");
open (XLS,">$ARGV[0].$win\_$slide.xls");
#########################################################################################
$/=">";
$GC_seq="";
$start=1;
while (<IN>) {
	chomp;
	if ($_ ne "") {
		$seq=(split(/\n/,$_,2))[1];
		$seq=~s/\n//g;
		$seq=uc($seq);
		$GC_seq.=$seq;
	}
}
close IN;

$x_length=length($GC_seq);
($x_end,$x_step) = &define_axis($x_length);
&put_maphead;
print XLS "START\tEND\tGC%\n";

while (length($GC_seq)>=$win) {
	$string=substr($GC_seq,0,$win);
	$string=~s/A//g;
	$string=~s/T//g;
	$GC=length($string);
	$GC_ratio=$GC/$win*100;
	$GC_seq=substr($GC_seq,$slide,);
	$end=$start+$win-1;
	print LST "$start:$GC_ratio\n";
	print XLS "$start\t$end\t$GC_ratio\n";
	$start+=$slide;
}
if (length($GC_seq)>=$win/2) {
	$string=$GC_seq;
	$string=~s/A//g;
	$string=~s/T//g;
	$GC=length($string);
	$GC_ratio=$GC/length($GC_seq)*100;
	$end=$start+length($GC_seq)-1;
	print LST "$start:$GC_ratio\n";
	print XLS "$start\t$end\t$GC_ratio\n";
}
close LST;
close XLS;
system ("distributing_svg.pl $ARGV[0].$win\_$slide.list $ARGV[0].$win\_$slide.list.svg");
system ("distributing_svg.pl $ARGV[0].$win\_$slide.list $ARGV[0].$win\_$slide.list.p.svg -p");


sub put_maphead{
print LST <<"map";
Type:Point
PointSize:1
Width:600
Height:450
WholeScale:0.85
X:Position, M
Y:GC, %
XStart:0
YStart:0
XEnd:$x_end
YEnd:100
XStep:$x_step
YStep:25
Xdiv:1000000
Note:$Note

Color:Blue
Mark:
map
}


sub define_axis () {
	my $i=0;
	my ($max)=@_;
	my $time=1;
	my @ret=();
	my @limit=(1,2,3,4,5,6,8,10,12,15,16,20,24,25,30,40,50,60,80,100,120);
	my @unlim=(0,1,2,3,4,5,6,8 ,10,11,14,15,18.5,21,23,29,37,47,56,76 ,92 ,110);

	while ($max >$unlim[21]) {
		$max=$max/10;
		$time=$time*10;
	}
	for ($i=0;$i<=20 ;$i++) {
		if ($max>$unlim[$i] && $max<=$unlim[$i+1]) {
			$ret[0]=$limit[$i]*$time;
			
			if ($i==2 || $i==5 || $i==9 || $i==14) {
				$ret[1]=$ret[0]/3;
			}
			elsif ($i==4 || $i==7 || $i==13 || $i==16){
				$ret[1]=$ret[0]/5;
			}
			else {
				$ret[1]=$ret[0]/4;
			}

		}
	}
	return @ret;
}
