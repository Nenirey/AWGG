unit flang;
{
  Language form of AWGG

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
  Forms, StdCtrls, Classes, LCLTranslator;

type

  { Tfrlang }

  Tfrlang = class(TForm)
    btnOk: TButton;
    cbLang: TComboBox;
    lblLang: TLabel;
    procedure btnOkClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frlang: Tfrlang;

implementation

{$R *.lfm}

{ Tfrlang }

procedure Tfrlang.btnOkClick(Sender: TObject);
begin
  frlang.Close;
end;

end.

