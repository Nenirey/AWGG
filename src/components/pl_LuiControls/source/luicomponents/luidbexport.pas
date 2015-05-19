unit LuiDBExport;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Db;

type

  TExportDatasetFileTypeSave = procedure(Dataset: TDataset; FieldList: TStrings;
    const FileName: String) of object;

  { TCustomDatasetExporter }

  TCustomDatasetExporter = class
  public
    class procedure Save(Dataset: TDataset; FieldList: TStrings;
      const FileName: String); virtual;
    class function DisplayText: String; virtual; abstract;
    class function Extension: String; virtual; abstract;
  end;

  TCustomDatasetExporterClass = class of TCustomDatasetExporter;

  { TCSVDatasetExporter }

  TCSVDatasetExporter = class(TCustomDatasetExporter)
  public
    class procedure Save(Dataset: TDataset; FieldList: TStrings;
      const FileName: String); override;
    class function DisplayText: String; override;
    class function Extension: String; override;
  end;

  procedure LoadExporters(RequestList, Result: TStrings);

  procedure RegisterExporter(const Id: ShortString; ExporterClass: TCustomDatasetExporterClass);

implementation

uses
  contnrs;

type
  TDatasetExporterManager = class
  private
    FList: TFPHashList;
  public
    function Find(const Id: String): TCustomDatasetExporterClass;
    procedure RegisterExporter(const Id: ShortString; ExporterClass: TCustomDatasetExporterClass);
    constructor Create;
    destructor Destroy; override;
  end;

var
  ExporterManager: TDatasetExporterManager;

procedure LoadExporters(RequestList, Result: TStrings);
var
  ExporterClass: TCustomDatasetExporterClass;
  i: Integer;
begin
  if ExporterManager = nil then
    Result.Assign(RequestList)
  else
  begin
    for i := 0 to RequestList.Count -1 do
    begin
      ExporterClass := ExporterManager.Find(RequestList[i]);
      if ExporterClass <> nil then
        Result.AddObject(ExporterClass.DisplayText, TObject(ExporterClass))
      else
        Result.Add(RequestList[i]);
    end;
  end;
end;

procedure RegisterExporter(const Id: ShortString;
  ExporterClass: TCustomDatasetExporterClass);
begin
  if ExporterManager = nil then
    ExporterManager := TDatasetExporterManager.Create;
  ExporterManager.RegisterExporter(Id, ExporterClass);
end;

{ TCSVDatasetExporter }

class procedure TCSVDatasetExporter.Save(Dataset: TDataset;
  FieldList: TStrings; const FileName: String);
begin
  //inherited Save(Dataset, FieldList, FileName);
end;

class function TCSVDatasetExporter.DisplayText: String;
begin
  //Result := inherited DisplayText;
end;

class function TCSVDatasetExporter.Extension: String;
begin
  //Result := inherited Extension;
end;

{ TExportFileTypeManager }

function TDatasetExporterManager.Find(const Id: String): TCustomDatasetExporterClass;
begin
  Result := TCustomDatasetExporterClass(FList.Find(Id));
end;

procedure TDatasetExporterManager.RegisterExporter(const Id: ShortString;
  ExporterClass: TCustomDatasetExporterClass);
begin
  FList.Add(Id, ExporterClass);
end;

constructor TDatasetExporterManager.Create;
begin
  FList := TFPHashList.Create;
end;

destructor TDatasetExporterManager.Destroy;
begin
  FList.Destroy;
  //inherited Destroy;
end;

{ TCustomDatasetExporter }

class procedure TCustomDatasetExporter.Save(Dataset: TDataset;
  FieldList: TStrings; const FileName: String);
begin
  //to be implemented in descendants
end;

finalization
  ExporterManager.Free;

end.

