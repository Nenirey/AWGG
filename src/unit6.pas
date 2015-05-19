unit Unit6;
{
  Resource strings form of AWGG

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
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TrsForm }

  TrsForm = class(TForm)
    dlgdeletedownandfile: TLabel;
    dlgdeletedown: TLabel;
    dlgconfirm: TLabel;
    btnpropertiesok: TLabel;
    btnnewdownstartnow: TLabel;
    dlgrestartalldownloads: TLabel;
    dlgdeletealldownloads: TLabel;
    dlgrestartalldownloadslatter: TLabel;
    dlgrestartselecteddownloadletter: TLabel;
    dlgclearhistorylogfile: TLabel;
    dlgrestartselecteddownload: TLabel;
    friday: TLabel;
    automaticstartscheduler: TLabel;
    dlgdeletequeue: TLabel;
    filtresname: TLabel;
    alldowntreename: TLabel;
    proxymanual: TLabel;
    proxysystem: TLabel;
    proxynot: TLabel;
    queuename: TLabel;
    queuestreename: TLabel;
    queuemainname: TLabel;
    statuserror: TLabel;
    startinthesystray: TLabel;
    runwiththesystem: TLabel;
    msgmustselectweekday: TLabel;
    msgmustselectdownloadengine: TLabel;
    saturday: TLabel;
    thursday: TLabel;
    wednesday: TLabel;
    tuesday: TLabel;
    monday: TLabel;
    sunday: TLabel;
    statuspaused: TLabel;
    msgfilenoexist: TLabel;
    msgnoexisthistorylog: TLabel;
    titlenewdown: TLabel;
    titlepropertiesdown: TLabel;
    msgcloseinprogressdownload: TLabel;
    popuptitlestoped: TLabel;
    statusstoped: TLabel;
    popuptitlecomplete: TLabel;
    statuscomplete: TLabel;
    msgerrordownlistsave: TLabel;
    msgmustselectdownload: TLabel;
    msgnoexistfolder: TLabel;
    statusinprogres: TLabel;
    msgerrorconfigload: TLabel;
    msgerrorconfigsave: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  rsForm: TrsForm;

implementation

{$R *.lfm}

{ TrsForm }

procedure TrsForm.FormCreate(Sender: TObject);
begin

end;

end.

