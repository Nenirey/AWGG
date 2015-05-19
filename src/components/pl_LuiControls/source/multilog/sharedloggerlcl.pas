unit sharedloggerlcl;

{$ifdef fpc}
{$mode objfpc}{$H+}
{$endif}

interface

uses
  multiloglcl;

const
  //lc stands for LogClass
  //it's possible to define the constants to suit any need
  lcAll = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31];
  lcDebug = 0;
  lcError = 1;
  lcInfo = 2;
  lcWarning = 3;
  
  lcEvents = 4;

var
  Logger: TLclLogger;
  
implementation

initialization
  Logger:=TLclLogger.Create;
finalization
  Logger.Free;
end.

