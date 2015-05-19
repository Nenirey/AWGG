unit ATxClipboardFPC;

{
Original work by Alexey Torgashin
LCL port: Luiz Americo Pereira Camara
}


{$mode objfpc}{$H+}

interface

uses
  lclext, DelphiCompat, LCLIntf, Classes, SysUtils, Clipbrd;

function SClearClipboard: boolean;
function SCopyToClipboard(const S: AnsiString; IsOEM: boolean = false): boolean;
function SCopyToClipboardW(const S: WideString): boolean;


implementation

function SClearClipboard: boolean;
begin
  //not necessary in LCL
  //Result:= EmptyClipboard;
end;

function SCopyToClipboardW_NT(const S: WideString; DoClear: boolean): boolean;
var
  DataSize: integer;
begin
  DataSize:= (Length(S)+1) * 2;
  if DoClear then
    Clipboard.Clear;
  //CF_UNICODETEXT returns Windows.CF_UNICODETEXT
  Clipboard.AddFormat(CF_UNICODETEXT,PWideChar(S)^,DataSize);
  Result:= True;
end;

function SCopyToClipboard(const S: AnsiString; IsOEM: boolean = false): boolean;
begin
  //todo: Implement OEM support
  Clipboard.AsText:=S;
  Result:=True;
end;


function SCopyToClipboardW(const S: WideString): boolean;
begin
  if OSSupportsUTF16 then
    Result:= SCopyToClipboardW_NT(S, True)
  else
    Result:= SCopyToClipboard(UTF8Encode(S));
end;


end.

