unit LuiJSONLazReport;

{$mode objfpc}{$H+}
{.$define LAZREPORT_HAS_IGNORENOTFOUNDSYMBOL}
{.$define DEBUG_JSONLAZREPORT}

interface

uses
  Classes, SysUtils, LR_Class, LR_DSet, fpjson, contnrs;

type

  { TfrJSONDataset }

  TfrJSONDataset = class(TfrDataset)
  private
    FData: TJSONData;
  protected
    procedure DoCheckEOF(var IsEof: Boolean); override;
  public
    function GetBookMark: Pointer; override;
    procedure GetValue(const ParName: String; var ParValue: Variant);
    procedure GotoBookMark(BM: Pointer); override;
    property Data: TJSONData read FData write FData;
  end;

  TfrJSONDatasetClass = class of TfrJSONDataset;

  { TfrJSONCrossDataset }

  TfrJSONCrossDataset = class(TfrJSONDataset)
  private
    FMasterDataset: TfrJSONDataset;
    procedure UpdateMasterData;
  protected
    procedure DoFirst; override;
    procedure DoNext; override;
  public
    property MasterDataset: TfrJSONDataset read FMasterDataset write FMasterDataset;
  end;

  { TfrJSONDataLink }

  TfrJSONDataLink = class
  private
    FHideBand: Boolean;
    FBandName: String;
    FCrossBandName: String;
    FCrossDataset: TfrJSONDataset;
    FDataset: TfrJSONDataset;
    FPropertyName: String;
  public
    constructor Create(const ABandName, APropertyName, ACrossBandName: String; AHideBand: Boolean);
    property BandName: String read FBandName;
    property CrossBandName: String read FCrossBandName;
    property CrossDataset: TfrJSONDataset read FCrossDataset write FCrossDataset;
    property Dataset: TfrJSONDataset read FDataset write FDataset;
    property HideBand: Boolean read FHideBand;
    property PropertyName: String read FPropertyName;
  end;

  { TfrJSONReport }

  TfrJSONReport = class(TfrReport)
  private
    FConfigProperty: String;
    FDataProperty: String;
    FBaseConfigData: TJSONObject;
    FReportData: TJSONObject;
    FConfigData: TJSONObject;
    FData: TJSONObject;
    FDataLinks: TFPHashObjectList;
    FNullValues: TJSONObject;
    FOwnsConfigData: Boolean;
    FOwnsReportData: Boolean;
    procedure BaseConfigDataNeeded;
    procedure FreeDataLinks;
    function CreateJSONDataset(DatasetClass: TfrJSONDatasetClass; Index: Integer): TfrJSONDataset;
    procedure FreeOwnedData;
    function GetDataLoaded: Boolean;
    procedure LoadConfigData;
    procedure ParseConfigData(Data: TJSONObject);
  protected
    procedure DoBeginDoc; override;
    procedure DoGetValue(const ParName: String; var ParValue: Variant); override;
    procedure DoUserFunction(const AName: String; p1, p2, p3: Variant; var Val: Variant); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadData(ReportData: TJSONObject; OwnsReportData: Boolean = False);
    procedure LoadData(ReportData, ConfigData: TJSONObject; OwnsReportData: Boolean = False;
      OwnsConfigData: Boolean = False);
    procedure RegisterDataLink(const BandName, PropertyName: String; CrossBandName: String = '');
    procedure RegisterNullValue(const PropertyName: String; Value: Variant);
    property ConfigProperty: String read FConfigProperty write FConfigProperty;
    property Data: TJSONObject read FData;
    property DataLoaded: Boolean read GetDataLoaded;
    property DataProperty: String read FDataProperty write FDataProperty;
  end;

implementation

uses
  LuiJSONUtils, Variants {$ifdef DEBUG_JSONLAZREPORT}, LCLProc{$endif};

{ TfrJSONCrossDataset }

