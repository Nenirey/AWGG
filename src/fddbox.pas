unit fddbox;

{
  Drag drop box form of AWGG

  Copyright (C) 2020 Reinier Romero Mir
  nenirey@gmail.com

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}

// {$mode objfpc}{$H+}
{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, {$IFDEF WINDOWS}Windows, ActiveX, ComObj,{$ENDIF} types;

type

  { Tfrddbox }
  {$IFDEF WINDOWS}
  Tfrddbox = class(TForm, IDropTarget)
  {$ELSE}
  Tfrddbox = class(TForm)
  {$ENDIF}
    edtDrop: TEdit;
    frddboximgLogo: TImage;
    getCurPosTimer: TTimer;
    procedure edtDropChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseEnter(Sender: TObject);
    procedure FormMouseLeave(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormPaint(Sender: TObject);
    procedure getCurPosTimerTimer(Sender: TObject);
  private
    { private declarations }
    // IDropTarget
    {$IFDEF WINDOWS}
    function DragEnter(const dataObj: IDataObject; grfKeyState: DWORD; pt: TPoint; var dwEffect: DWORD): HResult;StdCall;
    function DragOver(grfKeyState: DWORD; pt: TPoint; var dwEffect: DWORD): HResult;StdCall;
    function DragLeave: HResult;StdCall;
    function Drop(const dataObj: IDataObject; grfKeyState: DWORD; pt: TPoint; var dwEffect: DWORD):HResult;StdCall;
    // IUnknown
    // Ignore referance counting
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    {$ENDIF}
  public
    { public declarations }
  end;


var
  frddbox: Tfrddbox;
  startmdown:boolean=false;
  nodrag:boolean=false;
  startmx,startmy:integer;
implementation
uses fmain, fnewdown;
{$R *.lfm}

{ Tfrddbox }

procedure Tfrddbox.FormCreate(Sender: TObject);
begin
  {$IFDEF WINDOWS}
  OleInitialize(nil);
  OleCheck(RegisterDragDrop(Handle, Self));
  {$ENDIF}
end;

procedure Tfrddbox.FormDblClick(Sender: TObject);
begin
  startmdown:=false;
  frmain.miShowMainFormClick(nil);
end;

procedure Tfrddbox.edtDropChange(Sender: TObject);
begin
  {$IFDEF WINDOWS}
  {$ELSE}
  if (Pos('http://',frddbox.edtDrop.Text)=1) or (Pos('https://',frddbox.edtDrop.Text)=1) or (Pos('ftp://',frddbox.edtDrop.Text)=1) or (Pos('magnet',frddbox.edtDrop.Text)=1) then
  begin
    frnewdown.edtURL.Text:=frddbox.edtDrop.Text;
    frmain.tbAddDownClick(nil,not silentdropbox);
  end;
   frddbox.edtDrop.Text:='';
  {$ENDIF}
end;

procedure Tfrddbox.FormActivate(Sender: TObject);
begin
  {$IFDEF LCLQT5}
  {$ELSE}
  //if (frmain.Visible) and (not nodrag) then
    //frmain.SetFocus;
  {$ENDIF}
end;

procedure Tfrddbox.FormDeactivate(Sender: TObject);
begin
  startmdown:=false;
  nodrag:=false;
  {$IFDEF WINDOWS}
  {$ELSE}
  //frddbox.edtDrop.Visible:=true;
  {$ENDIF}
end;

procedure Tfrddbox.FormDestroy(Sender: TObject);
begin
  {$IFDEF WINDOWS}
  RevokeDragDrop(Handle);
  OleUninitialize;
  {$ENDIF}
end;

procedure Tfrddbox.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  startmdown:=true;
  nodrag:=true;
  startmx:=X;
  startmy:=Y;
end;

procedure Tfrddbox.FormMouseEnter(Sender: TObject);
begin
  nodrag:=true;
end;

procedure Tfrddbox.FormMouseLeave(Sender: TObject);
begin
  startmdown:=false;
  nodrag:=false;
end;

procedure Tfrddbox.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if startmdown then
  begin
    frddbox.Top:=Mouse.CursorPos.y-startmy;
    frddbox.Left:=Mouse.CursorPos.x-startmx;
  end;
end;

procedure Tfrddbox.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  startmdown:=false;
  saveconfig;
  //nodrag:=false;
end;

procedure Tfrddbox.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if WheelDelta>0 then
  begin
    frddbox.Width:=frddbox.Width+5;
    frddbox.Height:=frddbox.Height+5;
  end
  else
  begin
    frddbox.Width:=frddbox.Width-5;
    frddbox.Height:=frddbox.Height-5;
  end;
  nodrag:=true;
end;

procedure Tfrddbox.FormPaint(Sender: TObject);
begin
  Self.Canvas.Pen.Color:=clBlack;
  Self.Canvas.Pen.Width:=1;
  //Self.Canvas.RoundRect(0, 0, Self.Width, Self.Height, 0, 0);
  Self.Canvas.Rectangle(Self.GetClientRect);
end;


procedure Tfrddbox.getCurPosTimerTimer(Sender: TObject);
begin
  {$IFDEF WINDOWS}
  {$ELSE}
  if (Mouse.CursorPos.X>frddbox.Left) and (Mouse.CursorPos.Y>frddbox.Top) and (Mouse.CursorPos.X<(frddbox.Left+frddbox.Width)) and (Mouse.CursorPos.Y<(frddbox.Top+frddbox.Height)) then
  begin
    if (startmdown=false) and (nodrag=false) then
      frddbox.edtDrop.Visible:=true;
  end
  else
  begin
    frddbox.edtDrop.Visible:=false;
    nodrag:=false;
  end;
  {$ENDIF}
end;

{$IFDEF WINDOWS}
function Tfrddbox.DragEnter(const dataObj: IDataObject; grfKeyState: DWORD; pt: TPoint; var dwEffect: DWORD): HResult;
begin
  dwEffect := DROPEFFECT_LINK;
  Result := S_OK;
end;


function Tfrddbox.DragOver(grfKeyState: DWORD; pt: TPoint;
  var dwEffect: DWORD): HResult;
begin
  dwEffect := DROPEFFECT_LINK;
  Result := S_OK;
end;

function Tfrddbox.DragLeave: HResult;
begin
  Result := S_OK;
end;

function Tfrddbox._AddRef: Integer;
begin
   Result := 1;
end;

function Tfrddbox._Release: Integer;
begin
   Result := 1;
end;

function Tfrddbox.Drop(const dataObj: IDataObject; grfKeyState: DWORD;
  pt: TPoint; var dwEffect: DWORD): HResult;
var
  aFmtEtc: TFORMATETC;
  aStgMed: TSTGMEDIUM;
  pData: PChar;
  tmpindex:integer;
  tmpclip:string='';
begin
  {Make certain the data rendering is available}
  if (dataObj = nil) then
    raise Exception.Create('IDataObject-Pointer is not valid!');
  with aFmtEtc do
  begin
    cfFormat := CF_TEXT;
    ptd := nil;
    dwAspect := DVASPECT_CONTENT;
    lindex := -1;
    tymed := TYMED_HGLOBAL;
  end;
  if DataObj.QueryGetData(aFmtEtc) = S_OK then
  begin
    {Get the data}
    OleCheck(dataObj.GetData(aFmtEtc, aStgMed));
    try
      {Lock the global memory handle to get a pointer to the data}
      pData := GlobalLock(aStgMed.hGlobal);
      tmpclip:=pData;
      if not (Pos('http://',tmpclip)=1) or (Pos('https://',tmpclip)=1) or (Pos('ftp://',tmpclip)=1) or (Pos('magnet',tmpclip)=1) then
      begin
        dwEffect:=DROPEFFECT_COPY;
        OleCheck(dataObj.GetData(aFmtEtc, aStgMed));
        pData := GlobalLock(aStgMed.hGlobal);
      end;
      { Replace Text }
      frddbox.FormStyle:=fsNormal;
      /////////////////////////////****Capture download****/////////////////
      tmpclip:=pData;
      if (Pos('http://',tmpclip)=1) or (Pos('https://',tmpclip)=1) or (Pos('ftp://',tmpclip)=1) or (Pos('magnet',tmpclip)=1) then
      begin
        frnewdown.edtURL.Text:=tmpclip;
        frmain.tbAddDownClick(nil,not silentdropbox);
      end;
      ////////////////////////////*****end capture*****/////////////////////
      frddbox.FormStyle:=fsSystemStayOnTop;
    finally
      {Finished with the pointer}
      GlobalUnlock(aStgMed.hGlobal);
      {Free the memory}
      ReleaseStgMedium(aStgMed);
    end;
    Result := S_OK;
  end;
end;
{$ENDIF}
end.

