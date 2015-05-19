unit fpccompat;

{Unit with functions and classes not found in Delphi}

interface

uses
  Classes, sysutils;
  
const
  LineEnding = #13#10;

type
  PtrInt = LongInt;
  TFpList = TList;

function Space (b : Byte): String;

function ApplicationName: String;

implementation

function Space (b : Byte): String;
begin
  SetLength(Result,b);
  FillChar(Result[1],b,' ');
end;

function ApplicationName: String;
begin
  Result := ExtractFileName(ParamStr(0));
end;

end.
