unit LuiStrUtils; 

{
  Auxiliary string functions

  Copyright (C) 2010 Luiz Américo Pereira Câmara

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TFile }

  TFile = class
  public
     class procedure WriteAllText(const Path, Contents: string); overload; static;
  end;

function Capitalize(const U: UnicodeString; const ExcludeWords: array of UnicodeString): UnicodeString;

function Capitalize(const S: AnsiString; const ExcludeWords: array of UnicodeString): AnsiString;

function CompareNatural(s1, s2: string): Integer;

procedure ExtractNameValue(const NameValuePair: String; out Name, Value: String; Delimiter: Char = ';');

function ExtractInitials(const S: AnsiString; const ExcludeWords: array of String): AnsiString;

implementation

uses
  strutils, math;

function MatchWords(const U: UnicodeString; const A: array of UnicodeString): Boolean;
var
  i: Integer;
begin
  for i := Low(A) to High(A) do
    if A[i] = U then
      Exit(True);
  Result := False;
end;

function GetNextWord(const S: UnicodeString; var Index: Integer): UnicodeString;
var
  i,j,l: Integer;
  pc : punicodechar;
begin
  if Index > Length(S) then
  begin
    Result := '';
    Exit;
  end;

  l := length(s);
  i := Index;
  //find start of next word
  pc:=@s[Index];
  while i <= l do
  begin
    if pc^ <> ' ' then
    begin
      break;
    end;
    inc(pc);
    inc(i);
  end;

  //find end of the word
  j := i;
  while j <= l do
  begin
    if pc^ = ' ' then
    begin
      break;
    end;
    inc(pc);
    inc(j);
  end;

  Index := J + 1;
  SetLength(Result,j-i);
  If ((j-i)>0) then
    Move(S[i],Result[1],(j-i)*2);
end;

procedure UppercaseFirstChar(var U: UnicodeString);
var
  C: UnicodeString;
begin
  C := U[1];
  C := UpCase(C);
  Delete(U, 1, 1);
  Insert(C, U, 1);
end;

function Capitalize(const U: UnicodeString; const ExcludeWords: array of UnicodeString): UnicodeString;
var
  LN: Integer;
  WordIndex: Integer;
  NextWord, LowerStr: UnicodeString;
begin
  //todo: set result length once than copy the values
  Result := '';
  LowerStr := Trim(widestringmanager.LowerUnicodeStringProc(U));

  WordIndex := 1;
  NextWord := GetNextWord(LowerStr, WordIndex);
  LN := Length(NextWord);
  while LN > 0 do
  begin
    //Uppercase first letters
    if not MatchWords(NextWord, ExcludeWords) then
      UppercaseFirstChar(NextWord);
    Result := Result + NextWord;
    NextWord := GetNextWord(LowerStr, WordIndex);
    LN := Length(NextWord);
    if LN > 0 then
      Result := Result + ' ';
  end;
end;

function Capitalize(const S: AnsiString; const ExcludeWords: array of UnicodeString): AnsiString;
begin
  Result := UTF8Encode(Capitalize(UTF8Decode(S), ExcludeWords));
end;

//todo: optimize
//https://groups.google.com/forum/?fromgroups=#!topic/borland.public.delphi.language.delphi.general/bNmsT6fZLNI
function CompareNatural(s1, s2: string): integer; // by Roy M Klever

  function ExtractNr(n: integer; var txt: string): int64;
  begin
    while (n <= Length(txt)) and (txt[n] in ['0'..'9']) do
      n := n + 1;
    Result := StrToInt64Def(Copy(txt, 1, (n - 1)), 0);
    Delete(txt, 1, (n - 1));
  end;

var
  b: boolean;
