unit Unit6;

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


end.

