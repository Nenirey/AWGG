unit MultiLog;

{
  Main unit of the Multilog logging system

  Copyright (C) 2006 Luiz Américo Pereira Câmara
  pascalive@bol.com.br

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}

{$ifdef fpc} 
{$mode objfpc}{$H+}
{$endif}

interface

uses
  {$ifndef fpc}Types, fpccompat,{$endif} Classes, SysUtils;

const
  //MessageTypes
  //mt (Message Type) and lt (Log Type) prefixes are used elsewhere
  //but mt is worse because there's already mtWarning and mtInformation
  //the existing lt* do not makes confusion
  ltInfo    = 0;
  ltError   = 1;
  ltWarning = 2;
  ltValue   = 3;
  ltEnterMethod = 4;
  ltExitMethod  = 5;
  ltConditional = 6;
  ltCheckpoint = 7;
  ltStrings = 8;
  ltCallStack = 9;
  ltObject = 10;
  ltException = 11;
  ltBitmap = 12;
  ltHeapInfo = 13;
  ltMemory = 14;
  ltCustomData = 15;
  ltWatch = 20;
  ltCounter = 21;


  ltClear=100;
  
type
  TLogger = class;
  
  TDebugClass = 0..31;
  
  TDebugClasses = Set of TDebugClass;
  
  TLogMessage = record
    MsgType: Integer;
    MsgTime: TDateTime;
    MsgText: String;
    Data: TStream;
  end;

  TCustomDataNotify = function (Sender: TLogger; Data: Pointer; var DoSend: Boolean): String of Object;
  TCustomDataNotifyStatic = function (Sender: TLogger; Data: Pointer; var DoSend: Boolean): String;

  { TLogChannel }

  TLogChannel = class
  private
    FActive: Boolean;
  public
    procedure Clear; virtual; abstract;
    procedure Deliver(const AMsg: TLogMessage);virtual;abstract;
    procedure Init; virtual;
    property Active: Boolean read FActive write FActive;
  end;
  
  { TChannelList }

  TChannelList = class
  private
    FList: TFpList;
    function GetCount: Integer; {$ifdef fpc}inline;{$endif}
    function GetItems(AIndex:Integer): TLogChannel; {$ifdef fpc}inline;{$endif}
  public
    constructor Create;
    destructor Destroy; override;
    function Add(AChannel: TLogChannel):Integer;
    procedure Remove(AChannel:TLogChannel);
    property Count: Integer read GetCount;
    property Items[AIndex:Integer]: TLogChannel read GetItems; default;
  end;

  { TLogger }

  TLogger = class
  private
    FMaxStackCount: Integer;
    FChannels: TChannelList;
    FLogStack: TStrings;
    FCheckList: TStringList;
    FCounterList: TStringList;
    FOnCustomData: TCustomDataNotify;
    FLastActiveClasses: TDebugClasses;
    procedure GetCallStack(AStream:TStream);
    procedure SetEnabled(AValue: Boolean);
    function GetEnabled: Boolean;
    procedure SetMaxStackCount(const AValue: Integer);
  protected
    procedure SendStream(AMsgType: Integer;const AText:String; AStream: TStream);
    procedure SendBuffer(AMsgType: Integer;const AText:String;
      var Buffer; Count: LongWord);
  public
    ActiveClasses: TDebugClasses;//Made a public field to allow use of include/exclude functions
    DefaultClasses: TDebugClasses;
    constructor Create;
    destructor Destroy; override;
    function CalledBy(const AMethodName: String): Boolean;
    procedure Clear;
    //Helper functions
    function RectToStr(const ARect: TRect): String; //inline
    function PointToStr(const APoint: TPoint): String; //inline
    //Send functions
    procedure Send(const AText: String); overload; {$ifdef fpc}inline;{$endif}
    procedure Send(Classes: TDebugClasses; const AText: String);overload;
    procedure Send(const AText: String; Args: array of const);overload; {$ifdef fpc}inline;{$endif}
    procedure Send(Classes: TDebugClasses; const AText: String; Args: array of const);overload;
    procedure Send(const AText, AValue: String);overload; {$ifdef fpc}inline;{$endif}
    procedure Send(Classes: TDebugClasses; const AText,AValue: String); overload;
    procedure Send(const AText: String; AValue: Integer); overload; {$ifdef fpc}inline;{$endif}
    procedure Send(Classes: TDebugClasses; const AText: String; AValue: Integer);overload;
    {$ifdef fpc}
    procedure Send(const AText: String; AValue: Cardinal); overload; {$ifdef fpc}inline;{$endif}
    procedure Send(Classes: TDebugClasses; const AText: String; AValue: Cardinal);overload;
    {$endif}
    procedure Send(const AText: String; AValue: Double); overload; {$ifdef fpc}inline;{$endif}
    procedure Send(Classes: TDebugClasses; const AText: String; AValue: Double);overload;
    procedure Send(const AText: String; AValue: Int64); overload; {$ifdef fpc}inline;{$endif}
    procedure Send(Classes: TDebugClasses; const AText: String; AValue: Int64);overload;
    procedure Send(const AText: String; AValue: QWord); overload; {$ifdef fpc}inline;{$endif}
    procedure Send(Classes: TDebugClasses; const AText: String; AValue: QWord);overload;
    procedure Send(const AText: String; AValue: Boolean); overload; {$ifdef fpc}inline;{$endif}
    procedure Send(Classes: TDebugClasses; const AText: String; AValue: Boolean);overload;
    procedure Send(const AText: String; const ARect: TRect); overload; {$ifdef fpc}inline;{$endif}
    procedure Send(Classes: TDebugClasses; const AText: String; const ARect: TRect);overload;
    procedure Send(const AText: String; const APoint: TPoint); overload; {$ifdef fpc}inline;{$endif}
    procedure Send(Classes: TDebugClasses; const AText: String; const APoint: TPoint);overload;
    procedure Send(const AText: String; AStrList: TStrings); overload; {$ifdef fpc}inline;{$endif}
    procedure Send(Classes: TDebugClasses; const AText: String; AStrList: TStrings);overload;
    procedure Send(const AText: String; AObject: TObject); overload; {$ifdef fpc}inline;{$endif}
    procedure Send(Classes: TDebugClasses; const AText: String; AObject: TObject);overload;
    procedure SendPointer(const AText: String; APointer: Pointer); overload; {$ifdef fpc}inline;{$endif}
    procedure SendPointer(Classes: TDebugClasses; const AText: String; APointer: Pointer);overload;
    procedure SendCallStack(const AText: String); overload; {$ifdef fpc}inline;{$endif}
    procedure SendCallStack(Classes: TDebugClasses; const AText: String);overload;
    procedure SendException(const AText: String; AException: Exception);overload; {$ifdef fpc}inline;{$endif}
    procedure SendException(Classes: TDebugClasses; const AText: String; AException: Exception);overload;
    procedure SendHeapInfo(const AText: String); overload; {$ifdef fpc}inline;{$endif}
    procedure SendHeapInfo(Classes: TDebugClasses; const AText: String);overload;
    procedure SendMemory(const AText: String; Address: Pointer; Size: LongWord); overload; {$ifdef fpc}inline;{$endif}
    procedure SendMemory(Classes: TDebugClasses; const AText: String; Address: Pointer; Size: LongWord);overload;
    procedure SendIf(const AText: String; Expression: Boolean); overload; {$ifdef fpc}inline;{$endif}
    procedure SendIf(Classes: TDebugClasses; const AText: String; Expression: Boolean); overload;
    procedure SendIf(const AText: String; Expression, IsTrue: Boolean); overload; {$ifdef fpc}inline;{$endif}
    procedure SendIf(Classes: TDebugClasses; const AText: String; Expression, IsTrue: Boolean);overload;
    procedure SendWarning(const AText: String); overload; {$ifdef fpc}inline;{$endif}
    procedure SendWarning(Classes: TDebugClasses; const AText: String);overload;
    procedure SendError(const AText: String); overload; {$ifdef fpc}inline;{$endif}
    procedure SendError(Classes: TDebugClasses; const AText: String);overload;
    procedure SendCustomData(const AText: String; Data: Pointer);overload; {$ifdef fpc}inline;{$endif}
    procedure SendCustomData(const AText: String; Data: Pointer; CustomDataFunction: TCustomDataNotify);overload; {$ifdef fpc}inline;{$endif}
    procedure SendCustomData(Classes: TDebugClasses; const AText: String; Data: Pointer;
      CustomDataFunction: TCustomDataNotify);overload;
    procedure SendCustomData(Classes: TDebugClasses; const AText: String;
      Data: Pointer);overload;
    procedure SendCustomData(Classes: TDebugClasses; const AText: String;
      Data: Pointer; CustomDataFunction: TCustomDataNotifyStatic);overload;
    procedure SendCustomData(const AText: String; Data: Pointer;
      CustomDataFunction: TCustomDataNotifyStatic);overload; {$ifdef fpc}inline;{$endif}
    procedure AddCheckPoint;overload; {$ifdef fpc}inline;{$endif}
    procedure AddCheckPoint(Classes: TDebugClasses);overload; {$ifdef fpc}inline;{$endif}
    procedure AddCheckPoint(const CheckName: String);overload; {$ifdef fpc}inline;{$endif}
    procedure AddCheckPoint(Classes: TDebugClasses; const CheckName: String);overload;
    procedure IncCounter(const CounterName: String);overload; {$ifdef fpc}inline;{$endif}
    procedure IncCounter(Classes: TDebugClasses; const CounterName: String);overload;
    procedure DecCounter(const CounterName: String);overload; {$ifdef fpc}inline;{$endif}
    procedure DecCounter(Classes: TDebugClasses; const CounterName: String);overload;
    procedure ResetCounter(const CounterName: String);overload; {$ifdef fpc}inline;{$endif}
    procedure ResetCounter(Classes: TDebugClasses; const CounterName: String);overload;
    function GetCounter(const CounterName: String): Integer;
    procedure ResetCheckPoint;overload; {$ifdef fpc}inline;{$endif}
    procedure ResetCheckPoint(Classes: TDebugClasses);overload;
    procedure ResetCheckPoint(const CheckName: String);overload; {$ifdef fpc}inline;{$endif}
    procedure ResetCheckPoint(Classes: TDebugClasses;const CheckName: String);overload;
    procedure EnterMethod(const AMethodName: String); overload; {$ifdef fpc}inline;{$endif}
    procedure EnterMethod(Classes: TDebugClasses; const AMethodName: String); overload;
    procedure EnterMethod(Sender: TObject; const AMethodName: String); overload; {$ifdef fpc}inline;{$endif}
    procedure EnterMethod(Classes: TDebugClasses; Sender: TObject; const AMethodName: String);overload;
    procedure ExitMethod(const AMethodName: String); overload; {$ifdef fpc}inline;{$endif}
    procedure ExitMethod(Sender: TObject; const AMethodName: String); overload; {$ifdef fpc}inline;{$endif}
    procedure ExitMethod(Classes: TDebugClasses; const AMethodName: String); overload; {$ifdef fpc}inline;{$endif}
    procedure ExitMethod(Classes: TDebugClasses; Sender: TObject; const AMethodName: String);overload;
    procedure Watch(const AText, AValue: String); overload; {$ifdef fpc}inline;{$endif}
    procedure Watch(Classes: TDebugClasses; const AText,AValue: String);overload;
    procedure Watch(const AText: String; AValue: Integer); overload; {$ifdef fpc}inline;{$endif}
    procedure Watch(Classes: TDebugClasses; const AText: String; AValue: Integer);overload;
    {$ifdef fpc}
    procedure Watch(const AText: String; AValue: Cardinal); overload; {$ifdef fpc}inline;{$endif}
    procedure Watch(Classes: TDebugClasses; const AText: String; AValue: Cardinal);overload;
    {$endif}
    procedure Watch(const AText: String; AValue: Double); overload; {$ifdef fpc}inline;{$endif}
    procedure Watch(Classes: TDebugClasses; const AText: String; AValue: Double);overload;
    procedure Watch(const AText: String; AValue: Boolean); overload; {$ifdef fpc}inline;{$endif}
    procedure Watch(Classes: TDebugClasses; const AText: String; AValue: Boolean);overload;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property Channels: TChannelList read FChannels;
    property LogStack: TStrings read FLogStack;
    property MaxStackCount: Integer read FMaxStackCount write SetMaxStackCount;
    property OnCustomData: TCustomDataNotify read FOnCustomData write FOnCustomData;
  end;

