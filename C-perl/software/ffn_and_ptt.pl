#!usr/bin/perl -w
use strict;
die "\n\tUsage:perl $0 <ffn file> <ptt file> <new ffn file>\n" unless @ARGV==3;

my %ptt;
open PTT,$ARGV[1] or die;
while(<PTT>){
   chomp;
   next if(/^#/);
   my @split=split /\t/,$_;
   my ($str,$stop)=(split /\.\./,$split[0])[0,1];
   #print "$str\t$stop\n";
   my $loc;
   if($split[1] eq "-"){
      $loc="c".$stop."-".$str;
	  #print "$loc\n";
	#  $ptt{$loc}=$split[-1];
   }else{
      $loc=$str."-".$stop;
   }
   $ptt{$loc}=$split[-1];
}
close PTT;


my %ffn;
open Fa,$ARGV[0];
while(<Fa>){
   chomp;
   my $head=$_;
   $head=~s/>//;
   my $aa=(split /\s+/,$head)[0];
   #my($start,$stop)=(split /[\:\-]/,$aa)[0,1];
   #my $ab=join "_",$aa,$bb;
   $/=">";
   my $seq=<Fa>;
   $seq=~s/>//;
   #$seq=~s/\n//g;
   $/="\n";
   chomp $seq;
   $ffn{$aa}=$seq;
}
close Fa;

#open OUT,">$ARGV[2]";
foreach my $key(keys %ffn){
   my $site=(split /\:/,$key)[-1];
   if(exists $ptt{$site}){
      print ">$key $ptt{$site}\n$ffn{$key}\n";
   }
}
close OUT;