procedure TfrJSONCrossDataset.UpdateMasterData;
begin
  Assert(FMasterDataset <> nil, 'MasterDataset is nil');
  if (Data.JSONType = jtArray) and (RecNo < Data.Count) then
    FMasterDataset.Data := Data.Items[RecNo];
end;

procedure TfrJSONCrossDataset.DoFirst;
begin
  inherited DoFirst;
  UpdateMasterData;
end;

procedure TfrJSONCrossDataset.DoNext;
begin
  inherited DoNext;
  UpdateMasterData;
end;

{ TfrJSONDataLink }

constructor TfrJSONDataLink.Create(const ABandName, APropertyName, ACrossBandName: String;
  AHideBand: Boolean);
begin
  FBandName := ABandName;
  FPropertyName := APropertyName;
  FCrossBandName := ACrossBandName;
  FHideBand := AHideBand;
end;

{ TfrJSONDataset }

procedure TfrJSONDataset.DoCheckEOF(var IsEof: Boolean);
begin
  case FData.JSONType of
  jtArray:
    IsEof := RecNo >= FData.Count;
  jtObject:
    IsEof := RecNo = 1;
  else
    IsEof := True;
  end;
end;

function TfrJSONDataset.GetBookMark: Pointer;
begin
  Result := Pointer(PtrInt(FRecNo));
end;

procedure TfrJSONDataset.GetValue(const ParName: String; var ParValue: Variant);
var
  ArrayItem: TJSONData;
  PropData: TJSONData;
begin
  case FData.JSONType of
    jtArray:
      begin
        if RecNo < FData.Count then
        begin
          ArrayItem := FData.Items[RecNo];
          case ArrayItem.JSONType of
          jtObject:
            begin
              PropData := TJSONObject(ArrayItem).Find(ParName);
              if PropData <> nil then
                ParValue := PropData.Value;
            end;
          jtNumber, jtString, jtBoolean:
            begin
              ParValue := ArrayItem.Value;
            end;
          end;
        end;
      end;
    jtObject:
      begin
        PropData := TJSONObject(FData).Find(ParName);
        if PropData <> nil then
          ParValue := PropData.Value;
      end;
  end;
end;

procedure TfrJSONDataset.GotoBookMark(BM: Pointer);
var
  ARecNo: PtrInt absolute BM;
begin
  if (ARecNo < 0) or (ARecNo > FData.Count) then
    raise Exception.Create('TfrJSONDataset.GotoBookMark - RecNo Out Of Bounds');
  FRecNo := ARecNo;
end;

{ TfrJSONReport }

procedure TfrJSONReport.BaseConfigDataNeeded;
begin
  if FBaseConfigData = nil then
  begin
    FBaseConfigData := TJSONObject.Create;
    FBaseConfigData.Add('datalinks', TJSONObject.Create);
    FBaseConfigData.Add('nullvalues', TJSONObject.Create);
  end;
end;

procedure TfrJSONReport.FreeDataLinks;
var
  DataLink: TfrJSONDataLink;
  i: Integer;
begin
  for i := 0 to FDataLinks.Count - 1 do
  begin
    DataLink := TfrJSONDataLink(FDataLinks[i]);
    DataLink.Dataset.Free;
    DataLink.CrossDataset.Free;
  end;
end;

function TfrJSONReport.CreateJSONDataset(DatasetClass: TfrJSONDatasetClass; Index: Integer): TfrJSONDataset;
begin
  {$ifdef DEBUG_JSONLAZREPORT}
  if Owner <> nil then
    DebugLn('CreateJSONDataset - Owner: %s Report: %s DatasetClass: %s Index: %d',
      [Owner.Name, Name, DatasetClass.ClassName, Index])
  else
    DebugLn('CreateJSONDataset - Owner: nil Report: %s DatasetClass: %s Index: %d',
      [Name, DatasetClass.ClassName, Index]);
  {$endif}
  Result := DatasetClass.Create(Self.Owner);
  Result.Name := Name + DatasetClass.ClassName + IntToStr(Index);
  Result.FreeNotification(Self);
end;