implementation

const
  DefaultCheckName = 'CheckPoint';

function FormatNumber (Value: Integer):String;
var
  TempStr:String;
  i,Digits:Integer;
begin
  Digits:=0;
  Result:='';
  TempStr:=IntToStr(Value);
  for i := length(TempStr) downto 1 do
  begin
    //todo: implement using mod() -> get rids of digits
    if Digits = 3 then
    begin
      Digits:=0;
      Result:=ThousandSeparator+Result;
    end;
    Result:=TempStr[i]+Result;
    Inc(Digits);
  end;
end;

{ TLogger }

procedure TLogger.GetCallStack(AStream: TStream);
{$ifdef fpc}
var
  i : Longint;
  prevbp : Pointer;
  caller_frame,
  caller_addr,
  bp : Pointer;
  S:String;
{$endif}
begin
  {$ifdef fpc}
  //routine adapted from fpc source

  //This trick skip SendCallstack item
  //bp:=get_frame;
  bp:= get_caller_frame(get_frame);
  try
    prevbp:=bp-1;
    i:=0;
    //is_dev:=do_isdevice(textrec(f).Handle);
    while bp > prevbp Do
     begin
       caller_addr := get_caller_addr(bp);
       caller_frame := get_caller_frame(bp);
       if (caller_addr=nil) then
         break;
       //todo: see what is faster concatenate string and use writebuffer or current
       S:=BackTraceStrFunc(caller_addr)+LineEnding;
       AStream.WriteBuffer(S[1],Length(S));
       Inc(i);
       if (i>=FMaxStackCount) or (caller_frame=nil) then
         break;
       prevbp:=bp;
       bp:=caller_frame;
     end;
   except
     { prevent endless dump if an exception occured }
   end;
  {$endif} 
