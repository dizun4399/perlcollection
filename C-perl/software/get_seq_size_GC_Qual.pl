#!/usr/local/bin/perl -w

if (@ARGV eq 0) { die "Usage: <input seq> <output>\n"; }

open(SEQ,"$ARGV[0]") || die;
$seq = $name = ""; $trim = 0;
while (<SEQ>) {
	chomp;
	if (/^>(\S+)/) {
		if ($seq ne "") {
			$GC_num = ($seq =~ s/G/G/ig);
			$GC_num += ($seq =~ s/C/C/ig);
			$GC{$name} = $GC_num/length($seq)*100;
			$GC_num = 0;
			if ($trim = ($seq =~ s/X/N/g)) {
				$seq{$name} = length($seq)."\t".$trim;
			}
			else {$seq{$name} = length($seq)."\t0"; }
			#$untrim = length($seq) - $trim;
		}
		$seq = "";
		$name = $1;
		$trim = 0;
	}
	else {
		$seq .= $_;
	}
}
if ($seq ne "") {
		if ($trim = ($seq =~ s/X/N/g)) {
			$seq{$name} = length($seq)."\t".$trim;
		}
		else {$seq{$name} = length($seq)."\t0"; }
		#$untrim = length($seq) - $trim;
		$seq{$name} = length($seq)."\t".$trim;
}
$seq = "";
close(SEQ);

if (-e "$ARGV[0].qual") {
	open(QUAL,"$ARGV[0].qual") || die;
	while (<QUAL>) {
		chomp;
		if (/^>(\S+)/) {
			$name = $1; print ".";
			$num = $quality = 0;
		}
		else {
			push(@all, split(/ /,$_));
			foreach $temp (@all) {
				if ($temp =~ /\d+/) {
					$quality += $temp;
					$num ++; 
				}
			}
			$aver = $quality/$num;
			$qual{$name} = $aver;@all = ""; 
		}
	}
}
close(QUAL);
	
open(RES,">$ARGV[1]") || die;
print RES "Seq_Name\tSeq_Size\tTrim_Size\tAver_Qual\tGC%\n";
$i = $j = $l = 0;
foreach $key (keys %seq) {
	$l ++;
	if (exists $qual{$key}) {
		$i ++;
		$qual = sprintf("%.2f",$qual{$key});
		print RES "$key\t$seq{$key}\t$qual\t$GC{$key}\n";
	}
	else {
		$j ++;
		print RES "$key\t$seq{$key}\n";
	}
}
close(RES);
print "Same Qual: $i\tOnly Seq: $j\nAll Seq: $l\n";