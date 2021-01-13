#!/usr/bin/perl -w
use strict;

for (1..10) {
    if ($_==5) {
# last;
#       next;
#       redo;
    } else {
       print "$_\n";
    }
}