end;

procedure TLogger.SetEnabled(AValue: Boolean);
begin
  if AValue then
  begin
    if ActiveClasses = [] then
      ActiveClasses := FLastActiveClasses;
  end
  else
  begin
    FLastActiveClasses := ActiveClasses;
    ActiveClasses := [];
  end;
end;

function TLogger.GetEnabled: Boolean;
begin
  Result:=ActiveClasses <> [];
end;

procedure TLogger.SendStream(AMsgType: Integer; const AText: String;
  AStream: TStream);
var
  MsgRec: TLogMessage;
  i:Integer;
begin
  with MsgRec do
  begin
    MsgType:=AMsgType;
    MsgTime:=Now;
    MsgText:=AText;
    Data:=AStream;
  end;
  for i:= 0 to Channels.Count - 1 do
    if Channels[i].Active then
      Channels[i].Deliver(MsgRec);
  AStream.Free;
end;

procedure TLogger.SendBuffer(AMsgType: Integer; const AText: String;
  var Buffer; Count: LongWord);
var
  AStream: TStream;
begin
  if Count > 0 then
  begin
    AStream:=TMemoryStream.Create;
    AStream.Write(Buffer,Count);
  end
  else
    AStream:=nil;
  //SendStream free AStream
  SendStream(AMsgType,AText,AStream);
