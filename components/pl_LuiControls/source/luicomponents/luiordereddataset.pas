unit LuiOrderedDataset;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Sqlite3DS, CustomSqliteDS, Db;

type

  { TLuiOrderedDataset }

  TLuiOrderedDataset = class(TSqlite3Dataset)
  private
    FInitialOrderValue: Integer;
    FInsertBookmark: PDataRecord;
    FInternalActiveBuffer: PDataRecord;
    FOrderFieldIndex: Integer;
    FOrderFieldName: String;
    procedure AdjustOrderForward(RecordItem: PDataRecord; OrderValue: Integer);
    procedure NotifyItemUpdate(Item: PDataRecord);
    procedure SetInitialOrderValue(const AValue: Integer);
    procedure SetOrderFieldName(const AValue: String);
    procedure SwapOrder(CurrentItem, SiblingItem: PDataRecord);
  protected
    //todo: handle setfielddata to make orderfield readonly
    procedure DoAfterInsert; override;
    procedure DoBeforeInsert; override;
    procedure InternalAddRecord(Buffer: Pointer; DoAppend: Boolean); override;
    procedure InternalDelete; override;
    procedure InternalOpen; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ChangeOrder(Offset: Integer);
  published
    property InitialOrderValue: Integer read FInitialOrderValue write SetInitialOrderValue default 1;
    property OrderFieldName: String read FOrderFieldName write SetOrderFieldName;

  end;

implementation

{ TLuiOrderedDataset }

procedure TLuiOrderedDataset.AdjustOrderForward(RecordItem: PDataRecord;
  OrderValue: Integer);
var
  TempItem: PDataRecord;
  TempValue: Integer;
begin
  //todo: see how using the argument variables affect the generated code
  TempItem := RecordItem;
  TempValue := OrderValue;
  while TempItem^.Next <> nil do
  begin
    NotifyItemUpdate(TempItem);
    StrDispose(TempItem^.Row[FOrderFieldIndex]);
    TempItem^.Row[FOrderFieldIndex] := StrNew(PChar(IntToStr(TempValue)));
    Inc(TempValue);
    TempItem := TempItem^.Next;
  end;
end;

procedure TLuiOrderedDataset.NotifyItemUpdate(Item: PDataRecord);
begin
  if (FAddedItems.IndexOf(Item) = -1) and
    (FUpdatedItems.IndexOf(Item) = -1) then
    FUpdatedItems.Add(Item);
end;

procedure TLuiOrderedDataset.SetInitialOrderValue(const AValue: Integer);
begin
  if FInitialOrderValue=AValue then exit;
  FInitialOrderValue:=AValue;
end;

procedure TLuiOrderedDataset.SetOrderFieldName(const AValue: String);
begin
  if FOrderFieldName=AValue then exit;
  FOrderFieldName:=AValue;
end;

procedure TLuiOrderedDataset.SwapOrder(CurrentItem, SiblingItem: PDataRecord);
var
  TempRow: PPChar;
  TempValue: PChar;
begin
  //swap all fields
  TempRow := CurrentItem^.Row;
  CurrentItem^.Row := SiblingItem^.Row;
  SiblingItem^.Row := TempRow;

  //revert the order field
  TempValue := CurrentItem^.Row[FOrderFieldIndex];
  CurrentItem^.Row[FOrderFieldIndex] := SiblingItem^.Row[FOrderFieldIndex];
  SiblingItem^.Row[FOrderFieldIndex] := TempValue;
end;

procedure TLuiOrderedDataset.DoAfterInsert;
begin
  if EOF then
    FInsertBookmark := FEndItem
  else
    FInsertBookmark := FInternalActiveBuffer;

  inherited DoAfterInsert;
end;

procedure TLuiOrderedDataset.DoBeforeInsert;
begin
  FInternalActiveBuffer := PPDataRecord(ActiveBuffer)^;
  inherited DoBeforeInsert;
end;

