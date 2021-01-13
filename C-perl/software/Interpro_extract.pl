if(@ARGV!=2){die "usage : $0 usage : *.pl <interpro_result>  <result>  \n";}
chomp($binpath = `dirname $0`);
$binpath=~s/\/$//;
$binpath="/sdb/sunhb/work/Est_PipeLine/bin/";
open(IN,"$ARGV[0]");
open OUT, ">$binpath/tmp/tmp.1";
open OUT1, ">$binpath/tmp/tmp.2";
open OUT2, ">$binpath/tmp/tmp.3";
open OUT3, ">$binpath/tmp/tmp.4";                                                                
while(<IN>){
	chomp;
	if($_=~/^Sequence/){	
		@temp=split;
		$temp[1]=~s/\"//g;
		if($temp[1]=~/(\S+)\_[np][-+]\d+\_s:\d+\_e:\d+$/){
		   $gene=$1;
		}else{
		   $gene=$temp[1];
		}
		
        	}        	
	elsif($_=~/^InterPro/){
			
		if($ok==1){
		  print OUT "\n";
		  $ok=0;	
			
		}
		@temp=split;
		if($temp[1] ne "NULL" ){
			
		
		$ok=1;
		print OUT "$gene\t$temp[1]\t";
		
		for($i=2;$i<@temp;$i++){
        	print OUT $temp[$i]." ";
        	}
        	print OUT "\t";

        	}
        	}
        	elsif($_=~/GO:/ && $ok==1){

        		@tem=split(/\)\, /,$_);
        		foreach $a(@tem){
        		
        		print $a,"\n";	
        		@word=split(/\(GO/,$a);	
        		$word[1]=~s/\)//;
        		
        		if($word[0]=~/Molecular Function/){
        			$word[0]=~s/Molecular Function: //;
        			 print OUT2 "$gene\t";
        			 print OUT2 "GO$word[1]\t$word[0]\n";	 
        			
        		}elsif($word[0]=~/Biological Process/){
        			$word[0]=~s/Biological Process: //;
        			print OUT3 "$gene\t";
        			 print OUT3 "GO$word[1]\t$word[0]\n";
        			
        		}elsif($word[0]=~/Cellular Component/){
        			$word[0]=~s/Cellular Component: //;
        			print OUT1 "$gene\t";
        			 print OUT1 "GO$word[1]\t$word[0]\n";
        			
        		}

        		print OUT "GO$word[1]\t";	        	
        		} 
        		print OUT "\n";
        		$ok=0;	
        	 	
        	}

}
if($ok==1){
	  print OUT "\n";
	  $ok=0;			
}
close IN;
close OUT;
close OUT1;
close OUT2;
close OUT3;

$in1="$binpath/tmp/tmp.1";
$in2="$binpath/tmp/tmp.2";
$in3="$binpath/tmp/tmp.3";
$in4="$binpath/tmp/tmp.4";
$out1="$ARGV[1].ipr.go";	        
$out2="$ARGV[1].go.Cellular.Component";
$out3="$ARGV[1].go.Molecular.Function";
$out4="$ARGV[1].go.Biological.Process";

&drop_off_same($in1,$out1);	
&drop_off_same($in2,$out2);	
&drop_off_same($in3,$out3);	
&drop_off_same($in4,$out4);	
#system "more $binpath/tmp.1 |sort -u >$ARGV[1].ipr.go ";
#system "more $binpath/tmp.2 |sort -u >$ARGV[1].go.Cellular.Component ";
#system "more $binpath/tmp.3 |sort -u >$ARGV[1].go.Molecular.Function ";
#system "more $binpath/tmp.4 |sort -u >$ARGV[1].go.Biological.Process ";
system "rm -f $binpath/tmp/tmp.1 $binpath/tmp/tmp.2 $binpath/tmp/tmp.3 $binpath/tmp/tmp.4 ";
open OUT, ">$ARGV[1].go.txt ";
open GO, ">$ARGV[1]_GO_Anno.txt ";
open IN, "$ARGV[1].go.Cellular.Component";
while(<IN>){
     chomp;
     @temp=split(/\t/,$_);    
     $gene_go{$temp[0]}.="\t$temp[1]";
     $gene_go_anno{$temp[0]}.="\t$temp[1]:$temp[2]";
}
close IN;
open IN, "$ARGV[1].go.Molecular.Function";
while(<IN>){
     chomp;
     @temp=split(/\t/,$_);
     
     $gene_go{$temp[0]}.="\t$temp[1]";
     $gene_go_anno{$temp[0]}.="\t$temp[1]:$temp[2]";
}
close IN;
open IN, "$ARGV[1].go.Biological.Process";
while(<IN>){
     chomp;
     @temp=split(/\t/,$_);
    
     $gene_go{$temp[0]}.="\t$temp[1]";
     $gene_go_anno{$temp[0]}.="\t$temp[1]:$temp[2]";
}
close IN;
foreach (sort keys %gene_go){
     print OUT "$_$gene_go{$_}\n";
     print GO "$_$gene_go_anno{$_}\n";		
}
close OUT;
close GO;

open IN, "$ARGV[1].ipr.go";
open OUT, ">$ARGV[1].gene.interpro.txt";
open O, ">$ARGV[1].interpro.classify.txt";
while(<IN>){
     chomp;
     @temp=split(/\t/,$_);   
     $gene_ipr{$temp[0]}.="\t%$temp[1]:$temp[2]";
     $ipr{$temp[1]}.="\t$temp[0]\n";
     $num_ipr{$temp[1]}++;
     $anno_ipr{$temp[1]}=$temp[2];
        
}
close IN;
foreach (sort keys %gene_ipr){
     print OUT "$_$gene_ipr{$_}\n";		
}

foreach (sort keys %ipr){
     print O "%$_\t$anno_ipr{$_}\t$num_ipr{$_}\n$ipr{$_}\n";		
}

close OUT;
close O;

system "perl $binpath/Gene_Ontology_Tools/gene_ontology.pl -i $ARGV[1].go.txt -o $ARGV[1].go.svg -list ";


sub drop_off_same{
	($input,$output)=@_;
	%hash=();
	 open in,"$input";
	 while(<in>){
	 	chomp;
	 	$hash{$_}=1;;
	 
	 }
	 close in;
	 open out,">$output";
	 foreach (sort keys %hash){
	 	print out "$_\n";
	 	
	}
	close out;
}