procedure TfrJSONReport.FreeOwnedData;
begin
  if FOwnsReportData then
    FreeAndNil(FReportData);
  if FOwnsConfigData then
    FreeAndNil(FConfigData);
end;

function TfrJSONReport.GetDataLoaded: Boolean;
begin
  Result := FData <> nil;
end;

procedure TfrJSONReport.LoadConfigData;
begin
  FreeDataLinks;
  FNullValues.Clear;
  FDataLinks.Clear;
  ParseConfigData(FBaseConfigData);
  ParseConfigData(FConfigData);
end;

procedure TfrJSONReport.ParseConfigData(Data: TJSONObject);
var
  ItemData: TJSONData;
  ItemObject: TJSONObject absolute ItemData;
  DataLinksData: TJSONData;
  NullValuesData: TJSONData;
  PropertyName: String;
  i: Integer;
begin
  if Data = nil then
  begin
    DataLinksData := nil;
    NullValuesData := nil;
  end
  else
  begin
    DataLinksData := Data.Find('datalinks');
    NullValuesData := Data.Find('nullvalues');
    {$ifdef LAZREPORT_HAS_IGNORENOTFOUNDSYMBOL}
    ItemData := Data.Find('ignorenotfoundsymbol');
    if (ItemData <> nil) and (ItemData.JSONtype = jtBoolean) then
    begin
      if ItemData.AsBoolean then
        Options := Options + [roIgnoreSymbolNotFound]
      else
        Options := Options - [roIgnoreSymbolNotFound];
    end;
    {$endif}
  end;
  if NullValuesData <> nil then
  begin
    case NullValuesData.JSONType of
    jtObject:
      CopyJSONObject(TJSONObject(NullValuesData), FNullValues);
    jtArray:
      begin
        for i := 0 to NullValuesData.Count - 1 do
        begin
          ItemData := NullValuesData.Items[i];
          case ItemData.JSONType of
            jtString:
              FNullValues.Add(ItemData.AsString);
            jtObject:
              CopyJSONObject(ItemObject, FNullValues);
          end;
        end;
      end;
    end;
  end;

  if DataLinksData <> nil then
  begin
    for i := 0 to DataLinksData.Count - 1 do
    begin
      ItemData := DataLinksData.Items[i];
      if ItemData.JSONType = jtObject then
      begin
        PropertyName := ItemObject.Strings['property'];
        FDataLinks.Add(PropertyName, TfrJSONDataLink.Create(ItemObject.Get('band', ''),
          PropertyName, ItemObject.Get('crossband', ''),
          ItemObject.Get('hideband', False)));
      end;
    end;
  end;
end;

procedure TfrJSONReport.DoBeginDoc;
var
  i: Integer;
  DataLink: TfrJSONDataLink;
  PropertyData: TJSONData;
  Band: TfrBandView;
begin
  if FData = nil then
    raise Exception.Create('TfrJSONReport.FData = nil');
  if Owner = nil then
    raise Exception.Create('TfrJSONReport.Owner = nil');
  for i := 0 to FDataLinks.Count - 1 do
  begin
    DataLink := TfrJSONDataLink(FDataLinks[i]);
    Band := FindObject(DataLink.BandName) as TfrBandView;
    if Band = nil then
      raise Exception.CreateFmt('Band "%s" not found', [DataLink.BandName]);
    PropertyData := FData.Find(DataLink.PropertyName);
    if PropertyData = nil then
    begin
      if DataLink.HideBand then
        Band.Visible := False;
      Continue;
    end;
    if DataLink.Dataset = nil then
      DataLink.Dataset := CreateJSONDataset(TfrJSONDataset, i);
    Band.DataSet := DataLink.Dataset.Name;
    DataLink.Dataset.Data := PropertyData;
    if DataLink.CrossBandName <> '' then
    begin
      Band := FindObject(DataLink.CrossBandName) as TfrBandView;
      if Band = nil then
        raise Exception.CreateFmt('CrossBand "%s" not found', [DataLink.CrossBandName]);
      if Band.BandType <> btCrossData then
        raise Exception.CreateFmt('Band "%s" type different from CrossData', [DataLink.CrossBandName]);
      if DataLink.CrossDataset = nil then
        DataLink.CrossDataset := CreateJSONDataset(TfrJSONCrossDataset, i);
      TfrJSONCrossDataset(DataLink.CrossDataset).MasterDataset := DataLink.Dataset;
      Band.DataSet := DataLink.BandName + '=' + DataLink.CrossDataset.Name + ';';
      Band.DataSet := DataLink.CrossDataset.Name;
      DataLink.CrossDataset.Data := PropertyData;
    end;
  end;
  inherited DoBeginDoc;
