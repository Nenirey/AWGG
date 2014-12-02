unit Unit4;
{
  About form of AWGG

  Copyright (C) 2014 Reinier Romero Mir
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
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, LCLintf;

type

  { TForm4 }

  TForm4 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label3MouseEnter(Sender: TObject);
    procedure Label3MouseLeave(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.lfm}

{ TForm4 }

procedure TForm4.Button1Click(Sender: TObject);
begin
  Form4.Close;
end;

procedure TForm4.FormDeactivate(Sender: TObject);
begin
  Form4.Close;
end;

procedure TForm4.Label3Click(Sender: TObject);
begin
  OpenURL(Label3.Caption);
end;

procedure TForm4.Label3MouseEnter(Sender: TObject);
begin
  Label3.Font.Color:=clRed;
end;

procedure TForm4.Label3MouseLeave(Sender: TObject);
begin
  Label3.Font.Color:=clBlue;
end;

end.

