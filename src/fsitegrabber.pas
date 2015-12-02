unit fsitegrabber;
{
  New site grabber form of AWGG

  Copyright (C) 2015 Reinier Romero Mir
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
  Forms, Controls, StdCtrls,
  EditBtn, ComCtrls, Spin, Buttons;

type

  { Tfrsitegrabber }

  Tfrsitegrabber = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    ComboBox1: TComboBox;
    DirectoryEdit1: TDirectoryEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    GroupBox9: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    Memo5: TMemo;
    Memo6: TMemo;
    Memo7: TMemo;
    Memo8: TMemo;
    PageControl1: TPageControl;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpinEdit1: TSpinEdit;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frsitegrabber: Tfrsitegrabber;
  grbadd:boolean;
implementation
uses fmain, fconfig;
{$R *.lfm}

{ Tfrsitegrabber }

procedure validatesite();
begin
  if (Length(frsitegrabber.Edit2.Text)>0) and (Length(frsitegrabber.Edit1.Text)>0) then
  begin
    frsitegrabber.Button1.Enabled:=true;
    frsitegrabber.Button4.Enabled:=true;
  end
  else
  begin
    frsitegrabber.Button1.Enabled:=false;
    frsitegrabber.Button4.Enabled:=false;
  end;
end;

procedure Tfrsitegrabber.FormCreate(Sender: TObject);
begin
  grbadd:=false;
  frsitegrabber.Button3.Enabled:=false;
  validatesite();
end;

procedure Tfrsitegrabber.SpeedButton1Click(Sender: TObject);
var
  i:integer;
begin
  newqueue();
  frsitegrabber.ComboBox1.Items.Clear;
  for i:=0 to Length(queues)-1 do
  begin
    frsitegrabber.ComboBox1.Items.Add(queuenames[i]);
  end;
  frsitegrabber.ComboBox1.ItemIndex:=Length(queues)-1;
end;

procedure Tfrsitegrabber.SpeedButton2Click(Sender: TObject);
begin
  frsitegrabber.FormStyle:=fsNormal;
  frconfig.PageControl1.ActivePageIndex:=1;
  frconfig.tvConfig.Items[frconfig.PageControl1.ActivePageIndex].Selected:=true;
  configdlg();
  frconfig.ComboBox4.ItemIndex:=frsitegrabber.ComboBox1.ItemIndex;
  frconfig.ComboBox4Change(nil);
  frconfig.ShowModal;
  frsitegrabber.ComboBox1.ItemIndex:=frconfig.ComboBox4.ItemIndex;
  frsitegrabber.FormStyle:=fsSystemStayOnTop;
end;

procedure Tfrsitegrabber.Button1Click(Sender: TObject);
begin
  grbadd:=true;
  frsitegrabber.Close;
end;

procedure Tfrsitegrabber.Button2Click(Sender: TObject);
begin
  grbadd:=false;
  frsitegrabber.Close;
end;

procedure Tfrsitegrabber.Button3Click(Sender: TObject);
begin
  if frsitegrabber.PageControl1.TabIndex>0 then
    frsitegrabber.PageControl1.TabIndex:=frsitegrabber.PageControl1.TabIndex-1;
  if frsitegrabber.PageControl1.TabIndex=0 then
    frsitegrabber.Button3.Enabled:=false;
  frsitegrabber.Button4.Enabled:=true;
end;

procedure Tfrsitegrabber.Button4Click(Sender: TObject);
begin
  if frsitegrabber.PageControl1.TabIndex<frsitegrabber.PageControl1.PageCount-1 then
    frsitegrabber.PageControl1.TabIndex:=frsitegrabber.PageControl1.TabIndex+1;
  if (frsitegrabber.PageControl1.TabIndex=frsitegrabber.PageControl1.PageCount-1) then
    frsitegrabber.Button4.Enabled:=false;
  frsitegrabber.Button3.Enabled:=true;
end;

procedure Tfrsitegrabber.Edit1Change(Sender: TObject);
begin
  validatesite();
end;

procedure Tfrsitegrabber.Edit2Change(Sender: TObject);
begin
  validatesite();
end;

end.