end;

procedure TLogger.SetMaxStackCount(const AValue: Integer);
begin
  if AValue < 256 then
    FMaxStackCount := AValue
  else
    FMaxStackCount := 256;
end;

constructor TLogger.Create;
begin
  FChannels := TChannelList.Create;
  FMaxStackCount := 20;
  FLogStack := TStringList.Create;
  FCheckList := TStringList.Create;
  with FCheckList do
  begin
    CaseSensitive := False;
    Sorted := True; //Faster IndexOf?
  end;
  FCounterList := TStringList.Create;
  with FCounterList do
  begin
    CaseSensitive := False;
    Sorted := True; //Faster IndexOf?
  end;
  ActiveClasses := [0];
  DefaultClasses := [0];
end;

destructor TLogger.Destroy;
begin
  FChannels.Destroy;
  FLogStack.Destroy;
  FCheckList.Destroy;
  FCounterList.Destroy;
end;

function TLogger.CalledBy(const AMethodName: String): Boolean;
begin
  Result:=FLogStack.IndexOf(UpperCase(AMethodName)) <> -1;
end;

procedure TLogger.Clear;
var
  i: Integer;
begin
  for i:= 0 to Channels.Count - 1 do
    if Channels[i].Active then
      Channels[i].Clear;
end;

function TLogger.RectToStr(const ARect: TRect): String;
begin
  with ARect do
    Result:=Format('(Left: %d; Top: %d; Right: %d; Bottom: %d)',[Left,Top,Right,Bottom]);
end;

function TLogger.PointToStr(const APoint: TPoint): String;
begin
  with APoint do
    Result:=Format('(X: %d; Y: %d)',[X,Y]);
end;

procedure TLogger.Send(const AText: String);
begin
  Send(DefaultClasses,AText);
end;

procedure TLogger.Send(Classes: TDebugClasses; const AText: String);
begin
  if Classes * ActiveClasses = [] then Exit;
  SendStream(ltInfo,AText,nil);
end;

procedure TLogger.Send(const AText: String; Args: array of const);
begin
  Send(DefaultClasses,AText,Args);
end;

procedure TLogger.Send(Classes: TDebugClasses; const AText: String;
  Args: array of const);
begin
  if Classes * ActiveClasses = [] then Exit;
  SendStream(ltInfo, Format(AText,Args),nil);
end;

procedure TLogger.Send(const AText, AValue: String);
begin
  Send(DefaultClasses,AText,AValue);
end;

procedure TLogger.Send(Classes: TDebugClasses; const AText, AValue: String);
begin
  if Classes * ActiveClasses = [] then Exit;
  SendStream(ltValue,AText+' = '+AValue,nil);
end;

procedure TLogger.Send(const AText: String; AValue: Integer);
begin
  Send(DefaultClasses,AText,AValue);
end;

procedure TLogger.Send(Classes: TDebugClasses; const AText: String; AValue: Integer);
begin
  if Classes * ActiveClasses = [] then Exit;
  SendStream(ltValue,AText+' = '+IntToStr(AValue),nil);
end;

{$ifdef fpc}
procedure TLogger.Send(const AText: String; AValue: Cardinal);
begin
  Send(DefaultClasses,AText,AValue);
end;

procedure TLogger.Send(Classes: TDebugClasses; const AText: String;
  AValue: Cardinal);
begin
  if Classes * ActiveClasses = [] then Exit;
  SendStream(ltValue,AText+' = '+IntToStr(AValue),nil);
end;
{$endif}

procedure TLogger.Send(const AText: String; AValue: Double);
begin
  Send(DefaultClasses,AText,AValue);
end;

