unit FormMediator;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls;

type

  TCustomFormMediator = class;

  TFormMediatorState = set of (fmsLoading);

  TCaptionDisplay = (cdNone, cdDefault, cdAbove, cdSide);

  { TFormElement }

  TFormElement = class(TCollectionItem)
  private
    FCaption: String;
    FControl: TControl;
    FMediatorId: String;
    FName: String;
    FPropertyName: String;
    FCaptionDisplay: TCaptionDisplay;
    function GetName: String;
    procedure SetControl(Value: TControl);
  protected
    function AllowsCaptionLabel: Boolean; virtual;
  public
    constructor Create(ACollection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
    function GetDisplayName: string; override;
  published
    property Caption: String read FCaption write FCaption;
    property CaptionDisplay: TCaptionDisplay read FCaptionDisplay write FCaptionDisplay default cdDefault;
    property Control: TControl read FControl write SetControl;
    property MediatorId: String read FMediatorId write FMediatorId;
    property Name: String read GetName write FName;
    property PropertyName: String read FPropertyName write FPropertyName;
  end;

  TFormElementClass = class of TFormElement;

  { TFormElements }

  TFormElements = class(TOwnedCollection)
  private
  protected
  public
  end;

  TFormElementsClass = class of TFormElements;

  { TCustomFormMediator }

  TCustomFormMediator = class(TComponent)
  private
    FCaptionDisplay: TCaptionDisplay;
    FState: TFormMediatorState;
  protected
    procedure BeginLoad;
    procedure EndLoad;
    function GetElements: TFormElements; virtual; abstract;
    procedure InitializeCaptionDisplay(Element: TFormElement);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    property State: TFormMediatorState read FState;
  published
    property CaptionDisplay: TCaptionDisplay read FCaptionDisplay write FCaptionDisplay default cdNone;
  end;


implementation

uses
  StdCtrls;

{ TCustomFormMediator }

procedure TCustomFormMediator.InitializeCaptionDisplay(Element: TFormElement);
var
  TheCaptionDisplay: TCaptionDisplay;
  CaptionLabel: TLabel;
  Control: TControl;
begin
  Control := Element.Control;
  if (Control = nil) or (Element.Caption = '') then
    Exit;
  TheCaptionDisplay := Element.CaptionDisplay;
  if TheCaptionDisplay = cdDefault then
    TheCaptionDisplay := CaptionDisplay;
  if TheCaptionDisplay = cdDefault then
    TheCaptionDisplay := cdNone;
  if TheCaptionDisplay = cdNone then
    Exit;
  if Element.AllowsCaptionLabel then
  begin
    CaptionLabel := TLabel.Create(Owner);
    CaptionLabel.Caption := Element.Caption;
    CaptionLabel.Parent := Control.Parent;
    case TheCaptionDisplay of
      cdAbove:
        begin
          CaptionLabel.Anchors := [akBottom, akLeft];
          CaptionLabel.AnchorParallel(akLeft, 0, Control);
          CaptionLabel.AnchorToNeighbour(akBottom, 2, Control);
        end;
      cdSide:
        begin
          CaptionLabel.Anchors := [akTop, akRight];
          CaptionLabel.AnchorVerticalCenterTo(Control);
          CaptionLabel.AnchorToNeighbour(akRight, 2, Control);
        end;
    end;
  end
  else
    Control.Caption := Element.Caption;
end;

procedure TCustomFormMediator.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  i: Integer;
  Element: TFormElement;
  Elements: TFormElements;
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    Elements := GetElements;
    for i := 0 to Elements.Count - 1 do
    begin
      Element := TFormElement(Elements.Items[i]);
      if AComponent = Element.Control then
        Element.Control := nil;
    end;
  end;
end;

procedure TCustomFormMediator.BeginLoad;
begin
  Include(FState, fmsLoading);
end;

procedure TCustomFormMediator.EndLoad;
begin
  Exclude(FState, fmsLoading);
end;

procedure TFormElement.SetControl(Value: TControl);
var
  TheOwner: TComponent;
begin
  if FControl = Value then Exit;
  TheOwner := Collection.Owner as TComponent;
  if (TheOwner <> nil) then
  begin
    if FControl <> nil then
      FControl.RemoveFreeNotification(TheOwner);
    if Value <> nil then
      Value.FreeNotification(TheOwner);
  end;
  FControl := Value;
end;

function TFormElement.AllowsCaptionLabel: Boolean;
begin
  Result := True;
end;

constructor TFormElement.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FCaptionDisplay := cdDefault;
end;

function TFormElement.GetName: String;
begin
  if FName <> '' then
    Result := FName
  else
    Result := FPropertyName;
end;

procedure TFormElement.Assign(Source: TPersistent);
begin
  if Source is TFormElement then
  begin
    PropertyName := TFormElement(Source).PropertyName;
    Caption := TFormElement(Source).Caption;
    CaptionDisplay := TFormElement(Source).CaptionDisplay;
    Control := TFormElement(Source).Control;
    Name := TFormElement(Source).Name;
    MediatorId := TFormElement(Source).MediatorId;
  end
  else
    inherited Assign(Source);
end;

function TFormElement.GetDisplayName: string;
begin
  Result := Name;
  if Result = '' then
    Result := ClassName;
  if FControl <> nil then
    Result := Format('%s (%s)', [Result, FControl.Name]);
end;


end.