end;

procedure TfrJSONReport.DoGetValue(const ParName: String; var ParValue: Variant);
var
  PropData: TJSONData;
  PropDataObj: TJSONObject absolute PropData;
  DataLink: TfrJSONDataLink;
  PropertyName: String;
  DotPos: Integer;
begin
  inherited DoGetValue(ParName, ParValue);
  if VarIsEmpty(ParValue) then
  begin
    DotPos := Pos('.', ParName);
    if DotPos = 0 then
    begin
      PropData := FData.Find(ParName);
      if (PropData <> nil) then
      begin
        case PropData.JSONType of
          jtObject: ParValue := '(object)';
          jtArray: ParValue := '(array)';
          jtNull: ParValue := Null;
          else
            ParValue := PropData.Value;
        end;
      end;
    end
    else
    begin
      PropertyName := Copy(ParName, 1, DotPos - 1);
      DataLink := TfrJSONDataLink(FDataLinks.Find(PropertyName));
      if (DataLink <> nil) and (DataLink.Dataset <> nil) then
      begin
        PropertyName := Copy(ParName, DotPos + 1, Length(ParName));
        DataLink.Dataset.GetValue(PropertyName, ParValue);
      end
      else
      begin
        if FindJSONProp(FData, PropertyName, PropDataObj) then
        begin
          PropertyName := Copy(ParName, DotPos + 1, Length(ParName));
          PropData := PropDataObj.Find(PropertyName);
          if PropData <> nil then
            ParValue := PropData.Value;
        end;
      end;
    end;
    if VarIsEmpty(ParValue) then
    begin
      PropData := FNullValues.Find(ParName);
      if PropData <> nil then
        ParValue := PropData.Value;
    end;
  end;
end;

procedure TfrJSONReport.DoUserFunction(const AName: String; p1, p2,
  p3: Variant; var Val: Variant);
var
  V1, V2: Variant;
  S2, S3: String;
  VType: tvartype;
  ArrayData: TJSONArray;
  ItemData: TJSONData;
begin
  if AName = 'IFNULL' then
  begin
    V1 := frParser.Calc(P1);
    if VarIsNull(V1) then
    begin
      S2 := P2;
      if S2 <> '' then
        Val := frParser.Calc(S2)
      else
        Val := Null;
    end
    else
    begin
      S3 := P3;
      if S3 = '' then
        Val := V1
      else
        Val := frParser.Calc(S3);
    end;
  end
  else if AName = 'ISNULL' then
  begin
    V1 := frParser.Calc(P1);
    Val := VarIsNull(V1);
  end
  //due to lazreport design V1 is never varempty
  {
  else if AName = 'ISUNDEFINED' then
  begin
    V1 := frParser.Calc(P1);
    Val := VarIsEmpty(V1);
  end
  }
  else if AName = 'ISEMPTY' then
  begin
    V1 := frParser.Calc(P1);
    VType := VarType(V1);
    Val := (VType in [varempty, varnull]) or
      ((VType in [varstring, varustring]) and (V1 = ''));
  end
  else if AName = 'IFTHEN' then
  begin
    V1 := frParser.Calc(P1);
    if (VarType(V1) in [varshortint, varboolean, varnull, varempty]) then
    begin
      if (V1 = 1) or (V1 = True) then
      begin
        S2 := P2;
        if S2 <> '' then
          Val := frParser.Calc(S2)
        else
          Val := Null;
      end
      else
      begin
        S3 := P3;
        if S3 = '' then
          Val := Null
        else
          Val := frParser.Calc(S3);
      end;
    end;
  end else if AName = 'IFFINDITEM' then
  begin
    Val := '';
    V1 := frParser.Calc(p1);
    V2 := frParser.Calc(p2);
    if VarIsStr(V1) and not VarIsNull(V2) then
    begin
      //todo: use findpath or change context dinamically??
      if FindJSONProp(FData, VarToStr(V1), ArrayData) then
      begin
        if GetJSONIndexOf(ArrayData, V2) > -1 then
          Val := frParser.Calc(p3);
      end;
    end;
  end
  else
    inherited;
