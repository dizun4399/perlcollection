#!/usr/bin/perl -w
use strict;
use Excel::Writer::XLSX;
use Getopt::Long;
use File::Basename;
#use Spreadsheet::XLSX::Fmt2007;
#use Spreadsheet::WriteExcel;
my ($output,$help,);
GetOptions (
        "o:s"=>\$output,
        "h:s"=>\$help,
        );
if (@ARGV==0 || $help ) {
    die "Usage: This program is used to trans text file to Microsoft Excel 2007+
        perl $0 -o <output.xlsx> <1.txt> <2.txt> <...>\n";
}

my $workbook = Excel::Writer::XLSX->new( "$output" );
my $format = $workbook->add_format();
#$format->set_bold();
#$format->set_color('red');
$format->set_align('center');

foreach my $file (@ARGV) {
    my $sheet_name=basename ($file);
    open IN,"$file";
    my $worksheet = $workbook->add_worksheet("$sheet_name");
    my $row=0;
    while (<IN>) {
        chomp;
        my @line=split /\t/,$_;
        my $col = 0;
        foreach my $number (0..$#line) {
            $worksheet->write ($row,$col,"$line[$number]",$format);
            $col++;
        }
        $row++;
    }
}
close IN;
$workbook->close();


