unit fabout;
{
  About form of AWGG

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
  Forms, Graphics, StdCtrls,
  ExtCtrls, LCLintf;

type

  { Tfrabout }

  Tfrabout = class(TForm)
    btnOk: TButton;
    imgLogo: TImage;
    lblAboutName: TLabel;
    lblAboutVersion: TLabel;
    lblWebLink: TLabel;
    lblWebSite: TLabel;
    mAboutText: TMemo;
    procedure btnOkClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure lblWebLinkClick(Sender: TObject);
    procedure lblWebLinkMouseEnter(Sender: TObject);
    procedure lblWebLinkMouseLeave(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frabout: Tfrabout;

implementation

{$R *.lfm}

{ Tfrabout }

procedure Tfrabout.btnOkClick(Sender: TObject);
begin
  frabout.Close;
end;

procedure Tfrabout.FormDeactivate(Sender: TObject);
begin
  frabout.Close;
end;

procedure Tfrabout.lblWebLinkClick(Sender: TObject);
begin
  OpenURL(lblWebLink.Caption);
end;

procedure Tfrabout.lblWebLinkMouseEnter(Sender: TObject);
begin
  lblWebLink.Font.Color:=clRed;
end;

procedure Tfrabout.lblWebLinkMouseLeave(Sender: TObject);
begin
  lblWebLink.Font.Color:=clBlue;
end;

end.

