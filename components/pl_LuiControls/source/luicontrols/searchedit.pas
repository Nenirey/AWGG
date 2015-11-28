unit SearchEdit;

{
  Implements TSearchEdit

  Copyright (C) 2007 Luiz Américo Pereira Câmara
  pascalive@bol.com.br

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
{.$define DEBUG_SEARCHEDIT}

interface

uses
  Forms, Classes, SysUtils, Controls, StdCtrls, LMessages, LCLProc, Graphics, ExtCtrls
  {$ifdef DEBUG_SEARCHEDIT}, sharedlogger, ipcchannel {$endif};

type

  TSearchEditOption = (
    seoExecuteEmpty,
    seoExecuteOnKillFocus
  );
  
  TSearchEditOptions = set of TSearchEditOption;
  
  { TSearchEdit }

  TSearchEdit = class (TCustomEdit)
  private
    FEmptyText: String;
    FOnExecute: TNotifyEvent;
    FOptions: TSearchEditOptions;
    FTimer: TTimer;
    FIsEmpty: Boolean;
    FSettingText: Boolean;
    procedure ClearEmptyText;
    procedure DisplayEmptyText;
    function GetExecuteDelay: Integer;
    procedure OnTimer(Sender: TObject);
    procedure SetEmptyText(const AValue: String);
    procedure SetExecuteDelay(const AValue: Integer);
  protected
    procedure Change; override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure Loaded; override;
    function RealGetText: TCaption; override;
    procedure RealSetText(const Value: TCaption); override;
    procedure WMSetFocus(var Message: TLMSetFocus); message LM_SETFOCUS;
    procedure WMKillFocus(var Message: TLMKillFocus); message LM_KILLFOCUS;
  public
    property AutoSelected;
    procedure Execute;
    property IsEmpty: Boolean read FIsEmpty;
  published
    property EmptyText: String read FEmptyText write SetEmptyText;
    property ExecuteDelay: Integer read GetExecuteDelay write SetExecuteDelay default 0;
    property OnExecute: TNotifyEvent read FOnExecute write FOnExecute;
    property Options: TSearchEditOptions read FOptions write FOptions default [];
    //TEdit properties
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property AutoSelect;
    property BidiMode;
    property BorderSpacing;
    property Color;
    property Constraints;
    property CharCase;
    property DragCursor;
    property DragMode;
    property EchoMode;
    property Enabled;
    property Font;
    property MaxLength;
    property ParentBidiMode;
    property OnChange;
    property OnChangeBounds;
    property OnClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditingDone;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDrag;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabStop;
    property TabOrder;
    property Text;
    property Visible;
  end;

implementation

uses
  LCLType;

{ TSearchEdit }

procedure TSearchEdit.ClearEmptyText;
begin
  inherited RealSetText('');
  Font.Color := clWindowText;
end;

procedure TSearchEdit.DisplayEmptyText;
begin
  Font.Color := clGray;
  inherited RealSetText(FEmptyText);
end;

function TSearchEdit.GetExecuteDelay: Integer;
begin
  if FTimer = nil then
    Result := 0
  else
    Result := FTimer.Interval;
end;

procedure TSearchEdit.OnTimer(Sender: TObject);
begin
  Execute;
end;

procedure TSearchEdit.SetEmptyText(const AValue: String);
begin
  if FEmptyText = AValue then
    Exit;
  FEmptyText := AValue;
  if FIsEmpty then
    inherited RealSetText(FEmptyText);
end;

procedure TSearchEdit.SetExecuteDelay(const AValue: Integer);
begin
  if FTimer = nil then
  begin
    FTimer := TTimer.Create(Self);
    FTimer.OnTimer := @OnTimer;
    FTimer.Enabled := False;
  end;
  FTimer.Interval := AValue;
end;

procedure TSearchEdit.Change;
begin
  {$ifdef DEBUG_SEARCHEDIT}
  Logger.SendCallStack('TextChanged');
  Logger.Send('IsEmpty', FIsEmpty);
  {$endif}
  FIsEmpty := Trim(RealGetText) = '';
  if (FTimer <> nil) and not FSettingText then
  begin
    FTimer.Enabled := False;
    FTimer.Enabled := True;
  end;
  inherited Change;
end;

procedure TSearchEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited KeyUp(Key, Shift);
  if Key = VK_RETURN then
    Execute;
end;

procedure TSearchEdit.Loaded;
begin
  inherited;
  FIsEmpty := Trim(RealGetText) = '';
  if FIsEmpty then
    DisplayEmptyText;
end;

function TSearchEdit.RealGetText: TCaption;
var
  VisibleText: String;
begin
  VisibleText := inherited RealGetText;
  if FIsEmpty and (VisibleText = FEmptyText) then
    Result := ''
  else
    Result := VisibleText;
end;

procedure TSearchEdit.RealSetText(const Value: TCaption);
begin
  {$ifdef DEBUG_SEARCHEDIT}
  Logger.SendCallStack('RealSetText');
  {$endif}
  if FIsEmpty then
    Font.Color := clWindowText;
  FSettingText := True;
  inherited RealSetText(Value);
  FSettingText := False;
end;

procedure TSearchEdit.WMSetFocus(var Message: TLMSetFocus);
begin
  {$ifdef DEBUG_SEARCHEDIT}
  Logger.EnterMethod('WMSetFocus');
  {$endif}
  //Clear the text before to avoid SelectAll call in DoEnter
  if FIsEmpty then
    ClearEmptyText;
  inherited WMSetFocus(Message);
  {$ifdef DEBUG_SEARCHEDIT}
  Logger.ExitMethod('WMSetFocus');
  {$endif}
end;

procedure TSearchEdit.WMKillFocus(var Message: TLMKillFocus);
begin
  {$ifdef DEBUG_SEARCHEDIT}
  Logger.EnterMethod('WMKillFocus');
  {$endif}
  inherited WMKillFocus(Message);
  if seoExecuteOnKillFocus in FOptions then
    Execute;
  if FIsEmpty then
    DisplayEmptyText;
  {$ifdef DEBUG_SEARCHEDIT}
  Logger.ExitMethod('WMKillFocus');
  {$endif}
end;

procedure TSearchEdit.Execute;
begin
  if FTimer <> nil then
    FTimer.Enabled := False;
  if (FOnExecute <> nil) and (not FIsEmpty or (seoExecuteEmpty in FOptions)) then
    FOnExecute(Self);
end;

initialization
  {$ifdef DEBUG_SEARCHEDIT}
  if Logger.Channels.Count = 0 then
    Logger.Channels.Add(TIPCChannel.Create);
  {$endif}

end.

