#! /usr/bin/perl -w
use strict;
use Getopt::Long;

my ($predict,$tag,$nr,$kegg,$cog,$rRNA,$tRNA);
GetOptions(
        "predict:s" => \$predict,
        "locus_tag:s" => \$tag,
        "nr:s" => \$nr,
        "kegg:s" => \$kegg,
        "cog:s" => \$cog,
        "rrna:s" => \$rRNA,
        "trna:s" => \$tRNA,
        );
die `pod2text $0` unless($predict && $tag && $nr && $kegg && $cog && $rRNA && $tRNA);

my (%genename,%genestrand,%geneend,%nr,%kegg,%cog);
my ($name,$product,%gene,%ecno,@tmp,$start,$end);
my (%rna_r,%rna_t);

open PRE,"$predict" or die "$predict:$!\n";
while(<PRE>){
    chomp;
    next if(/^\#/);
    my $geneno = "";
    @tmp = split /\t/;
    next unless($tmp[2]=~/CDS/);
    if($tmp[-1]=~/Parent=[^\;]+(\d{4})/){
        $geneno = $1;
        $geneno = sprintf("%04d",$geneno);
    }
    $genename{$tmp[0]}{$tmp[3]} = $tag . "_" . $geneno;
    $genestrand{$tmp[0]}{$tmp[3]} = $tmp[6];
    $geneend{$tmp[0]}{$tmp[3]} = $tmp[4];
}
close PRE;

my $flag = 0;
open RRNA,"$rRNA" or die "$rRNA:$!\n";
while(<RRNA>){
    chomp;
    next if(/^\#/);
    @tmp = split /\t/;
    $flag ++;
    $flag = sprintf("%02d",$flag);
    $genename{$tmp[0]}{$tmp[3]} = $tag . "_r" . $flag;
    $genestrand{$tmp[0]}{$tmp[3]} = $tmp[6];
    $geneend{$tmp[0]}{$tmp[3]} = $tmp[4];
    $tmp[8] =~ s/^(\d+)\S+/$1/;
    $rna_r{$genename{$tmp[0]}{$tmp[3]}} = $tmp[8] . "S ribosomal RNA";
}
close RRNA;
open TRNA,"$tRNA" or die "$!\n";
while(<TRNA>){
    chomp;
    next if(/^\#/);
    @tmp = split /\t/;
    my $id = my $type = "";
    $genestrand{$tmp[0]}{$tmp[3]} = $tmp[6];
    $geneend{$tmp[0]}{$tmp[3]} = $tmp[4];
    if($tmp[8] =~ /ID=\w+tRNA_(\d+)/){
        $id = $1;
        $id = sprintf("%02d",$id);
    }
    $genename{$tmp[0]}{$tmp[3]} = $tag . "_t" . $id;
    if($tmp[8] =~ /Type=(\w+)/i){
        $type = $1;
        $rna_t{$genename{$tmp[0]}{$tmp[3]}} = 'tRNA-' . $type;
    }
}
close TRNA;

open NR,"$nr" or die "$nr:$!\n";
while(<NR>){
    chomp;
    @tmp = split /\t/;
    $name = $tag . "_" . substr($tmp[0],length($tmp[0])-4,4);
    $tmp[-1] =~ s/\[.+\]$//;
    $nr{$name} = $tmp[-1];
}
close NR;

open KEGG,"$kegg" or die "$kegg:$!\n";
<KEGG>;
while(<KEGG>){
    chomp;
    @tmp = split /\t/;
    $name = $tag . "_" . substr($tmp[0],length($tmp[0])-4,4);
    unless($tmp[7] =~ /\-\-/){
        $ecno{$name} = $tmp[7];
    }
    if($tmp[5] =~ /^[a-z]/ && $tmp[5] !~ /\,/){
        $gene{$name} = $tmp[5];
    }
    unless($tmp[6] =~ /\-\-/){
        $kegg{$name} = $tmp[6];
    }
}
close KEGG;

open COG,"$cog" or die "$cog:$!\n";
while(<COG>){
    chomp;
    @tmp = split /\t/;
    $name = $tag . "_" . substr($tmp[0],length($tmp[0])-4,4);
    $cog{$name} = $tmp[5];
}
close COG;

foreach my $k(sort keys %genename){
    print ">Feature $k\n";
    foreach my $subk(sort{$a<=>$b} keys %{$genename{$k}}){
        if($genestrand{$k}{$subk} =~ /\-/){
            $start = $geneend{$k}{$subk};
            $end = $subk;
        }else{
            $start = $subk;
            $end = $geneend{$k}{$subk};
        }
        $name = $genename{$k}{$subk};
        if($name =~ /_r\d+/){
            print "$start\t$end\tgene\n";
            print "\t\t\tlocus_tag\t$name\n";
            print "$start\t$end\trRNA\n";
            print "\t\t\tproduct\t$rna_r{$name}\n";
            next;
        }elsif($name =~ /_t\d+/){
            print "$start\t$end\tgene\n";
            print "\t\t\tlocus_tag\t$name\n";
            print "$start\t$end\ttRNA\n";
            print "\t\t\tproduct\t$rna_t{$name}\n";
            next;
        }

        if(exists $nr{$name}){
            $product = $nr{$name};
        }elsif(exists $kegg{$name}){
            $product = $kegg{$name};
        }elsif(exists $cog{$name}){
            $product = $cog{$name};
        }else{
            $product = "hypothetical protein";
        }

        print "$start\t$end\tgene\n";
        if(exists $gene{$name}){
            print "\t\t\tgene\t$gene{$name}\n";
        }
        print "\t\t\tlocus_tag\t$name\n";
        print "$start\t$end\tCDS\n";
        print "\t\t\tproduct\t$product\n";
        print "\t\t\tprotein_id\tgnl\|ncbi\|$name\n";
        if(exists $ecno{$name}){
            print "\t\t\tEC_number\t$ecno{$name}\n";
        }
    }
}


=head1 DESCRIPTION

perl anno2tbl.pl <option>
    
    -predict    <s> : prediction result in gff format
    -locus_tag  <s> : prefix
    -nr         <s> : nr anno result
    -kegg       <s> : kegg anno result
    -cog        <s> : cog anno result
    -rrna       <s> : rRNA anno result
    -trna       <s> : tRNA anno result

=cut