procedure TLogger.Send(Classes: TDebugClasses; const AText: String; AValue: Double
  );
begin
  if Classes * ActiveClasses = [] then Exit;
  SendStream(ltValue,AText+' = '+FloatToStr(AValue),nil);
end;

procedure TLogger.Send(const AText: String; AValue: Int64);
begin
  Send(DefaultClasses,AText,AValue);
end;

procedure TLogger.Send(Classes: TDebugClasses; const AText: String; AValue: Int64
  );
begin
  if Classes * ActiveClasses = [] then Exit;
  SendStream(ltValue,AText+' = '+IntToStr(AValue),nil);
end;

procedure TLogger.Send(const AText: String; AValue: QWord);
begin
  Send(DefaultClasses,AText,AValue);
end;

procedure TLogger.Send(Classes: TDebugClasses; const AText: String; AValue: QWord
  );
begin
  if Classes * ActiveClasses = [] then Exit;
  SendStream(ltValue,AText+' = '+IntToStr(AValue),nil);
end;

procedure TLogger.Send(const AText: String; AValue: Boolean);
begin
  Send(DefaultClasses, AText, AValue);
end;

procedure TLogger.Send(Classes: TDebugClasses; const AText: String; AValue: Boolean);
begin
  if Classes * ActiveClasses = [] then Exit;
  SendStream(ltValue, AText + ' = ' + BoolToStr(AValue, True), nil);
end;

procedure TLogger.Send(const AText: String; const ARect: TRect);
begin
  Send(DefaultClasses,AText,ARect);
end;

procedure TLogger.Send(Classes: TDebugClasses; const AText: String;const ARect: TRect);
begin
  if Classes * ActiveClasses = [] then Exit;
  with ARect do
    SendStream(ltValue,AText+ ' = '+RectToStr(ARect),nil);
end;

procedure TLogger.Send(const AText: String; const APoint: TPoint);
begin
  Send(DefaultClasses,AText,APoint);
end;

procedure TLogger.Send(Classes: TDebugClasses; const AText: String; const APoint: TPoint
  );
begin
  if Classes * ActiveClasses = [] then Exit;
  SendStream(ltValue,AText+' = '+PointToStr(APoint),nil);
end;

procedure TLogger.Send(const AText: String; AStrList: TStrings);
begin
  Send(DefaultClasses,AText,AStrList);
end;

procedure TLogger.Send(Classes: TDebugClasses; const AText: String;
  AStrList: TStrings);
var
  S:String;
begin
  if Classes * ActiveClasses = [] then Exit;
  if Assigned(AStrList) then
    S:= AStrList.Text
  else
    S:='';
  SendBuffer(ltStrings,AText,S[1],Length(S));
end;

procedure TLogger.Send(const AText: String; AObject: TObject);
begin
  Send(DefaultClasses,AText,AObject);
end;

function GetObjectDescription(Sender: TObject): String;
begin
  Result := Sender.ClassName;
  if (Sender is TComponent) and (TComponent(Sender).Name <> '') then
    Result := Result + '(' + TComponent(Sender).Name + ')';
end;

procedure TLogger.Send(Classes: TDebugClasses; const AText: String;
  AObject: TObject);
var
  TempStr: String;
  AStream: TStream;
begin
  if Classes * ActiveClasses = [] then Exit;
  AStream := nil;
  TempStr := AText + ' [';
  if AObject <> nil then
  begin
    if AObject is TComponent then
    begin
      AStream := TMemoryStream.Create;
      AStream.WriteComponent(TComponent(AObject));
    end
    else
      TempStr := TempStr + GetObjectDescription(AObject) + ' / ';
  end;
  TempStr := TempStr + ('$' + HexStr(AObject) + ']');
  //SendStream free AStream
  SendStream(ltObject, TempStr, AStream);
end;

procedure TLogger.SendPointer(const AText: String; APointer: Pointer);
begin
  SendPointer(DefaultClasses,AText,APointer);
end;

procedure TLogger.SendPointer(Classes: TDebugClasses; const AText: String;
  APointer: Pointer);
begin
  if Classes * ActiveClasses = [] then Exit;
  SendStream(ltValue, AText + ' = $' + HexStr(APointer), nil);
end;

procedure TLogger.SendCallStack(const AText: String);
begin
  SendCallStack(DefaultClasses,AText);
end;

procedure TLogger.SendCallStack(Classes: TDebugClasses; const AText: String);
var
  AStream: TStream;
begin
  if Classes * ActiveClasses = [] then Exit;
  AStream:=TMemoryStream.Create;
  GetCallStack(AStream);
  //SendStream free AStream
  SendStream(ltCallStack,AText,AStream);
end;

procedure TLogger.SendException(const AText: String; AException: Exception);
begin
  SendException(DefaultClasses,AText,AException);
end;

