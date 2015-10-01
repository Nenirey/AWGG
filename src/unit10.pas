unit Unit10;
{
  Add-Edit-Delete category form of AWGG

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
  Forms, StdCtrls,
  ButtonPanel;

type

  { TForm8 }

  TForm8 = class(TForm)
    ButtonPanel1: TButtonPanel;
    Edit1: TEdit;
    Label1: TLabel;
    procedure ButtonPanel1Click(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form8: TForm8;
  ok:boolean;

implementation

{$R *.lfm}

{ TForm8 }

procedure TForm8.ButtonPanel1Click(Sender: TObject);
begin

end;

procedure TForm8.CancelButtonClick(Sender: TObject);
begin
  ok:=false;
end;

procedure TForm8.FormCreate(Sender: TObject);
begin
  ok:=false;
end;

procedure TForm8.FormShow(Sender: TObject);
begin
  Form8.Edit1.SetFocus;
end;

procedure TForm8.OKButtonClick(Sender: TObject);
begin
  ok:=true;
end;

end.

