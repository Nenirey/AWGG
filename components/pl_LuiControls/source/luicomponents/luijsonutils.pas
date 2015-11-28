unit LuiJSONUtils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpjson, db;

type

  { TJSONFile }

  TJSONFile = class
  public
    class function Load(const AFileName: String): TJSONData; static;
    class procedure Save(AData: TJSONData; const AFileName: String; FormatOptions: TFormatOptions); static;
  end;

  TJSONArraySortCompare = function(JSONArray: TJSONArray; Index1, Index2: Integer): Integer;

  TDatasetToJSONOption = (djoSetNull, djoCurrentRecord, djoPreserveCase);

  TDatasetToJSONOptions = set of TDatasetToJSONOption;

  TCopyJSONObjectOption = (cjoSetUndefined, cjoSetNull, cjoOverwrite);

  TCopyJSONObjectOptions = set of TCopyJSONObjectOption;

function CompareJSONData(Data1, Data2: TJSONData): Integer;

procedure CopyJSONObject(SrcObj, DestObj: TJSONObject; const Properties: array of String;
  Options: TCopyJSONObjectOptions = [cjoOverwrite, cjoSetNull]);

procedure CopyJSONObject(SrcObj, DestObj: TJSONObject);

function FindJSONObject(JSONArray: TJSONArray; const ObjProps: array of Variant): TJSONObject;

function FindJSONProp(JSONObj: TJSONObject; const PropName: String; out PropData: TJSONObject): Boolean;

function FindJSONProp(JSONObj: TJSONObject; const PropName: String; out PropData: TJSONArray): Boolean;

function FindJSONProp(JSONObj: TJSONObject; const PropName: String; out PropValue: Integer): Boolean;

function FindJSONProp(JSONObj: TJSONObject; const PropName: String; out PropValue: Int64): Boolean;

function FindJSONProp(JSONObj: TJSONObject; const PropName: String; out PropValue: Double): Boolean;

function FindJSONProp(JSONObj: TJSONObject; const PropName: String; out PropValue: Boolean): Boolean;

function FindJSONProp(JSONObj: TJSONObject; const PropName: String; out PropValue: String): Boolean;

function GetJSONIndexOf(JSONArray: TJSONArray; const ItemValue: Variant): Integer;

function GetJSONIndexOf(JSONArray: TJSONArray; const ObjProps: array of Variant): Integer;

function SameValue(JSONData: TJSONData; Value: Variant): Boolean;

function SameJSONObject(JSONObj1, JSONObj2: TJSONObject): Boolean;

procedure SortJSONArray(JSONArray: TJSONArray);

procedure SortJSONArray(JSONArray: TJSONArray; CompareFn: TJSONArraySortCompare);

procedure SetJSONPropValue(JSONObj: TJSONObject; const PropName: String; Value: Variant; SetNull: Boolean = False);

function StrToJSON(const JSONStr: TJSONStringType): TJSONData;

function TryStrToJSON(const JSONStr: TJSONStringType; out JSONData: TJSONData): Boolean;

function TryStrToJSON(const JSONStr: TJSONStringType; out JSONArray: TJSONArray): Boolean;

function TryStrToJSON(const JSONStr: TJSONStringType; out JSONObject: TJSONObject): Boolean;

function StreamToJSONData(Stream: TStream): TJSONData;

function DatasetToJSON(Dataset: TDataset; Options: TDatasetToJSONOptions; const ExtOptions: TJSONStringType): TJSONData;

procedure DatasetToJSON(Dataset: TDataset; JSONArray: TJSONArray; Options: TDatasetToJSONOptions);

procedure DatasetToJSON(Dataset: TDataset; JSONObject: TJSONObject; Options: TDatasetToJSONOptions);

procedure DatasetToJSON(Dataset: TDataset; JSONArray: TJSONArray;
  Options: TDatasetToJSONOptions; const ExtOptions: TJSONStringType);

procedure DatasetToJSON(Dataset: TDataset; JSONObject: TJSONObject;
  Options: TDatasetToJSONOptions; const ExtOptions: TJSONStringType);