end;

procedure TfrJSONReport.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  i: Integer;
  DataLink: TfrJSONDataLink;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent is TfrJSONDataset) then
  begin
    for i := 0 to FDataLinks.Count - 1 do
    begin
      DataLink := TfrJSONDataLink(FDataLinks[i]);
      if DataLink.Dataset = AComponent then
        DataLink.Dataset := nil
      else if DataLink.CrossDataset = AComponent then
        DataLink.CrossDataset := nil;
    end;
  end;
end;

constructor TfrJSONReport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLinks := TFPHashObjectList.Create(True);
  FNullValues := TJSONObject.Create;
  FConfigProperty := 'report.config';
end;

destructor TfrJSONReport.Destroy;
begin
  FreeDataLinks;
  FreeOwnedData;
  FDataLinks.Destroy;
  FNullValues.Destroy;
  FBaseConfigData.Free;
  inherited Destroy;
end;

procedure TfrJSONReport.LoadData(ReportData: TJSONObject;
  OwnsReportData: Boolean);
begin
  if ReportData = nil then
    raise Exception.Create('TfrJSONReport.LoadData ReportData = nil');
  FreeOwnedData;
  FReportData := ReportData;
  FOwnsReportData := OwnsReportData;
  if FDataProperty <> '' then
    FData := ReportData.Objects[FDataProperty]
  else
    FData := ReportData;
  FindJSONProp(ReportData, FConfigProperty, FConfigData);
  FOwnsConfigData := False;
  LoadConfigData;
end;

procedure TfrJSONReport.LoadData(ReportData, ConfigData: TJSONObject;
  OwnsReportData: Boolean; OwnsConfigData: Boolean);
begin
  //todo: unify LoadData
  if ReportData = nil then
    raise Exception.Create('TfrJSONReport.LoadData ReportData = nil');
  FreeOwnedData;
  FReportData := ReportData;
  FOwnsReportData := OwnsReportData;
  if FDataProperty <> '' then
    FData := ReportData.Objects[FDataProperty]
  else
    FData := ReportData;
  if ConfigData <> nil then
  begin
    FConfigData := ConfigData;
    FOwnsConfigData := OwnsConfigData;
  end
  else
  begin
    FindJSONProp(ReportData, FConfigProperty, FConfigData);
    FOwnsConfigData := False;
  end;
  LoadConfigData;
end;

procedure TfrJSONReport.RegisterDataLink(const BandName, PropertyName: String;
  CrossBandName: String);
var
  DataLinksData: TJSONObject;
  DataLink: TJSONObject;
begin
  BaseConfigDataNeeded;
  DataLinksData := FBaseConfigData.Objects['datalinks'];
  DataLink := TJSONObject.Create(['band', BandName, 'property', PropertyName]);
  if CrossBandName <> '' then
    DataLink.Add('crossband', CrossBandName);
  DataLinksData.Objects[PropertyName] := DataLink;
end;

procedure TfrJSONReport.RegisterNullValue(const PropertyName: String; Value: Variant);
var
  NullValuesData: TJSONObject;
begin
  BaseConfigDataNeeded;
  NullValuesData := FBaseConfigData.Objects['nullvalues'];
  SetJSONPropValue(NullValuesData, PropertyName, Value);
end;

end.

