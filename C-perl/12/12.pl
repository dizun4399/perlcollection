#!/usr/bin/perl -w
use strict;

open IN,"<gene.ffn",or die "can not open the file:$!\n";

open OU,">protein.faa";
open OU,">>protein.faa";