procedure TLuiOrderedDataset.InternalAddRecord(Buffer: Pointer;
  DoAppend: Boolean);
var
  OrderStart: Integer;
  FieldValue: PChar;
begin
  inherited InternalAddRecord(Buffer, DoAppend);
  if FOrderFieldIndex = -1 then
    Exit;

  if FInsertBookmark = FEndItem then
  begin
    FieldValue := FEndItem^.Previous^.Previous^.Row[FOrderFieldIndex];
    if FieldValue <> nil then
      OrderStart := StrToInt(FieldValue) + 1
    else
      OrderStart := FInitialOrderValue;
  end
  else
  begin
    FieldValue := FInternalActiveBuffer^.Row[FOrderFieldIndex];
    if FieldValue <> nil then
      OrderStart := StrToInt(FieldValue)
    else
      OrderStart := FInitialOrderValue;
  end;

  AdjustOrderForward(FInsertBookmark^.Previous, OrderStart);
end;

procedure TLuiOrderedDataset.InternalDelete;
var
  OrderStart: Integer;
  CurrentItem, NextItem: PDataRecord;
begin
  if FOrderFieldIndex <> -1 then
  begin
    CurrentItem := PPDataRecord(ActiveBuffer)^;
    OrderStart := StrToInt(CurrentItem^.Row[FOrderFieldIndex]);
    if CurrentItem^.Previous = FBeginItem then
      NextItem := CurrentItem^.Next
    else
      NextItem := CurrentItem^.Next;
  end;
  inherited InternalDelete;
  if FOrderFieldIndex <> -1 then
    AdjustOrderForward(NextItem, OrderStart);
end;

procedure TLuiOrderedDataset.InternalOpen;
var
  OrderField: TField;
begin
  if (FSql = '') and (FOrderFieldName <> '') and (FTableName <> '') then
    FSql := 'Select * From ' + FTableName + ' Order By ' + FOrderFieldName;
  inherited InternalOpen;
  FOrderFieldIndex := -1;
  OrderField := FindField(FOrderFieldName);
  if (OrderField <> nil) and (OrderField.DataType in [ftInteger, ftWord]) then
    FOrderFieldIndex := OrderField.FieldNo - 1;
end;

constructor TLuiOrderedDataset.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInitialOrderValue := 1;
end;

procedure TLuiOrderedDataset.ChangeOrder(Offset: Integer);
var
  CurrentItem, SiblingItem: PDataRecord;
  CurrentAddIndex, SiblingAddIndex: Integer;
begin
  if (FOrderFieldIndex = -1) or (Offset = 0) then
    Exit;
  DisableControls;
  try
    CurrentItem := PPDataRecord(ActiveBuffer)^;
    Offset := MoveBy(Offset);
    while Offset <> 0 do
    begin
      if Offset > 0 then
      begin
        SiblingItem := CurrentItem^.Next;
        Dec(Offset);
      end
      else
      begin
        SiblingItem := CurrentItem^.Previous;
        Inc(Offset);
      end;
      SwapOrder(CurrentItem, SiblingItem);
      CurrentAddIndex := FAddedItems.IndexOf(CurrentItem);
      SiblingAddIndex := FAddedItems.IndexOf(SiblingItem);
      if (CurrentAddIndex > -1) xor (SiblingAddIndex > -1) then
      begin
        if SiblingAddIndex = -1 then
        begin
          FAddedItems.Delete(CurrentAddIndex);
          FAddedItems.Add(SiblingItem);
        end;
        if CurrentAddIndex = -1 then
        begin
          FAddedItems.Delete(SiblingAddIndex);
          FAddedItems.Add(CurrentItem);
        end;
      end;
      NotifyItemUpdate(CurrentItem);
      //Notify the update of sibling item only when Offset = 0 because otherwise
      //it will be notified as the current item
      if Offset = 0 then
        NotifyItemUpdate(SiblingItem);
      CurrentItem := SiblingItem;
    end;
  finally
    EnableControls;
  end;
end;

end.

