#!/usr/bin/perl 

@number=(1..20);
print "@number\n";

@sort_number=sort @number;
print "@sort_number\n";

@reverse_number=reverse @number;
print "@reverse_number\n";

$dna="CAGAAAGAATGCAGTAACCCATCGAATAATCAAGTGATGCCATGTGAACCGATCATAATAGAAAGGAACACAG";
$reverse_dna=reverse $dna;
print "$dna\n";
print "$reverse_dna\n";


