program awgg;
{
  AWGG

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

uses
  {$IFDEF UNIX}
  cthreads, cmem,
  {$ENDIF}
  {$IF DEFINED(WIN64) AND (FPC_FULLVERSION < 30000)}
  uExceptionHandlerFix,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, {$IFDEF TYPHON}lz_datetimectrls{$else}datetimectrls{$ENDIF}, fmain, fnewdown, fconfig, fabout,
  flang, fstrings, freplace, fsitegrabber, fadd, fnotification, fcopymove,
  fconfirm, un_lineinfo, fddbox, fvideoformat;

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Title:='AWGG';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(Tfrmain, frmain);
  Application.CreateForm(Tfrnewdown, frnewdown);
  Application.CreateForm(Tfrlang, frlang);
  Application.CreateForm(Tfrreplace, frreplace);
  Application.CreateForm(Tfrconfirm, frconfirm);
  Application.CreateForm(Tfrconfig, frconfig);
  Application.CreateForm(Tfrsitegrabber, frsitegrabber);
  Application.CreateForm(Tfradd, fradd);
  Application.CreateForm(Tfrabout, frabout);
  Application.CreateForm(Tfrddbox, frddbox);
  Application.CreateForm(Tfrvideoformat, frvideoformat);
  Application.Run;
end.

