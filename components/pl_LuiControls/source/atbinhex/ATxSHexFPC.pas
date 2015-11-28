unit ATxSHexFPC;

{
Original work by Alexey Torgashin
LCL port: Luiz Americo Pereira Camara
}


{$mode objfpc}{$H+}

interface

uses
  SysUtils;

function SToHex(const s: string): string;

implementation

function SToHex(const s: string): string;
var
  i: integer;
begin
  Result:= '';
  for i:= 1 to Length(s) do
    Result:= Result+IntToHex(Ord(s[i]), 2)+' ';
  if Result<>'' then
    Delete(Result, Length(Result), 1);
end;

end.

