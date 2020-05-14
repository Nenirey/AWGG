unit fnotification;
{
  Notification form of AWGG

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
{$mode objfpc}{$H+}

interface

uses
  SysUtils, FileUtil, Forms, Graphics, Dialogs, Buttons,
  StdCtrls, LCLIntF, ExtCtrls, Classes, LazFileUtils, LazUTF8;

type

  { Tfrnotification }

  Tfrnotification = class(TForm)
    imgLogo: TImage;
    lblFileName: TLabel;
    lblDescriptionError: TLabel;
    lblTitle: TLabel;
    sdlgDirectory: TSelectDirectoryDialog;
    btnGoPath: TSpeedButton;
    btnOpenFile: TSpeedButton;
    btnClose: TSpeedButton;
    btnCopyTo: TSpeedButton;
    btnMoveTo: TSpeedButton;
    HideTimer: TTimer;
    btnStartDown: TSpeedButton;
    procedure btnStartDownClick(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseEnter(Sender: TObject);
    procedure FormMouseLeave(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure btnGoPathClick(Sender: TObject);
    procedure btnOpenFileClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnCopyToClick(Sender: TObject);
    procedure btnMoveToClick(Sender: TObject);
    procedure HideTimerTimer(Sender: TObject);
  private
    { private declarations }

  public
    { public declarations }
    notipathfile:string;
    notiuid:string;
  end;

var
  frnotification: Tfrnotification;

implementation
uses fmain;
{$R *.lfm}

{ Tfrnotification }

procedure Tfrnotification.btnGoPathClick(Sender: TObject);
begin
  if not OpenURL(Self.notipathfile) then
    OpenURL(ExtractShortPathName(UTF8ToSys(Self.notipathfile)));
end;

procedure Tfrnotification.btnOpenFileClick(Sender: TObject);
begin
  OpenURL(Self.notipathfile+pathdelim+Self.lblFileName.Caption);
end;

procedure Tfrnotification.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure Tfrnotification.btnCopyToClick(Sender: TObject);
begin
  Self.sdlgDirectory.Execute;
  //if Self.sdlgDirectory.FileName<>'' then
  if {$IFDEF LCLQT}(Self.sdlgDirectory.UserChoice=1){$else}{$IFDEF LCLQT5}(Self.sdlgDirectory.UserChoice=1){$ELSE}Self.sdlgDirectory.FileName<>''{$endif}{$ENDIF} then
  begin
    SetLength(copywork,Length(copywork)+1);
    copywork[Length(copywork)-1]:=copythread.Create(true,Length(copywork)-1);
    copywork[Length(copywork)-1].id:=Length(copywork)-1;
    copywork[Length(copywork)-1].source.Add(Self.notipathfile+pathdelim+Self.lblFileName.Caption);
    copywork[Length(copywork)-1].destination:=Self.sdlgDirectory.FileName;
    copywork[Length(copywork)-1].Start;
  end;
end;

procedure Tfrnotification.btnMoveToClick(Sender: TObject);
begin
  Self.sdlgDirectory.Execute;
  //if Self.sdlgDirectory.FileName<>'' then
  if {$IFDEF LCLQT}(Self.sdlgDirectory.UserChoice=1){$else}{$IFDEF LCLQT5}(Self.sdlgDirectory.UserChoice=1){$ELSE}Self.sdlgDirectory.FileName<>''{$endif}{$ENDIF} then
  begin
    SetLength(copywork,Length(copywork)+1);
    copywork[Length(copywork)-1]:=copythread.Create(true,Length(copywork)-1,true);
    copywork[Length(copywork)-1].id:=Length(copywork)-1;
    copywork[Length(copywork)-1].source.Add(Self.notipathfile+pathdelim+Self.lblFileName.Caption);
    copywork[Length(copywork)-1].destination:=Self.sdlgDirectory.FileName;
    copywork[Length(copywork)-1].Start;
  end;
end;

procedure Tfrnotification.HideTimerTimer(Sender: TObject);
begin
  Self.HideTimer.Enabled:=false;
  Self.Close;
end;

procedure Tfrnotification.FormClick(Sender: TObject);
var
  i:integer;
begin
  if Self.lblFilename.Caption<>'' then
  begin
    for i:=0 to frmain.lvMain.Items.Count-1 do
    begin
      if frmain.lvMain.Items[i].SubItems[columnuid]=notiuid then
      begin
        frmain.lvMain.ItemIndex:=i;
        break;
      end;
    end;
  end;
  frmain.WindowState:=lastmainwindowstate;
  frmain.Show;
  Self.Close;
end;

procedure Tfrnotification.btnStartDownClick(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to frmain.lvMain.Items.Count-1 do
  begin
    if frmain.lvMain.Items[i].SubItems[columnuid]=notiuid then
    begin
      downloadstart(i,false);
      break;
    end;
  end;
  Self.btnStartDown.Enabled:=false;
end;

procedure Tfrnotification.FormCreate(Sender: TObject);
begin

end;

procedure Tfrnotification.FormMouseEnter(Sender: TObject);
begin
  Self.HideTimer.Enabled:=false;
  Self.AlphaBlend:=false;
end;

procedure Tfrnotification.FormMouseLeave(Sender: TObject);
begin
  Self.HideTimer.Enabled:=true;
  Self.AlphaBlend:=true;
end;

procedure Tfrnotification.FormPaint(Sender: TObject);
begin
  Self.Canvas.Pen.Color:=clBtnShadow;
  Self.Canvas.RoundRect(1, 1, Self.Width-1, Self.Height-1, 20, 20);
end;

end.

