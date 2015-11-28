unit LuiJSONLCLViews;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpjson, Controls, StdCtrls, ExtCtrls;

type

  TJSONObjectViewManager = class;

  TJSONMediatorState = set of (jmsLoading);

  { TCustomJSONGUIMediator }

  TCustomJSONGUIMediator = class
  public
    class procedure DoJSONToGUI(Data: TJSONObject; const PropName: String; Control: TControl; OptionsData: TJSONObject); virtual;
    class procedure DoGUIToJSON(Control: TControl; Data: TJSONObject; const PropName: String; OptionsData: TJSONObject); virtual;
    class procedure Initialize(Control: TControl; OptionsData: TJSONObject); virtual;
  end;

  TCustomJSONGUIMediatorClass = class of TCustomJSONGUIMediator;

  { TJSONGenericMediator }

  TJSONGenericMediator = class(TCustomJSONGUIMediator)
    class procedure DoJSONToGUI(Data: TJSONObject; const PropName: String;
      Control: TControl; OptionsData: TJSONObject); override;
    class procedure DoGUIToJSON(Control: TControl; Data: TJSONObject;
      const PropName: String; OptionsData: TJSONObject); override;
  end;

  { TJSONCaptionMediator }

  TJSONCaptionMediator = class(TCustomJSONGUIMediator)
    class procedure DoJSONToGUI(Data: TJSONObject; const PropName: String;
      Control: TControl; OptionsData: TJSONObject); override;
    class procedure DoGUIToJSON(Control: TControl; Data: TJSONObject;
      const PropName: String; OptionsData: TJSONObject); override;
  end;

  { TJSONSpinEditMediator }

  TJSONSpinEditMediator = class(TCustomJSONGUIMediator)
    class procedure DoJSONToGUI(Data: TJSONObject; const PropName: String;
      Control: TControl; OptionsData: TJSONObject); override;
    class procedure DoGUIToJSON(Control: TControl; Data: TJSONObject;
      const PropName: String; OptionsData: TJSONObject); override;
  end;

  { TJSONListMediator }

  TJSONListMediator = class(TCustomJSONGUIMediator)
    class function GetItemIndex(Data: TJSONObject; const PropName: String; Items: TStrings; OptionsData: TJSONObject): Integer; static;
    class procedure SetItemIndex(Data: TJSONObject; const PropName: String; Items: TStrings; ItemIndex: Integer; OptionsData: TJSONObject); static;
    class procedure LoadItems(Items: TStrings; OptionsData: TJSONObject); static;
  end;

  { TJSONComboBoxMediator }

  TJSONComboBoxMediator = class(TJSONListMediator)
    class procedure DoJSONToGUI(Data: TJSONObject; const PropName: String;
      Control: TControl; OptionsData: TJSONObject); override;
    class procedure DoGUIToJSON(Control: TControl; Data: TJSONObject;
      const PropName: String; OptionsData: TJSONObject); override;
    class procedure Initialize(Control: TControl; OptionsData: TJSONObject); override;
  end;

  { TJSONRadioGroupMediator }

  TJSONRadioGroupMediator = class(TJSONListMediator)
    class procedure DoJSONToGUI(Data: TJSONObject; const PropName: String;
      Control: TControl; OptionsData: TJSONObject); override;
    class procedure DoGUIToJSON(Control: TControl; Data: TJSONObject;
      const PropName: String; OptionsData: TJSONObject); override;
    class procedure Initialize(Control: TControl; OptionsData: TJSONObject); override;
  end;

  { TJSONCheckBoxMediator }

  TJSONCheckBoxMediator = class(TCustomJSONGUIMediator)
    class procedure DoJSONToGUI(Data: TJSONObject; const PropName: String;
      Control: TControl; OptionsData: TJSONObject); override;
    class procedure DoGUIToJSON(Control: TControl; Data: TJSONObject;
      const PropName: String; OptionsData: TJSONObject); override;
  end;

  { TJSONObjectPropertyView }

  TJSONObjectPropertyView = class(TCollectionItem)
  private
    FControl: TControl;
    FMediatorClass: TCustomJSONGUIMediatorClass;
    FMediatorId: String;
    FOptions: String;
    FOptionsData: TJSONObject;
    FPropertyName: String;
    FInitialized: Boolean;
    function GetOptionsData: TJSONObject;
    procedure Initialize;
    procedure MediatorClassNeeded;
    procedure OptionsDataNeeded;
    procedure SetControl(Value: TControl);
  public
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function GetDisplayName: string; override;
    procedure Load(JSONObject: TJSONObject);
    procedure Save(JSONObject: TJSONObject);
  published
    property Control: TControl read FControl write SetControl;
    property MediatorId: String read FMediatorId write FMediatorId;
    property Options: String read FOptions write FOptions;
    property OptionsData: TJSONObject read GetOptionsData;
    property PropertyName: String read FPropertyName write FPropertyName;
  end;

  { TJSONObjectPropertyViews }

  TJSONObjectPropertyViews = class(TCollection)
  private
    FOwner: TJSONObjectViewManager;
    function GetItems(Index: Integer): TJSONObjectPropertyView;
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TJSONObjectViewManager);
    property Items[Index: Integer]: TJSONObjectPropertyView read GetItems; default;
  end;

  { TJSONObjectViewManager }

  TJSONObjectViewManager = class(TComponent)
  private
    FJSONObject: TJSONObject;
    FPropertyViews: TJSONObjectPropertyViews;
    FState: TJSONMediatorState;
    procedure SetJSONObject(const Value: TJSONObject);
    procedure SetPropertyViews(const Value: TJSONObjectPropertyViews);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize;
    procedure Load;
    procedure Load(const Properties: array of String);
    function PropertyViewByName(const PropertyName: String): TJSONObjectPropertyView;
    procedure Save;
    procedure Save(const Properties: array of String);
    procedure SetViewOption(const PropertyName, OptionPropName: String; Data: TJSONData);
    property JSONObject: TJSONObject read FJSONObject write SetJSONObject;
    property State: TJSONMediatorState read FState;
  published
    property PropertyViews: TJSONObjectPropertyViews read FPropertyViews write SetPropertyViews;
  end;

  procedure RegisterJSONMediator(const MediatorId: String; MediatorClass: TCustomJSONGUIMediatorClass);
  procedure RegisterJSONMediator(ControlClass: TControlClass; MediatorClass: TCustomJSONGUIMediatorClass);

