{%MainUnit delphicompat.pas}

{$IFDEF LCLGTK}
  {$i delphicompat_gtk.inc}
{$ENDIF}

{$IFDEF LCLGTK2}  
  {$i delphicompat_gtk2.inc}
{$ENDIF}

{$IFDEF LCLCarbon}  
  {$i delphicompat_carbon.inc}
{$ENDIF}

{$IFDEF LCLCocoa}  
  {$i delphicompat_cocoa.inc}
{$ENDIF}

{$IFDEF LCLWin32}  
  {$i delphicompat_win32.inc}
{$ENDIF}

{$IFDEF LCLQT}  
  {$i delphicompat_qt.inc}
{$ENDIF}

{$IFDEF LCLWince}
  {$i delphicompat_wince.inc}
{$ENDIF}
