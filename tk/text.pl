#!/usr/bin/perl -w
use 5.32.0; 
use Tk;
use strict;
use utf8;
use feature     qw< unicode_strings >;

 
my $mw = MainWindow->new;
$mw->geometry("200x100");
$mw->title("hello");
 
$mw->Text(-background => 'cyan', -foreground => 'white')->pack(-side => "top");
say "ÄãºÃ";
MainLoop
