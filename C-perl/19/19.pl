#!/usrr/bin/perl -w
use strict;

open IN,"<$ARGV[0]";

while (<IN>) {
    chomp;
    my ($id,$file)=(split /=/,$_)[0,1];
    my ($gene_num,$gene_length)=&gene_stat ($file);
    print "$id\t$gene_num\t$gene_length\n";
}
close IN;

sub gene_stat {
    my $file = shift @_;
    my $genenum=0;
    my $genelength=0;

    open FA,"$file";
    while (<FA>) {
        chomp;
        if (/^>/) {
            $genenum+=1;
        } else {
            my $len=length ($_);
            $genelength+=$len;
        }
    }
    close FA;
    my $avg_length=$genelength/$genenum;
    return $genenum,$avg_length;
}