implementation

uses
  contnrs, LuiJSONUtils, strutils, spin, typinfo;

type

  { TJSONGUIMediatorManager }

  TJSONGUIMediatorManager = class
  private
    FList: TFPHashList;
  public
    constructor Create;
    destructor Destroy; override;
    function Find(const MediatorId: String): TCustomJSONGUIMediatorClass;
    procedure RegisterMediator(const MediatorId: String; MediatorClass: TCustomJSONGUIMediatorClass);
  end;

var
  MediatorManager: TJSONGUIMediatorManager;

procedure RegisterJSONMediator(const MediatorId: String;
  MediatorClass: TCustomJSONGUIMediatorClass);
begin
  MediatorManager.RegisterMediator(MediatorId, MediatorClass);
end;

procedure RegisterJSONMediator(ControlClass: TControlClass;
  MediatorClass: TCustomJSONGUIMediatorClass);
begin
  RegisterJSONMediator(ControlClass.ClassName, MediatorClass);
end;

type
  TJSONDataMapType = (jdmText, jdmIndex, jdmValue);

{ TJSONComboBoxMediator }

class procedure TJSONComboBoxMediator.DoJSONToGUI(Data: TJSONObject;
  const PropName: String; Control: TControl; OptionsData: TJSONObject);
var
  ComboBox: TComboBox;
