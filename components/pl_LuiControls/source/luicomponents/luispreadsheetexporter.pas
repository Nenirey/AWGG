unit LuiSpreadsheetExporter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LuiDBExport, fpspreadsheet, xlsbiff8, xlsbiff5, fpsopendocument, db;

type

  { TCustomExcelSpreadsheetExporter }

  TCustomExcelSpreadsheetExporter = class(TCustomDatasetExporter)
  public
    class function DisplayText: String; override;
    class function Extension: String; override;
  end;

  { TExcel5Exporter }

  TExcel5Exporter = class(TCustomExcelSpreadsheetExporter)
  public
    class procedure Save(Dataset: TDataset; FieldList: TStrings; const FileName: String); override;
  end;

  { TExcel8Exporter }

  TExcel8Exporter = class(TCustomExcelSpreadsheetExporter)
  public
    class procedure Save(Dataset: TDataset; FieldList: TStrings; const FileName: String); override;
  end;

  { TODFSpreadsheetExporter }

  TODFSpreadsheetExporter = class(TCustomDatasetExporter)
  public
    class function DisplayText: String; override;
    class function Extension: String; override;
    class procedure Save(Dataset: TDataset; FieldList: TStrings; const FileName: String); override;
  end;

implementation

//avoid lcl dependency
//uses
//  FileUtil;

procedure ConvertDatasetToSpreadSheet(Dataset: TDataset; FieldList: TStrings; const FileName: String;
  Format: TsSpreadsheetFormat);
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  Col, Row, OldRecNo: Integer;
  Field: TField;
begin
  MyWorkbook := TsWorkbook.Create;
  try
    MyWorksheet := MyWorkbook.AddWorksheet('planilha');
    for Col := 0 to FieldList.Count - 1 do
      MyWorksheet.WriteUTF8Text(0, Col, FieldList[Col]);
    OldRecNo := Dataset.RecNo;
    Dataset.DisableControls;
    try
      Dataset.First;
      Row := 1;
      while not Dataset.EOF do
      begin
        for Col := 0 to FieldList.Count - 1 do
        begin
          Field := TField(FieldList.Objects[Col]);
          if not Field.IsNull then
          begin
            case Field.DataType of
              ftInteger, ftFloat, ftSmallint, ftLargeint, ftWord:
                MyWorksheet.WriteNumber(Row, Col, Field.AsFloat)
            else
              MyWorksheet.WriteUTF8Text(Row, Col, Field.Text);
            end;
          end;
        end;
        Inc(Row);
        Dataset.Next;
      end;
    finally
      if OldRecNo <> -1 then
        Dataset.RecNo := OldRecNo;
      Dataset.EnableControls;
    end;
    MyWorkbook.WriteToFile(UTF8Decode(FileName), Format);
  finally
    MyWorkbook.Destroy;
  end;
end;

{ TODFSpreadsheetExporter }

class function TODFSpreadsheetExporter.DisplayText: String;
begin
  Result := 'Planilha do OpenOffice';
end;

class function TODFSpreadsheetExporter.Extension: String;
begin
  Result := STR_OPENDOCUMENT_CALC_EXTENSION;
end;

class procedure TODFSpreadsheetExporter.Save(Dataset: TDataset;
  FieldList: TStrings; const FileName: String);
begin
  ConvertDatasetToSpreadSheet(Dataset, FieldList, FileName, sfOpenDocument);
end;

{ TExcel8Exporter }

class procedure TExcel8Exporter.Save(Dataset: TDataset; FieldList: TStrings;
  const FileName: String);
begin
  ConvertDatasetToSpreadSheet(Dataset, FieldList, FileName, sfExcel8);
end;

{ TExcel5Exporter }

class procedure TExcel5Exporter.Save(Dataset: TDataset; FieldList: TStrings;
  const FileName: String);
begin
  ConvertDatasetToSpreadSheet(Dataset, FieldList, FileName, sfExcel5);
end;

{ TCustomExcelSpreadsheetExporter }

class function TCustomExcelSpreadsheetExporter.DisplayText: String;
begin
  Result := 'Planilha do Excel'; //todo: make a resource string
end;

class function TCustomExcelSpreadsheetExporter.Extension: String;
begin
  Result := STR_EXCEL_EXTENSION;
end;

initialization
  RegisterExporter('excel', TExcel8Exporter);
  RegisterExporter('excel5', TExcel5Exporter);
  RegisterExporter('ods', TODFSpreadsheetExporter);

end.

