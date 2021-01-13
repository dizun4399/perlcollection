#!/usr/local/bin/perl -w
# 
# Copyright (c) BGI 2005
# Writer:         Liudy <liudy@genomics.org.cn>
# Program Date:   2005.
# Modifier:       Liudy <liudy@genomics.org.cn>
# Last Modified:  2007-3-14
$ver="1.0";
$ver="1.2";#revise wrong relation bug
$ver="1.3";#add high quality region by liudy
$ver="1.4";#add .result output by liudy
$ver="1.5";#revise error bug by a barely low quality reads


#use strict;
#use Getopt::Long;
#use Data::Dumper;
#########################################################################################
if (@ARGV<3){
	print "Usage: Get sequence from ace file.\n";
	print "Usage: $0(ver$ver) *.ace seq phrap.lis\n";
	exit;
}
open (IN,"$ARGV[0]")||die"Can't open $ARGV[0]\n";
open (SEQ,">$ARGV[1]");
open (QUAL,">$ARGV[1].qual");
open (PL,">$ARGV[2]");
open (PL2,">$ARGV[2].result");
#########################################################################################
$sce=(split(/\//,$ARGV[0]))[-1];
$key_seq=0;
$key_qual=0;
$pl_out=0;
$last="";

@all=<IN>;
$all=join("",@all);
$all=~s/\n\nCO/\n\n\nCO/g;
@new_all=split(/\n/,$all);
#print "$new_all[0]\n$new_all[1]\n$new_all[2]\n$new_all[3]\n$new_all[4]\n";
#die;

foreach (@new_all) {
#	chomp;
	if (/^CO\s/) {
		@a=split;
		$ctg_name=$a[1];
#		$ctg_ori=$a[5];
		$reads_num=$a[3];
		$key_seq=1;
		$seq="";
		@reads=();
		%hash_size=();
		%hash_ori=();
		%hash_start=();
		%hash_high_left=();
		%hash_high_right=();
		%hash_pos=();
		$hash_pos{-1}=-1;
	}
	elsif ($key_seq==1 && $_ ne "") {
		$seq.=$_;
	}
	elsif ($key_seq==1 && $_ eq "") {
		$pos_seq=$seq;
		$seq=~s/\*//g;
		$seq=uc ($seq);
		$ctg_size=length($seq);
		$seq=~s/(.{50})/$1\n/g;
		$seq=~s/\n$//;
		$key_seq=0;
		print SEQ ">$ctg_name   $sce\n$seq\n";
	}
	elsif (/^BQ/) {
		$key_qual=1;
		print QUAL ">$ctg_name   $sce\n";
	}
	elsif ($key_qual==1 && $_ ne "") {
		$_=~s/^\s+//;
		$_=~s/\s+$//;
		print QUAL "$_\n";
	}
	elsif ($key_qual==1 && $_ eq "") {
		$key_qual=0;
		$pl_out=1;
	}
	elsif (/^AF\s/) {
		@a=split;
		push (@reads,$a[1]);
		$ori=$a[2];
#		$ori=~tr/UC/CU/ if($ctg_ori eq "C");
		$hash_ori{$a[1]}=$ori;
		$hash_start{$a[1]}=$a[3];
	}
#	elsif (/^RD\s/) {
#		@a=split;
#		$hash_size{$a[1]}=$a[2];
#	}
	elsif (/^RD\s/) {#add high_quality for coverage count
		@a=split;
		$hash_size{$a[1]}=$a[2];
		#add
		$read_exceed_size=$a[2];
		$read_name=$a[1];
	}
	elsif (/^QA\s/) {
		@a=split;
		$high_left=&max($a[1],$a[3]);
		$right_size=&min($a[2],$a[4]);
		$high_right=$read_exceed_size-$right_size;
		if ($a[1]==-1 && $a[2]==-1) {
			$high_left=-1;
			$high_right=-1;
		}
		$hash_high_left{$read_name}=$high_left;
		$hash_high_right{$read_name}=$high_right;
	}####前2个是高质量区，后2个是match区
	elsif ($last eq "" && $_ eq "" && $pl_out==1) {
		print PL "$ctg_name.  $reads_num reads; $ctg_size bp (untrimmed),  (trimmed).\n";
		print PL2 "$ctg_name.  $reads_num reads; $ctg_size bp (untrimmed),  (trimmed).\n";

		#pos换算  
		@pos=split(//,$pos_seq);
		$max=@pos;
		$i=0;
		$j=0;
		foreach $x (@pos) {
			$i++;
			if ($x ne "*") {
				$j++;
			}
			$hash_pos{$i}=$j;
		}

		foreach $x (@reads) {
			$reads_ori=$hash_ori{$x};
			$reads_ori="" if($reads_ori eq "U");
			$reads_start=$hash_start{$x};
			$reads_end=$reads_start+$hash_size{$x}-1;
			####
			$reads_high_start=$reads_start+$hash_high_left{$x}-1;
			$reads_high_end=$reads_end-$hash_high_right{$x};
			if ($hash_high_left{$x}==-1 && $hash_high_right{$x}==-1) {
				$reads_high_start=-1;
				$reads_high_end=-1;
			}
			####
			if ($reads_start>=1) {
				$reads_start2=$hash_pos{$reads_start};
			}
			else {
				$reads_start2=$reads_start;
			}
			if ($reads_end<=$max) {
				$reads_end2=$hash_pos{$reads_end};
			}
			else {
				$reads_end2=$reads_end-$max+$hash_pos{$max};
			}
			####
			if ($reads_high_start>=1) {
				$reads_high_start2=$hash_pos{$reads_high_start};
			}
			else {
				$reads_high_start2=$reads_high_start;
			}
			if ($reads_high_end<=$max) {
				$reads_high_end2=$hash_pos{$reads_high_end};
			}
			else {
				$reads_high_end2=$reads_high_end-$max+$hash_pos{$max};
			}
			####
			#print "$x $reads_start $reads_end $hash_high_left{$x} $hash_high_right{$x} $reads_high_start $reads_high_end\n\n";
			print PL "$reads_ori\t$reads_start2\t$reads_end2\t$x\t$reads_high_start2\t$reads_high_end2\n";
			$tmp=$x;
			$tmp=~s/^r//;
			print PL2 "$reads_ori\t$reads_start2\t$reads_end2\t$tmp\t$reads_high_start2\t$reads_high_end2\n";
		}
		print PL "\n";
		print PL2 "\n";
		$pl_out=0;
	}
	$last=$_;
}
close PL;
close PL2;
close SEQ;
close QUAL;
close IN;


##############
sub max {
	my ($x1,$x2)=@_;
	my $max;
	if ($x1 > $x2) {
		$max=$x1;
	}
	else {
		$max=$x2;
	}
	return $max;
}

sub min {
	my ($x1,$x2)=@_;
	my $min;
	if ($x1 < $x2) {
		$min=$x1;
	}
	else {
		$min=$x2;
	}
	return $min;
}
