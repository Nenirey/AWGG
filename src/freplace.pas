unit freplace;
{
  Replace form of AWGG

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
  SysUtils, Forms, StdCtrls, Classes;

type

  { Tfrreplace }

  Tfrreplace = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton3Change(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frreplace: Tfrreplace;
  accept:boolean;
implementation
uses fmain,fnewdown;
{$R *.lfm}

{ Tfrreplace }
procedure Tfrreplace.Button1Click(Sender: TObject);
begin
  accept:=true;
  if frreplace.RadioButton1.Checked then
    DeleteFile(frnewdown.DirectoryEdit1.Text+pathdelim+frnewdown.Edit3.Text);
  if ((frreplace.RadioButton3.Checked) and (destinyexists(frnewdown.DirectoryEdit1.Text+pathdelim+frreplace.Edit1.Text) or FileExists(frnewdown.DirectoryEdit1.Text+pathdelim+frreplace.Edit1.Text))) then
    frreplace.Activate
  else
    frreplace.Close;
end;

procedure Tfrreplace.Button2Click(Sender: TObject);
begin
  accept:=false;
  frreplace.Close;
end;

procedure Tfrreplace.FormCreate(Sender: TObject);
begin
  accept:=false;
end;

procedure Tfrreplace.RadioButton1Change(Sender: TObject);
begin
  if frreplace.RadioButton1.Checked then
    frreplace.Edit1.Text:=frnewdown.Edit3.Text;
end;

procedure Tfrreplace.RadioButton2Change(Sender: TObject);
begin
  while (frreplace.RadioButton2.Checked) and (destinyexists(frnewdown.DirectoryEdit1.Text+pathdelim+frreplace.Edit1.Text) or FileExists(frnewdown.DirectoryEdit1.Text+pathdelim+frreplace.Edit1.Text)) do
    frreplace.Edit1.Text:='_'+frreplace.Edit1.Text;
end;

procedure Tfrreplace.RadioButton3Change(Sender: TObject);
begin
  if frreplace.RadioButton3.Checked then
  begin
    frreplace.Edit1.Enabled:=true;
    frreplace.Edit1.Text:=frnewdown.Edit3.Text;
  end
  else
    frreplace.Edit1.Enabled:=false;
end;

procedure Tfrreplace.RadioButton4Click(Sender: TObject);
begin
  frreplace.Edit1.Text:=frnewdown.Edit3.Text;
end;

end.