implementation

uses
  jsonparser, Variants, math;

type

  TFieldMap = record
    Field: TField;
    Name: String;
  end;

  TFieldMaps = array of TFieldMap;

function CompareJSONData(Data1, Data2: TJSONData): Integer;
var
  Data1Type, Data2Type: TJSONtype;
begin
  if Data1 <> nil then
  begin
    if Data2 <> nil then
    begin
      //data1 <> nil, data2 <> nil
      Data1Type := Data1.JSONType;
      Data2Type := Data2.JSONType;
      if Data1Type = Data2Type then
      begin
        case Data1Type of
        jtNumber:
          Result := CompareValue(Data1.AsInt64, Data2.AsInt64);
        jtString:
          Result := CompareText(Data1.AsString, Data2.AsString);
        jtBoolean:
          Result := CompareValue(Ord(Data1.AsBoolean), Ord(Data2.AsBoolean));
        else
          Result := 0;
        end;
      end
      else
      begin
        if Data1Type = jtNull then
          Result := -1
        else
          //Data2type = jtNull or two values have different types and cannot be compared
          //VarCompareValue raises an exception when trying to compare such values
          Result := 1
      end;
    end
    else
    begin
      //data1 <> nil, data2 = nil
      if Data1.JSONType <> jtNull then
        Result := 1
      else
        Result := 0;
    end;
  end
  else
  begin
    if Data2 = nil then
    begin
      //data1 = nil, data2 = nil
      Result := 0
    end
    else
    begin
      //data1 = nil, data2 <> nil
      if Data2.JSONType <> jtNull then
        Result := -1
      else
        Result := 0;
    end;
  end;
end;

procedure CopyJSONObject(SrcObj, DestObj: TJSONObject; const Properties: array of String;
  Options: TCopyJSONObjectOptions);
var
  PropertyName: String;
  PropIndex, SrcIndex, DestIndex: Integer;
begin
  for PropIndex := Low(Properties) to High(Properties) do
  begin
    PropertyName := Properties[PropIndex];
    SrcIndex := SrcObj.IndexOfName(PropertyName);
    if SrcIndex <> -1 then
    begin
      DestIndex := DestObj.IndexOfName(PropertyName);
      if SrcObj.Items[SrcIndex].JSONType = jtNull then
      begin
        if cjoOverwrite in Options then
        begin
          if DestIndex <> - 1 then
          begin
            if (cjoSetNull in Options) then
              DestObj.Items[DestIndex] := TJSONNull.Create
            else
              DestObj.Delete(DestIndex);
          end else
          begin
            if (cjoSetNull in Options) then
              DestObj.Nulls[PropertyName] := True;
          end;
        end else
        begin
          if (DestIndex = -1) and (cjoSetNull in Options) then
            DestObj.Nulls[PropertyName] := True;
        end;
      end else
      begin
        if cjoOverwrite in Options then
        begin
          if DestIndex = -1 then
            DestObj.Elements[PropertyName] := SrcObj.Items[SrcIndex].Clone
          else
            DestObj.Items[DestIndex] := SrcObj.Items[SrcIndex].Clone;
        end else
        begin
          if DestIndex = -1 then
            DestObj.Elements[PropertyName] := SrcObj.Items[SrcIndex].Clone;
        end;
      end;
    end else
    begin
      DestIndex := DestObj.IndexOfName(PropertyName);
      if cjoOverwrite in Options then
      begin
        if cjoSetUndefined in Options then
        begin
          if DestIndex <> -1 then
            DestObj.Items[DestIndex] := TJSONNull.Create
          else
            DestObj.Nulls[PropertyName] := True;
        end else
        begin
          if DestIndex <> -1 then
            DestObj.Delete(DestIndex);
        end;
      end else
      begin
        if DestIndex = -1 then
        begin
          if cjoSetUndefined in Options then
            DestObj.Nulls[PropertyName] := True
        end;
      end;
    end;
  end;
end;

procedure CopyJSONObject(SrcObj, DestObj: TJSONObject);
var
  i: Integer;
