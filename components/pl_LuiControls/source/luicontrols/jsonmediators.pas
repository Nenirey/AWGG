unit JSONMediators;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpjson, Controls, Forms;

type

  TBooleanValue = (bvTrue, bvFalse, bvIndeterminate, bvNone);

  { TJSONBooleanProperty }

  TJSONBooleanProperty = class(TCollectionItem)
  private
    FCaption: String;
    FName: String;
    FView: TCustomFrame; //todo: add IJSONBooleanView intf
  public
    procedure Assign(Source: TPersistent); override;
    function GetDisplayName: string; override;
  published
    property Caption: String read FCaption write FCaption;
    property Name: String read FName write FName;
  end;

  { TJSONBooleanProperties }

  TJSONBooleanProperties = class(TOwnedCollection)
  private
    function GetItems(Index: Integer): TJSONBooleanProperty;
  public
    property Items[Index: Integer]: TJSONBooleanProperty read GetItems; default;
  end;

  { TJSONBooleanGroupMediator }

  TJSONBooleanGroupMediator = class(TComponent)
  private
    FControl: TWinControl;
    FFalseCaption: String;
    FFalseValue: TBooleanValue;
    FNullValue: TBooleanValue;
    FProperties: TJSONBooleanProperties;
    FTrueCaption: String;
    FIndeterminateCaption: String;
    FUndefinedValue: TBooleanValue;
    FViewsLoaded: Boolean;
    procedure CreateViews;
    procedure SetControl(AValue: TWinControl);
    procedure SetProperties(AValue: TJSONBooleanProperties);
    procedure InitializeViews(Data: TJSONObject);
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CheckValues: Boolean;
    procedure LoadData(Data: TJSONObject);
    procedure SaveData(Data: TJSONObject);
  published
    property Control: TWinControl read FControl write SetControl;
    property FalseCaption: String read FFalseCaption write FFalseCaption;
    property FalseValue: TBooleanValue read FFalseValue write FFalseValue default bvFalse;
    property IndeterminateCaption: String read FIndeterminateCaption write FIndeterminateCaption;
    property NullValue: TBooleanValue read FNullValue write FNullValue default bvIndeterminate;
    property Properties: TJSONBooleanProperties read FProperties write SetProperties;
    property TrueCaption: String read FTrueCaption write FTrueCaption;
    property UndefinedValue: TBooleanValue read FUndefinedValue write FUndefinedValue default bvNone;
  end;

implementation

uses
  JSONBooleanRadioButtonView;

{ TJSONBooleanProperties }

function TJSONBooleanProperties.GetItems(Index: Integer): TJSONBooleanProperty;
begin
  Result := TJSONBooleanProperty(inherited Items[Index]);
end;

{ TJSONBooleanProperty }

procedure TJSONBooleanProperty.Assign(Source: TPersistent);
begin
  if Source is TJSONBooleanProperty then
  begin
    FCaption := TJSONBooleanProperty(Source).FCaption;
    FName := TJSONBooleanProperty(Source).FName;
  end
  else
    inherited Assign(Source);
end;

function TJSONBooleanProperty.GetDisplayName: string;
begin
  if FCaption <> '' then
    Result := FCaption
  else
    Result := FName;
end;

{ TJSONBooleanGroupMediator }

procedure TJSONBooleanGroupMediator.CreateViews;
var
  View: TJSONBooleanRadioButtonViewFrame;
  JSONProperty: TJSONBooleanProperty;
  i, ViewTop: Integer;
begin
  if (FControl = nil) then
    Exit;
  ViewTop := 0;
  for i := 0 to FProperties.Count - 1 do
  begin
    JSONProperty := TJSONBooleanProperty(FProperties.Items[i]);
    //todo: use self as owner
    View := TJSONBooleanRadioButtonViewFrame.Create(FControl);
    View.Name := Name + 'BooleanView' + IntToStr(i);
    View.Top := ViewTop;
    View.PropertyCaption := JSONProperty.Caption;
    View.TrueCaption := FTrueCaption;
    View.FalseCaption := FFalseCaption;
    View.IndeterminateCaption := FIndeterminateCaption;
    View.Parent := FControl;
    View.Visible := True;
    JSONProperty.FView := View;
    Inc(ViewTop, View.Height);
  end;
  FViewsLoaded := True;
