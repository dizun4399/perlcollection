#!/usr/bin/perl 

@array=(1,2,3,4,5);
print "@array\n";

print "$array[0]\n";
print "$array[1]\n";
print "$array[2]\n";
print "$array[3]\n";
print "$array[4]\n";

@number=(1..100);
print "@number\n";

@strings=qw (fred barney betty wilma dino);

@string1=qw !fred barney betty wilma dino!;
@string2=  #fred barney betty wilma dino#:
@string3=qw /fred barney betty wilma dino/;
@string4=qw {fred barney betty wilma dino};
@string5=qw  <fred barney betty wilma dino>;

($fred,$barney,$dino)=("flintstone","rubble",undef);
print "$fred\n";
print "$barney\n";
print "$dino\n";
