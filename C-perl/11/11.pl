#!/usr/bin/perl 

@number=(1..10);
foreach $num (@number) {
    print "$num\n";
}


foreach  (@number) {
    print "$_\n";
}

$_="hello,world\n";
print;


