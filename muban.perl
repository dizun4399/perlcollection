use 5.24.0;
use utf8;
use strict;
use warnings;

die "aaa";
BEGIN{
    $SIG{__DIE__}=sub{
        my $error = shift;
        say "catch a error: $error";
        die $error;
    };
}
END{
    
}

