#!/usr/bin/perl 
use strict;

if (scalar @ARGV==0) {
        die "This program is used to trans cds to pep
             perl $0 <cds file>  <pep file> \n";
}

open IN,"$ARGV[0]";

#open OUT,">$ARGV[1]";
$/=">";<IN>;

while (<IN>) {
    chomp;
    next if (/^\s+$/);
    my ($id,$dna)=(split /\n/,$_,2)[0,1];
    $dna=~ s/\n//g;
    my $protein="";
    for(my $i=0; $i < (length($dna) - 2) ; $i += 3) {
        $protein .= &codon2aa( substr($dna,$i,3) );
    }
     print ">$id\n";
     print "$protein\n";
}
$/="\n";
sub codon2aa {
    my($codon) = @_;

    $codon = uc $codon;

    my(%genetic_code) = (

            'TCA' => 'S',    # Serine
            'TCC' => 'S',    # Serine
            'TCG' => 'S',    # Serine
            'TCT' => 'S',    # Serine
            'TTC' => 'F',    # Phenylalanine
            'TTT' => 'F',    # Phenylalanine
            'TTA' => 'L',    # Leucine
            'TTG' => 'L',    # Leucine
            'TAC' => 'Y',    # Tyrosine
            'TAT' => 'Y',    # Tyrosine
            'TAA' => '',    # Stop
            'TAG' => '',    # Stop
            'TGC' => 'C',    # Cysteine
            'TGT' => 'C',    # Cysteine
            'TGA' => '',    # Stop
            'TGG' => 'W',    # Tryptophan
            'CTA' => 'L',    # Leucine
            'CTC' => 'L',    # Leucine
            'CTG' => 'L',    # Leucine
            'CTT' => 'L',    # Leucine
            'CCA' => 'P',    # Proline
            'CCC' => 'P',    # Proline
            'CCG' => 'P',    # Proline
            'CCT' => 'P',    # Proline
            'CAC' => 'H',    # Histidine
            'CAT' => 'H',    # Histidine
            'CAA' => 'Q',    # Glutamine
            'CAG' => 'Q',    # Glutamine
            'CGA' => 'R',    # Arginine
            'CGC' => 'R',    # Arginine
            'CGG' => 'R',    # Arginine
            'CGT' => 'R',    # Arginine
            'ATA' => 'I',    # Isoleucine
            'ATC' => 'I',    # Isoleucine
            'ATT' => 'I',    # Isoleucine
            'ATG' => 'M',    # Methionine
            'ACA' => 'T',    # Threonine
            'ACC' => 'T',    # Threonine
            'ACG' => 'T',    # Threonine
            'ACT' => 'T',    # Threonine
            'AAC' => 'N',    # Asparagine
            'AAT' => 'N',    # Asparagine
            'AAA' => 'K',    # Lysine
            'AAG' => 'K',    # Lysine
            'AGC' => 'S',    # Serine
            'AGT' => 'S',    # Serine
            'AGA' => 'R',    # Arginine
            'AGG' => 'R',    # Arginine
            'GTA' => 'V',    # Valine
            'GTC' => 'V',    # Valine
            'GTG' => 'V',    # Valine
            'GTT' => 'V',    # Valine
            'GCA' => 'A',    # Alanine
            'GCC' => 'A',    # Alanine
            'GCG' => 'A',    # Alanine
            'GCT' => 'A',    # Alanine
            'GAC' => 'D',    # Aspartic Acid
            'GAT' => 'D',    # Aspartic Acid
            'GAA' => 'E',    # Glutamic Acid
            'GAG' => 'E',    # Glutamic Acid
            'GGA' => 'G',    # Glycine
            'GGC' => 'G',    # Glycine
            'GGG' => 'G',    # Glycine
            'GGT' => 'G',    # Glycine
            );

    if(exists $genetic_code{$codon}) {
        return $genetic_code{$codon};
    }else{
        return "X";

    }
}

