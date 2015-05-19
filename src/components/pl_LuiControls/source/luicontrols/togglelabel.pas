unit ToggleLabel;

{
  Implements TToggleLabel

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

interface

uses
  Classes, SysUtils, Controls, StdCtrls, Graphics, LMessages;

type

  TChangingEvent = procedure(Sender: TObject; var Allow: Boolean) of object;

  TToggleLabelOption = (tloUnderlineOnHover, tloBoldOnHover);
  
  TToggleLabelOptions = set of TToggleLabelOption;
  
  { TToggleLabel }

  TToggleLabel = class (TCustomLabel)
  private
    FArrowColor: TColor;
    FArrowTopOffset: Integer;
    FExpandedCaption: String;
    FHighlightColor: TColor;
    FMouseInControl: Boolean;
    FOnChange: TNotifyEvent;
    FOnChanging: TChangingEvent;
    FOptions: TToggleLabelOptions;
    FTextOffset: Integer;
    FExpanded: Boolean;
    FPaintOnlyArrow: Boolean;
    FFontChanged: Boolean;
    function ChangeAllowed: Boolean;
    procedure DoChange;
    procedure InvalidateArrow;
    procedure SetArrowColor(const AValue: TColor);
    procedure SetExpanded(const AValue: Boolean);
    procedure SetExpandedCaption(const AValue: String);
    procedure SetHighlightColor(const AValue: TColor);
    procedure SetOptions(const AValue: TToggleLabelOptions);
  protected
    procedure DoMeasureTextPosition(var TextTop: integer;
      var TextLeft: integer); override;
    procedure FontChanged(Sender: TObject); override;
    function GetLabelText: string; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure WMLButtonDown(var Message: TLMLButtonDown); message LM_LBUTTONDOWN;
  public
    constructor Create(TheOwner: TComponent); override;
    procedure Paint; override;
    procedure SetBoundsKeepBase(aLeft, aTop, aWidth, aHeight: Integer); override;
  published
    property ArrowColor: TColor read FArrowColor write SetArrowColor default clBlack;
    property ExpandedCaption: String read FExpandedCaption write SetExpandedCaption;
    property Expanded: Boolean read FExpanded write SetExpanded;
    property HighlightColor: TColor read FHighlightColor write SetHighlightColor default clWhite;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnChanging: TChangingEvent read FOnChanging write FOnChanging;
    property Options: TToggleLabelOptions read FOptions write SetOptions default [];
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property BorderSpacing;
    property Caption;
    property Color;
    property Constraints;
    property DragCursor;
    property DragMode;
    property Enabled;
    property FocusControl;
    property Font;
    property Layout;
    property ParentBidiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowAccelChar;
    property ShowHint;
    property Transparent;
    property Visible;
    property WordWrap;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnChangeBounds;
    property OnResize;
    property OnStartDrag;
    property OptimalFill;
  end;

implementation

uses
  LCLIntf;

{ TToggleLabel }

function TToggleLabel.ChangeAllowed: Boolean;
begin
  Result := True;
  if Assigned(FOnChanging) then
    FOnChanging(Self, Result);
end;

procedure TToggleLabel.DoChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TToggleLabel.SetExpanded(const AValue: Boolean);
begin
  if FExpanded <> AValue then
  begin
    FExpanded := AValue;
    DoChange;
    Invalidate;
  end;
end;

procedure TToggleLabel.SetExpandedCaption(const AValue: String);
begin
  if FExpandedCaption <> AValue then
  begin
    FExpandedCaption := AValue;
    TextChanged;
  end;
end;

procedure TToggleLabel.SetHighlightColor(const AValue: TColor);
begin
  if FHighlightColor = AValue then
    Exit;
  FHighlightColor := AValue;
  InvalidateArrow;
end;

procedure TToggleLabel.SetOptions(const AValue: TToggleLabelOptions);
begin
  if FOptions = AValue then
    Exit;
  FOptions := AValue;
end;

procedure TToggleLabel.DoMeasureTextPosition(var TextTop: Integer;
  var TextLeft: Integer);
var
  lTextHeight: Integer;
  lTextWidth: Integer;
begin
  //To calculate the position of the arrow is necessary to know the
  //text height, so here GetPreferredSize is always called unlike TLabel
  GetPreferredSize(lTextWidth, lTextHeight, True);
  TextLeft := FTextOffset;
  if Layout = tlTop then
  begin
    TextTop := 0;
  end else
  begin
    case Layout of
      tlCenter: TextTop := (Height - lTextHeight) div 2;
      tlBottom: TextTop := Height - lTextHeight;
    end;
  end;
  FArrowTopOffset := TextTop + ((lTextHeight - 1) div 2) - 2;
end;

procedure TToggleLabel.FontChanged(Sender: TObject);
begin
  inherited FontChanged(Sender);
  FFontChanged := True;
end;

function TToggleLabel.GetLabelText: string;
begin
  if FExpanded then
    Result := FExpandedCaption
  else
    Result := Caption;
end;

//The MouseInControl idea/code was borrowed from LCL.TCustomSpeedButton

procedure TToggleLabel.MouseEnter;
begin
  inherited MouseEnter;
  if csDesigning in ComponentState then
    Exit;
  if not FMouseInControl and Enabled and (GetCapture = 0) then
  begin
    FMouseInControl := True;
    if ChangeAllowed then
    begin
      if [tloUnderlineOnHover, tloBoldOnHover] * FOptions <> [] then
      begin
        Font.BeginUpdate;
        if tloUnderlineOnHover in FOptions then
          Font.Style := Font.Style + [fsUnderline];
        if tloBoldOnHover in FOptions then
          Font.Style := Font.Style + [fsBold];
        Font.EndUpdate;
      end;
      if not FFontChanged then
        InvalidateArrow
      else
        FFontChanged := False;
    end;
  end;
end;

procedure TToggleLabel.MouseLeave;
begin
  inherited MouseLeave;
  if csDesigning in ComponentState then
    Exit;
  if FMouseInControl then
  begin
    FMouseInControl := False;
    if Enabled then
    begin
      if [tloUnderlineOnHover, tloBoldOnHover] * FOptions <> [] then
      begin
        Font.BeginUpdate;
        if tloUnderlineOnHover in FOptions then
          Font.Style := Font.Style - [fsUnderline];
        if tloBoldOnHover in FOptions then
          Font.Style := Font.Style - [fsBold];
        Font.EndUpdate;
      end;
      if not FFontChanged then
        InvalidateArrow
      else
        FFontChanged := False;
    end;
  end;
end;

procedure TToggleLabel.WMLButtonDown(var Message: TLMLButtonDown);
begin
  if not ChangeAllowed then
    Exit;
  FExpanded := not FExpanded;
  DoChange;
  TextChanged;
  inherited WMLButtonDown(Message);
end;

constructor TToggleLabel.Create(TheOwner: TComponent);
begin
  FHighlightColor := clWhite;
  //todo: define Toggle button size dinamically instead of using a fixed value
  FTextOffset := 12;
  inherited Create(TheOwner);
end;

procedure TToggleLabel.SetBoundsKeepBase(aLeft, aTop, aWidth, aHeight: integer);
begin
  if AutoSize then
    Inc(aWidth, FTextOffset);
  inherited SetBoundsKeepBase(aLeft, aTop, aWidth, aHeight);
end;

procedure TToggleLabel.Paint;

begin
  with Canvas do
  begin
    if FPaintOnlyArrow then
    begin
      //paint background of the arrow area
      if (Color <> clNone) and not Transparent then
      begin
        Brush.Color := Color;
        Brush.Style := bsSolid;
        FillRect(Rect(0, 0, FTextOffset, Height));
      end;
      FPaintOnlyArrow := False;
    end
    else
      inherited Paint;
    //Paint Toggle button
    Brush.Style := bsSolid;
    Pen.Color := FArrowColor;
    {
    MoveTo(0,0);
    LineTo(Self.Width -1, 0);
    LineTo(Self.Width -1, Self.Height-1);
    LineTo(0, Self.Height-1);
    LineTo(0,0);
    }
    if FMouseInControl and ChangeAllowed then
      Brush.Color := FHighlightColor
    else
      Brush.Color := FArrowColor;
    if FExpanded then
      Polygon([Point(0, FArrowTopOffset),
        Point(8, FArrowTopOffset),
        Point(4, FArrowTopOffset + 4)])
    else
      Polygon([Point(2, FArrowTopOffset - 2),
        Point(6, FArrowTopOffset + 2),
        Point(2, FArrowTopOffset + 6)]);
  end;
end;

procedure TToggleLabel.InvalidateArrow;
var
  R: TRect;
begin
  FPaintOnlyArrow := True;
  R := Rect(Left, Top, Left + FTextOffset, Top + Height);
  InvalidateRect(Parent.Handle, @R, False);
end;

procedure TToggleLabel.SetArrowColor(const AValue: TColor);
begin
  if FArrowColor = AValue then
    Exit;
  FArrowColor := AValue;
  InvalidateArrow;
end;

end.

