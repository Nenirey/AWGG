unit ATxSProcFPC;

{
Original work by Alexey Torgashin
LCL port: Luiz Americo Pereira Camara
}


{$mode objfpc}{$H+}

interface

uses
  SysUtils;
   
procedure SDelLastSpaceW(var S: WideString);
function SFormatW(const Msg: WideString; Params: array of WideString): WideString;
procedure SReplaceAllW(var S: WideString; const SFrom, STo: WideString);
function SReplaceTabsW(const S: WideString; TabSize: word): WideString;
procedure SReplaceW(var S: WideString; const SFrom, STo: WideString);
procedure SReplaceZerosW(var S: WideString);
procedure SReplaceZeros(var S: String);
function SetStringW(Buffer: PChar; BufSize: integer; SwapBytes: boolean): WideString;
procedure SToLowerW(var S: WideString);
procedure SToLower(var S: String);

function ToANSI(const S: string): string;

function SFindText(const F, S: string; fForward, fWholeWords, fCaseSens, fLastBlock: boolean): integer;
function SFindTextW(const F, S: WideString; fForward, fWholeWords, fCaseSens, fLastBlock: boolean): integer;


function IMin(n1, n2: integer): integer;
function IMax(n1, n2: integer): integer;
function WMin(n1, n2: word): word;
function WMax(n1, n2: word): word;
function I64Min(const n1, n2: Int64): Int64;
function I64Max(const n1, n2: Int64): Int64;


procedure ILimitMin(var N: integer; Value: integer);
procedure ILimitMax(var N: integer; Value: integer);
procedure WLimitMin(var N: word; Value: word);
procedure WLimitMax(var N: word; Value: word);
procedure I64LimitMin(var N: Int64; const Value: Int64);
procedure I64LimitMax(var N: Int64; const Value: Int64);


implementation

function SDefaultDelimiters: string;
const
  Chars = ':;<=>?' + '@[\]^' + '`{|}~';
var
  i: integer;
begin
  Result:= '';
  for i:= 0 to Ord('/') do
    Result:= Result+Chr(i);
  Result:= Result+Chars;
end;

function SEquals(Buf1, Buf2: PChar; BufSize: integer): boolean;
var
  i: integer;
begin
  Result:= true;
  for i:= 0 to BufSize-1 do
    if Buf1[i]<>Buf2[i] then
      begin Result:= false; Break end;
end;

function SEqualsW(Buf1, Buf2: PWideChar; BufSize: integer): boolean;
var
  i: integer;
begin
  Result:= true;
  for i:= 0 to BufSize-1 do
    if Buf1[i]<>Buf2[i] then
      begin Result:= false; Break end;
end;


function SFillW(ch: WideChar; Count: integer): WideString;
var
  i: integer;
begin
  SetLength(Result, Count);
  for i:= 1 to Length(Result) do
    Result[i]:= ch;
end;