begin
  for i := 0 to SrcObj.Count - 1 do
    DestObj.Elements[SrcObj.Names[i]] := SrcObj.Items[i].Clone;
end;

procedure CopyJSONObject(SrcObj, DestObj: TJSONObject; Options: TCopyJSONObjectOptions);
var
  i: Integer;
  PropName: String;
begin
  if cjoOverwrite in Options then
    CopyJSONObject(SrcObj, DestObj)
  else
  begin
    for i := 0 to SrcObj.Count - 1 do
    begin
      PropName := SrcObj.Names[i];
      if DestObj.IndexOfName(PropName) = -1 then
        DestObj.Elements[PropName] := SrcObj.Items[i].Clone;
    end;
  end;
end;

function FindJSONObject(JSONArray: TJSONArray; const ObjProps: array of Variant): TJSONObject;
var
  i: Integer;
begin
  i := GetJSONIndexOf(JSONArray, ObjProps);
  if i > -1 then
    Result := TJSONObject(JSONArray.Items[i])
  else
    Result := nil;
end;

function FindJSONProp(JSONObj: TJSONObject; const PropName: String; out PropData: TJSONObject): Boolean;
var
  Data: TJSONData absolute PropData;
begin
  Data := JSONObj.Find(PropName, jtObject);
  Result := PropData <> nil;
end;

function FindJSONProp(JSONObj: TJSONObject; const PropName: String; out PropData: TJSONArray): Boolean;
var
  Data: TJSONData absolute PropData;
begin
  Data := JSONObj.Find(PropName, jtArray);
  Result := PropData <> nil;
end;

function FindJSONProp(JSONObj: TJSONObject; const PropName: String; out PropValue: Integer): Boolean;
var
  Data: TJSONData;
begin
  Data := JSONObj.Find(PropName, jtNumber);
  Result := Data <> nil;
  if Result then
    PropValue := Data.AsInteger
  else
    PropValue := 0;
end;

function FindJSONProp(JSONObj: TJSONObject; const PropName: String; out PropValue: Int64): Boolean;
var
  Data: TJSONData;
begin
  Data := JSONObj.Find(PropName, jtNumber);
  Result := Data <> nil;
  if Result then
    PropValue := Data.AsInt64
  else
    PropValue := 0;
end;

function FindJSONProp(JSONObj: TJSONObject; const PropName: String; out PropValue: Double): Boolean;
var
  Data: TJSONData;
begin
  Data := JSONObj.Find(PropName, jtNumber);
  Result := Data <> nil;
  if Result then
    PropValue := Data.AsFloat
  else
    PropValue := 0;
end;

function FindJSONProp(JSONObj: TJSONObject; const PropName: String; out PropValue: Boolean): Boolean;
var
  Data: TJSONData;
begin
  Data := JSONObj.Find(PropName, jtBoolean);
  Result := Data <> nil;
  if Result then
    PropValue := Data.AsBoolean
  else
    PropValue := False;
end;

function FindJSONProp(JSONObj: TJSONObject; const PropName: String; out PropValue: String): Boolean;
var
  Data: TJSONData;
begin
  Data := JSONObj.Find(PropName, jtString);
  Result := Data <> nil;
  if Result then
    PropValue := Data.AsString
  else
    PropValue := '';
end;

function GetJSONIndexOf(JSONArray: TJSONArray; const ItemValue: Variant): Integer;
begin
  for Result := 0 to JSONArray.Count - 1 do
  begin
    if SameValue(JSONArray.Items[Result], ItemValue) then
      Exit;
  end;
  Result := -1;
end;

function GetJSONIndexOf(JSONArray: TJSONArray; const ObjProps: array of Variant): Integer;
var
  PropCount, i: Integer;
  ItemData, PropData: TJSONData;
  ItemObj: TJSONObject absolute ItemData;
  ObjMatches: Boolean;