begin
  ComboBox := Control as TComboBox;
  ComboBox.ItemIndex := GetItemIndex(Data, PropName, ComboBox.Items, OptionsData);
  if (ComboBox.ItemIndex = -1) and (ComboBox.Style = csDropDown) then
  begin
    if OptionsData.Get('datamap', 'text') = 'text' then
      ComboBox.Text := Data.Get(PropName, '')
    else
      ComboBox.Text := '';
  end;
end;

class procedure TJSONComboBoxMediator.DoGUIToJSON(Control: TControl;
  Data: TJSONObject; const PropName: String; OptionsData: TJSONObject);
var
  ComboBox: TComboBox;
begin
  ComboBox := Control as TComboBox;
  if (ComboBox.ItemIndex = -1) and (ComboBox.Style = csDropDown) and (OptionsData.Get('datamap', 'text') = 'text') then
    Data.Strings[PropName] := ComboBox.Text
  else
    SetItemIndex(Data, PropName, ComboBox.Items, ComboBox.ItemIndex, OptionsData);
end;

class procedure TJSONComboBoxMediator.Initialize(Control: TControl;
  OptionsData: TJSONObject);
var
  ComboBox: TComboBox;
begin
  ComboBox := Control as TComboBox;
  LoadItems(ComboBox.Items, OptionsData);
end;

{ TJSONListMediator }

class function TJSONListMediator.GetItemIndex(Data: TJSONObject;
  const PropName: String; Items: TStrings; OptionsData: TJSONObject): Integer;
var
  PropData, MapData: TJSONData;
  SourceData: TJSONArray;
  MapType: TJSONDataMapType;
  ValuePropName: String;
begin
  Result := -1;
  PropData := Data.Find(PropName);
  if (PropData <> nil) and not (PropData.JSONType in [jtNull, jtArray, jtObject]) then
  begin
    MapType := jdmText;
    ValuePropName := 'value';
    MapData := OptionsData.Find('datamap');
    if MapData <> nil then
    begin
      case MapData.JSONType of
        jtString:
          if MapData.AsString = 'index' then
            MapType := jdmIndex
          else if MapData.AsString = 'value' then
            MapType := jdmValue;
        jtObject:
          begin
            MapType := jdmValue;
            ValuePropName := TJSONObject(MapData).Get('valueprop', 'value');
          end;
      end;
    end;
    case MapType of
      jdmText:
        Result := Items.IndexOf(PropData.AsString);
      jdmIndex:
        begin
          if PropData.JSONType = jtNumber then
            Result := PropData.AsInteger;
        end;
      jdmValue:
        begin
          if FindJSONProp(OptionsData, 'datasource', SourceData) then
            Result := GetJSONIndexOf(SourceData, [ValuePropName, PropData.Value]);
        end;
    end;
    //check for out of range result
    if (Result < 0) and (Result >= Items.Count) then
      Result := -1;
  end;
end;

class procedure TJSONListMediator.SetItemIndex(Data: TJSONObject;
  const PropName: String; Items: TStrings; ItemIndex: Integer;
  OptionsData: TJSONObject);
var
  MapType: TJSONDataMapType;
  MapData, ValueData: TJSONData;
  SourceData: TJSONArray;
  ValuePropName: String;
  ItemData: TJSONData;
