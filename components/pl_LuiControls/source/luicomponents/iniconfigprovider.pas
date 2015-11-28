unit IniConfigProvider;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles, LuiConfig;

type

  { TIniConfigProvider }

  TIniConfigProvider = class(TLuiConfigProvider)
  private
    FCacheUpdates: Boolean;
    FFileName: String;
    FIniFile: TMemIniFile;
    procedure SetCacheUpdates(const AValue: Boolean);
    procedure SetFileName(const AValue: String);
  protected
    procedure Close; override;
    procedure Open; override;
    procedure ReadSection(const SectionTitle: String; Strings: TStrings); override;
    procedure ReadSections(Strings: TStrings); override;
    function ReadString(const SectionTitle, ItemKey: String; out ValueExists: Boolean): String; override;
    procedure WriteString(const SectionTitle, ItemKey: String; AValue: String); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property CacheUpdates: Boolean read FCacheUpdates write SetCacheUpdates default True;
    property FileName: String read FFileName write SetFileName;
  end;

implementation

{ TIniConfigProvider }

procedure TIniConfigProvider.SetFileName(const AValue: string);
begin
  if FFileName = AValue then exit;
  FFileName := AValue;
end;

procedure TIniConfigProvider.SetCacheUpdates(const AValue: Boolean);
begin
  if FCacheUpdates=AValue then exit;
  FCacheUpdates:=AValue;
  if FIniFile <> nil then
    FIniFile.CacheUpdates := FCacheUpdates;
end;

destructor TIniConfigProvider.Destroy;
begin
  FIniFile.Free;
  inherited Destroy;
end;

procedure TIniConfigProvider.Close;
begin
  if FCacheUpdates then
    FIniFile.UpdateFile;
  FIniFile.Clear;
  //Reset the Ini FileName to avoid clearing the file when CacheUpdates is True
  FIniFile.Rename('', False);
end;

procedure TIniConfigProvider.Open;
var
  ParsedFileName: String;
begin
  ParsedFileName := ReplacePathMacros(FFileName);
  DoDirSeparators(ParsedFileName);
  if FIniFile = nil then
  begin
    FIniFile := TMemIniFile.Create(ParsedFileName);
    FIniFile.CacheUpdates := FCacheUpdates;
  end
  else
    FIniFile.Rename(ParsedFileName, True);
end;

procedure TIniConfigProvider.ReadSection(const SectionTitle: String;
  Strings: TStrings);
begin
  FIniFile.ReadSection(SectionTitle, Strings);
end;

procedure TIniConfigProvider.ReadSections(Strings: TStrings);
begin
  FIniFile.ReadSections(Strings);
end;

function TIniConfigProvider.ReadString(const SectionTitle, ItemKey: String;
  out ValueExists: Boolean): String;
begin
  //the natural way of retrieving ValueExists is to call FIniFile.ValueExists,
  //but this would have a performance impact since the section/key would be
  //searched twice. Here we compare the Result with the passed default value.
  //Is necessary to use a space to guarantees that the value does not exists since
  //the item value is trimmed when read from file or when write. See WriteString.
  Result := FIniFile.ReadString(SectionTitle, ItemKey, ' ');
  ValueExists := Result <> ' ';
end;

procedure TIniConfigProvider.WriteString(const SectionTitle, ItemKey: String;
  AValue: String);
begin
  //It's necessary to trim the value to avoid storing an empty space
  FIniFile.WriteString(SectionTitle, ItemKey, TrimRight(AValue));
end;

constructor TIniConfigProvider.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCacheUpdates := True;
end;


end.

