use Tk;
use Tk::PathEntry;
 
use Cwd;
 
$path = cwd();
 
$mw = MainWindow->new();
$mw->geometry( '300x80' );
$mw->resizable( 0, 0 );
 
$mw->PathEntry( -textvariable=>\$path )->pack;
$mw->Label( -textvariable=>\$path, -foreground=>'blue' )->pack;
$mw->Button( -text=>'Quit', -command=>sub{ exit } )->pack;
 
MainLoop;