begin
  PropCount := Length(ObjProps);
  Result := -1;
  if odd(PropCount) then
    raise Exception.Create('GetJSONIndexOf - Properties must have even length');
  PropCount := PropCount div 2;
  for Result := 0 to JSONArray.Count - 1 do
  begin
    ItemData := JSONArray.Items[Result];
    ObjMatches := False;
    if ItemData.JSONType = jtObject then
    begin
      for i := 0 to PropCount - 1 do
      begin
        PropData := ItemObj.Find(ObjProps[i * 2]);
        ObjMatches := (PropData <> nil) and SameValue(PropData, ObjProps[(i * 2) + 1]);
        if not ObjMatches then
          break;
      end;
    end;
    if ObjMatches then
      Exit;
  end;
  Result := -1;
end;

procedure RemoveJSONProp(JSONObj: TJSONObject; const PropName: String);
var
  i: Integer;
begin
  i := JSONObj.IndexOfName(PropName);
  if i <> -1 then
    JSONObj.Delete(i);
end;

//based in TStringList.QuickSort
procedure JSONArrayQuickSort(JSONArray: TJSONArray; L, R: Integer; CompareFn: TJSONArraySortCompare);
var
  Pivot, vL, vR: Integer;
begin
  if R - L <= 1 then begin // a little bit of time saver
    if L < R then
      if CompareFn(JSONArray, L, R) > 0 then
        JSONArray.Exchange(L, R);

    Exit;
  end;

  vL := L;
  vR := R;

  Pivot := L + Random(R - L); // they say random is best

  while vL < vR do begin
    while (vL < Pivot) and (CompareFn(JSONArray, vL, Pivot) <= 0) do
      Inc(vL);

    while (vR > Pivot) and (CompareFn(JSONArray, vR, Pivot) > 0) do
      Dec(vR);

    JSONArray.Exchange(vL, vR);

    if Pivot = vL then // swap pivot if we just hit it from one side
      Pivot := vR
    else if Pivot = vR then
      Pivot := vL;
  end;

  if Pivot - 1 >= L then
    JSONArrayQuickSort(JSONArray, L, Pivot - 1, CompareFn);
  if Pivot + 1 <= R then
    JSONArrayQuickSort(JSONArray, Pivot + 1, R, CompareFn);
end;

function JSONArraySimpleCompare(JSONArray: TJSONArray; Index1, Index2: Integer): Integer;
begin
  Result := CompareJSONData(JSONArray.Items[Index1], JSONArray.Items[Index2]);
end;

function SameValue(JSONData: TJSONData; Value: Variant): Boolean;
begin
  Result := False;
  case VarType(Value) of
    varnull:  Result := JSONData.JSONType = jtNull;
    varstring: Result := (JSONData.JSONType = jtString) and (JSONData.AsString = Value);
    vardouble, vardate: Result := (JSONData.JSONType = jtNumber) and (JSONData.AsFloat = Value);
    varinteger, varlongword, varshortint: Result := (JSONData.JSONType = jtNumber) and (JSONData.AsInteger = Value);
    varint64, varqword: Result := (JSONData.JSONType = jtNumber) and (JSONData.AsInt64 = Value);
    varboolean: Result := (JSONData.JSONType = jtBoolean) and (JSONData.AsBoolean = Value);
  end;
end;

function SameJSONObject(JSONObj1, JSONObj2: TJSONObject): Boolean;
var
  PropIndex1, PropIndex2: Integer;
  PropName: String;
begin
  if (JSONObj1 = nil) or (JSONObj2 = nil) then
    Exit(False);
  Result := JSONObj1.Count = JSONObj2.Count;
  PropIndex1 := 0;
  while Result and (PropIndex1 < JSONObj1.Count) do
  begin
    PropName := JSONObj1.Names[PropIndex1];
    PropIndex2 := JSONObj2.IndexOfName(PropName);
    if PropIndex2 >= 0 then
    begin
      Result := CompareJSONData(JSONObj1.Items[PropIndex1], JSONObj2.Items[PropIndex2]) = 0;
    end
    else
    begin
      Result := False;
    end;
    Inc(PropIndex1);
  end;
end;

procedure SortJSONArray(JSONArray: TJSONArray);
begin
  JSONArrayQuickSort(JSONArray, 0, JSONArray.Count - 1, @JSONArraySimpleCompare);
