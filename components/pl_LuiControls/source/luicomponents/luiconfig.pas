unit LuiConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, contnrs;

type

  TLuiConfig = class;

  { TLuiConfigProvider }

  TLuiConfigProvider = class(TComponent)
  protected
    function ReadInteger(const SectionTitle, ItemKey: String; out ValueExists: Boolean): Integer; virtual;
    function ReadString(const SectionTitle, ItemKey: String; out ValueExists: Boolean): String; virtual; abstract;
    function ReadBoolean(const SectionTitle, ItemKey: String; out ValueExists: Boolean): Boolean; virtual;
    function ReadFloat(const SectionTitle, ItemKey: String; out ValueExists: Boolean): Double; virtual;
    procedure ReadSection(const SectionTitle: String; Strings: TStrings); virtual; abstract;
    procedure ReadSections(Strings: TStrings); virtual; abstract;
    procedure WriteInteger(const SectionTitle, ItemKey: String; AValue: Integer); virtual;
    procedure WriteString(const SectionTitle, ItemKey: String; AValue: String); virtual; abstract;
    procedure WriteBoolean(const SectionTitle, ItemKey: String; AValue: Boolean); virtual;
    procedure WriteFloat(const SectionTitle, ItemKey: String; AValue: Double); virtual;
    procedure Open; virtual; abstract;
    procedure Close; virtual; abstract;
  end;

  TLuiConfigDataType = (ldtString, ldtInteger, ldtBoolean, ldtFloat);

  { TLuiConfigItemDef }

  TLuiConfigItemDef = class(TCollectionItem)
  private
    FDataType: TLuiConfigDataType;
    FDefaultValue: String;
    FDisplayText: String;
    FKey: String;
    FSection: String;
    procedure SetDataType(const AValue: TLuiConfigDataType);
    procedure SetDefaultValue(const AValue: String);
    procedure SetDisplayText(const AValue: String);
    procedure SetKey(const AValue: String);
    procedure SetSection(const AValue: String);
  protected
    function GetDisplayName: String; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property DataType: TLuiConfigDataType read FDataType write SetDataType;
    property DefaultValue: String read FDefaultValue write SetDefaultValue;
    property DisplayText: String read FDisplayText write SetDisplayText;
    property Key: String read FKey write SetKey;
    property Section: String read FSection write SetSection;
  end;

  { TLuiConfigItemDefs }

  TLuiConfigItemDefs = class(TCollection)
  private
    FOwner: TLuiConfig;
    FHashList: TFPHashList;
    FValidHashList: Boolean;
    procedure BuildHashList;
    function GetItem(Index: Integer): TLuiConfigItemDef;
  protected
    function GetOwner: TPersistent; override;
    procedure Notify(Item: TCollectionItem;
      Action: TCollectionNotification); override;
  public
    constructor Create(AOwner: TLuiConfig);
    destructor Destroy; override;
    function Add: TLuiConfigItemDef;
    function Find(const Section, Key: String): TLuiConfigItemDef;
    function GetDefaultString(const Section, Key: String): String;
    function GetDefaultInteger(const Section, Key: String): Integer;
    function GetDefaultBoolean(const Section, Key: String): Boolean;
    function GetDefaultFloat(const Section, Key: String): Double;
    property Items[Index: Integer]: TLuiConfigItemDef read GetItem; default;
  end;

  { TLuiConfigSectionDef }

  TLuiConfigSectionDef = class(TCollectionItem)
  private
    FDisplayText: String;
    FTitle: String;
    procedure SetDisplayTitle(const AValue: String);
    procedure SetTitle(const AValue: String);
  protected
    function GetDisplayName: String; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property DisplayText: String read FDisplayText write SetDisplayTitle;
    property Title: String read FTitle write SetTitle;
  end;

  { TLuiConfigSectionDefs }

  TLuiConfigSectionDefs = class(TCollection)
  private
    FOwner: TLuiConfig;
    FHashList: TFPHashList;
    FValidHashList: Boolean;
    procedure BuildHashList;
    function GetItem(Index: Integer): TLuiConfigSectionDef;
  protected
    function GetOwner: TPersistent; override;
    procedure Notify(Item: TCollectionItem;
      Action: TCollectionNotification); override;
  public
    constructor Create(AOwner: TLuiConfig);
    destructor Destroy; override;
    function Add: TLuiConfigSectionDef;
    function Find(const Title: String): TLuiConfigSectionDef;
    property Items[Index: Integer]: TLuiConfigSectionDef read GetItem; default;
  end;

  TLuiConfigNotificationType = (lcnOpen, lcnClose);

  ILuiConfigObserver = interface
    procedure ConfigNotification(NotificationType: TLuiConfigNotificationType;
      Data: PtrInt);
  end;

  TLuiConfigOption = (lcoParseMacros);

  TLuiConfigOptions = set of TLuiConfigOption;

  { TLuiConfig }

  TLuiConfig = class(TComponent)
  private
    FActive: Boolean;
    FDataProvider: TLuiConfigProvider;
    FItemDefs: TLuiConfigItemDefs;
    FObserverList: TFpList;
    FOptions: TLuiConfigOptions;
    FSectionDefs: TLuiConfigSectionDefs;
    procedure CheckObserverList;
    function HasObserver: Boolean;
    procedure InternalOpen;
    procedure InternalClose;
    procedure Notify(NotificationType: TLuiConfigNotificationType; Data: PtrInt);
    procedure SetActive(const AValue: Boolean);
    procedure SetDataProvider(const AValue: TLuiConfigProvider);
    procedure SetItemDefs(const AValue: TLuiConfigItemDefs);
    procedure SetSectionDefs(const AValue: TLuiConfigSectionDefs);
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddObserver(Observer: ILuiConfigObserver);
    function GetItemText(const ItemKey: String; const SectionTitle: String = ''): String;
    function GetSectionText(const SectionTitle: String): String;
    function ReadInteger(const SectionTitle, ItemKey: String): Integer;
    function ReadString(const SectionTitle, ItemKey: String): String;
    function ReadBoolean(const SectionTitle, ItemKey: String): Boolean;
    function ReadFloat(const SectionTitle, ItemKey: String): Double;
    function ReadValue(const SectionTitle, ItemKey: String): Variant;
    procedure ReadSection(const SectionTitle: String; Strings: TStrings; RetrieveEmpty: Boolean = False);
    procedure ReadSections(Strings: TStrings; RetrieveEmpty: Boolean = False);
    procedure RemoveObserver(Observer: ILuiConfigObserver);
    procedure WriteInteger(const SectionTitle, ItemKey: String; AValue: Integer);
    procedure WriteString(const SectionTitle, ItemKey: String; AValue: String);
    procedure WriteBoolean(const SectionTitle, ItemKey: String; AValue: Boolean);
    procedure WriteFloat(const SectionTitle, ItemKey: String; AValue: Double);
    procedure WriteValue(const SectionTitle, ItemKey: String; AValue: Variant);
  published
    property Active: Boolean read FActive write SetActive;
    property DataProvider: TLuiConfigProvider read FDataProvider write SetDataProvider;
    property ItemDefs: TLuiConfigItemDefs read FItemDefs write SetItemDefs;
    property Options: TLuiConfigOptions read FOptions write FOptions default [];
    property SectionDefs: TLuiConfigSectionDefs read FSectionDefs write SetSectionDefs;
  end;