procedure TLogger.SendException(Classes: TDebugClasses; const AText: String;
  AException: Exception);
{$ifdef fpc}
var
  i: Integer;
  Frames: PPointer;
  S:String;
{$endif}
begin
  {$ifdef fpc}
  if Classes * ActiveClasses = [] then Exit;
  if AException <> nil then
    S:=AException.ClassName+' - '+AException.Message+LineEnding;
  S:= S + BackTraceStrFunc(ExceptAddr);
  Frames:=ExceptFrames;
  for i:= 0 to ExceptFrameCount - 1 do
    S:= S + (LineEnding+BackTraceStrFunc(Frames[i]));
  SendBuffer(ltException,AText,S[1],Length(S));
  {$endif}
end;

procedure TLogger.SendHeapInfo(const AText: String);
begin
  SendHeapInfo(DefaultClasses,AText);
end;

procedure TLogger.SendHeapInfo(Classes: TDebugClasses; const AText: String);
{$ifdef fpc}
var
  S: String;
{$endif}
begin
  {$ifdef fpc}
  if Classes * ActiveClasses = [] then Exit;
  with GetFPCHeapStatus do
  begin
    S:='MaxHeapSize: '+FormatNumber(MaxHeapSize)+LineEnding
      +'MaxHeapUsed: '+FormatNumber(MaxHeapUsed)+LineEnding
      +'CurrHeapSize: '+FormatNumber(CurrHeapSize)+LineEnding
      +'CurrHeapUsed: '+FormatNumber(CurrHeapUsed)+LineEnding
      +'CurrHeapFree: '+FormatNumber(CurrHeapFree);
  end;
  SendBuffer(ltHeapInfo,AText,S[1],Length(S));
  {$endif}
end;

procedure TLogger.SendMemory(const AText: String; Address: Pointer;
  Size: LongWord);
begin
  SendMemory(DefaultClasses,AText,Address,Size)
end;

procedure TLogger.SendMemory(Classes: TDebugClasses; const AText: String;
  Address: Pointer; Size: LongWord);
begin
  if Classes * ActiveClasses = [] then Exit;
  SendBuffer(ltMemory,AText,Address^,Size);
end;

procedure TLogger.SendIf(const AText: String; Expression: Boolean);
begin
  SendIf(DefaultClasses,AText,Expression,True);
end;

procedure TLogger.SendIf(Classes: TDebugClasses; const AText: String; Expression: Boolean
  );
begin
  SendIf(Classes,AText,Expression,True);
end;

procedure TLogger.SendIf(const AText: String; Expression, IsTrue: Boolean);
begin
  SendIf(DefaultClasses,AText,Expression,IsTrue);
end;

procedure TLogger.SendIf(Classes: TDebugClasses; const AText: String; Expression,
  IsTrue: Boolean);
begin
  if (Classes * ActiveClasses = []) or (Expression <> IsTrue) then Exit;
  SendStream(ltConditional,AText,nil);
end;

procedure TLogger.SendWarning(const AText: String);
begin
  SendWarning(DefaultClasses,AText);
end;

procedure TLogger.SendWarning(Classes: TDebugClasses; const AText: String);
begin
  if Classes * ActiveClasses = [] then Exit;
  SendStream(ltWarning,AText,nil);
end;

procedure TLogger.SendError(const AText: String);
begin
  SendError(DefaultClasses,AText);
end;

procedure TLogger.SendError(Classes: TDebugClasses; const AText: String);
begin
  if Classes * ActiveClasses = [] then Exit;
  SendStream(ltError,AText,nil);
end;

procedure TLogger.SendCustomData(const AText: String; Data: Pointer);
begin
  SendCustomData(DefaultClasses,AText,Data,FOnCustomData);
end;

procedure TLogger.SendCustomData(Classes: TDebugClasses; const AText: String; Data: Pointer);
begin
  SendCustomData(Classes,AText,Data,FOnCustomData);
end;

procedure TLogger.SendCustomData(const AText: String; Data: Pointer;
  CustomDataFunction: TCustomDataNotify);
begin
  SendCustomData(DefaultClasses,AText,Data,CustomDataFunction);
end;

procedure TLogger.SendCustomData(Classes: TDebugClasses; const AText: String;
  Data: Pointer; CustomDataFunction: TCustomDataNotify);
var
  DoSend: Boolean;
  TempStr: String;
begin
  if (Classes * ActiveClasses = []) or
    not Assigned(CustomDataFunction) then Exit;
  DoSend:=True;
  TempStr:=CustomDataFunction(Self,Data,DoSend);
  if DoSend then
    SendBuffer(ltCustomData,AText,TempStr[1],Length(TempStr));
end;

procedure TLogger.SendCustomData(const AText: String; Data: Pointer;
  CustomDataFunction: TCustomDataNotifyStatic);
begin
  SendCustomData(DefaultClasses,AText,Data,CustomDataFunction);
end;

