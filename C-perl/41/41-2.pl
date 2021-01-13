#!/usr/bin/perl -w
use strict;

my @items =qw (wilam dino pebbles);
my $format ="The items are:\n" . ("%10s\n"x @items);
printf $format,@items;
