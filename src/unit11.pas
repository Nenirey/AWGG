unit Unit11;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, FileUtil, Forms, Graphics, Dialogs, Buttons,
  StdCtrls, LCLIntF, ExtCtrls, Classes;

type

  { TForm9 }

  TForm9 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Timer1: TTimer;
    procedure FormClick(Sender: TObject);
    procedure FormMouseEnter(Sender: TObject);
    procedure FormMouseLeave(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }

  public
    { public declarations }
    notipathfile:string;
  end;

var
  Form9: TForm9;

implementation
uses Unit1;
{$R *.lfm}

{ TForm9 }

procedure TForm9.SpeedButton1Click(Sender: TObject);
begin
  if not OpenURL(Self.notipathfile) then
    OpenURL(ExtractShortPathName(UTF8ToSys(Self.notipathfile)));
end;

procedure TForm9.SpeedButton2Click(Sender: TObject);
begin
  OpenURL(Self.notipathfile+pathdelim+Self.Label1.Caption);
end;

procedure TForm9.SpeedButton3Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TForm9.SpeedButton4Click(Sender: TObject);
begin
  Self.SelectDirectoryDialog1.Execute;
  if Self.SelectDirectoryDialog1.FileName<>'' then
  begin
    SetLength(copywork,Length(copywork)+1);
    copywork[Length(copywork)-1]:=copythread.Create(true,Length(copywork)-1);
    copywork[Length(copywork)-1].id:=Length(copywork)-1;
    copywork[Length(copywork)-1].source.Add(Self.notipathfile+pathdelim+Self.Label1.Caption);
    copywork[Length(copywork)-1].destination:=Self.SelectDirectoryDialog1.FileName;
    copywork[Length(copywork)-1].Start;
  end;
end;

procedure TForm9.SpeedButton5Click(Sender: TObject);
begin
  Self.SelectDirectoryDialog1.Execute;
  if Self.SelectDirectoryDialog1.FileName<>'' then
  begin
    SetLength(copywork,Length(copywork)+1);
    copywork[Length(copywork)-1]:=copythread.Create(true,Length(copywork)-1,true);
    copywork[Length(copywork)-1].id:=Length(copywork)-1;
    copywork[Length(copywork)-1].source.Add(Self.notipathfile+pathdelim+Self.Label1.Caption);
    copywork[Length(copywork)-1].destination:=Self.SelectDirectoryDialog1.FileName;
    copywork[Length(copywork)-1].Start;
  end;
end;

procedure TForm9.Timer1Timer(Sender: TObject);
begin
  Self.Timer1.Enabled:=false;
  Self.Close;
end;

procedure TForm9.Label1Click(Sender: TObject);
begin

end;

procedure TForm9.FormClick(Sender: TObject);
begin
  //Self.Close;
  //Self.Free;
end;

procedure TForm9.FormMouseEnter(Sender: TObject);
begin
  Self.Timer1.Enabled:=false;
  Self.AlphaBlend:=false;
end;

procedure TForm9.FormMouseLeave(Sender: TObject);
begin
  Self.Timer1.Enabled:=true;
  Self.AlphaBlend:=true;
end;

procedure TForm9.FormPaint(Sender: TObject);
begin
  Self.Canvas.Pen.Color:=clBtnShadow;
  Self.Canvas.RoundRect(1, 1, Self.Width-1, Self.Height-1, 20, 20);
end;

end.