procedure TLogger.SendCustomData(Classes: TDebugClasses; const AText: String;
  Data: Pointer; CustomDataFunction: TCustomDataNotifyStatic);
var
  DoSend: Boolean;
  TempStr: String;
begin
  if (Classes * ActiveClasses = []) or
    not Assigned(CustomDataFunction) then Exit;
    DoSend:=True;
  TempStr:=CustomDataFunction(Self,Data,DoSend);
  if DoSend then
    SendBuffer(ltCustomData,AText,TempStr[1],Length(TempStr));
end;

procedure TLogger.AddCheckPoint;
begin
  AddCheckPoint(DefaultClasses,DefaultCheckName);
end;

procedure TLogger.AddCheckPoint(Classes: TDebugClasses);
begin
  AddCheckPoint(Classes,DefaultCheckName);
end;

procedure TLogger.AddCheckPoint(const CheckName: String);
begin
  AddCheckPoint(DefaultClasses,CheckName);
end;

procedure TLogger.AddCheckPoint(Classes: TDebugClasses; const CheckName: String);
var
  i: Integer;
  j: PtrInt;
begin
  if Classes * ActiveClasses = [] then Exit;
  i:=FCheckList.IndexOf(CheckName);
  if i <> -1 then
  begin
    //Add a custom CheckList
    j:=PtrInt(FCheckList.Objects[i])+1;
    FCheckList.Objects[i]:=TObject(j);
  end
  else
  begin
    FCheckList.AddObject(CheckName,TObject(0));
    j:=0;
  end;
  SendStream(ltCheckpoint,CheckName+' #'+IntToStr(j),nil);
end;

procedure TLogger.IncCounter(const CounterName: String);
begin
  IncCounter(DefaultClasses,CounterName);
end;

procedure TLogger.IncCounter(Classes: TDebugClasses; const CounterName: String
  );
var
  i: Integer;
  j: PtrInt;
begin
  if Classes * ActiveClasses = [] then Exit;
  i := FCounterList.IndexOf(CounterName);
  if i <> -1 then
  begin
    j := PtrInt(FCounterList.Objects[i]) + 1;
    FCounterList.Objects[i] := TObject(j);
  end
  else
  begin
    FCounterList.AddObject(CounterName, TObject(1));
    j := 1;
  end;
  SendStream(ltCounter,CounterName+'='+IntToStr(j),nil);
end;

procedure TLogger.DecCounter(const CounterName: String);
begin
  DecCounter(DefaultClasses,CounterName);
end;

procedure TLogger.DecCounter(Classes: TDebugClasses; const CounterName: String
  );
var
  i: Integer;
  j: PtrInt;
begin
  if Classes * ActiveClasses = [] then Exit;
  i := FCounterList.IndexOf(CounterName);
  if i <> -1 then
  begin
    j := PtrInt(FCounterList.Objects[i]) - 1;
    FCounterList.Objects[i] := TObject(j);
  end
  else
  begin
    FCounterList.AddObject(CounterName, TObject(-1));
    j := -1;
  end;
  SendStream(ltCounter,CounterName+'='+IntToStr(j),nil);
end;

procedure TLogger.ResetCounter(const CounterName: String);
begin
  ResetCounter(DefaultClasses,CounterName);
end;

procedure TLogger.ResetCounter(Classes: TDebugClasses; const CounterName: String
  );
var
  i: Integer;
begin
  if Classes * ActiveClasses = [] then Exit;
  i := FCounterList.IndexOf(CounterName);
  if i <> -1 then
  begin
    FCounterList.Objects[i] := TObject(0);
    SendStream(ltCounter, FCounterList[i] + '=0', nil);
  end;
end;

function TLogger.GetCounter(const CounterName: String): Integer;
var
  i: Integer;
begin
  i := FCounterList.IndexOf(CounterName);
  if i <> -1 then
    Result := PtrInt(FCounterList.Objects[i])
  else
    Result := 0;
end;

procedure TLogger.ResetCheckPoint;
begin
  ResetCheckPoint(DefaultClasses,DefaultCheckName);
end;

procedure TLogger.ResetCheckPoint(Classes: TDebugClasses);
begin
  ResetCheckPoint(Classes,DefaultCheckName);
end;

procedure TLogger.ResetCheckPoint(const CheckName: String);
begin
  ResetCheckPoint(DefaultClasses,CheckName);
end;

procedure TLogger.ResetCheckPoint(Classes: TDebugClasses; const CheckName:String);
var
  i: Integer;
begin
  if Classes * ActiveClasses = [] then Exit;
  i:=FCheckList.IndexOf(CheckName);
  if i <> -1 then
  begin
    FCheckList.Objects[i] := TObject(0);
    SendStream(ltCheckpoint, CheckName+' #0',nil);
  end;
end;

procedure TLogger.EnterMethod(const AMethodName: String);
begin
  EnterMethod(DefaultClasses,nil,AMethodName);
