#!/usr/local/bin/perl
if (@ARGV!=2) {
	die "Usage:splitfasta.pl inputfile fastaseqnumber\n";
}
open(SEQ,"$ARGV[0]")||die "Can't open $ARGV[0]\n" ;
$/=">";
$a=0;$i=1;
if ($ARGV[0]=~/^([^\.]+)\./) {
	$name=$1;
	$wfile=$ARGV[0];
	$wfile=~s/^$name/$name\_$i/;
	open(WF,">$wfile")||die"Can't write to $wfile:$!\n";
	while (<SEQ>) {
		if ($a>=$ARGV[1]) {
			close(WF);
			$i++;$a=0;
			$wfile=$ARGV[0];
			$wfile=~s/^$name/$name\_$i/;
			open(WF,">$wfile");
		}
		s/>$//;
		$_=">".$_;
		if (/^>\S+/) {
			print WF $_;
			$a++;
		}
	}
	close(WF);
}
else {
	print "Please input *.* file!\n";
}
