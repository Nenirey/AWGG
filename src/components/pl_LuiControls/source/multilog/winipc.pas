unit winipc;


interface

uses
  Windows, Messages, Classes, SysUtils;
  
const
  //Message types
  mtUnknown = 0;
  mtString = 1;

type
  TMessageType = LongInt;

  { TWinIPCClient }

  TWinIPCClient = class (TComponent)
  private
    FActive: Boolean;
    FServerID: String;
    FServerInstance: String;
    FWindowName: String;
    FHWND: HWnd;
    procedure SetActive(const AValue: Boolean);
    procedure SetServerID(const AValue: String);
    procedure SetServerInstance(const AValue: String);
    procedure UpdateWindowName;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Connect;
    procedure Disconnect;
    function  ServerRunning: Boolean;
    procedure SendMessage(MsgType: TMessageType; Stream: TStream);
    procedure SendStringMessage(Msg: String);
    procedure SendStringMessageFmt(Msg: String; Args : array of const);
    property Active: Boolean read FActive write SetActive;
    property ServerID: String read FServerID write SetServerID;
    property ServerInstance: String read FServerInstance write SetServerInstance;
  end;

implementation

const
  MsgWndClassName : PChar = 'FPCMsgWindowCls';

resourcestring
  SErrServerNotActive = 'Server with ID %s is not active.';


{ TWinIPCClient }

procedure TWinIPCClient.SetActive(const AValue: Boolean);
begin
  if FActive = AValue then
    Exit;
  FActive := AValue;
  if FActive then
    Connect
  else
    Disconnect;
end;

procedure TWinIPCClient.SetServerID(const AValue: String);
begin
  FServerID := AValue;
  UpdateWindowName;
end;

procedure TWinIPCClient.SetServerInstance(const AValue: String);
begin
  FWindowName := AValue;
  UpdateWindowName;
end;

procedure TWinIPCClient.UpdateWindowName;
begin
  if FServerInstance <> '' then
    FWindowName := FServerID + '_' + FServerInstance
  else
    FWindowName := FServerID;
end;

constructor TWinIPCClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TWinIPCClient.Destroy;
begin
  inherited Destroy;
end;

procedure TWinIPCClient.Connect;
begin
  FHWND := FindWindow(MsgWndClassName,PChar(FWindowName));
  if FHWND = 0 then
    raise Exception.Create(Format(SErrServerNotActive,[FServerID]));
end;

procedure TWinIPCClient.Disconnect;
begin
  FHWND := 0;
end;

function TWinIPCClient.ServerRunning: Boolean;
begin
  Result := FindWindow(MsgWndClassName,PChar(FWindowName)) <> 0;
end;

procedure TWinIPCClient.SendMessage(MsgType: TMessageType; Stream: TStream);
var
  CDS : TCopyDataStruct;
  Data, FMemstr : TMemorySTream;

begin
  if Stream is TMemoryStream then
  begin
    Data := TMemoryStream(Stream);
    FMemStr := nil
  end
  else
  begin
    FMemStr := TMemoryStream.Create;
    Data := FMemstr;
  end;
  try
    if Assigned(FMemStr) then
    begin
      FMemStr.CopyFrom(Stream,0);
      FMemStr.Seek(0,soFromBeginning);
    end;
    CDS.lpData:=Data.Memory;
    CDS.cbData:=Data.Size;
    Windows.SendMessage(FHWnd,WM_COPYDATA,0,Integer(@CDS));
  finally
    FreeAndNil(FMemStr);
  end;
end;

procedure TWinIPCClient.SendStringMessage(Msg: String);
begin

end;

procedure TWinIPCClient.SendStringMessageFmt(Msg: String;
  Args: array of const);
begin

end;

end.

