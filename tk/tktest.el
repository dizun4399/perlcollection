#! /usr/bin/perl -w

use Tk;
use strict;

my $mw=MainWindow->new;
$mw->title("open file");
my $f=$mw->Frame;
my $lab=$f->Label(-text=>"select a file to open: ",
                  -anchor=>'e');
my $ent=$f->Entry(-width=>20);
my $button=$f->Button(-text=>"Browse",-command=>sub{but_openfile()});
$lab->pack(-side=>'left');
$ent->pack(-side=>'left',-expand=>'yes',-fill=>'x');
$button->pack(-side=>'left');
$f->pack(-fill=>'x',-padx=>'1c',-pady=>3);
MainLoop;

sub but_openfile {
  my $types;
  my $file;
  my @types=
    (["Text files",         [qw/.txt .doc/]],
     ["Text files",         '',             'TEXT'],
     ["Perl Scripts",       '.pl',          'TEXT'],
     ["C Source Files",     ['.c', '.h']],
     ["Image Files",        '.gif'],
     ["Image Files",        ['.jpeg', '.jpg']],
     ["Image Files",        '',             [qw/GIFF JPEG/]],
     ["All files",          '*']
    );
  $file=$mw->getOpenFile(-filetypes=>\@types);

  if (defined $file and $file ne '') {
      $ent->delete(0,'end');
      $ent->insert(0,$file);
      $ent->xview('end');
  }
}