begin
  Result := 0;
  s1 := LowerCase(s1);
  s2 := LowerCase(s2);
  if (s1 <> s2) and (s1 <> '') and (s2 <> '') then
  begin
    b := False;
    while (not b) do
    begin
      if ((s1[1] in ['0'..'9']) and (s2[1] in ['0'..'9'])) then
        Result := Sign(ExtractNr(1, s1) - ExtractNr(1, s2))
      else
        Result := Sign(integer(s1[1]) - integer(s2[1]));
      b := (Result <> 0) or (Min(Length(s1), Length(s2)) < 2);
      if not b then
      begin
        Delete(s1, 1, 1);
        Delete(s2, 1, 1);
      end;
    end;
  end;
  if Result = 0 then
  begin
    if (Length(s1) = 1) and (Length(s2) = 1) then
      Result := Sign(integer(s1[1]) - integer(s2[1]))
    else
      Result := Sign(Length(s1) - Length(s2));
  end;
end;


procedure ExtractNameValue(const NameValuePair: String; out Name, Value: String; Delimiter: Char);
var
  DelimiterPos: Integer;
begin
  DelimiterPos := Pos(Delimiter, NameValuePair);
  if DelimiterPos = 0 then
  begin
    Name := NameValuePair;
    Value := '';
  end
  else
  begin
    Name := Copy(NameValuePair, 1, DelimiterPos - 1);
    Value := Copy(NameValuePair, DelimiterPos + 1, Length(NameValuePair) - DelimiterPos);
  end;
end;

function ExtractInitials(const S: AnsiString;
  const ExcludeWords: array of String): AnsiString;
var
  WordIndex, WordPos: Integer;
  Word: String;
begin
  Result := '';
  WordIndex := 1;
  Word := ExtractWordPos(WordIndex, S, StdWordDelims, WordPos);
  while WordPos <> 0 do
  begin
    if not AnsiMatchText(Word, ExcludeWords) then
      Result := Result + Word[1];
    Inc(WordIndex);
    Word := ExtractWordPos(WordIndex, S, StdWordDelims, WordPos);
  end;
end;

//from http://delphi.about.com/b/2010/08/30/vigenere-cipher-algorithm-delphi-implementation-comments-by-alan-lloyd.htm
function Vigenere(const Src, Key: string; Encrypt : boolean): string;
const
  OrdMinChar : Integer = Ord('A');
  OrdMaxChar : Integer = Ord('Z');
  IncludeChars : set of char = ['A'..'Z'];
var
  CharRangeCount, i, j, KeyLen, KeyInc, SrcOrd, CryptOrd : Integer;
  SrcA : string;
begin
  CharRangeCount := OrdMaxChar - OrdMinChar + 1;
  KeyLen := Length(Key);
  SetLength(SrcA, Length(Src));
  If Encrypt then
  begin
    // transfer only included characters to SrcA for encryption
    j := 1;
    for i := 1 to Length(Src) do
      begin
      if (Src[i] in IncludeChars) then
      begin
        SrcA[j] := Src[i];
        inc(j);
      end;
    end;
    SetLength(SrcA, j - 1);
  end;
  SetLength(Result, Length(SrcA));
  if Encrypt then
    begin
    // Encrypt to Result
    for i := 1 to Length(SrcA) do
    begin
      SrcOrd := Ord(Src[i]) - OrdMinChar;
      KeyInc := Ord(Key[((i - 1 ) mod KeyLen)+ 1]) - OrdMinChar;
      CryptOrd := ((SrcOrd + KeyInc) mod CharRangeCount) + OrdMinChar;
      Result[i] := Char(CryptOrd);
    end;
  end
  else
  begin
    // Decrypt to Result
    for i := 1 to Length(SrcA) do
    begin
      SrcOrd := Ord(Src[i]) - OrdMinChar;
      KeyInc := Ord(Key[((i - 1 ) mod KeyLen)+ 1]) - OrdMinChar;
      CryptOrd := ((SrcOrd - KeyInc + CharRangeCount) mod CharRangeCount) + OrdMinChar;
      // KeyInc may be larger than SrcOrd
      Result[i] := Char(CryptOrd);
    end;
  end;
end;

{ TFile }

class procedure TFile.WriteAllText(const Path, Contents: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(Path, fmCreate);
  try
    Stream.WriteBuffer(Contents[1], Length(Contents));
  finally
    Stream.Free;
  end;
end;


end.

