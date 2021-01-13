#!/usr/bin/perl -w
use strict;

#
# draw cds length distribution
#

if(@ARGV == 0){die"usage:[in cds file]";};

my $in = shift @ARGV;

# get length and cata

my %length = ();
my @scale = qw(0 100 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000);
my %distribute = ();
my %sort = ();

for(my $i=0; $i<(@scale-1); $i++){
    $sort{"$scale[$i]-$scale[$i+1]"} = $i;
};
my $total = @scale;
$sort{">=$scale[-1]"} = $total;

sub sort_by_order{
    $sort{$a} <=> $sort{$b};
};

open IN,"$in"or die;
$/ = ">";
<IN>;
while(my $line = <IN>){
    chomp $line;
    my @a = split(/\n/,$line);
    my $head = shift @a;
    $head =~ /^(\S+)\s*/;
    my $name = $1;
    my $all = join "",@a;
    $length{$name} = length($all);
    for(my $i=0; $i<(@scale-1); $i++){
	if($length{$name} >= $scale[$i] and $length{$name} < $scale[$i+1]){
	    $distribute{"$scale[$i]-$scale[$i+1]"}++;
	    last;
	};
    };
    if($length{$name} >= $scale[-1]){
	    $distribute{">=$scale[-1]"}++;
    };
};
close IN;
$/ = "\n";

open OUT,">$in.len.dis.tmp"or die;
foreach my $key (sort sort_by_order keys %distribute){
    print OUT "$key\t$distribute{$key}\n";
};
close OUT;



# draw

my $R_out = <<R;
data = read.table("$in.len.dis.tmp");
tag = data[,1]
data = data[,2];
pdf(file="$in.pdf",6,6);
locate = barplot(data,ylim=c(0,max(data)*1.1),cex.names=0.8,las=1,cex.axis=0.7,xlab="Length",ylab="counts",main="Gene Length Distribution")
box();
axis(side=1,at=locate,labels=tag,padj=0.5,tick=FALSE,font=1,las=2,cex.axis=0.7,line=-0.7);
R

open OUT,">$in.R"or die;
print OUT $R_out;
close OUT;

#system "/share/raid1/genome/bin/R    CMD  BATCH   $in.R  $in.out ";
system "/opt/blc/genome/biosoft/R/bin/R    CMD  BATCH   $in.R  $in.out ";
system "/usr/bin/convert  -density 98  $in.pdf $in.png ";
system "rm $in.pdf $in.R $in.out $in.len.dis.tmp ";
