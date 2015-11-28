unit filechannel;

{ Copyright (C) 2006 Luiz Américo Pereira Câmara

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}
{$ifdef fpc}
{$mode objfpc}{$H+}
{$endif}

interface

uses
  {$ifndef fpc}fpccompat,{$endif} Classes, SysUtils, multilog;

type

  TFileChannelOption = (fcoShowHeader, fcoShowPrefix, fcoShowTime);

  TFileChannelOptions = set of TFileChannelOption;

  { TFileChannel }

  TFileChannel = class (TLogChannel)
  private
    FFileHandle: Text;
    FFileName: String;
    FRelativeIdent: Integer;
    FBaseIdent: Integer;
    FShowHeader: Boolean;
    FShowTime: Boolean;
    FShowPrefix: Boolean;
    procedure SetShowTime(const AValue: Boolean);
    procedure UpdateIdentation;
    procedure WriteStrings(AStream: TStream);
    procedure WriteComponent(AStream: TStream);
  public
    constructor Create (const AFileName: String; ChannelOptions: TFileChannelOptions = [fcoShowHeader, fcoShowTime]);
    procedure Clear; override;
    procedure Deliver(const AMsg: TLogMessage);override;
    procedure Init; override;
    property ShowHeader: Boolean read FShowHeader write FShowHeader;
    property ShowPrefix: Boolean read FShowPrefix write FShowPrefix;
    property ShowTime: Boolean read FShowTime write SetShowTime;
  end;

implementation

const
  LogPrefixes: array [ltInfo..ltCounter] of String = (
    'INFO',
    'ERROR',
    'WARNING',
    'VALUE',
    '>>ENTER METHOD',
    '<<EXIT METHOD',
    'CONDITIONAL',
    'CHECKPOINT',
    'STRINGS',
    'CALL STACK',
    'OBJECT',
    'EXCEPTION',
    'BITMAP',
    'HEAP INFO',
    'MEMORY',
    '','','','','',
    'WATCH',
    'COUNTER');

{ TFileChannel }

procedure TFileChannel.UpdateIdentation;
var
  S:String;
begin
  S:='';
  if FShowTime then
    S:=FormatDateTime('hh:nn:ss:zzz',Time);
  FBaseIdent:=Length(S)+3;
end;

procedure TFileChannel.SetShowTime(const AValue: Boolean);
begin
  FShowTime:=AValue;
  UpdateIdentation;
end;

procedure TFileChannel.WriteStrings(AStream: TStream);
var
  i: Integer;
begin
  if AStream.Size = 0 then Exit;
  with TStringList.Create do
  try
    AStream.Position:=0;
    LoadFromStream(AStream);
    for i:= 0 to Count - 1 do
      WriteLn(FFileHandle,Space(FRelativeIdent+FBaseIdent)+Strings[i]);
  finally
    Destroy;
  end;
end;

procedure TFileChannel.WriteComponent(AStream: TStream);
var
  TextStream: TStringStream;
begin
  TextStream:=TStringStream.Create('');
  AStream.Seek(0,soFromBeginning);
  ObjectBinaryToText(AStream,TextStream);
  //todo: better handling of format
  Write(FFileHandle,TextStream.DataString);
  TextStream.Destroy;
end;

constructor TFileChannel.Create(const AFileName: String; ChannelOptions: TFileChannelOptions);
begin
  FShowPrefix := fcoShowPrefix in ChannelOptions;
  FShowTime := fcoShowTime in ChannelOptions;
  FShowHeader := fcoShowHeader in ChannelOptions;
  Active := True;
  FFileName := AFileName;
end;

procedure TFileChannel.Clear;
begin
  Rewrite(FFileHandle);
end;

procedure TFileChannel.Deliver(const AMsg: TLogMessage);
begin
  //Exit method identation must be set before
  if (AMsg.MsgType = ltExitMethod) and (FRelativeIdent >= 2) then
    Dec(FRelativeIdent, 2);
  Append(FFileHandle);
  try
    if FShowTime then
      Write(FFileHandle, FormatDateTime('hh:nn:ss:zzz', AMsg.MsgTime) + ' ');
    Write(FFileHandle, Space(FRelativeIdent));
    if FShowPrefix then
      Write(FFileHandle, LogPrefixes[AMsg.MsgType] + ': ');
    Writeln(FFileHandle, AMsg.MsgText);
    if AMsg.Data <> nil then
    begin
      case AMsg.MsgType of
        ltStrings, ltCallStack, ltHeapInfo, ltException: WriteStrings(AMsg.Data);
        ltObject: WriteComponent(AMsg.Data);
      end;
    end;
  finally
    Close(FFileHandle);
    //Update enter method identation
    if AMsg.MsgType = ltEnterMethod then
      Inc(FRelativeIdent, 2);
  end;
end;

procedure TFileChannel.Init;
begin
  Assign(FFileHandle,FFileName);
  if FileExists(FFileName) then
    Append(FFileHandle)
  else
    Rewrite(FFileHandle);
  if FShowHeader then
    WriteLn(FFileHandle,'=== Log Session Started at ',DateTimeToStr(Now),' by ',ApplicationName,' ===');
  Close(FFileHandle);
  UpdateIdentation;
end;

end.

