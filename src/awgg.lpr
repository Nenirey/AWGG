program awgg;
{
  AWGG

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

uses
  {$IFDEF UNIX}
  cthreads, cmem,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, pl_luicontrols, fmain, fnewdown, fconfig, fabout, flang,
  fstrings, freplace, fsitegrabber, fadd, fnotification, fcopymove, fconfirm;

{$R *.res}

begin
  Application.Title:='AWGG';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(Tfrmain, frmain);
  Application.CreateForm(Tfrnewdown, frnewdown);
  Application.CreateForm(Tfrconfig, frconfig);
  Application.CreateForm(Tfrabout, frabout);
  Application.CreateForm(Tfrlang, frlang);
  Application.CreateForm(Tfrstrings, frstrings);
  Application.CreateForm(Tfrconfirm, frconfirm);
  Application.CreateForm(Tfrreplace, frreplace);
  Application.CreateForm(Tfrsitegrabber, frsitegrabber);
  Application.CreateForm(Tfradd, fradd);
  Application.CreateForm(Tfrnotification, frnotification);
  Application.CreateForm(Tfrcopymove, frcopymove);
  Application.Run;
end.