begin
  if ItemIndex > -1 then
  begin
    MapType := jdmText;
    ValuePropName := 'value';
    MapData := OptionsData.Find('datamap');
    if MapData <> nil then
    begin
      case MapData.JSONType of
        jtString:
          if MapData.AsString = 'index' then
            MapType := jdmIndex
          else if MapData.AsString = 'value' then
            MapType := jdmValue;
        jtObject:
          begin
            ValuePropName := TJSONObject(MapData).Get('valueprop', 'value');
            MapType := jdmValue;
          end;
      end;
    end;
    case MapType of
      jdmText:
        Data.Strings[PropName] := Items[ItemIndex];
      jdmIndex:
        Data.Integers[PropName] := ItemIndex;
      jdmValue:
        begin
          if FindJSONProp(OptionsData, 'datasource', SourceData) then
          begin
            if ItemIndex < SourceData.Count then
            begin
              ItemData := SourceData.Items[ItemIndex];
              if ItemData.JSONType = jtObject then
              begin
                ValueData := TJSONObject(ItemData).Find(ValuePropName);
                if ValueData <> nil then
                  Data.Elements[PropName] := ValueData.Clone;
              end;
            end;
          end;
        end;
    end;
  end
  else
    Data.Delete(PropName);
end;

class procedure TJSONListMediator.LoadItems(Items: TStrings;
  OptionsData: TJSONObject);
var
  SourceData: TJSONArray;
  MapData, ItemData: TJSONData;
  TextProp: String;
  i: Integer;
begin
  if FindJSONProp(OptionsData, 'datasource', SourceData) then
  begin
    MapData := OptionsData.Find('datamap');
    if (MapData <> nil) and (MapData.JSONType = jtObject) then
      TextProp := TJSONObject(MapData).Get('textprop', 'text')
    else
      TextProp := 'text';
    Items.Clear;
    for i := 0 to SourceData.Count - 1 do
    begin
      ItemData := SourceData.Items[i];
      case ItemData.JSONType of
        jtString:
          Items.Add(ItemData.AsString);
        jtObject:
          Items.Add(TJSONObject(ItemData).Get(TextProp, ''));
      end;
    end;
  end;
end;

{ TJSONCheckBoxMediator }

class procedure TJSONCheckBoxMediator.DoJSONToGUI(Data: TJSONObject;
  const PropName: String; Control: TControl; OptionsData: TJSONObject);
var
  CheckBox: TCheckBox;
  PropData: TJSONData;
begin
  //todo: add checked/unchecked options
  CheckBox := Control as TCheckBox;
  CheckBox.Checked := Data.Get(PropName, False);
end;

class procedure TJSONCheckBoxMediator.DoGUIToJSON(Control: TControl;
  Data: TJSONObject; const PropName: String; OptionsData: TJSONObject);
var
  CheckBox: TCheckBox;
begin
  CheckBox := Control as TCheckBox;
  if CheckBox.Checked then
    Data.Booleans[PropName] := True
  else
    Data.Delete(PropName);
end;

{ TJSONRadioGroupMediator }

class procedure TJSONRadioGroupMediator.DoJSONToGUI(Data: TJSONObject;
  const PropName: String; Control: TControl; OptionsData: TJSONObject);
var
  RadioGroup: TRadioGroup;
begin
  RadioGroup := Control as TRadioGroup;
  RadioGroup.ItemIndex := GetItemIndex(Data, PropName, RadioGroup.Items, OptionsData);
end;

class procedure TJSONRadioGroupMediator.DoGUIToJSON(Control: TControl;
  Data: TJSONObject; const PropName: String; OptionsData: TJSONObject);
var
  RadioGroup: TRadioGroup;
begin
  RadioGroup := Control as TRadioGroup;
  SetItemIndex(Data, PropName, RadioGroup.Items, RadioGroup.ItemIndex, OptionsData);
end;

class procedure TJSONRadioGroupMediator.Initialize(Control: TControl;
  OptionsData: TJSONObject);
var
  RadioGroup: TRadioGroup;
begin
  RadioGroup := Control as TRadioGroup;
  LoadItems(RadioGroup.Items, OptionsData);
end;

{ TJSONSpinEditMediator }

class procedure TJSONSpinEditMediator.DoJSONToGUI(Data: TJSONObject;
  const PropName: String; Control: TControl; OptionsData: TJSONObject);
var
  PropData: TJSONData;
  SpinEdit: TCustomFloatSpinEdit;
