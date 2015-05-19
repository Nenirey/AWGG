unit ATxFProcFPC;

{
Original work by Alexey Torgashin
LCL port: Luiz Americo Pereira Camara
}


{$mode objfpc}{$H+}

interface

{$ifdef Windows}
{$i win_ATxFProcFPCh.inc}
{$ELSE}
{$i unix_ATxFProcFPCh.inc}
{$endif}

function FFileOpen(const fn: WideString): THandle;
function FGetFileSize(Handle: THandle): Int64; overload;

implementation

function FFileOpen(const fn: WideString): THandle;
begin
 //String(fn) would work??
  Result:= FileOpen(WideCharToString(PWideChar(fn)),fmOpenRead);
end;


{$ifdef Windows}
{$i win_ATxFProcFPC.inc}
{$ELSE}
{$i unix_ATxFProcFPC.inc}
{$endif}


end.

