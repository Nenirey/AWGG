
{$IFDEF LCLGTK}
  {$i uses_gtk.inc}
{$ENDIF}

{$IFDEF LCLGTK2}  
  {$i uses_gtk2.inc}
{$ENDIF}

{$IFDEF LCLCarbon}  
  {$i uses_carbon.inc}  
{$ENDIF}

{$IFDEF LCLCocoa}   
  {$i uses_cocoa.inc}  
{$ENDIF}

{$IFDEF LCLWin32}  
  {$i uses_win32.inc} 
{$ENDIF}

{$IFDEF LCLQT}  
  {$i uses_qt.inc} 
{$ENDIF}

{$IFDEF LCLWince}
  {$i uses_wince.inc}
{$ENDIF}