end;

procedure SortJSONArray(JSONArray: TJSONArray; CompareFn: TJSONArraySortCompare);
begin
  JSONArrayQuickSort(JSONArray, 0, JSONArray.Count - 1, CompareFn);
end;

procedure SetJSONPropValue(JSONObj: TJSONObject; const PropName: String; Value: Variant; SetNull: Boolean = False);
var
  VariantType: tvartype;
begin
  VariantType := VarType(Value);
  case VariantType of
    varnull:
    begin
      if SetNull then
        JSONObj.Elements[PropName] := TJSONNull.Create;
    end;
    varstring: JSONObj.Elements[PropName] := TJSONString.Create(Value);
    vardouble, vardate: JSONObj.Elements[PropName] := TJSONFloatNumber.Create(Value);
    varinteger, varlongword: JSONObj.Elements[PropName] := TJSONIntegerNumber.Create(Value);
    varint64, varqword: JSONObj.Elements[PropName] := TJSONInt64Number.Create(Value);
    varboolean: JSONObj.Elements[PropName] := TJSONBoolean.Create(Value);
  else
    raise Exception.CreateFmt('SetJSONPropValue - Type %d not handled', [VariantType]);
  end
end;

function StrToJSON(const JSONStr: TJSONStringType): TJSONData;
var
  Parser: TJSONParser;
begin
  Parser := TJSONParser.Create(JSONStr);
  try
    Result := Parser.Parse;
  finally
    Parser.Destroy;
  end;
end;

function TryStrToJSON(const JSONStr: TJSONStringType; out JSONData: TJSONData): Boolean;
var
  Parser: TJSONParser;
begin
  Result := True;
  JSONData := nil;
  Parser := TJSONParser.Create(JSONStr);
  try
    try
      JSONData := Parser.Parse;
    except
      Result := False;
    end;
  finally
    Parser.Destroy;
  end;
  Result := Result and (JSONData <> nil);
  if not Result then
    FreeAndNil(JSONData);
end;

function TryStrToJSON(const JSONStr: TJSONStringType; out JSONArray: TJSONArray): Boolean;
var
  Parser: TJSONParser;
  JSONData: TJSONData;
begin
  Result := True;
  JSONArray := nil;
  JSONData := nil;
  Parser := TJSONParser.Create(JSONStr);
  try
    try
      JSONData := Parser.Parse;
    except
      Result := False;
    end;
  finally
    Parser.Destroy;
  end;
  Result := Result and (JSONData <> nil) and (JSONData.JSONType = jtArray);
  if Result then
    JSONArray := TJSONArray(JSONData)
  else
    JSONData.Free;
end;

function TryStrToJSON(const JSONStr: TJSONStringType; out JSONObject: TJSONObject): Boolean;
var
  Parser: TJSONParser;
  JSONData: TJSONData;
begin
  Result := True;
  JSONObject := nil;
  JSONData := nil;
  Parser := TJSONParser.Create(JSONStr);
  try
    try
      JSONData := Parser.Parse;
    except
      Result := False;
    end;
  finally
    Parser.Destroy;
  end;
  Result := Result and (JSONData <> nil) and (JSONData.JSONType = jtObject);
  if Result then
    JSONObject := TJSONObject(JSONData)
  else
    JSONData.Free;
end;

function StreamToJSONData(Stream: TStream): TJSONData;
var
  Parser: TJSONParser;
begin
  Parser := TJSONParser.Create(Stream);
  try
    Result := Parser.Parse;
  finally
    Parser.Destroy;
  end;
end;

procedure CopyFieldsToJSONObject(Fields: TFieldMaps; JSONObject: TJSONObject; SetNull: Boolean);
var
  i: Integer;
begin
  for i := 0 to Length(Fields) - 1 do
    SetJSONPropValue(JSONObject, Fields[i].Name, Fields[i].Field.AsVariant, SetNull);
end;

//todo implement array of arrays
procedure DatasetToJSON(Dataset: TDataset; JSONArray: TJSONArray; Options: TDatasetToJSONOptions);
var
  OldRecNo: Integer;
  RecordData: TJSONObject;
