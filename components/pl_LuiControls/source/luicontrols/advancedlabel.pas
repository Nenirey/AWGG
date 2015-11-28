unit AdvancedLabel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, Controls, Graphics, LMessages;

type

  TAdvancedLabelState = (alsMouseInControl, alsUpdatingFont);

  TAdvancedLabelStates = set of TAdvancedLabelState;

  { TCustomAdvancedLabel }

  TCustomAdvancedLabel = class (TCustomLabel)
  private
    FHotTrackColor: TColor;
    FHotTrackStyle: TFontStyles;
    FBaseFontColor: TColor;
    FBaseFontStyle: TFontStyles;
    FHotTrack: Boolean;
    FStates: TAdvancedLabelStates;
    procedure CMFontChanged(var Message: TLMessage); message CM_FONTCHANGED;
  protected
    procedure Loaded; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure RestoreFontProperties;
    procedure UpdateFont(AColor: TColor; AStyle: TFontStyles);
    property HotTrack: Boolean read FHotTrack write FHotTrack;
    property HotTrackColor: TColor read FHotTrackColor write FHotTrackColor;
    property HotTrackStyle: TFontStyles read FHotTrackStyle write FHotTrackStyle;
  public
  published
  end;

  { TAdvancedLabel }

  TAdvancedLabel = class(TCustomAdvancedLabel)
  private
    FLinkColor: TColor;
    FLinkStyle: TFontStyles;
    FSavedBaseFontColor: TColor;
    FSavedBaseFontStyle: TFontStyles;
    FAutoLink: Boolean;
    FLink: Boolean;
    procedure ApplyLinkProperties;
    function GetOnClick: TNotifyEvent;
    procedure SetLink(Value: Boolean);
    procedure SetLinkColor(Value: TColor);
    procedure SetLinkStyle(Value: TFontStyles);
    procedure SetOnClick(Value: TNotifyEvent);
  protected
    procedure Loaded; override;
  public
    constructor Create(TheOwner: TComponent); override;
  published
    property AutoLink: Boolean read FAutoLink write FAutoLink default True;
    property Link: Boolean read FLink write SetLink default False;
    property LinkColor: TColor read FLinkColor write SetLinkColor default clBlue;
    property LinkStyle: TFontStyles read FLinkStyle write SetLinkStyle default [fsUnderline];
    property HotTrack default False;
    property HotTrackColor default clDefault;
    property HotTrackStyle default [fsUnderline];
    property OnClick: TNotifyEvent read GetOnClick write SetOnClick;
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
    property DragKind;
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
    property OnContextPopup;
    property OnResize;
    property OnStartDrag;
    property OptimalFill;
  end;

implementation

uses
  LCLIntf;

{ TAdvancedLabel }

procedure TAdvancedLabel.SetLinkStyle(Value: TFontStyles);
begin
  if FLinkStyle = Value then Exit;
  FLinkStyle := Value;
  if FLink then
    ApplyLinkProperties;
end;

procedure TAdvancedLabel.SetOnClick(Value: TNotifyEvent);
begin
  inherited OnClick := Value;
  if (csDesigning in ComponentState) and FAutoLink then
    Link := Assigned(TMethod(Value).Data);
end;

procedure TAdvancedLabel.SetLinkColor(Value: TColor);
begin
  if FLinkColor = Value then Exit;
  FLinkColor := Value;
  if FLink then
    ApplyLinkProperties;
end;

procedure TAdvancedLabel.ApplyLinkProperties;
begin
  FSavedBaseFontColor := FBaseFontColor;
  FSavedBaseFontStyle := FBaseFontStyle;
  FBaseFontColor := FLinkColor;
  FBaseFontStyle := FLinkStyle;
  UpdateFont(FLinkColor, FLinkStyle);
end;

function TAdvancedLabel.GetOnClick: TNotifyEvent;
begin
  Result := inherited OnClick;
end;

procedure TAdvancedLabel.SetLink(Value: Boolean);
begin
  if FLink = Value then Exit;
  FLink := Value;
  if Value then
    ApplyLinkProperties
  else
  begin
    FBaseFontColor := FSavedBaseFontColor;
    FBaseFontStyle := FSavedBaseFontStyle;
    RestoreFontProperties;
  end;
end;

procedure TAdvancedLabel.Loaded;
begin
  inherited Loaded;
  if Assigned(OnClick) and FAutoLink then
    ApplyLinkProperties;
end;

constructor TAdvancedLabel.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FLinkColor := clBlue;
  FLinkStyle := [fsUnderline];
  FHotTrackColor := clDefault;
  FHotTrackStyle := [fsUnderline];
  FAutoLink := True;
end;

{ TCustomAdvancedLabel }

procedure TCustomAdvancedLabel.CMFontChanged(var Message: TLMessage);
begin
  if not (alsUpdatingFont in FStates) then
  begin
    FBaseFontColor := Font.Color;
    FBaseFontStyle := Font.Style;
  end;
end;

procedure TCustomAdvancedLabel.Loaded;
begin
  inherited Loaded;
  FBaseFontColor := Font.Color;
  FBaseFontStyle := Font.Style;
end;

procedure TCustomAdvancedLabel.MouseEnter;
begin
  inherited MouseEnter;
  if csDesigning in ComponentState then
    Exit;
  if not (alsMouseInControl in FStates) and Enabled and (GetCapture = 0) then
  begin
    Include(FStates, alsMouseInControl);
    if Enabled and FHotTrack then
    begin
      UpdateFont(HotTrackColor, HotTrackStyle);
    end;
  end;
end;

procedure TCustomAdvancedLabel.MouseLeave;
begin
  inherited MouseLeave;
  if csDesigning in ComponentState then
    Exit;
  if (alsMouseInControl in FStates) then
  begin
    Exclude(FStates, alsMouseInControl);
    if Enabled and FHotTrack then
    begin
      RestoreFontProperties;
    end;
  end;
end;

procedure TCustomAdvancedLabel.RestoreFontProperties;
begin
  UpdateFont(FBaseFontColor, FBaseFontStyle);
end;

procedure TCustomAdvancedLabel.UpdateFont(AColor: TColor; AStyle: TFontStyles);
begin
  Include(FStates, alsUpdatingFont);
  try
    Font.BeginUpdate;
    Font.Color := AColor;
    Font.Style := AStyle;
    Font.EndUpdate;
  finally
    Exclude(FStates, alsUpdatingFont);
  end;
end;

end.

