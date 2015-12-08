unit fnotification;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, FileUtil, Forms, Graphics, Dialogs, Buttons,
  StdCtrls, LCLIntF, ExtCtrls, Classes;

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
    procedure FormClick(Sender: TObject);
    procedure FormMouseEnter(Sender: TObject);
    procedure FormMouseLeave(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure lblFileNameClick(Sender: TObject);
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
  if Self.sdlgDirectory.FileName<>'' then
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
  if Self.sdlgDirectory.FileName<>'' then
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

procedure Tfrnotification.lblFileNameClick(Sender: TObject);
begin

end;

procedure Tfrnotification.FormClick(Sender: TObject);
begin
  //Self.Close;
  //Self.Free;
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

