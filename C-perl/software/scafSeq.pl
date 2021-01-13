#!/usr/bin/perl -w
use strict;
################################################################################
unless(1==@ARGV) {
    &usage;
    exit;
}
################################################################################
my$list=$ARGV[0];
my(@info,$i,$file,%sample);
my($scafnum,$scaflen,$scafN50,$scafN90);
my($contnum,$contlen,$contN50,$contN90);
################################################################################
open IN,"<$list" or die "Read $list $!\n";
while(<IN>) {
    chomp;
    @info=split /\s+/,$_;;
#   $sample{$info[0]}=$info[1];
#}
#close IN;
#################################################################################
#foreach $i(keys %sample) {
#    $file=$sample{$i};
    open SH,"/share/backup/zhouyj/bin/ss.o $info[1] |" or die "ss $file $!\n";
    while(<SH>) {
        next unless(/\w/);
        chomp;
        if(/Total number \(>\)/) {
            @info=split;
            $scafnum=$info[-3];
            $contnum=$info[-2];
        }
        if(/Total length of \(bp\)/) {
            @info=split;
            $scaflen=$info[-3];
            $contlen=$info[-2];
        }
        if(/N50 Length \(bp\)/) {
            @info=split;
            $scafN50=$info[-3];
            $contN50=$info[-2];
        }
        if(/Gap number \(bp\)/) {
            @info=split;
            $scafN90=$info[-3];
#$contN90=$info[-2];
        }
        if(/Maximum/) {
            print $i,"\t";
            print $scafnum,"\t",$scaflen,"\t",$scafN50,"\t",$scafN90,"\t";
            print $contnum,"\t",$contlen,"\t",$contN50,"\t","\n";
            last;
        }
    }
    close SH;
}

################################################################################
sub usage {
    print STDERR
        "\n
        Description\n
        Start by Mon Feb 21 11:35:09 2011\n
        This script is to stat scafSeq info\n
        Usage:  \$perl $0 [scafSeq list]\n
        [scafSeq list] like Sample ./sample.scafSeq\n
        Author by zhouyuanjie\@genomics.org.cn\n
        \n"
}
