unit fvideoformat;
{
  Select video format form of AWGG

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
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ButtonPanel, ComCtrls;

type

  { Tfrvideoformat }

  Tfrvideoformat = class(TForm)
    bpSelectFormat: TButtonPanel;
    btnReload: TButton;
    chDownSubtitle: TCheckBox;
    chDownPlayList: TCheckBox;
    lblName: TLabel;
    lblVideoName: TLabel;
    lblSelectFormat: TLabel;
    lvFormats: TListView;
    procedure btnReloadClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frvideoformat: Tfrvideoformat;
  accept:boolean=false;
  vname:string='';
implementation
uses fmain,fnewdown,fstrings;
{$R *.lfm}

{ Tfrvideoformat }

procedure Tfrvideoformat.OKButtonClick(Sender: TObject);
begin
  accept:=true;
end;

procedure Tfrvideoformat.btnReloadClick(Sender: TObject);
begin
  frvideoformat.lblSelectFormat.Caption:=videoformatloading;
  frvideoformat.lblVideoName.Caption:=videonameloading;
  frvideoformat.lblName.Caption:='';
  vname:='';
  getyoutubeformats(frnewdown.edtURL.Text);
  getyoutubename(frnewdown.edtURL.Text);
end;

end.