begin
  SpinEdit := Control as TCustomFloatSpinEdit;
  PropData := Data.Find(PropName);
  if (PropData = nil) or (PropData.JSONType = jtNull) then
    SpinEdit.ValueEmpty := True
  else
  begin
    SpinEdit.Value := PropData.AsFloat;
    SpinEdit.ValueEmpty := False;
  end;
end;

class procedure TJSONSpinEditMediator.DoGUIToJSON(Control: TControl;
  Data: TJSONObject; const PropName: String; OptionsData: TJSONObject);
var
  SpinEdit: TCustomFloatSpinEdit;
begin
  SpinEdit := Control as TCustomFloatSpinEdit;
  if not SpinEdit.ValueEmpty then
  begin
    if SpinEdit.DecimalPlaces = 0 then
      Data.Integers[PropName] := round(SpinEdit.Value)
    else
      Data.Floats[PropName] := SpinEdit.Value;
  end
  else
  begin
    //todo add option to configure undefined/null
    Data.Delete(PropName);
    //JSONObject.Nulls[PropName] := True;
  end;
end;

{ TJSONGUIMediatorStore }

constructor TJSONGUIMediatorManager.Create;
begin
  FList := TFPHashList.Create;
end;

destructor TJSONGUIMediatorManager.Destroy;
begin
  FList.Destroy;
  inherited Destroy;
end;

function TJSONGUIMediatorManager.Find(const MediatorId: String): TCustomJSONGUIMediatorClass;
begin
  Result := TCustomJSONGUIMediatorClass(FList.Find(MediatorId));
end;

procedure TJSONGUIMediatorManager.RegisterMediator(const MediatorId: String;
  MediatorClass: TCustomJSONGUIMediatorClass);
begin
  FList.Add(MediatorId, MediatorClass);
end;

{ TJSONObjectViewManager }

procedure TJSONObjectViewManager.SetPropertyViews(const Value: TJSONObjectPropertyViews);
begin
  FPropertyViews.Assign(Value);
end;

procedure TJSONObjectViewManager.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  i: Integer;
  View: TJSONObjectPropertyView;
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    for i := 0 to FPropertyViews.Count -1 do
    begin
      View := TJSONObjectPropertyView(FPropertyViews.Items[i]);
      if AComponent = View.Control then
        View.Control := nil;
    end;
  end;
end;

procedure TJSONObjectViewManager.SetJSONObject(const Value: TJSONObject);
begin
  if FJSONObject = Value then exit;
  FJSONObject := Value;
end;

constructor TJSONObjectViewManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPropertyViews := TJSONObjectPropertyViews.Create(Self);
end;

destructor TJSONObjectViewManager.Destroy;
begin
  FPropertyViews.Destroy;
  inherited Destroy;
end;

procedure TJSONObjectViewManager.Initialize;
var
  i: Integer;
begin
  for i := 0 to FPropertyViews.Count - 1 do
    TJSONObjectPropertyView(FPropertyViews.Items[i]).Initialize;
end;

procedure TJSONObjectViewManager.Load;
var
  i: Integer;
  View: TJSONObjectPropertyView;
begin
  Include(FState, jmsLoading);
  try
    for i := 0 to FPropertyViews.Count - 1 do
    begin
      View := TJSONObjectPropertyView(FPropertyViews.Items[i]);
      View.Load(FJSONObject);
    end;
  finally
    Exclude(FState, jmsLoading);
  end;
end;

procedure TJSONObjectViewManager.Load(const Properties: array of String);
var
  i: Integer;
  View: TJSONObjectPropertyView;
begin
  Include(FState, jmsLoading);
  try
    for i := 0 to FPropertyViews.Count - 1 do
    begin
      View := TJSONObjectPropertyView(FPropertyViews.Items[i]);
      if AnsiMatchText(View.PropertyName, Properties) then
        View.Load(FJSONObject);
    end;
  finally
    Exclude(FState, jmsLoading);
  end;
