{************************************************}
{                                                }
{  ATBinHex component                            }
{  Copyright (C) 2006-2007 Alexey Torgashin      }
{  http://atorg.net.ru                           }
{  atorg@yandex.ru                               }
{                                                }
{************************************************}

{
LCL port: Luiz Americo Pereira Camara
}

{$mode delphi}
{$H+}

{.$OPTIMIZATION OFF} //Delphi 5 cannot compile this with optimization on.
{$BOOLEVAL OFF}    //Short boolean evaluation required.
{$RANGECHECKS OFF} //For assignment compatability between DWORD and Longint.

{$I ATBinHexOptions.inc} //ATBinHex options.

unit ATBinHex;


interface

uses
  LCLIntf, LCLType, Types, SysUtils, Classes, Controls, Graphics,
  StdCtrls, ExtCtrls,
  {$ifdef DEBUG_ATBINHEX}
  SharedLogger, IPCChannel,
  {$endif}
  {$ifdef NOTIF} ATFileNotification, {$endif}
  Menus,
  DelphiCompat;

const
  IsWinNT = True;

type
  TATEncoding = (
    vencANSI,
    vencOEM
    );

  TATBinHexMode = (
    vbmodeText,
    vbmodeBinary,
    vbmodeHex,
    vbmodeUnicode
    );

  TATUnicodeFormat = (
    vbUnicodeFmtUnknown,
    vbUnicodeFmtLE,
    vbUnicodeFmtBE
    );

  TATDirection = (
    vdirUp,
    vdirDown
    );

  TATFileSource = (
    vfsrcUnassigned,
    vfsrcFile,
    vfsrcStream
    );

  TATPopupCommand = (
    vpcmdCopy,
    vpcmdCopyHex,
    vpcmdSelectLine,
    vpcmdSelectAll
    );

  TATPopupCommands = set of TATPopupCommand;

const
  clLtGray2 = $ECECEC;

  vpcmdDefaultSet = [vpcmdCopy, vpcmdCopyHex, {vpcmdSelectLine,} vpcmdSelectAll];

type

  { TATBinHex }

  TATBinHex = class(TCustomControl)
  private
    FFileName: WideString;
    FFileHandle: THandle;
    FFileSize: Int64;
    FFileOK: Boolean;
    FFileUnicodeFmt: TATUnicodeFormat;
    FFileSourceType: TATFileSource;
    {$ifdef SEARCH}
    FSearch: TATStreamSearch;
    {$endif}
    FStream: TStream;
    FBuffer: PChar;
    FBufferMaxOffset: Integer;
    FBufferAllocSize: Integer;
    FBitmap: TBitmap;
    FTimer: TTimer;
    FStrings: TObject;
    FMenu: TPopupMenu;
    FMenuItemCopy: TMenuItem;
    FMenuItemCopyHex: TMenuItem;
    FMenuItemSelectLine: TMenuItem;
    FMenuItemSelectAll: TMenuItem;
    FMenuItemSep: TMenuItem;
    {$ifdef NOTIF}
    FNotif: TATFileNotification;
    {$endif}
    FAutoReload: Boolean;
    FAutoReloadBeep: Boolean;
    FAutoReloadFollowTail: Boolean;
    FLockCount: Integer;
    FBufferPos: Int64;
    FViewPos: Int64;
    FViewAtEnd: Boolean;
    FHViewPos: Integer;
    FHViewWidth: Integer;
    FSelStart: Int64;
    FSelLength: Int64;
    FMode: TATBinHexMode;
    FEncoding: TATEncoding;
    FTextWidth: Integer;
    FTextWidthHex: Integer;
    FTextWidthFit: Boolean;
    FTextWidthFitHex: Boolean;
    FTextWrap: Boolean;
    FTextColorHex: TColor;
    FTextColorHex2: TColor;
    FTextColorHexBack: TColor;
    FTextColorLines: TColor;
    FTextColorError: TColor;
    FSearchIndentVert: Integer;
    FSearchIndentHorz: Integer;
    FTabSize: Integer;
    FPopupCommands: TATPopupCommands;
    FMaxLength: Integer;
    FMaxLengths: array[TATBinHexMode] of Integer;
    FMaxClipboardDataSizeMb: Integer;
    FFontOEM: TFont;
    FScrollPageSize: Boolean;
    FHexOffsetLen: Integer;
    FMouseDown: Boolean;
    FMouseStart: Int64;
    FMouseStartShift: Int64;
    FMouseStartDbl: Int64;
    FMouseDblClick: Boolean;
    FMouseTriClick: Boolean;
    FMouseTriTime: DWORD;
    FMousePopupPos: TPoint;
    FMouseScrollUp: Boolean;
    FOnSelectionChange: TNotifyEvent;
    {$ifdef NOTIF}
    FOnFileReload: TNotifyEvent;
    {$endif}
    procedure AllocBuffer;
    procedure RedrawEmpty;
    procedure Redraw(DoPaintBitmap: Boolean = True);
    function SourceAssigned: Boolean;
    function ReadSource(const APos: Int64; ABuffer: Pointer; ABufferSize: DWORD; var AReadSize: DWORD): Boolean;
    procedure ReadBuffer;
    procedure InitData;
    procedure FreeData;
    function LoadFile(ANewFile: boolean): boolean;
    function LoadStream: boolean;
    procedure DetectUnicodeFmt;
    procedure HideScrollBar(AHorz: boolean);
    procedure SetVScrollBar(APageSize: integer);
    procedure SetHScrollBar;
    procedure SetMode(AMode: TATBinHexMode);
    procedure SetEncoding(AEncoding: TATEncoding);
    procedure SetTextWidth(AWidth: Integer);
    procedure SetTextWidthHex(AWidth: Integer);
    procedure SetTextWidthFit(AFit: boolean);
    procedure SetTextWidthFitHex(AFit: boolean);
    procedure SetTextWrap(AWrap: boolean);
    procedure SetSearchIndentVert(AIndent: Integer);
    procedure SetSearchIndentHorz(AIndent: Integer);
    procedure SetFontOEM(AFont: TFont);
    procedure InitHexOffsetLen;
    procedure MsgReadError;
    procedure MsgOpenError;
    function LinesNum: integer;
    function ColsNumFit: integer;
    function ColsNumHexFit: integer;
    function ColsNum: integer;
    function PosBad(const APos: Int64): boolean;
    function PosMax: Int64;
    function PosLast: Int64;
    procedure PosAt(const APos: Int64; ARedraw: boolean = true);
    procedure PosDec(const n: Int64);
    procedure PosInc(const n: Int64);
    procedure PosLineUp(n: Integer = 1);
    procedure PosLineDown(n: Integer = 1);
    procedure PosPageUp;
    procedure PosPageDown;
    procedure PosBegin(ARedraw: boolean = true);
    procedure PosEnd(ARedraw: boolean = true);
    procedure HPosAt(APos: integer; ARedraw: boolean = true);
    procedure HPosInc(N: integer);
    procedure HPosDec(N: integer);
    procedure HPosBegin;
    procedure HPosEnd;
    procedure HPosLeft;
    procedure HPosRight;
    procedure HPosPageLeft;
    procedure HPosPageRight;
    function HPosWidth: integer;
    function HPosMax: integer;
    function GetPosPercent: Integer;
    procedure SetPosPercent(APos: Integer);
    function GetPosOffset: Int64;
    procedure SetPosOffset(const APos: Int64; ARedraw: boolean = true);
    procedure SetPosOffset_(const APos: Int64);
    procedure MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    function MousePosition(AX, AY: integer): Int64;
    procedure MouseMoveAction(AX, AY: integer);
    procedure TimerTimer(Sender: TObject);
    procedure MenuItemCopyClick(Sender: TObject);
    procedure MenuItemCopyHexClick(Sender: TObject);
    procedure MenuItemSelectLineClick(Sender: TObject);
    procedure MenuItemSelectAllClick(Sender: TObject);
    procedure UpdateMenu;
    procedure SetMsgCopy(const S: string);
    procedure SetMsgCopyHex(const S: string);
    procedure SetMsgSelectLine(const S: string);
    procedure SetMsgSelectAll(const S: string);
    procedure SetTabSize(ASize: Integer);
    function GetAnsiDecode: boolean;
    function FindLinePos(const AStartPos: Int64; ADir: TATDirection; var ALine: WideString): Int64;
    function FindLineLength(const AStartPos: Int64; ADir: TATDirection; var ALine: WideString): integer;
    procedure PosNextLineFrom(const AStartPos: Int64; ALines: integer; ADir: TATDirection; ARedraw: boolean = true);
    procedure PosNextLine(ALines: integer; ADir: TATDirection);
    function GetChar(const APos: Int64): WideChar;
    function CharSize: integer;
    function FileIsEmpty: Boolean;
    procedure NormalizePos(var APos: Int64);
    function NormalizedPos(const APos: Int64): Int64;
    procedure NextPos(var APos: Int64; ADir: TATDirection); overload;
    procedure NextPos(var APos: Int64; ADir: TATDirection; AChars: integer); overload;
    procedure SelectLineAtPos(const APos: Int64; AWordOnly: boolean);
    procedure ContextPopup(Sender: TObject; MousePos: TPoint; var Handled: boolean);
    function ActiveFont: TFont;
    {$ifdef NOTIF}
    procedure NotifChanged(Sender: TObject);
    procedure DoFileReload;
    {$endif}
    procedure Lock;
    procedure Unlock;
    function Locked: boolean;
    function GetSelText: AnsiString;
    function GetSelTextA: AnsiString;
    function GetSelTextW: WideString;
    procedure DoSelectionChange;
    function GetMaxLengths(AIndex: TATBinHexMode): integer;
    procedure SetMaxLengths(AIndex: TATBinHexMode; AValue: integer);
    {$ifdef PRINT}
    function PrintCaption: string;
    {$endif}
    {$ifdef SEARCH}
    function GetOnSearchProgress: TATStreamSearchProgress;
    procedure SetOnSearchProgress(AValue: TATStreamSearchProgress);
    function GetSearchResultStart: Int64;
    function GetSearchResultLength: Int64;
    {$endif}
    procedure SetMaxClipboardDataSizeMb(AValue: Integer);

  protected
    procedure DblClick; override;
    procedure DoOnResize; override;
    procedure Paint; override;
    procedure WMGetDlgCode(var Message: TMessage); message WM_GETDLGCODE;
    procedure WMEraseBkgnd(var Message: TMessage); message WM_ERASEBKGND;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Open(const AFileName: WideString; ARedraw: boolean = true): boolean;
    function OpenStream(AStream: TStream; ARedraw: boolean = true): boolean;
    {$ifdef SEARCH}
    function FindFirst(const AText: WideString; AOptions: TATStreamSearchOptions): Boolean;
    function FindNext: Boolean;
    {$endif}
    function IncreaseFontSize(AIncrement: Boolean): Boolean;
    procedure CopyToClipboard(AsHex: boolean = false);
    property SelStart: Int64 read FSelStart;
    property SelLength: Int64 read FSelLength;
    property SelText: AnsiString read GetSelText;
    property SelTextW: WideString read GetSelTextW;
    procedure SetSelection(const AStart, ALength: Int64; AScroll: boolean; AFireEvent: boolean = true);
    procedure Scroll(const APos: Int64; AIndentVert, AIndentHorz: Integer; ARedraw: Boolean = True);
    procedure SelectAll;
    procedure SelectNone(AFireEvent: boolean = true);
    {$ifdef PRINT}
    procedure Print(ASelectionOnly: Boolean; ACopies: Word = 1; ACaption: string = '');
    {$endif}
    property PosPercent: Integer read GetPosPercent write SetPosPercent;
    property PosOffset: Int64 read GetPosOffset write SetPosOffset_;
    property MsgCopy: string write SetMsgCopy;
    property MsgCopyHex: string write SetMsgCopyHex;
    property MsgSelectLine: string write SetMsgSelectLine;
    property MsgSelectAll: string write SetMsgSelectAll;
    property MaxLengths[AIndex: TATBinHexMode]: integer read GetMaxLengths write SetMaxLengths;
    property MaxClipboardDataSizeMb: Integer read FMaxClipboardDataSizeMb write SetMaxClipboardDataSizeMb;
    property FileName: WideString read FFileName;
    property FileSize: Int64 read FFileSize;
    property FileUnicodeFormat: TATUnicodeFormat read FFileUnicodeFmt;
    property FileReadOK: boolean read FFileOK;
    {$ifdef SEARCH}
    property SearchResultStart: Int64 read GetSearchResultStart;
    property SearchResultLength: Int64 read GetSearchResultLength;
    {$endif}

  published
    property Align;
    property Anchors;
    property BorderSpacing;
    property BorderStyle;
    property Font;
    property ParentColor;
    property TabOrder;
    property FontOEM: TFont read FFontOEM write SetFontOEM;
    property Mode: TATBinHexMode read FMode write SetMode default vbmodeText;
    property TextEncoding: TATEncoding read FEncoding write SetEncoding default vencANSI;
    property TextWidth: Integer read FTextWidth write SetTextWidth default 80;
    property TextWidthHex: Integer read FTextWidthHex write SetTextWidthHex default 16;
    property TextWidthFit: boolean read FTextWidthFit write SetTextWidthFit default false;
    property TextWidthFitHex: boolean read FTextWidthFitHex write SetTextWidthFitHex default false;
    property TextWrap: boolean read FTextWrap write SetTextWrap default false;
    property TextColorHex: TColor read FTextColorHex write FTextColorHex default clNavy;
    property TextColorHex2: TColor read FTextColorHex2 write FTextColorHex2 default clBlue;
    property TextColorHexBack: TColor read FTextColorHexBack write FTextColorHexBack default clLtGray2;
    property TextColorLines: TColor read FTextColorLines write FTextColorLines default clGray;
    property TextColorError: TColor read FTextColorError write FTextColorError default clRed;
    property TextSearchIndentVert: Integer read FSearchIndentVert write SetSearchIndentVert default 5;
    property TextSearchIndentHorz: Integer read FSearchIndentHorz write SetSearchIndentHorz default 5;
    property TextTabSize: Integer read FTabSize write SetTabSize default 8;
    property TextPopupCommands: TATPopupCommands read FPopupCommands write FPopupCommands default vpcmdDefaultSet;
    property ScrollPageSize: boolean read FScrollPageSize write FScrollPageSize default true;
    {$ifdef NOTIF}
    property AutoReload: boolean read FAutoReload write FAutoReload default false;
    property AutoReloadBeep: boolean read FAutoReloadBeep write FAutoReloadBeep default false;
    property AutoReloadFollowTail: boolean read FAutoReloadFollowTail write FAutoReloadFollowTail default true;
    property OnFileReload: TNotifyEvent read FOnFileReload write FOnFileReload;
    {$endif}
    {$ifdef SEARCH}
    property OnSearchProgress: TATStreamSearchProgress read GetOnSearchProgress write SetOnSearchProgress;
    {$endif}
    property OnSelectionChange: TNotifyEvent read FOnSelectionChange write FOnSelectionChange;
  end;

function TextIncreaseFontSize(AFont: TFont; ACanvas: TCanvas; AIncrement: Boolean): Boolean;

implementation

uses
  Printers,
  Forms,
  {$ifdef DEBUG_FORM} TntStdCtrls, {$endif}
  ATxSProcFPC, ATxSHexFPC, ATxFProcFPC, ATxClipboardFPC, ATViewerMsgFPC;


{ Important constants: change with care }

const
  cMaxLengthDefault = 300; //Default value of "Maximal line length".
                           //See MaxLengths property description.
                           //Don't set too large value, it affects default file buffer size.

  cMaxLength = 2 * 1024;   //Limits for "Maximal line length" value.
  cMinLength = 2;

  cMaxLines = 200; //Maximal number of lines on screen supported.
                   //Don't set too large value because it affects file buffer size.
                   //Warning: It may be not enough for very high screen resolutions!
                   //200 should be enough for Height=1600, if we assume that minimal
                   //font height is 8.
                   //Suggestion: make it a field affected by current control height.


{ Visual constants: may be changed freely }

const
  cMaxTabSize = 16; //Limits for tabulation size
  cMinTabSize = 1;
  cSpecialChar = '.';             //Char that replaces control characters (lower than $20)
  cArrowScrollSize = 200;         //Scroll size (px) for Left/Right keys
  cMWheelLines = 3;               //Lines to scroll by mouse wheel
  cMScrollLines = 3;              //Lines to scroll when mouse is upper/lower than control
  cMScrollTime = 150;             //Interval of timer that scrolls control when mouse is upper/lower
  cHexOffsetSep = ':';            //Separator between hex offset and digits (may be set to empty string)
  cHexLinesShow = True;           //Draw vertical lines in Hex mode
  cHexLinesWidth = 2;             //Width of lines in pixels
  cPositionX0 = 2;                //Position of left-top corner of display
  cPositionY0 = 0;
  cSelectionByDoubleClick = true; //Double click selects current word
  cSelectionByTripleClick = True; //Triple click selects current line
  cSelectionByShiftClick = True;  //Click marks selection start, Shift+Click marks selection end
  cSelectionRightIndent = 4;      //Minimal space (px) before selection start and control right border
  cMaxClipboardDataSizeMb = 16;   //Maximal data size for copying to Clipboard, in Mb
  cMaxClipboardDataSizeMbMin = 8; //  (default and minimal values)
  cMaxFontSize = 72;              //Maximal font size for IncreaseFontSize method
  cMaxSearchIndent = 80;          //Maximal vertical/horizontal search indent (chars)


{ Debug form }

{$ifdef DEBUG_FORM}
var
  FDebugForm: TForm = nil;
  FDebugLabel1: TTntLabel = nil;
  FDebugLabel2: TTntLabel = nil;

procedure MsgDebug(const S1, S2: WideString);
begin
  if Assigned(FDebugLabel1) and Assigned(FDebugLabel2) then
  begin
    FDebugLabel1.Caption := S1;
    FDebugLabel2.Caption := S2;
  end;
end;

function MsgDebugStr(const S: WideString; Pos: integer): WideString;
begin
  Result := S;
  if Pos > 0 then
    Insert('>', Result, Pos);
end;

procedure InitDebugForm;
begin
  FDebugForm := TForm.Create(nil);
  with FDebugForm do
  begin
    Left := 0;
    Top := 0;
    Width := Screen.Width;
    ClientHeight := 25;
    Caption := 'Debug';
    BorderStyle := bsToolWindow;
    BorderIcons := [];
    FormStyle := fsStayOnTop;
    Font.Name := 'Tahoma';
    Font.Size := 8;
    Color := clWhite;
    Enabled := False;
    Show;
    end;

  FDebugLabel1:= TTntLabel.Create(FDebugForm);
  with FDebugLabel1 do
    begin
    Parent := FDebugForm;
    Left := 4;
    Top := 4;
    end;

  FDebugLabel2:= TTntLabel.Create(FDebugForm);
  with FDebugLabel2 do
    begin
    Parent:= FDebugForm;
    Left:= 4;
    Top:= 18;
    end;

  MsgDebug('', '');
end;

procedure FreeDebugForm;
begin
  FDebugLabel1.Free;
  FDebugLabel2.Free;
  FDebugForm.Free;
end;
{$endif}


{ Helper functions }

procedure SwapInt64(var n1, n2: Int64);
var
  n: Int64;
begin
  N := N1;
  N1 := N2;
  N2 := N;
end;

procedure InvertRect(Canvas: TCanvas; const Rect: TRect);
begin
  {$ifdef DEBUG_ATBINHEX}
  Logger.Send('InvertRect',Rect);
  {$endif}
  DelphiCompat.InvertRect(Canvas.Handle, Rect);
end;

function SExtractAnsiFromWide(const S: WideString): AnsiString;
var
  i: integer;
begin
  SetLength(Result, Length(S));
  for i := 1 to Length(S) do
    Result[i] := Char(S[i]);
end;

function SConvertForOut(const S: WideString; TabSize: Integer; AnsiDecode: Boolean): WideString;
begin
  Result := SReplaceTabsW(S, TabSize);

  if AnsiDecode then
    Result:= SExtractAnsiFromWide(Result);
end;

procedure StringOut(Canvas: TCanvas; const X, Y: Integer; const Str: WideString; TabSize: Integer; AnsiDecode: Boolean);
var
  S: WideString;
begin
  S:= SConvertForOut(Str, TabSize, AnsiDecode);

  if IsWinNT then
    TextOutW(Canvas.Handle, X, Y, PWideChar(S), Length(S))
  else
    TextOut(Canvas.Handle, X, Y, PChar(string(S)), Length(S));
end;

type
  TStringExtent = array[0..cMaxLength] of integer;

type
  TTextExtentEx = array[1 .. MaxInt div SizeOf(Integer)] of Integer;
  PTextExtentEx = ^TTextExtentEx;

function StringExtent(Canvas: TCanvas; const Str: WideString; var Ext: TStringExtent; TabSize: Integer; AnsiDecode: Boolean): Boolean;
var
  S: WideString;
  Size: TSize;
  i, j: integer;
  Dx: PTextExtentEx;
  DxSize: integer;
begin
  S:= SConvertForOut(Str, TabSize, AnsiDecode);

  DxSize:= Length(S)*SizeOf(integer);
  GetMem(Dx, DxSize);
  FillChar(Dx^, DxSize, 0);

  if IsWinNT
    then Result:= GetTextExtentExPointW(Canvas.Handle, PWideChar(S), Length(S), 0, nil, PInteger(Dx), Size)
    else Result:= GetTextExtentExPoint(Canvas.Handle, PChar(string(S)), Length(S), 0, nil, PInteger(Dx), Size);

  FillChar(Ext, SizeOf(Ext), 0);
  if Result then
    begin
    j:= 0;
    for i:= 1 to Length(Str) do
      begin
      Inc(j);
      if Str[i] = #9 then
        Inc(j, TabSize - 1);
      Ext[i] := Dx^[j];
      {$ifdef DEBUG_ATBINHEX}
      Logger.Send('StringExtent Ext[%d]: %d',[i,Ext[i]]);
      {$endif}
      end;
    end;

  FreeMem(Dx);
end;

function StringWidth(Canvas: TCanvas; const Str: WideString; TabSize: Integer; AnsiDecode: Boolean): Integer;
var
  S: WideString;
  Size: TSize;
  OK: boolean;
begin
  S:= SConvertForOut(Str, TabSize, AnsiDecode);

  if IsWinNT
    then OK:= GetTextExtentPoint32W(Canvas.Handle, PWideChar(S), Length(S), Size)
    else OK:= GetTextExtentPoint(Canvas.Handle, PChar(string(S)), Length(S), Size);
  if OK
    then Result:= Size.cx
    else Result:= 0;
end;

function IsSeparator(ch: WideChar): boolean;
begin
  Result := (ch = ' ') or (ch = #9) or (ch = '\');
end;

function StringWrapPosition(const S: WideString; MaxLen: integer): integer;
var
  i: integer;
begin
  for i := IMin(MaxLen + 1, Length(S)) downto 1 do
    if IsSeparator(S[i]) then
      begin Result:= i; Exit end;
  Result:= MaxLen;
end;

function FontHeight(Canvas: TCanvas): integer;
var
  Metric: TTextMetric;
begin
  if GetTextMetrics(Canvas.Handle, Metric) then
    Result := Metric.tmHeight
  else
    Result := Abs(Canvas.Font.Height);
end;

function FontWidthDigits(Canvas: TCanvas): integer;
begin
  Result:= Canvas.TextWidth('0');
end;

function FontMonospaced(Canvas: TCanvas): boolean;
begin
  Result := Canvas.TextWidth('W') = Canvas.TextWidth('.');
end;

function BoolToSign(AValue: Boolean): Integer;
begin
  if AValue then
    Result := 1
  else
    Result := -1;
end;

function TextIncreaseFontSize(AFont: TFont; ACanvas: TCanvas; AIncrement: Boolean): Boolean;
var
  C: TCanvas;
  CHeight: Integer;
begin
  Result := False;

  C := TCanvas.Create;
  try
    C.Handle := ACanvas.Handle;
    C.Font.Assign(AFont);

    CHeight := FontHeight(C);

    repeat
      if AIncrement then
      begin
        if C.Font.Size >= cMaxFontSize then Break;
      end
      else
      begin
        if C.Font.Size <= 1 then Break;
      end;

      C.Font.Size := C.Font.Size + BoolToSign(AIncrement);

      if FontHeight(C) <> CHeight then
      begin
        AFont.Size := C.Font.Size;
        Result := True;
        Break;
      end;
    until False;

  finally
    FreeAndNil(C);
  end;
end;


{ TStrPositions }

type
  TStrPosRecord = record
    Str: WideString;
    Pnt: TPoint;
    Pos: Int64;
  end;

  TStrPosArray = array[1..cMaxLines] of TStrPosRecord;

  TStrPositions = class(TObject)
  private
    FNum: Integer;
    FArray: TStrPosArray;
    FCharSize: integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear(ACharSize: integer = 1);
    procedure Add(const AStr: WideString; AX, AY: integer; const APos: Int64);
    function GetPosFromCoord(ACanvas: TCanvas; AX, AY: Integer; ATabSize: Integer; AAnsiDecode: Boolean): Int64;
    function GetCoordFromPos(ACanvas: TCanvas; const APos: Int64; ATabSize: Integer; AAnsiDecode: Boolean; var AX, AY: Integer): Boolean;
    function GetScreenWidth(ACanvas: TCanvas; ATabSize: Integer; AAnsiDecode: Boolean): Integer;
  end;

constructor TStrPositions.Create;
begin
  inherited Create;
  FillChar(FArray, SizeOf(FArray), 0);
  FNum:= 0;
  FCharSize:= 1;
end;

destructor TStrPositions.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TStrPositions.Clear(ACharSize: integer = 1);
var
  i: Integer;
begin
  for i := FNum downto 1 do
    with FArray[i] do
    begin
      Str := '';
      Pnt := Point(0, 0);
      Pos := 0;
    end;
  FNum := 0;
  FCharSize := ACharSize;
end;

procedure TStrPositions.Add(const AStr: WideString; AX, AY: integer; const APos: Int64);
begin
  if FNum < High(TStrPosArray) then
  begin
    Inc(FNum);
    with FArray[FNum] do
      begin
      Str := AStr;
      Pnt := Point(AX, AY);
      Pos := APos;
      end;
  end;
end;

function TStrPositions.GetPosFromCoord(ACanvas: TCanvas; AX, AY: Integer; ATabSize: Integer; AAnsiDecode: Boolean): Int64;
var
  YH: integer;
  Num, i: Integer;
  Dx: TStringExtent;
begin
  Result := -1;

  if FNum = 0 then Exit;

  {$ifdef DEBUG_FORM} MsgDebug('', ''); {$endif}

  //Mouse upper than first line
  with FArray[1] do
    if AY < Pnt.Y then
    begin
      {$ifdef DEBUG_FORM} MsgDebug('Upper than first line', ''); {$endif}
      Result := Pos;
      Exit
    end;

  YH := FontHeight(ACanvas);
  Num := 0;
  for i := 1 to FNum do
    with FArray[i] do
      if (AY >= Pnt.Y) and (AY < Pnt.Y + YH) then
      begin
        Num := i;
        Break
      end;

  //Mouse lower than last line
  if Num = 0 then
    with FArray[FNum] do
    begin
      {$ifdef DEBUG_FORM} MsgDebug('Lower than last line', ''); {$endif}
      Result := Pos + Length(Str) * FCharSize;
      Exit
    end;

  with FArray[Num] do
  begin
    //Mouse lefter than line
    if AX <= Pnt.X then
    begin
      {$ifdef DEBUG_FORM} MsgDebug(Format('Lefter than line %d', [Num]), MsgDebugStr(Str, 1)); {$endif}
      Result := Pos;
      Exit
    end;

    if StringExtent(ACanvas, Str, Dx, ATabSize, AAnsiDecode) then
    begin
      //Mouse inside line
      for i := 1 to Length(Str) do
      begin
        if (AX < Pnt.X + (Dx[i - 1] + Dx[i]) div 2) then
        begin
          {$ifdef DEBUG_FORM} MsgDebug(Format('Line %d, Char %d', [Num, i]), MsgDebugStr(Str, i)); {$endif}
          Result := Pos + (i - 1) * FCharSize;
          Exit
        end;
      end;

      //Mouse righter than line
      {$ifdef DEBUG_FORM} MsgDebug(Format('Righer than line %d', [Num]), ''); {$endif}
      Result := Pos + Length(Str) * FCharSize;
    end;
  end;
end;

function TStrPositions.GetCoordFromPos(ACanvas: TCanvas; const APos: Int64; ATabSize: Integer; AAnsiDecode: Boolean; var AX, AY: Integer): Boolean;
var
  i: Integer;
  Dx: TStringExtent;
begin
  Result := False;

  AX := 0;
  AY := 0;

  for i := 1 to FNum do
    with FArray[i] do
      if (APos >= Pos) and (APos < Pos + Length(Str) * FCharSize) then
        if StringExtent(ACanvas, Str, Dx, ATabSize, AAnsiDecode) then
        begin
          Result := True;
          AX := Pnt.X + Dx[(APos - Pos) div FCharSize];
          AY := Pnt.Y;
          Break
        end;

  //debug
  {
  if not Result then
  begin
    S := '';
    for i := 1 to FNum do
      with FArray[i] do
        S := S + Format('%d:  Pos: %d', [i, Pos]) + #13;
    S := S + #13 + Format('APos: %d', [APos]);
    MsgError(S);
  end;
  }
end;


function TStrPositions.GetScreenWidth(ACanvas: TCanvas; ATabSize: Integer; AAnsiDecode: Boolean): Integer;
var
  i: Integer;
  AWidth: Integer;
begin
  Result := 0;
  for i := 1 to FNum do
    with FArray[i] do
    begin
      AWidth := Pnt.X + StringWidth(ACanvas, Str, ATabSize, AAnsiDecode);
      ILimitMin(Result, AWidth);
    end;
end;


{ TATBinHex }

procedure TATBinHex.AllocBuffer;
begin
  FMaxLength:= FMaxLengths[FMode];

  //Buffer contains 3 offsets: offset below + 2 offsets above view position
  FBufferMaxOffset:= FMaxLength*cMaxLines*CharSize;
  FBufferAllocSize:= 3*FBufferMaxOffset;

  GetMem(FBuffer, FBufferAllocSize);
  FillChar(FBuffer^, FBufferAllocSize, 0);
end;

constructor TATBinHex.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //Init inherited properties
  Width:= 200;
  Height:= 150;
  Color:= clWindow;
  Cursor:= crIBeam;
  ControlStyle:= ControlStyle + [csOpaque];

  Font.Name:= 'Courier New';
  Font.Size:= 10;
  Font.Color:= clWindowText;

  //Init fields
  FMode := vbmodeText;
  FEncoding := vencANSI;
  FTextWidth := 80;
  FTextWidthHex := 16;
  FTextWidthFit := False;
  FTextWidthFitHex := False;
  FTextWrap := False;
  FTextColorHex := clNavy;
  FTextColorHex2 := clBlue;
  FTextColorHexBack := clLtGray2;
  FTextColorLines := clGray;
  FTextColorError := clRed;
  FScrollPageSize := True;
  //FScrollHorzVisible := False;
  //FScrollVertVisible := False;
  FSearchIndentVert := 5;
  FSearchIndentHorz := 5;
  FTabSize := 8;
  FPopupCommands := vpcmdDefaultSet;

  FAutoReload := False;
  FAutoReloadBeep := False;
  FAutoReloadFollowTail := True;

  FMaxLength := 0; //Initialized in AllocBuffer
  FMaxLengths[vbmodeText] := cMaxLengthDefault;
  FMaxLengths[vbmodeBinary] := cMaxLengthDefault;
  FMaxLengths[vbmodeHex] := cMaxLengthDefault;
  FMaxLengths[vbmodeUnicode] := cMaxLengthDefault;

  FMaxClipboardDataSizeMb := cMaxClipboardDataSizeMb;

  FHexOffsetLen := 8;
  FLockCount := 0;

  FOnSelectionChange := nil;
  {$ifdef NOTIF}
  FOnFileReload := nil;
  {$endif}

  FFileName:= '';
  FStream:= nil;
  InitData;
  //Init objects

  {$ifdef SEARCH}
  FSearch := TATStreamSearch.Create(Self);
  {$endif}

  FFontOEM := TFont.Create;
  with FFontOEM do
  begin
    Name := 'Terminal';
    Size := 9;
    Color := clWindowText;
    CharSet := OEM_CHARSET;
  end;

  FBitmap := TBitmap.Create;
  with FBitmap do
  begin
    Width := Self.Width;
    Height := Self.Height;
  end;

  FTimer := TTimer.Create(Self);
  with FTimer do
  begin
    Enabled := False;
    Interval := cMScrollTime;
    OnTimer := TimerTimer;
  end;

  FStrings := TStrPositions.Create;

  //Init popup menu
  FMenuItemCopy:= TMenuItem.Create(Self);
  with FMenuItemCopy do
  begin
    Enabled := False;
    Visible := vpcmdCopy in FPopupCommands;
    Caption := 'Copy';
    OnClick := MenuItemCopyClick;
  end;

  FMenuItemCopyHex:= TMenuItem.Create(Self);
  with FMenuItemCopyHex do
  begin
    Enabled := False;
    Visible := vpcmdCopyHex in FPopupCommands;
    Caption := 'Copy as hex';
    OnClick := MenuItemCopyHexClick;
  end;

  FMenuItemSelectLine:= TMenuItem.Create(Self);
  with FMenuItemSelectLine do
  begin
    Enabled := False;
    Visible := vpcmdSelectLine in FPopupCommands;
    Caption := 'Select line';
    OnClick := MenuItemSelectLineClick;
  end;

  FMenuItemSelectAll:= TMenuItem.Create(Self);
  with FMenuItemSelectAll do
  begin
    Enabled := False;
    Visible := vpcmdSelectAll in FPopupCommands;
    Caption := 'Select all';
    OnClick := MenuItemSelectAllClick;
  end;

  FMenuItemSep:= TMenuItem.Create(Self);
  with FMenuItemSep do
    begin
    Caption:= '-';
    end;

  FMenu:= TPopupMenu.Create(Self);
  with FMenu do
  begin
    Items.Add(FMenuItemCopy);
    Items.Add(FMenuItemCopyHex);
    Items.Add(FMenuItemSep);
    Items.Add(FMenuItemSelectLine);
    Items.Add(FMenuItemSelectAll);
  end;

  PopupMenu := FMenu;

  //Init notification object
  {$ifdef NOTIF}
  FNotif:= TATFileNotification.Create(Self);
  with FNotif do
    begin
    Options:= [foNotifyFilename, foNotifyLastWrite, foNotifySize];
    OnChanged:= NotifChanged;
    end;
  {$endif}

  //Init event handlers
  OnMouseWheelUp:= MouseWheelUp;
  OnMouseWheelDown:= MouseWheelDown;
  OnContextPopup:= ContextPopup;

  //Init debug form
  {$ifdef DEBUG_FORM}
  InitDebugForm;
  {$endif}
end;

destructor TATBinHex.Destroy;
begin
  {$ifdef DEBUG_FORM}
  FreeDebugForm;
  {$endif}

  FreeData;
  FStrings.Free;
  FBitmap.Free;
  FFontOEM.Free;

  inherited Destroy;
end;

function TATBinHex.GetAnsiDecode: boolean;
begin
  Result := FMode = vbmodeText;
end;

procedure TATBinHex.RedrawEmpty;
begin
  with FBitmap do
  begin
    Width := Self.ClientWidth;
    Height := Self.ClientHeight;
    
    Canvas.Brush.Color := Self.Color;
    Canvas.FillRect(Rect(0, 0, Width, Height));
  end;
end;

procedure TATBinHex.Redraw(DoPaintBitmap: Boolean = True);
var
  Dx: TStringExtent; //TStringExtent is huge, so
                     //this isn't SelectLine local

  procedure SelectLine(const ALine: WideString; AX, AY: integer; const AFilePos: Int64; ASelectAll: boolean = false);
  var
    Len, YHeight: integer;
    nStart, nEnd: Int64;
  begin
    if ASelectAll then
      Len := 1
    else
      Len := Length(ALine);

    if (FSelStart > AFilePos + (Len - 1) * CharSize) or
      (FSelStart + FSelLength - 1 * CharSize < AFilePos) then Exit;

    if (AX >= FBitmap.Width) or (AY >= FBitmap.Height) then Exit;

    YHeight:= FontHeight(FBitmap.Canvas);

    if StringExtent(FBitmap.Canvas, ALine, Dx, FTabSize, GetAnsiDecode) then
    begin
      if ASelectAll then
        InvertRect(FBitmap.Canvas, Rect(AX, AY, AX + Dx[Length(ALine)], AY + YHeight))
      else
      begin
        nStart := (FSelStart - AFilePos) div CharSize;
        I64LimitMin(nStart, 0);

        nEnd := (FSelStart + FSelLength - AFilePos) div CharSize;
        I64LimitMax(nEnd, Length(ALine));

        InvertRect(FBitmap.Canvas, Rect(AX + Dx[nStart], AY, AX + Dx[nEnd], AY + YHeight))
      end;
    end;
  end;

var
  Strings: TStrPositions;
  X, Y, Y2, CellWidth: integer;
  Pos, PosEnd, PageSize: Int64;
  LineA: AnsiString;
  LineW, LineText: WideString;
  PosTextX, PosTextY: integer;
  i, j: integer;
  ch: char;
  //DebugX, DebugY: integer;
begin
  {$ifdef DEBUG_ATBINHEX}
  Logger.EnterMethod(Self,'Redraw');
  {$endif}
  try
    Lock;

  //If file is empty, clear and quit
  if FileIsEmpty then
  begin
    HideScrollBar(false);
    HideScrollBar(true);
    RedrawEmpty;
    if DoPaintBitmap then
      Paint;
    {$ifdef DEBUG_ATBINHEX}
    Logger.ExitMethod(Self,'Redraw');
    {$endif}
    Exit;
  end;

  //Do drawing
  RedrawEmpty;

  Assert(
    (FBufferPos >= 0) and (FBufferPos <= PosLast) and
    (FViewPos >= FBufferPos) and (FViewPos <= FBufferPos + 2 * FBufferMaxOffset),
    Format('Positions out of range: Redraw'#13#13'BufferPos: %d'#13'ViewPos: %d', [FBufferPos, FViewPos]));

  Strings:= TStrPositions(FStrings);
  Strings.Clear(CharSize);

  with FBitmap do
  begin
    Canvas.Font := ActiveFont;

    if FTextWidthFit then SetTextWidth(ColsNumFit);
    if FTextWidthFitHex then SetTextWidthHex(ColsNumHexFit);

    CellWidth := FontWidthDigits(Canvas);
    PageSize := LinesNum * ColsNum;

    if FFileOK then
    case FMode of
      vbmodeText,
      vbmodeUnicode:
        begin
          if FMode = vbmodeUnicode then
            DetectUnicodeFmt;

          Pos := FViewPos;
          for i := 1 to IMin(LinesNum + 1, cMaxLines) do
          begin
            //Find line
            PosEnd := FindLinePos(Pos, vdirDown, LineW);

            if FTextWrap then
              SDelLastSpaceW(LineW);

            //Draw
            LineText := LineW;
            PosTextX := cPositionX0;
            PosTextY := cPositionY0 + (i - 1) * FontHeight(Canvas);
            StringOut(Canvas, PosTextX - FHViewPos, PosTextY, LineText, FTabSize, GetAnsiDecode);
            //Selecting text under gtk is crash prone
            {$ifdef EnableSelection}
            SelectLine(LineText, PosTextX - FHViewPos, PosTextY, Pos);
            {$endif}
            Strings.Add(LineText, PosTextX - FHViewPos, PosTextY, Pos);

            //Move to next line
            Pos := PosEnd;

            //Calculate page size: it's last position minus previous position
            if i <= LinesNum then
            begin
              if FScrollPageSize then
              begin
                if Pos >= 0 then
                  PageSize := Pos - FViewPos
                else
                  PageSize := FFileSize - FViewPos;
              end;
              FViewAtEnd := Pos < 0;
            end;

            if Pos < 0 then Break;
          end;
        end;

      vbmodeHex:
        begin
          for i := 1 to IMin(LinesNum + 1, cMaxLines) do
          begin
            Pos := FViewPos - FBufferPos + (i - 1) * FTextWidthHex;
            if FBufferPos + Pos >= FFileSize then Break;

            Y := cPositionY0 + (i - 1) * FontHeight(Canvas);
            Y2 := Y + FontHeight(Canvas);

            //Draw offset
            X := cPositionX0;
            LineA := IntToHex(FBufferPos + Pos, FHexOffsetLen) + cHexOffsetSep;
            Canvas.Font.Color := ActiveFont.Color;
            StringOut(Canvas, X - FHViewPos, Y, LineA, FTabSize, GetAnsiDecode);

            //Draw hex background
            Inc(X, (Length(LineA) + 1{space}) * CellWidth);

            Canvas.Brush.Color := FTextColorHexBack;
            Canvas.FillRect(Rect(
              X - FHViewPos,
              Y,
              X - FHViewPos + CellWidth * (FTextWidthHex * 3 + 2),
              Y2 + (cHexLinesWidth div 2)));

            //Draw hex digits
            Inc(X, CellWidth);

            for j := 0 to FTextWidthHex - 1 do
              if FBufferPos + Pos + j < FFileSize then
              begin
                if (j mod 4) < 2 then
                  Canvas.Font.Color := FTextColorHex
                else
                  Canvas.Font.Color := FTextColorHex2;

                LineA := IntToHex(Ord(FBuffer[Pos + j]), 2);

                LineW := LineA;
                StringOut(Canvas, X - FHViewPos, Y, LineW, FTabSize, GetAnsiDecode);
                {$ifdef EnableSelection}
                SelectLine(LineW, X - FHViewPos, Y, FBufferPos + Pos + j, True);
                {$endif}
                Inc(X, 3 * CellWidth);
                if j = (FTextWidthHex div 2 - 1) then
                  Inc(X, CellWidth); //Space
              end;

            //Restore text background
            Canvas.Brush.Color := Self.Color;

            //Draw text
            X := cPositionX0 + (FHexOffsetLen + Length(cHexOffsetSep) + 4{4 spaces} + FTextWidthHex * 3) * CellWidth;
            Canvas.Font.Color := ActiveFont.Color;
            LineA := '';

            for j := 0 to FTextWidthHex - 1 do
              if FBufferPos + Pos + j < FFileSize then
              begin
                ch := FBuffer[Pos + j];
                if Ord(ch) < $20 then
                  ch := cSpecialChar;
                LineA := LineA + ch;
              end;

            LineText := LineA;
            PosTextX := X;
            PosTextY := Y;
            StringOut(Canvas, PosTextX - FHViewPos, PosTextY, LineText, FTabSize, GetAnsiDecode);
            {$ifdef EnableSelection}
            SelectLine(LineText, PosTextX - FHViewPos, PosTextY, FBufferPos + Pos);
            {$endif}
            Strings.Add(LineText, PosTextX - FHViewPos, PosTextY, FBufferPos + Pos);

            //Draw lines
            if cHexLinesShow then
            begin
              Canvas.Pen.Color := FTextColorLines;
              Canvas.Pen.Width := cHexLinesWidth;

              X := cPositionX0 + (FHexOffsetLen + Length(cHexOffsetSep) + 1{1 space}) * CellWidth;
              Canvas.MoveTo(X - FHViewPos, Y);
              Canvas.LineTo(X - FHViewPos, Y2);

              X := cPositionX0 + (FHexOffsetLen + Length(cHexOffsetSep) + 2{2 spaces} + (FTextWidthHex div 2) * 3) * CellWidth;
              Canvas.MoveTo(X - FHViewPos, Y);
              Canvas.LineTo(X - FHViewPos, Y2);

              X := cPositionX0 + (FHexOffsetLen + Length(cHexOffsetSep) + 3{3 spaces} + FTextWidthHex * 3) * CellWidth;
              Canvas.MoveTo(X - FHViewPos, Y);
              Canvas.LineTo(X - FHViewPos, Y2);
            end;
          end;

          FViewAtEnd := FViewPos >= (FFileSize - LinesNum * ColsNum);
        end;

      vbmodeBinary:
        begin
          for i := 1 to IMin(LinesNum + 1, cMaxLines) do
          begin
            Pos := FViewPos - FBufferPos + (i - 1) * FTextWidth;
            if FBufferPos + Pos >= FFileSize then Break;

            LineA := '';
            for j := 0 to FTextWidth - 1 do
            begin
              PosEnd := Pos + j;
              if PosEnd >= FFileSize - FBufferPos then Break;
              ch := FBuffer[PosEnd];
              if Ord(ch) < $20 then
                ch := cSpecialChar;
              LineA := LineA + ch;
            end;

            LineText := LineA;
            PosTextX := cPositionX0;
            PosTextY := cPositionY0 + (i - 1) * FontHeight(Canvas);
            StringOut(Canvas, PosTextX - FHViewPos, PosTextY, LineText, FTabSize, GetAnsiDecode);
            {$ifdef EnableSelection}
            SelectLine(LineText, PosTextX - FHViewPos, PosTextY, FBufferPos + Pos);
            {$endif}
            Strings.Add(LineText, PosTextX - FHViewPos, PosTextY, FBufferPos + Pos);
          end;

          FViewAtEnd := FViewPos >= (FFileSize - LinesNum * ColsNum);
        end;

    end //if FFileOK then case FMode of ...
    else
    //Handle read error
    begin
      LineA := Format(MsgViewerErrCannotReadPos, [IntToHex(FViewPos, FHexOffsetLen)]);
      X := (Width - StringWidth(Canvas, LineA, FTabSize, False)) div 2;
      Y := (Height - FontHeight(Canvas)) div 2;
      ILimitMin(X, cPositionX0);
      ILimitMin(Y, cPositionY0);
      Canvas.Font.Color := FTextColorError;
      StringOut(Canvas, X, Y, LineA, FTabSize, false);
    end;
  end; //with FBitmap do ...

  //Debugging
  {$ifdef DEBUG_FORM}
  {
  if AtTheEnd
    then MsgDebug('At the end', '')
    else MsgDebug('In the middle', '');
    }
  {$endif}

  //Debug for TStrPositions.GetCoordFromPos:
  {
  if TStrPositions(FStrings).GetCoordFromPos(
    FBitmap.Canvas, 60, FTabSize, GetAnsiDecode, DebugX, DebugY) then
    begin
    FBitmap.Canvas.Pen.Color:= clRed;
    FBitmap.Canvas.MoveTo(DebugX, DebugY);
    FBitmap.Canvas.LineTo(DebugX, DebugY+20);
    end;
    }
  //End of debugging

  //Update scrollbars and force paint
  SetVScrollBar(PageSize);
  SetHScrollBar;
  if DoPaintBitmap then
    Paint;

  finally
    Unlock;
  end;
  {$ifdef DEBUG_ATBINHEX}
  Logger.ExitMethod(Self,'Redraw');
  {$endif}
end;

procedure TATBinHex.HideScrollBar(AHorz: boolean);
const
  ScrollTypes: array[Boolean] of Integer = (SB_VERT, SB_HORZ);
var
  si: TScrollInfo;
begin
  FillChar(si, SizeOf(si), 0);
  si.cbSize := SizeOf(si);
  si.fMask := SIF_ALL;
  {
  if (AHorz and FScrollHorzVisible) or
     ((not AHorz) and FScrollVertVisible) then
    si.fMask := si.fMask or SIF_DISABLENOSCROLL;
    }
  //not necessary. FillChar already set all fields to 0
  {si.nMin := 0;
  si.nMax := 0;
  si.nPage := 0;
  si.nPos := 0;
  }
  SetScrollInfo(Handle, ScrollTypes[AHorz], si, True);
end;

procedure TATBinHex.SetVScrollBar(APageSize: integer);
var
  Cols, Max, Pos, Page: Int64;
  si: TScrollInfo;
begin
  Cols := ColsNum;

  if FFileOK and (FFileSize > Cols) then
  begin
    Max := FFileSize div Cols;
    I64LimitMax(Max, MAXSHORT);

    Pos := Max * FViewPos div FFileSize;
    I64LimitMax(Pos, Max);

    Page := Max * APageSize div FFileSize;
    I64LimitMin(Page, 1);
    if Page >= Max then
      Page := Max + 1;
    I64LimitMax(Page, MAXSHORT);
  end
  else
  begin
    Max := 0;
    Pos := 0;
    Page := 0;
  end;

  FillChar(si, SizeOf(si), 0);
  si.cbSize := SizeOf(si);
  si.fMask := SIF_ALL;
  //si.nMin := 0;
  si.nMax := Max;
  si.nPage := Page;
  si.nPos := Pos;

  SetScrollInfo(Handle, SB_VERT, si, true);
end;

procedure TATBinHex.SetHScrollBar;
var
  Max, Page, Pos: integer;
  si: TScrollInfo;
begin
  if                 //Hide horizontal scrollbar if the following cases:
    (not FFileOK) or // - read error occurs
    (FileIsEmpty) or // - File is empty
    ((FMode in [vbmodeText, vbmodeUnicode]) and FTextWrap) or
                     // - Text/Unicode modes when TextWrap is on
    ((FMode = vbmodeBinary) and FTextWidthFit and FontMonospaced(FBitmap.Canvas))
                     // - Binary mode when TextWidthFit is on and font is monospaced
  then
  begin
    Max := 0;
    Page := 0;
    Pos := 0;
  end
  else
  begin
    {$ifdef HSCROLLBAR_WORKAROUND}
    //Remember max width, so horizontal scrollbar won't appear/disappear:
    ILimitMin(FHViewWidth, IMax(HPosWidth, FHViewPos + ClientWidth));
    {$else}
    FHViewWidth := IMax(HPosWidth, FHViewPos + ClientWidth);
    {$endif}
    Max := FHViewWidth;
    Page := ClientWidth + 1;
    Pos := FHViewPos;
  end;

  FillChar(si, SizeOf(si), 0);
  si.cbSize := SizeOf(si);
  si.fMask := SIF_ALL;
  //si.nMin := 0;
  si.nMax := Max;
  si.nPage := Page;
  si.nPos := Pos;

  SetScrollInfo(Handle, SB_HORZ, si, true);
end;

procedure TATBinHex.Paint;
begin
  {$ifdef DEBUG_ATBINHEX}
  Logger.EnterMethod(Self,'Paint');
  {$endif}
  Canvas.Draw(0, 0, FBitmap);
  {$ifdef DEBUG_ATBINHEX}
  Logger.ExitMethod(Self,'Paint');
  {$endif}
end;

procedure TATBinHex.SelectLineAtPos(const APos: Int64; AWordOnly: boolean);

  function PosBefore(const APos: Int64; ADir: TATDirection): Int64;
  const
    Separators: array[boolean] of WideString =
      (#13#10, ' !"#$%&''()*+,-./:;<=>?@[\]^`{|}~'#13#10#9);
  var
    PosTemp: Int64;
    i: integer;
  begin
    Result:= APos;
    NormalizePos(Result);
    PosTemp := Result;
    for i := 1 to FMaxLength do
    begin
      NextPos(PosTemp, ADir);
      if (PosBad(PosTemp)) or (Pos(GetChar(PosTemp), Separators[AWordOnly]) > 0) then Break;
      Result:= PosTemp;
    end;
  end;

var
  APosStart, APosEnd: Int64;
begin
  APosStart := PosBefore(APos, vdirUp);
  APosEnd := PosBefore(APos, vdirDown);
  SetSelection(APosStart, APosEnd - APosStart + CharSize, False);
end;

procedure TATBinHex.DblClick;
begin
  if FMouseStartDbl < 0 then Exit;

  FMouseDblClick := True;
  FMouseTriClick := False;
  FMouseTriTime := 0;

  if cSelectionByDoubleClick then
    SelectLineAtPos(FMouseStartDbl, true);
end;

procedure TATBinHex.DoOnResize;
begin
  {$ifdef DEBUG_ATBINHEX}
  Logger.EnterMethod(Self,'DoOnResize');
  {$endif}
  //there's a problem redrawing in Resize under LCL
  inherited;
  if HandleAllocated then
    Redraw(False);
  {$ifdef DEBUG_ATBINHEX}
  Logger.ExitMethod(Self,'DoOnResize');
  {$endif}
end;

procedure TATBinHex.ContextPopup(Sender: TObject; MousePos: TPoint; var Handled: boolean);
begin
  FMousePopupPos:= MousePos;
end;

function TATBinHex.SourceAssigned: boolean;
begin
  case FFileSourceType of
    vfsrcFile:
      Result := (FFileName <> '') and (FFileHandle <> INVALID_HANDLE_VALUE);
    vfsrcStream:
      Result := Assigned(FStream);
    else
      Result := False;
  end;
end;

function TATBinHex.ReadSource(const APos: Int64; ABuffer: pointer; ABufferSize: DWORD; var AReadSize: DWORD): boolean;
begin
  Result:= false;

  Assert(
    Assigned(ABuffer),
    'Buffer not allocated: ReadSource');
  FillChar(ABuffer^, ABufferSize, 0);

  Assert(
    FFileSourceType<>vfsrcUnassigned,
    'File source not assigned: ReadSource');

  case FFileSourceType of
    //Read from file
    vfsrcFile:
      begin
      Assert(
        FFileHandle<>INVALID_HANDLE_VALUE,
        'File handle not open: ReadSource');

      FileSeek(FFileHandle,APos,fsFromBeginning);
      AReadSize:=FileRead(FFileHandle, ABuffer^,ABufferSize);
      Result:=AReadSize <> -1;
      end;

    //Read from stream
    vfsrcStream:
      begin
      Assert(
        Assigned(FStream),
        'File stream not assigned: ReadSource');

      try
        FStream.Seek(APos, soFromBeginning);
        AReadSize:= FStream.Read(ABuffer^, ABufferSize);
        Result:= true;
      except
      end;
      end;
  end;
end;

procedure TATBinHex.MsgReadError;
begin
  case FFileSourceType of
    vfsrcFile:
      MsgError(SFormatW(MsgViewerErrCannotReadFile, [FFileName]));
    vfsrcStream:
      MsgError(MsgViewerErrCannotReadStream);
  end;
end;

procedure TATBinHex.MsgOpenError;
begin
  MsgError(SFormatW(MsgViewerErrCannotOpenFile, [FFileName]));
end;

procedure TATBinHex.ReadBuffer;
var
  BytesRead: DWORD;
begin
  if SourceAssigned then
  begin
    FFileOK := ReadSource(FBufferPos, FBuffer, FBufferAllocSize, BytesRead);
    if not FFileOK then
      MsgReadError;
  end;
end;

function TATBinHex.Open(const AFileName: WideString; ARedraw: boolean = true): boolean;
begin
  Result := True;
  if FFileName <> AFileName then
  begin
    FFileName := AFileName;
    Result := LoadFile(True);
    UpdateMenu;
    if ARedraw then
      Redraw;
  end;
end;

function TATBinHex.OpenStream(AStream: TStream; ARedraw: boolean = true): boolean;
begin
  Result := True;
  if FStream <> AStream then
  begin
    FStream := AStream;
    Result := LoadStream;
    UpdateMenu;
    if ARedraw then
      Redraw;
  end;
end;

function TATBinHex.LinesNum: integer;
begin
  Result:= (ClientHeight-4) div FontHeight(FBitmap.Canvas);
  ILimitMin(Result, 0);
  ILimitMax(Result, cMaxLines);
end;

function TATBinHex.ColsNumFit: integer;
begin
  Result:= (ClientWidth-4) div FontWidthDigits(FBitmap.Canvas);
  ILimitMin(Result, cMinLength);
  ILimitMax(Result, FMaxLength);
end;

function TATBinHex.ColsNumHexFit: integer;
begin
  Result := (ColsNumFit - (FHexOffsetLen + Length(cHexOffsetSep) + 4{4 spaces})) div 4;
  ILimitMin(Result, cMinLength);
  ILimitMax(Result, FMaxLength);
end;

function TATBinHex.ColsNum: integer;
begin
  case FMode of
    vbmodeBinary:
      Result:= FTextWidth;
    vbmodeHex:
      Result:= FTextWidthHex;
    else
      Result := 10 * CharSize; //Stub
  end;
end;

function TATBinHex.PosBad(const APos: Int64): boolean;
begin
  Result := not (
    (APos >= 0) and
    (APos <= PosLast) and
    (APos - FBufferPos >= 0) and
    (APos - FBufferPos < FBufferAllocSize)
    );
end;

//Max position regarding page size.
//Used only in Binary/Hex modes.
function TATBinHex.PosMax: Int64;
var
  Cols: integer;
begin
  Cols := ColsNum;
  Result := FFileSize div Cols * Cols;
  if Result = FFileSize then
    Dec(Result, Cols);
  Dec(Result, (LinesNum - 1) * Cols);
  I64LimitMin(Result, 0);
end;

//Max position at the very end of file.
function TATBinHex.PosLast: Int64;
begin
  Result:= FFileSize;
  NormalizePos(Result);
  Dec(Result, CharSize);
  I64LimitMin(Result, 0);
end;

//Used (with one exception) only in Binary/Hex modes.
procedure TATBinHex.PosAt(const APos: Int64; ARedraw: boolean = true);
var
  Cols: integer;
begin
  if (APos <> FViewPos) and (APos >= 0) then
  begin
    FViewPos := APos;
    I64LimitMax(FViewPos, PosLast);

    Cols := ColsNum;
    FViewPos := FViewPos div Cols * Cols;

    if not ((FViewPos >= FBufferPos) and (FViewPos < FBufferPos + 2 * FBufferMaxOffset)) then
    begin
      FBufferPos := FViewPos - FBufferMaxOffset;
      I64LimitMin(FBufferPos, 0);
      ReadBuffer;
    end;

    if ARedraw then
      Redraw;
  end;
end;

//Used only in Binary/Hex modes.
procedure TATBinHex.PosDec(const n: Int64);
begin
  if FViewPos - N >= 0 then
    PosAt(FViewPos - N)
  else
    PosBegin;
end;

//Used only in Binary/Hex modes.
procedure TATBinHex.PosInc(const n: Int64);
begin
  if FViewPos < PosMax then
    PosAt(FViewPos + N);
end;

procedure TATBinHex.PosLineUp(N: Integer = 1);
begin
  case FMode of
    vbmodeText,
    vbmodeUnicode:
      PosNextLine(n, vdirUp)
    else
      PosDec(N * ColsNum);
  end;
end;

procedure TATBinHex.PosLineDown(N: Integer = 1);
begin
  case FMode of
    vbmodeText,
    vbmodeUnicode:
      PosNextLine(n, vdirDown)
    else
      PosInc(n*ColsNum);
  end;
end;

procedure TATBinHex.PosPageUp;
begin
  PosLineUp(LinesNum);
end;

procedure TATBinHex.PosPageDown;
begin
  PosLineDown(LinesNum);
end;

procedure TATBinHex.PosBegin(ARedraw: boolean = true);
begin
  HPosAt(0, false);
  PosAt(0, ARedraw);
end;

procedure TATBinHex.PosEnd(ARedraw: boolean = true);
begin
  HPosAt(0, false);
  case FMode of
    vbmodeText,
    vbmodeUnicode:
      PosNextLineFrom(FFileSize, LinesNum, vdirUp, ARedraw)
    else
      PosAt(PosMax, ARedraw);
  end;
end;

function TATBinHex.GetPosPercent: Integer;
begin
  if FileIsEmpty then
    Result := 0
  else
    Result := FViewPos * 100 div FFileSize;
end;

procedure TATBinHex.SetPosPercent(APos: Integer);
begin
  if APos <= 0 then PosBegin else
    if APos >= 100 then PosEnd else
      SetPosOffset(FFileSize * APos div 100);
end;

function TATBinHex.GetPosOffset: Int64;
begin
  Result := FViewPos;
end;

procedure TATBinHex.SetPosOffset(const APos: Int64; ARedraw: boolean = true);
begin
  if APos <= 0 then PosBegin(ARedraw) else
    if APos > PosLast then PosEnd(ARedraw) else
      case FMode of
        vbmodeText,
        vbmodeUnicode:
          PosNextLineFrom(APos, 1, vdirUp, ARedraw);
        else
          PosAt(APos, ARedraw);
      end;
end;

procedure TATBinHex.SetPosOffset_(const APos: Int64);
begin
  SetPosOffset(APos);
end;


procedure TATBinHex.InitData;
begin
  FFileHandle := INVALID_HANDLE_VALUE;
  FFileSize := 0;
  FFileOK := True;
  FFileUnicodeFmt := vbUnicodeFmtUnknown;
  FFileSourceType := vfsrcUnassigned;

  FBuffer := nil;
  FBufferMaxOffset := 0;
  FBufferAllocSize := 0;
  FBufferPos := 0;
  FViewPos := 0;
  FViewAtEnd := False;
  FHViewPos := 0;
  FHViewWidth := 0;
  FSelStart := 0;
  FSelLength := 0;
  FMouseDown := False;
  FMouseStart := -1;
  FMouseStartShift := -1;
  FMouseStartDbl := -1;
  FMouseDblClick := False;
  FMouseTriClick := False;
  FMouseTriTime := 0;
  FMousePopupPos := Point(-1, -1);
  FMouseScrollUp := False;
end;

procedure TATBinHex.FreeData;
begin
  if FFileHandle<>INVALID_HANDLE_VALUE then
    begin
    FileClose(FFileHandle);
    FFileHandle:= INVALID_HANDLE_VALUE;
    end;
  if Assigned(FBuffer) then
    begin
    FreeMem(FBuffer);
    FBuffer:= nil;
    FBufferMaxOffset:= 0;
    FBufferAllocSize:= 0;
    end;
  InitData;

  FTimer.Enabled := False;
end;

function TATBinHex.LoadFile(ANewFile: boolean): boolean;
var
  OldViewPos: Int64;
  OldViewHPos: integer;
  OldAtEnd: boolean;
begin
  Result := False;

  {$ifdef NOTIF}
  if ANewFile or (not FAutoReload) then
    FNotif.Stop;
  {$endif}

  OldViewPos:= FViewPos;
  OldViewHPos:= FHViewPos;
  OldAtEnd:= FViewAtEnd;

  FreeData;

  if FFileName = '' then
  begin
    Result := True;
    Exit
  end;

  FFileHandle:= FFileOpen(FFileName);
  if FFileHandle=INVALID_HANDLE_VALUE then
    begin
    MsgOpenError;
    Exit
    end;

  FFileSize:= FGetFileSize(FFileHandle);
  if FFileSize<0 then
    begin
    FileClose(FFileHandle);
    FFileHandle:= INVALID_HANDLE_VALUE;
    FFileSize:= 0;
    Exit
    end;

  FFileSourceType:= vfsrcFile;

  AllocBuffer;
  ReadBuffer;
  InitHexOffsetLen;

  //Restore last position
  if not ANewFile then
    SetPosOffset(OldViewPos, false);

  {$ifdef NOTIF}
  if FAutoReload then
  begin
    //Restore last position
    if not ANewFile then
    begin
      if FAutoReloadFollowTail and OldAtEnd then
      begin
        PosEnd(false);
        //Sometimes PosEnd goes not to the end of file - need to fix this.
        //Workaround:
        if not FViewAtEnd then
          PosEnd(False);
      end
      else
        SetPosOffset(OldViewPos, false);
    end;

    //Start watching
    if ANewFile then
    begin
      FNotif.FileName := FFileName;
      FNotif.Start;
    end;
  end;
  {$endif}

  //Restore last horizontal position (need to redraw)
  if not ANewFile then
  begin
    Redraw;
    HPosAt(OldViewHPos, false);
    //debug
    //MsgInfo(Format('Old HPos: %d, New HPos: %d', [OldViewHPos, FHViewPos]));
  end;

  Result:= true;
end;

function TATBinHex.LoadStream: boolean;
begin
  Result := True;

  {$ifdef NOTIF}
  FNotif.Stop;
  {$endif}

  FreeData;
  if not Assigned(FStream) then Exit;
    
  FFileSize:= FStream.Size;

  FFileSourceType:= vfsrcStream;

  AllocBuffer;
  ReadBuffer;
  InitHexOffsetLen;
end;

procedure TATBinHex.InitHexOffsetLen;
var
  Size: Extended;
begin
  if FileIsEmpty then
    FHexOffsetLen := 0
  else
  begin
    Size := FFileSize;
    FHexOffsetLen := Trunc(Ln(Size) / Ln(16)) + 1
  end;

  if FHexOffsetLen < 8 then
    FHexOffsetLen := 8;

  if (FHexOffsetLen mod 2) > 0 then
    Inc(FHexOffsetLen);
end;

procedure TATBinHex.SetMode(AMode: TATBinHexMode);
begin
  //No check for FMode <> AMode so file can be reloaded
  //by setting the same mode
  FMode := AMode;

  case FFileSourceType of
    vfsrcFile:
      LoadFile(false);
    vfsrcStream:
      LoadStream;
  end;

  UpdateMenu;
  if SourceAssigned then
    Redraw;
end;

procedure TATBinHex.SetEncoding(AEncoding: TATEncoding);
begin
  if AEncoding <> FEncoding then
  begin
    FEncoding := AEncoding;
    Redraw;
  end;
end;

procedure TATBinHex.SetTextWidth(AWidth: Integer);
begin
  //No check AWidth <> FTextWidth so method can be called to correct current value
  FTextWidth := AWidth;
  ILimitMin(FTextWidth, cMinLength);
  ILimitMax(FTextWidth, FMaxLengths[vbmodeBinary]);
end;

procedure TATBinHex.SetTextWidthHex(AWidth: Integer);
begin
  //No check AWidth <> FTextWidthHex so method can be called to correct current value
  FTextWidthHex := AWidth;
  ILimitMin(FTextWidthHex, cMinLength);
  ILimitMax(FTextWidthHex, FMaxLengths[vbmodeHex]);
  FTextWidthHex := FTextWidthHex div 4 * 4;
  ILimitMin(FTextWidthHex, cMinLength);
end;

procedure TATBinHex.SetTextWidthFit(AFit: boolean);
begin
  FTextWidthFit := AFit;
end;

procedure TATBinHex.SetTextWidthFitHex(AFit: boolean);
begin
  if AFit <> FTextWidthFitHex then
  begin
    FTextWidthFitHex := AFit;
    if not FTextWidthFitHex then
      FTextWidthHex := 16;
  end;
end;

procedure TATBinHex.SetTextWrap(AWrap: boolean);
begin
  if AWrap <> FTextWrap then
  begin
    FTextWrap := AWrap;
    if FTextWrap then
      HPosAt(0, false);
    Redraw;
  end;
end;

procedure TATBinHex.SetSearchIndentVert(AIndent: Integer);
begin
  FSearchIndentVert := AIndent;
  ILimitMin(FSearchIndentVert, 0);
  ILimitMax(FSearchIndentVert, cMaxSearchIndent);
end;

procedure TATBinHex.SetSearchIndentHorz(AIndent: Integer);
begin
  FSearchIndentHorz := AIndent;
  ILimitMin(FSearchIndentHorz, 0);
  ILimitMax(FSearchIndentHorz, cMaxSearchIndent);
end;

procedure TATBinHex.SetFontOEM(AFont: TFont);
begin
  FFontOEM.Assign(AFont);
end;

procedure TATBinHex.WMGetDlgCode(var Message: TMessage);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TATBinHex.WMEraseBkgnd(var Message: TMessage);
begin
  Message.Result := 1;
end;

procedure TATBinHex.WMVScroll(var Message: TWMVScroll);
var
  Max: Int64;
  Cols: integer;
begin
  case Message.ScrollCode of
    SB_TOP:
      PosBegin;
    SB_BOTTOM:
      PosEnd;
    //SB_ENDSCROLL:
    SB_LINEUP:
      PosLineUp;
    SB_LINEDOWN:
      PosLineDown;
    SB_PAGEUP:
      PosPageUp;
    SB_PAGEDOWN:
      PosPageDown;
    SB_THUMBPOSITION,
    SB_THUMBTRACK:
      begin
        Cols := ColsNum;
        Max := FFileSize div Cols;
        I64LimitMax(Max, MAXSHORT);
        SetPosOffset(FFileSize * Message.Pos div Max);
      end;
  end;
  Message.Result:= 0;
end;

procedure TATBinHex.WMHScroll(var Message: TWMHScroll);
begin
  case Message.ScrollCode of
    SB_TOP:
      HPosBegin;
    SB_BOTTOM:
      HPosEnd;
    SB_LINELEFT:
      HPosLeft;
    SB_LINERIGHT:
      HPosRight;
    SB_PAGELEFT:
      HPosPageLeft;
    SB_PAGERIGHT:
      HPosPageRight;
    SB_THUMBPOSITION,
    SB_THUMBTRACK:
      HPosAt(Message.Pos);
  end;
  Message.Result:= 0;
end;

procedure TATBinHex.KeyDown(var Key: Word; Shift: TShiftState);
begin
  //PgDn: page down
  if (Key = VK_NEXT) and (Shift = []) then
  begin
    PosPageDown;
    Key:= 0;
    Exit
  end;

  //PgUp: page up
  if (Key = VK_PRIOR) and (Shift = []) then
  begin
    PosPageUp;
    Key:= 0;
    Exit
  end;

  //Down: down one line
  if (Key = VK_DOWN) and (Shift = []) then
  begin
    PosLineDown;
    Key:= 0;
    Exit
  end;

  //Up: up one line
  if (Key = VK_UP) and (Shift = []) then
  begin
    PosLineUp;
    Key:= 0;
    Exit
  end;

  //Ctrl+Home: begin of file
  if (Key = VK_HOME) and (Shift = [ssCtrl]) then
  begin
    PosBegin;
    Key:= 0;
    Exit
  end;

  //Ctrl+End: end of file
  if (Key = VK_END) and (Shift = [ssCtrl]) then
  begin
    PosEnd;
    Key := 0;
    Exit
  end;

  //Left: ~200 px left
  if (Key = VK_LEFT) and (Shift = []) then
  begin
    HPosLeft;
    Key := 0;
    Exit
  end;

  //Right: ~200 px right
  if (Key = VK_RIGHT) and (Shift = []) then
  begin
    HPosRight;
    Key:= 0;
    Exit
  end;

  //Home: leftmost position
  if (Key = VK_HOME) and (Shift = []) then
  begin
    HPosBegin;
    Key:= 0;
    Exit
  end;

  //End: rightmost position
  if (Key = VK_END) and (Shift = []) then
  begin
    HPosEnd;
    Key:= 0;
    Exit
  end;

  //Ctrl+A: select all
  if (Key = Ord('A')) and (Shift = [ssCtrl]) then
  begin
    SelectAll;
    Key:= 0;
    Exit
  end;

  //Ctrl+C, Ctrl+Ins: copy to clipboard
  if ((Key = Ord('C')) or (Key = VK_INSERT)) and (Shift = [ssCtrl]) then
  begin
    CopyToClipboard;
    Key:= 0;
    Exit
  end;

  inherited KeyDown(Key, Shift);
end;

{$ifdef PRINT}
function TATBinHex.PrintCaption: string;
begin
  if FFileName <> '' then
    Result := MsgViewerCaption + ': ' + FFileName
  else
    Result := MsgViewerCaption;
end;
{$endif}

{$ifdef PRINT}
procedure TATBinHex.Print(ASelectionOnly: Boolean; ACopies: Word = 1; ACaption: string = '');
const
  BlockSize = 64 * 1024;
var
  Buffer: array[0..BlockSize-1] of char;
  PosStart, PosEnd: Int64;
  BytesRead: DWORD;
  SBuffer: string;
  LenAll, Len: Int64;
  Written: Integer;
begin
  if ACopies=0 then Inc(ACopies);
  Printer.Copies:= ACopies;
  
  //Printer.Canvas.Font:= Self.Font; //Not ActiveFont! We always use ANSI font here, because Windows
                                   //doesn't allow to print by OEM fonts in most cases
                                   //(it substitutes other font instead of given one).

  if ACaption <> '' then
    Printer.Title := ACaption
  else
    Printer.Title := PrintCaption;
  Printer.RawMode:= True;
  if ASelectionOnly then
  begin
    PosStart := FSelStart;
    PosEnd := FSelStart + FSelLength - 1;
  end
  else
    begin
    PosStart:= 0;
    PosEnd:= PosLast;
    end;

  try
    Printer.BeginDoc;
    try
      repeat
        if not ReadSource(PosStart, @Buffer, BlockSize, BytesRead) then
        begin
          MsgReadError;
          Exit
        end;

        LenAll := PosEnd - PosStart + 1;
        Len := LenAll;
        I64LimitMax(Len, BytesRead);
        SetString(SBuffer, Buffer, Len);

        //OEM decoding:
        if FEncoding=vencOEM then
          SBuffer:= ToANSI(SBuffer);

        Printer.Write(SBuffer[1],Length(SBuffer),Written);

        Inc(PosStart, BlockSize);
      until (BytesRead < BlockSize) or (LenAll <= BytesRead);
    finally
      Printer.EndDoc;
    end;
  except
  end;
end;
{$endif}

procedure TATBinHex.CopyToClipboard(AsHex: boolean = false);
var
  BufferA: AnsiString;
  BufferW: WideString;
begin
  try
    case FMode of
      vbmodeUnicode:
      begin
        BufferW := GetSelTextW;
        SReplaceZerosW(BufferW);
        SCopyToClipboardW(BufferW);
      end;
      else
      begin
        BufferA := GetSelText;
        if AsHex then
          BufferA := SToHex(BufferA)
        else
          SReplaceZeros(BufferA);
        SCopyToClipboard(BufferA, FEncoding = vencOEM);
      end;
    end;
  except
    MsgError(MsgViewerErrCannotCopyData);
  end;
end;

function TATBinHex.GetSelTextA: AnsiString;
var
  Buffer: AnsiString;
  BlockSize: Integer;
  BytesRead: DWORD;
begin
  Result:= '';

  if FSelLength > 0 then
  begin
    BlockSize := I64Min(FSelLength, FMaxClipboardDataSizeMb * 1024 * 1024);

    SetLength(Buffer, BlockSize);

    if not ReadSource(FSelStart, @Buffer[1], BlockSize, BytesRead) then
      begin
      MsgReadError;
      Exit;
      end;

    SetLength(Buffer, BytesRead);
    Result := Buffer;
  end;
end;

function TATBinHex.GetSelText: AnsiString;
begin
  Assert(FMode <> vbmodeUnicode, 'SelText is called in Unicode mode');

  Result := GetSelTextA;
end;

function TATBinHex.GetSelTextW: WideString;
var
  Buffer: AnsiString;
begin
  Assert(FMode = vbmodeUnicode, 'SelTextW is called in non-Unicode mode');

  Buffer := GetSelTextA;

  if Buffer = '' then
    Result := ''
  else
    Result := SetStringW(@Buffer[1], Length(Buffer), FFileUnicodeFmt = vbUnicodeFmtBE);
end;

procedure TATBinHex.SetSelection(const AStart, ALength: Int64;
  AScroll: boolean; AFireEvent: boolean = true);
var
  SelChanged: boolean;
begin
  if (AStart >= 0) and (AStart <= PosLast) and (ALength >= 0) then
  begin
    SelChanged := (AStart <> FSelStart) or (ALength <> FSelLength);

    if SelChanged then
    begin
      FSelStart := AStart;
      FSelLength := ALength;
      NormalizePos(FSelStart);
      NormalizePos(FSelLength);
      I64LimitMax(FSelLength, PosLast - FSelStart + CharSize);
      UpdateMenu;
    end;

    if AScroll then
      Scroll(AStart, FSearchIndentVert, FSearchIndentHorz, False);

    Redraw;

    if SelChanged then
      if AFireEvent then DoSelectionChange;
    end;
end;

procedure TATBinHex.Scroll(const APos: Int64; AIndentVert, AIndentHorz: Integer; ARedraw: Boolean = True);
var
  Pos: Int64;
  Cols, PosX, PosY: integer;
begin
  //Scroll vertically (redraw if needed)
  case FMode of
    vbmodeText,
    vbmodeUnicode:
      begin
      PosNextLineFrom(APos, AIndentVert + 1, vdirUp);
      end
    else
      begin
      Cols := ColsNum;
      Pos := APos div Cols * Cols;
      Dec(Pos, Cols * AIndentVert);
      I64LimitMin(Pos, 0);
      PosAt(Pos);
      end;
  end;

  //Scroll horizontally (redraw if needed and allowed)
  if TStrPositions(FStrings).GetCoordFromPos(
    FBitmap.Canvas, APos, FTabSize, GetAnsiDecode, PosX, PosY) then
  begin
    if not ((PosX >= 0) and (PosX < ClientWidth - cSelectionRightIndent)) then
      HPosAt(PosX + FHViewPos - AIndentHorz * FontWidthDigits(FBitmap.Canvas), ARedraw);
  end;
end;

procedure TATBinHex.SelectAll;
begin
  SetSelection(0, FFileSize, false);
end;

procedure TATBinHex.SelectNone(AFireEvent: boolean = true);
begin
  SetSelection(0, 0, false, AFireEvent);
end;

procedure TATBinHex.MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  PosLineUp(cMWheelLines);
  Handled := True;
end;

procedure TATBinHex.MouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  PosLineDown(cMWheelLines);
  Handled:= true;
end;

function TATBinHex.MousePosition(AX, AY: integer): Int64;
begin
  {$ifdef EnableSelection}
  Result := TStrPositions(FStrings).GetPosFromCoord(
    FBitmap.Canvas, AX, AY, FTabSize, GetAnsiDecode);
  {$else}
  Result := -1;
  {$endif}
end;

procedure TATBinHex.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  FMouseStartNew: Int64;
begin
  {$ifdef DEBUG_ATBINHEX}
  Logger.Send('MouseDown',Point(X,Y));
  {$endif}
  SetFocus;

  if Button = mbLeft then
  begin
    FMouseStartNew := MousePosition(X, Y);
    if Shift = [ssShift, ssLeft] then
    begin
      //Shift+click
      if cSelectionByShiftClick then
        SetSelection(
          I64Max(I64Min(FMouseStartNew, FMouseStartShift), 0),
          Abs(FMouseStartNew - FMouseStartShift),
          False);
    end
    else
    begin
      if FMouseTriClick and (GetTickCount - FMouseTriTime <= GetDoubleClickTime) then
      begin
        //Triple click
        FMouseDblClick := False;
        FMouseTriClick := False;
        FMouseTriTime := 0;
        if cSelectionByTripleClick then
          SelectLineAtPos(FMouseStartDbl, False);
      end
      else
      begin
        if FMouseDblClick then
        begin
          //Double click (already handled in DblClick)
          FMouseDblClick := False;
          FMouseTriClick := True;
          FMouseTriTime := GetTickCount;
        end
        else
        begin
          //Single click (not second click of double click!)
          SelectNone(False);
        end;
      end;

      FMouseDown := True;
      FMouseStart := FMouseStartNew;
      FMouseStartShift := FMouseStart;
      FMouseStartDbl := FMouseStart - CharSize;
      FMouseDblClick := False;
    end;
  end;
end;

procedure TATBinHex.MouseMoveAction(AX, AY: integer);
var
  APosStart, APosEnd: Int64;
begin
  {$ifdef DEBUG_ATBINHEX}
  Logger.EnterMethod('MouseMoveAction');
  Logger.Send('FMouseStart',FMouseStart);
  Logger.Send('Ax/Ay',Point(Ax,Ay));
  {$endif}
  APosStart:= FMouseStart;
  if APosStart<0 then Exit;
  APosEnd:= MousePosition(AX, AY);
  {$ifdef DEBUG_ATBINHEX}
  Logger.Send('APosEnd',FMouseStart);
  {$endif}
  if APosEnd<0 then Exit;
  if APosStart>APosEnd then
    SwapInt64(APosStart, APosEnd);
  SetSelection(APosStart, APosEnd-APosStart, false, false{Don't fire event});
  {$ifdef DEBUG_ATBINHEX}
  Logger.Send('APosStart',APosStart);
  Logger.Send('APosEnd',APosEnd);
  Logger.Send('FSelStart',FSelStart);
  Logger.Send('FSelLength',FSelLength);
  Logger.Exitmethod('MouseMoveAction');
  {$endif}
end;

procedure TATBinHex.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if FMouseDown then
  begin
    //If Y is out of control position, start FTimer which
    //will scroll control up or down every NNN msec
    if Y < 0 then
    begin
      FMouseScrollUp := True;
      FTimer.Enabled := True;
      Exit
    end;
    if Y > ClientHeight then
    begin
      FMouseScrollUp := False;
      FTimer.Enabled := True;
      Exit
    end;
    //Else stop timer and perform needed actions
    FTimer.Enabled := False;
    MouseMoveAction(X, Y);
  end
  else
    FTimer.Enabled := False;
end;

procedure TATBinHex.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    FMouseDown := False;
    FMouseStart := -1;
    FTimer.Enabled := False;
    DoSelectionChange;
  end;
end;

procedure TATBinHex.TimerTimer(Sender: TObject);
begin
  if FMouseScrollUp then
    begin
    PosLineUp(cMScrollLines);
    MouseMoveAction(0, -1);
    end
  else
    begin
    PosLineDown(cMScrollLines);
    MouseMoveAction(0, ClientHeight+1);
    end;
end;

procedure TATBinHex.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style:= Params.Style or WS_VSCROLL or WS_HSCROLL;
end;

procedure TATBinHex.MenuItemCopyClick(Sender: TObject);
begin
  CopyToClipboard;
end;

procedure TATBinHex.MenuItemCopyHexClick(Sender: TObject);
begin
  CopyToClipboard(true);
end;

procedure TATBinHex.MenuItemSelectAllClick(Sender: TObject);
begin
  SelectAll;
end;

procedure TATBinHex.MenuItemSelectLineClick(Sender: TObject);
var
  Pos: Int64;
begin
  with FMousePopupPos do
    if (X>=0) and (Y>=0) then
      begin
      Pos:= MousePosition(X, Y);
      if Pos>=0 then
        SelectLineAtPos(Pos, false);
      end;
end;

procedure TATBinHex.UpdateMenu;
var
  En: Boolean;
begin
  En := not FileIsEmpty;
  FMenuItemCopy.Enabled := En and (FSelLength > 0);
  FMenuItemCopyHex.Enabled := En and FMenuItemCopy.Enabled and (FMode = vbmodeHex);
  FMenuItemSelectLine.Enabled := En;
  FMenuItemSelectAll.Enabled := En and not ((FSelStart = 0) and (FSelLength >= NormalizedPos(FFileSize)));

  FMenuItemCopy.Visible := vpcmdCopy in FPopupCommands;
  FMenuItemCopyHex.Visible := vpcmdCopyHex in FPopupCommands;
  FMenuItemSelectLine.Visible := vpcmdSelectLine in FPopupCommands;
  FMenuItemSelectAll.Visible := vpcmdSelectAll in FPopupCommands;
end;

procedure TATBinHex.SetMsgCopy(const S: string);
begin
  FMenuItemCopy.Caption:= S;
end;

procedure TATBinHex.SetMsgCopyHex(const S: string);
begin
  FMenuItemCopyHex.Caption:= S;
end;

procedure TATBinHex.SetMsgSelectLine(const S: string);
begin
  FMenuItemSelectLine.Caption:= S;
end;

procedure TATBinHex.SetMsgSelectAll(const S: string);
begin
  FMenuItemSelectAll.Caption:= S;
end;

procedure TATBinHex.DetectUnicodeFmt;
var
  Buffer: Word; //2-byte Unicode signature
  BytesRead: DWORD;
begin
  if FFileUnicodeFmt = vbUnicodeFmtUnknown then
  begin
    FFileUnicodeFmt := vbUnicodeFmtLE;
    if SourceAssigned and (FFileSize >= 2) then
    begin
      if ReadSource(0, @Buffer, SizeOf(Buffer), BytesRead) and
        (BytesRead >= 2) and (Buffer = $FFFE) then
        FFileUnicodeFmt := vbUnicodeFmtBE;
    end;
  end;
end;

procedure TATBinHex.HPosAt(APos: integer; ARedraw: boolean = true);
begin
  ILimitMin(APos, 0);
  ILimitMax(APos, HPosMax);

  if APos <> FHViewPos then
  begin
    FHViewPos := APos;
    if ARedraw then
      Redraw;
  end;
end;

procedure TATBinHex.HPosInc(n: integer);
begin
  HPosAt(FHViewPos+n);
end;

procedure TATBinHex.HPosDec(n: integer);
begin
  HPosAt(FHViewPos-n);
end;

procedure TATBinHex.HPosBegin;
begin
  HPosAt(0);
end;

procedure TATBinHex.HPosEnd;
begin
  HPosAt(MaxInt);
end;

procedure TATBinHex.HPosLeft;
begin
  HPosDec(cArrowScrollSize);
end;

procedure TATBinHex.HPosRight;
begin
  HPosInc(cArrowScrollSize);
end;

procedure TATBinHex.HPosPageLeft;
begin
  HPosDec(ClientWidth);
end;

procedure TATBinHex.HPosPageRight;
begin
  HPosInc(ClientWidth);
end;

function TATBinHex.HPosWidth: integer;
begin
  Result := TStrPositions(FStrings).GetScreenWidth(
    FBitmap.Canvas, FTabSize, GetAnsiDecode) + FHViewPos;
end;

function TATBinHex.HPosMax: integer;
begin
  Result := HPosWidth - ClientWidth;
  ILimitMin(Result, 0);
end;

//Note: AStartPos may be equal to FFileSize (without -1).
function TATBinHex.FindLinePos(const AStartPos: Int64; ADir: TATDirection; var ALine: WideString): Int64;

  function PrevPos(const APos: Int64): Int64;
  begin
    Result := APos - CharSize;
  end;
  function IsCR(ch: WideChar): boolean;
  begin
    Result := (ch = #13) or (ch = #10);
  end;
var
  Len, i: integer;
  EOL: boolean;
begin
  if AStartPos<0 then
    begin Result:= -1; Exit end;

  Result:= AStartPos;
  Len:= FindLineLength(Result, ADir, ALine);

  if ADir = vdirUp then
  //If in the middle of line, then move to start of line and exit, else move up to CR
  begin
    if Len > 1 then
    begin
      NextPos(Result, ADir, Len - 1);
      if PosBad(Result) then begin Result := -1; Exit end;
      Exit; //No move beyond start of line
    end
    else
    //Move up
    begin
      if PosBad(PrevPos(Result)) then begin Result := -1; Exit end;
      NextPos(Result, ADir);
    end;
  end
  else
  //Move beyond of line to CR
  begin
    NextPos(Result, ADir, Len);
    if PosBad(Result) then begin Result := -1; Exit end;
  end;

  //Skip EOL
  EOL := False;

  case GetChar(Result) of
    #13:
      begin
        EOL := True;
        NextPos(Result, ADir);
        if PosBad(Result) then begin Result := -1; Exit end;
        if GetChar(Result) = #10 then NextPos(Result, ADir);
        if PosBad(Result) then begin Result := -1; Exit end;
      end;
    #10:
      begin
        EOL := True;
        NextPos(Result, ADir);
        if PosBad(Result) then begin Result := -1; Exit end;
        if GetChar(Result) = #13 then NextPos(Result, ADir);
        if PosBad(Result) then begin Result := -1; Exit end;
      end;
  end;

  //When moving up, we are at the END of previous line, so we need additional move
  if EOL and (ADir = vdirUp) then
  begin
    Len := FindLineLength(Result, ADir, ALine);

    if Len = 0 then
    begin
      NextPos(Result, vdirDown);
      if PosBad(Result) then Result := -1;
      Exit;
    end;

    for i := 1 to Len - 1 do
    begin
      if PosBad(PrevPos(Result)) then begin Result := -1; Exit end;
      if IsCR(GetChar(PrevPos(Result))) then Break;
      NextPos(Result, ADir);
    end;
  end;
end;

//Note: AStartPos may be equal to FFileSize (without -1).
function TATBinHex.FindLineLength(const AStartPos: Int64; ADir: TATDirection; var ALine: WideString): integer;
var
  MaxWidth, i: integer;
  Pos: Int64;
  Dx: TStringExtent;
  wch: WideChar;
begin
  if AStartPos < 0 then
    begin Result := 0; Exit end;

  Result := 0;
  Pos := AStartPos;
  NormalizePos(Pos);

  if ADir = vdirUp then
  begin
    I64LimitMax(Pos, PosLast);
    if PosBad(Pos) then Exit;
  end;

  ALine := '';
  for i := 1 to FMaxLength do
  begin
    if PosBad(Pos) then Break;
    wch := GetChar(Pos);
    if (wch = #13) or (wch = #10) then Break;
    ALine := ALine + wch;
    Inc(Result);
    NextPos(Pos, ADir);
  end;

  if FTextWrap and (Result > 0) then
  begin
    MaxWidth := ClientWidth - cPositionX0;
    if StringWidth(FBitmap.Canvas, ALine, FTabSize, GetAnsiDecode) > MaxWidth then
      if StringExtent(FBitmap.Canvas, ALine, Dx, FTabSize, GetAnsiDecode) then
      begin
        Result := 1;
        for i := Length(ALine) downto 1 do
          if Dx[i] <= MaxWidth then
            begin Result := StringWrapPosition(ALine, i); Break end;
        SetLength(ALine, Result);
      end;
  end;
end;

procedure TATBinHex.PosNextLineFrom(const AStartPos: Int64; ALines: integer; ADir: TATDirection; ARedraw: boolean = true);
var
  NewPos: Int64;
  Line: WideString;
  i: integer;
begin
  NewPos:= AStartPos;
  NormalizePos(NewPos);

  NextPos(NewPos, ADir, ALines * FMaxLength);
  I64LimitMin(NewPos, 0);
  I64LimitMax(NewPos, PosLast);

  FBufferPos := NewPos - FBufferMaxOffset;
  I64LimitMin(FBufferPos, 0);
  ReadBuffer;

  NewPos:= AStartPos;
  NormalizePos(NewPos);
  for i := 1 to ALines do
    NewPos := FindLinePos(NewPos, ADir, Line);

  if NewPos < 0 then
  begin
    if ADir = vdirDown then
    begin
      NewPos := FindLinePos(FFileSize, vdirUp, Line);
      I64LimitMin(NewPos, 0);
    end
    else
      NewPos := 0;
  end;

  FViewPos := NewPos;

  if ARedraw then
    Redraw;
end;

procedure TATBinHex.PosNextLine(ALines: integer; ADir: TATDirection);
begin
  if FViewAtEnd and (ADir=vdirDown) then Exit;

  PosNextLineFrom(FViewPos, ALines, ADir);
end;

function TATBinHex.CharSize: Integer;
const
  Sizes: array[TATBinHexMode] of Integer = (1, 1, 1, 2);
begin
  Result := Sizes[FMode];
end;

function TATBinHex.FileIsEmpty: Boolean;
begin
  Result := FFileSize < CharSize;
end;

procedure TATBinHex.NormalizePos(var APos: Int64);
begin
  if FMode = vbmodeUnicode then
    APos := APos div 2 * 2;
end;

function TATBinHex.NormalizedPos(const APos: Int64): Int64;
begin
  Result := APos;
  NormalizePos(Result);
end;

procedure TATBinHex.NextPos(var APos: Int64; ADir: TATDirection);
begin
  if ADir = vdirDown then
    Inc(APos, CharSize)
  else
    Dec(APos, CharSize);
end;

procedure TATBinHex.NextPos(var APos: Int64; ADir: TATDirection; AChars: integer);
begin
  if ADir = vdirDown then
    Inc(APos, AChars * CharSize)
  else
    Dec(APos, AChars * CharSize);
end;

function TATBinHex.GetChar(const APos: Int64): WideChar;
var
  Pos: Int64;
begin
  Result := #0;

  Pos := APos;
  if (Pos >= 0) and (Pos <= PosLast) then
    begin
    Pos := Pos - FBufferPos;

    Assert(
      (Pos >= 0) and (Pos < FBufferAllocSize),
      'Buffer position out of range: GetChar');

    if FMode = vbmodeUnicode then
    begin
      if FFileUnicodeFmt = vbUnicodeFmtBE then
        Result := WideChar(Ord(FBuffer[Pos + 1]) + (Ord(FBuffer[Pos]) shl 8))
      else
        Result := WideChar(Ord(FBuffer[Pos]) + (Ord(FBuffer[Pos + 1]) shl 8));
    end
    else
      Result := WideChar(FBuffer[Pos]);
    end;

  if (Ord(Result) < $20) and (Result <> #13) and (Result <> #10) and (Result <> #9) then
    Result := cSpecialChar;
end;

function TATBinHex.ActiveFont: TFont;
begin
  if (FMode <> vbmodeUnicode) and (FEncoding = vencOEM) then
    Result := FFontOEM
  else
    Result := Font;
end;

procedure TATBinHex.Lock;
begin
  Inc(FLockCount);
end;

procedure TATBinHex.Unlock;
begin
  Dec(FLockCount);
end;

function TATBinHex.Locked: boolean;
begin
  Result:= FLockCount>0;
end;

{$ifdef NOTIF}
procedure TATBinHex.NotifChanged(Sender: TObject);
begin
  if not Locked then
  begin
    try
      Lock;

      if not IsFileExist(FFileName) then
      //File is deleted
      begin
        FFileName := '';
        LoadFile(True);
      end
      else
      //It's just changed
      begin
        LoadFile(False);
      end;

      UpdateMenu;
      Redraw;

      if FAutoReloadBeep then
        MessageBeep(MB_ICONEXCLAMATION);

    finally
      Unlock;
    end;

    DoFileReload;
  end;
end;
{$endif}

{$ifdef NOTIF}
procedure TATBinHex.DoFileReload;
begin
  if Assigned(FOnFileReload) then
    FOnFileReload(Self);
end;
{$endif}

procedure TATBinHex.DoSelectionChange;
begin
  if Assigned(FOnSelectionChange) then
    FOnSelectionChange(Self);
end;

procedure TATBinHex.SetTabSize(ASize: Integer);
begin
  FTabSize := ASize;
  ILimitMin(FTabSize, cMinTabSize);
  ILimitMax(FTabSize, cMaxTabSize);
end;

function TATBinHex.GetMaxLengths(AIndex: TATBinHexMode): integer;
begin
  Result:= FMaxLengths[AIndex];
end;

procedure TATBinHex.SetMaxLengths(AIndex: TATBinHexMode; AValue: integer);
begin
  ILimitMin(AValue, cMinLength);
  ILimitMax(AValue, cMaxLength);
  FMaxLengths[AIndex]:= AValue;
  SetTextWidth(FTextWidth);
  SetTextWidthHex(FTextWidthHex);
end;

function TATBinHex.IncreaseFontSize(AIncrement: Boolean): Boolean;
begin
  Result := TextIncreaseFontSize(ActiveFont, Canvas, AIncrement);
  if Result then
    Redraw;
end;

{$ifdef SEARCH}
function TATBinHex.GetOnSearchProgress: TATStreamSearchProgress;
begin
  Result := FSearch.OnProgress;
end;

procedure TATBinHex.SetOnSearchProgress(AValue: TATStreamSearchProgress);
begin
  FSearch.OnProgress := AValue;
end;

function TATBinHex.GetSearchResultStart: Int64;
begin
  Result := FSearch.FoundStart;
end;

function TATBinHex.GetSearchResultLength: Int64;
begin
  Result := FSearch.FoundLength;
end;
{$endif}

{$ifdef SEARCH}
function TATBinHex.FindFirst(const AText: WideString; AOptions: TATStreamSearchOptions): Boolean;
var
  StreamEncoding: TATStreamSearchEncoding;
begin
  Assert(SourceAssigned, 'Source not assigned: FindFirst');

  if FMode = vbmodeUnicode then
  begin
    if FFileUnicodeFmt = vbUnicodeFmtBE then
      StreamEncoding := aseUnicodeBE
    else
      StreamEncoding := aseUnicodeLE;
  end
  else
  begin
    if FEncoding = vencOEM then
      StreamEncoding := aseOEM
    else
      StreamEncoding := aseANSI;
  end;

  try
    case FFileSourceType of
      vfsrcFile:
        FSearch.FileName := FFileName;
      vfsrcStream:
        FSearch.Stream := FStream;
    end;
  except
    MsgOpenError;
    Result := False;
    Exit;
  end;

  Result := FSearch.FindFirst(AText, 0, StreamEncoding, AOptions);
end;
{$endif}

{$ifdef SEARCH}
function TATBinHex.FindNext: Boolean;
begin
  Assert(SourceAssigned, 'Source not assigned: FindNext');
  Result := FSearch.FindNext;
end;
{$endif}

procedure TATBinHex.SetMaxClipboardDataSizeMb(AValue: Integer);
begin
  ILimitMin(AValue, cMaxClipboardDataSizeMbMin);
  ILimitMax(AValue, MaxInt div (1024 * 1024));
  FMaxClipboardDataSizeMb := AValue;
end;

initialization
  {$ifdef DEBUG_ATBINHEX}
  Logger.Channels.Add(TIPCChannel.Create);
  {$endif}
finalization


end.