//todo: use miscutils instead
function ReplacePathMacros(const Path: String): String;
function ReplacePathMacrosUTF8(const Path: String): String;

implementation

uses
  StrUtils, Variants;

function ReplacePathMacros(const Path: String): String;
begin
  Result := AnsiReplaceText(Path, '$(APP_CONFIG_DIR)', GetAppConfigDir(False));
  Result := AnsiReplaceText(Result, '$(EXE_DIR)', ExtractFileDir(ParamStr(0)));
  Result := AnsiReplaceText(Result, '$(PATH_DELIM)', PathDelim);
end;

function ReplacePathMacrosUTF8(const Path: String): String;
begin
  Result := AnsiReplaceText(Path, '$(APP_CONFIG_DIR)', UTF8Encode(GetAppConfigDir(False)));
  Result := AnsiReplaceText(Result, '$(EXE_DIR)', ExtractFileDir(UTF8Encode(ParamStr(0))));
  Result := AnsiReplaceText(Result, '$(PATH_DELIM)', PathDelim);
end;


{ TLuiConfig }

procedure TLuiConfig.SetDataProvider(const AValue: TLuiConfigProvider);
begin
  if FDataProvider = AValue then
    Exit;
  FDataProvider := AValue;
  if FDataProvider <> nil then
    FDataProvider.FreeNotification(Self);
