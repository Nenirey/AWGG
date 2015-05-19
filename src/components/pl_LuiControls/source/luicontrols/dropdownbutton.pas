unit DropDownButton;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DropDownManager, DropDownBaseButtons, Controls, LCLType, Buttons, Forms,
  Graphics;

type

  TDropDownButton = class;

  { TOwnedDropDownManager }

  TOwnedDropDownManager = class(TCustomDropDownManager)
  private
    FButton: TDropDownButton;
  protected
    procedure DoHide; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Control;
    property Options;
    property OnCreateControl;
    property OnHide;
    property OnShow;
  end;

  { TDropDownButton }

  TDropDownButton = class(TCustomDropDownButton)
  private
    FDropDown: TOwnedDropDownManager;
    procedure FormVisibleChange(Sender: TObject; Form: TCustomForm);
    procedure SetDropDown(AValue: TOwnedDropDownManager);
  protected
    procedure DoShowDropDown; override;
    procedure DoHideDropDown; override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property DropDown: TOwnedDropDownManager read FDropDown write SetDropDown;
    property Options;
    property Style;
    //
    property Action;
    property Align;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property Constraints;
    property Caption;
    property Color;
    property Enabled;
    property Flat;
    property Font;
    property Glyph;
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

{ TOwnedDropDownManager }

procedure TOwnedDropDownManager.DoHide;
begin
  FButton.DropDownClosed;
  inherited DoHide;
end;

constructor TOwnedDropDownManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetSubComponent(True);
  Name := 'OwnedDropDown';
  FButton := AOwner as TDropDownButton;
  MasterControl := FButton;
end;

{ TDropDownButton }

procedure TDropDownButton.FormVisibleChange(Sender: TObject; Form: TCustomForm);
begin
  if Form.Visible then
  begin
    FDropDown.UpdateState;
    UpdateDown(FDropDown.Visible);
  end;
  Screen.RemoveHandlerFormVisibleChanged(@FormVisibleChange);
end;

procedure TDropDownButton.SetDropDown(AValue: TOwnedDropDownManager);
begin
  FDropDown.Assign(AValue);
end;

procedure TDropDownButton.DoShowDropDown;
begin
  FDropDown.Visible := True;
end;

procedure TDropDownButton.DoHideDropDown;
begin
  FDropDown.Visible := False;
end;

procedure TDropDownButton.Loaded;
begin
  inherited Loaded;
  Screen.AddHandlerFormVisibleChanged(@FormVisibleChange);
end;

constructor TDropDownButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDropDown := TOwnedDropDownManager.Create(Self);
  //necessary to the button toggle
  AllowAllUp := True;
  GroupIndex := 1;
end;

destructor TDropDownButton.Destroy;
begin
  Screen.RemoveHandlerFormVisibleChanged(@FormVisibleChange);
  inherited Destroy;
end;

end.