end;

function TJSONObjectViewManager.PropertyViewByName(const PropertyName: String): TJSONObjectPropertyView;
var
  i: Integer;
begin
  for i := 0 to FPropertyViews.Count - 1 do
  begin
    Result := FPropertyViews[i];
    if Result.PropertyName = PropertyName then
      Exit;
  end;
  raise Exception.CreateFmt('PropertyViewByName - View of property "%s" not found', [PropertyName]);
end;

procedure TJSONObjectViewManager.Save;
var
  i: Integer;
  View: TJSONObjectPropertyView;
begin
  for i := 0 to FPropertyViews.Count -1 do
  begin
    View := TJSONObjectPropertyView(FPropertyViews.Items[i]);
    View.Save(FJSONObject);
  end;
end;

procedure TJSONObjectViewManager.Save(const Properties: array of String);
var
  i: Integer;
  View: TJSONObjectPropertyView;
begin
  for i := 0 to FPropertyViews.Count -1 do
  begin
    View := TJSONObjectPropertyView(FPropertyViews.Items[i]);
    if AnsiMatchText(View.PropertyName, Properties) then
      View.Save(FJSONObject);
  end;
end;

procedure TJSONObjectViewManager.SetViewOption(const PropertyName,
  OptionPropName: String; Data: TJSONData);
begin
  PropertyViewByName(PropertyName).OptionsData.Elements[OptionPropName] := Data;
end;

{ TJSONObjectPropertyViews }

function TJSONObjectPropertyViews.GetItems(Index: Integer): TJSONObjectPropertyView;
begin
  Result := TJSONObjectPropertyView(inherited Items[Index]);
end;

function TJSONObjectPropertyViews.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

constructor TJSONObjectPropertyViews.Create(AOwner: TJSONObjectViewManager);
begin
  inherited Create(TJSONObjectPropertyView);
  FOwner := AOwner;
end;

{ TJSONObjectPropertyView }

procedure TJSONObjectPropertyView.Initialize;
begin
  if not FInitialized then
  begin
    OptionsDataNeeded;
    MediatorClassNeeded;
    if FControl <> nil then
      FMediatorClass.Initialize(FControl, FOptionsData);
    FInitialized := True;
  end;
end;

function TJSONObjectPropertyView.GetOptionsData: TJSONObject;
begin
  OptionsDataNeeded;
  Result := FOptionsData;
end;

procedure TJSONObjectPropertyView.MediatorClassNeeded;
begin
  if FMediatorClass = nil then
  begin
    if FMediatorId <> '' then
      FMediatorClass := MediatorManager.Find(FMediatorId)
    else
      FMediatorClass := MediatorManager.Find(Control.ClassName);
    if FMediatorClass = nil then
      raise Exception.CreateFmt('Could not find mediator (MediatorId: "%s" ControlClass: "%s")', [FMediatorId, Control.ClassName]);
  end;
end;

procedure TJSONObjectPropertyView.OptionsDataNeeded;
begin
  if FOptionsData = nil then
  begin
    if not TryStrToJSON(FOptions, FOptionsData) then
      FOptionsData := TJSONObject.Create;
  end;
end;

procedure TJSONObjectPropertyView.SetControl(Value: TControl);
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

destructor TJSONObjectPropertyView.Destroy;
begin
  FOptionsData.Free;
  inherited Destroy;
end;

procedure TJSONObjectPropertyView.Assign(Source: TPersistent);
begin
  if Source is TJSONObjectPropertyView then
  begin
    PropertyName := TJSONObjectPropertyView(Source).PropertyName;
    Control := TJSONObjectPropertyView(Source).Control;
    Options := TJSONObjectPropertyView(Source).Options;
    MediatorId := TJSONObjectPropertyView(Source).MediatorId;
  end
  else
    inherited Assign(Source);
end;

