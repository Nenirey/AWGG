unit freplace;
{
  Replace form of AWGG

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
  SysUtils, Forms, StdCtrls, Classes;

type

  { Tfrreplace }

  Tfrreplace = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    edtFileName: TEdit;
    lblFileExistInformation: TLabel;
    lblFileName: TLabel;
    rbOverwrite: TRadioButton;
    rbAutoRename: TRadioButton;
    rbManualRename: TRadioButton;
    rbUpdateURL: TRadioButton;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rbOverwriteChange(Sender: TObject);
    procedure rbAutoRenameChange(Sender: TObject);
    procedure rbManualRenameChange(Sender: TObject);
    procedure rbUpdateURLClick(Sender: TObject);
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
procedure Tfrreplace.btnOkClick(Sender: TObject);
begin
  accept:=true;
  if frreplace.rbOverwrite.Checked then
    DeleteFile(frnewdown.deDestination.Text+pathdelim+frnewdown.edtFileName.Text);
  if ((frreplace.rbManualRename.Checked) and (destinyexists(frnewdown.deDestination.Text+pathdelim+frreplace.edtFileName.Text) or FileExists(frnewdown.deDestination.Text+pathdelim+frreplace.edtFileName.Text))) then
    frreplace.Activate
  else
    frreplace.Close;
end;

procedure Tfrreplace.btnCancelClick(Sender: TObject);
begin
  accept:=false;
  frreplace.Close;
end;

procedure Tfrreplace.FormCreate(Sender: TObject);
begin
  accept:=false;
end;

procedure Tfrreplace.rbOverwriteChange(Sender: TObject);
begin
  if frreplace.rbOverwrite.Checked then
    frreplace.edtFileName.Text:=frnewdown.edtFileName.Text;
end;

procedure Tfrreplace.rbAutoRenameChange(Sender: TObject);
begin
  while (frreplace.rbAutoRename.Checked) and (destinyexists(frnewdown.deDestination.Text+pathdelim+frreplace.edtFileName.Text) or FileExists(frnewdown.deDestination.Text+pathdelim+frreplace.edtFileName.Text)) do
    frreplace.edtFileName.Text:='_'+frreplace.edtFileName.Text;
end;

procedure Tfrreplace.rbManualRenameChange(Sender: TObject);
begin
  if frreplace.rbManualRename.Checked then
  begin
    frreplace.edtFileName.Enabled:=true;
    frreplace.edtFileName.Text:=frnewdown.edtFileName.Text;
  end
  else
    frreplace.edtFileName.Enabled:=false;
end;

procedure Tfrreplace.rbUpdateURLClick(Sender: TObject);
begin
  frreplace.edtFileName.Text:=frnewdown.edtFileName.Text;
end;

end.

