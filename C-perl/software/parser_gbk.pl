#!/usr/bin/perl

=head1 Name

parse genbank format file

=head1 Description

get needed information form genbank format files

=head1 Usage

  --verbose   output verbose information to screen  
  --help      output help information to screen  

=head1 Exmple



=cut

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname); 
use Data::Dumper;

my ($Verbose,$Help);
GetOptions(
	"verbose"=>\$Verbose,
	"help"=>\$Help
);
die `pod2text $0` if (@ARGV == 0 || $Help);

my $genbank_file = shift;
my %Gene;

parse_genbank($genbank_file,\%Gene);

generate_seq_file(\%Gene,$genbank_file.".seq");
generate_cds_file(\%Gene,$genbank_file.".cds");
generate_pep_file(\%Gene,$genbank_file.".pep");
generate_gff_file(\%Gene,$genbank_file.".gff");

sub generate_seq_file{
	my ($hash,$file) = @_;
	open OUT,">".$file || die "fail $file";
	foreach my $ACCESSION (sort keys %$hash) {
		my $seq_str = uc $hash->{$ACCESSION}{SEQ};
		Display_seq(\$seq_str);
		print OUT ">$ACCESSION  [$hash->{$ACCESSION}{ORGANISM}]  $hash->{$ACCESSION}{DEFINITION}\n$seq_str";
	}
	close OUT;
}



sub generate_cds_file{
	my ($hash,$file) = @_;
	open OUT,">".$file || die "fail $file";
	foreach my $ACCESSION (sort keys %$hash) {
		my $output;
		my $cds_hash = $hash->{$ACCESSION}{CDS};
		foreach my $gene (sort keys %$cds_hash) {
			my $strand = $cds_hash->{$gene}{is_complement} ? '-' : '+';
			my $status = $cds_hash->{$gene}{is_partial} ? "partial gene" : "complete gene";
			my $coor_p = $cds_hash->{$gene}{cds};
			my $gene_name = $cds_hash->{$gene}{gene};
			my $cds_str;
			next unless($coor_p);
			for (my $i=0; $i<@$coor_p; $i+=2) {
				$cds_str .= substr($hash->{$ACCESSION}{SEQ},$coor_p->[$i]-1,$coor_p->[$i+1]-$coor_p->[$i]+1);
			}
			Complement_Reverse(\$cds_str) if($cds_hash->{$gene}{is_complement});
			Display_seq(\$cds_str);
			$cds_str = uc $cds_str;
			#print ">$gene  sequence:$ACCESSION:$coor_p->[0]:$coor_p->[-1]:$strand  $cds_hash->{$gene}{note}\n$cds_str";	
			$output .= ">$gene  $gene_name  sequence:$ACCESSION:$coor_p->[0]:$coor_p->[-1]:$strand  $cds_hash->{$gene}{note}  $status\n$cds_str";
		} 
		print OUT $output;
	}
	close OUT;
}

sub generate_pep_file{

	my ($hash,$file) = @_;
	open OUT,">".$file || die "fail $file";
	foreach my $ACCESSION (sort keys %$hash) {
		my $output;
		my $cds_hash = $hash->{$ACCESSION}{CDS};
		foreach my $gene (sort keys %$cds_hash) {
			my $strand = $cds_hash->{$gene}{is_complement} ? '-' : '+';
			my $status = $cds_hash->{$gene}{is_partial} ? "partial gene" : "complete gene";
			my $coor_p = $cds_hash->{$gene}{cds};
			my $pep_str = $cds_hash->{$gene}{protein};
			my $gene_name = $cds_hash->{$gene}{gene};
			Display_seq(\$pep_str);
			
			$output .= ">$gene  $gene_name  sequence:$ACCESSION:$coor_p->[0]:$coor_p->[-1]:$strand  $cds_hash->{$gene}{note}  $status\n$pep_str";
		} 
		print OUT $output;
	}
	close OUT;
}


sub generate_gff_file{
	my ($hash,$file) = @_;
	open OUT,">".$file || die "fail $file";
	foreach my $ACCESSION (sort keys %$hash) {
		my $output;
		my $cds_hash = $hash->{$ACCESSION}{CDS};
		foreach my $gene (sort keys %$cds_hash) {
			my $strand = $cds_hash->{$gene}{is_complement} ? '-' : '+';
			my $status = $cds_hash->{$gene}{is_partial} ? "partial gene" : "complete gene";
			my $coor_p = $cds_hash->{$gene}{cds};
			my $gene_name = $cds_hash->{$gene}{gene};
			$output .= "$ACCESSION\tGenBank\tmRNA\t$coor_p->[0]\t$coor_p->[-1]\t.\t$strand\t.\tID=$gene; $gene_name  $cds_hash->{$gene}{note}  $status\n";
			for (my $i=0; $i<@$coor_p; $i+=2) {
				my ($exon_start,$exon_end) = ($coor_p->[$i], $coor_p->[$i+1]);
				$output .= "$ACCESSION\tGenBank\tCDS\t$exon_start\t$exon_end\t.\t$strand\t.\tParent=$gene;\n";
			}
		} 
		print OUT $output;
	}
	close OUT;
}