begin
  if Dataset.IsEmpty then
    Exit;
  if djoCurrentRecord in Options then
  begin
    RecordData := TJSONObject.Create;
    DatasetToJSON(Dataset, RecordData, Options);
    JSONArray.Add(RecordData);
  end
  else
  begin
    Dataset.DisableControls;
    OldRecNo := Dataset.RecNo;
    try
      Dataset.First;
      while not Dataset.EOF do
      begin
        RecordData := TJSONObject.Create;
        DatasetToJSON(Dataset, RecordData, Options);
        JSONArray.Add(RecordData);
        Dataset.Next;
      end;
    finally
      Dataset.RecNo := OldRecNo;
      Dataset.EnableControls;
    end;
  end;
end;

function DatasetToJSON(Dataset: TDataset; Options: TDatasetToJSONOptions; const ExtOptions: TJSONStringType): TJSONData;
begin
  if not (djoCurrentRecord in Options) then
  begin
    Result := TJSONArray.Create;
    if ExtOptions = '' then
      DatasetToJSON(Dataset, TJSONArray(Result), Options)
    else
      DatasetToJSON(Dataset, TJSONArray(Result), Options, ExtOptions);
  end
  else
  begin
    Result := TJSONObject.Create;
    if ExtOptions = '' then
      DatasetToJSON(Dataset, TJSONObject(Result), Options)
    else
      DatasetToJSON(Dataset, TJSONObject(Result), Options, ExtOptions);
  end;
end;

procedure DatasetToJSON(Dataset: TDataset; JSONObject: TJSONObject; Options: TDatasetToJSONOptions);
var
  i: Integer;
  Field: TField;
  SetNull, PreserveCase: Boolean;
begin
  SetNull := djoSetNull in Options;
  PreserveCase := djoPreserveCase in Options;
  for i := 0 to Dataset.Fields.Count - 1 do
  begin
    Field := Dataset.Fields[i];
    if not PreserveCase then
      SetJSONPropValue(JSONObject, LowerCase(Field.FieldName), Field.AsVariant, SetNull)
    else
      SetJSONPropValue(JSONObject, Field.FieldName, Field.AsVariant, SetNull);
  end;
end;

procedure OptionsToFieldMaps(Dataset: TDataset; FieldsData: TJSONArray; var Result: TFieldMaps);
var
  i: Integer;
  FieldData: TJSONData;
  FieldObj: TJSONObject absolute FieldData;
  Field: TField;
  FieldName: String;
begin
  SetLength(Result, FieldsData.Count);
  for i := 0 to FieldsData.Count - 1 do
  begin
    FieldData := FieldsData.Items[i];
    case FieldData.JSONType of
      jtString:
      begin
        FieldName := FieldData.AsString;
        Field := Dataset.FieldByName(FieldName);
      end;
      jtObject:
      begin
        Field := nil;
        FieldName := FieldObj.Get('mapping', '');
        if FieldName <> '' then
          Field := Dataset.FieldByName(FieldName);
        FieldName := FieldObj.Get('name', FieldName);
        if Field = nil then
        begin
          //mapping not found
          Field := Dataset.FieldByName(FieldName);
        end;
      end;
      else
        raise Exception.Create('DatasetToJSON - Error parsing fields property');
    end;
    Result[i].Field := Field;
    Result[i].Name := FieldName;
  end;
end;

procedure DatasetToJSON(Dataset: TDataset; JSONArray: TJSONArray;
  Options: TDatasetToJSONOptions; const ExtOptions: TJSONStringType);
var
  RecordData: TJSONObject;
  ExtOptionsData: TJSONData;
  FieldsData: TJSONArray;
  FieldMaps: TFieldMaps;
  OldRecNo: Integer;
