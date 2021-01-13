#!/usr/bin/perl -w
 
use Tk;
use strict;
 
my $mw = MainWindow->new;
$mw->geometry("200x100");
$mw->title("Entry Test");
 
$mw->Entry(-background => 'black', -foreground => 'white')->pack(-side => "top");
 
MainLoop;
