// ATBinHex options:

{.$define NOTIF} //Enable file change notification code. Should be enabled.

{$define PRINT} //Enable printing code. Should be enabled.

{.$define SEARCH} //Enable searching code. Should be enabled.

{$define HSCROLLBAR_WORKAROUND}
                //Enable workaround for Windows bug: when horiz scrollbar temporary hides,
                //this may cause both horiz+vertical scrollbars + window border to disappear
                //completely. This workaround rises users' question: why horiz scrollbar
                //doesn't hide when lines become short enough. Should be enabled.

//{$define DEBUG_FORM}
                //Show debug form. Must be commented in release!
                
                
//lcl

{.$define DEBUG_ATBINHEX}
{$ifdef Windows}
  {$define EnableSelection}
{$endif}
     