end;

procedure TLogger.EnterMethod(Classes: TDebugClasses; const AMethodName: String);
begin
  EnterMethod(Classes,nil,AMethodName);
end;

procedure TLogger.EnterMethod(Sender: TObject; const AMethodName: String);
begin
  EnterMethod(DefaultClasses,Sender,AMethodName);
end;

procedure TLogger.EnterMethod(Classes: TDebugClasses; Sender: TObject;
  const AMethodName: String);
begin
  if Classes * ActiveClasses = [] then Exit;
  FLogStack.Insert(0, UpperCase(AMethodName));
  if Sender <> nil then
    SendStream(ltEnterMethod, GetObjectDescription(Sender) + '.' + AMethodName, nil)
  else
    SendStream(ltEnterMethod, AMethodName, nil);
end;

procedure TLogger.ExitMethod(const AMethodName: String);
begin
  ExitMethod(DefaultClasses,nil,AMethodName);
end;

procedure TLogger.ExitMethod(Sender: TObject; const AMethodName: String);
begin
  ExitMethod(DefaultClasses,Sender,AMethodName);
end;

procedure TLogger.ExitMethod(Classes: TDebugClasses; const AMethodName: String);
begin
  ExitMethod(Classes,nil,AMethodName);
end;

procedure TLogger.ExitMethod(Classes: TDebugClasses; Sender: TObject;
  const AMethodName: String);
var
  i: Integer;
begin
  //ensure that ExitMethod will be called always even if there's an unpaired Entermethod
  //and Classes is not in ActiveClasses
  if FLogStack.Count = 0 then Exit;
  //todo: see if is necessary to do Uppercase (set case sensitive to false?)
  i := FLogStack.IndexOf(UpperCase(AMethodName));
  if i <> -1 then
    FLogStack.Delete(i)
  else
    Exit;
  if Sender <> nil then
    SendStream(ltExitMethod, GetObjectDescription(Sender) + '.' + AMethodName, nil)
  else
    SendStream(ltExitMethod, AMethodName, nil);
end;

procedure TLogger.Watch(const AText, AValue: String);
begin
  Watch(DefaultClasses,AText,AValue);
end;

procedure TLogger.Watch(Classes: TDebugClasses; const AText, AValue: String);
begin
  if Classes * ActiveClasses = [] then Exit;
  SendStream(ltWatch,AText+'='+AValue,nil);
end;

procedure TLogger.Watch(const AText: String; AValue: Integer);
begin
  Watch(DefaultClasses,AText,AValue);
end;

procedure TLogger.Watch(Classes: TDebugClasses; const AText: String;
  AValue: Integer);
begin
  if Classes * ActiveClasses = [] then Exit;
  SendStream(ltWatch,AText+'='+IntToStr(AValue),nil);
end;

{$ifdef fpc}
procedure TLogger.Watch(const AText: String; AValue: Cardinal);
begin
  Watch(DefaultClasses,AText,AValue);
end;

procedure TLogger.Watch(Classes: TDebugClasses; const AText: String;
  AValue: Cardinal);
begin
  if Classes * ActiveClasses = [] then Exit;
  SendStream(ltWatch,AText+'='+IntToStr(AValue),nil);
end;
{$endif}

procedure TLogger.Watch(const AText: String; AValue: Double);
begin
  Watch(DefaultClasses,AText,AValue);
end;

procedure TLogger.Watch(Classes: TDebugClasses; const AText: String; AValue: Double
  );
begin
  if Classes * ActiveClasses = [] then Exit;
  SendStream(ltWatch,AText+'='+FloatToStr(AValue),nil);
end;

procedure TLogger.Watch(const AText: String; AValue: Boolean);
begin
  Watch(DefaultClasses,AText,AValue);
end;

procedure TLogger.Watch(Classes: TDebugClasses; const AText: String;
  AValue: Boolean);
begin
  if Classes * ActiveClasses = [] then Exit;
  SendStream(ltWatch,AText+'='+BoolToStr(AValue),nil);
end;

{ TChannelList }

function TChannelList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TChannelList.GetItems(AIndex:Integer): TLogChannel;
begin
  Result := TLogChannel(FList[AIndex]);
end;

constructor TChannelList.Create;
begin
  FList := TFPList.Create;
end;

destructor TChannelList.Destroy;
var
  i: Integer;
begin
  //free the registered channels
  for i := 0 to FList.Count - 1 do
    Items[i].Free;
  FList.Destroy;
end;

function TChannelList.Add(AChannel: TLogChannel):Integer;
begin
  Result := FList.Add(AChannel);
  AChannel.Init;
end;

procedure TChannelList.Remove(AChannel: TLogChannel);
begin
  FList.Remove(AChannel);
end;


{ TLogChannel }

procedure TLogChannel.Init;
begin

end;

end.

