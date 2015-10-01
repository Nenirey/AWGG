unit Unit8;
{
  Rename form of AWGG

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
  SysUtils, Forms, StdCtrls;

type

  { TForm6 }

  TForm6 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton3Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form6: TForm6;
  accept:boolean;
implementation

{$R *.lfm}

{ TForm6 }
procedure TForm6.Button1Click(Sender: TObject);
begin
  accept:=true;
  if Form6.RadioButton1.Checked then
    DeleteFile(Form6.Label3.Caption+pathdelim+Form6.Label4.Caption);
  Form6.Close;
end;

procedure TForm6.Button2Click(Sender: TObject);
begin
  accept:=false;
  Form6.Close;
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
  accept:=false;
end;

procedure TForm6.RadioButton1Change(Sender: TObject);
begin
  if Form6.RadioButton1.Checked then
    Form6.Edit1.Text:=Form6.Label4.Caption;
end;

procedure TForm6.RadioButton2Change(Sender: TObject);
begin
  if Form6.RadioButton2.Checked then
    Form6.Edit1.Text:='_'+Form6.Label4.Caption;
end;

procedure TForm6.RadioButton3Change(Sender: TObject);
begin
  if Form6.RadioButton3.Checked then
  begin
    Form6.Edit1.Enabled:=true;
    Form6.Edit1.Text:=Form6.Label4.Caption;
  end
  else
    Form6.Edit1.Enabled:=false;
end;

end.