function TJSONObjectPropertyView.GetDisplayName: string;
begin
  Result := FPropertyName;
  if Result = '' then
    Result := ClassName;
end;

procedure TJSONObjectPropertyView.Load(JSONObject: TJSONObject);
begin
  if FControl <> nil then
  begin
    Initialize;
    FMediatorClass.DoJSONToGUI(JSONObject, FPropertyName, FControl, FOptionsData);
  end;
end;

procedure TJSONObjectPropertyView.Save(JSONObject: TJSONObject);
begin
  if FControl <> nil then
  begin
    Initialize;
    FMediatorClass.DoGUIToJSON(FControl, JSONObject, FPropertyName, FOptionsData);
  end;
end;

{ TCustomJSONGUIMediator }

class procedure TCustomJSONGUIMediator.DoJSONToGUI(Data: TJSONObject;
  const PropName: String; Control: TControl; OptionsData: TJSONObject);
begin
  //
end;

class procedure TCustomJSONGUIMediator.DoGUIToJSON(Control: TControl;
  Data: TJSONObject; const PropName: String; OptionsData: TJSONObject);
begin
  //
end;

class procedure TCustomJSONGUIMediator.Initialize(Control: TControl;
  OptionsData: TJSONObject);
begin
  //
end;

{ TJSONGenericMediator }

type
  TControlAccess = class(TControl)

  end;

class procedure TJSONGenericMediator.DoJSONToGUI(Data: TJSONObject;
  const PropName: String; Control: TControl; OptionsData: TJSONObject);
begin
  TControlAccess(Control).Text := Data.Get(PropName, '');
end;

class procedure TJSONGenericMediator.DoGUIToJSON(Control: TControl;
  Data: TJSONObject; const PropName: String; OptionsData: TJSONObject);
var
  i: Integer;
  ControlText: String;
begin
  i := Data.IndexOfName(PropName);
  ControlText := TControlAccess(Control).Text;
  if (i <> -1) or (ControlText <> '') then
    Data.Strings[PropName] := ControlText;
end;

{ TJSONCaptionMediator }

class procedure TJSONCaptionMediator.DoJSONToGUI(Data: TJSONObject;
  const PropName: String; Control: TControl; OptionsData: TJSONObject);
var
  FormatStr, TemplateStr, ValueStr: String;
  PropData: TJSONData;
begin
  PropData := Data.Find(PropName);
  if PropData <> nil then
  begin
    //todo: check propdata type
    ValueStr := PropData.AsString;
    FormatStr := OptionsData.Get('format', '');
    if FormatStr = 'date' then
      ValueStr := DateToStr(PropData.AsFloat)
    else if FormatStr = 'datetime' then
      ValueStr := DateTimeToStr(PropData.AsFloat);
    TemplateStr := OptionsData.Get('template', '%s');
    Control.Caption := Format(TemplateStr, [ValueStr]);
  end
  else
    Control.Caption := '';
end;

class procedure TJSONCaptionMediator.DoGUIToJSON(Control: TControl;
  Data: TJSONObject; const PropName: String; OptionsData: TJSONObject);
begin
  //
end;

initialization
  MediatorManager := TJSONGUIMediatorManager.Create;
  RegisterJSONMediator(TEdit, TJSONGenericMediator);
  RegisterJSONMediator(TMemo, TJSONGenericMediator);
  RegisterJSONMediator(TComboBox, TJSONComboBoxMediator);
  RegisterJSONMediator(TLabel, TJSONCaptionMediator);
  RegisterJSONMediator(TSpinEdit, TJSONSpinEditMediator);
  RegisterJSONMediator(TFloatSpinEdit, TJSONSpinEditMediator);
  RegisterJSONMediator(TRadioGroup, TJSONRadioGroupMediator);
  RegisterJSONMediator(TCheckBox, TJSONCheckBoxMediator);

finalization
  MediatorManager.Destroy;

end.


