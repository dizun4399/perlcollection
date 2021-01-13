use 5.24.0;
use utf8;
use strict;
use warnings;
while(<STDIN>){
    chomp;
    #i是不分大小写，s是.包括\n  x是空格不管用
    if(/^\s*
       yes$/isx){
        say "follow your yes";
        

    }elsif(/-?
       \d+
       \.?
       \d+
       /x)
    {
        say "you input a number $_";
    }
    elsif(/^\s*
       exit$/isx){
        say "exit";
    }
    


}

BEGIN{
    $SIG{__DIE__}=sub{
        my $error = shift;
        say "catch a error: $error";
        die $error;
    };
}
END{
    
}