end;

procedure TLuiConfig.SetItemDefs(const AValue: TLuiConfigItemDefs);
begin
  FItemDefs.Assign(AValue);
end;

procedure TLuiConfig.SetSectionDefs(const AValue: TLuiConfigSectionDefs);
begin
  FSectionDefs.Assign(AValue);
end;

procedure TLuiConfig.CheckObserverList;
begin
  if FObserverList = nil then
    FObserverList := TFPList.Create;
end;

function TLuiConfig.HasObserver: Boolean;
begin
  Result := (FObserverList <> nil) and (FObserverList.Count > 0);
end;

procedure TLuiConfig.InternalOpen;
begin
  if FDataProvider = nil then
    raise Exception.Create('DataProvider not set');
  FDataProvider.Open;
  Notify(lcnOpen, 0);
end;

procedure TLuiConfig.InternalClose;
begin
  if FDataProvider <> nil then
    FDataProvider.Close;
  Notify(lcnClose, 0);
end;

procedure TLuiConfig.Loaded;
begin
  inherited Loaded;
  if FActive then
    InternalOpen;
end;

procedure TLuiConfig.Notification(AComponent: TComponent; Operation: TOperation
  );
begin
  if (AComponent = FDataProvider) and (Operation = opRemove) then
  begin
    FDataProvider.RemoveFreeNotification(Self);
    FDataProvider := nil;
  end;
end;

procedure TLuiConfig.Notify(NotificationType: TLuiConfigNotificationType;
  Data: PtrInt);
var
  i: Integer;
begin
  if not HasObserver then
    Exit;
  for i := 0 to FObserverList.Count - 1 do
    ILuiConfigObserver(FObserverList[i]).ConfigNotification(NotificationType, Data);
end;

procedure TLuiConfig.SetActive(const AValue: Boolean);
begin
  if FActive = AValue then
    Exit;
  FActive := AValue;
  if csLoading in ComponentState then
    Exit;
  if FActive then
    InternalOpen
  else
    InternalClose;
end;

constructor TLuiConfig.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSectionDefs := TLuiConfigSectionDefs.Create(Self);
  FItemDefs := TLuiConfigItemDefs.Create(Self);
end;

destructor TLuiConfig.Destroy;
begin
  InternalClose;
  FSectionDefs.Destroy;
  FItemDefs.Destroy;
  FObserverList.Free;
  inherited Destroy;
end;

procedure TLuiConfig.AddObserver(Observer: ILuiConfigObserver);
begin
  CheckObserverList;
  FObserverList.Add(Observer);
end;

function TLuiConfig.GetItemText(const ItemKey: String; const SectionTitle: String): String;
var
  Item: TLuiConfigItemDef;
begin
  Item := FItemDefs.Find(SectionTitle, ItemKey);
  if (Item <> nil) and (Item.Section = SectionTitle) then
    Result := Item.DisplayName
  else
    Result := ItemKey;
end;

function TLuiConfig.GetSectionText(const SectionTitle: String): String;
var
  Section: TLuiConfigSectionDef;
begin
  Section := FSectionDefs.Find(SectionTitle);
  if Section <> nil then
    Result := Section.DisplayName
  else
    Result := SectionTitle;
end;

function TLuiConfig.ReadInteger(const SectionTitle, ItemKey: String): Integer;
var
  ValueExists: Boolean;
begin
  Result := FDataProvider.ReadInteger(SectionTitle, ItemKey, ValueExists);
  if not ValueExists then
    Result := FItemDefs.GetDefaultInteger(SectionTitle, ItemKey);
end;

function TLuiConfig.ReadString(const SectionTitle, ItemKey: String): String;
var
  ValueExists: Boolean;
begin
  Result := FDataProvider.ReadString(SectionTitle, ItemKey, ValueExists);
  if not ValueExists then
  begin
    Result := FItemDefs.GetDefaultString(SectionTitle, ItemKey);
    if (Result <> '') and (lcoParseMacros in FOptions) then
      Result := ReplacePathMacrosUTF8(Result);
  end;
end;

function TLuiConfig.ReadBoolean(const SectionTitle, ItemKey: String): Boolean;
var
  ValueExists: Boolean;
