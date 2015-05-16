unit Unit7;
{
  Confirm form of AWGG

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
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls;

type

  { TdlgForm }

  TdlgForm = class(TForm)
    dlgbtnyes: TButton;
    dlgbtnno: TButton;
    dlgtext: TLabel;
    procedure dlgbtnnoClick(Sender: TObject);
    procedure dlgbtnyesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  dlgForm: TdlgForm;
  dlgcuestion:boolean;
implementation

{$R *.lfm}

{ TdlgForm }

procedure TdlgForm.dlgbtnyesClick(Sender: TObject);
begin
  dlgcuestion:=true;
  dlgForm.Close;
end;

procedure TdlgForm.FormCreate(Sender: TObject);
begin
  dlgcuestion:=false;
end;

procedure TdlgForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //ShowMessage(inttostr(Key));
  case Key of
  27:begin
    dlgcuestion:=false;
    dlgForm.Close;
    end;
  end;
end;

procedure TdlgForm.dlgbtnnoClick(Sender: TObject);
begin
  dlgcuestion:=false;
  dlgForm.Close;
end;

end.