begin
  if Dataset.IsEmpty then
    Exit;
  ExtOptionsData := nil;
  if (ExtOptions <> '') and not TryStrToJSON(ExtOptions, ExtOptionsData) then
    raise Exception.Create('Unable to convert ExtOptions to JSON');
  try
    FieldsData := nil;
    if ExtOptionsData <> nil then
    begin
      case ExtOptionsData.JSONType of
        jtArray:
          FieldsData := TJSONArray(ExtOptionsData);
        jtObject:
          FindJSONProp(TJSONObject(ExtOptionsData), 'fields', FieldsData);
      else
        raise Exception.Create('ExtOptions is an invalid JSON type');
      end;
    end;
    if FieldsData = nil then
      DatasetToJSON(Dataset, JSONArray, Options)
    else
    begin
      OptionsToFieldMaps(Dataset, FieldsData, {%H-}FieldMaps);
      if djoCurrentRecord in Options then
      begin
        RecordData := TJSONObject.Create;
        CopyFieldsToJSONObject(FieldMaps, RecordData, djoSetNull in Options);
        JSONArray.Add(RecordData);
      end
      else
      begin
        Dataset.DisableControls;
        OldRecNo := Dataset.RecNo;
        try
          Dataset.First;
          while not Dataset.EOF do
          begin
            RecordData := TJSONObject.Create;
            CopyFieldsToJSONObject(FieldMaps, RecordData, djoSetNull in Options);
            JSONArray.Add(RecordData);
            Dataset.Next;
          end;
        finally
          Dataset.RecNo := OldRecNo;
          Dataset.EnableControls;
        end;
      end;
    end;
  finally
    ExtOptionsData.Free;
  end;
end;

procedure DatasetToJSON(Dataset: TDataset; JSONObject: TJSONObject;
  Options: TDatasetToJSONOptions; const ExtOptions: TJSONStringType);
var
  ExtOptionsData: TJSONData;
  FieldsData: TJSONArray;
  FieldMaps: TFieldMaps;
begin
  ExtOptionsData := nil;
  if (ExtOptions <> '') and not TryStrToJSON(ExtOptions, ExtOptionsData) then
    raise Exception.Create('Unable to convert ExtOptions to JSON');
  try
    FieldsData := nil;
    if ExtOptionsData <> nil then
    begin
      case ExtOptionsData.JSONType of
        jtArray:
          FieldsData := TJSONArray(ExtOptionsData);
        jtObject:
          FindJSONProp(TJSONObject(ExtOptionsData), 'fields', FieldsData);
      else
        raise Exception.Create('ExtOptions is an invalid JSON type');
      end;
    end;
    if FieldsData = nil then
      DatasetToJSON(Dataset, JSONObject, Options)
    else
    begin
      OptionsToFieldMaps(Dataset, FieldsData, {%H-}FieldMaps);
      CopyFieldsToJSONObject(FieldMaps, JSONObject, djoSetNull in Options);
    end;
  finally
    ExtOptionsData.Free;
  end;
end;

{ TJSONFile }

class function TJSONFile.Load(const AFileName: String): TJSONData;
var
  Parser: TJSONParser;
  Stream: TFileStream;
begin
  Result := nil;
  //todo: handle UTF-8
  if not FileExists(AFileName) then
    raise Exception.CreateFmt('TJSONFile - File "%s" does not exist', [AFileName]);
  Stream := nil;
  Parser := nil;
  try
    try
      Stream := TFileStream.Create(AFileName, fmOpenRead);
      Parser := TJSONParser.Create(Stream);
      Result := Parser.Parse;
    finally
      Parser.Free;
      Stream.Free;
    end;
  except
    on E: EFOpenError do
      raise Exception.CreateFmt('TJSONFile - Error loading "%s" : %s', [AFileName, E.Message]);
    on E: EParserError do
    begin
       FreeAndNil(Result);
       raise Exception.CreateFmt('TJSONFile - Error parsing "%s" : %s', [AFileName, E.Message]);
    end;
  end;
end;

class procedure TJSONFile.Save(AData: TJSONData; const AFileName: String; FormatOptions: TFormatOptions);
var
  Output: TStringList;
begin
  Output := TStringList.Create;
  try
    Output.Text := AData.FormatJSON(FormatOptions);
    Output.SaveToFile(AFileName);
  finally
    Output.Destroy;
  end;
end;

end.