begin
  Result := FDataProvider.ReadBoolean(SectionTitle, ItemKey, ValueExists);
  if not ValueExists then
    Result := FItemDefs.GetDefaultBoolean(SectionTitle, ItemKey);
end;

function TLuiConfig.ReadFloat(const SectionTitle, ItemKey: String): Double;
var
  ValueExists: Boolean;
begin
  Result := FDataProvider.ReadFloat(SectionTitle, ItemKey, ValueExists);
  if not ValueExists then
    Result := FItemDefs.GetDefaultFloat(SectionTitle, ItemKey);
end;

function TLuiConfig.ReadValue(const SectionTitle, ItemKey: String): Variant;
var
  ValueExists: Boolean;
  Item: TLuiConfigItemDef;
  S: String;
begin
  Item := FItemDefs.Find(SectionTitle, ItemKey);
  if (Item <> nil) and (Item.DataType in [ldtBoolean, ldtFloat, ldtInteger]) then
  begin
    case Item.DataType of
     ldtBoolean:
       Result := DataProvider.ReadBoolean(SectionTitle, ItemKey, ValueExists);
     ldtInteger:
       Result := DataProvider.ReadInteger(SectionTitle, ItemKey, ValueExists);
     ldtFloat:
       Result := DataProvider.ReadFloat(SectionTitle, ItemKey, ValueExists);
    end;
    if not ValueExists then
      Result := Null;
  end
  else
  begin
    //fallback for string or special types that can be added in the future
    S := FDataProvider.ReadString(SectionTitle, ItemKey, ValueExists);
    if not ValueExists then
    begin
      if Item <> nil then
        S := Item.DefaultValue
      else
        S := FItemDefs.GetDefaultString(SectionTitle, ItemKey);

      if S = '' then
        Result := Null
      else
      begin
        if lcoParseMacros in FOptions then
          S := ReplacePathMacrosUTF8(S);
        Result := S;
      end;
    end
    else
      Result := S;
  end;
end;

procedure TLuiConfig.ReadSection(const SectionTitle: String; Strings: TStrings;
  RetrieveEmpty: Boolean);
var
  i, Last: Integer;
  Item: TLuiConfigItemDef;
begin
  FDataProvider.ReadSection(SectionTitle, Strings);

  //Add the items that exists in ItemDefs but not in the provider
  if RetrieveEmpty then
  begin
    Last := 0;
    for i := 0 to FItemDefs.Count - 1 do
    begin
      Item := TLuiConfigItemDef(FItemDefs.Items[i]);
      if ((Item.Section = '') or (Item.Section = SectionTitle)) and
        (Strings.IndexOf(Item.Key) = -1) then
      begin
        Strings.Insert(Last, Item.Key);
        Inc(Last);
      end;
    end;
  end;
end;

procedure TLuiConfig.ReadSections(Strings: TStrings; RetrieveEmpty: Boolean);
var
  i, j, Last: Integer;
begin
  FDataProvider.ReadSections(Strings);
  if RetrieveEmpty then
  begin
    Last := 0;
    for i := 0 to FSectionDefs.Count - 1 do
    begin
      j := Strings.IndexOf(FSectionDefs[i].Title);
      if j = -1 then
      begin
        Strings.Insert(Last, FSectionDefs[i].Title);
        Inc(Last);
      end;
    end;
  end;
end;

procedure TLuiConfig.RemoveObserver(Observer: ILuiConfigObserver);
begin
  if not HasObserver then
    Exit;
  FObserverList.Remove(Observer);
end;

procedure TLuiConfig.WriteInteger(const SectionTitle, ItemKey: String; AValue: Integer);
begin
  FDataProvider.WriteInteger(SectionTitle, ItemKey, AValue);
end;

procedure TLuiConfig.WriteString(const SectionTitle, ItemKey: String; AValue: String);
begin
  FDataProvider.WriteString(SectionTitle, ItemKey, AValue);
end;

procedure TLuiConfig.WriteBoolean(const SectionTitle, ItemKey: String; AValue: Boolean);
begin
  FDataProvider.WriteBoolean(SectionTitle, ItemKey, AValue);
end;

procedure TLuiConfig.WriteFloat(const SectionTitle, ItemKey: String; AValue: Double);
begin
  FDataProvider.WriteFloat(SectionTitle, ItemKey, AValue);
end;