sub parse_genbank {
	my $file = shift;
	my $hash = shift;
	
	open IN,$file  || die "fail $file";
	$/="LOCUS       ";
	<IN>;
	while (<IN>) {
		chomp;
		$_ = "LOCUS       ".$_;
		my ($locus,$len,$type,$class,$ACCESSION,$ORGANISM,$DEFINITION,$ORF,$seq,%cds);
		($locus,$len,$type,$class) = ($1,$2,$3,$4) if(/LOCUS\s+(\S+)\s+(\d+)\s+bp\s+(\S+)\s+\S+\s+(\S+)/);
		$locus = $1 if(/LOCUS\s+(\S+)/);

		next unless($locus);
		$ACCESSION = $1 if(/\nACCESSION\s+(\S+)/);	
		$ORGANISM = $1 if(/\n\s+ORGANISM\s+(.+)/);
		$DEFINITION = $1 if(/\nDEFINITION\s+(.+?)\s+ACCESSION/s);
		$DEFINITION =~ s/\n           //g;
		
		$seq = $1 if(/\nORIGIN(.+?)\/\//s);      
		$seq =~ s/\s+\d+\s+//g;
		$seq =~ s/\s//g;

		while (/(CDS             .+?\n)     \S/sg) {
			parse_CDS($1,\%cds);
		}

		$hash->{$ACCESSION}{LOCUS} = $locus;
		$hash->{$ACCESSION}{LEN} = $len;
		$hash->{$ACCESSION}{TYPE} = $type;
		$hash->{$ACCESSION}{CLASS} = $class;
		$hash->{$ACCESSION}{ORGANISM} = $ORGANISM;
		$hash->{$ACCESSION}{DEFINITION} = $DEFINITION;
		$hash->{$ACCESSION}{SEQ} = $seq;
		$hash->{$ACCESSION}{CDS} = \%cds;
		##warn "$ACCESSION parsed";
	}
	$/="\n";
	close IN;
}


sub parse_CDS{
	my $str = shift;
	my $hash = shift;
	
	my ($gene,$protein,$note,$is_partial,$is_complement,$locus_tag);
	$is_complement = 1 if($str =~ /CDS             complement\(/);
	$protein = $1 if($str =~ /\/translation=\"(.+?)\"/s);
	$protein =~ s/\s//g;
	
	$gene = $1 if($str =~ /\/gene=\"(.+?)\"/s);
	$locus_tag = $1 if($str =~ /\/locus_tag=\"(.+?)\"/s);

	while ($str =~ /\/note=\"(.+?)\"/sg) {
		$note .= $1.";  ";
	}
	$note =~ s/\n//g;
	$note =~ s/\>//g;
	
	my @cds;
	my $temp_str = (split(/\//, $str))[0];
	while ($temp_str =~ /([\d><]+\.\.[\d><]+)[\n\)]?/sg) {
		my $coor_str = $1;
		$is_partial = 1 if($coor_str =~ /[><]/);
		$coor_str =~ s/[><]//g;
		my ($start,$end) = ($1,$2) if($coor_str =~ /(\d+)\.\.(\d+)/);
		push @cds,$start,$end;
	}
	if ($temp_str =~ /join\(.*,(\d+)\)/) { 
		push @cds, $1, $1;
	}
	
	$hash->{$locus_tag}{protein} = $protein;
	$hash->{$locus_tag}{note} = $note;
	$hash->{$locus_tag}{is_partial} = $is_partial;
	$hash->{$locus_tag}{is_complement} = $is_complement;
	$hash->{$locus_tag}{cds} = \@cds;
	$hash->{$locus_tag}{gene} = $gene;
}

#############################################
sub Display_seq{
	my $seq_p=shift;
	my $num_line=(@_) ? shift : 50; ##set the number of charcters in each line
	my $disp;

	$$seq_p =~ s/\s//g;
	for (my $i=0; $i<length($$seq_p); $i+=$num_line) {
		$disp .= substr($$seq_p,$i,$num_line)."\n";
	}
	$$seq_p = ($disp) ?  $disp : "\n";
}
#############################################
sub Complement_Reverse{
	my $seq_p=shift;
	if (ref($seq_p) eq 'SCALAR') { ##deal with sequence
		$$seq_p=~tr/AGCTagct/TCGAtcga/;
		$$seq_p=reverse($$seq_p);  
	}
}
#############################################

