unit LuiDataCache;

//todo: make it more generic. Implement GetAsJSON, GetAsDataSet

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Sqlite3DS, fgl, db;

type

  TDataRevisionMap = specialize TFPGMap<string, int64>;

  TUpdateRevisionMap = procedure (RevisionMap: TDataRevisionMap) of object;

  TUpdateData = procedure (const DataId: String) of object;

  { TSqlite3CacheManager }

  TSqlite3CacheManager = class
  private
    FCacheDataset: TSqlite3Dataset;
    FFileName: String;
    FOnUpdateData: TUpdateData;
    FOnUpdateRevisionMap: TUpdateRevisionMap;
    FRevisionMap: TDataRevisionMap;
    procedure DoUpdateData(const DataId: String);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Initialize;
    procedure SaveRevision(const DataId: String; Revision: Int64; Dataset: TDataset);
    procedure UpdateRevisionMap;
    procedure ValidateData(const DataId: String);
    property FileName: String read FFileName write FFileName;
    property OnUpdateData: TUpdateData read FOnUpdateData write FOnUpdateData;
    property OnUpdateRevisionMap: TUpdateRevisionMap read FOnUpdateRevisionMap write FOnUpdateRevisionMap;
  end;

implementation

uses
  LuiDBUtils;

const
  RevisionsTable = 'luisqlite3cache_revisions';

{ TSqlite3CacheManager }

procedure TSqlite3CacheManager.DoUpdateData(const DataId: String);
begin
  if Assigned(FOnUpdateData) then
    FOnUpdateData(DataId);
end;

constructor TSqlite3CacheManager.Create;
begin
  FCacheDataset := TSqlite3Dataset.Create(nil);
  FRevisionMap := TDataRevisionMap.Create;
end;

destructor TSqlite3CacheManager.Destroy;
begin
  FRevisionMap.Destroy;
  FCacheDataset.Destroy;
  inherited Destroy;
end;

procedure TSqlite3CacheManager.ValidateData(const DataId: String);
var
  i: Integer;
  CacheRev, TableRev: Int64;
begin
  i := FRevisionMap.IndexOf(DataId);
  if i > -1 then
  begin
    TableRev := FRevisionMap.Data[i];
    FCacheDataset.TableName := RevisionsTable;
    //todo: change to use SQL (avoid locate)
    FCacheDataset.Open;
    if FCacheDataset.Locate('DataId', DataId, [loCaseInsensitive]) then
    begin
      CacheRev := FCacheDataset.FieldByName('Revision').AsLargeInt;
    end
    else
      CacheRev := -1;
    FCacheDataset.Close;
    if TableRev > CacheRev then
      DoUpdateData(DataId);
  end
  else
    raise Exception.CreateFmt('Data "%s" not in revision map', [DataId]);
end;

procedure TSqlite3CacheManager.SaveRevision(const DataId: String;
  Revision: Int64; Dataset: TDataset);
const
  InsertTableSQL = 'Insert or Replace Into ' + RevisionsTable + ' (DataId, Revision) values (''%s'', %d)';
begin
  FCacheDataset.Close;
  FCacheDataset.TableName := DataId;
  if not FCacheDataset.TableExists then
  begin
    FCacheDataset.FieldDefs.Assign(Dataset.FieldDefs);
    if not FCacheDataset.CreateTable then
      raise Exception.CreateFmt('TDataCacheManager.SaveTableRevision Error Creating Table %s', [DataId]);
  end
  else
    FCacheDataset.ExecSQL('Delete from ' + DataId);
  FCacheDataset.Open;
  CopyDatasetData(Dataset, FCacheDataset);
  FCacheDataset.ApplyUpdates;
  FCacheDataset.Close;
  FRevisionMap.KeyData[DataId] := Revision;
  FCacheDataset.ExecSQL(Format(InsertTableSQL, [DataId, Revision]) );
end;

procedure TSqlite3CacheManager.Initialize;
const
  CreateTableSQL = 'Create Table IF NOT EXISTS ' + RevisionsTable + ' (DataId VARCHAR PRIMARY KEY, Revision INT64)';
begin
  FCacheDataset.FileName := FFileName;
  FCacheDataset.ExecSQL(CreateTableSQL);
  UpdateRevisionMap;
end;

procedure TSqlite3CacheManager.UpdateRevisionMap;
begin
  if Assigned(FOnUpdateRevisionMap) then
    FOnUpdateRevisionMap(FRevisionMap);
end;

end.