procedure TLuiConfig.WriteValue(const SectionTitle, ItemKey: String;
  AValue: Variant);
var
  Item: TLuiConfigItemDef;
begin
  if VarIsNull(AValue) then
    FDataProvider.WriteString(SectionTitle, ItemKey, '')
  else
  begin
    Item := FItemDefs.Find(SectionTitle, ItemKey);
    if (Item <> nil) and (Item.DataType in [ldtInteger, ldtBoolean, ldtFloat]) then
    begin
      case Item.DataType of
        ldtBoolean:
          FDataProvider.WriteBoolean(SectionTitle, ItemKey, AValue);
        ldtInteger:
          FDataProvider.WriteInteger(SectionTitle, ItemKey, AValue);
        ldtFloat:
          FDataProvider.WriteFloat(SectionTitle, ItemKey, AValue);
      end;
    end
    else
      FDataProvider.WriteString(SectionTitle, ItemKey, AValue);
  end;
end;

{ TLuiConfigItemDef }

procedure TLuiConfigItemDef.SetKey(const AValue: String);
begin
  if FKey=AValue then exit;
  FKey:=AValue;
end;

procedure TLuiConfigItemDef.SetSection(const AValue: String);
begin
  if FSection=AValue then exit;
  FSection:=AValue;
end;

function TLuiConfigItemDef.GetDisplayName: String;
begin
  if FDisplayText <> '' then
    Result := FDisplayText
  else
    Result := FKey;
end;

procedure TLuiConfigItemDef.Assign(Source: TPersistent);
begin
  if Source is TLuiConfigItemDef then
  begin
    Key := TLuiConfigItemDef(Source).Key;
    DisplayText := TLuiConfigItemDef(Source).DisplayText;
    DefaultValue := TLuiConfigItemDef(Source).DefaultValue;
    DataType := TLuiConfigItemDef(Source).DataType;
    Section := TLuiConfigItemDef(Source).Section;
  end
  else
    inherited Assign(Source);
end;

procedure TLuiConfigItemDef.SetDataType(const AValue: TLuiConfigDataType);
begin
  if FDataType=AValue then exit;
  FDataType:=AValue;
end;

procedure TLuiConfigItemDef.SetDefaultValue(const AValue: String);
begin
  if FDefaultValue=AValue then exit;
  FDefaultValue:=AValue;
end;

procedure TLuiConfigItemDef.SetDisplayText(const AValue: String);
begin
  if FDisplayText=AValue then exit;
  FDisplayText:=AValue;
end;

{ TLuiConfigSectionDefs }

procedure TLuiConfigSectionDefs.BuildHashList;
var
  i: Integer;
  Section: TLuiConfigSectionDef;
begin
  if FHashList = nil then
    FHashList := TFPHashList.Create
  else
    FHashList.Clear;
  for i := 0 to Count - 1 do
  begin
    Section := TLuiConfigSectionDef(Items[i]);
    FHashList.Add(Section.Title, Section);
  end;
  FValidHashList := True;
end;

function TLuiConfigSectionDefs.GetItem(Index: Integer): TLuiConfigSectionDef;
begin
  Result := TLuiConfigSectionDef(inherited GetItem(Index));
end;

function TLuiConfigSectionDefs.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TLuiConfigSectionDefs.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
begin
  FValidHashList := False;
end;

constructor TLuiConfigSectionDefs.Create(AOwner: TLuiConfig);
begin
  inherited Create(TLuiConfigSectionDef);
  FOwner := AOwner;
end;

destructor TLuiConfigSectionDefs.Destroy;
begin
  FHashList.Free;
  inherited Destroy;
end;

function TLuiConfigSectionDefs.Add: TLuiConfigSectionDef;
begin
  Result := TLuiConfigSectionDef(inherited Add);
end;

function TLuiConfigSectionDefs.Find(const Title: String): TLuiConfigSectionDef;
begin
  if not FValidHashList then
    BuildHashList;
  Result := TLuiConfigSectionDef(FHashList.Find(Title));
end;

{ TLuiConfigSectionDef }

procedure TLuiConfigSectionDef.SetDisplayTitle(const AValue: String);
begin
  if FDisplayText=AValue then exit;
  FDisplayText:=AValue;
end;

procedure TLuiConfigSectionDef.SetTitle(const AValue: String);
begin
  if FTitle=AValue then exit;
  FTitle:=AValue;
