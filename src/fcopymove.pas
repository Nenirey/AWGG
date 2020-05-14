unit fcopymove;
{
  Copy and move form of AWGG

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
  Forms, StdCtrls,
  ComCtrls;

type

  { Tfrcopymove }

  Tfrcopymove = class(TForm)
    btnCancel: TButton;
    lblFrom: TLabel;
    lblTo: TLabel;
    pbCopyMove: TProgressBar;
    pbTotal: TProgressBar;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
  private
    { private declarations }
  public
    { public declarations }
  id:integer;
  end;

var
  frcopymove: Tfrcopymove;

implementation
uses fmain;
{ Tfrcopymove }

procedure Tfrcopymove.btnCancelClick(Sender: TObject);
begin
  copywork[self.id].stop;
end;

procedure Tfrcopymove.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  copywork[self.id].stop;
end;

{$R *.lfm}

end.