end;

procedure TJSONBooleanGroupMediator.SetControl(AValue: TWinControl);
begin
  if FControl = AValue then Exit;
  if AValue <> nil then
    AValue.FreeNotification(Self);
  if FControl <> nil then
    FControl.RemoveFreeNotification(Self);
  FControl := AValue;
end;

procedure TJSONBooleanGroupMediator.SetProperties(AValue: TJSONBooleanProperties);
begin
  FProperties.Assign(AValue);
end;

procedure TJSONBooleanGroupMediator.InitializeViews(Data: TJSONObject);
var
  i, PropIndex: Integer;
  JSONProperty: TJSONBooleanProperty;
  InitialValue: TBooleanValue;
  PropData: TJSONData;
begin
  if not FViewsLoaded then
    Exit;
  for i := 0 to FProperties.Count -1 do
  begin
    JSONProperty := TJSONBooleanProperty(FProperties.Items[i]);
    PropIndex := Data.IndexOfName(JSONProperty.Name);
    if PropIndex = -1 then
      InitialValue := FUndefinedValue
    else
    begin
      PropData := Data.Items[PropIndex];
      case PropData.JSONType of
        jtBoolean:
        begin
          if PropData.AsBoolean then
            InitialValue := bvTrue
          else
            InitialValue := FFalseValue;
        end;
        jtNull:
          InitialValue := FNullValue;
        else
          InitialValue := bvIndeterminate;  //??
      end;
    end;
    TJSONBooleanRadioButtonViewFrame(JSONProperty.FView).Value := InitialValue;
  end;
end;

procedure TJSONBooleanGroupMediator.Loaded;
begin
  inherited Loaded;
  if (FControl <> nil) and (FControl.ComponentState * [csLoading, csDesigning] = []) then
    CreateViews;
end;

procedure TJSONBooleanGroupMediator.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FControl) then
    FControl := nil;
end;

constructor TJSONBooleanGroupMediator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FProperties := TJSONBooleanProperties.Create(Self, TJSONBooleanProperty);
  FFalseCaption := 'No';
  FTrueCaption := 'Yes';
  FIndeterminateCaption := 'Indeterminate';
  FNullValue := bvIndeterminate;
  FUndefinedValue := bvNone;
  FFalseValue := bvFalse;
end;

destructor TJSONBooleanGroupMediator.Destroy;
begin
  FProperties.Destroy;
  inherited Destroy;
end;

function TJSONBooleanGroupMediator.CheckValues: Boolean;
begin
  //todo
end;

procedure TJSONBooleanGroupMediator.LoadData(Data: TJSONObject);
begin
  InitializeViews(Data);
end;

procedure TJSONBooleanGroupMediator.SaveData(Data: TJSONObject);
var
  i: Integer;
  JSONProperty: TJSONBooleanProperty;
  PropName: String;
  View: TJSONBooleanRadioButtonViewFrame;
begin
  if not FViewsLoaded or (Data = nil) then
    Exit;
  for i := 0 to FProperties.Count -1 do
  begin
    JSONProperty := FProperties[i];
    PropName := JSONProperty.Name;
    View := TJSONBooleanRadioButtonViewFrame(JSONProperty.FView);
    case View.Value of
      bvTrue:
        Data.Booleans[PropName] := True;
      bvFalse:
      begin
        if FUndefinedValue = bvFalse then
          Data.Delete(PropName)
        else if FNullValue = bvFalse then
          Data.Nulls[PropName] := True
        else
          Data.Booleans[PropName] := False;
      end;
      bvIndeterminate:
      begin
        if FUndefinedValue = bvIndeterminate then
          Data.Delete(PropName)
        else if FFalseValue = bvIndeterminate then
          Data.Booleans[PropName] := False
        else
          Data.Nulls[PropName] := True;
      end;
      bvNone:
      begin
        if FNullValue = bvNone then
          Data.Nulls[PropName] := True
        else if FFalseValue = bvNone then
          Data.Booleans[PropName] := False
        else
          Data.Delete(PropName);
      end;
    end;
  end;
end;

end.
