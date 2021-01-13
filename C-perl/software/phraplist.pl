#!/usr/bin/perl

die "Usage:$0 phrap.out\n" if (@ARGV!=1);
open(PhrapOut, "$ARGV[0]") ||die "could not open $ARGV[0]";
#open(PhrapList , ">phrap.lis") || die "could not open phrap.lis for writing";
@line=<PhrapOut>;
$real=0;
foreach $hang (@line) {
        if($hang =~/^Contig\s\d+.\s+\d+\s\w+;\s\d+\sbp/ ) {
                $real=1;
        }
        $real=0 if($hang =~/Contig quality (.*):$/ || $hang =~/^Overall discrep rates/);
	#print $hang if($real);
	#print PhrapList $hang if($real);
	$real=0 if($hang=~"Overall");
	print $hang if($real);
}
#close(PhrapList);
close(PhrapOut);
