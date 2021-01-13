#!/use/bin/perl -w
use strict;
use Spreadsheet::XLSX;
use Data::Dumper;
#use Text::Iconv;
#my $converter = Text::Iconv -> new ("utf-8", "windows-1251");
if (scalar @ARGV==0) {
    die "Usage : This program is used to trans Excel file to text file
        perl $0 <test.xlsx>\n";
}
my $excel = Spreadsheet::XLSX -> new ("$ARGV[0]",);
#my $excel = Spreadsheet::XLSX -> new ('test.xlsx', $converter);

#print Dumper (\$excel);

foreach my $sheet (@{$excel -> {Worksheet}}) {
#    printf("Sheet: %s\n", $sheet->{Name});
#   $sheet -> {MaxRow} ||= $sheet -> {MinRow};
    foreach my $row ($sheet -> {MinRow} .. $sheet -> {MaxRow}) {
#        $sheet -> {MaxCol} ||= $sheet -> {MinCol};
        foreach my $col ($sheet -> {MinCol} ..  $sheet -> {MaxCol}) {
            my $cell = $sheet -> {Cells} [$row] [$col];
            if ($cell) {
            print "$cell->{Val}\t";
#                printf("( %s , %s ) => %s\n", $row, $col, $cell -> {Val});
            }
        }
        print "\n";
    }
}
