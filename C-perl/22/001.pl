#!/usr/bin/perl -w
print "Do u like perl？\n";
my $choice=<STDIN>;
if ($choice=~ /y e s/ix) {
    print "Yes，So you need to work hard\n";
} else {
    print "No，So you need to work harder\n";
}