procedure SDelLastSpaceW(var S: WideString);
begin
  if (S<>'') and ((S[Length(S)]=' ') or (S[Length(S)]=#9)) then
    SetLength(S, Length(S)-1);
end;

function SFormatW(const Msg: WideString; Params: array of WideString): WideString;
var
  i: integer;
begin
  Result:= Msg;
  for i:= Low(Params) to High(Params) do
    SReplaceW(Result, '%s', Params[i]);
end;

procedure SReplaceAllW(var S: WideString; const SFrom, STo: WideString);
var
  i: integer;
begin
  repeat
    i:= Pos(SFrom, S);
    if i=0 then Break;
    Delete(S, i, Length(SFrom));
    Insert(STo, S, i);
  until false;
end;

function SReplaceTabsW(const S: WideString; TabSize: word): WideString;
begin
  Result:= S;
  SReplaceAllW(Result, #9, SFillW(' ', TabSize));
end;

procedure SReplaceW(var S: WideString; const SFrom, STo: WideString);
var
  i: integer;
begin
  i:= Pos(SFrom, S);
  if i>0 then
    begin
    Delete(S, i, Length(SFrom));
    Insert(STo, S, i);
    end;
end;

procedure SReplaceZeros(var S: string);
var
  i: integer;
begin
  for i:= 1 to Length(S) do
    if S[i]=#0 then S[i]:= ' ';
end;

procedure SReplaceZerosW(var S: WideString);
var
  i: integer;
begin
  for i:= 1 to Length(S) do
    if S[i]=#0 then S[i]:= ' ';
end;

function SetStringW(Buffer: PChar; BufSize: integer; SwapBytes: boolean): WideString;
var
  P: PChar;
  i, j: integer;
  ch: char;
begin
  Result:= '';
  if BufSize<2 then Exit;
  SetLength(Result, BufSize div 2);
  Move(Buffer^, Result[1], Length(Result)*2);
  if SwapBytes then
    begin
    P:= @Result[1];
    for i:= 1 to Length(Result) do
      begin
      j:= (i-1)*2;
      ch:= P[j];
      P[j]:= P[j+1];
      P[j+1]:= ch;
      end;
    end;
end;

procedure SToLower(var S: string);
begin
  S:=LowerCase(S);
end;

procedure SToLowerW(var S: WideString);
begin
  S:=WideLowerCase(S);
end;

function ToANSI(const S: string): string;
begin
  //todo
  Result:=S;
  //SetLength(Result, Length(S));
  //OemToCharBuff(PChar(S), PChar(Result), Length(S));
end;


function SFindText(const F, S: string; fForward, fWholeWords, fCaseSens, fLastBlock: boolean): integer;
var
  SBuf, FBuf, Delimiters: string;
  Match: boolean;
  LastPos, i: integer;
begin
  Result:= 0;
  if (S='') or (F='') then Exit;

  Delimiters:= SDefaultDelimiters;

  SBuf:= S;
  FBuf:= F;
  if not fCaseSens then
    begin
    SToLower(SBuf);
    SToLower(FBuf);
    end;

  LastPos:= Length(S)-Length(F)+1;

  if fForward then
    //Search forward
    for i:= 1 to LastPos do
      begin
      Match:= SEquals(@FBuf[1], @SBuf[i], Length(FBuf));

      if fWholeWords then
        Match:= Match
          and (fLastBlock or (i<LastPos))
          and ((i<=1) or (Pos(S[i-1], Delimiters)>0))
          and ((i>=LastPos) or (Pos(S[i+Length(F)], Delimiters)>0));

      if Match then
        begin
        Result:= i;
        Break
        end;
      end
    else
    //Search backward
    for i:= LastPos downto 1 do
      begin
      Match:= SEquals(@FBuf[1], @SBuf[i], Length(FBuf));

      if fWholeWords then
        Match:= Match
          and (fLastBlock or (i>1))
          and ((i<=1) or (Pos(S[i-1], Delimiters)>0))
          and ((i>=LastPos) or (Pos(S[i+Length(F)], Delimiters)>0));

      if Match then
        begin
        Result:= i;
        Break
        end;
      end;
end;

function SFindTextW(const F, S: WideString; fForward, fWholeWords, fCaseSens, fLastBlock: boolean): integer;
var
  SBuf, FBuf, Delimiters: WideString;
  Match: boolean;
  LastPos, i: integer;
begin
  Result:= 0;
  if (S='') or (F='') then Exit;

  Delimiters:= SDefaultDelimiters;

  SBuf:= S;
  FBuf:= F;
  if not fCaseSens then
    begin
    SToLowerW(SBuf);
    SToLowerW(FBuf);
    end;

  LastPos:= Length(S)-Length(F)+1;

  if fForward then
    //Search forward
    for i:= 1 to LastPos do
      begin
      Match:= SEqualsW(@FBuf[1], @SBuf[i], Length(FBuf));

      if fWholeWords then
        Match:= Match
          and (fLastBlock or (i<LastPos))
          and ((i<=1) or (Pos(S[i-1], Delimiters)>0))
          and ((i>=LastPos) or (Pos(S[i+Length(F)], Delimiters)>0));

      if Match then
        begin
        Result:= i;
        Break
        end;
      end
    else
    //Search backward
    for i:= LastPos downto 1 do
      begin
      Match:= SEqualsW(@FBuf[1], @SBuf[i], Length(FBuf));

      if fWholeWords then
        Match:= Match
          and (fLastBlock or (i>1))
          and ((i<=1) or (Pos(S[i-1], Delimiters)>0))
          and ((i>=LastPos) or (Pos(S[i+Length(F)], Delimiters)>0));

      if Match then
        begin
        Result:= i;
        Break
        end;
      end;
end;



function IMin(n1, n2: integer): integer;
begin
  if n1<n2 then Result:= n1 else Result:= n2;
end;

function IMax(n1, n2: integer): integer;
begin
  if n1>n2 then Result:= n1 else Result:= n2;
end;

function WMin(n1, n2: word): word;
begin
  if n1<n2 then Result:= n1 else Result:= n2;
end;

function WMax(n1, n2: word): word;
begin
  if n1>n2 then Result:= n1 else Result:= n2;
end;

function I64Min(const n1, n2: Int64): Int64;
begin
  if n1<n2 then Result:= n1 else Result:= n2;
end;

function I64Max(const n1, n2: Int64): Int64;
begin
  if n1>n2 then Result:= n1 else Result:= n2;
end;

procedure ILimitMin(var N: integer; Value: integer);
begin
  if N<Value then N:= Value;
end;

procedure ILimitMax(var N: integer; Value: integer);
begin
  if N>Value then N:= Value;
end;

procedure WLimitMin(var N: word; Value: word);
begin
  if N<Value then N:= Value;
end;

procedure WLimitMax(var N: word; Value: word);
begin
  if N>Value then N:= Value;
end;

procedure I64LimitMin(var N: Int64; const Value: Int64);
begin
  if N < Value then
    N := Value;
end;

procedure I64LimitMax(var N: Int64; const Value: Int64);
begin
  if N > Value then
    N := Value;
end;

end.

