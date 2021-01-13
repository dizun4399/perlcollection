#!/usr/bin/perl
if (@ARGV == 0) { die "Usage: <input contig size list file>\n";}
($input)=@ARGV;
open I,"$input";
#open O,">0$output";
$length=0;
while (<I>) 
{
	chomp;
	@temp=split ;
	push @array,$temp[1];
	$length=$temp[1]+$length;
}
@array=sort {$a<=>$b} @array;
$n50=0;
foreach $contig (@array) 
{
	$n50=$contig+$n50;
	if ($n50 >= $length/2) 
	{
		print "N50 is: $contig\n";
		exit;
	}
}
close I;
