#!/usr/bin/perl

use warnings;

my ($file) = ($ARGV[0]);

#print $file, "\n";
my $cnt = 0;

$/ = ">";
open IN, $file or die 'can not open the file, ', "$!\n";
<IN>;
while(<IN>)
{
	chomp;
	my ($name, $info) = split(/\n/, $_, 2);
	$info =~ s/\n//g;
	print ">$name :\n";
	my $length = length($info);
	my $pre = 1;
	my $start = 0;
	my $end = 0;
	for(my $i = 0; $i != $length; ++$i)
	{
		my $tc = substr($info, $i, 1);
		if(lc($tc)  eq 'n')
		{
			if($pre == 1)
			{
				$start = $i + 1;
				$pre = 0;
			}
		}
		else
		{
			if($pre == 0)
			{
				$end = $i;
				$pre = 1;
				my $tl = $end - $start + 1;
				print "$start\t$end\t$tl\n";
				++$cnt;
			}
		}
	}
}
close IN;

$/ = "\n";

print "total gap number:\t", $cnt, "\n";