end;

function TLuiConfigSectionDef.GetDisplayName: String;
begin
  if FDisplayText <> '' then
    Result := FDisplayText
  else
    Result := FTitle;
end;

procedure TLuiConfigSectionDef.Assign(Source: TPersistent);
begin
  if Source is TLuiConfigSectionDef then
  begin
    DisplayText := TLuiConfigSectionDef(Source).DisplayText;
    Title := TLuiConfigSectionDef(Source).Title;
  end
  else
    inherited Assign(Source);
end;

{ TLuiConfigItemDefs }

procedure TLuiConfigItemDefs.BuildHashList;
var
  i: Integer;
  Item: TLuiConfigItemDef;
begin
  if FHashList = nil then
    FHashList := TFPHashList.Create
  else
    FHashList.Clear;
  for i := 0 to Count - 1 do
  begin
    Item := TLuiConfigItemDef(Items[i]);
    FHashList.Add(Item.FSection + '.' + Item.Key, Item);
  end;
  FValidHashList := True;
end;

function TLuiConfigItemDefs.GetItem(Index: Integer): TLuiConfigItemDef;
begin
  Result := TLuiConfigItemDef(inherited GetItem(Index));
end;

function TLuiConfigItemDefs.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TLuiConfigItemDefs.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
begin
  FValidHashList := False;
end;

constructor TLuiConfigItemDefs.Create(AOwner: TLuiConfig);
begin
  inherited Create(TLuiConfigItemDef);
  FOwner := AOwner;
end;

destructor TLuiConfigItemDefs.Destroy;
begin
  FHashList.Free;
  inherited Destroy;
end;

function TLuiConfigItemDefs.Add: TLuiConfigItemDef;
begin
  //protect the case the user try to create a item twice
  Result := TLuiConfigItemDef(inherited Add);
end;

function TLuiConfigItemDefs.Find(const Section, Key: String): TLuiConfigItemDef;
begin
  if not FValidHashList then
    BuildHashList;
  Result := TLuiConfigItemDef(FHashList.Find(Section + '.' + Key));
end;

function TLuiConfigItemDefs.GetDefaultString(const Section, Key: String): String;
var
  Item: TLuiConfigItemDef;
begin
  Item := Find(Section, Key);
  if Item <> nil then
    Result := Item.DefaultValue
  else
    Result := '';
end;

function TLuiConfigItemDefs.GetDefaultInteger(const Section, Key: String): Integer;
begin
  Result := StrToIntDef(GetDefaultString(Section, Key), 0);
end;

function TLuiConfigItemDefs.GetDefaultBoolean(const Section, Key: String): Boolean;
begin
  Result := StrToBoolDef(GetDefaultString(Section, Key), False);
end;

function TLuiConfigItemDefs.GetDefaultFloat(const Section, Key: String): Double;
begin
  Result := StrToFloatDef(GetDefaultString(Section, Key), 0);
end;

{ TLuiConfigProvider }

function TLuiConfigProvider.ReadInteger(const SectionTitle, ItemKey: String; out ValueExists: Boolean): Integer;
begin
  Result := StrToIntDef(ReadString(SectionTitle, ItemKey, ValueExists), 0);
end;

function TLuiConfigProvider.ReadBoolean(const SectionTitle, ItemKey: String; out ValueExists: Boolean): Boolean;
begin
  Result := StrToBoolDef(ReadString(SectionTitle, ItemKey, ValueExists), False);
end;

function TLuiConfigProvider.ReadFloat(const SectionTitle, ItemKey: String; out ValueExists: Boolean): Double;
begin
  Result := StrToFloatDef(ReadString(SectionTitle, ItemKey, ValueExists), 0);
end;

procedure TLuiConfigProvider.WriteInteger(const SectionTitle, ItemKey: String;
  AValue: Integer);
begin
  WriteString(SectionTitle, ItemKey, IntToStr(AValue));
end;

procedure TLuiConfigProvider.WriteBoolean(const SectionTitle, ItemKey: String;
  AValue: Boolean);
begin
  WriteString(SectionTitle, ItemKey, IfThen(AValue, '1', '0'));
end;

procedure TLuiConfigProvider.WriteFloat(const SectionTitle, ItemKey: String;
  AValue: Double);
begin
  WriteString(SectionTitle, ItemKey, FloatToStr(AValue));
end;

end.

