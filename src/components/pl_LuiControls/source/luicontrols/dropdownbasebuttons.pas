unit DropDownBaseButtons;

{
  Base DropDown buttons

  Copyright (C) 2012 Luiz Américo Pereira Câmara
  luizmed@oi.com.br

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
{.define DEBUG_MENUBUTTON}

interface


uses
  LCLType, LCLProc, Types, Forms, Classes, SysUtils, Buttons, Menus, LMessages, Controls, ActnList, Graphics
  {$ifdef DEBUG_MENUBUTTON}, sharedlogger {$endif};

type

  TCustomDropDownButton = class;

  TDropDownButtonOption =
  (
    dboPopupOnMouseUp,    // popped in MouseUp event
    dboShowIndicator
  );
  
  TDropDownButtonStyle = (dbsSingle, dbsCombo);
  
  TDropDownButtonOptions = set of TDropDownButtonOption;

  TArrowCoordinates = (acLeft, acRight, acBottom);
  TArrowPoints = array[TArrowCoordinates] of TPoint;
  
  { TToggleSpeedButton }

  TToggleSpeedButton = class (TCustomSpeedButton)
  private
    FArrowPoints: TArrowPoints;
    FInternalDown: Boolean;
    FToggleMode: Boolean;
    FUpdateLocked: Boolean;
    FForceInvalidate: Boolean;
    procedure CalculateArrowPoints(XOffset, AWidth, AHeight: Integer);
    procedure WMLButtonDown(var Message: TLMLButtonDown); message LM_LBUTTONDOWN;
  protected
    {$ifdef DEBUG_MENUBUTTON}
    procedure Invalidate; override;
    {$endif}
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure ResetState;
    procedure UpdateDown(Value: Boolean);
    procedure UpdateState(InvalidateOnChange: Boolean); override;
    procedure DoButtonDown; virtual; abstract;
  public
    property ToggleMode: Boolean read FToggleMode write FToggleMode;
  end;

  { TArrowButton }

  TArrowButton = class (TToggleSpeedButton)
  private
    FMainButton: TCustomDropDownButton;
  protected
    procedure DoButtonDown; override;
    procedure DoSetBounds(ALeft, ATop, AWidth, AHeight: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Paint; override;
  public
    property MainButton: TCustomDropDownButton read FMainButton write FMainButton;
    property OnMouseEnter;
    property OnMouseLeave;
  end;

  { TCustomDropDownButton }

  TCustomDropDownButton = class (TToggleSpeedButton)
  private
    FArrowButton: TArrowButton;
    FClientWidth: Integer;
    FContentWidth: Integer;
    FOptions: TDropDownButtonOptions;
    FStyle: TDropDownButtonStyle;
    procedure ArrowEntered(Sender: TObject);
    procedure ArrowLeaved(Sender: TObject);
    procedure DelayedUnlock(Data: PtrInt);
    procedure SetOptions(const AValue: TDropDownButtonOptions);
    procedure SetStyle(const AValue: TDropDownButtonStyle);
    procedure UpdateArrowPosition;
    procedure UpdateDropDown(IsButtonDown: Boolean);
    procedure UpdateStyle;
  protected
    procedure DoButtonDown; override;
    procedure DoShowDropDown; virtual;
    procedure DoHideDropDown; virtual;
    procedure DropDownClosed;
    function GetGlyphSize(Drawing: Boolean; PaintRect: TRect): TSize; override;
    function GetTextSize(Drawing: Boolean; PaintRect: TRect): TSize; override;
    procedure Loaded; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Paint; override;
  public
    destructor Destroy; override;
    procedure Click; override;
  published
    property Options: TDropDownButtonOptions read FOptions write SetOptions default [];
    property Style: TDropDownButtonStyle read FStyle write SetStyle default dbsSingle;
    //TSpeedButton properties
    property Action;
    property Align;
    property Anchors;
    property AllowAllUp;
    property BorderSpacing;
    property Constraints;
    property Caption;
    property Color;
    property Down;
    property Enabled;
    property Flat;
    property Font;
    property Glyph;
    property GroupIndex;
    property Layout;
    property Margin;
    property NumGlyphs;
    property Spacing;
    property Transparent;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnPaint;
    property OnResize;
    property OnChangeBounds;
    property ShowCaption;
    property ShowHint;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
  end;

implementation

uses
  Math;

function SuccPoint(const P: TPoint): TPoint;
begin
  Result := Point(P.x+1,P.y+1);
end;

{ TCustomDropDownButton }

procedure TCustomDropDownButton.DoShowDropDown;
begin
  //
end;

procedure TCustomDropDownButton.DoHideDropDown;
begin
  //
end;

procedure TCustomDropDownButton.UpdateArrowPosition;
var
  XOffset: Integer;
begin
  if Margin = -1 then
  begin
    XOffset := (FClientWidth - FContentWidth) div 2;
    if XOffset >= 6 then
      Dec(XOffset, 1)
    else
      Dec(XOffset, 2);
  end
  else
  begin
    if Glyph.Empty then
      XOffset := Margin + 2
    else
      XOffset := Margin + 7;
  end;
  CalculateArrowPoints(FContentWidth + XOffset, 10, Height)
end;

procedure TCustomDropDownButton.UpdateDropDown(IsButtonDown: Boolean);
begin
  if IsButtonDown then
    DoShowDropDown
  else
    DoHideDropDown;
end;

procedure TCustomDropDownButton.UpdateStyle;
var
  ArrowWidth: Integer;
begin
  if FStyle = dbsCombo then
  begin
    if FArrowButton = nil then
    begin
      FArrowButton := TArrowButton.Create(nil);
      with FArrowButton do
      begin
        //ControlStyle := ControlStyle + [csNoDesignSelectable];
        MainButton := Self;
        OnMouseEnter := @ArrowEntered;
        OnMouseLeave := @ArrowLeaved;
        ToggleMode := True;
        Parent := Self.Parent;
        Flat := Self.Flat;
        ArrowWidth := EnsureRange(Self.Width div 3, 10, 14);
        if Odd(ArrowWidth) then
          Inc(ArrowWidth);
        Width := ArrowWidth;
        AnchorToCompanion(akLeft, 0, Self);
      end;
    end;
    ToggleMode := False;
    FArrowButton.Visible := True;
  end
  else
  begin
    if FArrowButton <> nil then
      FArrowButton.Visible := False;
    ToggleMode := True;
  end;
end;

procedure TCustomDropDownButton.DoButtonDown;
begin
  if FStyle = dbsCombo then
    Click
  else
    if not (dboPopupOnMouseUp in FOptions) then
      UpdateDropDown(FInternalDown);
end;

function TCustomDropDownButton.GetGlyphSize(Drawing: Boolean; PaintRect: TRect): TSize;
begin
  Result := inherited GetGlyphSize(Drawing, PaintRect);
  if (FStyle = dbsSingle) and (dboShowIndicator in FOptions) then
  begin
    FClientWidth := PaintRect.Right - PaintRect.Left;
    if Layout in [blGlyphLeft, blGlyphRight] then
      Inc(FContentWidth, Result.cx);
    if not ShowCaption or (Caption = '') then
      Inc(Result.Cx, 6);
  end;
end;

function TCustomDropDownButton.GetTextSize(Drawing: Boolean; PaintRect: TRect): TSize;
begin
  Result := inherited GetTextSize(Drawing, PaintRect);
  if (FStyle = dbsSingle) and (dboShowIndicator in FOptions) then
  begin
    Inc(FContentWidth, Result.Cx);
    if Result.cx > 0 then
    begin
      //if no glyph the returned text width must be smaller
      if Result.cx = FContentWidth then
        Inc(Result.cx, 6)
      else
        Inc(Result.cx, 12);
    end;
  end;
end;

procedure TCustomDropDownButton.Loaded;
begin
  inherited Loaded;
  UpdateStyle;
end;

procedure TCustomDropDownButton.MouseEnter;
begin
  inherited MouseEnter;
  if FArrowButton <> nil then
    FArrowButton.MouseEnter;
end;

procedure TCustomDropDownButton.MouseLeave;
begin
  inherited MouseLeave;
  if FArrowButton <> nil then
    FArrowButton.MouseLeave;
end;

procedure TCustomDropDownButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if (dboPopupOnMouseUp in FOptions) and (Button = mbLeft) then
    UpdateDropDown(FInternalDown);
end;

procedure TCustomDropDownButton.Paint;
begin
  FContentWidth := 0;
  inherited Paint;
  if (FStyle = dbsSingle) and (dboShowIndicator in FOptions) then
  begin
    UpdateArrowPosition;
    with Canvas do
    begin
      Brush.Color := clBlack;
      if FState = bsDown then
        Polygon([SuccPoint(FArrowPoints[acLeft]), SuccPoint(FArrowPoints[acRight]),
          SuccPoint(FArrowPoints[acBottom])])
      else
        Polygon([FArrowPoints[acLeft], FArrowPoints[acRight], FArrowPoints[acBottom]]);
    end;
  end;
end;

procedure TCustomDropDownButton.ArrowEntered(Sender: TObject);
begin
  inherited MouseEnter;
end;

procedure TCustomDropDownButton.ArrowLeaved(Sender: TObject);
begin
  inherited MouseLeave;
end;

procedure TCustomDropDownButton.DelayedUnlock(Data: PtrInt);
begin
  if csDestroying in ComponentState then
    Exit;
  FUpdateLocked := False;
  if FStyle = dbsCombo then
    FArrowButton.FUpdateLocked := False;
end;

procedure TCustomDropDownButton.DropDownClosed;
begin
  {$ifdef DEBUG_MENUBUTTON}
  Logger.EnterMethod('DropDownClosed');
  {$endif}
  if FStyle = dbsCombo then
  begin
    FArrowButton.FUpdateLocked := True;
    FArrowButton.ResetState
  end
  else
  begin
    FUpdateLocked := True;
    ResetState;
  end;
  Application.QueueAsyncCall(@DelayedUnlock, 0);
  {$ifdef DEBUG_MENUBUTTON}
  Logger.ExitMethod('DropDownClosed');
  {$endif}
end;

procedure TCustomDropDownButton.SetOptions(const AValue: TDropDownButtonOptions);
begin
  if FOptions = AValue then
    Exit;
  FOptions := AValue;
  UpdateStyle;
end;

procedure TCustomDropDownButton.SetStyle(const AValue: TDropDownButtonStyle);
begin
  if FStyle = AValue then
    Exit;
  FStyle := AValue;
  if not (csLoading in ComponentState) then
    UpdateStyle;
end;

destructor TCustomDropDownButton.Destroy;
begin
  FArrowButton.Free;
  inherited Destroy;
end;

procedure TCustomDropDownButton.Click;
begin
  //skips Click event in mbsSingle style
  if FStyle = dbsCombo then
    inherited Click;
end;

{ TArrowButton }

procedure TArrowButton.DoSetBounds(ALeft, ATop, AWidth, AHeight: integer);
begin
  inherited;
  CalculateArrowPoints(0, AWidth, AHeight);
end;

procedure TArrowButton.DoButtonDown;
begin
  if not (dboPopupOnMouseUp in MainButton.Options) then
    MainButton.UpdateDropDown(FInternalDown);
end;

procedure TArrowButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if (Button = mbLeft) and (dboPopupOnMouseUp in MainButton.Options) then
    MainButton.UpdateDropDown(FInternalDown);
end;

procedure TArrowButton.Paint;
begin
  inherited Paint;
  with Canvas do
  begin
    Brush.Color := clBlack;
    if FState = bsDown then
      Polygon([SuccPoint(FArrowPoints[acLeft]), SuccPoint(FArrowPoints[acRight]),
        SuccPoint(FArrowPoints[acBottom])])
    else
      Polygon([FArrowPoints[acLeft], FArrowPoints[acRight], FArrowPoints[acBottom]]);
  end;
end;

{ TToggleSpeedButton }

procedure TToggleSpeedButton.CalculateArrowPoints(XOffset, AWidth,
  AHeight: Integer);
var
  ArrowTop, ArrowWidth: Integer;
begin
  ArrowWidth := (AWidth - 1) div 2;
  if Odd(ArrowWidth) then
    Dec(ArrowWidth);
  ArrowTop := (AHeight - (ArrowWidth div 2)) div 2;
  with FArrowPoints[acLeft] do
  begin
    X := ((AWidth - ArrowWidth) div 2) - 1 + XOffset;
    Y := ArrowTop;
  end;
  with FArrowPoints[acRight] do
  begin
    X := FArrowPoints[acLeft].X + ArrowWidth;
    Y := ArrowTop;
  end;
  with FArrowPoints[acBottom] do
  begin
    X := FArrowPoints[acLeft].X + (ArrowWidth div 2);
    Y := ArrowTop + (ArrowWidth div 2);
  end;
end;

procedure TToggleSpeedButton.WMLButtonDown(var Message: TLMLButtonDown);
begin
  {$ifdef DEBUG_MENUBUTTON}
  Logger.EnterMethod('WMLButton');
  {$endif}
  Include(FControlState, csClicked);
  if not FToggleMode then
  begin
    //Note: this calls TControl.WMLButtonDown and not TCustomSpeedButton one
    inherited WMLButtonDown(Message);
  end
  else
  begin
    if FUpdateLocked then
    begin
      FUpdateLocked := False;
      Exit;
    end;
    if Enabled then
    begin
      FInternalDown := not FInternalDown;
      {$ifdef DEBUG_MENUBUTTON}
      Logger.Send('FInternalDown',FInternalDown);
      {$endif}
      if (Action is TCustomAction) then
        TCustomAction(Action).Checked := FInternalDown;
      UpdateState(True);
      DoButtonDown;
      //FDragging := True;
    end;
  end;
  {$ifdef DEBUG_MENUBUTTON}
  Logger.ExitMethod('WMLButton');
  {$endif}
end;

{$ifdef DEBUG_MENUBUTTON}
procedure TToggleSpeedButton.Invalidate;
begin
  inherited Invalidate;
  Logger.SendCallStack(Self.ClassName + '.Invalidate');
end;
{$endif}

procedure TToggleSpeedButton.MouseEnter;
begin
  FForceInvalidate := True;
  inherited MouseEnter;
  FForceInvalidate := False;
end;

procedure TToggleSpeedButton.MouseLeave;
begin
  FForceInvalidate := True;
  inherited MouseLeave;
  FForceInvalidate := False;
end;

procedure TToggleSpeedButton.ResetState;
begin
  FInternalDown := False;
  UpdateState(True);
end;

procedure TToggleSpeedButton.UpdateDown(Value: Boolean);
begin
  Down := Value;
  FInternalDown := Value;
end;

const
  UpState: array[Boolean] of TButtonState =
  (
{False} bsUp, // mouse in control = false
{True } bsHot // mouse in contorl = true
  );

procedure TToggleSpeedButton.UpdateState(InvalidateOnChange: boolean);
var
  OldState: TButtonState;
begin
  {$ifdef DEBUG_MENUBUTTON}
  Logger.EnterMethod('UpdateState');
  //Logger.SendCallStack('Stack');
  {$endif}
  if not FToggleMode then
    inherited UpdateState(InvalidateOnChange)
  else
  begin
    if Enabled then
    begin
      OldState := FState;
      if FInternalDown then
        FState := bsDown
      else
        FState := UpState[MouseInControl];
    end;
    if InvalidateOnChange and ((OldState <> FState) or FForceInvalidate) then
      Invalidate;
  end;
  {$ifdef DEBUG_MENUBUTTON}
  Logger.ExitMethod('UpdateState');
  {$endif}
end;

end.

