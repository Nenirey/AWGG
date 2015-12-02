unit fmain;

{
  Main form of AWGG

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
  Classes, SysUtils, FileUtil,
  synhighlighterunixshellscript, SynEdit, UniqueInstance, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ExtCtrls, Menus, Spin, ComCtrls, DateUtils,
  Process,
  {$IFDEF WINDOWS}Registry, MMSystem,{$ENDIF} Math, fnewdown, fconfig, fabout, flang, fstrings, freplace, fsitegrabber, fnotification, fcopymove, fconfirm, Clipbrd,
  strutils, LCLIntf, types, versionitis, INIFiles, LCLVersion,
  PairSplitter, {DefaultTranslator}LCLTranslator, URIParser;

type
  DownThread = class(TThread)
private
  wout:array of string;
  wpr:TStringList;
  wthp:TProcess;
  thid:integer;
  thid2:integer;
  completado:boolean;
  manualshutdown:boolean;
  procedure update;
  procedure prepare();
  procedure shutdown();
protected
  procedure Execute; override;
public
  Constructor Create(CreateSuspended:boolean;tmps:TStringList);
end;

type
  soundthread=class(TThread)
private
  player:TProcess;
  sndfile:string;
protected
  procedure Execute; override;
public
  Constructor Create(CreateSuspended:boolean);
end;

type
  copythread=class(TThread)
private
  pform:Tfrcopymove;
  percent:integer;
  canceling:boolean;
  delsrc:boolean;
  procedure update;
  procedure prepare;
  procedure confirm;
protected
  procedure Execute; override;
public
  source:TStringList;
  destination:string;
  id:integer;
  Findex:integer;
  procedure stop;
  Constructor Create(CreateSuspended:boolean;idform:integer;deletesource:boolean=false);
end;
  { Tfrmain }

  Tfrmain = class(TForm)
    ApplicationProperties1: TApplicationProperties;
    cbLimit: TCheckBox;
    fseLimit: TFloatSpinEdit;
    ilSrc: TImageList;
    lblMaxDownInProgress: TLabel;
    lvMain: TListView;
    lvFilter: TListView;
    mnuMain: TMainMenu;
    miShowMainForm: TMenuItem;
    mimainAbout: TMenuItem;
    milistMoveFiles: TMenuItem;
    micommandClear: TMenuItem;
    micommandCopy: TMenuItem;
    micommandSelectAll: TMenuItem;
    miline25: TMenuItem;
    mimainShowTree: TMenuItem;
    milistProperties: TMenuItem;
    milistCopyURL: TMenuItem;
    milistDeleteDown: TMenuItem;
    miStopAll: TMenuItem;
    mimainScheduler: TMenuItem;
    mimainAddDown: TMenuItem;
    mimainDeleteDown: TMenuItem;
    mimainDownloads: TMenuItem;
    mimainSelectAll: TMenuItem;
    miExit: TMenuItem;
    mimainUnselectAll: TMenuItem;
    mimainStartAll: TMenuItem;
    mimainStopAll: TMenuItem;
    mimainShowCurrent: TMenuItem;
    mimainShowParameters: TMenuItem;
    mimainShowGrid: TMenuItem;
    milistOpenLog: TMenuItem;
    milistStartDown: TMenuItem;
    milistStopDown: TMenuItem;
    milistRestartNow: TMenuItem;
    miline3: TMenuItem;
    mimainRestartAllNow: TMenuItem;
    mimainDeleteAll: TMenuItem;
    mimainShow: TMenuItem;
    mimainShowCommand: TMenuItem;
    milistOpenDestination: TMenuItem;
    mimainColumns: TMenuItem;
    mimainShowState: TMenuItem;
    mimainShowName: TMenuItem;
    mimainShowSize: TMenuItem;
    mimainShowURL: TMenuItem;
    mimainShowTrayDowns: TMenuItem;
    mimainShowSpeed: TMenuItem;
    mimainShowPercent: TMenuItem;
    mimainShowEstimated: TMenuItem;
    mimainShowDestination: TMenuItem;
    mimainShowEngine: TMenuItem;
    milistOpenFile: TMenuItem;
    milistOpenURL: TMenuItem;
    mimainRestartAllLater: TMenuItem;
    milistRestartLater: TMenuItem;
    milistSteepUp: TMenuItem;
    mimainFile: TMenuItem;
    milistSteepDown: TMenuItem;
    milistToUp: TMenuItem;
    milistToDown: TMenuItem;
    micommandFollow: TMenuItem;
    mimainImportDown: TMenuItem;
    mimainExportDown: TMenuItem;
    mimainStartQueue: TMenuItem;
    mimainStopQueue: TMenuItem;
    milistClearLog: TMenuItem;
    miAddDown: TMenuItem;
    mimainExit: TMenuItem;
    miline9: TMenuItem;
    mitraydownStart: TMenuItem;
    miline5: TMenuItem;
    miline6: TMenuItem;
    miline7: TMenuItem;
    miline8: TMenuItem;
    miline10: TMenuItem;
    miline11: TMenuItem;
    miline12: TMenuItem;
    miline13: TMenuItem;
    mimainTools: TMenuItem;
    miline2: TMenuItem;
    mitraydownStop: TMenuItem;
    mitrydownHide: TMenuItem;
    miline1: TMenuItem;
    miline4: TMenuItem;
    miline15: TMenuItem;
    miline16: TMenuItem;
    miline19: TMenuItem;
    miline20: TMenuItem;
    miline22: TMenuItem;
    mimainConfig: TMenuItem;
    miline23: TMenuItem;
    miline21: TMenuItem;
    mimainShowDate: TMenuItem;
    mitreeAddQueue: TMenuItem;
    mitreeDeleteQueue: TMenuItem;
    mitreeRenameQueue: TMenuItem;
    milistSendToQueue: TMenuItem;
    miline17: TMenuItem;
    mimainAddGrabber: TMenuItem;
    miAddGrabber: TMenuItem;
    mimainHelp: TMenuItem;
    miline14: TMenuItem;
    mimainHomePage: TMenuItem;
    milistShowTrayIcon: TMenuItem;
    miline18: TMenuItem;
    miline24: TMenuItem;
    mitreeStartQueue: TMenuItem;
    mitreeStopQueue: TMenuItem;
    milistCopyFiles: TMenuItem;
    milistDeleteDownDisk: TMenuItem;
    mimainDeleteDownDisk: TMenuItem;
    odlgImportdown: TOpenDialog;
    psVertical: TPairSplitter;
    psHorizontal: TPairSplitter;
    psVerticalUpSide: TPairSplitterSide;
    psVerticalDownSide: TPairSplitterSide;
    psHorizontalLeftSide: TPairSplitterSide;
    psHorizontalRightSide: TPairSplitterSide;
    pmTrayIcon: TPopupMenu;
    pmDownList: TPopupMenu;
    pmTreeView: TPopupMenu;
    pmTrayDown: TPopupMenu;
    pmCommandOut: TPopupMenu;
    pbMain: TProgressBar;
    sdlgExportDown: TSaveDialog;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    seMaxDownInProgress: TSpinEdit;
    SynEdit1: TSynEdit;
    SynUNIXShellScriptSyn1: TSynUNIXShellScriptSyn;
    AutoSaveTimer: TTimer;
    ClipboardTimer: TTimer;
    FirstStartTimer: TTimer;
    tbrMain: TToolBar;
    tbAddDown: TToolButton;
    tbSeparator3: TToolButton;
    tbStopQueue: TToolButton;
    tbStopAll: TToolButton;
    tbSeparator4: TToolButton;
    tbStartScheduler: TToolButton;
    tbStopScheduler: TToolButton;
    tbExit: TToolButton;
    tbSeparator5: TToolButton;
    tbSteepUp: TToolButton;
    tbDeleteDown: TToolButton;
    tbSteepDown: TToolButton;
    tbSeparator6: TToolButton;
    tbRestartNow: TToolButton;
    tbToUp: TToolButton;
    tbToDown: TToolButton;
    tbImportDown: TToolButton;
    tbExportDown: TToolButton;
    tbSeparator7: TToolButton;
    tbAddGrabber: TToolButton;
    tbSeparator8: TToolButton;
    tbStartDown: TToolButton;
    tbSeparator9: TToolButton;
    tbClipBoard: TToolButton;
    tbRestartLater: TToolButton;
    tbDelDownDisk: TToolButton;
    tbStopDown: TToolButton;
    tbSeparator1: TToolButton;
    tbSeparator2: TToolButton;
    tbConfig: TToolButton;
    tbScheduler: TToolButton;
    tbStartQueue: TToolButton;
    MainTrayIcon: TTrayIcon;
    tvMain: TTreeView;
    UniqueInstance1: TUniqueInstance;
    procedure ApplicationProperties1Exception(Sender: TObject; E: Exception);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure lvMainClick(Sender: TObject);
    procedure lvMainColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvMainContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure lvMainDblClick(Sender: TObject);
    procedure lvMainKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvMainSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lvFilterClick(Sender: TObject);
    procedure lvFilterSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure milistMoveFilesClick(Sender: TObject);
    procedure micommandClearClick(Sender: TObject);
    procedure micommandCopyClick(Sender: TObject);
    procedure micommandSelectAllClick(Sender: TObject);
    procedure mimainShowTreeClick(Sender: TObject);
    procedure mimainAboutClick(Sender: TObject);
    procedure milistPropertiesClick(Sender: TObject);
    procedure milistCopyURLClick(Sender: TObject);
    procedure milistDeleteDownClick(Sender: TObject);
    procedure miStopAllClick(Sender: TObject);
    procedure mimainSchedulerClick(Sender: TObject);
    procedure mimainAddDownClick(Sender: TObject);
    procedure mimainDeleteDownClick(Sender: TObject);
    procedure mimainSelectAllClick(Sender: TObject);
    procedure miShowMainFormClick(Sender: TObject);
    procedure mimainUnselectAllClick(Sender: TObject);
    procedure mimainStartAllClick(Sender: TObject);
    procedure mimainStopAllClick(Sender: TObject);
    procedure mimainShowCurrentClick(Sender: TObject);
    procedure mimainShowParametersClick(Sender: TObject);
    procedure mimainShowGridClick(Sender: TObject);
    procedure milistOpenLogClick(Sender: TObject);
    procedure milistStartDownClick(Sender: TObject);
    procedure milistStopDownClick(Sender: TObject);
    procedure milistRestartNowClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure mimainRestartAllNowClick(Sender: TObject);
    procedure mimainDeleteAllClick(Sender: TObject);
    procedure mimainShowCommandClick(Sender: TObject);
    procedure milistOpenDestinationClick(Sender: TObject);
    procedure mimainShowStateClick(Sender: TObject);
    procedure mimainShowNameClick(Sender: TObject);
    procedure mimainShowSizeClick(Sender: TObject);
    procedure mimainShowURLClick(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure mimainShowSpeedClick(Sender: TObject);
    procedure mimainShowPercentClick(Sender: TObject);
    procedure mimainShowEstimatedClick(Sender: TObject);
    procedure mimainShowDestinationClick(Sender: TObject);
    procedure mimainShowEngineClick(Sender: TObject);
    procedure milistOpenFileClick(Sender: TObject);
    procedure milistOpenURLClick(Sender: TObject);
    procedure mimainRestartAllLaterClick(Sender: TObject);
    procedure milistRestartLaterClick(Sender: TObject);
    procedure milistSteepUpClick(Sender: TObject);
    procedure mimainShowTrayDownsClick(Sender: TObject);
    procedure milistSteepDownClick(Sender: TObject);
    procedure milistToUpClick(Sender: TObject);
    procedure milistToDownClick(Sender: TObject);
    procedure micommandFollowClick(Sender: TObject);
    procedure mimainImportDownClick(Sender: TObject);
    procedure mimainExportDownClick(Sender: TObject);
    procedure mimainStartQueueClick(Sender: TObject);
    procedure mimainStopQueueClick(Sender: TObject);
    procedure milistClearLogClick(Sender: TObject);
    procedure miAddDownClick(Sender: TObject);
    procedure MenuItem60Click(Sender: TObject);
    procedure mitraydownStartClick(Sender: TObject);
    procedure mimainExitClick(Sender: TObject);
    procedure mitraydownStopClick(Sender: TObject);
    procedure mitrydownHideClick(Sender: TObject);
    procedure mimainShowDateClick(Sender: TObject);
    procedure mitreeAddQueueClick(Sender: TObject);
    procedure mitreeDeleteQueueClick(Sender: TObject);
    procedure mitreeRenameQueueClick(Sender: TObject);
    procedure mimainAddGrabberClick(Sender: TObject);
    procedure miAddGrabberClick(Sender: TObject);
    procedure mimainConfigClick(Sender: TObject);
    procedure mimainHomePageClick(Sender: TObject);
    procedure milistShowTrayIconClick(Sender: TObject);
    procedure mitreeStartQueueClick(Sender: TObject);
    procedure mitreeStopQueueClick(Sender: TObject);
    procedure milistCopyFilesClick(Sender: TObject);
    procedure milistDeleteDownDiskClick(Sender: TObject);
    procedure mimainDeleteDownDiskClick(Sender: TObject);
    procedure psVerticalChangeBounds(Sender: TObject);
    procedure psVerticalMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure psVerticalResize(Sender: TObject);
    procedure psHorizontalChangeBounds(Sender: TObject);
    procedure psHorizontalMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure psHorizontalResize(Sender: TObject);
    procedure psHorizontalLeftSideMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure psHorizontalLeftSideResize(Sender: TObject);
    procedure pmCommandOutPopup(Sender: TObject);
    procedure AutoSaveTimerTimer(Sender: TObject);
    procedure ClipboardTimerStartTimer(Sender: TObject);
    procedure ClipboardTimerStopTimer(Sender: TObject);
    procedure ClipboardTimerTimer(Sender: TObject);
    procedure FirstStartTimerTimer(Sender: TObject);
    procedure tbStopQueueClick(Sender: TObject);
    procedure tbStopAllClick(Sender: TObject);
    procedure ToolButton14Click(Sender: TObject);
    procedure tbStartSchedulerClick(Sender: TObject);
    procedure tbStopSchedulerClick(Sender: TObject);
    procedure tbExitClick(Sender: TObject);
    procedure tbSteepUpClick(Sender: TObject);
    procedure tbAddDownClick(Sender: TObject);
    procedure tbSteepDownClick(Sender: TObject);
    procedure tbRestartNowClick(Sender: TObject);
    procedure tbToUpClick(Sender: TObject);
    procedure tbToDownClick(Sender: TObject);
    procedure tbImportDownClick(Sender: TObject);
    procedure tbExportDownClick(Sender: TObject);
    procedure tbAddGrabberClick(Sender: TObject);
    procedure tbDeleteDownClick(Sender: TObject);
    procedure tbClipBoardClick(Sender: TObject);
    procedure tbDelDownDiskClick(Sender: TObject);
    procedure tbStartDownClick(Sender: TObject);
    procedure tbStopDownClick(Sender: TObject);
    procedure tbConfigClick(Sender: TObject);
    procedure tbSchedulerClick(Sender: TObject);
    procedure tbStartQueueClick(Sender: TObject);
    procedure MainTrayIconClick(Sender: TObject);
    procedure MainTrayIconDblClick(Sender: TObject);
    procedure MainTrayIconMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure tvMainContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure tvMainDblClick(Sender: TObject);
    procedure tvMainEdited(Sender: TObject; Node: TTreeNode; var S: string);
    procedure tvMainEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure tvMainKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tvMainSelectionChanged(Sender: TObject);
    procedure UniqueInstance1OtherInstance(Sender: TObject;
      ParamCount: Integer; Parameters: array of String);
  private
    { private declarations }
  public
    { public declarations }
  end;
  type
  queuemenu=class(TMenuItem)
  procedure sendtoqueue(Sender:TObject);
  end;

  type
  stqueuemenu=class(TMenuItem)
  procedure startstopqueue(Sender:TObject);
  private
  stqindex:integer;
  end;

  type
  downtrayicon=class(TTrayIcon)
  procedure showinmain(Sender:TObject);
  procedure contextmenu(Sender:TObject;Boton:TMouseButton;SShift:TShiftState;X:LongInt;Y:LongInt);
  private
  downindex:integer;
  end;

  type
  queuetimer=class(TTimer)
  procedure ontime(Sender:TObject);
  procedure ontimestart(Sender:TObject);
  procedure ontimestop(Sender:TObject);
  private
  qtindex:integer;
  end;

  type
  sheduletimer=class(TTimer)
  procedure onstime(Sender:TObject);
  procedure onstimestart(Sender:TObject);
  procedure onstimestop(Sender:TObject);
  private
  stindex:integer;
  end;


var
  frmain: Tfrmain;
  wtp:TProcess;
  onestart:boolean=true;
  hilo:array of DownThread;
  copywork:array of copythread;
  phttp,phttpport,phttps,phttpsport,pftp,pftpport,nphost,puser,ppassword,cntlmhost,cntlmport:string;
  useproxy:integer;
  useaut:boolean;
  shownotifi:boolean;
  hiddenotifi:integer;
  notifipos:integer;
  ddowndir:string='';
  clipboardmonitor:boolean;
  //columnstatus 1=in progress, 2=Stopped, 3=Complete, 4=Error
  columnname,columnurl,columnpercent,columnsize,columncurrent,columnspeed,columnestimate, columndate, columndestiny,columnengine,columnparameters,columnuser,columnpass,columnstatus,columnid, columntries, columnuid, columntype, columnqueue, columncookie, columnreferer, columnpost, columnheader, columnuseragent:integer;
  columncolaw,columnnamew,columnurlw,columnpercentw,columnsizew,columncurrentw,columnspeedw,columnestimatew,columndatew,columndestinyw,columnenginew,columnparametersw:integer;
  columncolav,columnnamev,columnurlv,columnpercentv,columnsizev,columncurrentv,columnspeedv,columnestimatev,columndatev,columndestinyv,columnenginev,columnparametersv:boolean;
  limited:boolean;
  speedlimit:string;
  maxgdown,dtries,dtimeout,ddelay:integer;
  showstdout:boolean;
  wgetrutebin,aria2crutebin,curlrutebin,axelrutebin,lftprutebin:UTF8string;
  wgetargs,aria2cargs,curlargs,axelargs,lftpargs:ansistring;
  wgetdefcontinue,wgetdefnh,wgetdefnd,wgetdefncert:boolean;
  aria2cdefcontinue,aria2cdefallocate:boolean;
  aria2splitsize:string;
  aria2splitnum:integer;
  aria2split:boolean;
  lftpdefcontinue,curldefcontinue:boolean;
  autostartwithsystem, autostartminimized:boolean;
  configpath,datapath:string;
  logger:boolean;
  logpath:string;
  showgridlines,showcommandout,showtreeviewpanel:boolean;
  splitpos,splithpos:integer;
  lastmainwindowstate:TWindowstate;
  firsttime:boolean;
  hilosnd:soundthread;
  deflanguage:string;
  firststart:boolean;
  defaultengine:string;
  playsounds:boolean;
  downcompsound,downstopsound:string;
  sheduledisablelimits:boolean;
  queuerotate:boolean;
  triesrotate:integer;
  rotatemode:integer;
  queuedelay:integer;
  sameproxyforall:boolean;
  sameclip:string='';
  loadhistorylog:boolean;
  loadhistorymode:integer;
  defaultdirmode:integer;
  queues:array of integer;
  queuestartdates:array of TDate;
  queuestopdates:array of TDate;
  queuestarttimes:array of TTime;
  queuestoptimes:array of TTime;
  queuenames:array of string;
  qdomingo,qlunes,qmartes,qmiercoles,qjueves,qviernes,qsabado:array of boolean;
  qstop:array of boolean;
  qallday:array of boolean;
  qtimer:array of queuetimer;
  stimer:array of sheduletimer;
  qtimerenable:array of boolean;
  queuemanual:array of boolean;
  queuelimits:array of boolean;
  queuepoweroff:array of boolean;
  queuesheduledone:array of boolean;
  queuestmp:array of integer;
  queuestartdatestmp:array of TDate;
  queuestopdatestmp:array of TDate;
  queuestarttimestmp:array of TTime;
  queuestoptimestmp:array of TTime;
  queuenamestmp:array of string;
  qdomingotmp,qlunestmp,qmartestmp,qmiercolestmp,qjuevestmp,qviernestmp,qsabadotmp:array of boolean;
  qstoptmp:array of boolean;
  qalldaytmp:array of boolean;
  qtimertmp:array of queuetimer;
  stimertmp:array of sheduletimer;
  qtimerenabletmp:array of boolean;
  queuemanualtmp:array of boolean;
  queuelimitstmp:array of boolean;
  queuepowerofftmp:array of boolean;
  queuesheduledonetmp:array of boolean;
  shutingdown:boolean=false;
  trayicons:array of downtrayicon;
  showdowntrayicon:boolean;
  numtraydown:integer;
  categoryextencions:array of TStringList;
  dotherdowndir:string;
  useglobaluseragent:boolean;
  globaluseragent:string;
  portablemode:boolean;
  notiforms:Tfrnotification;
  function urlexists(url:string):boolean;
  function destinyexists(destiny:string;newurl:string=''):boolean;
  function suggestdir(doc:string):string;
  procedure playsound(soundfile:string);
  procedure newqueue();
  procedure setconfig();
  procedure enginereload();
  procedure configdlg();
  procedure poweroff;
  procedure savemydownloads;
  procedure stopqueue(indice:integer);
  procedure setfirefoxintegration();
  procedure createnewnotifi(title:string;name:string;note:string;fpath:string;ok:boolean;simulation:integer=-1);
  procedure categoryreload();
implementation
{$R *.lfm}
{ Tfrmain }
resourcestring
startqueuesystray='Start queue';
stopqueuesystray='Stop queue';
//folderdownname='Downloads';
categorycompressed='Compressed';
categoryprograms='Programs';
categoryimages='Images';
categorydocuments='Documents';
categoryvideos='Videos';
categorymusic='Music';
categoryothers='Others';
categoryfilter='Categories';
abouttext='This program is free software under GNU GPL 2 license.'+
#10#13+'Created By Reinier Romero Mir'+
#13+'Email: nenirey@gmail.com'+
#13+'Copyright (c) 2015'+
#13+'The project uses the following third party resources:'+
#10#13+'Silk icons set 1.3 by Mark James'+
#13+'http://www.famfamfam.com/lab/icons/silk/'+
#13+'Tango Icon Library'+
#13+'http://tango.freedesktop.org/Tango_Icon_Library'+
#13+'aria2'+
#13+'http://aria2.sourceforge.net/'+
#13+'Wget'+
#13+'http://www.gnu.org/software/wget/'
+#13+'cURL'+
#13+'http://curl.haxx.se/'+
#13+'Axel'+
#13+'http://axel.alioth.debian.org/'+
#10#13+'French translation: '+
#10+'Tony O Gallos @ CodeTyphon Community';
wgetdefarg1='[-c] Continue downloads.';
wgetdefarg2='[-nH] No create host dir.';
wgetdefarg3='[-nd] No create out dir.';
wgetdefarg4='[--no-check-certificate] No check SSL.';
aria2defarg1='[-c] Continue downloads';
aria2defarg2='[--file-allocation=none] No allocate space.';
curldefarg1='[-C -] Continue downloads.';
firefoxintegration='Do you want to enable firefox integration?';
transfromlabel='From: %S';
transdestinationlabel='To: %S';
fileexistsreplacetext='The file "%S" already exists, do you want to replace it?';
fileoperationcopy='Coping file(s)...';
fileoperationmove='Moving file(s)...';

function strshort(str:string;maxlength:integer):string;
begin
  if Length(str)>maxlength then
  begin
    str:=Copy(str,0,Round((maxlength/2)-3))+'...'+Copy(str,Round((Length(str)/2)),Length(str));
    result:=str;
  end
  else
    result:=str;
end;

Constructor copythread.Create(CreateSuspended:boolean;idform:integer;deletesource:boolean=false);
begin
  Inherited Create(true);
  canceling:=false;
  pform:=Tfrcopymove.Create(nil);
  source:=TStringList.Create;
  findex:=0;
  pform.id:=idform;
  delsrc:=deletesource;
  if deletesource then
    pform.Caption:=fileoperationmove
  else
    pform.Caption:=fileoperationcopy;
  pform.Show;
end;

procedure copythread.Execute;
var
  FromF, ToF : TFileStream;
  Buffer: array[0..$10000 -1] of byte;
  NumRead,i: Integer;
begin
  for i:=0 to source.Count-1 do
  begin
    findex:=i;
    FromF := TFileStream.Create(UTF8ToSys(Source[i]), fmOpenRead or fmShareDenyNone);
    try
      try
        synchronize(@update);
        if FileExists(UTF8ToSys(Destination+pathdelim+ExtractFilename(Source[i]))) then
        begin
        synchronize(@confirm);
        if dlgcuestion then
        begin
          ToF := TFileStream.Create(UTF8ToSys(Destination+pathdelim+ExtractFilename(Source[i])), fmOpenReadWrite or fmShareDenyWrite);
          ToF.Size:=0;
        end
        else
        begin
          if i = source.Count-1 then
            canceling:=true;
          continue;
        end;
        end
        else
          ToF := TFileStream.Create(UTF8ToSys(Destination+pathdelim+ExtractFilename(Source[i])), fmCreate);
        try
          ToF.Position := 0;
          FromF.Position := 0;
          NumRead := FromF.Read(Buffer[0], $10000);
          while (NumRead > 0) and (self.canceling=false) do begin
            ToF.Write(Buffer[0], NumRead);
            NumRead := FromF.Read(Buffer[0], $10000);
            percent:=Round((ToF.Size/FromF.Size) * 100);
            synchronize(@update);
          end;
        finally
          ToF.Free;
        end;
      finally
        FromF.Free;
      end;

    except on e:exception do
    begin
    synchronize(@prepare);
    canceling:=true;
    end;
    end;
    try
      if delsrc and (canceling=false) and FileExists(UTF8ToSys(Source[i])) then
        DeleteFile(UTF8ToSys(Source[i]));
    except on e:exception do
    end;
  end;
  source.Free;
  synchronize(@prepare);
end;

procedure copythread.update;
begin
  pform.ProgressBar1.Position:=percent;
  if delsrc then
    pform.Caption:=inttostr(percent)+'% '+inttostr(findex+1)+'/'+inttostr(source.Count)+' '+fileoperationmove
  else
    pform.Caption:=inttostr(percent)+'% '+inttostr(findex+1)+'/'+inttostr(source.Count)+' '+fileoperationcopy;
  pform.Label1.Caption:=strshort(format(transfromlabel,[source[findex]]),90);
  pform.Label2.Caption:=strshort(format(transdestinationlabel,[destination+pathdelim+ExtractFilename(Source[findex])]),90);
end;

procedure copythread.confirm;
begin
  frconfirm.dlgtext.Caption:=format(fileexistsreplacetext,[ExtractFileName(source[findex])]);
  frconfirm.ShowModal;
end;

procedure copythread.prepare;
begin
 if percent=100 then
   pform.Hide
 else
 begin
   if (self.canceling=false) then
     ShowMessage('Error saving file!!!');
   pform.Hide;
 end;
 self.Terminate;
end;

procedure copythread.stop;
begin
 canceling:=true;
end;

procedure createnewnotifi(title:string;name:string;note:string;fpath:string;ok:boolean;simulation:integer=-1);
var
  ABitmap:TBitmap;
  posicion:integer;
begin
  notiforms:=Tfrnotification.Create(nil);
  ABitmap:=TBitmap.Create;
  ABitmap.Monochrome:=true;
  ABitmap.Width:=notiforms.Width;
  ABitmap.Height:=notiforms.Height;
  ABitmap.Canvas.Brush.Color:=clBlack;
  ABitmap.Canvas.FillRect(0, 0, notiforms.Width, notiforms.Height);
  ABitmap.Canvas.Brush.Color:=clWhite;
  ABitmap.Canvas.RoundRect(0, 0, notiforms.Width, notiforms.Height, 20, 20);
  notiforms.SpeedButton1.Enabled:=ok;
  notiforms.SpeedButton2.Enabled:=ok;
  notiforms.SpeedButton4.Enabled:=ok;
  notiforms.SpeedButton5.Enabled:=ok;
  notiforms.SpeedButton1.OnClick:=notiforms.SpeedButton1.OnClick;
  notiforms.SpeedButton2.OnClick:=notiforms.SpeedButton2.OnClick;
  notiforms.SpeedButton3.OnClick:=notiforms.SpeedButton3.OnClick;
  notiforms.SpeedButton4.OnClick:=notiforms.SpeedButton4.OnClick;
  notiforms.SpeedButton5.OnClick:=notiforms.SpeedButton5.OnClick;
  notiforms.OnMouseEnter:=notiforms.OnMouseEnter;
  notiforms.OnMouseLeave:=notiforms.OnMouseLeave;
  notiforms.OnClick:=notiforms.OnClick;
  notiforms.Label1.Caption:=name;
  notiforms.Label2.Caption:=note;
  notiforms.Label3.Caption:=title;
  notiforms.Label2.Hint:=note;
  notiforms.notipathfile:=fpath;
  if simulation<>-1 then
    posicion:=simulation
  else
    posicion:=notifipos;
  case posicion of
        0: begin notiforms.Left:=0;notiforms.Top:=0;end;
        1: begin notiforms.Left:=Round(Screen.Width/4);notiforms.Top:=0;end;
        2: begin notiforms.Left:=Screen.Width-notiforms.Width;notiforms.Top:=0;end;
        3: begin notiforms.Left:=0;notiforms.Top:=Round(Screen.Height/3);end;
        4: begin notiforms.Left:=Round(Screen.Width/4);notiforms.Top:=Round(Screen.Height/3);end;
        5: begin notiforms.Left:=Screen.Width-notiforms.Width;notiforms.Top:=Round(Screen.Height/3);end;
        6: begin notiforms.Left:=0;notiforms.Top:=Screen.Height-notiforms.Height;end;
        7: begin notiforms.Left:=Round(Screen.Width/4);notiforms.Top:=Screen.Height-notiforms.Height;end;
        8: begin notiforms.Left:=Screen.Width-notiforms.Width;notiforms.Top:=Screen.Height-notiforms.Height;end;
      end;
  notiforms.Timer1.Interval:=hiddenotifi*1000;
  notiforms.Timer1.Enabled:=true;
  notiforms.Show;
  notiforms.SetShape(ABitmap);
  ABitmap.Free;
end;

function prettysize(size:float;format:string;const Digits: TRoundToRange = -1;coma:string=','):string;
var
  tempstr:string='';
begin
  case format of
  'wget':
    begin
     if(size<1024) then
       tempstr:=floattostr(size)+'B';
     if(size>=1024) then
       tempstr:=floattostr(SimpleRoundTo(size/1024,Digits))+'K';
     if(size>=(1024*1024)) then
       tempstr:=floattostr(SimpleRoundTo(size/1024/1024,Digits))+'M';
     if(size>=(1024*1024*1024)) then
       tempstr:=floattostr(SimpleRoundTo(size/1024/1024/1024,Digits))+'G';
     if(size>=(1024*1024*1024*1024)) then
       tempstr:=floattostr(SimpleRoundTo(size/1024/1024/1024/1024,Digits))+'T';
     {tempstr:=StringReplace(tempstr,',','.',[rfReplaceAll]);
     if Pos('.',tempstr)>=1 then
     begin
       tempstr:=StringReplace(tempstr,'K','.0K',[rfReplaceAll]);
       tempstr:=StringReplace(tempstr,'M','.0M',[rfReplaceAll]);
       tempstr:=StringReplace(tempstr,'G','.0G',[rfReplaceAll]);
       tempstr:=StringReplace(tempstr,'T','.0T',[rfReplaceAll]);
     end;
     if Pos(',',tempstr)>=1 then
     begin
       tempstr:=StringReplace(tempstr,'K',',0K',[rfReplaceAll]);
       tempstr:=StringReplace(tempstr,'M',',0M',[rfReplaceAll]);
       tempstr:=StringReplace(tempstr,'G',',0G',[rfReplaceAll]);
       tempstr:=StringReplace(tempstr,'T',',0T',[rfReplaceAll]);
     end;}
    end;
  'aria2c':
    begin
     if(size<1024) then
       tempstr:=floattostr(size)+'B';
     if(size>=1024) then
       tempstr:=floattostr(SimpleRoundTo(size/1024,Digits))+'KiB';
     if(size>=(1024*1024)) then
       tempstr:=floattostr(SimpleRoundTo(size/1024/1024,Digits))+'MiB';
     if(size>=(1024*1024*1024)) then
       tempstr:=floattostr(SimpleRoundTo(size/1024/1024/1024,Digits))+'GiB';
     if(size>=(1024*1024*1024*1024)) then
       tempstr:=floattostr(SimpleRoundTo(size/1024/1024/1024/1024,Digits))+'TiB';
     tempstr:=StringReplace(tempstr,',','.',[rfReplaceAll]);
    end;
  'curl':
    begin
     if(size<1024) then
       tempstr:=floattostr(size)+' b';
     if(size>=1024*10) then
       tempstr:=floattostr(SimpleRoundTo(size/1024,0))+'k';
     if(size>=(1024*1024)*10) then
       tempstr:=floattostr(SimpleRoundTo(size/1024/1024,Digits))+'M';
     if(size>=(1024*1024*1024)*10) then
       tempstr:=floattostr(SimpleRoundTo(size/1024/1024/1024,Digits))+'G';
     if(size>=(1024*1024*1024*1024)*10) then
       tempstr:=floattostr(SimpleRoundTo(size/1024/1024/1024/1024,Digits))+'T';
     tempstr:=StringReplace(tempstr,',','.',[rfReplaceAll]);
    end;
  else
    if(size<1024) then
      tempstr:=floattostr(size)+' B';
    if(size>=1024) then
      tempstr:=floattostr(SimpleRoundTo(size/1024,Digits))+' KB';
    if(size>=(1024*1024)) then
      tempstr:=floattostr(SimpleRoundTo(size/1024/1024,Digits))+' MB';
    if(size>=(1024*1024*1024)) then
      tempstr:=floattostr(SimpleRoundTo(size/1024/1024/1024,Digits))+' GB';
    if(size>=(1024*1024*1024*1024)) then
      tempstr:=floattostr(SimpleRoundTo(size/1024/1024/1024/1024,Digits))+' TB';
  end;
  tempstr:=StringReplace(tempstr,',',coma,[rfReplaceAll]);
  tempstr:=StringReplace(tempstr,'.',coma,[rfReplaceAll]);
  result:=tempstr;
end;

procedure refreshicons;
var
  x:integer;
begin
  for x:=0 to Length(trayicons)-1 do
  begin
    if Assigned(trayicons[x]) then
    begin
      trayicons[x].Icon.Clear;
      trayicons[x].Visible:=false;
    end
   else
    begin
      trayicons[x]:=downtrayicon.Create(nil);
      trayicons[x].Icon.Clear;
      trayicons[x].Visible:=false;
      trayicons[x].downindex:=x;
      trayicons[x].OnMouseDown:=@trayicons[x].contextmenu;
      trayicons[x].PopUpMenu:=frmain.pmTrayDown;
      trayicons[x].OnDblClick:=@trayicons[x].showinmain;
    end;
    if x<frmain.lvMain.Items.Count then
    begin
      if (frmain.lvMain.Items[x].SubItems[columnstatus]='1') and showdowntrayicon then
        trayicons[x].Show;
    end;
  end;
end;

function suggestdir(doc:string):string;
var
  i,x:integer;
  e:string;
begin
  if not DirectoryExists(ddowndir) then
    CreateDir(UTF8ToSys(ddowndir));
  e:=UpperCase(Copy(doc,LastDelimiter('.',doc)+1,Length(doc)));
  result:=dotherdowndir;
  for i:=0 to Length(categoryextencions)-1 do
  begin
    for x:=2 to categoryextencions[i].Count-1 do
    begin
      if UpperCase(categoryextencions[i][x])=e then
        result:=categoryextencions[i][0];
    end;
  end;
  if not DirectoryExists(result) then
    SysUtils.CreateDir(UTF8ToSys(result));
end;

function findcategoryall(doc:string):boolean;
var
  i,x:integer;
  e:string;
begin
  e:=UpperCase(Copy(doc,LastDelimiter('.',doc)+1,Length(doc)));
  result:=false;
  for i:=0 to Length(categoryextencions)-1 do
  begin
    for x:=2 to categoryextencions[i].Count-1 do
    begin
      if UpperCase(categoryextencions[i][x])=e then
        result:=true;
    end;
  end;
end;

function findcategorydir(catindex:integer;doc:string):boolean;
var
  x:integer;
  e:string;
begin
e:=UpperCase(Copy(doc,LastDelimiter('.',doc)+1,Length(doc)));
result:=false;
 for x:=2 to categoryextencions[catindex].Count-1 do
 begin
  if UpperCase(categoryextencions[catindex][x])=e then
    result:=true;
 end;
end;

procedure defaultcategory();
begin
  SetLength(categoryextencions,6);
  categoryextencions[0]:=TStringList.Create;
  categoryextencions[0].Add(ddowndir+pathdelim+'Compressed');
  categoryextencions[0].Add(categorycompressed);
  categoryextencions[0].AddStrings(['ZIP','RAR','7Z','7ZIP','CAB','GZ','TAR','XZ','BZ2','LZMA']);
  categoryextencions[1]:=TStringList.Create;
  categoryextencions[1].Add(ddowndir+pathdelim+'Programs');
  categoryextencions[1].Add(categoryprograms);
  categoryextencions[1].AddStrings(['EXE','MSI','COM','BAT','PY','SH','HTA','JAR','APK','DMG']);
  categoryextencions[2]:=TStringList.Create;
  categoryextencions[2].Add(ddowndir+pathdelim+'Images');
  categoryextencions[2].Add(categoryimages);
  categoryextencions[2].AddStrings(['JPG','JPE','JPEG','PNG','GIF','BMP','ICO','CUR','ANI']);
  categoryextencions[3]:=TStringList.Create;
  categoryextencions[3].Add(ddowndir+pathdelim+'Documents');
  categoryextencions[3].Add(categorydocuments);
  categoryextencions[3].AddStrings(['DOC','DOCX','XLS','XLSX','PPT','PPS','PPTX','PPSX','TXT','PDF','HTM','HTML','MHT','RTF','ODF','ODT','ODS','PHP']);
  categoryextencions[4]:=TStringList.Create;
  categoryextencions[4].Add(ddowndir+pathdelim+'Videos');
  categoryextencions[4].Add(categoryvideos);
  categoryextencions[4].AddStrings(['MPG','MPE','MPEG','MP4','MOV','FLV','AVI','ASF','WMV','MKV','VOB','IFO','RMVB','DIVX','3GP','3GP2','SWF','MPV','M4V','WEBM','AMV']);
  categoryextencions[5]:=TStringList.Create;
  categoryextencions[5].Add(ddowndir+pathdelim+'Music');
  categoryextencions[5].Add(categorymusic);
  categoryextencions[5].AddStrings(['MP3','OGG','WAV','WMA','AMR','MIDI']);
end;

function finduid(uid:string):integer;
var
  i:integer;
begin
  result:=0;
  for i:=0 to frmain.lvFilter.Items.Count-1 do
  begin
    if frmain.lvFilter.Items[i].SubItems[columnuid]=uid then
      result:=i;
  end;
end;

procedure newdownqueues();
var
  i:integer;
begin
  frnewdown.ComboBox2.Items.Clear;
  for i:=0 to Length(queues)-1 do
    frnewdown.ComboBox2.Items.Add(queuenames[i]);
end;

procedure newgrabberqueues();
var
  i:integer;
begin
  frsitegrabber.ComboBox1.Items.Clear;
  for i:=0 to Length(queues)-1 do
    frsitegrabber.ComboBox1.Items.Add(queuenames[i]);
end;

procedure queueindexselect();
begin
  frnewdown.ComboBox2.ItemIndex:=0;
  frsitegrabber.ComboBox1.ItemIndex:=0;
  if (frmain.tvMain.SelectionCount>0) then
  begin
    if frmain.tvMain.Selected.Level>0 then
    begin
      case frmain.tvMain.Selected.Parent.Index of
        1:begin//colas
            frnewdown.ComboBox2.ItemIndex:=frmain.tvMain.Selected.Index;
            frsitegrabber.ComboBox1.ItemIndex:=frmain.tvMain.Selected.Index;
          end;
      end;
    end;
  end;
end;

procedure queuemenu.sendtoqueue(Sender:TObject);
var
  i:integer;
begin
  if (frmain.lvMain.ItemIndex<>-1) or (frmain.lvMain.SelCount>0) then
  begin
    for i:=0 to frmain.lvMain.Items.Count-1 do
    begin
      if frmain.lvMain.Items[i].Selected and (frmain.milistSendToQueue.IndexOf(self)<>-1) then
        frmain.lvMain.Items[i].SubItems[columnqueue]:=inttostr(frmain.milistSendToQueue.IndexOf(self));
    end;
  end;
  frmain.tvMainSelectionChanged(nil);
  savemydownloads();
end;

procedure stqueuemenu.startstopqueue(Sender:TObject);
begin
  if qtimer[self.stqindex].Enabled then
    stopqueue(self.stqindex)
  else
  begin
    queuemanual[self.stqindex]:=true;
    qtimer[self.stqindex].Interval:=1000;
    qtimer[self.stqindex].Enabled:=true;
  end;
end;


procedure queuesreload();
var
  treeitem: TTreeNode;
  menuitem: queuemenu;
  stmenu: stqueuemenu;
  i: integer;
  tmptreeindex: integer=0;
begin
  if frmain.tvMain.Items.SelectionCount>0 then
    tmptreeindex:=frmain.tvMain.Selected.AbsoluteIndex;

  frmain.tvMain.Items[1].DeleteChildren;
  frmain.milistSendToQueue.Clear;

  for i:=frmain.pmTrayIcon.Items.Count-1 downto 0 do
  begin
    if (frmain.pmTrayIcon.Items[i].ImageIndex=7) or (frmain.pmTrayIcon.Items[i].ImageIndex=8) then
      frmain.pmTrayIcon.Items.Delete(i);
  end;

  for i:=0 to Length(queues)-1 do
  begin
    qtimer[i].qtindex:=i;
    stimer[i].stindex:=i;
    treeitem:=TTreeNode.Create(frmain.tvMain.Items);
    treeitem:=frmain.tvMain.Items.AddChild(frmain.tvMain.Items[1],queuenames[i]);

    if queuemanual[i] or stimer[i].Enabled then
    begin
      if qtimer[i].Enabled then
      begin
        treeitem.ImageIndex:=46;
        treeitem.SelectedIndex:=46;
        treeitem.StateIndex:=40;
      end
      else
      begin
        treeitem.ImageIndex:=47;
        treeitem.SelectedIndex:=47;
        treeitem.StateIndex:=40;
      end;
    end
    else
    begin
      treeitem.ImageIndex:=45;
      treeitem.SelectedIndex:=45;
      treeitem.StateIndex:=40;
    end;

    menuitem:=queuemenu.Create(frmain.milistSendToQueue);
    menuitem.Caption:=queuenames[i];
    menuitem.ImageIndex:=40;
    menuitem.OnClick:=@menuitem.sendtoqueue;
    stmenu:=stqueuemenu.Create(frmain.pmTrayIcon);
    stmenu.stqindex:=i;

    if qtimer[i].Enabled then
    begin
      stmenu.Caption:=stopqueuesystray+' ('+queuenames[i]+')';
      stmenu.ImageIndex:=8;
    end
    else
    begin
      stmenu.Caption:=startqueuesystray+' ('+queuenames[i]+')';
      stmenu.ImageIndex:=7;
    end;

    stmenu.OnClick:=@stmenu.startstopqueue;
    frmain.pmTrayIcon.Items.Insert(frmain.pmTrayIcon.Items.Count-4,stmenu);
    frmain.milistSendToQueue.Add(menuitem);
  end;

  frmain.tvMain.Items[1].Expand(true);
  if (tmptreeindex>=0) and (tmptreeindex<frmain.tvMain.Items.Count) then
    frmain.tvMain.Items[tmptreeindex].Selected:=true;
end;

procedure categoryreload();
var
  treeitem:TTreeNode;
  i:integer;
begin
  frmain.tvMain.Items.TopLvlItems[3].DeleteChildren;
  if Assigned(frnewdown) then
    frnewdown.ComboBox3.Items.Clear;
  for i:=0 to Length(categoryextencions)-1 do
  begin
    treeitem:=TTreeNode.Create(frmain.tvMain.Items);
    treeitem:=frmain.tvMain.Items.AddChild(frmain.tvMain.Items.TopLvlItems[3],categoryextencions[i][1]);
    treeitem.ImageIndex:=23;
    treeitem.SelectedIndex:=23;
    if Assigned(frnewdown) then
      frnewdown.ComboBox3.Items.Add(categoryextencions[i][0]);
  end;
  treeitem:=TTreeNode.Create(frmain.tvMain.Items);
  treeitem:=frmain.tvMain.Items.AddChild(frmain.tvMain.Items.TopLvlItems[3],categoryothers);
  treeitem.ImageIndex:=23;
  treeitem.SelectedIndex:=23;
  frmain.tvMain.Items.TopLvlItems[3].Expand(true);
end;

procedure resetqtmp();
begin
  SetLength(queuestmp,0);
  SetLength(queuenamestmp,0);
  SetLength(queuestartdatestmp,0);
  SetLength(queuestopdatestmp,0);
  SetLength(queuestarttimestmp,0);
  SetLength(queuestoptimestmp,0);
  SetLength(qdomingotmp,0);
  SetLength(qlunestmp,0);
  SetLength(qmartestmp,0);
  SetLength(qmiercolestmp,0);
  SetLength(qjuevestmp,0);
  SetLength(qviernestmp,0);
  SetLength(qsabadotmp,0);
  SetLength(qstoptmp,0);
  SetLength(qalldaytmp,0);
  SetLength(qtimertmp,0);
  SetLength(stimertmp,0);
  SetLength(qtimerenabletmp,0);
  SetLength(queuemanualtmp,0);
  SetLength(queuelimitstmp,0);
  SetLength(queuepowerofftmp,0);
  SetLength(queuesheduledonetmp,0);
end;

procedure deletequeue(indice:integer);
var
  i:integer;
begin
  frconfirm.dlgtext.Caption:=frstrings.dlgdeletequeue.Caption+#10#13+#10#13+queuenames[indice];
  frconfirm.ShowModal;
  if dlgcuestion then
  begin
    qtimer[indice].OnStopTimer:=nil;
    if stimer[indice].Enabled then
      stimer[indice].Enabled:=false;
    if qtimer[indice].Enabled then
      qtimer[indice].Enabled:=false;
    if indice<>0 then
    begin
      resetqtmp();
      for i:=0 to Length(queues)-1 do
      begin
        if i<>indice then
        begin
          SetLength(queuestmp,Length(queuestmp)+1);
          SetLength(queuenamestmp,Length(queuenamestmp)+1);
          SetLength(queuestartdatestmp,Length(queuestartdatestmp)+1);
          SetLength(queuestopdatestmp,Length(queuestopdatestmp)+1);
          SetLength(queuestarttimestmp,Length(queuestarttimestmp)+1);
          SetLength(queuestoptimestmp,Length(queuestoptimestmp)+1);
          SetLength(qdomingotmp,Length(qdomingotmp)+1);
          SetLength(qlunestmp,Length(qlunestmp)+1);
          SetLength(qmartestmp,Length(qmartestmp)+1);
          SetLength(qmiercolestmp,Length(qmiercolestmp)+1);
          SetLength(qjuevestmp,Length(qjuevestmp)+1);
          SetLength(qviernestmp,Length(qviernestmp)+1);
          SetLength(qsabadotmp,Length(qsabadotmp)+1);
          SetLength(qstoptmp,Length(qstoptmp)+1);
          SetLength(qalldaytmp,Length(qalldaytmp)+1);
          SetLength(qtimertmp,Length(qtimertmp)+1);
          SetLength(stimertmp,Length(stimertmp)+1);
          SetLength(qtimerenabletmp,Length(qtimerenabletmp)+1);
          SetLength(queuemanualtmp,Length(queuemanualtmp)+1);
          SetLength(queuelimitstmp,Length(queuelimitstmp)+1);
          SetLength(queuepowerofftmp,Length(queuepowerofftmp)+1);
          SetLength(queuesheduledonetmp,Length(queuesheduledonetmp)+1);

          queuestmp[Length(queuestmp)-1]:=queues[i];
          queuenamestmp[Length(queuenamestmp)-1]:=queuenames[i];
          queuestartdatestmp[Length(queuestartdatestmp)-1]:=queuestartdates[i];
          queuestopdatestmp[Length(queuestopdatestmp)-1]:=queuestopdates[i];
          queuestarttimestmp[Length(queuestarttimestmp)-1]:=queuestarttimes[i];
          queuestoptimestmp[Length(queuestoptimestmp)-1]:=queuestoptimes[i];
          qdomingotmp[Length(qdomingotmp)-1]:=qdomingo[i];
          qlunestmp[Length(qlunestmp)-1]:=qlunes[i];
          qmartestmp[Length(qmartestmp)-1]:=qmartes[i];
          qmiercolestmp[Length(qmiercolestmp)-1]:=qmiercoles[i];
          qjuevestmp[Length(qjuevestmp)-1]:=qjueves[i];
          qviernestmp[Length(qviernestmp)-1]:=qviernes[i];
          qsabadotmp[Length(qsabadotmp)-1]:=qsabado[i];
          qstoptmp[Length(qstoptmp)-1]:=qstop[i];
          qalldaytmp[Length(qalldaytmp)-1]:=qallday[i];
          qtimertmp[Length(qtimertmp)-1]:=qtimer[i];
          stimertmp[Length(stimertmp)-1]:=stimer[i];
          qtimerenabletmp[Length(qtimerenabletmp)-1]:=qtimerenable[i];
          queuemanualtmp[Length(queuemanualtmp)-1]:=queuemanual[i];
          queuelimitstmp[Length(queuelimitstmp)-1]:=queuelimits[i];
          queuepowerofftmp[Length(queuepowerofftmp)-1]:=queuepoweroff[i];
          queuesheduledonetmp[Length(queuesheduledonetmp)-1]:=queuesheduledone[i];
        end;
      end;
      queues:=queuestmp;
      queuestartdates:=queuestartdatestmp;
      queuestopdates:=queuestopdatestmp;
      queuestarttimes:=queuestarttimestmp;
      queuestoptimes:=queuestoptimestmp;
      queuenames:=queuenamestmp;
      qdomingo:=qdomingotmp;
      qlunes:=qlunestmp;
      qmartes:=qmartestmp;
      qmiercoles:=qmiercolestmp;
      qjueves:=qjuevestmp;
      qviernes:=qviernestmp;
      qsabado:=qsabadotmp;
      qstop:=qstoptmp;
      qallday:=qalldaytmp;
      qtimer:=qtimertmp;
      stimer:=stimertmp;
      qtimerenable:=qtimerenabletmp;
      queuemanual:=queuemanualtmp;
      queuelimits:=queuelimitstmp;
      queuepoweroff:=queuepowerofftmp;
      queuesheduledone:=queuesheduledonetmp;
      resetqtmp();
      frmain.tvMain.Items[1].Selected:=true;
      newdownqueues();
      queuesreload();
    end;
  end;

  for i:=0 to frmain.lvMain.Items.Count-1 do
  begin
    if frmain.lvMain.Items[i].SubItems[columnqueue]=inttostr(indice) then
      frmain.lvMain.Items[i].SubItems[columnqueue]:='0';
    if (strtoint(frmain.lvMain.Items[i].SubItems[columnqueue])>=indice) and (strtoint(frmain.lvMain.Items[i].SubItems[columnqueue])>0) then
      frmain.lvMain.Items[i].SubItems[columnqueue]:=inttostr(strtoint(frmain.lvMain.Items[i].SubItems[columnqueue])-1);
  end;
end;

procedure newqueue();
var
  nam:string;
begin
  nam:=frstrings.queuename.Caption+' '+inttostr(Length(queues)+1);

  SetLength(queues,Length(queues)+1);
  SetLength(queuenames,Length(queuenames)+1);
  SetLength(queuestartdates,Length(queuestartdates)+1);
  SetLength(queuestopdates,Length(queuestopdates)+1);
  SetLength(queuestarttimes,Length(queuestarttimes)+1);
  SetLength(queuestoptimes,Length(queuestoptimes)+1);
  SetLength(qdomingo,Length(qdomingo)+1);
  SetLength(qlunes,Length(qlunes)+1);
  SetLength(qmartes,Length(qmartes)+1);
  SetLength(qmiercoles,Length(qmiercoles)+1);
  SetLength(qjueves,Length(qjueves)+1);
  SetLength(qviernes,Length(qviernes)+1);
  SetLength(qsabado,Length(qsabado)+1);
  SetLength(qstop,Length(qstop)+1);
  SetLength(qallday,Length(qallday)+1);
  SetLength(qtimer,Length(qtimer)+1);
  SetLength(stimer,Length(stimer)+1);
  SetLength(qtimerenable,Length(qtimerenable)+1);
  SetLength(queuemanual,Length(queuemanual)+1);
  SetLength(queuelimits,Length(queuelimits)+1);
  SetLength(queuepoweroff,Length(queuepoweroff)+1);
  SetLength(queuesheduledone,Length(queuesheduledone)+1);

  //Fecha actual ya que por defecto da una muy antigua
  queuestartdates[Length(queues)-1]:=Date();
  queuestopdates[Length(queues)-1]:=Date();

  qtimer[Length(queues)-1]:=queuetimer.Create(frmain);
  qtimer[Length(queues)-1].Enabled:=false;
  qtimer[Length(queues)-1].qtindex:=Length(queues)-1;
  qtimer[Length(queues)-1].OnTimer:=@qtimer[Length(queues)-1].ontime;
  qtimer[Length(queues)-1].OnStartTimer:=@qtimer[Length(queues)-1].ontimestart;
  qtimer[Length(queues)-1].OnStopTimer:=@qtimer[Length(queues)-1].ontimestop;
  qtimer[Length(queues)-1].Interval:=1000;
  qdomingo[Length(queues)-1]:=true;
  qlunes[Length(queues)-1]:=true;
  qmartes[Length(queues)-1]:=true;
  qmiercoles[Length(queues)-1]:=true;
  qjueves[Length(queues)-1]:=true;
  qviernes[Length(queues)-1]:=true;
  qsabado[Length(queues)-1]:=true;

  stimer[Length(queues)-1]:=sheduletimer.Create(frmain);
  stimer[Length(queues)-1].Enabled:=false;
  stimer[Length(queues)-1].stindex:=Length(queues)-1;
  stimer[Length(queues)-1].OnTimer:=@stimer[Length(queues)-1].onstime;
  stimer[Length(queues)-1].OnStartTimer:=@stimer[Length(queues)-1].onstimestart;
  stimer[Length(queues)-1].OnStopTimer:=@stimer[Length(queues)-1].onstimestop;
  stimer[Length(queues)-1].Interval:=1000;

  queuenames[Length(queuenames)-1]:=nam;
  newdownqueues();
  queuesreload();
end;

procedure titlegen();
begin
  //alpha por defecto
  frmain.Caption:='AWGG '+Copy(version,0,LastDelimiter('.',version)-1)+' ALPHA BUILD '+Copy(version,LastDelimiter('.',version)+1,Length(version));

  {$IFDEF alpha}
    frmain.Caption:='AWGG '+Copy(version,0,LastDelimiter('.',version)-1)+' ALPHA BUILD '+Copy(version,LastDelimiter('.',version)+1,Length(version));
  {$ENDIF}

  {$IFDEF beta}
    frmain.Caption:='AWGG '+Copy(version,0,LastDelimiter('.',version)-1)+' BETA';
  {$ENDIF}

  {$IFDEF release}
    frmain.Caption:='AWGG '+Copy(version,0,LastDelimiter('.',version)-1);
  {$ENDIF}

  {$IFDEF alpha64}
    frmain.Caption:='AWGG '+Copy(version,0,LastDelimiter('.',version)-1)+' ALPHA BUILD '+Copy(version,LastDelimiter('.',version)+1,Length(version));
  {$ENDIF}

  {$IFDEF beta64}
    frmain.Caption:='AWGG '+Copy(version,0,LastDelimiter('.',version)-1)+' BETA';
  {$ENDIF}

  {$IFDEF release64}
    frmain.Caption:='AWGG '+Copy(version,0,LastDelimiter('.',version)-1);
  {$ENDIF}
end;
function uidexists(uid:string):boolean;
var
  n:integer;
  match:boolean;
begin
  match:=false;
  for n:=0 to frmain.lvMain.Items.Count-1 do
  begin
    if frmain.lvMain.items[n].SubItems[columnuid]=uid then
      match:=true;
  end;
  result:=match;
end;

function uidgen():string;
var
  tmpuid:integer;
begin
  tmpuid:=0;
  while (uidexists(inttostr(tmpuid))=true) do
    inc(tmpuid);
  result:=inttostr(tmpuid);
end;

function ufilename(url:string):string;
begin
  result:=Copy(url,LastDelimiter('/',url)+1,length(url));
end;

procedure stopqueue(indice:integer);
var
  n:integer;
begin
  qtimer[indice].Enabled:=false;
  for n:=0 to frmain.lvMain.Items.Count-1 do
  begin
    if (frmain.lvMain.Items[n].SubItems[columnqueue]=inttostr(indice)) and (frmain.lvMain.Items[n].SubItems[columnstatus]='1') then
      hilo[strtoint(frmain.lvMain.Items[n].SubItems[columnid])].shutdown();
  end;
end;

function urlexists(url:string):boolean;
var
  ni:integer;
  uexists:boolean;
begin
  uexists:=false;
  for ni:=0 to frmain.lvMain.Items.Count-1 do
  begin
    if frmain.lvMain.Items[ni].SubItems[columnurl] = url then
      uexists:=true;
  end;
  result:=uexists;
end;



constructor soundthread.Create(CreateSuspended:boolean);
begin
  inherited Create(CreateSuspended);
  player:=TProcess.Create(nil);
  sndfile:='';
end;

procedure soundthread.Execute;
var
  engine:string;
begin
  engine:='';
  if FileExists('/usr/bin/aplay') then
    engine:='/usr/bin/aplay';
  if (engine='') and (FileExists('/usr/bin/play')=true) then
    engine:='/usr/bin/play';
  if (engine='') and (FileExists('/usr/bin/mplayer')=true) then
    engine:='/usr/bin/mplayer';
  if (engine='') and (FileExists('/usr/bin/mplayer2')=true) then
    engine:='/usr/bin/mplayer2';
  if FileExists(engine) then
  begin
    player.Options:=[poUsePipes,poStderrToOutPut,poNoConsole];
    player.Executable:=engine;
    player.Parameters.Add(sndfile);
    player.Execute;
  end;
  while player.Running do;
    hilosnd.Terminate;
end;

procedure playsound(soundfile:string);
begin
  {$IFDEF WINDOWS}
    sndPlaySound(pchar(UTF8ToSys(soundfile)), snd_Async or snd_NoDefault);
  {$ELSE}
    hilosnd:=soundthread.Create(true);
    hilosnd.sndfile:=soundfile;
    hilosnd.Start;
  {$ENDIF}
end;

procedure rebuildids();
var
  x:integer;
begin
  SetLength(trayicons,frmain.lvMain.Items.Count);
  for x:=0 to frmain.lvMain.Items.Count-1 do
  begin
    if frmain.lvMain.Items[x].SubItems[columnstatus]='1' then
      hilo[strtoint(frmain.lvMain.Items[x].SubItems[columnid])].thid:=x;
    try
      if Assigned(trayicons[x]) then
      begin
        trayicons[x].downindex:=x;
        trayicons[x].Animate:=false;
        trayicons[x].Icon.Clear;
        trayicons[x].Visible:=false;
        trayicons[x].Hide;
      end
      else
      begin
        trayicons[x]:=downtrayicon.Create(nil);
        trayicons[x].downindex:=x;
        trayicons[x].Animate:=false;
        trayicons[x].Visible:=false;
        trayicons[x].Icon.Clear;
        trayicons[x].Hide;
        trayicons[x].OnMouseDown:=@trayicons[x].contextmenu;
        trayicons[x].PopUpMenu:=frmain.pmTrayDown;
        trayicons[x].OnDblClick:=@trayicons[x].showinmain;
      end;
    except on e:exception do
    end;
    if (frmain.lvMain.Items[x].SubItems[columnstatus]='1') and showdowntrayicon then
      trayicons[x].Show;
  end;
  if frmain.lvFilter.Visible then
  begin
    for x:=0 to frmain.lvFilter.Items.Count-1 do
    begin
      if frmain.lvFilter.Items[x].SubItems[columnstatus]='1' then
        hilo[strtoint(frmain.lvFilter.Items[x].SubItems[columnid])].thid2:=x;
    end;
  end;
end;

procedure movestepup(steps:integer);
begin
  if (frmain.lvMain.SelCount>0) and (steps>=0) then
  begin
    frmain.lvMain.MultiSelect:=false;
    frmain.lvMain.Items.Move(frmain.lvMain.ItemIndex,steps);
    frmain.lvMain.MultiSelect:=true;
    rebuildids();
    if frmain.lvFilter.Visible then
      frmain.tvMainSelectionChanged(nil);
  end;
end;

procedure moveonestepup();
var
  i:integer;
  indexup:integer=0;
begin
  for i:=0 to frmain.lvMain.Items.Count-1 do
  begin
    if (frmain.lvMain.Items[i].SubItems[columnqueue]=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnqueue]) and (i<frmain.lvMain.ItemIndex) then
      indexup:=i;
  end;
  if (frmain.lvMain.SelCount>0) and (indexup>=0) and (indexup<frmain.lvMain.Items.Count) then
  begin
    frmain.lvMain.MultiSelect:=false;
    frmain.lvMain.Items.Move(frmain.lvMain.ItemIndex,indexup);
    frmain.lvMain.MultiSelect:=true;
    rebuildids();
    if frmain.lvFilter.Visible then
      frmain.tvMainSelectionChanged(nil);
  end;
end;

procedure movestepdown(steps:integer);
begin
  if (frmain.lvMain.SelCount>0) and (steps<frmain.lvMain.Items.Count) then
  begin
    frmain.lvMain.MultiSelect:=false;
    frmain.lvMain.Items.Move(frmain.lvMain.ItemIndex,steps);
    frmain.lvMain.MultiSelect:=true;
    rebuildids();
    if frmain.lvFilter.Visible then
      frmain.tvMainSelectionChanged(nil);
  end;
end;

procedure moveonestepdown(indice:integer;numsteps:integer=0);
var
  i:integer;
  indexdown:integer=0;
begin
  for i:=0 to frmain.lvMain.Items.Count-1 do
  begin
    if (frmain.lvMain.Items[i].SubItems[columnqueue]=frmain.lvMain.Items[indice].SubItems[columnqueue]) and (i>indice+numsteps) then
    begin
      indexdown:=i;
      break;
    end;
  end;
  if (indexdown<frmain.lvMain.Items.Count) then
  begin
    frmain.lvMain.MultiSelect:=false;
    frmain.lvMain.Items.Move(indice,indexdown);
    frmain.lvMain.MultiSelect:=true;
    rebuildids();
    if frmain.lvFilter.Visible then
      frmain.tvMainSelectionChanged(nil);
  end;
end;

procedure updatelangstatus();
var
  x:integer;
begin
  for x:=0 to frmain.lvMain.Items.Count-1 do
  begin
    case frmain.lvMain.Items[x].SubItems[columnstatus] of
      '0':frmain.lvMain.Items[x].Caption:=frstrings.statuspaused.Caption;
      '1':frmain.lvMain.Items[x].Caption:=frstrings.statusinprogres.Caption;
      '2':frmain.lvMain.Items[x].Caption:=frstrings.statusstoped.Caption;
      '3':frmain.lvMain.Items[x].Caption:=frstrings.statuscomplete.Caption;
      '4':frmain.lvMain.Items[x].Caption:=frstrings.statuserror.Caption;
    end;
  end;
  for x:=0 to frmain.lvFilter.Columns.Count-1 do
    frmain.lvFilter.Columns[x].Caption:=frmain.lvMain.Columns[x].Caption;

  frmain.tvMain.Items[0].Text:=frstrings.alldowntreename.Caption;
  frmain.tvMain.Items[1].Text:=frstrings.queuestreename.Caption;
  frmain.tvMain.Items[1].Items[0].Text:=frstrings.queuemainname.Caption;
  frmain.tvMain.Items[frmain.tvMain.Items[1].Count+2].Text:=frstrings.filtresname.Caption;
  frmain.tvMain.Items[frmain.tvMain.Items[1].Count+3].Text:=frstrings.statuscomplete.Caption;
  frmain.tvMain.Items[frmain.tvMain.Items[1].Count+4].Text:=frstrings.statusinprogres.Caption;
  frmain.tvMain.Items[frmain.tvMain.Items[1].Count+5].Text:=frstrings.statusstoped.Caption;
  frmain.tvMain.Items[frmain.tvMain.Items[1].Count+6].Text:=frstrings.statuserror.Caption;
  frmain.tvMain.Items[frmain.tvMain.Items[1].Count+7].Text:=frstrings.statuspaused.Caption;
  frmain.tvMain.Items.TopLvlItems[3].Text:=categoryfilter;
  frconfig.tvConfig.Items[0].Text:=frconfig.tsProxy.Caption;
  frconfig.tvConfig.Items[1].Text:=frconfig.tsScheduler.Caption;
  frconfig.tvConfig.Items[2].Text:=frconfig.tsNotifications.Caption;
  frconfig.tvConfig.Items[3].Text:=frconfig.tsSounds.Caption;
  frconfig.tvConfig.Items[4].Text:=frconfig.tsClipboardm.Caption;
  frconfig.tvConfig.Items[5].Text:=frconfig.tsFolders.Caption;
  frconfig.tvConfig.Items[6].Text:=frconfig.tsWget.Caption;
  frconfig.tvConfig.Items[7].Text:=frconfig.tsAria2.Caption;
  frconfig.tvConfig.Items[8].Text:=frconfig.tsCurl.Caption;
  frconfig.tvConfig.Items[9].Text:=frconfig.tsAxel.Caption;
  frconfig.tvConfig.Items[10].Text:=frconfig.tsAutomation.Caption;
  frconfig.tvConfig.Items[11].Text:=frconfig.tsLogs.Caption;
  frconfig.tvConfig.Items[12].Text:=frconfig.tsDownOptions.Caption;
  frconfig.tvConfig.Items[13].Text:=frconfig.tsLang.Caption;
  frconfig.tvConfig.Items[14].Text:=frconfig.tsQueue.Caption;
  frconfig.tvConfig.Items[15].Text:=frconfig.tsIntegration.Caption;
  frmain.tvMain.Items.TopLvlItems[3][frmain.tvMain.Items.TopLvlItems[3].SubTreeCount-2].Text:=categoryothers;
  frconfig.Panel1.Caption:=frconfig.PageControl1.Pages[frconfig.PageControl1.TabIndex].Caption;
  frconfig.CheckGroup5.Items[0]:=frstrings.sunday.Caption;
  frconfig.CheckGroup5.Items[1]:=frstrings.monday.Caption;
  frconfig.CheckGroup5.Items[2]:=frstrings.tuesday.Caption;
  frconfig.CheckGroup5.Items[3]:=frstrings.wednesday.Caption;
  frconfig.CheckGroup5.Items[4]:=frstrings.thursday.Caption;
  frconfig.CheckGroup5.Items[5]:=frstrings.friday.Caption;
  frconfig.CheckGroup5.Items[6]:=frstrings.saturday.Caption;
  frconfig.CheckGroup4.Items[0]:=frstrings.runwiththesystem.Caption;
  frconfig.CheckGroup4.Items[1]:=frstrings.startinthesystray.Caption;
  queuenames[0]:=frstrings.queuemainname.Caption;
  if frconfig.ComboBox4.Items.Count>0 then
    frconfig.ComboBox4.Items[0]:=frstrings.queuemainname.Caption;
  frconfig.cbProxy.Items[0]:=frstrings.proxynot.Caption;
  frconfig.cbProxy.Items[1]:=frstrings.proxysystem.Caption;
  frconfig.cbProxy.Items[2]:=frstrings.proxymanual.Caption;
  frconfig.CheckGroup1.Items[0]:=wgetdefarg1;
  frconfig.CheckGroup1.Items[1]:=wgetdefarg2;
  frconfig.CheckGroup1.Items[2]:=wgetdefarg3;
  frconfig.CheckGroup1.Items[3]:=wgetdefarg4;
  frconfig.CheckGroup2.Items[0]:=aria2defarg1;
  frconfig.CheckGroup2.Items[1]:=aria2defarg2;
  frconfig.CheckGroup3.Items[0]:=curldefarg1;
  queuesreload();
  newdownqueues();
end;

procedure enginereload();
begin
  frnewdown.ComboBox1.Items.Clear;
  frconfig.ComboBox3.Items.Clear;

  if FileExistsUTF8(aria2crutebin) then
  begin
    frnewdown.ComboBox1.Items.Add('aria2c');
    frconfig.ComboBox3.Items.Add('aria2c');
  end;

  if FileExistsUTF8(axelrutebin) then
  begin
    frnewdown.ComboBox1.Items.Add('axel');
    frconfig.ComboBox3.Items.Add('axel');
  end;

  if FileExistsUTF8(curlrutebin) then
  begin
    frnewdown.ComboBox1.Items.Add('curl');
    frconfig.ComboBox3.Items.Add('curl');
  end;

  if FileExistsUTF8(wgetrutebin) then
  begin
    frnewdown.ComboBox1.Items.Add('wget');
    frconfig.ComboBox3.Items.Add('wget');
  end;

  //if FileExistsUTF8(lftprutebin) then
  //begin
    //fnewdown.ComboBox1.Items.Add('lftp');
    //fconfig.ComboBox3.Items.Add('lftp');
  //end;

  //Seleccionar wget por defecto
  frnewdown.ComboBox1.ItemIndex:=frnewdown.ComboBox1.Items.IndexOf(defaultengine);
  frconfig.ComboBox3.ItemIndex:=frconfig.ComboBox3.Items.IndexOf(defaultengine);
  if frnewdown.ComboBox1.ItemIndex=-1 then
    frnewdown.ComboBox1.ItemIndex:=0;
  if frconfig.ComboBox3.ItemIndex=-1 then
    frconfig.ComboBox3.ItemIndex:=0;
end;

procedure autostart();
{$IFDEF UNIX}
  var
    soutput:TStringList;
{$ENDIF}
{$IFDEF WINDOWS}
  var
    registro:TRegistry;
{$ENDIF}
begin
  if autostartwithsystem then
  begin
    {$IFDEF WINDOWS}
      registro:=TRegistry.Create;
      registro.RootKey:=HKEY_CURRENT_USER;
      registro.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run\',false);
      registro.WriteString('AWGG','"'+Application.Params[0]+'"');
      registro.CloseKey;
      registro.Free;
    {$ENDIF}
    {$IFDEF UNIX}
      soutput:=TStringList.Create;
      soutput.Add('[Desktop Entry]');
      soutput.Add('Type=Application');
      soutput.Add('Exec=bash -c "sleep 10;'+Application.Params[0]+'"');
      soutput.Add('Icon=/usr/lib/awgg/awgg.png');
      soutput.Add('Hidden=false');
      soutput.Add('Name=AWGG');
      soutput.Add('Comment=Gestor de descargas AWGG');
      if FileExists(GetUserDir+'.config/autostart/awgg.desktop') then
        DeleteFile(GetUserDir+'.config/autostart/awgg.desktop');
      CreateDir(GetUserDir+'.config/autostart/');
      soutput.SaveToFile(GetUserDir+'.config/autostart/awgg.desktop');
      soutput.Free;
    {$ENDIF}
  end
  else
  begin
    {$IFDEF WINDOWS}
      registro:=TRegistry.Create;
      registro.RootKey:=HKEY_CURRENT_USER;
      registro.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run\',false);
      registro.DeleteValue('AWGG');
      registro.CloseKey;
      registro.Free;
    {$ENDIF}
    {$IFDEF UNIX}
      if FileExists(GetUserDir+'.config/autostart/awgg.desktop') then
        DeleteFile(GetUserDir+'.config/autostart/awgg.desktop');
    {$ENDIF}
  end;
end;

procedure saveconfig();
var
  iniconfigfile:TMEMINIFile;
  i,x:integer;
  extencions:string='';
begin
  if FileExists(configpath+'awgg.ini') then
  begin
    FileUtil.CopyFile(ExtractShortPathName(configpath)+'awgg.ini',ExtractShortPathName(configpath)+'awgg.ini.bak',[cffOverwriteFile]);
    SysUtils.DeleteFile(configpath+'awgg.ini');
  end;
  if frmain.lvMain.Visible then
  begin
    columncolaw:=frmain.lvMain.Column[0].Width;
    columnnamew:=frmain.lvMain.Column[columnname+1].Width;
    columnurlw:=frmain.lvMain.Column[columnurl+1].Width;
    columnpercentw:=frmain.lvMain.Column[columnpercent+1].Width;
    columnsizew:=frmain.lvMain.Column[columnsize+1].Width;
    columncurrentw:=frmain.lvMain.Column[columncurrent+1].Width;
    columnspeedw:=frmain.lvMain.Column[columnspeed+1].Width;
    columnestimatew:=frmain.lvMain.Column[columnestimate+1].Width;
    columndatew:=frmain.lvMain.Column[columndate+1].Width;
    columndestinyw:=frmain.lvMain.Column[columndestiny+1].Width;
    columnenginew:=frmain.lvMain.Column[columnengine+1].Width;
    columnparametersw:=frmain.lvMain.Column[columnparameters+1].Width;
    columncolav:=frmain.lvMain.Column[0].Visible;
    columnnamev:=frmain.lvMain.Column[columnname+1].Visible;
    columnurlv:=frmain.lvMain.Column[columnurl+1].Visible;
    columnpercentv:=frmain.lvMain.Column[columnpercent+1].Visible;
    columnsizev:=frmain.lvMain.Column[columnsize+1].Visible;
    columnspeedv:=frmain.lvMain.Column[columnspeed+1].Visible;
    columnestimatev:=frmain.lvMain.Column[columnestimate+1].Visible;
    columndatev:=frmain.lvMain.Column[columndate+1].Visible;
    columndestinyv:=frmain.lvMain.Column[columndestiny+1].Visible;
    columnenginev:=frmain.lvMain.Column[columnengine+1].Visible;
    columnparametersv:=frmain.lvMain.Column[columnparameters+1].Visible;
  end
  else
  begin
    columncolaw:=frmain.lvFilter.Column[0].Width;
    columnnamew:=frmain.lvFilter.Column[columnname+1].Width;
    columnurlw:=frmain.lvFilter.Column[columnurl+1].Width;
    columnpercentw:=frmain.lvFilter.Column[columnpercent+1].Width;
    columnsizew:=frmain.lvFilter.Column[columnsize+1].Width;
    columncurrentw:=frmain.lvFilter.Column[columncurrent+1].Width;
    columnspeedw:=frmain.lvFilter.Column[columnspeed+1].Width;
    columnestimatew:=frmain.lvFilter.Column[columnestimate+1].Width;
    columndatew:=frmain.lvFilter.Column[columndate+1].Width;
    columndestinyw:=frmain.lvFilter.Column[columndestiny+1].Width;
    columnenginew:=frmain.lvFilter.Column[columnengine+1].Width;
    columnparametersw:=frmain.lvFilter.Column[columnparameters+1].Width;
    columncolav:=frmain.lvFilter.Column[0].Visible;
    columnnamev:=frmain.lvFilter.Column[columnname+1].Visible;
    columnurlv:=frmain.lvFilter.Column[columnurl+1].Visible;
    columnpercentv:=frmain.lvFilter.Column[columnpercent+1].Visible;
    columnsizev:=frmain.lvFilter.Column[columnsize+1].Visible;
    columnspeedv:=frmain.lvFilter.Column[columnspeed+1].Visible;
    columnestimatev:=frmain.lvFilter.Column[columnestimate+1].Visible;
    columndatev:=frmain.lvFilter.Column[columndate+1].Visible;
    columndestinyv:=frmain.lvFilter.Column[columndestiny+1].Visible;
    columnenginev:=frmain.lvFilter.Column[columnengine+1].Visible;
    columnparametersv:=frmain.lvFilter.Column[columnparameters+1].Visible;
  end;
  limited:=frmain.cbLimit.Checked;
  speedlimit:=frmain.fseLimit.Text;
  maxgdown:=frmain.seMaxDownInProgress.Value;
  showstdout:=frmain.micommandFollow.Checked;
  showgridlines:=frmain.lvMain.GridLines;
  showcommandout:=frmain.SynEdit1.Visible;
  showdowntrayicon:=frmain.mimainShowTrayDowns.Checked;
  showtreeviewpanel:=frmain.tvMain.Visible;
  if showcommandout then
    splitpos:=frmain.psVertical.Position;
  if frmain.psHorizontal.Position>10 then
    splithpos:=frmain.psHorizontal.Position;
  try
    iniconfigfile:=TMEMINIFile.Create(configpath+'awgg.ini');
    iniconfigfile.WriteString('Config','version',versionitis.version);
    iniconfigfile.WriteInteger('Config','useproxy',useproxy);
    iniconfigfile.WriteString('Config','phttp',phttp);
    iniconfigfile.WriteString('Config','phttpport',phttpport);
    iniconfigfile.WriteString('Config','phttps',phttps);
    iniconfigfile.WriteString('Config','phttpsport',phttpsport);
    iniconfigfile.WriteString('Config','pftp',pftp);
    iniconfigfile.WriteString('Config','pftpport',pftpport);
    iniconfigfile.WriteString('Config','nphost',nphost);
    iniconfigfile.WriteBool('Config','useaut',useaut);
    iniconfigfile.WriteString('Config','puser',puser);
    iniconfigfile.WriteString('Config','ppassword',ppassword);
    iniconfigfile.WriteBool('Config','shownotifi',shownotifi);
    iniconfigfile.WriteInteger('Config','hiddenotifi',hiddenotifi);
    iniconfigfile.WriteBool('Config','clipboardmonitor',clipboardmonitor);
    iniconfigfile.WriteString('Config','ddowndir',ddowndir);
    if columncolaw>10 then
      iniconfigfile.WriteInteger('Config','columncolaw',columncolaw);
    if columnnamew>10 then
      iniconfigfile.WriteInteger('Config','columnnamew',columnnamew);
    if columnurlw>10 then
      iniconfigfile.WriteInteger('Config','columnurlw',columnurlw);
    if columnpercentw>10 then
     iniconfigfile.WriteInteger('Config','columnpercentw',columnpercentw);
    if columnsizew>10 then
      iniconfigfile.WriteInteger('Config','columnsizew',columnsizew);
    if columncurrentw>10 then
      iniconfigfile.WriteInteger('Config','columncurrentw',columncurrentw);
    if columnspeedw>10 then
      iniconfigfile.WriteInteger('Config','columnspeedw',columnspeedw);
    if columnestimatew>10 then
      iniconfigfile.WriteInteger('Config','columnestimatew',columnestimatew);
    if columndatew>10 then
      iniconfigfile.WriteInteger('Config','columndatew',columndatew);
    if columndestinyw>10 then
      iniconfigfile.WriteInteger('Config','columndestinyw',columndestinyw);
    if columnenginew>10 then
      iniconfigfile.WriteInteger('Config','columnenginew',columnenginew);
    if columnparametersw>10 then
      iniconfigfile.WriteInteger('Config','columnparametersw',columnparametersw);
    iniconfigfile.WriteBool('Config','columncolav',columncolav);
    iniconfigfile.WriteBool('Config','columnnamev',columnnamev);
    iniconfigfile.WriteBool('Config','columnurlv',columnurlv);
    iniconfigfile.WriteBool('Config','columnpercentv',columnpercentv);
    iniconfigfile.WriteBool('Config','columnsizev',columnsizev);
    iniconfigfile.WriteBool('Config','columncurrentv',columncurrentv);
    iniconfigfile.WriteBool('Config','columnspeedv',columnspeedv);
    iniconfigfile.WriteBool('Config','columnestimatev',columnestimatev);
    iniconfigfile.WriteBool('Config','columndatev',columndatev);
    iniconfigfile.WriteBool('Config','columndestinyv',columndestinyv);
    iniconfigfile.WriteBool('Config','columnenginev',columnenginev);
    iniconfigfile.WriteBool('Config','columnparametersv',columnparametersv);
    iniconfigfile.WriteBool('Config','limited',limited);
    iniconfigfile.WriteString('Config','speedlimit',speedlimit);
    iniconfigfile.WriteInteger('Config','maxgdown',maxgdown);
    iniconfigfile.WriteBool('Config','showstdout',showstdout);
    iniconfigfile.WriteString('Config','wgetrutebin',wgetrutebin);
    iniconfigfile.WriteString('Config','aria2crutebin',aria2crutebin);
    iniconfigfile.WriteString('Config','curlrutebin',curlrutebin);
    iniconfigfile.WriteString('Config','axelrutebin',axelrutebin);
    iniconfigfile.WriteString('Config','lftprutebin',lftprutebin);
    iniconfigfile.WriteString('Config','wgetargs',wgetargs);
    iniconfigfile.WriteString('Config','aria2cargs',aria2cargs);
    iniconfigfile.WriteString('Config','curlargs',curlargs);
    iniconfigfile.WriteString('Config','axelargs',axelargs);
    iniconfigfile.WriteString('Config','lftpargs',lftpargs);
    iniconfigfile.WriteBool('Config','wgetdefcontinue',wgetdefcontinue);
    iniconfigfile.WriteBool('Config','wgetdefnh',wgetdefnh);
    iniconfigfile.WriteBool('Config','wgetdefnd',wgetdefnd);
    iniconfigfile.WriteBool('Config','wgetdefncert',wgetdefncert);
    iniconfigfile.WriteBool('Config','aria2cdefcontinue',aria2cdefcontinue);
    iniconfigfile.WriteBool('Config','aria2cdefallocate',aria2cdefallocate);
    iniconfigfile.WriteString('Config','aria2splitsize',aria2splitsize);
    iniconfigfile.WriteInteger('Config','aria2splitnum',aria2splitnum);
    iniconfigfile.WriteBool('Config','aria2split',aria2split);
    iniconfigfile.WriteBool('Config','curldefcontinue',curldefcontinue);
    iniconfigfile.WriteBool('Config','lftpdefcontinue',lftpdefcontinue);
    iniconfigfile.WriteBool('Config','autostartwithsystem',autostartwithsystem);
    iniconfigfile.WriteBool('Config','autostartminimized',autostartminimized);
    iniconfigfile.WriteBool('Config','logger',logger);
    iniconfigfile.WriteString('Config','logpath',logpath);
    iniconfigfile.WriteBool('Config','showgridlines',showgridlines);
    iniconfigfile.WriteBool('Config','showcommandout',showcommandout);
    iniconfigfile.WriteBool('Config','showtreeviewpanel',showtreeviewpanel);
    iniconfigfile.WriteInteger('Config','notifipos',notifipos);
    iniconfigfile.WriteInteger('Config','splitpos',splitpos);
    iniconfigfile.WriteInteger('Config','splithpos',splithpos);
    case lastmainwindowstate of
      wsNormal:iniconfigfile.WriteString('Config','lastmainwindowstate','wsNormal');
      wsMaximized:iniconfigfile.WriteString('Config','lastmainwindowstate','wsMaximized');
    end;
    iniconfigfile.WriteInteger('Config','dtries',dtries);
    iniconfigfile.WriteInteger('Config','dtimeout',dtimeout);
    iniconfigfile.WriteInteger('Config','ddelay',ddelay);
    iniconfigfile.WriteString('Config','deflanguage',deflanguage);
    iniconfigfile.WriteBool('Config','firststart',firststart);
    iniconfigfile.WriteString('Config','defaultengine',defaultengine);
    iniconfigfile.WriteBool('Config','playsounds',playsounds);
    iniconfigfile.WriteString('Config','downcompsound',downcompsound);
    iniconfigfile.WriteString('Config','downstopsound',downstopsound);
    iniconfigfile.WriteBool('Config','sheduledisablelimits',sheduledisablelimits);
    iniconfigfile.WriteBool('Config','queuerotate',queuerotate);
    iniconfigfile.WriteInteger('Config','triesrotate',triesrotate);
    iniconfigfile.WriteInteger('Config','rotatemode',rotatemode);
    iniconfigfile.WriteInteger('Config','queuedelay',queuedelay);
    iniconfigfile.WriteBool('Config','sameproxyforall',sameproxyforall);
    iniconfigfile.WriteBool('Config','loadhistorylog',loadhistorylog);
    iniconfigfile.WriteInteger('Config','loadhistorymode',loadhistorymode);
    iniconfigfile.WriteInteger('Config','defaultdirmode',defaultdirmode);
    iniconfigfile.WriteBool('Config','showdowntrayicon',showdowntrayicon);
    iniconfigfile.WriteBool('Config','useglobaluseragent',useglobaluseragent);
    iniconfigfile.WriteString('Config','globaluseragent',globaluseragent);
    iniconfigfile.WriteBool('Config','portablemode',portablemode);
    //categorias
    iniconfigfile.WriteInteger('Category','count',Length(categoryextencions));
    for i:=0 to Length(categoryextencions)-1 do
    begin
      extencions:='';
      iniconfigfile.WriteString('Group'+inttostr(i),'Name',categoryextencions[i][1]);
      iniconfigfile.WriteString('Group'+inttostr(i),'Path',categoryextencions[i][0]);
      for x:=2 to categoryextencions[i].Count-1 do
      begin
        extencions:=extencions+categoryextencions[i][x]+':';
      end;
      iniconfigfile.WriteString('Group'+inttostr(i),'Ext',extencions);
      extencions:='';
    end;
    iniconfigfile.UpdateFile;
    iniconfigfile.Free;
    autostart();
  except on e:exception do
    ShowMessage(frstrings.msgerrorconfigsave.caption+e.ToString);
  end;
end;
procedure loadconfig();
var
  iniconfigfile:TINIFile;
  i:integer;
begin
  try
    iniconfigfile:=TINIFile.Create(configpath+'awgg.ini');
    useproxy:=iniconfigfile.ReadInteger('Config','useproxy',1);
    phttp:=iniconfigfile.ReadString('Config','phttp','');
    phttpport:=iniconfigfile.ReadString('Config','phttpport','3128');
    phttps:=iniconfigfile.ReadString('Config','phttps','');
    phttpsport:=iniconfigfile.ReadString('Config','phttpsport','3128');
    pftp:=iniconfigfile.ReadString('Config','pftp','');
    pftpport:=iniconfigfile.ReadString('Config','pftpport','3128');
    nphost:=iniconfigfile.ReadString('Config','nphost','');
    useaut:=iniconfigfile.ReadBool('Config','useaut',false);
    puser:=iniconfigfile.ReadString('Config','puser','');
    ppassword:=iniconfigfile.ReadString('Config','ppassword','');
    shownotifi:=iniconfigfile.ReadBool('Config','shownotifi',true);
    hiddenotifi:=iniconfigfile.ReadInteger('Config','hiddenotifi',5);
    clipboardmonitor:=iniconfigfile.ReadBool('Config','clipboardmonitor',true);
    ddowndir:=iniconfigfile.ReadString('Config','ddowndir',ddowndir);
    dotherdowndir:=ddowndir+pathdelim+'Others';
    columncolaw:=iniconfigfile.ReadInteger('Config','columncolaw',90);
    if columncolaw<10 then columncolaw:=90;
      columnnamew:=iniconfigfile.ReadInteger('Config','columnnamew',110);
    if columnnamew<10 then columnnamew:=110;
      columnurlw:=iniconfigfile.ReadInteger('Config','columnurlw',100);
    if columnurlw<10 then columnurlw:=100;
      columnpercentw:=iniconfigfile.ReadInteger('Config','columnpercentw',40);
    if columnpercentw<10 then columnpercentw:=40;
      columnsizew:=iniconfigfile.ReadInteger('Config','columnsizew',70);
    if columnsizew<10 then columnsizew:=70;
      columncurrentw:=iniconfigfile.ReadInteger('Config','columncurrentw',90);
    if columncurrentw<10 then columncurrentw:=90;
      columnspeedw:=iniconfigfile.ReadInteger('Config','columnspeedw',70);
    if columnspeedw<10 then columnspeedw:=70;
      columnestimatew:=iniconfigfile.ReadInteger('Config','columnestimatew',70);
    if columnestimatew<10 then columnestimatew:=70;
      columndatew:=iniconfigfile.ReadInteger('Config','columndatew',80);
    if columndatew<10 then columndatew:=80;
      columndestinyw:=iniconfigfile.ReadInteger('Config','columndestinyw',100);
    if columndestinyw<10 then columndestinyw:=100;
      columnenginew:=iniconfigfile.ReadInteger('Config','columnenginew',50);
    if columnenginew<10 then columnenginew:=50;
      columnparametersw:=iniconfigfile.ReadInteger('Config','columnparametersw',50);
    if columnparametersw<10 then columnparametersw:=50;
      columncolav:=iniconfigfile.ReadBool('Config','columncolav',true);
    columnnamev:=iniconfigfile.ReadBool('Config','columnnamev',true);
    columnurlv:=iniconfigfile.ReadBool('Config','columnurlv',false);
    columnpercentv:=iniconfigfile.ReadBool('Config','columnpercentv',true);
    columnsizev:=iniconfigfile.ReadBool('Config','columnsizev',true);
    columncurrentv:=iniconfigfile.ReadBool('Config','columncurrentv',true);
    columnspeedv:=iniconfigfile.ReadBool('Config','columnspeedv',true);
    columnestimatev:=iniconfigfile.ReadBool('Config','columnestimatev',true);
    columndatev:=iniconfigfile.ReadBool('Config','columndatev',false);
    columndestinyv:=iniconfigfile.ReadBool('Config','columndestinyv',false);
    columnenginev:=iniconfigfile.ReadBool('Config','columnenginev',false);
    columnparametersv:=iniconfigfile.ReadBool('Config','columnparametersv',false);
    limited:=iniconfigfile.ReadBool('Config','limited',false);
    speedlimit:=iniconfigfile.ReadString('Config','speedlimit','3');
    maxgdown:=iniconfigfile.Readinteger('Config','maxgdown',maxgdown);
    showstdout:=iniconfigfile.ReadBool('Config','showstdout',false);
    wgetrutebin:=iniconfigfile.ReadString('Config','wgetrutebin',wgetrutebin);
    aria2crutebin:=iniconfigfile.ReadString('Config','aria2crutebin',aria2crutebin);
    curlrutebin:=iniconfigfile.ReadString('Config','curlrutebin',curlrutebin);
    axelrutebin:=iniconfigfile.ReadString('Config','axelrutebin',axelrutebin);
    lftprutebin:=iniconfigfile.ReadString('Config','lftprutebin',lftprutebin);
    wgetargs:=iniconfigfile.ReadString('Config','wgetargs',wgetargs);
    aria2cargs:=iniconfigfile.ReadString('Config','aria2cargs',aria2cargs);
    curlargs:=iniconfigfile.ReadString('Config','curlargs',curlargs);
    axelargs:=iniconfigfile.ReadString('Config','axelargs',axelargs);
    lftpargs:=iniconfigfile.ReadString('Config','lftpargs',lftpargs);
    wgetdefcontinue:=iniconfigfile.ReadBool('Config','wgetdefcontinue',true);
    wgetdefnh:=iniconfigfile.ReadBool('Config','wgetdefnh',true);
    wgetdefnd:=iniconfigfile.ReadBool('Config','wgetdefnd',true);
    wgetdefncert:=iniconfigfile.ReadBool('Config','wgetdefncert',true);
    aria2cdefcontinue:=iniconfigfile.ReadBool('Config','aria2cdefcontinue',true);
    aria2cdefallocate:=iniconfigfile.ReadBool('Config','aria2cdefallocate',true);
    aria2splitsize:=iniconfigfile.ReadString('Config','aria2splitsize','1M');
    aria2splitnum:=iniconfigfile.ReadInteger('Config','aria2splitnum',5);
    aria2split:=iniconfigfile.ReadBool('Config','aria2split',true);
    curldefcontinue:=iniconfigfile.ReadBool('Config','curldefcontinue',true);
    lftpdefcontinue:=iniconfigfile.ReadBool('Config','lftpdefcontinue',true);
    autostartwithsystem:=iniconfigfile.ReadBool('Config','autostartwithsystem',false);
    autostartminimized:=iniconfigfile.ReadBool('Config','autostartminimized',false);
    logger:=iniconfigfile.ReadBool('Config','logger',true);
    logpath:=iniconfigfile.ReadString('Config','logpath',ddowndir+pathdelim+'logs');
    showgridlines:=iniconfigfile.ReadBool('Config','showgridlines',false);
    showcommandout:=iniconfigfile.ReadBool('Config','showcommandout',false);
    notifipos:=iniconfigfile.ReadInteger('Config','notifipos',2);
    splitpos:=iniconfigfile.ReadInteger('Config','splitpos',270);
    splithpos:=iniconfigfile.ReadInteger('Config','splithpos',170);
    case iniconfigfile.ReadString('Config','lastmainwindowstate','wsNormal') of
      'wsNormal':lastmainwindowstate:=wsNormal;
      'wsMaximized':lastmainwindowstate:=wsMaximized;
    end;
    dtries:=iniconfigfile.ReadInteger('Config','dtries',10);
    dtimeout:=iniconfigfile.ReadInteger('Config','dtimeout',10);
    ddelay:=iniconfigfile.ReadInteger('Config','ddelay',5);
    deflanguage:=iniconfigfile.ReadString('Config','deflanguage','en');
    firststart:=iniconfigfile.ReadBool('Config','firststart',true);
    defaultengine:=iniconfigfile.ReadString('Config','defaultengine','wget');
    playsounds:=iniconfigfile.ReadBool('Config','playsounds',playsounds);
    downcompsound:=iniconfigfile.ReadString('Config','downcompsound',downcompsound);
    downstopsound:=iniconfigfile.ReadString('Config','downstopsound',downstopsound);
    sheduledisablelimits:=iniconfigfile.ReadBool('Config','sheduledisablelimits',false);
    queuerotate:=iniconfigfile.ReadBool('Config','queuerotate',false);
    triesrotate:=iniconfigfile.ReadInteger('Config','triesrotate',5);
    rotatemode:=iniconfigfile.ReadInteger('Config','rotatemode',0);
    queuedelay:=iniconfigfile.ReadInteger('Config','queuedelay',1);
    sameproxyforall:=iniconfigfile.ReadBool('Config','sameproxyforall',false);
    loadhistorylog:=iniconfigfile.ReadBool('Config','loadhistorylog',false);
    loadhistorymode:=iniconfigfile.ReadInteger('Config','loadhistorymode',2);
    defaultdirmode:=iniconfigfile.ReadInteger('Config','defaultdirmode',2);
    showdowntrayicon:=iniconfigfile.ReadBool('Config','showdowntrayicon',true);
    showtreeviewpanel:=iniconfigfile.ReadBool('Config','showtreeviewpanel',true);
    useglobaluseragent:=iniconfigfile.ReadBool('Config','useglobaluseragent',false);
    globaluseragent:=iniconfigfile.ReadString('Config','globaluseragent','Mozilla/5.0');
    portablemode:=iniconfigfile.ReadBool('Config','portablemode',false);
    //categorias
    if iniconfigfile.ValueExists('Category','count') then
    begin
      for i:=0 to (iniconfigfile.ReadInteger('Category','count',0)-1) do
      begin
        SetLength(categoryextencions,Length(categoryextencions)+1);
        categoryextencions[i]:=TStringList.Create;
        categoryextencions[i].Add(iniconfigfile.ReadString('Group'+inttostr(i),'Path',ddowndir));
        categoryextencions[i].Add(iniconfigfile.ReadString('Group'+inttostr(i),'Name','Group'));
        categoryextencions[i].AddText(StringReplace(iniconfigfile.ReadString('Group'+inttostr(i),'Ext',''),':',lineending,[rfReplaceAll]));
      end;
    end
    else
    begin
      //defaultcategory();
    end;
    iniconfigfile.Free;
    frmain.lvMain.Column[0].Width:=columncolaw;
    frmain.lvMain.Column[columnname+1].Width:=columnnamew;
    frmain.lvMain.Column[columnurl+1].Width:=columnurlw;
    frmain.lvMain.Column[columnpercent+1].Width:=columnpercentw;
    frmain.lvMain.Column[columnsize+1].Width:=columnsizew;
    frmain.lvMain.Column[columncurrent+1].Width:=columncurrentw;
    frmain.lvMain.Column[columnspeed+1].Width:=columnspeedw;
    frmain.lvMain.Column[columnestimate+1].Width:=columnestimatew;
    frmain.lvMain.Column[columndate+1].Width:=columndatew;
    frmain.lvMain.Column[columndestiny+1].Width:=columndestinyw;
    frmain.lvMain.Column[columnengine+1].Width:=columnenginew;
    frmain.lvMain.Column[columnparameters+1].Width:=columnparametersw;
    frmain.lvMain.Column[0].Visible:=columncolav;
    frmain.lvMain.Column[columnname+1].Visible:=columnnamev;
    frmain.lvMain.Column[columnurl+1].Visible:=columnurlv;
    frmain.lvMain.Column[columnpercent+1].Visible:=columnpercentv;
    frmain.lvMain.Column[columnsize+1].Visible:=columnsizev;
    frmain.lvMain.Column[columncurrent+1].Visible:=columncurrentv;
    frmain.lvMain.Column[columnspeed+1].Visible:=columnspeedv;
    frmain.lvMain.Column[columnestimate+1].Visible:=columnestimatev;
    frmain.lvMain.Column[columndate+1].Visible:=columndatev;
    frmain.lvMain.Column[columndestiny+1].Visible:=columndestinyv;
    frmain.lvMain.Column[columnengine+1].Visible:=columnenginev;
    frmain.lvMain.Column[columnparameters+1].Visible:=columnparametersv;

    frmain.mimainShowState.Checked:=columncolav;
    frmain.mimainShowName.Checked:=columnnamev;
    frmain.mimainShowSize.Checked:=columnsizev;
    frmain.mimainShowCurrent.Checked:=columncurrentv;
    frmain.mimainShowURL.Checked:=columnurlv;
    frmain.mimainShowSpeed.Checked:=columnspeedv;
    frmain.mimainShowPercent.Checked:=columnpercentv;
    frmain.mimainShowEstimated.Checked:=columnestimatev;
    frmain.mimainShowDate.Checked:=columndatev;
    frmain.mimainShowDestination.Checked:=columndestinyv;
    frmain.mimainShowEngine.Checked:=columnenginev;
    frmain.mimainShowParameters.Checked:=columnparametersv;
    frmain.lvMain.GridLines:=showgridlines;
    frmain.lvFilter.GridLines:=showgridlines;
    frmain.cbLimit.Checked:=limited;
    frmain.fseLimit.Value:=strtofloat(speedlimit);
    frmain.seMaxDownInProgress.Value:=maxgdown;
    frmain.micommandFollow.Checked:=showstdout;
    frmain.SynEdit1.Visible:=showcommandout;
    frmain.micommandFollow.Checked:=showcommandout;
    frmain.micommandFollow.Enabled:=showcommandout;
    frmain.mimainShowCommand.Checked:=showcommandout;
    frmain.mimainshowgrid.Checked:=showgridlines;
    frmain.ClipboardTimer.Enabled:=clipboardmonitor;
    frmain.tbClipBoard.Down:=clipboardmonitor;
    frmain.mimainShowTrayDowns.Checked:=showdowntrayicon;
    frmain.mimainShowTree.Checked:=showtreeviewpanel;
    frmain.tvMain.Visible:=showtreeviewpanel;
    //if splitpos<20 then
      //splitpos:=20;
    //if splitpos>frmain.PairSplitter1.Height-20 then
      //splitpos:=splitpos-20;
    splitpos:=Round(frmain.psVertical.Height/1.5);
    if showstdout then
      frmain.psVertical.Position:=splitpos
    else
      frmain.psVertical.Position:=frmain.psVertical.Height;
    if showtreeviewpanel then
      frmain.psHorizontal.Position:=splithpos
    else
      frmain.psHorizontal.Position:=0;
    {$IFDEF UNIX}
      if not FileExistsUTF8(wgetrutebin) then
        wgetrutebin:='/usr/bin/wget';
      if not FileExistsUTF8(wgetrutebin) then
        wgetrutebin:=ExtractFilePath(Application.Params[0])+'wget';
      if not FileExistsUTF8(aria2crutebin) then
        aria2crutebin:='/usr/bin/aria2c';
      if not FileExistsUTF8(aria2crutebin) then
        aria2crutebin:=ExtractFilePath(Application.Params[0])+'aria2c';
      if not FileExistsUTF8(curlrutebin) then
        curlrutebin:='/usr/bin/curl';
      if not FileExistsUTF8(curlrutebin) then
        curlrutebin:=ExtractFilePath(Application.Params[0])+'curl';
      if not FileExistsUTF8(axelrutebin) then
        axelrutebin:='/usr/bin/axel';
      if not FileExistsUTF8(axelrutebin) then
        axelrutebin:=ExtractFilePath(Application.Params[0])+'axel';
      if not FileExistsUTF8(lftprutebin) then
        lftprutebin:='/usr/bin/lftp';
      if not FileExistsUTF8(lftprutebin) then
        lftprutebin:=ExtractFilePath(Application.Params[0])+'lftp';
    {$ENDIF}
    {$IFDEF WINDOWS}
      {$IF FPC_FULLVERSION<=20604}
      if not FileExists(wgetrutebin) then
        wgetrutebin:=ExtractFilePath(Application.Params[0])+'wget.exe';
      if not FileExists(aria2crutebin) then
        aria2crutebin:=ExtractFilePath(Application.Params[0])+'aria2c.exe';
      if not FileExists(curlrutebin) then
        curlrutebin:=ExtractFilePath(Application.Params[0])+'curl.exe';
      if not FileExists(axelrutebin) then
        axelrutebin:=ExtractFilePath(Application.Params[0])+'axel.exe';
      if not FileExists(lftprutebin) then
        lftprutebin:=ExtractFilePath(Application.Params[0])+'lftp.exe';
      {$ELSE}
      if not FileExistsUTF8(wgetrutebin) then
        wgetrutebin:=SysToUTF8(ExtractFilePath(Application.Params[0])+'wget.exe');
      if not FileExistsUTF8(aria2crutebin) then
        aria2crutebin:=SysToUTF8(ExtractFilePath(Application.Params[0])+'aria2c.exe');
      if not FileExistsUTF8(curlrutebin) then
        curlrutebin:=SysToUTF8(ExtractFilePath(Application.Params[0])+'curl.exe');
      if not FileExistsUTF8(axelrutebin) then
        axelrutebin:=SysToUTF8(ExtractFilePath(Application.Params[0])+'axel.exe');
      if not FileExistsUTF8(lftprutebin) then
        lftprutebin:=SysToUTF8(ExtractFilePath(Application.Params[0])+'lftp.exe');
      {$ENDIF}
    {$ENDIF}
    frmain.ClipboardTimer.Enabled:=clipboardmonitor;
  except on e:exception do
    //ShowMessage(e.Message);
  end;
end;

procedure setconfig();
begin
  useproxy:=frconfig.cbProxy.ItemIndex;
  phttp:=frconfig.edtHTTPhost.Text;
  phttpport:=frconfig.seHTTPport.Text;
  phttps:=frconfig.edtSSLhost.Text;
  phttpsport:=frconfig.seSSLport.Text;
  pftp:=frconfig.edtFTPhost.Text;
  pftpport:=frconfig.seFTPport.Text;
  nphost:=frconfig.edtNoProxyHosts.Text;
  useaut:=frconfig.chUseAuth.Checked;
  puser:=frconfig.edtProxyUser.Text;
  ppassword:=frconfig.edtProxyPass.Text;
  shownotifi:=frconfig.CheckBox4.Checked;
  hiddenotifi:=frconfig.SpinEdit4.Value;
  clipboardmonitor:=frconfig.CheckBox6.Checked;
  frmain.ClipBoardTimer.Enabled:=clipboardmonitor;
  ddowndir:=frconfig.DirectoryEdit1.Text;
  dotherdowndir:=ddowndir+pathdelim+'Others';
  wgetrutebin:=frconfig.FiLeNameEdit1.Text;
  aria2crutebin:=frconfig.FiLeNameEdit2.Text;
  curlrutebin:=frconfig.FiLeNameEdit3.Text;
  axelrutebin:=frconfig.FileNameEdit4.Text;
  wgetargs:=frconfig.Edit7.Text;
  aria2cargs:=frconfig.Edit8.Text;
  curlargs:=frconfig.Edit9.Text;
  axelargs:=frconfig.Edit10.Text;
  wgetdefcontinue:=frconfig.CheckGroup1.Checked[0];
  wgetdefnh:=frconfig.CheckGroup1.Checked[1];
  wgetdefnd:=frconfig.CheckGroup1.Checked[2];
  wgetdefncert:=frconfig.CheckGroup1.Checked[3];
  aria2cdefcontinue:=frconfig.CheckGroup2.Checked[0];
  aria2cdefallocate:=frconfig.CheckGroup2.Checked[1];
  aria2splitsize:=frconfig.Edit12.Text;
  aria2splitnum:=frconfig.SpinEdit5.Value;
  aria2split:=frconfig.CheckBox15.Checked;
  curldefcontinue:=frconfig.CheckGroup3.Checked[0];
  autostartwithsystem:=frconfig.CheckGroup4.Checked[0];
  autostartminimized:=frconfig.CheckGroup4.Checked[1];
  logger:=frconfig.Checkbox1.Checked;
  logpath:=frconfig.DirectoryEdit2.Text;
  notifipos:=frconfig.RadioGroup1.ItemIndex;
  dtimeout:=frconfig.SpinEdit10.Value;
  dtries:=frconfig.SpinEdit11.Value;
  ddelay:=frconfig.SpinEdit12.Value;
  deflanguage:=frconfig.ComboBox2.Text;
  defaultengine:=frconfig.ComboBox3.Text;
  playsounds:=frconfig.CheckBox7.Checked;
  queuelimits[frconfig.ComboBox4.ItemIndex]:=frconfig.CheckBox8.Checked;
  queuepoweroff[frconfig.ComboBox4.ItemIndex]:=frconfig.CheckBox13.Checked;
  queuerotate:=frconfig.CheckBox9.Checked;
  downcompsound:=frconfig.FileNameEdit6.Text;
  downstopsound:=frconfig.FileNameEdit7.Text;
  triesrotate:=frconfig.SpinEdit13.Value;
  if frconfig.RadioButton1.Checked then
    rotatemode:=0;
  if frconfig.RadioButton2.Checked then
    rotatemode:=1;
  if frconfig.RadioButton3.Checked then
    rotatemode:=2;
  queuedelay:=frconfig.SpinEdit14.Value;
  useglobaluseragent:=frconfig.CheckBox14.Checked;
  globaluseragent:=frconfig.Edit11.Text;
  sameproxyforall:=frconfig.chSameProxy.Checked;
  loadhistorylog:=frconfig.CheckBox12.Checked;
  if frconfig.RadioButton4.Checked=true then
    loadhistorymode:=1;
  if frconfig.RadioButton5.Checked=true then
    loadhistorymode:=2;
  if frconfig.RadioButton6.Checked=true then
    defaultdirmode:=1;
  if frconfig.RadioButton7.Checked=true then
    defaultdirmode:=2;
  qtimerenable[frconfig.ComboBox4.ItemIndex]:=frconfig.CheckBox11.Checked;
  qallday[frconfig.ComboBox4.ItemIndex]:=frconfig.CheckBox3.Checked;

  //queuestarttimes[fconfig.ComboBox4.ItemIndex]:=strtotime(inttostr(fconfig.SpinEdit6.Value)+':'+inttostr(fconfig.SpinEdit7.Value)+':00');
  //queuestoptimes[fconfig.ComboBox4.ItemIndex]:=strtotime(inttostr(fconfig.SpinEdit8.Value)+':'+inttostr(fconfig.SpinEdit9.Value)+':00');

  queuestarttimes[frconfig.ComboBox4.ItemIndex]:=frconfig.DateTimePicker1.Time;
  queuestoptimes[frconfig.ComboBox4.ItemIndex]:=frconfig.DateTimePicker2.Time;

  queuestartdates[frconfig.ComboBox4.ItemIndex]:=frconfig.DateEdit1.Date;
  qstop[frconfig.ComboBox4.ItemIndex]:=frconfig.CheckBox10.Checked;
  queuestopdates[frconfig.ComboBox4.ItemIndex]:=frconfig.DateEdit2.Date;
  qdomingo[frconfig.ComboBox4.ItemIndex]:=frconfig.CheckGroup5.Checked[0];
  qlunes[frconfig.ComboBox4.ItemIndex]:=frconfig.CheckGroup5.Checked[1];
  qmartes[frconfig.ComboBox4.ItemIndex]:=frconfig.CheckGroup5.Checked[2];
  qmiercoles[frconfig.ComboBox4.ItemIndex]:=frconfig.CheckGroup5.Checked[3];
  qjueves[frconfig.ComboBox4.ItemIndex]:=frconfig.CheckGroup5.Checked[4];
  qviernes[frconfig.ComboBox4.ItemIndex]:=frconfig.CheckGroup5.Checked[5];
  qsabado[frconfig.ComboBox4.ItemIndex]:=frconfig.CheckGroup5.Checked[6];
  if frconfig.ListBox1.ItemIndex<>-1 then
    categoryextencionstmp[frconfig.ListBox1.ItemIndex][0]:=frconfig.DirectoryEdit3.Text;
  categoryextencions:=categoryextencionstmp;
  SetDefaultLang(deflanguage);
  updatelangstatus();
  titlegen();
  saveconfig();
  stimer[frconfig.ComboBox4.ItemIndex].Enabled:=qtimerenable[frconfig.ComboBox4.ItemIndex];
  categoryreload();
end;

procedure configdlg();
var
  itemfile:TSearchRec;
  i:integer;
begin
  try
    frconfig.cbProxy.ItemIndex:=useproxy;
    frconfig.edtHTTPhost.Text:=phttp;
    frconfig.seHTTPport.Value:=strtoint(phttpport);
    frconfig.edtSSLhost.Text:=phttps;
    frconfig.seSSLport.Value:=strtoint(phttpsport);
    frconfig.edtFTPhost.Text:=pftp;
    frconfig.seFTPport.Value:=strtoint(pftpport);
    frconfig.edtNoProxyHosts.Text:=nphost;
    frconfig.chUseAuth.Checked:=useaut;
    frconfig.edtProxyUser.Text:=puser;
    frconfig.edtProxyPass.Text:=ppassword;
    frconfig.CheckBox6.Checked:=clipboardmonitor;
    frconfig.DirectoryEdit1.Text:=ddowndir;
    frconfig.CheckBox4.Checked:=shownotifi;
    frconfig.SpinEdit4.Value:=hiddenotifi;
    frconfig.FiLeNameEdit1.Text:=wgetrutebin;
    frconfig.FiLeNameEdit2.Text:=aria2crutebin;
    frconfig.FiLeNameEdit3.Text:=curlrutebin;
    frconfig.FileNameEdit4.Text:=axelrutebin;
    frconfig.Edit7.Text:=wgetargs;
    frconfig.Edit8.Text:=aria2cargs;
    frconfig.Edit9.Text:=curlargs;
    frconfig.Edit10.Text:=axelargs;
    frconfig.CheckGroup1.Checked[0]:=wgetdefcontinue;
    frconfig.CheckGroup1.Checked[1]:=wgetdefnh;
    frconfig.CheckGroup1.Checked[2]:=wgetdefnd;
    frconfig.CheckGroup1.Checked[3]:=wgetdefncert;
    frconfig.CheckGroup2.Checked[0]:=aria2cdefcontinue;
    frconfig.CheckGroup2.Checked[1]:=aria2cdefallocate;
    frconfig.SpinEdit5.Value:=aria2splitnum;
    frconfig.Edit12.Text:=aria2splitsize;
    frconfig.CheckBox15.Checked:=aria2split;
    frconfig.CheckGroup3.Checked[0]:=curldefcontinue;
    frconfig.CheckGroup4.Checked[0]:=autostartwithsystem;
    frconfig.CheckGroup4.Checked[1]:=autostartminimized;
    frconfig.Checkbox1.Checked:=logger;
    frconfig.DirectoryEdit2.Text:=logpath;
    frconfig.RadioGroup1.ItemIndex:=notifipos;
    frconfig.SpinEdit10.Value:=dtimeout;
    frconfig.SpinEdit11.Value:=dtries;
    frconfig.SpinEdit12.Value:=ddelay;
    Case useproxy of
      0,1:
        begin
          frconfig.edtHTTPhost.Enabled:=false;
          frconfig.edtSSLhost.Enabled:=false;
          frconfig.edtFTPhost.Enabled:=false;
          frconfig.edtNoProxyHosts.Enabled:=false;
          frconfig.edtProxyUser.Enabled:=false;
          frconfig.edtProxyPass.Enabled:=false;
          frconfig.lblHTTPhost.Enabled:=false;
          frconfig.lblSSLhost.Enabled:=false;
          frconfig.lblFTPhost.Enabled:=false;
          frconfig.lblHTTPport.Enabled:=false;
          frconfig.lblSSLport.Enabled:=false;
          frconfig.lblFTPport.Enabled:=false;
          frconfig.lblNoProxyHosts.Enabled:=false;
          frconfig.lblProxyUser.Enabled:=false;
          frconfig.lblProxyPass.Enabled:=false;
          frconfig.lblNoProxyHelp.Enabled:=false;
          frconfig.seHTTPport.Enabled:=false;
          frconfig.seSSLport.Enabled:=false;
          frconfig.seFTPport.Enabled:=false;
          frconfig.chSameProxy.Enabled:=false;
          frconfig.chUseAuth.Enabled:=false;
        end;
      2,3:
        begin
          frconfig.edtHTTPhost.Enabled:=true;
          frconfig.edtSSLhost.Enabled:=true;
          frconfig.edtFTPhost.Enabled:=true;
          frconfig.edtNoProxyHosts.Enabled:=true;
          frconfig.edtProxyUser.Enabled:=true;
          frconfig.edtProxyPass.Enabled:=true;
          frconfig.lblHTTPhost.Enabled:=true;
          frconfig.lblSSLhost.Enabled:=true;
          frconfig.lblFTPhost.Enabled:=true;
          frconfig.lblHTTPport.Enabled:=true;
          frconfig.lblSSLport.Enabled:=true;
          frconfig.lblFTPport.Enabled:=true;
          frconfig.lblNoProxyHosts.Enabled:=true;
          frconfig.lblProxyUser.Enabled:=true;
          frconfig.lblProxyPass.Enabled:=true;
          frconfig.lblNoProxyHelp.Enabled:=true;
          frconfig.seHTTPport.Enabled:=true;
          frconfig.seSSLport.Enabled:=true;
          frconfig.seFTPport.Enabled:=true;
          frconfig.chSameProxy.Enabled:=true;
          frconfig.chUseAuth.Enabled:=true;
        end;
    end;
    frconfig.ComboBox2.Items.Clear;
    if FindFirst(ExtractFilePath(UTF8ToSys(Application.Params[0]))+pathdelim+'languages'+pathdelim+'awgg.*.po',faAnyFile,itemfile)=0 then
    begin
      Repeat
        try
          frconfig.ComboBox2.Items.Add(Copy(itemfile.name,Pos('awgg.',itemfile.name)+5,Pos('.po',itemfile.name)-6));
        except
        on E:Exception do ShowMessage('The file '+itemfile.Name+' of language is not valid');
        end;
      Until FindNext(itemfile)<>0;
    end;
    frconfig.ComboBox2.ItemIndex:=frconfig.ComboBox2.Items.IndexOf(deflanguage);
    enginereload();
    frconfig.CheckBox7.Checked:=playsounds;
    frconfig.CheckBox9.Checked:=queuerotate;
    frconfig.FileNameEdit6.Text:=downcompsound;
    frconfig.FileNameEdit7.Text:=downstopsound;
    frconfig.SpinEdit13.Value:=triesrotate;
    if rotatemode=0 then
      frconfig.RadioButton1.Checked:=true;
    if rotatemode=1 then
      frconfig.RadioButton2.Checked:=true;
    if rotatemode=2 then
      frconfig.RadioButton3.Checked:=true;
    frconfig.SpinEdit14.Value:=queuedelay;
    frconfig.CheckBox14.Checked:=useglobaluseragent;
    frconfig.Edit11.Text:=globaluseragent;
    frconfig.chSameProxy.Checked:=sameproxyforall;
    frconfig.CheckBox12.Checked:=loadhistorylog;
    if loadhistorymode=1 then
      frconfig.RadioButton4.Checked:=true;
    if loadhistorymode=2 then
      frconfig.RadioButton5.Checked:=true;
    frconfig.ComboBox4.Items.Clear;
    for i:=0 to Length(queues)-1 do
    begin
      frconfig.ComboBox4.Items.Add(queuenames[i]);
    end;
    ///////////////////////
    frconfig.ComboBox4.ItemIndex:=0;
    if (frmain.tvMain.SelectionCount>0) then
    begin
      if frmain.tvMain.Selected.Level>0 then
      begin
        case frmain.tvMain.Selected.Parent.Index of
          1:begin//colas
              frconfig.ComboBox4.ItemIndex:=frmain.tvMain.Selected.Index;
            end;
        end;
      end;
    end;
    ///////////////////////
    frconfig.CheckBox11.Checked:=qtimerenable[frconfig.ComboBox4.ItemIndex];
    frconfig.CheckBox3.Checked:=qallday[frconfig.ComboBox4.ItemIndex];
    frconfig.DateTimePicker1.Time:=queuestarttimes[frconfig.ComboBox4.ItemIndex];
    frconfig.DateEdit1.Date:=queuestartdates[frconfig.ComboBox4.ItemIndex];
    frconfig.CheckBox10.Checked:=qstop[frconfig.ComboBox4.ItemIndex];
    frconfig.DateTimePicker2.Time:=queuestoptimes[frconfig.ComboBox4.ItemIndex];
    frconfig.DateEdit2.Date:=queuestopdates[frconfig.ComboBox4.ItemIndex];
    frconfig.CheckGroup5.Checked[0]:=qdomingo[frconfig.ComboBox4.ItemIndex];
    frconfig.CheckGroup5.Checked[1]:=qlunes[frconfig.ComboBox4.ItemIndex];
    frconfig.CheckGroup5.Checked[2]:=qmartes[frconfig.ComboBox4.ItemIndex];
    frconfig.CheckGroup5.Checked[3]:=qmiercoles[frconfig.ComboBox4.ItemIndex];
    frconfig.CheckGroup5.Checked[4]:=qjueves[frconfig.ComboBox4.ItemIndex];
    frconfig.CheckGroup5.Checked[5]:=qviernes[frconfig.ComboBox4.ItemIndex];
    frconfig.CheckGroup5.Checked[6]:=qsabado[frconfig.ComboBox4.ItemIndex];
    frconfig.CheckBox8.Checked:=queuelimits[frconfig.ComboBox4.ItemIndex];
    frconfig.CheckBox13.Checked:=queuepoweroff[frconfig.ComboBox4.ItemIndex];
    case defaultdirmode of
      1:frconfig.RadioButton6.Checked:=true;
      2:frconfig.RadioButton6.Checked:=false;
    end;
    categoryextencionstmp:=categoryextencions;
  except on e:exception do
    ShowMessage(e.Message);
  end;
end;

procedure startsheduletimer();
begin
  if frmain.tvMain.SelectionCount>0 then
  begin
    if frmain.tvMain.Selected.Level>0 then
    begin
      case frmain.tvMain.Selected.Parent.Index of
        1:begin//colas
            if qtimerenable[frmain.tvMain.Selected.Index] then
              stimer[frmain.tvMain.Selected.Index].Enabled:=true
            else
            begin
              frconfig.PageControl1.TabIndex:=1;
              configdlg();
              frconfig.ShowModal;
            end;
          end;
        2:begin //filtros
          end;
      end;
   end
   else
   begin

   end;
  end;
end;

procedure stopall(force:boolean);
var
  i:integer;
begin
  frmain.ClipBoardTimer.Enabled:=false;
  for i:=0 to Length(queues)-1 do
  begin
    stimer[i].Enabled:=false;
    qtimer[i].Enabled:=false;
  end;
  for  i:=0 to frmain.lvMain.Items.Count-1 do
  begin
    try
      if frmain.lvMain.Items[i].SubItems[columnstatus]='1' then
      begin
      if force then
        hilo[strtoint(frmain.lvMain.Items[i].SubItems[columnid])].wthp.Terminate(0)
      else
        hilo[strtoint(frmain.lvMain.Items[i].SubItems[columnid])].shutdown();
      end;
      sleep(1);
    except on e:exception do
    end;
  end;
  if frmain.lvMain.ItemIndex<>-1 then
  begin
    frmain.tbStartDown.Enabled:=true;
    frmain.tbStopDown.Enabled:=false;
  end;
end;

procedure downloadstart(indice:integer;restart:boolean);
var
  tmps{$IFDEF UNIX}{,wgetc}{$ENDIF},aria2cc{,curlc}:TStringList;
  uandp:string;
  wrn:integer;
  thnum:integer;
  downid:integer;
begin
  if Not DirectoryExistsUTF8(frmain.lvMain.Items[indice].SubItems[columndestiny]) then
  begin
    ForceDirectory(frmain.lvMain.Items[indice].SubItems[columndestiny]);
  end;
  if indice<>-1 then
  begin
    if frmain.lvMain.Items[indice].SubItems[columnstatus]<>'1' then
    begin
      tmps:=TstringList.Create;
      if frmain.lvMain.Items[indice].SubItems[columntype]='0' then
      begin
        ///////////////////***WGET****////////////////////
        if frmain.lvMain.Items[indice].SubItems[columnengine]='wget' then
        begin
        ////USAR un archivo de configuracion limpio
          {$IFDEF UNIX}
            //No trabaja en versiones antiguas de wget
            //try
              //if FileExists(configpath+'.wgetrc')=false then
              //begin
                //wgetc:=TStringList.Create;
                //wgetc.Add('#This is a WGET config file created by AWGG, please not change it.');
                //wgetc.Add('passive_ftp = on');
                //wgetc.Add('recursive = off');
                //wgetc.SaveToFile(configpath+'.wgetrc');
              //end;
              //tmps.Add('--config='+ExtractShortPathName(configpath)+'.wgetrc');
            //except on e:exception do
            //end;
          {$ENDIF}
          ////Parametros generales
          if WordCount(wgetargs,[' '])>0 then
          begin
            for wrn:=1 to WordCount(wgetargs,[' ']) do
              tmps.Add(ExtractWord(wrn,wgetargs,[' ']));
          end;
          ////Parametros para cada descarga
          if WordCount(frmain.lvMain.Items[indice].SubItems[columnparameters],[' '])>0 then
          begin
            for wrn:=1 to WordCount(frmain.lvMain.Items[indice].SubItems[columnparameters],[' ']) do
              tmps.Add(ExtractWord(wrn,frmain.lvMain.Items[indice].SubItems[columnparameters],[' ']));
          end;
          tmps.Add('-e');
          tmps.Add('recursive=off');//Descativar para la opcion -O
          tmps.Add('-S');//Mouestra la respuesta del servidor
          if frmain.lvMain.Items[indice].SubItems[columnname]<>'' then
          begin
            tmps.Add('-O');
            tmps.Add(UTF8ToSys(frmain.lvMain.Items[indice].SubItems[columnname]));
          end;
          if useaut then
            uandp:=puser+':'+ppassword+'@'
          else
            uandp:='';
          case useproxy of
            0:tmps.Add('--no-proxy');
            2:
            begin
              tmps.Add('-e');
              tmps.Add('http_proxy=http://'+uandp+phttp+':'+phttpport+'/');
              tmps.Add('-e');
              tmps.Add('https_proxy=http://'+uandp+phttps+':'+phttpsport+'/');
              tmps.Add('-e');
              tmps.Add('ftp_proxy=http://'+uandp+pftp+':'+pftpport+'/');
              if nphost<>'' then
              begin
                tmps.Add('-e');
                tmps.Add('no_proxy="'+nphost+'"');
              end;
            end;
          end;
          if wgetdefcontinue then
            tmps.Add('-c');//Continuar descarga
          tmps.Add('--progress=bar:force');
          if frmain.cbLimit.Checked then
            tmps.Add('--limit-rate='+floattostr(frmain.fseLimit.Value)+'k');//limite de velocidad
          if wgetdefnh then
            tmps.Add('-nH');//No crear directorios del Host
          if wgetdefnd then
            tmps.Add('-nd');//No crear directorios
          if wgetdefncert then
            tmps.Add('--no-check-certificate');//No verificar certificados SSL
          tmps.Add('-P');//Destino de la descarga
          tmps.Add('"'+ExtractShortPathName(UTF8ToSys(frmain.lvMain.Items[indice].SubItems[columndestiny]))+'"');
          tmps.Add('-t');
          tmps.Add(inttostr(dtries));
          tmps.Add('-T');
          tmps.Add(inttostr(dtimeout));
          tmps.Add('-w');
          tmps.Add(inttostr(ddelay));
          if (frmain.lvMain.Items[indice].SubItems[columnuser]<>'') and (frmain.lvMain.Items[indice].SubItems[columnpass]<>'') then
          begin
            if UpperCase(Copy(frmain.lvMain.Items[indice].SubItems[columnurl],0,3))='HTT' then
            begin
              tmps.Add('--http-user='+frmain.lvMain.Items[indice].SubItems[columnuser]);
              tmps.Add('--http-password='+frmain.lvMain.Items[indice].SubItems[columnpass]);
            end;
            if UpperCase(Copy(frmain.lvMain.Items[indice].SubItems[columnurl],0,3))='FTP' then
            begin
              tmps.Add('--ftp-user='+frmain.lvMain.Items[indice].SubItems[columnuser]);
              tmps.Add('--ftp-password='+frmain.lvMain.Items[indice].SubItems[columnpass]);
            end;
          end;
          if (frmain.lvMain.Items[indice].SubItems[columnuseragent]<>'') then
          begin
            tmps.Add('--user-agent="'+frmain.lvMain.Items[indice].SubItems[columnuseragent]+'"');
          end
          else
          begin
            if useglobaluseragent then
              tmps.Add('--user-agent="'+globaluseragent+'"');
          end;
          if (frmain.lvMain.Items[indice].SubItems[columncookie]<>'') and FileExists(frmain.lvMain.Items[indice].SubItems[columncookie]) then
          begin
            tmps.Add('--content-disposition');
            tmps.Add('--load-cookies='+frmain.lvMain.Items[indice].SubItems[columncookie]);
          end;
          if (frmain.lvMain.Items[indice].SubItems[columnreferer]<>'') then
          begin
            tmps.Add('--referer='+frmain.lvMain.Items[indice].SubItems[columnreferer]);
          end;
          if (frmain.lvMain.Items[indice].SubItems[columnpost]<>'') then
          begin
            tmps.Add('--post-data='+frmain.lvMain.Items[indice].SubItems[columnpost]);
          end;
          if (frmain.lvMain.Items[indice].SubItems[columnheader]<>'') then
          begin
            tmps.Add('--header=Cookie:"'+frmain.lvMain.Items[indice].SubItems[columnheader]+'"');
          end;
          if FileExists(frmain.lvMain.Items[indice].SubItems[columnurl]) then
            tmps.Add('-i');//Fichero de entrada
          tmps.Add(frmain.lvMain.Items[indice].SubItems[columnurl]);
        end;
        /////////////////***END***//////////////////

        /////////////////***ARIA2***///////////////
        if frmain.lvMain.Items[indice].SubItems[columnengine] = 'aria2c' then
        begin
          //Usar un archivo de configuracion limpio
          try
            if FileExists(configpath+'aria2.conf')=false then
            begin
              aria2cc:=TStringList.Create;
              aria2cc.Add('#This is a Aria2 config file created by AWGG, please not change it.');
              aria2cc.SaveToFile(configpath+'aria2.conf');
            end;
            tmps.Add('--conf-path='+ExtractShortPathName(configpath)+'aria2.conf');
          except on e:exception do
          end;
          ////Parametros generales
          if WordCount(aria2cargs,[' '])>0 then
          begin
            for wrn:=1 to WordCount(aria2cargs,[' ']) do
              tmps.Add(ExtractWord(wrn,aria2cargs,[' ']));
          end;
          if aria2split then
          begin
            tmps.Add('-x');
            tmps.Add('16');
            tmps.Add('-k');
            tmps.Add(aria2splitsize);
            tmps.Add('-s');
            tmps.Add(inttostr(aria2splitnum));
          end;
          ////Parametros para cada descarga
          if WordCount(frmain.lvMain.Items[indice].SubItems[columnparameters],[' '])>0 then
          begin
            for wrn:=1 to WordCount(frmain.lvMain.Items[indice].SubItems[columnparameters],[' ']) do
              tmps.Add(ExtractWord(wrn,frmain.lvMain.Items[indice].SubItems[columnparameters],[' ']));
          end;
          tmps.Add('--check-certificate=false');//Ignorar certificados
          tmps.Add('--summary-interval=1');//intervalo del sumario de descargas
          if frmain.lvMain.Items[indice].SubItems[columnname]<>'' then
          begin
            tmps.Add('-o');
            tmps.Add(UTF8ToSys(frmain.lvMain.Items[indice].SubItems[columnname]));
          end;
          if aria2cdefcontinue and (not restart) then
            tmps.Add('-c');
          if restart then
            tmps.Add('--allow-overwrite=true');
          if aria2cdefallocate then
            tmps.Add('--file-allocation=none');
          Case useproxy of
            0:tmps.Add('--no-proxy=*.*');
            2:
              begin
                if nphost<>'' then
                  tmps.Add('--no-proxy="'+nphost+'"');
                tmps.Add('--http-proxy='+phttp+':'+phttpport);
                tmps.Add('--https-proxy='+phttps+':'+phttpsport);
                tmps.Add('--ftp-proxy='+pftp+':'+pftpport);
                if useaut then
                begin
                  tmps.Add('--http-proxy-user='+puser);
                  tmps.Add('--http-proxy-passwd='+ppassword);
                end;
              end;
          end;
          tmps.Add('-d');
          tmps.Add(ExtractShortPathName(UTF8ToSys(frmain.lvMain.Items[indice].SubItems[columndestiny])));
          if frmain.cbLimit.Checked then
            tmps.Add('--max-download-limit='+floattostr(frmain.fseLimit.Value)+'K');
          tmps.Add('-m');
          tmps.Add(inttostr(dtries));
          tmps.Add('-t');
          tmps.Add(inttostr(dtimeout));
          tmps.Add('--retry-wait='+inttostr(ddelay));
          if (frmain.lvMain.Items[indice].SubItems[columnuser]<>'') and (frmain.lvMain.Items[indice].SubItems[columnpass]<>'') then
          begin
            if UpperCase(Copy(frmain.lvMain.Items[indice].SubItems[columnurl],0,3))='HTT' then
            begin
              tmps.Add('--http-user='+frmain.lvMain.Items[indice].SubItems[columnuser]);
              tmps.Add('--http-passwd='+frmain.lvMain.Items[indice].SubItems[columnpass]);
            end;
            if UpperCase(Copy(frmain.lvMain.Items[indice].SubItems[columnurl],0,3))='FTP' then
            begin
              tmps.Add('--ftp-user='+frmain.lvMain.Items[indice].SubItems[columnuser]);
              tmps.Add('--ftp-passwd='+frmain.lvMain.Items[indice].SubItems[columnpass]);
            end;
          end;
          if (frmain.lvMain.Items[indice].SubItems[columnuseragent]<>'') then
          begin
            tmps.Add('--user-agent="'+frmain.lvMain.Items[indice].SubItems[columnuseragent]+'"');
          end
          else
          begin
            if useglobaluseragent then
              tmps.Add('--user-agent="'+globaluseragent+'"');
          end;
          if (frmain.lvMain.Items[indice].SubItems[columncookie]<>'') and FileExists(frmain.lvMain.Items[indice].SubItems[columncookie]) then
          begin
            tmps.Add('--load-cookies='+frmain.lvMain.Items[indice].SubItems[columncookie]);
          end;
          if (frmain.lvMain.Items[indice].SubItems[columnreferer]<>'') then
          begin
           tmps.Add('--referer='+frmain.lvMain.Items[indice].SubItems[columnreferer]);
          end;
          if (frmain.lvMain.Items[indice].SubItems[columnheader]<>'') then
          begin
           tmps.Add('--header="'+frmain.lvMain.Items[indice].SubItems[columnheader]+'"');
          end;

          tmps.Add(frmain.lvMain.Items[indice].SubItems[columnurl]);
        end;
        ///////////////***END***////////////////

        //////////////***CURL***////////////////
        if frmain.lvMain.Items[indice].SubItems[columnengine] = 'curl' then
        begin
          //Usar un archivo de configuracion limpio
          {try
            if FileExists(UTF8ToSys(configpath)+'curl.conf')=false then
            begin
              curlc:=TStringList.Create;
              curlc.Add('#This is a cURL config file created by AWGG, please not change it.');
              curlc.SaveToFile(configpath+'curl.conf');
              tmps.Add('-config');
              tmps.Add(ExtractShortPathName(UTF8ToSys(configpath))+'curl.conf');
            end;
          except on e:exception do
          end;}
          ////Parametros generales
          if WordCount(curlargs,[' '])>0 then
          begin
            for wrn:=1 to WordCount(curlargs,[' ']) do
              tmps.Add(ExtractWord(wrn,curlargs,[' ']));
          end;
          ////Parametros para cada descarga
          if WordCount(frmain.lvMain.Items[indice].SubItems[columnparameters],[' '])>0 then
          begin
            for wrn:=1 to WordCount(frmain.lvMain.Items[indice].SubItems[columnparameters],[' ']) do
              tmps.Add(ExtractWord(wrn,frmain.lvMain.Items[indice].SubItems[columnparameters],[' ']));
          end;
          tmps.Add('-k');//Ignorar certificados
          tmps.Add('-i');//Muestra la respuesta del servidor
          if frmain.lvMain.Items[indice].SubItems[columnname]<>'' then
          begin
            tmps.Add('-o');
            tmps.Add(UTF8ToSys(frmain.lvMain.Items[indice].SubItems[columnname]));
          end;
          tmps.Add('-O');
          if curldefcontinue and (not restart) then
          begin
            tmps.Add('-C');
            tmps.Add('-');
          end;
          if frmain.cbLimit.Checked then
          begin
            tmps.Add('--limit-rate');
            tmps.Add(inttostr(round(frmain.fseLimit.Value))+'K');
          end;
          Case useproxy of
            0:
            begin
                tmps.Add('--noproxy');
                tmps.Add('*');
            end;
            2:
            begin
              tmps.Add('--proxy1.0');
              tmps.Add(phttp+':'+phttpport);
              if nphost<>'' then
              begin
                tmps.Add('--noproxy');
                tmps.Add('"'+nphost+'"');
              end;
              if useaut then
              begin
                tmps.Add('--proxy-user');
                tmps.Add(puser+':'+ppassword);
              end;
            end;
          end;
          tmps.Add('--retry');
          tmps.Add(inttostr(dtries));
          tmps.Add('--retry-max-time');
          tmps.Add(inttostr(dtimeout));
          tmps.Add('--retry-delay');
          tmps.Add(inttostr(ddelay));
          if (frmain.lvMain.Items[indice].SubItems[columnuser]<>'') and (frmain.lvMain.Items[indice].SubItems[columnpass]<>'') then
          begin
            tmps.Add('-u');
            tmps.Add(frmain.lvMain.Items[indice].SubItems[columnuser]+':'+frmain.lvMain.Items[indice].SubItems[columnpass]);
          end;
          if (frmain.lvMain.Items[indice].SubItems[columnuseragent]<>'') then
          begin
            tmps.Add('-A');
            tmps.Add('"'+frmain.lvMain.Items[indice].SubItems[columnuseragent]+'"');
          end
          else
          begin
            if useglobaluseragent then
            begin
              tmps.Add('-A');
              tmps.Add('"'+globaluseragent+'"');
            end;
          end;
          if (frmain.lvMain.Items[indice].SubItems[columncookie]<>'') and FileExists(frmain.lvMain.Items[indice].SubItems[columncookie]) then
          begin
            tmps.Add('-b');
            tmps.Add(frmain.lvMain.Items[indice].SubItems[columncookie]);
          end;
          if (frmain.lvMain.Items[indice].SubItems[columnreferer]<>'') then
          begin
            tmps.Add('--referer');
            tmps.Add(frmain.lvMain.Items[indice].SubItems[columnreferer]);
          end;
          if (frmain.lvMain.Items[indice].SubItems[columnpost]<>'') then
          begin
            tmps.Add('-d');
            tmps.Add(frmain.lvMain.Items[indice].SubItems[columnpost]);
          end;
          if (frmain.lvMain.Items[indice].SubItems[columnheader]<>'') then
          begin
            tmps.Add('-b');
            tmps.Add('"'+frmain.lvMain.Items[indice].SubItems[columnheader]+'"');
          end;
          tmps.Add(frmain.lvMain.Items[indice].SubItems[columnurl]);
        end;
        /////////////////***END***////////////////////

        /////////////////***AXEL***//////////////////
        if frmain.lvMain.Items[indice].SubItems[columnengine] = 'axel' then
        begin
          ////Parametros generales
          if WordCount(axelargs,[' '])>0 then
          begin
            for wrn:=1 to WordCount(axelargs,[' ']) do
              tmps.Add(ExtractWord(wrn,axelargs,[' ']));
          end;
          ////Parametros para cada descarga
          if WordCount(frmain.lvMain.Items[indice].SubItems[columnparameters],[' '])>0 then
          begin
           for wrn:=1 to WordCount(frmain.lvMain.Items[indice].SubItems[columnparameters],[' ']) do
             tmps.Add(ExtractWord(wrn,frmain.lvMain.Items[indice].SubItems[columnparameters],[' ']));
          end;
          if frmain.cbLimit.Checked then
          begin
            tmps.Add('-s');
            tmps.Add(floattostr(frmain.fseLimit.Value*1024));
          end;
          tmps.Add('-v');
          tmps.Add('-a');
          case useproxy of
            0:tmps.Add('-N');
           {3:begin
           //Tal vez modificar la configuracion de .axelrc al vuelo
              end;}
          end;
          if frmain.lvMain.Items[indice].SubItems[columnname]<>'' then
          begin
            tmps.Add('-o');
            tmps.Add(UTF8ToSys(frmain.lvMain.Items[indice].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[indice].SubItems[columnname]));
          end;
          if frmain.lvMain.Items[indice].SubItems[columnheader]<>'' then
          begin
            tmps.add('--header="'+frmain.lvMain.Items[indice].SubItems[columnheader]+'"');
          end;
          if frmain.lvMain.Items[indice].SubItems[columnuseragent]<>'' then
          begin
            tmps.Add('--user-agent="'+frmain.lvMain.Items[indice].SubItems[columnuseragent]+'"');
          end
          else
          begin
            if useglobaluseragent then
              tmps.Add('--user-agent="'+globaluseragent+'"');
          end;
          tmps.Add(frmain.lvMain.Items[indice].SubItems[columnurl]);
        end;
        ///////////////////***END***///////////////////

        ///////////////////***LFTP***//////////////////
        if frmain.lvMain.Items[indice].SubItems[columnengine] = 'lftp' then
        begin
          ////Parametros generales
          if WordCount(lftpargs,[' '])>0 then
          begin
            for wrn:=1 to WordCount(lftpargs,[' ']) do
              tmps.Add(ExtractWord(wrn,lftpargs,[' ']));
          end;
          ////Parametros para cada descarga
          if WordCount(frmain.lvMain.Items[indice].SubItems[columnparameters],[' '])>0 then
          begin
            for wrn:=1 to WordCount(frmain.lvMain.Items[indice].SubItems[columnparameters],[' ']) do
              tmps.Add(ExtractWord(wrn,frmain.lvMain.Items[indice].SubItems[columnparameters],[' ']));
          end;
          if frmain.cbLimit.Checked then
          begin
            //tmps.Add('-s');
            //tmps.Add(floattostr(frmain.FloatSpinEdit1.Value*1024));
          end;
          case useproxy of
            0:
            begin
              tmps.Add('-c');
              {$IFDEF UNIX}
                tmps.Add('pget -c -n 4 "'+frmain.lvMain.Items[indice].SubItems[columnurl]+'" -o "'+ExtractShortPathName(frmain.lvMain.Items[indice].SubItems[columnname])+'"');
              {$ENDIF}
              {$IFDEF WINDOWS}
                tmps.Add('"pget -c -n 4 '+frmain.lvMain.Items[indice].SubItems[columnurl]+' -o '+ExtractShortPathName(frmain.lvMain.Items[indice].SubItems[columnname])+'"');
              {$ENDIF}
            end;
            2:
            begin
              tmps.Add('-c');
              {$IFDEF UNIX}
                tmps.Add('set http:proxy "http://'+puser+':'+ppassword+'@'+phttp+':'+phttpport+'" && pget -c -n 4 "'+frmain.lvMain.Items[indice].SubItems[columnurl]+'" -o "'+ExtractShortPathName(frmain.lvMain.Items[indice].SubItems[columnname])+'"');
              {$ENDIF}
              {$IFDEF WINDOWS}
                tmps.Add('set http:proxy http://'+puser+':'+ppassword+'@'+phttp+':'+phttpport+' && pget -c -n 4 '+frmain.lvMain.Items[indice].SubItems[columnurl]+' -o "'+ExtractShortPathName(frmain.lvMain.Items[indice].SubItems[columnname])+'"');
              {$ENDIF}
            end;
          end;
          if frmain.lvMain.Items[indice].SubItems[columnname]<>'' then
          begin
            //tmps.Add('-c');
            //tmps.Add('pget -c -n 8 '+frmain.lvMain.Items[indice].SubItems[columnurl]+'" -o "'+ExtractShortPathName(frmain.lvMain.Items[indice].SubItems[columnname])+'"');
          end
          else
          begin
            tmps.Add('-e');
            tmps.Add('pget "'+frmain.lvMain.Items[indice].SubItems[columnurl]+'"');
          end;
        end;
        //////////////////////***END***////////////////////
      end;

      if frmain.lvMain.Items[indice].SubItems[columntype] = '1' then
      begin
        //// Site Grabber implementation *********
        ////USAR un archivo de configuracion limpio
        {$IFDEF UNIX}
          //No trabaja en versiones antiguas de wget
          //try
          //  if FileExists(configpath+'.wgetrc')=false then
          //  begin
          //    wgetc:=TStringList.Create;
          //    wgetc.Add('#This is a WGET config file created by AWGG, please not change it.');
          //    wgetc.Add('passive_ftp = on');
          //    wgetc.Add('recursive = on');
          //    wgetc.SaveToFile(configpath+'.wgetrc');
          //  end;
          //  tmps.Add('--config='+ExtractShortPathName(configpath)+'.wgetrc');
          //except on e:exception do
          //end;
        {$ENDIF}
        tmps.Add('-r');
        tmps.Add('-N');
        tmps.Add('-S');//Mouestra la respuesta del servidor
        tmps.Add('--progress=bar:force');
        tmps.Add('--no-remove-listing');
        tmps.Add('--restrict-file-names=windows');//Nombre de archivos compatibles
        //Parametros por descargas
        if WordCount(frmain.lvMain.Items[indice].SubItems[columnparameters],[' '])>0 then
        begin
          for wrn:=1 to WordCount(frmain.lvMain.Items[indice].SubItems[columnparameters],[' ']) do
            tmps.Add(ExtractWord(wrn,frmain.lvMain.Items[indice].SubItems[columnparameters],[' ']));
        end;
        if useaut then
          uandp:=puser+':'+ppassword+'@'
        else
          uandp:='';
        case useproxy of
          0:tmps.Add('--no-proxy');
          2:
          begin
            tmps.Add('-e');
            tmps.Add('http_proxy=http://'+uandp+phttp+':'+phttpport+'/');
            tmps.Add('-e');
            tmps.Add('https_proxy=http://'+uandp+phttps+':'+phttpsport+'/');
            tmps.Add('-e');
            tmps.Add('ftp_proxy=http://'+uandp+pftp+':'+pftpport+'/');
            if nphost<>'' then
            begin
              tmps.Add('-e');
              tmps.Add('no_proxy="'+nphost+'"');
            end;
          end;
        end;
        if frmain.cbLimit.Checked then
          tmps.Add('--limit-rate='+floattostr(frmain.fseLimit.Value)+'k');//limite de velocidad
        if wgetdefncert then
          tmps.Add('--no-check-certificate');//No verificar certificados SSL
        tmps.Add('-P');//Destino de la descarga
        tmps.Add(ExtractShortPathName(frmain.lvMain.Items[indice].SubItems[columndestiny]));
        tmps.Add('-t');
        tmps.Add(inttostr(dtries));
        tmps.Add('-T');
        tmps.Add(inttostr(dtimeout));
        if (frmain.lvMain.Items[indice].SubItems[columnuser]<>'') and (frmain.lvMain.Items[indice].SubItems[columnpass]<>'') then
        begin
          if UpperCase(Copy(frmain.lvMain.Items[indice].SubItems[columnurl],0,3))='HTT' then
          begin
            tmps.Add('--http-user='+frmain.lvMain.Items[indice].SubItems[columnuser]);
            tmps.Add('--http-password='+frmain.lvMain.Items[indice].SubItems[columnpass]);
          end;
          if UpperCase(Copy(frmain.lvMain.Items[indice].SubItems[columnurl],0,3))='FTP' then
          begin
            tmps.Add('--ftp-user='+frmain.lvMain.Items[indice].SubItems[columnuser]);
            tmps.Add('--ftp-password='+frmain.lvMain.Items[indice].SubItems[columnpass]);
          end;
        end;
        if FileExists(frmain.lvMain.Items[indice].SubItems[columnurl]) then
          tmps.Add('-i');//Fichero de entrada
        tmps.Add(frmain.lvMain.Items[indice].SubItems[columnurl]);
      end;
    frmain.lvMain.Items[indice].SubItems[columnstatus]:='1';
    frmain.lvMain.Items[indice].Caption:=frstrings.statusinprogres.Caption;
    if frmain.lvMain.Items[indice].SubItems[columntype] = '0' then
      frmain.lvMain.Items[indice].ImageIndex:=2;
    if frmain.lvMain.Items[indice].SubItems[columntype] = '1' then
      frmain.lvMain.Items[indice].ImageIndex:=52;
    downid:=strtoint(frmain.lvMain.Items[indice].SubItems[columnid]);

    //El tama;o del array de hilos no debe ser menor que el propio id o la catidad de items
    if downid>=frmain.lvMain.Items.Count then
      thnum:=downid
    else
      thnum:=frmain.lvMain.Items.Count;
    SetLength(hilo,thnum);
    SetLength(trayicons,thnum);
    if Assigned(trayicons[downid])=false then
    begin
      trayicons[downid]:=downtrayicon.Create(nil);
      trayicons[downid].Visible:=showdowntrayicon;
      trayicons[downid].downindex:=downid;
      trayicons[downid].OnDblClick:=@trayicons[downid].showinmain;
      trayicons[downid].OnMouseDown:=@trayicons[downid].contextmenu;
      trayicons[downid].PopUpMenu:=frmain.pmTrayDown;
    end
    else
    begin
      trayicons[downid].Visible:=showdowntrayicon;
    end;
    hilo[downid]:=DownThread.Create(true,tmps);
    SetLength(hilo[downid].wout,thnum);
    hilo[downid].thid:=indice;
    if Assigned(hilo[downid].FatalException) then
      raise hilo[downid].FatalException;
    hilo[downid].Start;
    tmps.Free;
    if (frmain.lvFilter.Visible) then
    begin
      rebuildids();
      //frmain.tvMainSelectionChanged(nil);
      hilo[downid].thid2:=finduid(frmain.lvMain.Items[indice].SubItems[columnuid]);
      if (frmain.lvFilter.Items.Count>hilo[downid].thid2) then
      begin
        if (frmain.lvMain.Items[indice].SubItems[columnuid]=frmain.lvFilter.Items[hilo[downid].thid2].SubItems[columnuid]) then
        begin
          frmain.lvFilter.Items[hilo[downid].thid2].SubItems[columnstatus]:='1';
          frmain.lvFilter.Items[hilo[downid].thid2].Caption:=frstrings.statusinprogres.Caption;
          if frmain.lvFilter.Items[hilo[downid].thid2].SubItems[columntype] = '0' then
            frmain.lvFilter.Items[hilo[downid].thid2].ImageIndex:=2;
          if frmain.lvFilter.Items[hilo[downid].thid2].SubItems[columntype] = '1' then
            frmain.lvFilter.Items[hilo[downid].thid2].ImageIndex:=52;
        end;
      end;
    end;
    frmain.tbStartDown.Enabled:=false;
    frmain.tbStopDown.Enabled:=true;
    frmain.tbRestartNow.Enabled:=false;
    frmain.tbRestartLater.Enabled:=false;
    end;
  end
  else
    frmain.SynEdit1.Lines.Add(frstrings.msgmustselectdownload.Caption);
  if columncolav then
  begin
    frmain.lvMain.Columns[0].Width:=columncolaw;
    frmain.lvFilter.Columns[0].Width:=columncolaw;
  end;
end;

function destinyexists(destiny:string;newurl:string):boolean;
var
  ni:integer;
  pathnodelim:string;
  downexists:boolean;
begin
  downexists:=false;
  for ni:=0 to frmain.lvMain.Items.Count-1 do
  begin
    pathnodelim:=frmain.lvMain.Items[ni].SubItems[columndestiny];
    if ExpandFileName(pathnodelim+pathdelim+frmain.lvMain.Items[ni].SubItems[columnname]) = ExpandFileName(destiny) then
    begin
      downexists:=true;
      if newurl<>'' then
      begin
        frmain.lvMain.Items[ni].SubItems[columnurl]:=newurl;
        if iniciar and frnewdown.Button4.Visible then
        begin
          queuemanual[strtoint(frmain.lvMain.Items[ni].SubItems[columnqueue])]:=true;
          downloadstart(ni,false);
        end;
        if cola then
        begin
          queuemanual[strtoint(frmain.lvMain.Items[ni].SubItems[columnqueue])]:=true;
          qtimer[strtoint(frmain.lvMain.Items[ni].SubItems[columnqueue])].Enabled:=true;
        end;
      end;
    end;
  end;
  result:=downexists;
end;

procedure queuetimer.ontime(Sender:TObject);
var
  i,maxcdown:integer;
begin
  maxcdown:=0;
  for i:=0 to frmain.lvMain.Items.Count-1 do
  begin
    if (frmain.lvMain.Items[i].SubItems[columnstatus]='1') and (frmain.lvMain.Items[i].SubItems[columnqueue]=inttostr(self.qtindex)) then
      inc(maxcdown);
  end;
  for i:=0 to frmain.lvMain.Items.Count-1 do
  begin
    if (frmain.lvMain.Items[i].SubItems[columnqueue]=inttostr(self.qtindex)) and (maxcdown<frmain.seMaxDownInProgress.Value) and ((frmain.lvMain.Items[i].SubItems[columnstatus]='') or (frmain.lvMain.Items[i].SubItems[columnstatus]='2') or (frmain.lvMain.Items[i].SubItems[columnstatus]='0') or (frmain.lvMain.Items[i].SubItems[columnstatus]='4')) and (strtoint(frmain.lvMain.Items[i].SubItems[columntries])>0) then
    begin
      inc(maxcdown);
      downloadstart(i,false);
    end;
  end;
end;

procedure queuetimer.ontimestart(Sender:TObject);
var
  n:integer;
begin
  frmain.tbStartQueue.Enabled:=false;
  frmain.tbStopQueue.Enabled:=true;
  frmain.tvMain.Items[1].Items[self.qtindex].ImageIndex:=46;
  frmain.tvMain.Items[1].Items[self.qtindex].SelectedIndex:=46;
  frmain.tvMain.Items[1].Items[self.qtindex].StateIndex:=40;
  frmain.pmTrayIcon.Items[self.qtindex+5].Caption:=stopqueuesystray+' ('+queuenames[self.qtindex]+')';
  frmain.pmTrayIcon.Items[self.qtindex+5].ImageIndex:=8;
  for n:=0 to frmain.lvMain.Items.Count-1 do
  begin
    if frmain.lvMain.Items[n].SubItems[columnqueue]=inttostr(self.qtindex) then
      frmain.lvMain.Items[n].SubItems[columntries]:=inttostr(triesrotate);
  end;
end;

procedure queuetimer.ontimestop(Sender:TObject);
begin
  frmain.tbStartQueue.Enabled:=true;
  frmain.tbStopQueue.Enabled:=false;
  frmain.tvMain.Items[1].Items[self.qtindex].ImageIndex:=47;
  frmain.tvMain.Items[1].Items[self.qtindex].SelectedIndex:=47;
  frmain.tvMain.Items[1].Items[self.qtindex].StateIndex:=40;
  frmain.pmTrayIcon.Items[self.qtindex+5].Caption:=startqueuesystray+' ('+queuenames[self.qtindex]+')';
  frmain.pmTrayIcon.Items[self.qtindex+5].ImageIndex:=7;
end;

procedure sheduletimer.onstime(Sender:TObject);
var
  hora:TTime;
  fecha:TDate;
  startdatetime:TDatetime;
  stopdatetime:TDateTime;
  checkstart:boolean;
  checkstop:boolean;
  checkdayweek:boolean;
  diasemana:integer;
  semana:array[1..7] of boolean;
begin

  if self.stindex<=Length(queues)-1 then
  begin
    semana[1]:=qdomingo[self.stindex];
    semana[2]:=qlunes[self.stindex];
    semana[3]:=qmartes[self.stindex];
    semana[4]:=qmiercoles[self.stindex];
    semana[5]:=qjueves[self.stindex];
    semana[6]:=qviernes[self.stindex];
    semana[7]:=qsabado[self.stindex];
    hora:=Time();
    fecha:=Date();
    startdatetime:=StrToDateTime(datetostr(queuestartdates[self.stindex])+' '+timetostr(queuestarttimes[self.stindex]));
    stopdatetime:=StrToDateTime(datetostr(queuestopdates[self.stindex])+' '+timetostr(queuestoptimes[self.stindex]));
    diasemana:=DayOfWeek(fecha);
    if qallday[self.stindex] then
    begin
      checkstart:=(hora>=queuestarttimes[self.stindex]);
      if queuestarttimes[self.stindex]>queuestoptimes[self.stindex] then
      begin
        if qstop[self.stindex] then
          checkstop:=(hora<=IncDay(queuestoptimes[self.stindex]))
        else
          checkstop:=true;
      end
      else
      begin
        if qstop[self.stindex] then
          checkstop:=(hora<=queuestoptimes[self.stindex])
        else
          checkstop:=true;
      end;
      checkdayweek:=semana[diasemana];
    end
    else
    begin
      checkstart:=(Now()>=startdatetime);
      if qstop[self.stindex] then
        checkstop:=(Now()<=stopdatetime)
      else
        checkstop:=true;
      checkdayweek:=true;
    end;

    if (checkstart) and (checkstop) and (checkdayweek) then
    begin
      queuemanual[self.stindex]:=false;
      queuesheduledone[self.stindex]:=true;
      if queuelimits[self.stindex] then
        frmain.cbLimit.Checked:=false;
      if qtimer[self.stindex].Enabled =false then
        qtimer[self.stindex].Interval:=1000;
      qtimer[self.stindex].Enabled:=true;
    end
    else
    begin
      if (queuemanual[self.stindex]=false) then
      begin
        stopqueue(self.stindex);
        if queuepoweroff[self.stindex] and (shutingdown=false) and (queuesheduledone[self.stindex]) then
          poweroff;
      end;
    end;
  end;
end;

procedure sheduletimer.onstimestart(Sender:TObject);
begin
  frmain.tbStartScheduler.Enabled:=false;
  frmain.tbStopScheduler.Enabled:=true;
end;

procedure sheduletimer.onstimestop(Sender:TObject);
begin
  frmain.tbStartScheduler.Enabled:=true;
  frmain.tbStopScheduler.Enabled:=false;
end;

procedure restartdownload(indice:integer;ahora:boolean;update:boolean=true);
begin
  if frmain.lvMain.Items[indice].SubItems[columnstatus] <> '1' then
  begin
    if frmain.lvMain.Items[indice].SubItems[columntype]='0' then
    begin
      if FileExists(UTF8ToSys(frmain.lvMain.Items[indice].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[indice].SubItems[columnname])) then
        SysUtils.DeleteFile(UTF8ToSys(frmain.lvMain.Items[indice].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[indice].SubItems[columnname]));

      if (frmain.lvMain.Items[indice].SubItems[columnengine]='aria2c') and (FileExists(UTF8ToSys(frmain.lvMain.Items[indice].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[indice].SubItems[columnname])+'.aria2')) then
        SysUtils.DeleteFile(UTF8ToSys(frmain.lvMain.Items[indice].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[indice].SubItems[columnname])+'.aria2');

      if (frmain.lvMain.Items[indice].SubItems[columnengine]='axel') and (FileExists(UTF8ToSys(frmain.lvMain.Items[indice].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[indice].SubItems[columnname])+'.st')) then
        SysUtils.DeleteFile(UTF8ToSys(frmain.lvMain.Items[indice].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[indice].SubItems[columnname])+'.st');

      if (frmain.lvMain.Items[indice].SubItems[columnengine]='lftp') and (FileExists(UTF8ToSys(frmain.lvMain.Items[indice].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[indice].SubItems[columnname])+'.lftp-pget-status')) then
        SysUtils.DeleteFile(UTF8ToSys(frmain.lvMain.Items[indice].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[indice].SubItems[columnname])+'.lftp-pget-status');

      if FileExists(UTF8ToSys(datapath+pathdelim+frmain.lvMain.Items[indice].SubItems[columnuid])+'.status') then
        SysUtils.DeleteFile(UTF8ToSys(datapath+pathdelim+frmain.lvMain.Items[indice].SubItems[columnuid])+'.status');

      frmain.lvMain.Items[indice].ImageIndex:=18;
    end;
    if frmain.lvMain.Items[indice].SubItems[columntype] = '1' then
    begin
      if FileExists(UTF8ToSys(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columndestiny]+pathdelim+StringReplace(ParseURI(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnurl]).Host+ParseURI(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnurl]).Path,'/',pathdelim,[rfReplaceAll])+pathdelim+'index.html')) then
        DeleteFile(UTF8ToSys(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columndestiny]+pathdelim+StringReplace(ParseURI(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnurl]).Host+ParseURI(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnurl]).Path,'/',pathdelim,[rfReplaceAll])+pathdelim+'index.html'));
      frmain.lvMain.Items[indice].ImageIndex:=51;
    end;
    frmain.lvMain.Items[indice].Caption:=frstrings.statuspaused.Caption;
    frmain.lvMain.Items[indice].SubItems[columnstatus]:='0';
    frmain.lvMain.Items[indice].SubItems[columnpercent]:='-';
    frmain.lvMain.Items[indice].SubItems[columnspeed]:='--';
    frmain.lvMain.Items[indice].SubItems[columnestimate]:='--';
    frmain.lvMain.Items[indice].SubItems[columncurrent]:='0';
    if frmain.lvFilter.Visible and update then
      frmain.tvMainSelectionChanged(nil);
    if ahora then
    begin
      queuemanual[strtoint(frmain.lvMain.Items[indice].SubItems[columnqueue])]:=true;
      downloadstart(indice,true);
    end;
  end;
end;

procedure DownThread.update;
var
  porciento, velocidad, tamano, tiempo, descargado:String;
  icono:TBitmap;
  statusfile:TextFile;
  th,tw:integer;
begin
  porciento:='';
  velocidad:='';
  tamano:='';
  tiempo:='';
  descargado:='';
  if (frmain.lvMain.ItemIndex>-1) and (frmain.micommandFollow.Checked) and (thid=frmain.lvMain.ItemIndex) then
  begin
    if Length(frmain.SynEdit1.Lines.Text)>0 then
      frmain.SynEdit1.SelStart:=Length(frmain.SynEdit1.Lines.Text);
    frmain.SynEdit1.SelEnd:=Length(frmain.SynEdit1.Lines.Text)+1;
    frmain.SynEdit1.InsertTextAtCaret(wout[thid]);
  end;

  /////////////////***WGET***/////////////////////
  if frmain.lvMain.Items[thid].SubItems[columnengine] = 'wget' then
  begin
    if Pos(#10+'Longitud: ',wout[thid])>0 then
    begin
      tamano:=Copy(wout[thid],Pos(#10+'Longitud: ',wout[thid])+10,length(wout[thid]));
      tamano:=Copy(tamano,Pos('(',tamano)+1,length(tamano));
      tamano:=Copy(tamano,0,Pos(')',tamano)-1);
    end;
    if Pos(#10+'Length: ',wout[thid])>0 then
    begin
      tamano:=Copy(wout[thid],Pos(#10+'Length: ',wout[thid])+8,length(wout[thid]));
      tamano:=Copy(tamano,Pos('(',tamano)+1,length(tamano));
      tamano:=Copy(tamano,0,Pos(')',tamano)-1);
    end;
    /////El tamaño mas exacto
    {if Pos(#10+'Longitud: ',wout[thid])>0 then
    begin
      tamano:=Copy(wout[thid],Pos(#10+'Longitud: ',wout[thid])+10,length(wout[thid]));
      tamano:=Copy(tamano,0,Pos('(',tamano)-1);
    end;
    if Pos(#10+'Length: ',wout[thid])>0 then
    begin
      tamano:=Copy(wout[thid],Pos(#10+'Length: ',wout[thid])+8,length(wout[thid]));
      tamano:=Copy(tamano,0,Pos('(',tamano)-1);
    end;}

    if Pos(' guardado [',wout[thid])>0 then
    begin
      descargado:=Copy(wout[thid],Pos(' guardado [',wout[thid])+11,length(wout[thid]));
      descargado:=Copy(tamano,0,Pos('/',tamano)-1);
    end;
    if Pos(' saved [',wout[thid])>0 then
    begin
      descargado:=Copy(wout[thid],Pos(' saved [',wout[thid])+8,length(wout[thid]));
      descargado:=Copy(tamano,0,Pos('/',tamano)-1);
    end;
    if Pos('/',tamano)>0 then
      tamano:='';
    //wget 1.16 cambios en la salida
    if (Pos('% [',wout[thid])>0) or (Pos('%[',wout[thid])>0)  then
    begin
      if (Pos('% [',wout[thid])>0) then
      begin
        porciento:=Copy(wout[thid],Pos('% [',wout[thid])-2,3);
        velocidad:=Copy(wout[thid],Pos('/s ',wout[thid])-6,8);
      end
      else
      begin
        porciento:=Copy(wout[thid],Pos('%[',wout[thid])-2,3);
        velocidad:=Copy(wout[thid],Pos('/s ',wout[thid])-7,9);
      end;
      descargado:=Copy(wout[thid],Pos(']',wout[thid])+1,Length(wout[thid]));
      descargado:=ExtractWord(1,descargado,[' ']);
      if Pos(':',descargado)>0 then
        descargado:='';
      if Pos('T.E. ',wout[thid])>0 then
      begin
        tiempo:=Copy(wout[thid],Pos('T.E. ',wout[thid])+5,length(wout[thid]));
      end;
      if Pos(' eta ',wout[thid])>0 then
      begin
        tiempo:=Copy(wout[thid],Pos(' eta ',wout[thid])+5,length(wout[thid]));
        if Pos('[',tiempo)>0 then
          tiempo:=Copy(tiempo,0,Pos('[',tiempo)-6)
        else
          tiempo:=Copy(tiempo,0,Length(tiempo));
      end;
      if Length(tiempo)>8 then
        tiempo:=copy(tiempo,0,Pos(#13,tiempo)-1);
      if Length(tiempo)>8 then
        tiempo:='';
    end;
    if Pos(' guardado [',wout[thid])>0 then
    begin
      descargado:=Copy(wout[thid],Pos(' guardado [',wout[thid])+11,length(wout[thid]));
      descargado:=Copy(descargado,0,Pos('/',descargado)-1);
    end;
    if Pos(' saved [',wout[thid])>0 then
    begin
      descargado:=Copy(wout[thid],Pos(' saved [',wout[thid])+8,length(wout[thid]));
      descargado:=Copy(descargado,0,Pos('/',descargado)-1);
    end;
    if Pos('<=>',wout[thid])>0 then
    begin
      if Pos('B/s ',wout[thid])>0 then
        velocidad:=Copy(wout[thid],Pos('B/s ',wout[thid])-6,9)
      else
        velocidad:=Copy(wout[thid],Pos('/s ',wout[thid])-5,7);
      descargado:=Copy(wout[thid],Pos('] ',wout[thid])+2,Length(wout[thid]));
      //descargado:=Copy(descargado,0,Pos(' ',descargado));
      descargado:=ExtractWord(1,descargado,[' ']);
    end;
  end;
  ///////////////////***END***///////////////////

  ///////////////////***ARIA2***///////////////////
  if frmain.lvMain.Items[thid].SubItems[columnengine] = 'aria2c' then
  begin
    if Pos('%) ',wout[thid])>0 then
    begin
      porciento:=Copy(wout[thid],Pos('B(',wout[thid])+2,length(wout[thid]));
      porciento:=Copy(porciento,0,Pos('%)',porciento));
      if Pos(' SPD:',wout[thid])>0 then
        velocidad:=Copy(wout[thid],Pos(' SPD:',wout[thid])+5,length(wout[thid]))
      else
        velocidad:=Copy(wout[thid],Pos(' DL:',wout[thid])+4,length(wout[thid]));
      velocidad:=Copy(velocidad,0,Pos('B',velocidad));
      if Pos(' ETA:',wout[thid])>0 then
      begin
        tiempo:=Copy(wout[thid],Pos(' ETA:',wout[thid])+5,length(wout[thid]));
        tiempo:=Copy(tiempo,0,Pos(']',tiempo)-1);
      end;
      if Pos(' SIZE:',wout[thid])>0 then
      begin
        tamano:=Copy(wout[thid],Pos('B/',wout[thid])+2,length(wout[thid]));
        tamano:=Copy(tamano,0,Pos('(',tamano)-1);
        descargado:=Copy(wout[thid],Pos(' SIZE:',wout[thid])+6,length(wout[thid]));
        descargado:=Copy(descargado,0,Pos('/',descargado)-1);
      end;
      //aria2 1.18 cambios en la salida
      if Pos('[#',wout[thid])>0 then
      begin
        tamano:=Copy(wout[thid],Pos('B/',wout[thid])+2,length(wout[thid]));
        tamano:=Copy(tamano,0,Pos('(',tamano)-1);
        descargado:=Copy(wout[thid],Pos('[#',wout[thid])+9,length(wout[thid]));
        descargado:=Copy(descargado,0,Pos('/',descargado)-1);
      end;
    end;
  end;
  /////////////////////***END***//////////////////////

  ////////////////////***CURL***//////////////////////
  if frmain.lvMain.Items[thid].SubItems[columnengine] = 'curl' then
  begin
    if (Pos(':',wout[thid])>0) and (WordCount(wout[thid],[' '])=13) then
    begin
      porciento:=ExtractWord(WordCount(wout[thid],[' '])-11,wout[thid],[' '])+'%';
      velocidad:=ExtractWord(WordCount(wout[thid],[' ']),wout[thid],[' ']);
      tiempo:=ExtractWord(WordCount(wout[thid],[' '])-1,wout[thid],[' ']);
      tamano:=ExtractWord(WordCount(wout[thid],[' '])-10,wout[thid],[' ']);
      descargado:=ExtractWord(WordCount(wout[thid],[' '])-8,wout[thid],[' ']);
    end;
  end;
  ///////////////////***END***////////////////////////

  ///////////////////***AXEL***////////////////////////
  if frmain.lvMain.Items[thid].SubItems[columnengine] = 'axel' then
  begin
    if Pos('File size: ',wout[thid])>0 then
      tamano:=Copy(wout[thid],Pos('File size: ',wout[thid])+11,length(wout[thid]));
    tamano:=Copy(tamano,0,Pos('bytes',tamano)-1);
    if FileExists(frmain.lvMain.Items[thid].SubItems[columndestiny]+pathdelim+UTF8ToSys(frmain.lvMain.Items[thid].SubItems[columnname])) then
      descargado:=inttostr(FileSize(frmain.lvMain.Items[thid].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[thid].SubItems[columnname]));
    if (Pos('%] [',wout[thid])>0) and (WordCount(wout[thid],[']'])>=4) then
    begin
      porciento:=ExtractWord(1,wout[thid],[']']);
      porciento:=Copy(porciento,Pos('[',porciento)+1,length(porciento)-1);
      velocidad:=ExtractWord(WordCount(wout[thid],[']'])-1,wout[thid],[']']);
      velocidad:=Copy(velocidad,Pos('[',velocidad)+1,length(velocidad)-1);
      tiempo:=ExtractWord(4,wout[thid],[']']);
      tiempo:=Copy(tiempo,Pos('[',tiempo)+1,length(tiempo)-1);
    end;
    if Length(tiempo)>8 then
      tiempo:='';
  end;
  ////////////////////***END***////////////////////////////

  ////////////////////***LFTP***///////////////////////////
  if frmain.lvMain.Items[thid].SubItems[columnengine] = 'lftp' then
  begin
    //LFTP UPDATE ****
  end;
  ////////////////////***END***//////////////////////////

  if descargado<>'' then
    frmain.lvMain.Items[thid].SubItems[columncurrent]:=AnsiReplaceStr(descargado,LineEnding,'');
  if porciento<>'' then
    frmain.lvMain.Items[thid].SubItems[columnpercent]:=AnsiReplaceStr(porciento,LineEnding,'');
  if velocidad<>'' then
    frmain.lvMain.Items[thid].SubItems[columnspeed]:=AnsiReplaceStr(velocidad,LineEnding,'');
  if tiempo<>'' then
    frmain.lvMain.Items[thid].SubItems[columnestimate]:=AnsiReplaceStr(tiempo,LineEnding,'');
  if tamano<>'' then
    frmain.lvMain.Items[thid].SubItems[columnsize]:=AnsiReplaceStr(tamano,LineEnding,'');
  ////////////////////////////////////
  if (frmain.lvFilter.Visible) then
  begin
    if (frmain.lvFilter.Items.Count>thid2) then
    begin
      if (frmain.lvMain.Items[thid].SubItems[columnuid]=frmain.lvFilter.Items[thid2].SubItems[columnuid]) then
      begin
        if descargado<>'' then
          frmain.lvFilter.Items[thid2].SubItems[columncurrent]:=AnsiReplaceStr(descargado,LineEnding,'');
        if porciento<>'' then
          frmain.lvFilter.Items[thid2].SubItems[columnpercent]:=AnsiReplaceStr(porciento,LineEnding,'');
        if velocidad<>'' then
          frmain.lvFilter.Items[thid2].SubItems[columnspeed]:=AnsiReplaceStr(velocidad,LineEnding,'');
        if tiempo<>'' then
          frmain.lvFilter.Items[thid2].SubItems[columnestimate]:=AnsiReplaceStr(tiempo,LineEnding,'');
        if tamano<>'' then
          frmain.lvFilter.Items[thid2].SubItems[columnsize]:=AnsiReplaceStr(tamano,LineEnding,'');
      end;
    end;
  end;
  ////////////////////////////////////
  try
    if (porciento<>'') and (thid=frmain.lvMain.ItemIndex) then
    begin
      frmain.pbMain.Style:=pbstNormal;
      frmain.pbMain.Position:=strtoint(Copy(porciento,0,Pos('%',porciento)-1));
    end;
    if ((frmain.lvMain.Items[thid].SubItems[columnpercent]='') or (frmain.lvMain.Items[thid].SubItems[columnpercent]='-')) and (frmain.lvMain.Items[thid].SubItems[columnstatus]='1') and (thid=frmain.lvMain.ItemIndex) then
      frmain.pbMain.Style:=pbstMarquee;
  except on e:exception do
  end;

  if descargado = '' then
  begin
    descargado:=frmain.lvMain.Items[thid].SubItems[columncurrent];
    if descargado = '' then
      descargado:='-';
  end;
  if porciento = '' then
  begin
    porciento:=frmain.lvMain.Items[thid].SubItems[columnpercent];
    if porciento = '' then
      porciento:='-';
  end;
  if tiempo = '' then
  begin
    tiempo:=frmain.lvMain.Items[thid].SubItems[columnestimate];
    if tiempo = '' then
      tiempo:='-';
  end;

  try
    AssignFile(statusfile,datapath+PathDelim+frmain.lvMain.Items[thid].SubItems[columnuid]+'.status');
    if fileExists(configpath+PathDelim+frmain.lvMain.Items[thid].SubItems[columnuid]+'.status')=false then
      ReWrite(statusfile);
    Write(statusfile,frmain.lvMain.Items[thid].SubItems[columnstatus]+'/'+descargado+'/'+porciento+'/'+tiempo);
    CloseFile(statusfile);
  except on e:exception do
    CloseFile(statusfile);
  end;
  //Un icono independiente por cada descarga
  icono:=TBitmap.Create();
  icono.Width:=frmain.MainTrayIcon.Icon.Width;
  icono.Height:=frmain.MainTrayIcon.Icon.Height;
  icono.Canvas.Brush.Color:=clWhite;
  icono.Canvas.Pen.Color:=clBlack;
  if frmain.lvMain.Items[thid].SubItems[columnstatus]='1' then
    icono.Canvas.Font.Color:=clBlack
  else
    icono.Canvas.Font.Color:=clRed;
  icono.Canvas.Font.Bold:=true;
  icono.Canvas.Font.Quality:=fqAntialiased;
  icono.Canvas.Font.Size:=14;
  icono.Canvas.Pen.Width:=1;
  icono.Canvas.Rectangle(1,1,icono.Width,icono.Height);
  icono.Canvas.Pen.Width:=3;
  if porciento<>'-' then
  begin
    porciento:=StringReplace(porciento,'%','',[rfReplaceAll]);
  end
  else
  begin
    if velocidad <> '' then
      porciento:=velocidad
    else
      porciento:='?';
    porciento:=StringReplace(porciento,'KB/s','K',[rfReplaceAll]);
    porciento:=StringReplace(porciento,'MB/s','M',[rfReplaceAll]);
  end;
   porciento:=StringReplace(porciento,' ','',[rfReplaceAll]);
  while(icono.Canvas.TextWidth(porciento)>icono.Width) do
    icono.Canvas.Font.Size:=icono.Canvas.Font.Size-1;
  th:=icono.Canvas.TextHeight(porciento);
  tw:=icono.Canvas.TextWidth(porciento);
  icono.Canvas.TextOut(Round((icono.Width-tw)/2),Round((icono.Height-th)/2),porciento);
  trayicons[thid].Icon.Canvas.Brush.Color:=clWhite;
  trayicons[thid].Icon.Assign(icono);
  trayicons[thid].Animate:=true;///////////Esto es necesario para Qt si no el icono no se actualiza
  trayicons[thid].AnimateInterval:=0;//////y un intervalo que no parpadee
  trayicons[thid].Hint:=frmain.lvMain.Items[thid].SubItems[columnname]+' '+velocidad;
  icono.Destroy;
end;

procedure savemydownloads();
var
  wn:integer;
  inidownloadsfile:TMEMINIFile;
begin
  try
    if FileExists(configpath+'awgg.dat') then
    begin
      FileUtil.CopyFile(ExtractShortPathName(configpath)+'awgg.dat',ExtractShortPathName(configpath)+'awgg.dat.bak',[cffOverwriteFile]);
      SysUtils.DeleteFile(configpath+'awgg.dat');
    end;
    inidownloadsfile:=TMEMINIFile.Create(configpath+'awgg.dat');
    inidownloadsfile.WriteInteger('Total','value',frmain.lvMain.Items.Count);
    for wn:=0 to frmain.lvMain.Items.Count-1 do
    begin
      if frmain.lvMain.Items[wn].SubItems[columnstatus]<> '1' then
      begin
        inidownloadsfile.WriteString('Download'+inttostr(wn),'columnstatus',frmain.lvMain.Items[wn].SubItems[columnstatus]);
        inidownloadsfile.WriteInteger('Download'+inttostr(wn),'icon',frmain.lvMain.Items[wn].ImageIndex);
        inidownloadsfile.WriteString('Download'+inttostr(wn),'status',frmain.lvMain.Items[wn].Caption);
      end
      else
      begin
        inidownloadsfile.WriteString('Download'+inttostr(wn),'columnstatus','2');
        inidownloadsfile.WriteInteger('Download'+inttostr(wn),'icon',3);
        inidownloadsfile.WriteString('Download'+inttostr(wn),'status','Detenido');
      end;
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnname',frmain.lvMain.Items[wn].SubItems[columnname]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnsize',frmain.lvMain.Items[wn].SubItems[columnsize]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columncurrent',frmain.lvMain.Items[wn].SubItems[columncurrent]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnurl',frmain.lvMain.Items[wn].SubItems[columnurl]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnspeed',frmain.lvMain.Items[wn].SubItems[columnspeed]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnpercent',frmain.lvMain.Items[wn].SubItems[columnpercent]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnestimate',frmain.lvMain.Items[wn].SubItems[columnestimate]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columndate',frmain.lvMain.Items[wn].SubItems[columndate]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columndestiny',frmain.lvMain.Items[wn].SubItems[columndestiny]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnengine',frmain.lvMain.Items[wn].SubItems[columnengine]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnparameters',frmain.lvMain.Items[wn].SubItems[columnparameters]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnuser',frmain.lvMain.Items[wn].SubItems[columnuser]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnpass',frmain.lvMain.Items[wn].SubItems[columnpass]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnuid',frmain.lvMain.Items[wn].SubItems[columnuid]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnqueue',frmain.lvMain.Items[wn].SubItems[columnqueue]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columntype',frmain.lvMain.Items[wn].SubItems[columntype]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columncookie',frmain.lvMain.Items[wn].SubItems[columncookie]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnreferer',frmain.lvMain.Items[wn].SubItems[columnreferer]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnpost',frmain.lvMain.Items[wn].SubItems[columnpost]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnheader',frmain.lvMain.Items[wn].SubItems[columnheader]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnuseragent',frmain.lvMain.Items[wn].SubItems[columnuseragent]);
    end;
    if (frmain.lvMain.Items.Count=0) and inidownloadsfile.SectionExists('Download0') then
    begin
      inidownloadsfile.EraseSection('Download0');
      inidownloadsfile.WriteInteger('Total','value',0);
    end;
    inidownloadsfile.WriteInteger('Queues','total',Length(queues));
    for wn:=0 to Length(queues)-1 do
    begin
      inidownloadsfile.WriteString('Queue'+inttostr(wn),'name',queuenames[wn]);
      inidownloadsfile.WriteDate('Queue'+inttostr(wn),'startdate',queuestartdates[wn]);
      inidownloadsfile.WriteDate('Queue'+inttostr(wn),'stopdate',queuestopdates[wn]);
      inidownloadsfile.WriteTime('Queue'+inttostr(wn),'starttime',queuestarttimes[wn]);
      inidownloadsfile.WriteTime('Queue'+inttostr(wn),'stoptime',queuestoptimes[wn]);
      inidownloadsfile.WriteBool('Queue'+inttostr(wn),'domingo',qdomingo[wn]);
      inidownloadsfile.WriteBool('Queue'+inttostr(wn),'lunes',qlunes[wn]);
      inidownloadsfile.WriteBool('Queue'+inttostr(wn),'martes',qlunes[wn]);
      inidownloadsfile.WriteBool('Queue'+inttostr(wn),'miercoles',qmiercoles[wn]);
      inidownloadsfile.WriteBool('Queue'+inttostr(wn),'jueves',qjueves[wn]);
      inidownloadsfile.WriteBool('Queue'+inttostr(wn),'viernes',qviernes[wn]);
      inidownloadsfile.WriteBool('Queue'+inttostr(wn),'sabado',qsabado[wn]);
      inidownloadsfile.WriteBool('Queue'+inttostr(wn),'stop',qstop[wn]);
      inidownloadsfile.WriteBool('Queue'+inttostr(wn),'allday',qallday[wn]);
      inidownloadsfile.WriteBool('Queue'+inttostr(wn),'timerenable',qtimerenable[wn]);
      inidownloadsfile.WriteBool('Queue'+inttostr(wn),'limits',queuelimits[wn]);
      inidownloadsfile.WriteBool('Queue'+inttostr(wn),'poweroff',queuepoweroff[wn]);
    end;
    inidownloadsfile.UpdateFile;
    inidownloadsfile.Free;
  except on e:exception do
  //ShowMessage(rsForm.msgerrordownlistsave.Caption+' '+e.Message);
  end;
end;

procedure importdownloads();
var
  urls:TStringList;
  nurl:integer;
  imitem:TListItem;
  fname:string;
  defaultdir:string='';
begin
  frmain.odlgImportdown.Execute;
  if {$IFDEF LCLQT}(frmain.OpenDialog1.UserChoice=1){$else}frmain.odlgImportdown.FileName<>''{$endif} then
  begin
    urls:=TStringList.Create;
    urls.LoadFromFile(frmain.odlgImportdown.FileName);
    for nurl:=0 to urls.Count-1 do
    begin
      if urlexists(urls[nurl])=false then
      begin
        case defaultdirmode of
          1:defaultdir:=ddowndir;
          2:defaultdir:=suggestdir(ParseURI(urls[nurl]).Document);
        end;
        imitem:=TListItem.Create(frmain.lvMain.Items);
        imitem.Caption:=frstrings.statuspaused.Caption;
        imitem.ImageIndex:=18;
        fname:=ParseURI(urls[nurl]).Document;
        while destinyexists(defaultdir+pathdelim+fname) do
          fname:='_'+fname;
        imitem.SubItems.Add(fname);//Nombre de archivo
        imitem.SubItems.Add('');//Tama;o
        imitem.SubItems.Add('');//Descargado
        imitem.SubItems.Add(urls[nurl]);//URL
        imitem.SubItems.Add('');//Velocidad
        imitem.SubItems.Add('');//Porciento
        imitem.SubItems.Add('');//Estimado
        imitem.SubItems.Add(datetostr(Date())+' '+timetostr(Time()));//Fecha
        imitem.SubItems.Add(defaultdir);//Destino
        imitem.SubItems.Add(defaultengine);//Motor
        imitem.SubItems.Add('');//Parametros
        imitem.SubItems.Add('0');//status
        imitem.SubItems.Add(inttostr(frmain.lvMain.Items.Count));//id
        imitem.SubItems.Add('');//user
        imitem.SubItems.Add('');//pass
        imitem.SubItems.Add(inttostr(triesrotate));//tries
        imitem.SubItems.Add(uidgen());//uid
        imitem.SubItems.Add('0');//queue
        imitem.SubItems.Add('0');//type
        imitem.SubItems.Add('');//cookie
        imitem.SubItems.Add('');//referer
        imitem.SubItems.Add('');//post
        imitem.SubItems.Add('');//header
        imitem.SubItems.Add('');//useragent
        frmain.lvMain.Items.AddItem(imitem);
      end;
    end;
    urls.Destroy;
  end;
  frmain.tvMainSelectionChanged(nil);
  savemydownloads();
end;

procedure exportdownloads();
var
  nurl:integer;
  urlist:TStringList;
begin
  frmain.sdlgExportDown.Execute;
  if {$IFDEF LCLQT}frmain.SaveDialog1.UserChoice=1{$else}frmain.sdlgExportDown.FileName<>''{$endif} then
  begin
    urlist:=TstringList.Create;
    for nurl:=0 to frmain.lvMain.Items.Count-1 do
    begin
      urlist.Add(frmain.lvMain.Items[nurl].SubItems[columnurl]);
    end;
    urlist.SaveToFile(frmain.sdlgExportDown.FileName);
  end;
end;

procedure deleteitems(delfile:boolean);
var
  i,total,n:integer;
  nombres:string;
begin
  nombres:='';
  SetLength(trayicons,frmain.lvMain.Items.Count);
  if (frmain.lvMain.SelCount>0) or (frmain.lvMain.ItemIndex<>-1) then
  begin
    n:=0;
    if frmain.lvMain.SelCount>1 then
    begin
      for i:=0 to frmain.lvMain.Items.Count-1 do
      begin
        if (frmain.lvMain.Items[i].Selected) then
        begin
          if (Length(nombres)<100) and (n<5) then
          begin
            inc(n);
            nombres:=nombres+frmain.lvMain.Items[i].SubItems[columnname]+#10;
          end;
        end;
      end;
      if frmain.lvMain.SelCount>n then
      nombres:=nombres+'...';
    end
    else
      nombres:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnname];
    total:=frmain.lvMain.Items.Count-1;
    frconfirm.Caption:=frstrings.dlgconfirm.Caption;
    if delfile then
      frconfirm.dlgtext.Caption:=frstrings.dlgdeletedownandfile.Caption+' ['+inttostr(frmain.lvMain.SelCount)+']'+#10#13+#10#13+nombres
    else
      frconfirm.dlgtext.Caption:=frstrings.dlgdeletedown.Caption+' ['+inttostr(frmain.lvMain.SelCount)+']'+#10#13+#10#13+nombres;
    frconfirm.ShowModal;
    if dlgcuestion then
    begin
      for i:=total downto 0 do
      begin
        if (frmain.lvMain.Items[i].Selected) and (frmain.lvMain.Items[i].SubItems[columnstatus]<>'1') then
        begin
          //Borrar tambien el historial de la descarga antes de borrar.
          if FileExists(UTF8ToSys(logpath+pathdelim+frmain.lvMain.Items[i].SubItems[columnname])+'.log') then
            SysUtils.DeleteFile(UTF8ToSys(logpath+pathdelim+frmain.lvMain.Items[i].SubItems[columnname])+'.log');
          if FileExists(UTF8ToSys(datapath+pathdelim+frmain.lvMain.Items[i].SubItems[columnuid])+'.status') then
            SysUtils.DeleteFile(UTF8ToSys(datapath+pathdelim+frmain.lvMain.Items[i].SubItems[columnuid])+'.status');
          if frmain.lvMain.Items[i].SubItems[columnname] <> '' then
          begin
            if FileExists(UTF8ToSys(frmain.lvMain.Items[i].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[i].SubItems[columnname])) and delfile and (frmain.lvMain.Items[i].SubItems[columntype]='0') then
              SysUtils.DeleteFile(UTF8ToSys(frmain.lvMain.Items[i].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[i].SubItems[columnname]));
          end;
          if frmain.lvMain.ItemIndex=i then
            frmain.SynEdit1.Lines.Clear;
          refreshicons();
          frmain.lvMain.Items.Delete(i);
        end;
      end;
      rebuildids();
      savemydownloads();
      frmain.pbMain.Position:=0;
      if frmain.lvFilter.Visible then
        frmain.tvMainSelectionChanged(nil);
    end;
  end
  else
    ShowMessage(frstrings.msgmustselectdownload.Caption);
end;

procedure DownThread.shutdown;
begin
  manualshutdown:=true;
  if frmain.lvMain.Items[thid].SubItems[columnengine]='lftp' then
    hilo[thid].wthp.Terminate(0);
end;

procedure DownThread.Execute;
var
  CharBuffer: array [0..2047] of char;
  ReadCount: integer;
  logfile:TextFile;
  {cuadro:Small_Rect;
  cord1,cord2:TCOORD;}
begin
  completado:=false;
  wthp.Options:=[poUsePipes,poStderrToOutPut,poNoConsole];
  Case frmain.lvMain.Items[thid].SubItems[columnengine] of
    'wget':
    begin
      wthp.Executable:=UTF8ToSys(wgetrutebin);
    end;
    'aria2c':
    begin
      wthp.Executable:=UTF8ToSys(aria2crutebin);
    end;
    'curl':
    begin
      wthp.Executable:=UTF8ToSys(curlrutebin);
    end;
    'axel':
    begin
      wthp.Executable:=UTF8ToSys(axelrutebin);
    end;
    'lftp':
    begin
      {$IFDEF UNIX}
        wthp.Executable:='/bin/sh';
        wthp.Parameters.Add('/usr/bin/unbuffer');
        wthp.Parameters.Add(lftprutebin);
      {$ENDIF}
      {$IFDEF WINDOWS}
        {
        cuadro.Bottom:=10;
        cuadro.Left:=10;
        cuadro.Right:=10;
        cuadro.Top:=10;
        if IsConsole=false then
        begin
        AllocConsole;
        IsConsole := True; // in System unit
        SysInitStdIO;
        WriteLn('Hello World');
        end;}
        wthp.Executable:=UTF8ToSys(lftprutebin);
      {$ENDIF}
    end;
  end;
  wthp.Parameters.AddStrings(wpr);
  wpr.Free;
  {$IFDEF ALPHA64}
  wout[thid]:=#10#13+'Executing: '+wthp.Executable+' '+AnsiReplacestr(wthp.Parameters.Text,LineEnding,' ')+' ;End execution line;';
  {$ENDIF}
  if Not DirectoryExists(datapath) then
    CreateDir(datapath);
  Synchronize(@update);
  wthp.CurrentDirectory:=UTF8ToSys(frmain.lvMain.Items[thid].SubItems[columndestiny]);
  try
    wthp.Execute;
    try
      if logger then
      begin
        if Not DirectoryExists(logpath) then
          CreateDir(UTF8ToSys(logpath));
        AssignFile(logfile,UTF8ToSys(logpath)+PathDelim+UTF8ToSys(frmain.lvMain.Items[thid].SubItems[columnname])+'.log');
        if fileExists(logpath+PathDelim+UTF8ToSys(frmain.lvMain.Items[thid].SubItems[columnname])+'.log') then
          Append(logfile)
        else
          ReWrite(logfile);
      end;
    except on e:exception do
    end;
    while (wthp.Running or (wthp.Output.NumBytesAvailable > 0)) and (not manualshutdown) {or
         (wthp.Stderr.NumBytesAvailable > 0)} do
    begin
      //while wthp.Output.NumBytesAvailable >= 1 do
      {$IFDEF UNIX}
        if wthp.Output.NumBytesAvailable > 0 then
        begin
      {$ENDIF}
          ReadCount := Min(2048, wthp.Output.NumBytesAvailable); //Solo leer hasta llenar el buffer
          wthp.Output.Read(CharBuffer, ReadCount);
          //Write(StdOut, Copy(CharBuffer, 0, ReadCount));
          wout[thid]:=Copy(CharBuffer, 0, ReadCount);
          Synchronize(@update);
          try
            if logger then
            Write(logfile,AnsiReplaceStr(AnsiReplaceStr(wout[thid],#13,#10),#10,LineEnding));
          except on e:exception do
          end;
          if (Pos('(OK):download',wout[thid])>0) or (Pos('100%[',wout[thid])>0) or (Pos('%AWGG100OK%',wout[thid])>0) or (Pos('[100%]',wout[thid])>0) or (Pos(' guardado [',wout[thid])>0) or (Pos(' saved [',wout[thid])>0) or (Pos('ERROR 400: Bad Request.',wout[thid])>0) or (Pos('The file is already fully retrieved; nothing to do.',wout[thid])>0) or (Pos('El fichero ya ha sido totalmente recuperado, no hay nada que hacer.',wout[thid])>0) and (frmain.lvMain.Items[thid].SubItems[columntype]='0') then
            completado:=true;
          if (Pos('FINISHED --',wout[thid])>0) or (Pos('Downloaded: ',wout[thid])>0) and (frmain.lvMain.Items[thid].SubItems[columntype]='1') then
            completado:=true;
          //end;
      {$IFDEF UNIX}
        end;
      {$ENDIF}
        sleep(1000);//Sin esto el consumo de CPU es muy alto
    end;
  Except on E:Exception do
    begin
    //wout[thid]:='ERROR!**** '+E.ToString; //Solo para debug
    //Synchronize(@update);                 //Solo para debug
    end;
  end;
  Synchronize(@prepare);
  wout[thid]:=LineEnding+datetostr(Date())+' '+timetostr(Time())+' Exit code=['+inttostr(wthp.ExitStatus)+']';
  //ReadConsoleOutput(wthp.ThreadHandle,wout[thid],cord1,cord2,cuadro);
  Synchronize(@update);
  if logger then
  begin
    Write(logfile,wout[thid]);
    CloseFile(logfile);
  end;
  if manualshutdown then
  begin
    wthp.Terminate(0);
  end;
  wthp.Destroy;
  hilo[thid].Terminate;
end;

procedure DownThread.prepare();
var
  outlines:TStringList;
  otherlistview:boolean;
  tmpsize:string;
  punto:string='';
begin
  otherlistview:=false;
  case frmain.lvMain.Items[thid].SubItems[columnengine] of
    'wget':
    begin
      case wthp.ExitStatus of
        259:completado:=false;
        //0:completado:=true; //Al detener el wget produce el codigo cero tambien
      end;
    end;
    'aria2c':
    begin
      case wthp.ExitStatus of
        259,1,-1:completado:=false;
        0:completado:=true;
      end;
    end;
    'curl':
    begin
      case wthp.ExitStatus of
        259,7,18,1:completado:=false;
        0:completado:=true;
      end;
    end;
  end;
  if (frmain.lvFilter.Visible) then
  begin
    if (frmain.lvFilter.Items.Count>=thid2) then
    begin
      if (frmain.lvMain.Items[thid].SubItems[columnuid]=frmain.lvFilter.Items[thid2].SubItems[columnuid]) then
      begin
        otherlistview:=true;
      end;
    end;
  end;
  frmain.lvMain.Items[thid].SubItems[columnspeed]:='--';
  if frmain.lvMain.ItemIndex=thid then
    frmain.pbMain.Style:=pbstNormal;
  if completado then
  begin
    qtimer[strtoint(frmain.lvMain.Items[thid].SubItems[columnqueue])].Interval:=1000;
    frmain.lvMain.Items[thid].SubItems[columnstatus]:='3';
    frmain.lvMain.Items[thid].Caption:=frstrings.statuscomplete.Caption;
    frmain.lvMain.Items[thid].SubItems[columnpercent]:='100%';
    ///Tama;o automatico
    if (Pos(',',frmain.lvMain.Items[thid].SubItems[columnsize])>0) then
      punto:=',';
    if (Pos('.',frmain.lvMain.Items[thid].SubItems[columnsize])>0) then
      punto:='.';
    if (Pos(',',frmain.lvMain.Items[thid].SubItems[columnsize])>0) or (Pos('.',frmain.lvMain.Items[thid].SubItems[columnsize])>0) then
      tmpsize:=prettysize(FileSize(frmain.lvMain.Items[thid].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[thid].SubItems[columnname]),frmain.lvMain.Items[thid].SubItems[columnengine],-1,punto)
    else
      tmpsize:=prettysize(FileSize(frmain.lvMain.Items[thid].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[thid].SubItems[columnname]),frmain.lvMain.Items[thid].SubItems[columnengine],0,punto);
    if Pos('-',tmpsize)<1 then
    frmain.lvMain.Items[thid].SubItems[columncurrent]:=tmpsize;
    if frmain.lvMain.ItemIndex=thid then
      frmain.pbMain.Position:=100;
    if frmain.lvMain.Items[thid].SubItems[columntype] = '0' then
      frmain.lvMain.Items[thid].ImageIndex:=4;
    if frmain.lvMain.Items[thid].SubItems[columntype] = '1' then
      frmain.lvMain.Items[thid].ImageIndex:=54;
    if otherlistview then
    begin
      frmain.lvFilter.Items[thid2].SubItems[columnstatus]:='3';
      frmain.lvFilter.Items[thid2].Caption:=frstrings.statuscomplete.Caption;
      frmain.lvFilter.Items[thid2].SubItems[columnpercent]:='100%';
      //tama;o automatico
      frmain.lvFilter.Items[thid2].SubItems[columncurrent]:=frmain.lvMain.Items[thid].SubItems[columncurrent];
      frmain.lvFilter.Items[thid2].SubItems[columnspeed]:='--';
      if frmain.lvFilter.Items[thid2].SubItems[columntype] = '0' then
        frmain.lvFilter.Items[thid2].ImageIndex:=4;
      if frmain.lvFilter.Items[thid2].SubItems[columntype] = '1' then
        frmain.lvFilter.Items[thid2].ImageIndex:=54;
    end;
    if (shownotifi) and (frmain.Focused=false) then
    begin
      //////Many notifi forms
      //if frmain.lvMain.Items[thid].SubItems[columnname]<>'' then
        createnewnotifi(frstrings.popuptitlecomplete.Caption,frmain.lvMain.Items[thid].SubItems[columnname],'',frmain.lvMain.Items[thid].SubItems[columndestiny],true);
      //else
        //createnewnotifi(rsForm.popuptitlecomplete.Caption,frmain.lvMain.Items[thid].SubItems[columnurl],'',frmain.lvMain.Items[thid].SubItems[columndestiny],true);
      //////
      try
        if playsounds then
          playsound(downcompsound);
      except on e:exception do
      end;
    end;
    trayicons[thid].Animate:=false;
    trayicons[thid].Icon.Clear;
    trayicons[thid].Visible:=false;
  end
  else
  begin
    if manualshutdown then
    begin
      frmain.lvMain.Items[thid].SubItems[columnstatus]:='2';
      frmain.lvMain.Items[thid].Caption:=frstrings.statusstoped.Caption;
      if frmain.lvMain.Items[thid].SubItems[columntype] = '0' then
        frmain.lvMain.Items[thid].ImageIndex:=3;
      if frmain.lvMain.Items[thid].SubItems[columntype] = '1' then
        frmain.lvMain.Items[thid].ImageIndex:=53;
      if otherlistview then
      begin
        frmain.lvFilter.Items[thid2].SubItems[columnstatus]:='2';
        frmain.lvFilter.Items[thid2].Caption:=frstrings.statusstoped.Caption;
        if frmain.lvMain.Items[thid2].SubItems[columntype] = '0' then
          frmain.lvFilter.Items[thid2].ImageIndex:=3;
        if frmain.lvFilter.Items[thid2].SubItems[columntype] = '1' then
          frmain.lvFilter.Items[thid2].ImageIndex:=53;
      end;
    end
    else
    begin
      frmain.lvMain.Items[thid].SubItems[columnstatus]:='4';
      frmain.lvMain.Items[thid].Caption:=frstrings.statuserror.Caption;
      if frmain.lvMain.Items[thid].SubItems[columntype] = '0' then
        frmain.lvMain.Items[thid].ImageIndex:=3;
      if frmain.lvMain.Items[thid].SubItems[columntype] = '1' then
        frmain.lvMain.Items[thid].ImageIndex:=53;
      if otherlistview then
      begin
        frmain.lvFilter.Items[thid2].SubItems[columnstatus]:='4';
        frmain.lvFilter.Items[thid2].Caption:=frstrings.statuserror.Caption;
        if frmain.lvMain.Items[thid2].SubItems[columntype] = '0' then
          frmain.lvFilter.Items[thid2].ImageIndex:=3;
        if frmain.lvFilter.Items[thid2].SubItems[columntype] = '1' then
          frmain.lvFilter.Items[thid2].ImageIndex:=53;
      end;
      if qtimer[strtoint(frmain.lvMain.Items[thid].SubItems[columnqueue])].Enabled then
      begin
        qtimer[strtoint(frmain.lvMain.Items[thid].SubItems[columnqueue])].Interval:=queuedelay*1000;
      end;
    end;
    frmain.lvMain.Items[thid].SubItems[columnspeed]:='--';
    if otherlistview then
      frmain.lvMain.Items[thid].SubItems[columnspeed]:='--';
    if frmain.lvMain.ItemIndex=thid then
    begin
      frmain.tbStartDown.Enabled:=true;
      frmain.tbStopDown.Enabled:=false;
      frmain.tbRestartNow.Enabled:=true;
      frmain.tbRestartLater.Enabled:=true;
    end;
    if (shownotifi) and (manualshutdown=false) then
    begin
      outlines:=TStringList.Create;
      outlines.Add(datetostr(Date()));
      outlines.Add(timetostr(Time()));
      outlines.AddText(wout[thid]);
      //////Many notifi forms
      //if frmain.lvMain.Items[thid].SubItems[columnname]<>'' then
        createnewnotifi(frstrings.popuptitlestoped.Caption,frmain.lvMain.Items[thid].SubItems[columnname],outlines.Strings[outlines.Count-1]+outlines.Strings[outlines.Count-2],frmain.lvMain.Items[thid].SubItems[columndestiny],false);
      //else
        //createnewnotifi(rsForm.popuptitlestoped.Caption,frmain.lvMain.Items[thid].SubItems[columnurl],outlines.Strings[outlines.Count-1]+outlines.Strings[outlines.Count-2],frmain.lvMain.Items[thid].SubItems[columndestiny],false);
      outlines.Destroy;
      if frmain.lvMain.Items[thid].SubItems[columntries]<>'' then
        frmain.lvMain.Items[thid].SubItems[columntries]:=inttostr(strtoint(frmain.lvMain.Items[thid].SubItems[columntries])-1);
      //////Mover la descarga si ocurrio un error
      if qtimer[strtoint(frmain.lvMain.Items[thid].SubItems[columnqueue])].Enabled and queuerotate then
      begin
        if thid<frmain.lvMain.Items.Count-1 then
        begin
          frmain.lvMain.MultiSelect:=false;
          if rotatemode=0 then
            moveonestepdown(thid);
          if rotatemode=1 then
            frmain.lvMain.Items.Move(thid,frmain.lvMain.Items.Count-1);
          if rotatemode=2 then
          begin
            if (thid+1)<(frmain.lvMain.Items.Count-1) then
              moveonestepdown(thid,1)
            else
              moveonestepdown(thid);
          end;
          frmain.lvMain.MultiSelect:=true;
          rebuildids();
          if frmain.lvFilter.Visible then
            frmain.tvMainSelectionChanged(nil);
        end;
      end;
      try
        if playsounds then
          playsound(downstopsound);
      except on e:exception do
      end;
    end;
  end;
  //if columncolav then
  //begin
    //frmain.lvMain.Columns[0].Width:=columncolaw;
    //frmain.lvFilter.Columns[0].Width:=columncolaw;
  //end;
  {$IFDEF LCLGTK2}
    //if columncolav then
    //begin
      //frmain.lvMain.Columns[0].Width:=columncolaw;
      //frmain.lvFilter.Columns[0].Width:=columncolaw;
    //end;
  {$ENDIF}
end;

constructor DownThread.Create(CreateSuspended:boolean;tmps:TStringlist);
begin
  FreeOnTerminate:=True;
  inherited Create(CreateSuspended);
  wthp:=TProcess.Create(nil);
  wpr:=TStringList.Create;
  wpr.AddStrings(tmps);
  completado:=false;
  manualshutdown:=false;
end;


procedure loadmydownloads();
var
  fitem:TListItem;
  inidownloadsfile:TINIFile;
  ns,nt:integer;
  downloadsconfig:string;
  ftext:TStringList;
  statusstr:string;
begin
  //if FileExists(configpath+'awgg.dat.bak') then
  //downloadsconfig:=configpath+'awgg.dat.bak'
  //else
  downloadsconfig:=configpath+'awgg.dat';
  inidownloadsfile:=TINIFile.Create(downloadsconfig);
  nt:=inidownloadsfile.ReadInteger('Total','value',0);
  for ns:=0 to nt-1 do
  begin
    try
      fitem:=TListItem.Create(frmain.lvMain.Items);
      fitem.Caption:=inidownloadsfile.ReadString('Download'+inttostr(ns),'status','');
      fitem.ImageIndex:=inidownloadsfile.ReadInteger('Download'+inttostr(ns),'icon',-1);
      fitem.SubItems.Add('');
      fitem.SubItems[columnname]:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columnname','');
      fitem.SubItems.Add('');
      fitem.SubItems[columnsize]:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columnsize','');
      fitem.SubItems.Add('');
      fitem.SubItems[columncurrent]:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columncurrent','');
      fitem.SubItems.Add('');
      fitem.SubItems[columnurl]:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columnurl','');
      fitem.SubItems.Add('');
      //No speed in this point
      fitem.SubItems[columnspeed]:='--';
      fitem.SubItems.Add('');
      fitem.SubItems[columnpercent]:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columnpercent','');
      fitem.SubItems.Add('');
      fitem.SubItems[columnestimate]:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columnestimate','');
      fitem.SubItems.Add('');
      fitem.SubItems[columndate]:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columndate','');
      fitem.SubItems.Add('');
      fitem.SubItems[columndestiny]:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columndestiny','');
      fitem.SubItems.Add('');
      fitem.SubItems[columnengine]:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columnengine','');
      fitem.SubItems.Add('');
      fitem.SubItems[columnparameters]:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columnparameters','');
      fitem.SubItems.Add('0');
      if inidownloadsfile.ReadString('Download'+inttostr(ns),'columnstatus','0')<>'1' then
        fitem.SubItems[columnstatus]:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columnstatus','0')
      else
        fitem.SubItems[columnstatus]:='2';
      fitem.SubItems.Add(inttostr(ns));
      fitem.SubItems.Add('');
      fitem.SubItems[columnuser]:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columnuser','');
      fitem.SubItems.Add('');
      fitem.SubItems[columnpass]:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columnpass','');
      fitem.SubItems.Add('0');
      //tries
      fitem.SubItems.Add('');
      fitem.SubItems[columnuid]:=inttostr(inidownloadsfile.ReadInteger('Download'+inttostr(ns),'columnuid',ns));
      fitem.SubItems.Add('');
      fitem.SubItems[columnqueue]:=inttostr(inidownloadsfile.ReadInteger('Download'+inttostr(ns),'columnqueue',0));
      if fitem.SubItems[columnqueue]='-1' then
        fitem.SubItems[columnqueue]:='0';
      fitem.SubItems.Add('');
      fitem.SubItems[columntype]:=inttostr(inidownloadsfile.ReadInteger('Download'+inttostr(ns),'columntype',0));
      fitem.SubItems.Add('');
      fitem.SubItems[columncookie]:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columncookie','');
      fitem.SubItems.Add('');
      fitem.SubItems[columnreferer]:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columnreferer','');
      fitem.SubItems.Add('');
      fitem.SubItems[columnpost]:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columnpost','');
      fitem.SubItems.Add('');
      fitem.SubItems[columnheader]:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columnheader','');
      fitem.SubItems.Add('');
      fitem.SubItems[columnuseragent]:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columnuseragent','');
      if FileExists(datapath+pathdelim+fitem.SubItems[columnuid]+'.status') then
      begin
        ftext:=TStringList.Create;
        ftext.LoadFromFile(datapath+pathdelim+fitem.SubItems[columnuid]+'.status');
        fitem.SubItems[columncurrent]:=ExtractWord(2,ftext.Strings[0],['/']);
        fitem.SubItems[columnpercent]:=ExtractWord(3,ftext.Strings[0],['/']);
        fitem.SubItems[columnestimate]:=ExtractWord(4,ftext.Strings[0],['/']);
        statusstr:=ExtractWord(1,ftext.Strings[0],['/']);
        Case statusstr of
          '0':
          begin
            fitem.SubItems[columnstatus]:=statusstr;
            if fitem.SubItems[columntype] = '0' then
              fitem.ImageIndex:=18;
            if fitem.SubItems[columntype] = '1' then
              fitem.ImageIndex:=51;
          end;
          '1':
          begin
            fitem.SubItems[columnstatus]:='4';
            if fitem.SubItems[columntype] = '0' then
              fitem.ImageIndex:=3;
            if fitem.SubItems[columntype] = '1' then
              fitem.ImageIndex:=53;
          end;
          '2':
          begin
            fitem.SubItems[columnstatus]:=statusstr;
            if fitem.SubItems[columntype] = '0' then
              fitem.ImageIndex:=3;
            if fitem.SubItems[columntype] = '1' then
              fitem.ImageIndex:=53;
          end;
          '3':
          begin
            fitem.SubItems[columnstatus]:=statusstr;
            if fitem.SubItems[columntype] = '0' then
            begin
              if FileExists(UTF8ToSys(fitem.SubItems[columndestiny]+pathdelim+fitem.SubItems[columnname])) then
                fitem.ImageIndex:=4
              else
                fitem.ImageIndex:=61;
            end;
            if fitem.SubItems[columntype] = '1' then
              fitem.ImageIndex:=54;
          end;
          '4':
          begin
            fitem.SubItems[columnstatus]:=statusstr;
            if fitem.SubItems[columntype] = '0' then
              fitem.ImageIndex:=3;
            if fitem.SubItems[columntype] = '1' then
              fitem.ImageIndex:=53;
          end;
        end;
        ftext.Destroy;
      end;
      frmain.lvMain.Items.AddItem(fitem);
    except on e:exception do
      //ShowMessage('Error loading download list '+e.Message);
    end;
  end;
  SetLength(queues,inidownloadsfile.ReadInteger('Queues','total',1));
  SetLength(queuenames,Length(queues));
  SetLength(queuestartdates,Length(queues));
  SetLength(queuestopdates,Length(queues));
  SetLength(queuestarttimes,Length(queues));
  SetLength(queuestoptimes,Length(queues));
  SetLength(qdomingo,Length(queues));
  SetLength(qlunes,Length(queues));
  SetLength(qmartes,Length(queues));
  SetLength(qmiercoles,Length(queues));
  SetLength(qjueves,Length(queues));
  SetLength(qviernes,Length(queues));
  SetLength(qsabado,Length(queues));
  SetLength(qstop,Length(queues));
  SetLength(qallday,Length(queues));
  SetLength(qtimer,Length(queues));
  SetLength(stimer,Length(queues));
  SetLength(qtimerenable,Length(queues));
  SetLength(queuemanual,Length(queues));
  SetLength(queuelimits,Length(queues));
  SetLength(queuepoweroff,Length(queues));
  SetLength(queuesheduledone,Length(queues));
  for ns:=0 to Length(queues)-1 do
  begin
    queues[ns]:=ns;
    queuenames[ns]:=inidownloadsfile.ReadString('Queue'+inttostr(ns),'name','Main');
    queuestartdates[ns]:=inidownloadsfile.ReadDate('Queue'+inttostr(ns),'startdate',Date());
    queuestopdates[ns]:=inidownloadsfile.ReadDate('Queue'+inttostr(ns),'stopdate',Date());
    queuestarttimes[ns]:=inidownloadsfile.ReadTime('Queue'+inttostr(ns),'starttime',Time());
    queuestoptimes[ns]:=inidownloadsfile.ReadTime('Queue'+inttostr(ns),'stoptime',Time());
    qdomingo[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'domingo',true);
    qlunes[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'lunes',true);
    qmartes[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'martes',true);
    qmiercoles[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'miercoles',true);
    qjueves[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'jueves',true);
    qviernes[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'viernes',true);
    qsabado[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'sabado',true);
    qstop[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'stop',false);
    qallday[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'allday',false);
    qtimerenable[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'timerenable',false);
    queuelimits[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'limits',false);
    queuepoweroff[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'poweroff',false);
    queuesheduledone[ns]:=false;
    qtimer[ns]:=queuetimer.Create(frmain);
    qtimer[ns].Enabled:=false;
    qtimer[ns].qtindex:=ns;
    qtimer[ns].OnTimer:=@qtimer[ns].ontime;
    qtimer[ns].OnStartTimer:=@qtimer[ns].ontimestart;
    qtimer[ns].OnStopTimer:=@qtimer[ns].ontimestop;
    qtimer[ns].Interval:=1000;
    stimer[ns]:=sheduletimer.Create(frmain);
    stimer[ns].Enabled:=qtimerenable[ns];
    stimer[ns].stindex:=ns;
    stimer[ns].OnTimer:=@stimer[ns].onstime;
    stimer[ns].OnStartTimer:=@stimer[ns].onstimestart;
    stimer[ns].OnStopTimer:=@stimer[ns].onstimestop;
    stimer[ns].Interval:=1000;
  end;
  queuesreload();
  inidownloadsfile.Free;
end;

procedure saveandexit();
var
  enprogreso, confirmar:boolean;
  n:integer;
begin
  enprogreso:=false;
  confirmar:=true;
  for n:=0 to frmain.lvMain.Items.Count-1 do
  begin
    if frmain.lvMain.Items[n].SubItems[columnstatus]='1' then
      enprogreso:=true;
  end;
  if enprogreso then
  begin
    frconfirm.Caption:=frstrings.dlgconfirm.Caption;
    frconfirm.dlgtext.Caption:=frstrings.msgcloseinprogressdownload.Caption;
    frconfirm.ShowModal;
    if dlgcuestion then
      confirmar:=true
    else
      confirmar:=false;
  end;
  if confirmar then
  begin
    saveconfig();
    stopall(true);
    savemydownloads();
    Application.Terminate;
  end;
end;

procedure poweroff;
var
  shutp:TProcess;
begin
  frmain.Caption:='Turning off...';
  shutingdown:=true;
  savemydownloads();
  shutp:=TProcess.Create(nil);
  {$IFDEF UNIX}
    if fileexists('/usr/bin/gnome-session-save') then
    begin
      shutp.Executable:='/usr/bin/gnome-session-save';
      shutp.Parameters.Add('--shutdown-dialog');
    end;

    if fileexists('/usr/bin/mate-session-save') and (fileexists(shutp.Executable)=false) then
    begin
      shutp.Executable:='/usr/bin/mate-session-save';
      shutp.Parameters.Add('--shutdown-dialog');
    end;

    if fileexists('/usr/bin/shutdown') and (fileexists(shutp.Executable)=false) then
    begin
      shutp.Executable:='/usr/bin/shutdown';
      shutp.Parameters.Add('-h');
      shutp.Parameters.Add('1');
    end;

  {$ENDIF}
  {$IFDEF WINDOWS}
    shutp.Executable:='shutdown.exe';
    shutp.Parameters.Add('-f');
    shutp.Parameters.Add('-s');
    shutp.Parameters.Add('-t');
    shutp.Parameters.Add('10');
    shutp.Parameters.Add('-c');
    shutp.Parameters.Add('"AWGG is turning off the system"');
  {$ENDIF}
  if fileexists(shutp.Executable) then
    shutp.Execute;
end;

procedure Tfrmain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  frmain.Visible:=false;
  MainTrayIcon.Visible:=true;
  CanClose:=false;
  saveconfig();
end;

procedure Tfrmain.ApplicationProperties1Exception(Sender: TObject; E: Exception);
var exceptstr:System.Text;
begin
  AssignFile(exceptstr,configpath+pathdelim+'awgg.err');
  if FileExists(configpath+pathdelim+'awgg.err') then
    Append(exceptstr)
  else
    Rewrite(exceptstr);
  Writeln(exceptstr,'------------------------------------------');
  Writeln(exceptstr,DateTostr(SysUtils.Now())+' '+TimeTostr(SysUtils.Now()));
  Writeln(exceptstr,'AWGG '+versionitis.version+' Build with FPC '+versionitis.fpcversion+' and LCL '+lcl_version);
  Writeln(exceptstr,'CPU: '+versionitis.targetcpu);
  Writeln(exceptstr,'OS: '+versionitis.targetos);
  Writeln(exceptstr,'');
  Writeln(exceptstr,Exception(ExceptObject).ClassName+':'+Exception(ExceptObject).Message+#10#13);
  System.DumpExceptionBackTrace(exceptstr);
  Writeln(exceptstr,'------------------------------------------');
  CloseFile(exceptstr);
  MessageDlg(Application.Title,'Oh!! this is rare, take calm and please report to nenirey@gmail.com and attach the file:'+LineEnding+SysToUTF8(configpath+pathdelim+'awgg.err')+LineEnding+'Error:' + LineEnding + e.Message, mtError, [mbOK], 0);
end;


procedure Tfrmain.FormCreate(Sender: TObject);
begin
  firsttime:=true;
  //Tal vez se puede cambiar el orden de las columnas dinamicamente
  columnname:=0;
  columnsize:=1;
  columncurrent:=2;
  columnurl:=3;
  columnspeed:=4;
  columnpercent:=5;
  columnestimate:=6;
  columndate:=7;
  columndestiny:=8;
  columnengine:=9;
  columnparameters:=10;
  columnstatus:=11;
  columnid:=12;
  columnuser:=13;
  columnpass:=14;
  columntries:=15;
  columnuid:=16;
  columnqueue:=17;
  columntype:=18;
  columncookie:=19;
  columnreferer:=20;
  columnpost:=21;
  columnheader:=22;
  columnuseragent:=23;

  phttpport:='3128';
  phttpsport:='3128';
  pftpport:='3128';
  shownotifi:=true;
  hiddenotifi:=5;
  clipboardmonitor:=false;
  wgetdefcontinue:=true;
  wgetdefnh:=true;
  wgetdefnd:=true;
  aria2cdefcontinue:=true;
  aria2cdefallocate:=true;
  curldefcontinue:=true;
  if FileExists(ExtractFilePath(Application.Params[0])+'awgg.ini') then
    configpath:=ExtractFilePath(Application.Params[0])
  else
    configpath:=GetAppConfigDir(false);
  datapath:=configpath+PathDelim+'Data';
  {$IFDEF UNIX}
    if FileExists(ExtractFilePath(Application.Params[0])+'wget') then
      wgetrutebin:=ExtractFilePath(Application.Params[0])+'wget';
    if FileExists('/usr/bin/wget') then
      wgetrutebin:='/usr/bin/wget';
    if FileExists(ExtractFilePath(Application.Params[0])+'aria2c') then
      aria2crutebin:=ExtractFilePath(Application.Params[0])+'aria2c';
    if FileExists('/usr/bin/aria2c') then
      aria2crutebin:='/usr/bin/aria2c';
    if FileExists(ExtractFilePath(Application.Params[0])+'curl') then
      curlrutebin:=ExtractFilePath(Application.Params[0])+'curl';
    if FileExists('/usr/bin/curl') then
      curlrutebin:='/usr/bin/curl';
    if FileExists(ExtractFilePath(Application.Params[0])+'axel') then
      axelrutebin:=ExtractFilePath(Application.Params[0])+'axel';
    if FileExists('/usr/bin/axel') then
      axelrutebin:='/usr/bin/axel';
    if FileExists(ExtractFilePath(Application.Params[0])+'lftp') then
      lftprutebin:=ExtractFilePath(Application.Params[0])+'lftp';
    if FileExists('/usr/bin/lftp') then
      lftprutebin:='/usr/bin/lftp';
  {$ENDIF}
  {$IFDEF WINDOWS}
    {$IF FPC_FULLVERSION<=20604}
    if FileExists(ExtractFilePath(Application.Params[0])+'wget.exe') then
      wgetrutebin:=ExtractFilePath(Application.Params[0])+'wget.exe';
    if FileExists(ExtractFilePath(Application.Params[0])+'aria2c.exe') then
      aria2crutebin:=ExtractFilePath(Application.Params[0])+'aria2c.exe';
    if FileExists(ExtractFilePath(Application.Params[0])+'curl.exe') then
      curlrutebin:=ExtractFilePath(Application.Params[0])+'curl.exe';
    if FileExists(ExtractFilePath(Application.Params[0])+'axel.exe') then
      axelrutebin:=ExtractFilePath(Application.Params[0])+'axel.exe';
    if FileExists(ExtractFilePath(Application.Params[0])+'lftp.exe') then
      lftprutebin:=ExtractFilePath(Application.Params[0])+'lftp.exe';
    {$ELSE}
    if FileExists(ExtractFilePath(Application.Params[0])+'wget.exe') then
      wgetrutebin:=SysToUTF8(ExtractFilePath(Application.Params[0])+'wget.exe');
    if FileExists(ExtractFilePath(Application.Params[0])+'aria2c.exe') then
      aria2crutebin:=SysToUTF8(ExtractFilePath(Application.Params[0])+'aria2c.exe');
    if FileExists(ExtractFilePath(Application.Params[0])+'curl.exe') then
      curlrutebin:=SysToUTF8(ExtractFilePath(Application.Params[0])+'curl.exe');
    if FileExists(ExtractFilePath(Application.Params[0])+'axel.exe') then
      axelrutebin:=SysToUTF8(ExtractFilePath(Application.Params[0])+'axel.exe');
    if FileExists(ExtractFilePath(Application.Params[0])+'lftp.exe') then
      lftprutebin:=SysToUTF8(ExtractFilePath(Application.Params[0])+'lftp.exe');
    {$ENDIF}
  {$ENDIF}
  loadmydownloads();
  loadconfig();
  categoryreload();
  SetDefaultLang(deflanguage);
  titlegen();
  frmain.FirstStartTimer.Enabled:=true;
  onestart:=false;
  if autostartminimized then
  begin
    frmain.WindowState:=wsMinimized;
    frmain.Hide;
  end
  else
    frmain.WindowState:=lastmainwindowstate;
  frmain.lvFilter.Columns:=frmain.lvMain.Columns;
end;

procedure Tfrmain.FormResize(Sender: TObject);
begin

end;

procedure Tfrmain.FormWindowStateChange(Sender: TObject);
begin
  if frmain.WindowState<>wsMinimized then
  lastmainwindowstate:=frmain.WindowState;
end;

procedure Tfrmain.lvMainClick(Sender: TObject);
begin
  //columncolaw:=frmain.lvMain.Columns[0].Width;
end;

procedure Tfrmain.lvMainColumnClick(Sender: TObject; Column: TListColumn);
//var
//  n:integer;
begin
  //Commentado temporalmente porque afecta el orden de todas las colas
  //for n:=0 to frmain.lvMain.Columns.Count-1 do
  //begin
  //  frmain.lvMain.Columns[n].Caption:=AnsiReplaceStr(frmain.lvMain.Columns[n].Caption,'  ٧','');
  //  frmain.lvMain.Columns[n].Caption:=AnsiReplaceStr(frmain.lvMain.Columns[n].Caption,'  ٨','');
  //  if (frmain.lvFilter.Visible) then
  //  begin
  //    frmain.lvFilter.Columns[n].Caption:=AnsiReplaceStr(frmain.lvFilter.Columns[n].Caption,'  ٧','');
  //    frmain.lvFilter.Columns[n].Caption:=AnsiReplaceStr(frmain.lvFilter.Columns[n].Caption,'  ٨','');
  //  end;
  //end;
  //if frmain.lvMain.SortDirection=sdAscending then
  //begin
  //  frmain.lvMain.SortDirection:=sdDescending;
  //  {$IFDEF LCLQT}
  //  {$ELSE}
  //    Column.Caption:=Column.Caption+'  ٧';
  //  {$ENDIF}
  //end
  //else
  //begin
  //  frmain.lvMain.SortDirection:=sdAscending;
  //  {$IFDEF LCLQT}
  //  {$ELSE}
  //    Column.Caption:=Column.Caption+'  ٨';
  //  {$ENDIF}
  //end;
  //frmain.lvMain.SortColumn:=column.Index;
  //frmain.lvMain.SortType:=stText;
  //if (frmain.lvFilter.Visible) then
  //begin
  //  frmain.lvFilter.SortColumn:=Column.Index;
  //  frmain.lvFilter.SortType:=stText;
  //  frmain.tvMainSelectionChanged(nil);
  //end;
  //rebuildids();
  //if frmain.lvMain.Visible then
    //columncolaw:=frmain.lvMain.Columns[0].Width
  //else
    //columncolaw:=frmain.lvFilter.Columns[0].Width;
end;


procedure Tfrmain.lvMainContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  i:integer;
begin
  if frmain.lvMain.SelCount>0 then
  begin
    case frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnstatus] of
      '0':
      begin
        frmain.milistStartDown.Enabled:=true;
        frmain.milistStopDown.Enabled:=false;
        frmain.milistRestartNow.Enabled:=true;
        frmain.milistRestartLater.Enabled:=true;
        frmain.milistClearLog.Enabled:=true;
        frmain.milistDeleteDown.Enabled:=true;
        frmain.milistDeleteDownDisk.Enabled:=true;
        frmain.milistProperties.Enabled:=true;
        frmain.milistOpenFile.Enabled:=false;
        frmain.milistCopyFiles.Enabled:=false;
        frmain.milistMoveFiles.Enabled:=false;
      end;
      '1':
      begin
        frmain.milistStartDown.Enabled:=false;
        frmain.milistStopDown.Enabled:=true;
        frmain.milistRestartNow.Enabled:=false;
        frmain.milistRestartLater.Enabled:=false;
        frmain.milistClearLog.Enabled:=false;
        frmain.milistDeleteDown.Enabled:=false;
        frmain.milistDeleteDownDisk.Enabled:=false;
        frmain.milistProperties.Enabled:=false;
        frmain.milistOpenFile.Enabled:=false;
        frmain.milistCopyFiles.Enabled:=false;
        frmain.milistMoveFiles.Enabled:=false;
      end;
      '2','4':
      begin
        frmain.milistStartDown.Enabled:=true;
        frmain.milistStopDown.Enabled:=false;
        frmain.milistRestartNow.Enabled:=true;
        frmain.milistRestartLater.Enabled:=true;
        frmain.milistClearLog.Enabled:=true;
        frmain.milistDeleteDown.Enabled:=true;
        frmain.milistDeleteDownDisk.Enabled:=true;
        frmain.milistProperties.Enabled:=true;
        frmain.milistOpenFile.Enabled:=false;
        frmain.milistCopyFiles.Enabled:=false;
        frmain.milistMoveFiles.Enabled:=false;
      end;
      '3':
      begin
        frmain.milistStartDown.Enabled:=true;
        frmain.milistStopDown.Enabled:=false;
        frmain.milistRestartNow.Enabled:=true;
        frmain.milistRestartLater.Enabled:=true;
        frmain.milistClearLog.Enabled:=true;
        frmain.milistDeleteDown.Enabled:=true;
        frmain.milistDeleteDownDisk.Enabled:=true;
        frmain.milistProperties.Enabled:=true;
        frmain.milistOpenFile.Enabled:=true;
        frmain.milistCopyFiles.Enabled:=true;
        frmain.milistMoveFiles.Enabled:=true;
      end;
    end;
    if (frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnstatus]='1') then
    begin
      frmain.milistShowTrayIcon.Enabled:=true;
      if Assigned(trayicons[frmain.lvMain.ItemIndex]) then
        frmain.milistShowTrayIcon.Checked:=trayicons[frmain.lvMain.ItemIndex].Visible
    end
    else
    begin
      frmain.milistShowTrayIcon.Enabled:=false;
    end;
    handled:=true;
    for i:=0 to frmain.milistSendToQueue.Count-1 do
    begin
      if (inttostr(i)=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnqueue]) and (frmain.lvMain.SelCount<2) then
        frmain.milistSendToQueue.Items[i].Enabled:=false
      else
        frmain.milistSendToQueue.Items[i].Enabled:=true;
    end;
    frmain.pmDownList.PopUp;
  end;
end;
procedure Tfrmain.lvMainDblClick(Sender: TObject);
begin
  if frmain.lvMain.ItemIndex<>-1 then
  begin
    if (frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnstatus]='3') then
    begin
      frmain.milistOpenFileClick(nil);
    end;
  end;
end;

procedure Tfrmain.lvMainKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //ShowMessage(inttostr(key));
  Case key of
    46,109:
    begin
      if Shift=[ssShift] then
      begin
        deleteitems(true);
      end
      else
      deleteitems(false);
    end;
    13: frmain.lvMainDblClick(nil);
    45,107:frmain.tbAddDownClick(nil);
    106:frmain.mimainSelectAllClick(nil);
  end;
end;

procedure Tfrmain.lvMainSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  lastlines:TStringList;
  percent:string;
begin
  if (frmain.lvMain.ItemIndex<>-1) then
  begin
    if frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnstatus]='1' then
    begin
      frmain.tbStartDown.Enabled:=false;
      frmain.tbStopDown.Enabled:=true;
      frmain.tbRestartNow.Enabled:=false;
      frmain.tbRestartLater.Enabled:=false;
    end
    else
    begin
      frmain.tbStartDown.Enabled:=true;
      frmain.tbStopDown.Enabled:=false;
      frmain.tbRestartNow.Enabled:=true;
      frmain.tbRestartLater.Enabled:=true;
    end;
    if qtimer[strtoint(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnqueue])].Enabled then
    begin
      frmain.tbStartQueue.Enabled:=false;
      frmain.tbStopQueue.Enabled:=true;
    end
    else
    begin
      frmain.tbStartQueue.Enabled:=true;
      frmain.tbStopQueue.Enabled:=false;
    end;

    frmain.SynEdit1.Lines.Clear;
    if FileExists(UTF8ToSys(logpath)+pathdelim+UTF8ToSys(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnname])+'.log') and (frmain.SynEdit1.Visible) and (loadhistorylog) then
    begin
      try
        lastlines:=TStringList.Create;
        lastlines.LoadFromFile(UTF8ToSys(logpath)+pathdelim+UTF8ToSys(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnname])+'.log');
        if (lastlines.Count>=20) and (loadhistorymode=2) then
        begin
          frmain.SynEdit1.Lines.Add(lastlines[lastlines.Count-20]);
          frmain.SynEdit1.Lines.Add(lastlines[lastlines.Count-19]);
          frmain.SynEdit1.Lines.Add(lastlines[lastlines.Count-18]);
          frmain.SynEdit1.Lines.Add(lastlines[lastlines.Count-17]);
          frmain.SynEdit1.Lines.Add(lastlines[lastlines.Count-16]);
          frmain.SynEdit1.Lines.Add(lastlines[lastlines.Count-15]);
          frmain.SynEdit1.Lines.Add(lastlines[lastlines.Count-14]);
          frmain.SynEdit1.Lines.Add(lastlines[lastlines.Count-13]);
          frmain.SynEdit1.Lines.Add(lastlines[lastlines.Count-12]);
          frmain.SynEdit1.Lines.Add(lastlines[lastlines.Count-11]);
          frmain.SynEdit1.Lines.Add(lastlines[lastlines.Count-10]);
          frmain.SynEdit1.Lines.Add(lastlines[lastlines.Count-9]);
          frmain.SynEdit1.Lines.Add(lastlines[lastlines.Count-8]);
          frmain.SynEdit1.Lines.Add(lastlines[lastlines.Count-7]);
          frmain.SynEdit1.Lines.Add(lastlines[lastlines.Count-6]);
          frmain.SynEdit1.Lines.Add(lastlines[lastlines.Count-5]);
          frmain.SynEdit1.Lines.Add(lastlines[lastlines.Count-4]);
          frmain.SynEdit1.Lines.Add(lastlines[lastlines.Count-3]);
          frmain.SynEdit1.Lines.Add(lastlines[lastlines.Count-2]);
          frmain.SynEdit1.Lines.Add(lastlines[lastlines.Count-1]);
        end
        else
          frmain.SynEdit1.Lines:=lastlines;
        lastlines.Destroy;
        if Length(frmain.SynEdit1.Lines.Text)>0 then
          frmain.SynEdit1.SelStart:=Length(frmain.SynEdit1.Lines.Text);
        frmain.SynEdit1.SelEnd:=Length(frmain.SynEdit1.Lines.Text);
      except on e:exception do
        //frmain.SynEdit1.Lines.Add(e.ToString);
      end;
    end;
    percent:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnpercent];
    try
      frmain.pbMain.Style:=pbstNormal;
      if (percent<>'') and (percent<>'-') then
        frmain.pbMain.Position:=strtoint(Copy(percent,0,Pos('%',percent)-1))
      else
        frmain.pbMain.Position:=0;
    except on e:exception do
      frmain.pbMain.Position:=0;
    end;
  end;
end;

procedure Tfrmain.lvFilterClick(Sender: TObject);
begin
  //columncolaw:=frmain.lvFilter.Columns[0].Width;
end;

procedure Tfrmain.lvFilterSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  indice:integer=0;
  x:integer;
begin
  if (frmain.lvMain.Items.Count>0) then
  begin
    if item.SubItems[columnstatus] = '1' then
      indice:=hilo[strtoint(item.SubItems[columnid])].thid
    else
    begin
      for x:=0 to frmain.lvMain.Items.Count-1 do
      begin
        if frmain.lvMain.Items[x].SubItems[columnuid]=Item.SubItems[columnuid] then
          indice:=x;
      end;
    end;
    if (frmain.lvFilter.SelCount>1) and (indice<frmain.lvMain.Items.Count) then
    begin
      frmain.lvMain.Items[indice].Selected:=true;
      frmain.lvMain.ItemIndex:=indice;
    end
    else
    begin
      if frmain.lvMain.SelCount>1 then
      begin
        for x:=0 to frmain.lvMain.Items.Count-1 do
          frmain.lvMain.Items[x].Selected:=false;
      end;
      frmain.lvMain.MultiSelect:=false;
      if (indice <> -1) and (indice<frmain.lvMain.Items.Count) then
        frmain.lvMain.ItemIndex:=indice;
      frmain.lvMain.MultiSelect:=true;
    end;
  end;
end;

procedure Tfrmain.milistMoveFilesClick(Sender: TObject);
var
  i:integer;
begin
  frmain.SelectDirectoryDialog1.Execute;
  if (frmain.SelectDirectoryDialog1.FileName<>'') then
  begin
    SetLength(copywork,Length(copywork)+1);
    copywork[Length(copywork)-1]:=copythread.Create(true,Length(copywork)-1,true);
    copywork[Length(copywork)-1].id:=Length(copywork)-1;
    for i:=0 to frmain.lvMain.Items.Count-1 do
    begin
      if (frmain.lvMain.Items[i].Selected) and (frmain.lvMain.Items[i].SubItems[columnstatus]='3') and (FileExists(UTF8ToSys(frmain.lvMain.Items[i].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[i].SubItems[columnname]))) then
        copywork[Length(copywork)-1].source.Add(frmain.lvMain.Items[i].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[i].SubItems[columnname]);
    end;
    copywork[Length(copywork)-1].destination:=frmain.SelectDirectoryDialog1.FileName;
    copywork[Length(copywork)-1].Start;
  end;

end;

procedure Tfrmain.micommandClearClick(Sender: TObject);
begin
  frmain.SynEdit1.Lines.Clear;
end;

procedure Tfrmain.micommandCopyClick(Sender: TObject);
begin
  clipboard.AsText:=frmain.SynEdit1.SelText;
end;

procedure Tfrmain.micommandSelectAllClick(Sender: TObject);
begin
  frmain.SynEdit1.SelectAll;
end;

procedure Tfrmain.mimainShowTreeClick(Sender: TObject);
begin
  if frmain.tvMain.Visible and (frmain.psHorizontal.Position>10) then
    splithpos:=frmain.psHorizontal.Position;
  frmain.tvMain.Visible:=(not frmain.tvMain.Visible);
  frmain.mimainShowTree.Checked:=frmain.tvMain.Visible;
  if frmain.tvMain.Visible then
  begin
    if splithpos<10 then
      splithpos:=170;
    frmain.psHorizontal.Position:=splithpos;
  end
  else
  begin
    frmain.psHorizontal.Position:=0;
    frmain.tvMain.Items.SelectOnlyThis(frmain.tvMain.Items[0]);
  end;
end;

procedure Tfrmain.mimainAboutClick(Sender: TObject);
var
  widgetset:String;
  cpu:String;
begin
  {$IFDEF LCLWINCE}
    widgetset:='wince';
  {$ENDIF}
  {$IFDEF LCLWIN32}
    widgetset:='win32';
  {$ENDIF}
  {$IFDEF LCLWIN64}
    widgetset:='win64';
  {$ENDIF}
  {$IFDEF LCLQT}
    widgetset:='qt';
  {$ENDIF}
  {$IFDEF LCLQT5}
    widgetset:='qt5';
  {$ENDIF}
  {$IFDEF LCLGTK}
    widgetset:='gtk';
  {$ENDIF}
  {$IFDEF LCLGTK2}
    widgetset:='gtk2';
  {$ENDIF}
  {$IFDEF LCLGTK3}
    widgetset:='gtk3';
  {$ENDIF}
  {$IFDEF LCLCarbon}
    widgetset:='carbon';
  {$ENDIF}
  {$IFDEF LCLCocoa}
    widgetset:='cocoa';
  {$ENDIF}
  {$IFDEF cpui386}
    cpu:='i386';
  {$ENDIF}
  {$IFDEF cpux86_64}
    cpu:='x86_64';
  {$ENDIF}
  frabout.Label1.Caption:='AWGG';
  frabout.Label2.Caption:='(Advanced WGET GUI)'+#10#13+'Version: '+versionitis.version+#10#13+'Compiled using:'+#10#13+'Lazarus: '+lcl_version+#10#13+'FPC: '+versionitis.fpcversion+#10#13+'Platform: '+cpu+'-'+versionitis.targetos+'-'+widgetset;
  frabout.Memo1.Text:=abouttext;
  frabout.Label3.Caption:='http://sites.google.com/site/awggproject';
  frabout.Show;
end;

procedure Tfrmain.milistPropertiesClick(Sender: TObject);
var
  tmpstr:string='';
  paramlist:string='';
begin
  if frmain.lvMain.ItemIndex<>-1 then
  begin
    if frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columntype] = '0' then
    begin
      //////THIS ORDER IS IMPORTANT/////////
      frnewdown.Edit1.Text:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnurl];
      frnewdown.Edit3.Text:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnname];
      frnewdown.DirectoryEdit1.Text:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columndestiny];
      enginereload();
      frnewdown.ComboBox1.ItemIndex:=frnewdown.ComboBox1.Items.IndexOf(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnengine]);
      frnewdown.Edit2.Text:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters];
      frmain.ClipBoardTimer.Enabled:=false;
      frnewdown.Edit4.Text:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnuser];
      frnewdown.Edit5.Text:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnpass];
      frnewdown.Show;
      frnewdown.Update;
      frnewdown.Visible:=false;
      ///////CONFIRM DIALOG MODE///////////
      frnewdown.Caption:=frstrings.titlepropertiesdown.Caption;
      frnewdown.Button1.Visible:=false;
      frnewdown.Button4.Visible:=false;
      frnewdown.BitBtn1.Caption:=frstrings.btnpropertiesok.Caption;
      frnewdown.BitBtn1.GlyphShowMode:=gsmNever;
      ////////////////////////////////////
      frnewdown.ComboBox2.ItemIndex:=strtoint(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnqueue]);
      frnewdown.ShowModal;
      ///////NEW DOWNLOAD DIALOG MODE///////////
      frnewdown.Caption:=frstrings.titlenewdown.Caption;
      frnewdown.Button1.Visible:=true;
      frnewdown.Button4.Visible:=true;
      frnewdown.BitBtn1.Caption:=frstrings.btnnewdownstartnow.Caption;
      frnewdown.BitBtn1.GlyphShowMode:=gsmApplication;
      frnewdown.UpdateRolesForForm;
      ////////////////////////////////////
      frmain.ClipBoardTimer.Enabled:=clipboardmonitor;
      if agregar then
      begin
        frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnname]:=frnewdown.Edit3.Text;
        frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnurl]:=frnewdown.Edit1.Text;
        frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columndestiny]:=frnewdown.DirectoryEdit1.Text;
        frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnengine]:=frnewdown.ComboBox1.Text;
        frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters]:=frnewdown.Edit2.Text;
        frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnuser]:=frnewdown.Edit4.Text;
        frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnpass]:=frnewdown.Edit5.Text;
        if frnewdown.ComboBox2.ItemIndex>=0 then
          frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnqueue]:=inttostr(frnewdown.ComboBox2.ItemIndex);
        frmain.tvMainSelectionChanged(nil);
        savemydownloads();
      end;
    end;
    if frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columntype] = '1' then
    begin
      newgrabberqueues();
      frsitegrabber.ComboBox1.ItemIndex:=strtoint(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnqueue]);
      frsitegrabber.Edit2.Text:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnname];
      frsitegrabber.Edit1.Text:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnurl];
      frsitegrabber.DirectoryEdit1.Text:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columndestiny];
      frsitegrabber.Edit3.Text:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnuser];
      frsitegrabber.Edit4.Text:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnpass];
      frsitegrabber.ComboBox1.ItemIndex:=strtoint(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnqueue]);
      if Pos('-k',frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters])>0 then
        frsitegrabber.CheckBox1.Checked:=true
      else
        frsitegrabber.CheckBox1.Checked:=false;
      if Pos('--follow-ftp',frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters])>0 then
        frsitegrabber.CheckBox2.Checked:=true
      else
        frsitegrabber.CheckBox2.Checked:=false;
      if Pos('-np',frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters])>0 then
        frsitegrabber.CheckBox3.Checked:=true
      else
        frsitegrabber.CheckBox3.Checked:=false;
      if Pos('-p',frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters])>0 then
        frsitegrabber.CheckBox4.Checked:=true
      else
        frsitegrabber.CheckBox4.Checked:=false;
      if Pos('-H',frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters])>0 then
        frsitegrabber.CheckBox5.Checked:=true
      else
        frsitegrabber.CheckBox5.Checked:=false;
      if Pos('-L',frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters])>0 then
        frsitegrabber.CheckBox6.Checked:=true
      else
        frsitegrabber.CheckBox6.Checked:=false;
      if Pos('-l ',frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters])>0 then
      begin
        tmpstr:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters];
        tmpstr:=Copy(tmpstr,Pos('-l ',tmpstr)+3,Length(tmpstr));
        tmpstr:=Copy(tmpstr,0,Pos(' ',tmpstr)-1);
        //ShowMessage(tmpstr);
        frsitegrabber.SpinEdit1.Value:=strtoint(tmpstr);
      end
      else
        frsitegrabber.Spinedit1.Value:=5;
      if Pos('-R "',frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters])>0 then
      begin
        tmpstr:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters];
        tmpstr:=Copy(tmpstr,Pos('-R "',tmpstr)+4,Length(tmpstr));
        tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
        //ShowMessage(tmpstr);
        frsitegrabber.Memo1.Text:=tmpstr;
      end
      else
        frsitegrabber.Memo1.Text:='';
      if Pos('-A "',frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters])>0 then
      begin
        tmpstr:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters];
        tmpstr:=Copy(tmpstr,Pos('-A "',tmpstr)+4,Length(tmpstr));
        tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
        //ShowMessage(tmpstr);
        frsitegrabber.Memo6.Text:=tmpstr;
      end
      else
        frsitegrabber.Memo6.Text:='';
      if Pos('-D "',frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters])>0 then
      begin
        tmpstr:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters];
        tmpstr:=Copy(tmpstr,Pos('-D "',tmpstr)+4,Length(tmpstr));
        tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
        //ShowMessage(tmpstr);
        frsitegrabber.Memo3.Text:=tmpstr;
      end
      else
        frsitegrabber.Memo3.Text:='';
      if Pos('--exclude-domains "',frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters])>0 then
      begin
        tmpstr:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters];
        tmpstr:=Copy(tmpstr,Pos('--exclude-domains "',tmpstr)+19,Length(tmpstr));
        tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
        //ShowMessage(tmpstr);
        frsitegrabber.Memo2.Text:=tmpstr;
      end
      else
        frsitegrabber.Memo2.Text:='';
      if Pos('-I "',frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters])>0 then
      begin
        tmpstr:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters];
        tmpstr:=Copy(tmpstr,Pos('-I "',tmpstr)+4,Length(tmpstr));
        tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
        //ShowMessage(tmpstr);
        frsitegrabber.Memo4.Text:=tmpstr;
      end
      else
        frsitegrabber.Memo4.Text:='';
      if Pos('-X "',frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters])>0 then
      begin
        tmpstr:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters];
        tmpstr:=Copy(tmpstr,Pos('-X "',tmpstr)+4,Length(tmpstr));
        tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
        //ShowMessage(tmpstr);
        frsitegrabber.Memo5.Text:=tmpstr;
      end
      else
        frsitegrabber.Memo5.Text:='';
      if Pos('--follow-tags="',frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters])>0 then
      begin
        tmpstr:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters];
        tmpstr:=Copy(tmpstr,Pos('--follow-tags="',tmpstr)+15,Length(tmpstr));
        tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
        //ShowMessage(tmpstr);
        frsitegrabber.Memo7.Text:=tmpstr;
      end
      else
        frsitegrabber.Memo7.Text:='';
      if Pos('--ignore-tags="',frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters])>0 then
      begin
        tmpstr:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters];
        tmpstr:=Copy(tmpstr,Pos('--ignore-tags="',tmpstr)+15,Length(tmpstr));
        tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
        //ShowMessage(tmpstr);
        frsitegrabber.Memo8.Text:=tmpstr;
      end
      else
        frsitegrabber.Memo8.Text:='';
      if Pos('-U "',frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters])>0 then
      begin
        tmpstr:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters];
        tmpstr:=Copy(tmpstr,Pos('-U "',tmpstr)+4,Length(tmpstr));
        tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
        //ShowMessage(tmpstr);
        frsitegrabber.Edit5.Text:=tmpstr;
      end
      else
        frsitegrabber.Edit5.Text:='';
      frsitegrabber.PageControl1.TabIndex:=0;
      frmain.ClipBoardTimer.Enabled:=false;
      frsitegrabber.ShowModal;
      frmain.ClipBoardTimer.Enabled:=clipboardmonitor;
      if grbadd then
      begin
        paramlist:=paramlist+'-l '+inttostr(frsitegrabber.SpinEdit1.Value);
        if frsitegrabber.CheckBox1.Checked then
          paramlist:=paramlist+' -k';
        if frsitegrabber.CheckBox2.Checked then
          paramlist:=paramlist+' --follow-ftp';
        if frsitegrabber.CheckBox3.Checked then
          paramlist:=paramlist+' -np';
        if frsitegrabber.CheckBox4.Checked then
          paramlist:=paramlist+' -p';
        if frsitegrabber.CheckBox5.Checked then
          paramlist:=paramlist+' -H';
        if frsitegrabber.CheckBox6.Checked then
          paramlist:=paramlist+' -L';
        if Length(frsitegrabber.Memo1.Lines.Text)>0 then
          paramlist:=paramlist+' -R "'+frsitegrabber.Memo1.Lines.Text+'"';
        if Length(frsitegrabber.Memo2.Lines.Text)>0 then
          paramlist:=paramlist+' --exclude-domains "'+frsitegrabber.Memo2.Lines.Text+'"';
        if Length(frsitegrabber.Memo3.Lines.Text)>0 then
          paramlist:=paramlist+' -D "'+frsitegrabber.Memo3.Lines.Text+'"';
        if Length(frsitegrabber.Memo4.Lines.Text)>0 then
          paramlist:=paramlist+' -I "'+frsitegrabber.Memo4.Lines.Text+'"';
        if Length(frsitegrabber.Memo5.Lines.Text)>0 then
          paramlist:=paramlist+' -X "'+frsitegrabber.Memo5.Lines.Text+'"';
        if Length(frsitegrabber.Memo6.Lines.Text)>0 then
          paramlist:=paramlist+' -A "'+frsitegrabber.Memo6.Lines.Text+'"';
        if Length(frsitegrabber.Memo7.Lines.Text)>0 then
          paramlist:=paramlist+' --follow-tags="'+frsitegrabber.Memo7.Lines.Text+'"';
        if Length(frsitegrabber.Memo8.Lines.Text)>0 then
          paramlist:=paramlist+' --ignore-tags="'+frsitegrabber.Memo8.Lines.Text+'"';
        if Length(frsitegrabber.Edit5.Text)>0 then
          paramlist:=paramlist+' -U "'+frsitegrabber.Edit5.Text+'"';
        frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnname]:=frsitegrabber.Edit2.Text;//Nombre del sitio
        frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnurl]:=frsitegrabber.Edit1.Text;//URL
        frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columndestiny]:=frsitegrabber.DirectoryEdit1.Text;//Destino
        frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnparameters]:=paramlist;//Parametros
        frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnuser]:=frsitegrabber.Edit3.Text;//user
        frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnpass]:=frsitegrabber.Edit4.Text;//pass
        frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnqueue]:=inttostr(frsitegrabber.ComboBox1.ItemIndex);//queue
        frmain.tvMainSelectionChanged(nil);
        savemydownloads();
      end;
    end;
  end;
end;

procedure Tfrmain.milistCopyURLClick(Sender: TObject);
begin
  if frmain.lvMain.ItemIndex<>-1 then
  ClipBoard.AsText:=frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnurl];
end;

procedure Tfrmain.milistDeleteDownClick(Sender: TObject);
begin
  deleteitems(false);
end;

procedure Tfrmain.miStopAllClick(Sender: TObject);
begin
  stopall(false);
end;

procedure Tfrmain.mimainSchedulerClick(Sender: TObject);
begin
  frconfig.PageControl1.ActivePageIndex:=1;
  frconfig.tvConfig.Items[frconfig.PageControl1.ActivePageIndex].Selected:=true;
  configdlg();
  frconfig.Show;
end;

procedure Tfrmain.mimainAddDownClick(Sender: TObject);
begin
  tbAddDownClick(nil);
end;

procedure Tfrmain.mimainDeleteDownClick(Sender: TObject);
begin
  deleteitems(false);
end;

procedure Tfrmain.mimainSelectAllClick(Sender: TObject);
var
  x:integer;
begin
  if frmain.lvMain.Visible then
  begin
    for x:=0 to frmain.lvMain.Items.Count-1 do
    begin
      frmain.lvMain.Items[x].Selected:=true;
    end;
  end
  else
  begin
    for x:=0 to frmain.lvFilter.Items.Count-1 do
    begin
      frmain.lvFilter.Items[x].Selected:=true;
    end;
  end;
end;

procedure Tfrmain.miShowMainFormClick(Sender: TObject);
begin
  frmain.MainTrayIconDblClick(nil);
end;

procedure Tfrmain.mimainUnselectAllClick(Sender: TObject);
var
  x:integer;
begin
  for x:=0 to frmain.lvMain.Items.Count-1 do
  begin
    frmain.lvMain.Items[x].Selected:=false;
  end;
  frmain.tvMainSelectionChanged(nil);
end;

procedure Tfrmain.mimainStartAllClick(Sender: TObject);
var
  x:integer;
begin
  frmain.mimainSelectAllClick(nil);
  for x:=0 to frmain.lvMain.Items.Count-1 do
  begin
    if frmain.lvMain.Items[x].Selected then
    begin
      queuemanual[strtoint(frmain.lvMain.Items[x].SubItems[columnqueue])]:=true;
      downloadstart(x,false);
    end;
  end;
end;

procedure Tfrmain.mimainStopAllClick(Sender: TObject);
var
  x:integer;
begin
  frmain.mimainSelectAllClick(nil);
  for x:=0 to frmain.lvMain.Items.Count-1 do
  begin
    if (frmain.lvMain.Items[x].SubItems[columnstatus]='1') and (frmain.lvMain.Items[x].Selected)then
    begin
    hilo[strtoint(frmain.lvMain.Items[x].SubItems[columnid])].shutdown();
    end;
  end;
end;

procedure Tfrmain.mimainShowCurrentClick(Sender: TObject);
begin
  frmain.lvMain.Column[columncurrent+1].Visible:=not frmain.lvMain.Column[columncurrent+1].Visible;
  frmain.lvFilter.Column[columncurrent+1].Visible:=not frmain.lvFilter.Column[columncurrent+1].Visible;
  frmain.mimainShowCurrent.Checked:=frmain.lvMain.Column[columncurrent+1].Visible;
end;

procedure Tfrmain.mimainShowParametersClick(Sender: TObject);
begin
  frmain.lvMain.Column[columnparameters+1].Visible:=not frmain.lvMain.Column[columnparameters+1].Visible;
  frmain.lvFilter.Column[columnparameters+1].Visible:=not frmain.lvFilter.Column[columnparameters+1].Visible;
  frmain.mimainShowParameters.Checked:=frmain.lvMain.Column[columnparameters+1].Visible;
end;

procedure Tfrmain.mimainShowGridClick(Sender: TObject);
begin
  frmain.lvMain.GridLines:=not frmain.lvMain.GridLines;
  frmain.lvFilter.GridLines:=not frmain.lvFilter.GridLines;
  frmain.mimainshowgrid.Checked:=frmain.lvMain.GridLines;
end;

procedure Tfrmain.milistOpenLogClick(Sender: TObject);
begin
  if frmain.lvMain.ItemIndex<>-1 then
  begin
    if FileExists(UTF8ToSys(logpath+pathdelim+frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnname])+'.log') then
      OpenURL(ExtractShortPathName(UTF8ToSys(logpath+pathdelim+frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnname])+'.log'))
    else
      ShowMessage(frstrings.msgnoexisthistorylog.Caption);
  end;
end;

procedure Tfrmain.milistStartDownClick(Sender: TObject);
begin
  if frmain.lvMain.ItemIndex<>-1 then
  begin
    queuemanual[strtoint(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnqueue])]:=true;
    downloadstart(frmain.lvMain.ItemIndex,false);
  end;
end;

procedure Tfrmain.milistStopDownClick(Sender: TObject);
begin
  if frmain.lvMain.ItemIndex<>-1 then
    hilo[strtoint(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnid])].shutdown();
end;

procedure Tfrmain.milistRestartNowClick(Sender: TObject);
begin
  frmain.tbRestartNowClick(nil);
end;

procedure Tfrmain.miExitClick(Sender: TObject);
begin
  saveandexit();
end;

procedure Tfrmain.mimainRestartAllNowClick(Sender: TObject);
var
  x:integer;
begin
  frconfirm.Caption:=frstrings.dlgconfirm.Caption;
  frconfirm.dlgtext.Caption:=frstrings.dlgrestartalldownloads.Caption;
  frconfirm.ShowModal;
  if dlgcuestion then
  begin
    frmain.mimainSelectAllClick(nil);
    for x:=0 to frmain.lvMain.Items.Count-1 do
    begin
      if (frmain.lvMain.Items[x].Subitems[columnstatus]<>'1') and (frmain.lvMain.Items[x].Selected=true) then
      begin
        queuemanual[strtoint(frmain.lvMain.Items[x].SubItems[columnqueue])]:=true;
        restartdownload(x,true,false);
      end;
    end;
    if frmain.lvFilter.Visible then
      frmain.tvMainSelectionChanged(nil);
  end;
end;

procedure Tfrmain.mimainDeleteAllClick(Sender: TObject);
begin
  frmain.mimainSelectAllClick(nil);
  deleteitems(false);
  savemydownloads();
end;

procedure Tfrmain.mimainShowCommandClick(Sender: TObject);
begin
  if splitpos<50 then
    splitpos:=50;
  if splitpos>frmain.psVertical.Height-50 then
    splitpos:=splitpos-50;
  if frmain.SynEdit1.Visible then
  begin
    splitpos:=frmain.psVertical.Position;
  end;
  frmain.SynEdit1.Visible:=not frmain.SynEdit1.Visible;
  mimainShowCommand.Checked:=frmain.SynEdit1.Visible;
  if frmain.SynEdit1.Visible then
    frmain.psVertical.Position:=splitpos
  else
    frmain.psVertical.Position:=frmain.psVertical.Height;
  frmain.micommandFollow.Checked:=frmain.SynEdit1.Visible;
  frmain.micommandFollow.Enabled:=frmain.SynEdit1.Visible;
  if frmain.SynEdit1.Visible=false then
    frmain.SynEdit1.Lines.Clear;
end;

procedure Tfrmain.milistOpenDestinationClick(Sender: TObject);
begin
  if frmain.lvMain.ItemIndex<>-1 then
  begin
    if DirectoryExists(UTF8ToSys(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columndestiny])) then
    begin
      if not OpenURL(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columndestiny]) then
        OpenURL(ExtractShortPathName(UTF8ToSys(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columndestiny])));
    end
    else
      ShowMessage(frstrings.msgnoexistfolder.Caption+' '+frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columndestiny]);
  end;
end;

procedure Tfrmain.mimainShowStateClick(Sender: TObject);
begin
  frmain.lvMain.Column[0].Visible:=not frmain.lvMain.Column[0].Visible;
  frmain.lvFilter.Column[0].Visible:=not frmain.lvFilter.Column[0].Visible;
  frmain.mimainShowState.Checked:=frmain.lvMain.Column[0].Visible;
end;

procedure Tfrmain.mimainShowNameClick(Sender: TObject);
begin
  frmain.lvMain.Column[columnname+1].Visible:=not frmain.lvMain.Column[columnname+1].Visible;
  frmain.lvFilter.Column[columnname+1].Visible:=not frmain.lvFilter.Column[columnname+1].Visible;
  frmain.mimainShowName.Checked:=frmain.lvMain.Column[columnname+1].Visible;
end;

procedure Tfrmain.mimainShowSizeClick(Sender: TObject);
begin
  frmain.lvMain.Column[columnsize+1].Visible:=not frmain.lvMain.Column[columnsize+1].Visible;
  frmain.lvFilter.Column[columnsize+1].Visible:=not frmain.lvFilter.Column[columnsize+1].Visible;
  frmain.mimainShowSize.Checked:=frmain.lvMain.Column[columnsize+1].Visible;
end;

procedure Tfrmain.mimainShowURLClick(Sender: TObject);
begin
  frmain.lvMain.Column[columnurl+1].Visible:=not frmain.lvMain.Column[columnurl+1].Visible;
  frmain.lvFilter.Column[columnurl+1].Visible:=not frmain.lvFilter.Column[columnurl+1].Visible;
  frmain.mimainShowURL.Checked:=frmain.lvMain.Column[columnurl+1].Visible;
end;

procedure Tfrmain.MenuItem3Click(Sender: TObject);
begin
  if frmain.tvMain.SelectionCount>0 then
  begin
    if frmain.tvMain.Selected.Level>0 then
    begin
      case frmain.tvMain.Selected.Parent.Index of
        1:
        begin//colas
          queuemanual[frmain.tvMain.Selected.Index]:=true;
          qtimer[frmain.tvMain.Selected.Index].Interval:=1000;
          qtimer[frmain.tvMain.Selected.Index].Enabled:=true;
        end;
      end;
    end;
  end;
end;

procedure Tfrmain.mimainShowSpeedClick(Sender: TObject);
begin
  frmain.lvMain.Column[columnspeed+1].Visible:=not frmain.lvMain.Column[columnspeed+1].Visible;
  frmain.lvFilter.Column[columnspeed+1].Visible:=not frmain.lvFilter.Column[columnspeed+1].Visible;
  frmain.mimainShowSpeed.Checked:=frmain.lvMain.Column[columnspeed+1].Visible;
end;

procedure Tfrmain.mimainShowPercentClick(Sender: TObject);
begin
  frmain.lvMain.Column[columnpercent+1].Visible:=not frmain.lvMain.Column[columnpercent+1].Visible;
  frmain.lvFilter.Column[columnpercent+1].Visible:=not frmain.lvFilter.Column[columnpercent+1].Visible;
  frmain.mimainShowPercent.Checked:=frmain.lvMain.Column[columnpercent+1].Visible;
end;

procedure Tfrmain.mimainShowEstimatedClick(Sender: TObject);
begin
  frmain.lvMain.Column[columnestimate+1].Visible:=not frmain.lvMain.Column[columnestimate+1].Visible;
  frmain.lvFilter.Column[columnestimate+1].Visible:=not frmain.lvFilter.Column[columnestimate+1].Visible;
  frmain.mimainShowEstimated.Checked:=frmain.lvMain.Column[columnestimate+1].Visible;
end;

procedure Tfrmain.mimainShowDestinationClick(Sender: TObject);
begin
  frmain.lvMain.Column[columndestiny+1].Visible:=not frmain.lvMain.Column[columndestiny+1].Visible;
  frmain.lvFilter.Column[columndestiny+1].Visible:=not frmain.lvFilter.Column[columndestiny+1].Visible;
  frmain.mimainShowDestination.Checked:=frmain.lvMain.Column[columndestiny+1].Visible;
end;

procedure Tfrmain.mimainShowEngineClick(Sender: TObject);
begin
  frmain.lvMain.Column[columnengine+1].Visible:=not frmain.lvMain.Column[columnengine+1].Visible;
  frmain.lvFilter.Column[columnengine+1].Visible:=not frmain.lvFilter.Column[columnengine+1].Visible;
  frmain.mimainShowEngine.Checked:=frmain.lvMain.Column[columnengine+1].Visible;
end;

procedure Tfrmain.milistOpenFileClick(Sender: TObject);
begin
  if frmain.lvMain.ItemIndex<>-1 then
  begin
    if frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columntype]='0' then
    begin
      if FileExists(UTF8ToSys(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnname])) then
        OpenURL(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnname])
      else
        ShowMessage(frstrings.msgfilenoexist.Caption);
    end;
  end;
end;

procedure Tfrmain.milistOpenURLClick(Sender: TObject);
begin
  if frmain.lvMain.ItemIndex<>-1 then
    OpenURL(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnurl]);
end;

procedure Tfrmain.mimainRestartAllLaterClick(Sender: TObject);
var
  x:integer;
begin
  frconfirm.Caption:=frstrings.dlgconfirm.Caption;
  frconfirm.dlgtext.Caption:=frstrings.dlgrestartalldownloadslatter.Caption;
  frconfirm.ShowModal;
  if dlgcuestion then
  begin
    frmain.mimainSelectAllClick(nil);
    for x:=0 to frmain.lvMain.Items.Count-1 do
    begin
      if (frmain.lvMain.Items[x].Subitems[columnstatus]<>'1') and frmain.lvMain.Items[x].Selected then
        restartdownload(x,false,false);
    end;
  end;
  if frmain.lvFilter.Visible then
    frmain.tvMainSelectionChanged(nil);
end;

procedure Tfrmain.milistRestartLaterClick(Sender: TObject);
begin
  if frmain.lvMain.ItemIndex<>-1 then
  begin
    frconfirm.Caption:=frstrings.dlgconfirm.Caption;
    frconfirm.dlgtext.Caption:=frstrings.dlgrestartselecteddownloadletter.Caption+#10#13+#10#13+frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnname];
    frconfirm.ShowModal;
    if dlgcuestion then
    begin
      restartdownload(frmain.lvMain.ItemIndex,false);
    end;
  end;
end;

procedure Tfrmain.milistSteepUpClick(Sender: TObject);
begin
  movestepup(frmain.lvMain.ItemIndex-1);
end;

procedure Tfrmain.mimainShowTrayDownsClick(Sender: TObject);
var
  i:integer;
begin
  frmain.mimainShowTrayDowns.Checked:=not frmain.mimainShowTrayDowns.Checked;
  showdowntrayicon:=frmain.mimainShowTrayDowns.Checked;
  for i:=0 to Length(trayicons)-1 do
  begin
    if Assigned(trayicons[i]) then
    begin
      if showdowntrayicon then
      begin
        if frmain.lvMain.Items[i].SubItems[columnstatus]='1' then
          trayicons[i].Visible:=true;
      end
      else
        trayicons[i].Visible:=false;
    end;
  end;
end;

procedure Tfrmain.milistSteepDownClick(Sender: TObject);
begin
  movestepdown(frmain.lvMain.ItemIndex+1);
end;

procedure Tfrmain.milistToUpClick(Sender: TObject);
begin
  movestepup(0);
end;

procedure Tfrmain.milistToDownClick(Sender: TObject);
begin
  movestepdown(frmain.lvMain.Items.Count-1);
end;

procedure Tfrmain.micommandFollowClick(Sender: TObject);
begin
  frmain.micommandFollow.Checked:=not frmain.micommandFollow.Checked;
end;

procedure Tfrmain.mimainImportDownClick(Sender: TObject);
begin
  importdownloads();
end;

procedure Tfrmain.mimainExportDownClick(Sender: TObject);
begin
  exportdownloads();
end;

procedure Tfrmain.mimainStartQueueClick(Sender: TObject);
begin
  if frmain.tvMain.SelectionCount>0 then
  begin
    if frmain.tvMain.Selected.Level>0 then
    begin
      case frmain.tvMain.Selected.Parent.Index of
        1:
        begin//colas
          queuemanual[frmain.tvMain.Selected.Index]:=true;
          qtimer[frmain.tvMain.Selected.Index].Interval:=1000;
          qtimer[frmain.tvMain.Selected.Index].Enabled:=true;
        end;
      end;
    end;
  end;
end;

procedure Tfrmain.mimainStopQueueClick(Sender: TObject);
begin
  if frmain.tvMain.SelectionCount>0 then
  begin
    if frmain.tvMain.Selected.Level>0 then
    begin
      case frmain.tvMain.Selected.Parent.Index of
        1:
        begin//colas
          stopqueue(frmain.tvMain.Selected.Index);
        end;
      end;
    end;
  end;
end;

procedure Tfrmain.milistClearLogClick(Sender: TObject);
begin
  if frmain.lvMain.ItemIndex<>-1 then
  begin
    frconfirm.Caption:=frstrings.dlgconfirm.Caption;
    frconfirm.dlgtext.Caption:=frstrings.dlgclearhistorylogfile.Caption;
    frconfirm.ShowModal;
    if dlgcuestion then
    begin
      if FileExists(UTF8ToSys(logpath+pathdelim+frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnname])+'.log') then
        SysUtils.DeleteFile(UTF8ToSys(logpath+pathdelim+frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnname])+'.log');
    end;
    frmain.SynEdit1.Lines.Clear;
  end;
end;

procedure Tfrmain.miAddDownClick(Sender: TObject);
begin
  tbAddDownClick(nil);
end;

procedure Tfrmain.MenuItem60Click(Sender: TObject);
begin
  startsheduletimer();
end;

procedure Tfrmain.mitraydownStartClick(Sender: TObject);
begin
  if frmain.lvMain.Items[numtraydown].SubItems[columnstatus]<>'1' then
  begin
    downloadstart(numtraydown,false);
  end;
end;

procedure Tfrmain.mimainExitClick(Sender: TObject);
begin
  saveandexit();
end;

procedure Tfrmain.mitraydownStopClick(Sender: TObject);
begin
  if frmain.lvMain.Items[numtraydown].SubItems[columnstatus]='1' then
    hilo[strtoint(frmain.lvMain.Items[numtraydown].SubItems[columnid])].shutdown();
  if qtimer[strtoint(frmain.lvMain.Items[numtraydown].SubItems[columnqueue])].Enabled then
      frmain.lvMain.Items[numtraydown].SubItems[columntries]:='0';
end;

procedure Tfrmain.mitrydownHideClick(Sender: TObject);
begin
  trayicons[numtraydown].Visible:=false;
end;

procedure Tfrmain.mimainShowDateClick(Sender: TObject);
begin
  frmain.lvMain.Column[columndate+1].Visible:=not frmain.lvMain.Column[columndate+1].Visible;
  frmain.lvFilter.Column[columndate+1].Visible:=not frmain.lvFilter.Column[columndate+1].Visible;
  frmain.mimainShowDate.Checked:=frmain.lvMain.Column[columndate+1].Visible;
end;

procedure Tfrmain.mitreeAddQueueClick(Sender: TObject);
begin
  newqueue();
end;

procedure Tfrmain.mitreeDeleteQueueClick(Sender: TObject);
begin
  deletequeue(frmain.tvMain.Selected.Index);
end;

procedure Tfrmain.mitreeRenameQueueClick(Sender: TObject);
begin
  frmain.tvMain.Selected.EditText;
end;

procedure Tfrmain.mimainAddGrabberClick(Sender: TObject);
begin
  frmain.tbAddGrabberClick(nil);
end;

procedure Tfrmain.miAddGrabberClick(Sender: TObject);
begin
  frmain.tbAddGrabberClick(nil);
end;

procedure Tfrmain.mimainConfigClick(Sender: TObject);
begin
  frconfig.tvConfig.Items[frconfig.PageControl1.ActivePageIndex].Selected:=true;
  configdlg();
  frconfig.Show;
end;

procedure Tfrmain.mimainHomePageClick(Sender: TObject);
begin
  OpenURL('http://sites.google.com/site/awggproject');
end;

procedure Tfrmain.milistShowTrayIconClick(Sender: TObject);
begin
  if frmain.lvMain.ItemIndex<>-1 then
  begin
    trayicons[frmain.lvMain.ItemIndex].Visible:=not trayicons[frmain.lvMain.ItemIndex].Visible;
    frmain.milistShowTrayIcon.Checked:=trayicons[frmain.lvMain.ItemIndex].Visible;
  end;
end;

procedure Tfrmain.mitreeStartQueueClick(Sender: TObject);
begin
  if frmain.tvMain.SelectionCount>0 then
  begin
    if frmain.tvMain.Selected.Level>0 then
    begin
      case frmain.tvMain.Selected.Parent.Index of
        1:
        begin//colas
          queuemanual[frmain.tvMain.Selected.Index]:=true;
          qtimer[frmain.tvMain.Selected.Index].Interval:=1000;
          qtimer[frmain.tvMain.Selected.Index].Enabled:=true;
        end;
      end;
    end;
  end;
end;

procedure Tfrmain.mitreeStopQueueClick(Sender: TObject);
begin
  if frmain.tvMain.SelectionCount>0 then
  begin
    if frmain.tvMain.Selected.Level>0 then
    begin
      case frmain.tvMain.Selected.Parent.Index of
        1:
        begin//colas
          stopqueue(frmain.tvMain.Selected.Index);
        end;
      end;
    end;
  end;
end;

procedure Tfrmain.milistCopyFilesClick(Sender: TObject);
var
  i:integer;
begin
  frmain.SelectDirectoryDialog1.Execute;
  if (frmain.SelectDirectoryDialog1.FileName<>'') then
  begin
    SetLength(copywork,Length(copywork)+1);
    copywork[Length(copywork)-1]:=copythread.Create(true,Length(copywork)-1);
    copywork[Length(copywork)-1].id:=Length(copywork)-1;
    for i:=0 to frmain.lvMain.Items.Count-1 do
    begin
      if (frmain.lvMain.Items[i].Selected) and (frmain.lvMain.Items[i].SubItems[columnstatus]='3') and (FileExists(UTF8ToSys(frmain.lvMain.Items[i].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[i].SubItems[columnname]))) then
        copywork[Length(copywork)-1].source.Add(frmain.lvMain.Items[i].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[i].SubItems[columnname]);
    end;
    copywork[Length(copywork)-1].destination:=frmain.SelectDirectoryDialog1.FileName;
    copywork[Length(copywork)-1].Start;
  end;
end;

procedure Tfrmain.milistDeleteDownDiskClick(Sender: TObject);
begin
  deleteitems(true);
end;

procedure Tfrmain.mimainDeleteDownDiskClick(Sender: TObject);
begin
  deleteitems(true);
end;

procedure Tfrmain.psVerticalChangeBounds(Sender: TObject);
begin
  splitpos:=Round(frmain.psVertical.Height/1.3);
  if frmain.SynEdit1.Visible then
    frmain.psVertical.Position:=splitpos
  else
    frmain.psVertical.Position:=frmain.psVertical.Height;
end;

procedure Tfrmain.psVerticalMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  splitpos:=frmain.psVertical.Position;
end;

procedure Tfrmain.psVerticalResize(Sender: TObject);
begin
  if frmain.SynEdit1.Visible then
    splitpos:=frmain.psVertical.Position;
end;

procedure Tfrmain.psHorizontalChangeBounds(Sender: TObject);
begin
  splithpos:=frmain.psHorizontal.Position;
end;

procedure Tfrmain.psHorizontalMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  splithpos:=frmain.psHorizontal.Position;
end;

procedure Tfrmain.psHorizontalResize(Sender: TObject);
begin
  splithpos:=frmain.psHorizontal.Position;
end;

procedure Tfrmain.psHorizontalLeftSideMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  splithpos:=frmain.psHorizontal.Position;
end;

procedure Tfrmain.psHorizontalLeftSideResize(Sender: TObject);
begin
  splithpos:=frmain.psHorizontal.Position;
end;

procedure Tfrmain.pmCommandOutPopup(Sender: TObject);
begin
  if frmain.SynEdit1.SelText<>'' then
    frmain.micommandCopy.Enabled:=true
  else
    frmain.micommandCopy.Enabled:=False;
end;

procedure Tfrmain.AutoSaveTimerTimer(Sender: TObject);
begin
  savemydownloads();
  frmain.AutoSaveTimer.Enabled:=false;
end;

procedure Tfrmain.ClipboardTimerStartTimer(Sender: TObject);
begin
  frmain.tbClipBoard.Down:=frmain.ClipBoardTimer.Enabled;
end;

procedure Tfrmain.ClipboardTimerStopTimer(Sender: TObject);
begin
  frmain.tbClipBoard.Down:=frmain.ClipBoardTimer.Enabled;
end;

procedure Tfrmain.ClipboardTimerTimer(Sender: TObject);
var
  cbn:integer;
  noesta:boolean;
  tmpclip:string='';
begin
  noesta:=true;
  if ClipBoard.HasFormat(CF_TEXT) then
  begin
  if sameclip<>ClipBoard.AsText then
  begin
    sameclip:=ClipBoard.AsText;
    tmpclip:=Copy(sameclip,0,6);
    if (tmpclip='http:/') or (tmpclip='https:') or (tmpclip='ftp://') then
    begin
      for cbn:=0 to frmain.lvMain.Items.Count-1 do
      begin
        if sameclip=frmain.lvMain.Items[cbn].SubItems[columnurl] then
          noesta:=false;
      end;
      if noesta then
      begin
        frmain.ClipBoardTimer.Enabled:=false;
        tbAddDownClick(nil);
        frmain.ClipBoardTimer.Enabled:=true;
      end;
    end;
    tmpclip:='';
  end;
  end;
end;

procedure Tfrmain.FirstStartTimerTimer(Sender: TObject);
var
  downitem:TListItem;
  tmpindex,i:integer;
  itemfile:TSearchRec;
  fcookie:string='';
  fname:string='';
  referer:string='';
  post:string='';
  header:string='';
  url:string='';
  useragent:string='';
  silent:boolean=false;
begin
  newdownqueues();
  frmain.FirstStartTimer.Enabled:=false;
  if firststart then
  begin
    frlang.ComboBox1.Items.Clear;
    if FindFirst(ExtractFilePath(UTF8ToSys(Application.Params[0]))+pathdelim+'languages'+pathdelim+'awgg.*.po',faAnyFile,itemfile)=0 then
    begin
      Repeat
        try
          frlang.ComboBox1.Items.Add(Copy(itemfile.name,Pos('awgg.',itemfile.name)+5,Pos('.po',itemfile.name)-6));
        except
        on E:Exception do ShowMessage('The file '+itemfile.Name+' of language is not valid');
        end;
      Until FindNext(itemfile)<>0;
    end;
    if frlang.ComboBox1.Items.Count>0 then
    begin
      frlang.ComboBox1.ItemIndex:=0;
      frlang.ShowModal;
      deflanguage:=frlang.ComboBox1.Text;
    end;
    SetDefaultLang(deflanguage);
    updatelangstatus();
    if ddowndir='' then //Para version portable
    begin
      ddowndir:=SysToUTF8(GetUserDir()+'Downloads');
      ///More compatible for modern windows version
      {$IFDEF WINDOWS}
        //registro:=TRegistry.Create;
        //registro.RootKey:=HKEY_CURRENT_USER;
        //registro.OpenKey('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\',false);
        //ddowndir:=SysToUTF8(registro.ReadString('Personal')+PathDelim+'Downloads');
        //registro.CloseKey;
        //registro.Free;
      {$ENDIF}
    end;
    logpath:=ddowndir+pathdelim+'logs';
    if not DirectoryExists(ddowndir) then
      CreateDir(ddowndir);
    defaultcategory();
    categoryreload();
    frconfirm.dlgtext.Caption:=firefoxintegration;
    frconfirm.ShowModal;
    if dlgcuestion then
    begin
      ShowMessage(frstrings.firefoxhelpintegration.Caption);
      setfirefoxintegration();
      OpenURL('http://sites.google.com/site/awggproject');
    end;
  end;
  dotherdowndir:=ddowndir+pathdelim+'Others';
  updatelangstatus();
  titlegen();
  firststart:=false;
  if (Application.ParamCount>0) then
  begin
    for i:=1 to Application.ParamCount do
    begin
      if Application.Params[i]='-s' then
        silent:=true;
      if (Application.Params[i]='-n') and (Application.ParamCount>i) then
      begin
        if (Application.Params[i+1]<>'-c') then
          fname:=Application.Params[i+1];
      end;
      if (Application.Params[i]='-c') and (Application.ParamCount>i) then
      begin
        if (Copy(Application.Params[i+1],0,1)<>'-') then
          fcookie:=Application.Params[i+1];
      end;
      if (Application.Params[i]='-r') and (Application.ParamCount>i) then
      begin
        if (Copy(Application.Params[i+1],0,1)<>'-') then
          referer:=Application.Params[i+1];
      end;
      if (Application.Params[i]='-p') and (Application.ParamCount>i) then
      begin
        if (Copy(Application.Params[i+1],0,1)<>'-') then
          post:=Application.Params[i+1];
      end;
      if (Application.Params[i]='-h') and (Application.ParamCount>i) then
      begin
        if (Copy(Application.Params[i+1],0,1)<>'-') then
          header:=Application.Params[i+1];
      end;
      if (Application.Params[i]='-u') and (Application.ParamCount>i) then
      begin
        if (Copy(Application.Params[i+1],0,1)<>'-') then
          useragent:=Application.Params[i+1];
      end;
      if ((Pos('http://',Application.Params[i])=1) or (Pos('https://',Application.Params[i])=1) or (Pos('ftp://',Application.Params[i])=1)) and (url='') then
      begin
        url:=Application.Params[i];
      end;
    end;
    frnewdown.Edit1.Text:=url;
    if fname<>'' then
      frnewdown.Edit3.Text:=fname
    else
      frnewdown.Edit3.Text:=ParseURI(frnewdown.Edit1.Text).Document;
    case defaultdirmode of
      1:frnewdown.DirectoryEdit1.Text:=ddowndir;
      2:frnewdown.DirectoryEdit1.Text:=suggestdir(frnewdown.Edit3.Text);
    end;
    frnewdown.Edit2.Text:='';
    frnewdown.Edit4.Text:='';
    frnewdown.Edit5.Text:='';
    frnewdown.ComboBox1.ItemIndex:=frnewdown.ComboBox1.Items.IndexOf(defaultengine);
    frmain.ClipBoardTimer.Enabled:=false;//Desactivar temporalmente el clipboard monitor
    enginereload();
    if frnewdown.ComboBox2.ItemIndex=-1 then
      frnewdown.ComboBox2.ItemIndex:=0;
    //queueindexselect();
    if (frnewdown.Visible=false) and (silent=false) then
      frnewdown.ShowModal;
    if silent then
      silent:=checkandclose(true);
    frmain.ClipBoardTimer.Enabled:=clipboardmonitor;//Avtivar el clipboardmonitor
    if (agregar or silent) and (updateurl=false) then
    begin
      downitem:=TListItem.Create(frmain.lvMain.Items);
      downitem.Caption:=frstrings.statuspaused.Caption;
      downitem.ImageIndex:=18;
      downitem.SubItems.Add(frnewdown.Edit3.Text);//Nombre de archivo
      downitem.SubItems.Add('');//Tama;o
      downitem.SubItems.Add('');//Descargado
      downitem.SubItems.Add(frnewdown.Edit1.Text);//URL
      downitem.SubItems.Add('');//Velocidad
      downitem.SubItems.Add('');//Porciento
      downitem.SubItems.Add('');//Estimado
      downitem.SubItems.Add(datetostr(Date())+' '+timetostr(Time()));//Fecha
      downitem.SubItems.Add(frnewdown.DirectoryEdit1.Text);//Destino
      downitem.SubItems.Add(frnewdown.ComboBox1.Text);//Motor
      downitem.SubItems.Add(frnewdown.Edit2.Text);//Parametros
      downitem.SubItems.Add('0');//status
      downitem.SubItems.Add(inttostr(frmain.lvMain.Items.Count));//id
      downitem.SubItems.Add(frnewdown.Edit4.Text);//user
      downitem.SubItems.Add(frnewdown.Edit5.Text);//pass
      downitem.SubItems.Add(inttostr(triesrotate));//tries
      downitem.SubItems.Add(uidgen());//uid
      if silent then
        downitem.SubItems.Add('0')//silent defualt queue
      else
        downitem.SubItems.Add(inttostr(frnewdown.ComboBox2.ItemIndex));//queue
      downitem.SubItems.Add('0');//type
      downitem.SubItems.Add(fcookie);//cookie
      downitem.SubItems.Add(referer);//referer
      downitem.SubItems.Add(post);//post
      downitem.SubItems.Add(header);//header
      downitem.SubItems.Add(useragent);//useragent
      frmain.lvMain.Items.AddItem(downitem);
      tmpindex:=downitem.Index;
      if cola then
      begin
        queuemanual[strtoint(frmain.lvMain.Items[tmpindex].SubItems[columnqueue])]:=true;
        qtimer[strtoint(frmain.lvMain.Items[tmpindex].SubItems[columnqueue])].Enabled:=true;
      end;
      frmain.tvMainSelectionChanged(nil);
      savemydownloads();
      if iniciar or silent then
      begin
        queuemanual[strtoint(frmain.lvMain.Items[tmpindex].SubItems[columnqueue])]:=true;
        downloadstart(tmpindex,false);
      end;
    end;
  end;
  silent:=false;
end;

procedure Tfrmain.tbStopQueueClick(Sender: TObject);
begin
  if frmain.tvMain.SelectionCount>0 then
  begin
    if frmain.tvMain.Selected.Level>0 then
    begin
      case frmain.tvMain.Selected.Parent.Index of
        1:
        begin//colas
          stopqueue(frmain.tvMain.Selected.Index);
        end;
      end;
    end
    else
    begin
      if frmain.lvMain.ItemIndex<>-1 then
      begin
        stopqueue(strtoint(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnqueue]));
      end;
    end;
  end;
end;

procedure Tfrmain.tbStopAllClick(Sender: TObject);
begin
  stopall(false);
end;

procedure Tfrmain.ToolButton14Click(Sender: TObject);
begin
  frmain.SynEdit1.Lines.Clear;
end;

procedure Tfrmain.tbStartSchedulerClick(Sender: TObject);
begin
  startsheduletimer();
end;

procedure Tfrmain.tbStopSchedulerClick(Sender: TObject);
begin
  if frmain.tvMain.SelectionCount>0 then
  begin
    if frmain.tvMain.Selected.Level>0 then
    begin
      case frmain.tvMain.Selected.Parent.Index of
        1:
        begin//colas
          stimer[frmain.tvMain.Selected.Index].Enabled:=false;
        end;
      end;
    end;
  end;
end;

procedure Tfrmain.tbExitClick(Sender: TObject);
begin
  saveandexit();
end;

procedure Tfrmain.tbSteepUpClick(Sender: TObject);
begin
  moveonestepup();
end;

procedure Tfrmain.tbAddDownClick(Sender: TObject);
var
  downitem:TListItem;
  tmpindex:integer;
  tmpclip:string='';
begin
  if Length(ClipBoard.AsText)<=256 then
    tmpclip:=ClipBoard.AsText;
  if (Pos('http://',tmpclip)=1) or (Pos('https://',tmpclip)=1) or (Pos('ftp://',tmpclip)=1) then
    frnewdown.Edit1.Text:=tmpclip
  else
    frnewdown.Edit1.Text:='http://';
  tmpclip:='';
  frnewdown.Edit3.Text:=ParseURI(frnewdown.Edit1.Text).Document;
  case defaultdirmode of
    1:frnewdown.DirectoryEdit1.Text:=ddowndir;
    2:frnewdown.DirectoryEdit1.Text:=suggestdir(frnewdown.Edit3.Text);
  end;
  frnewdown.Edit2.Text:='';
  frnewdown.Edit4.Text:='';
  frnewdown.Edit5.Text:='';
  frnewdown.ComboBox1.ItemIndex:=frnewdown.ComboBox1.Items.IndexOf(defaultengine);
  frmain.ClipBoardTimer.Enabled:=false;//Descativar temporalmete el clipboardmonitor
  //Recargar engines
  enginereload();
  queueindexselect();
  if frnewdown.Visible=false then
    frnewdown.ShowModal;
  frmain.ClipBoardTimer.Enabled:=clipboardmonitor;//Activar el clipboardmonitor.
  if agregar and (updateurl=false) then
  begin
    downitem:=TListItem.Create(frmain.lvMain.Items);
    downitem.Caption:=frstrings.statuspaused.Caption;
    downitem.ImageIndex:=18;
    downitem.SubItems.Add(frnewdown.Edit3.Text);//Nombre de archivo
    downitem.SubItems.Add('');//Tama;o
    downitem.SubItems.Add('');//Descargado
    downitem.SubItems.Add(frnewdown.Edit1.Text);//URL
    downitem.SubItems.Add('');//Velocidad
    downitem.SubItems.Add('');//Porciento
    downitem.SubItems.Add('');//Estimado
    downitem.SubItems.Add(datetostr(Date())+' '+timetostr(Time()));//Fecha
    downitem.SubItems.Add(frnewdown.DirectoryEdit1.Text);//Destino
    downitem.SubItems.Add(frnewdown.ComboBox1.Text);//Motor
    downitem.SubItems.Add(frnewdown.Edit2.Text);//Parametros
    downitem.SubItems.Add('0');//status
    downitem.SubItems.Add(inttostr(frmain.lvMain.Items.Count));//id
    downitem.SubItems.Add(frnewdown.Edit4.Text);//user
    downitem.SubItems.Add(frnewdown.Edit5.Text);//pass
    downitem.SubItems.Add(inttostr(triesrotate));//tries
    downitem.SubItems.Add(uidgen());//uid
    downitem.SubItems.Add(inttostr(frnewdown.ComboBox2.ItemIndex));//queue
    downitem.SubItems.Add('0');//type
    downitem.SubItems.Add('');//cookie
    downitem.SubItems.Add('');//referer
    downitem.SubItems.Add('');//post
    downitem.SubItems.Add('');//header
    downitem.SubItems.Add('');//useragent
    frmain.lvMain.Items.AddItem(downitem);
    tmpindex:=downitem.Index;
    if cola then
    begin
      queuemanual[strtoint(frmain.lvMain.Items[tmpindex].SubItems[columnqueue])]:=true;
      qtimer[strtoint(frmain.lvMain.Items[tmpindex].SubItems[columnqueue])].Enabled:=true;
    end;
    frmain.tvMainSelectionChanged(nil);
    savemydownloads();
    if iniciar then
    begin
      queuemanual[strtoint(frmain.lvMain.Items[tmpindex].SubItems[columnqueue])]:=true;
      downloadstart(tmpindex,false);
    end;
  end;
end;

procedure Tfrmain.tbSteepDownClick(Sender: TObject);
begin
  if frmain.lvMain.ItemIndex<>-1 then
  moveonestepdown(frmain.lvMain.ItemIndex);
end;

procedure Tfrmain.tbRestartNowClick(Sender: TObject);
begin
  if frmain.lvMain.ItemIndex<>-1 then
  begin
    frconfirm.Caption:=frstrings.dlgconfirm.Caption;
    frconfirm.dlgtext.Caption:=frstrings.dlgrestartselecteddownload.Caption+#10#13+#10#13+frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnname];
    frconfirm.ShowModal;
    if dlgcuestion then
    begin
      restartdownload(frmain.lvMain.ItemIndex,true);
    end;
  end;
end;

procedure Tfrmain.tbToUpClick(Sender: TObject);
begin
  movestepup(0);
end;

procedure Tfrmain.tbToDownClick(Sender: TObject);
begin
  movestepdown(frmain.lvMain.Items.Count-1);
end;

procedure Tfrmain.tbImportDownClick(Sender: TObject);
begin
  importdownloads();
end;

procedure Tfrmain.tbExportDownClick(Sender: TObject);
begin
  exportdownloads();
end;

procedure Tfrmain.tbAddGrabberClick(Sender: TObject);
var
  downitem:TListItem;
  tmpclip:string='';
  paramlist:string='';
begin
  frsitegrabber.Edit2.Text:='';
  if Length(ClipBoard.AsText)<=256 then
  tmpclip:=ClipBoard.AsText;
  if (Pos('http://',tmpclip)=1) or (Pos('https://',tmpclip)=1) or (Pos('ftp://',tmpclip)=1) then
    frsitegrabber.Edit1.Text:=tmpclip
  else
    frsitegrabber.Edit1.Text:='http://';
  tmpclip:='';
  frsitegrabber.Edit2.Text:=ParseURI(frsitegrabber.Edit1.Text).Host;
  frsitegrabber.DirectoryEdit1.Text:=ddowndir+pathdelim+'Sites';
  if not DirectoryExists(ddowndir+pathdelim+'Sites') then
    CreateDir(ddowndir+pathdelim+'Sites');
  frsitegrabber.Edit3.Text:='';
  frsitegrabber.Edit4.Text:='';
  frsitegrabber.Edit5.Text:=globaluseragent;
  frsitegrabber.ComboBox1.ItemIndex:=frsitegrabber.ComboBox1.Items.IndexOf(defaultengine);
  frmain.ClipBoardTimer.Enabled:=false;//Descativar temporalmete el clipboardmonitor
  newgrabberqueues();
  queueindexselect();
  frsitegrabber.PageControl1.PageIndex:=0;
  if frsitegrabber.Visible=false then
    frsitegrabber.ShowModal;
  frmain.ClipBoardTimer.Enabled:=clipboardmonitor;//Activar el clipboardmonitor.
  if grbadd then
  begin
    paramlist:=paramlist+'-l '+inttostr(frsitegrabber.SpinEdit1.Value);
    if frsitegrabber.CheckBox1.Checked then
      paramlist:=paramlist+' -k';
    if frsitegrabber.CheckBox2.Checked then
     paramlist:=paramlist+' --follow-ftp';
    if frsitegrabber.CheckBox3.Checked then
      paramlist:=paramlist+' -np';
    if frsitegrabber.CheckBox4.Checked then
      paramlist:=paramlist+' -p';
    if frsitegrabber.CheckBox5.Checked then
      paramlist:=paramlist+' -H';
    if frsitegrabber.CheckBox6.Checked then
      paramlist:=paramlist+' -L';
    if Length(frsitegrabber.Memo1.Lines.Text)>0 then
      paramlist:=paramlist+' -R "'+frsitegrabber.Memo1.Lines.Text+'"';
    if Length(frsitegrabber.Memo2.Lines.Text)>0 then
      paramlist:=paramlist+' --exclude-domains "'+frsitegrabber.Memo2.Lines.Text+'"';
    if Length(frsitegrabber.Memo3.Lines.Text)>0 then
      paramlist:=paramlist+' -D "'+frsitegrabber.Memo3.Lines.Text+'"';
    if Length(frsitegrabber.Memo4.Lines.Text)>0 then
      paramlist:=paramlist+' -I "'+frsitegrabber.Memo4.Lines.Text+'"';
    if Length(frsitegrabber.Memo5.Lines.Text)>0 then
      paramlist:=paramlist+' -X "'+frsitegrabber.Memo5.Lines.Text+'"';
    if Length(frsitegrabber.Memo6.Lines.Text)>0 then
      paramlist:=paramlist+' -A "'+frsitegrabber.Memo6.Lines.Text+'"';
    if Length(frsitegrabber.Memo7.Lines.Text)>0 then
      paramlist:=paramlist+' --follow-tags="'+frsitegrabber.Memo7.Lines.Text+'"';
    if Length(frsitegrabber.Memo8.Lines.Text)>0 then
      paramlist:=paramlist+' --ignore-tags="'+frsitegrabber.Memo8.Lines.Text+'"';
    if Length(frsitegrabber.Edit5.Text)>0 then
      paramlist:=paramlist+' -U "'+frsitegrabber.Edit5.Text+'"';
    downitem:=TListItem.Create(frmain.lvMain.Items);
    downitem.Caption:=frstrings.statuspaused.Caption;
    downitem.ImageIndex:=51;
    downitem.SubItems.Add(frsitegrabber.Edit2.Text);//Nombre del sitio
    downitem.SubItems.Add('');//Tama;o
    downitem.SubItems.Add('');//Descargado
    downitem.SubItems.Add(frsitegrabber.Edit1.Text);//URL
    downitem.SubItems.Add('');//Velocidad
    downitem.SubItems.Add('');//Porciento
    downitem.SubItems.Add('');//Estimado
    downitem.SubItems.Add(datetostr(Date())+' '+timetostr(Time()));//Fecha
    downitem.SubItems.Add(frsitegrabber.DirectoryEdit1.Text);//Destino
    downitem.SubItems.Add('wget');//Motor
    downitem.SubItems.Add(paramlist);//Parametros
    downitem.SubItems.Add('0');//status
    downitem.SubItems.Add(inttostr(frmain.lvMain.Items.Count));//id
    downitem.SubItems.Add(frsitegrabber.Edit3.Text);//user
    downitem.SubItems.Add(frsitegrabber.Edit4.Text);//pass
    downitem.SubItems.Add(inttostr(triesrotate));//tries
    downitem.SubItems.Add(uidgen());//uid
    downitem.SubItems.Add(inttostr(frsitegrabber.ComboBox1.ItemIndex));//queue
    downitem.SubItems.Add('1');//type
    downitem.SubItems.Add('');//cookie;
    downitem.SubItems.Add('');//referer;
    downitem.SubItems.Add('');//post;
    downitem.SubItems.Add('');//header;
    frmain.lvMain.Items.AddItem(downitem);
    frmain.tvMainSelectionChanged(nil);
    savemydownloads();
  end;
end;

procedure Tfrmain.tbDeleteDownClick(Sender: TObject);
begin
  deleteitems(false);
end;

procedure Tfrmain.tbClipBoardClick(Sender: TObject);
begin
  frmain.ClipBoardTimer.Enabled:=frmain.tbClipBoard.Down;
  clipboardmonitor:=frmain.tbClipBoard.Down;
end;

procedure Tfrmain.tbDelDownDiskClick(Sender: TObject);
begin
  deleteitems(true);
end;

procedure Tfrmain.tbStartDownClick(Sender: TObject);
begin
  if frmain.lvMain.ItemIndex<>-1 then
  begin
    queuemanual[strtoint(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnqueue])]:=true;
    downloadstart(frmain.lvMain.ItemIndex,false);
  end
  else
    ShowMessage(frstrings.msgmustselectdownload.Caption);
end;

procedure Tfrmain.tbStopDownClick(Sender: TObject);
begin
  if frmain.lvMain.ItemIndex<>-1 then
  begin
    hilo[strtoint(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnid])].shutdown();
    if qtimer[strtoint(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnqueue])].Enabled then
      frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columntries]:='0';
    frmain.tbStartDown.Enabled:=true;
    frmain.tbStopDown.Enabled:=false;
    frmain.tbRestartNow.Enabled:=true;
    frmain.tbRestartLater.Enabled:=true;
  end
  else
    ShowMessage(frstrings.msgmustselectdownload.Caption);
end;

procedure Tfrmain.tbConfigClick(Sender: TObject);
begin
  frconfig.tvConfig.Items[frconfig.PageControl1.ActivePageIndex].Selected:=true;
  configdlg();
  frconfig.Show;
end;

procedure Tfrmain.tbSchedulerClick(Sender: TObject);
begin
  frconfig.PageControl1.ActivePageIndex:=1;
  frconfig.tvConfig.Items[frconfig.PageControl1.ActivePageIndex].Selected:=true;
  configdlg();
  frconfig.Show;
end;

procedure Tfrmain.tbStartQueueClick(Sender: TObject);
begin
  if frmain.tvMain.SelectionCount>0 then
  begin
    if frmain.tvMain.Selected.Level>0 then
    begin
      case frmain.tvMain.Selected.Parent.Index of
        1:
        begin//colas
          queuemanual[frmain.tvMain.Selected.Index]:=true;
          qtimer[frmain.tvMain.Selected.Index].Interval:=1000;
          qtimer[frmain.tvMain.Selected.Index].Enabled:=true;
        end;
      end;
    end
    else
    begin
      if frmain.lvMain.ItemIndex<>-1 then
      begin
        queuemanual[strtoint(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnqueue])]:=true;
        qtimer[strtoint(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnqueue])].Interval:=1000;
        qtimer[strtoint(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnqueue])].Enabled:=true;
      end;
    end;
  end;
end;

procedure Tfrmain.MainTrayIconClick(Sender: TObject);
begin
  frmain.MainTrayIconMouseMove(nil,[ssShift], 0, 0);
end;

procedure Tfrmain.MainTrayIconDblClick(Sender: TObject);
begin
  frmain.WindowState:=lastmainwindowstate;
  if firsttime then
    frmain.Visible:=false;
  firsttime:=false;
  if(not frnewdown.Visible) and (not frconfig.Visible) then
  begin
    frmain.Show;
  end;
  if (frnewdown.Visible) and (not frconfig.Visible) then
    frnewdown.Show;
  if (not frnewdown.Visible) and (frconfig.Visible) then
    frconfig.Show;
end;

procedure Tfrmain.MainTrayIconMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  n,nc:integer;
  strhint:string;
begin
  nc:=0;
  strhint:='';
  for n:=0 to frmain.lvMain.Items.Count-1 do
  begin
    if frmain.lvMain.Items[n].SubItems[columnstatus]='1' then
      strhint+=frmain.lvMain.Items[n].SubItems[columnpercent]+' '+frmain.lvMain.Items[n].SubItems[columnname]+' '+frmain.lvMain.Items[n].SubItems[columnspeed]+' '+frmain.lvMain.Items[n].SubItems[columnestimate]+#10;
    if frmain.lvMain.Items[n].SubItems[columnstatus]='3' then
      inc(nc);
  end;
  if strhint<>'' then
    frmain.MainTrayIcon.Hint:='AWGG ['+inttostr(nc)+'/'+inttostr(frmain.lvMain.Items.Count)+']'+#10+Copy(strhint,0,Length(strhint)-1)
  else
    frmain.MainTrayIcon.Hint:='AWGG ['+inttostr(nc)+'/'+inttostr(frmain.lvMain.Items.Count)+']'+#10+'v'+version;
end;

procedure Tfrmain.tvMainContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  if frmain.tvMain.Items.SelectionCount>0 then
  begin
    if frmain.tvMain.Selected.Level>0 then
    begin
      case frmain.tvMain.Selected.Parent.Index of
        1:
        begin
          if frmain.tvMain.Selected.Index<>0 then
          begin
            frmain.mitreeAddQueue.Enabled:=true;
            frmain.mitreeDeleteQueue.Enabled:=true;
            frmain.mitreeRenameQueue.Enabled:=true;
            if qtimer[frmain.tvMain.Selected.Index].Enabled then
            begin
              frmain.mitreeStartQueue.Enabled:=false;
              frmain.mitreeStopQueue.Enabled:=true;
            end
            else
            begin
              frmain.mitreeStartQueue.Enabled:=true;
              frmain.mitreeStopQueue.Enabled:=false;
            end;
            frmain.pmTreeView.PopUp;
          end
          else
          begin
            frmain.mitreeAddQueue.Enabled:=true;
            frmain.mitreeDeleteQueue.Enabled:=false;
            frmain.mitreeRenameQueue.Enabled:=false;
            if qtimer[frmain.tvMain.Selected.Index].Enabled then
            begin
              frmain.mitreeStartQueue.Enabled:=false;
              frmain.mitreeStopQueue.Enabled:=true;
            end
            else
            begin
              frmain.mitreeStartQueue.Enabled:=true;
              frmain.mitreeStopQueue.Enabled:=false;
            end;
            frmain.pmTreeView.PopUp;
          end;
        end;
      end;
    end
    else
    begin
      //////elementos de la rais
      case frmain.tvMain.Selected.Index of
        1:
        begin
          frmain.mitreeAddQueue.Enabled:=true;
          frmain.mitreeDeleteQueue.Enabled:=false;
          frmain.mitreeRenameQueue.Enabled:=false;
          frmain.pmTreeView.PopUp;
        end;
      end;
    end;
  end;
end;

procedure Tfrmain.tvMainDblClick(Sender: TObject);
begin
  if frmain.tvMain.Selected.Level>0 then
  begin
    case frmain.tvMain.Selected.Parent.Index of
      3:
      begin//categorias
        if frmain.tvMain.Selected.Index<Length(categoryextencions) then
        begin
          if DirectoryExists(UTF8ToSys(categoryextencions[frmain.tvMain.Selected.Index][0])) then
          begin
            if not OpenURL(categoryextencions[frmain.tvMain.Selected.Index][0]) then
              OpenURL(ExtractShortPathName(UTF8ToSys(categoryextencions[frmain.tvMain.Selected.Index][0])));
          end
          else
            ShowMessage(frstrings.msgnoexistfolder.Caption+' '+categoryextencions[frmain.tvMain.Selected.Index][0]);
        end
        else
        begin
          if DirectoryExists(UTF8ToSys(dotherdowndir)) then
          begin
            if not OpenURL(dotherdowndir) then
              OpenURL(ExtractShortPathName(UTF8ToSys(dotherdowndir)));
          end
          else
            ShowMessage(frstrings.msgnoexistfolder.Caption+' '+dotherdowndir);
        end;
      end;
    end;
  end;
end;

procedure Tfrmain.tvMainEdited(Sender: TObject; Node: TTreeNode; var S: string
  );
begin
  if frmain.tvMain.Items.SelectionCount>0 then
  begin
    if frmain.tvMain.Selected.Level>0 then
    begin
      //elementos de las ramas
      case frmain.tvMain.Selected.Parent.Index of
        1:
        begin//colas
          if frmain.tvMain.Selected.Index<>0 then
          begin
            queuenames[frmain.tvMain.Selected.Index]:=s;
            frmain.milistSendToQueue.Items[frmain.tvMain.Selected.Index].Caption:=s;
            frnewdown.ComboBox2.Items[frmain.tvMain.Selected.Index]:=s;
            if qtimer[frmain.tvMain.Selected.Index].Enabled then
              frmain.pmTrayIcon.Items[frmain.tvMain.Selected.Index+5].Caption:=stopqueuesystray+' ('+s+')'
            else
              frmain.pmTrayIcon.Items[frmain.tvMain.Selected.Index+5].Caption:=startqueuesystray+' ('+s+')';
            savemydownloads();
          end;
        end;
      end;
    end;
  end;
end;

procedure Tfrmain.tvMainEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
  if frmain.tvMain.Items.SelectionCount>0 then
  begin
    if frmain.tvMain.Selected.Level>0 then
    begin
      //elementos de las ramas
      if frmain.tvMain.Selected.Parent.Index<>1 then
        allowedit:=false;
      case frmain.tvMain.Selected.Parent.Index of
        1:
        begin//colas
          if frmain.tvMain.Selected.Index=0 then
            allowedit:=false;
        end;
      end;
    end
    else
    begin
      //////elementos de la rais
      allowedit:=false;
    end;
  end;
end;

procedure Tfrmain.tvMainKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if frmain.tvMain.Items.SelectionCount>0 then
  begin
    if frmain.tvMain.Selected.Level>0 then
    begin
      case frmain.tvMain.Selected.Parent.Index of
        1:
        begin
          if frmain.tvMain.Selected.Index<>0 then
          begin
            case key of
              46:deletequeue(frmain.tvMain.Selected.Index);
            end;
          end
        end;
      end;
    end
    else
    begin
      //////elementos de la rais
      case frmain.tvMain.Selected.Index of
        1:
        begin

        end;
      end;
    end;
  end;
end;

procedure Tfrmain.tvMainSelectionChanged(Sender: TObject);
var
  i:integer;
  sts:string;
  vitem:TListItem;
begin
  sts:='';
  frmain.lvFilter.Items.Clear;
  if (frmain.tvMain.SelectionCount>0) then
  begin
    frmain.tbStartQueue.Enabled:=false;
    frmain.tbStopQueue.Enabled:=false;
    frmain.tbStartScheduler.Enabled:=false;
    frmain.tbStopScheduler.Enabled:=false;
    if frmain.tvMain.Selected.Level>0 then
    begin
      if frmain.lvFilter.Visible=false then
      begin
        for i:=0 to frmain.lvMain.Columns.Count-1 do
        begin
          frmain.lvFilter.Columns[i].Width:=frmain.lvMain.Columns[i].Width;
          frmain.lvFilter.Columns[i].Visible:=frmain.lvMain.Columns[i].Visible;
        end;
      end;
      if (frmain.lvMain.ItemIndex=-1) and (frmain.lvMain.Items.Count>0) then
        frmain.lvMain.ItemIndex:=0;
      frmain.lvMain.Visible:=false;
      frmain.lvFilter.Visible:=true;
      case frmain.tvMain.Selected.Parent.Index of
        1:
        begin//colas
          for i:=0 to frmain.lvMain.Items.Count-1 do
          begin
            if frmain.lvMain.Items[i].SubItems[columnqueue]=inttostr(frmain.tvMain.Selected.Index) then
            begin
              vitem:=TListItem.Create(frmain.lvFilter.Items);
              vitem.Caption:=frmain.lvMain.Items[i].Caption;
              vitem.ImageIndex:=frmain.lvMain.Items[i].ImageIndex;
              vitem.SubItems.AddStrings(frmain.lvMain.Items[i].SubItems);
              vitem.Selected:=frmain.lvMain.Items[i].Selected;
              frmain.lvFilter.Items.AddItem(vitem);
              vitem.Selected:=frmain.lvMain.Items[i].Selected;
              if frmain.lvMain.Items[i].SubItems[columnstatus]='1' then
              hilo[strtoint(frmain.lvMain.Items[i].SubItems[columnid])].thid2:=vitem.Index;
            end;
          end;
          if qtimer[frmain.tvMain.Selected.Index].Enabled then
          begin
            frmain.tbStartQueue.Enabled:=false;
            frmain.tbStopQueue.Enabled:=true;
          end
          else
          begin
            frmain.tbStartQueue.Enabled:=true;
            frmain.tbStopQueue.Enabled:=false;
          end;

          if stimer[frmain.tvMain.Selected.Index].Enabled then
          begin
            frmain.tbStartScheduler.Enabled:=false;
            frmain.tbStopScheduler.Enabled:=true;
          end
          else
          begin
            frmain.tbStartScheduler.Enabled:=true;
            frmain.tbStopScheduler.Enabled:=false;
          end;
        end;
        2:
        begin //filtros
          case frmain.tvMain.Selected.Index of
            0:sts:='3';
            1:sts:='1';
            2:sts:='2';
            3:sts:='4';
            4:sts:='0';
          end;
          for i:=0 to frmain.lvMain.Items.Count-1 do
          begin
            if frmain.lvMain.Items[i].SubItems[columnstatus]=sts then
            begin
              vitem:=TListItem.Create(frmain.lvFilter.Items);
              vitem.Caption:=frmain.lvMain.Items[i].Caption;
              vitem.ImageIndex:=frmain.lvMain.Items[i].ImageIndex;
              vitem.SubItems.AddStrings(frmain.lvMain.Items[i].SubItems);
              vitem.Selected:=frmain.lvMain.Items[i].Selected;
              frmain.lvFilter.Items.AddItem(vitem);
              vitem.Selected:=frmain.lvMain.Items[i].Selected;
              if frmain.lvMain.Items[i].SubItems[columnstatus]='1' then
                hilo[strtoint(frmain.lvMain.Items[i].SubItems[columnid])].thid2:=vitem.Index;
            end;
          end;
        end;
        3:
        begin//categorias
          for i:=0 to frmain.lvMain.Items.Count-1 do
          begin
            if frmain.tvMain.Selected.Index<Length(categoryextencions) then
            begin
              if findcategorydir(frmain.tvMain.Selected.Index,frmain.lvMain.Items[i].SubItems[columnname]) then
              begin
                vitem:=TListItem.Create(frmain.lvFilter.Items);
                vitem.Caption:=frmain.lvMain.Items[i].Caption;
                vitem.ImageIndex:=frmain.lvMain.Items[i].ImageIndex;
                vitem.SubItems.AddStrings(frmain.lvMain.Items[i].SubItems);
                vitem.Selected:=frmain.lvMain.Items[i].Selected;
                frmain.lvFilter.Items.AddItem(vitem);
                vitem.Selected:=frmain.lvMain.Items[i].Selected;
                if frmain.lvMain.Items[i].SubItems[columnstatus]='1' then
                  hilo[strtoint(frmain.lvMain.Items[i].SubItems[columnid])].thid2:=vitem.Index;
              end;
            end
            else
            begin
              if not findcategoryall(frmain.lvMain.Items[i].SubItems[columnname]) then
              begin
                vitem:=TListItem.Create(frmain.lvFilter.Items);
                vitem.Caption:=frmain.lvMain.Items[i].Caption;
                vitem.ImageIndex:=frmain.lvMain.Items[i].ImageIndex;
                vitem.SubItems.AddStrings(frmain.lvMain.Items[i].SubItems);
                vitem.Selected:=frmain.lvMain.Items[i].Selected;
                frmain.lvFilter.Items.AddItem(vitem);
                vitem.Selected:=frmain.lvMain.Items[i].Selected;
                if frmain.lvMain.Items[i].SubItems[columnstatus]='1' then
                  hilo[strtoint(frmain.lvMain.Items[i].SubItems[columnid])].thid2:=vitem.Index;
              end;
            end;
          end;
        end;
      end;
    end
    else
    begin
      if frmain.lvMain.Visible=false then
      begin
        for i:=0 to frmain.lvMain.Columns.Count-1 do
        begin
          frmain.lvMain.Columns[i].Width:=frmain.lvFilter.Columns[i].Width;
          frmain.lvMain.Columns[i].Visible:=frmain.lvFilter.Columns[i].Visible;
        end;
        //if columncolav then
        //begin
          //frmain.lvMain.Columns[0].Width:=columncolaw;
          //frmain.lvFilter.Columns[0].Width:=columncolaw;
        //end;
      end;
      frmain.lvMain.Visible:=true;
      frmain.lvFilter.Visible:=false;
    end;
  end;
end;

procedure Tfrmain.UniqueInstance1OtherInstance(Sender: TObject;
  ParamCount: Integer; Parameters: array of String);
var
  downitem:TListItem;
  tmpindex,i:integer;
  url:string='';
  fcookie:string='';
  fname:string='';
  referer:string='';
  post:string='';
  header:string='';
  useragent:string='';
  silent:boolean=false;
begin
  onestart:=false;
  if ParamCount>0 then
  begin
    for i:=0 to ParamCount-1 do
    begin
      if (Parameters[i]='-s') and (ParamCount>i) then
        silent:=true;
      if (Parameters[i]='-n') and (ParamCount>i) then
      begin
        if (Parameters[i+1]<>'-c') then
          fname:=SysToUTF8(Parameters[i+1]);
      end;
      if (Parameters[i]='-c') and (ParamCount>i) then
      begin
        if (Copy(Parameters[i+1],0,1)<>'-') then
          fcookie:=Parameters[i+1];
      end;
      if (Parameters[i]='-r') and (ParamCount>i) then
      begin
        if (Copy(Parameters[i+1],0,1)<>'-') then
          referer:=Parameters[i+1];
      end;
      if (Parameters[i]='-p') and (ParamCount>i) then
      begin
        if (Copy(Parameters[i+1],0,1)<>'-') then
          post:=Parameters[i+1];
      end;
      if (Parameters[i]='-h') and (ParamCount>i+1) then
      begin
        if (Copy(Parameters[i+1],0,1)<>'-') then
          header:=Parameters[i+1];
      end;
      if (Parameters[i]='-u') and (ParamCount>i+1) then
      begin
        if (Copy(Parameters[i+1],0,1)<>'-') then
          useragent:=Parameters[i+1];
      end;
      if ((Pos('http://',Parameters[i])=1) or (Pos('https://',Parameters[i])=1) or (Pos('ftp://',Parameters[i])=1)) and (url='') then
      begin
        url:=Parameters[i];
      end;
    end;
    frnewdown.Edit1.Text:=url;
    if fname<>'' then
      frnewdown.Edit3.Text:=fname
    else
      frnewdown.Edit3.Text:=ParseURI(frnewdown.Edit1.Text).Document;
    case defaultdirmode of
      1:frnewdown.DirectoryEdit1.Text:=ddowndir;
      2:frnewdown.DirectoryEdit1.Text:=suggestdir(frnewdown.Edit3.Text);
    end;
    frnewdown.Edit2.Text:='';
    frnewdown.Edit4.Text:='';
    frnewdown.Edit5.Text:='';
    frnewdown.ComboBox1.ItemIndex:=frnewdown.ComboBox1.Items.IndexOf(defaultengine);
    frmain.ClipBoardTimer.Enabled:=false;//Desactivar temporalmente el clipboardmonitor
    enginereload();
    if frnewdown.ComboBox2.ItemIndex=-1 then
      frnewdown.ComboBox2.ItemIndex:=0;
    //queueindexselect();
    if (frnewdown.Visible=false) and (silent=false) then
      frnewdown.ShowModal;
    if silent then
      silent:=checkandclose(true);
    frmain.ClipBoardTimer.Enabled:=clipboardmonitor;//Activar el clipboardmonitor
    if (agregar or silent) and (updateurl=false) then
    begin
      downitem:=TListItem.Create(frmain.lvMain.Items);
      downitem.Caption:=frstrings.statuspaused.Caption;
      downitem.ImageIndex:=18;
      downitem.SubItems.Add(frnewdown.Edit3.Text);//Nombre de archivo
      downitem.SubItems.Add('');//Tama;o
      downitem.SubItems.Add('');//Descargado
      downitem.SubItems.Add(frnewdown.Edit1.Text);//URL
      downitem.SubItems.Add('');//Velocidad
      downitem.SubItems.Add('');//Porciento
      downitem.SubItems.Add('');//Estimado
      downitem.SubItems.Add(datetostr(Date())+' '+timetostr(Time()));//Fecha
      downitem.SubItems.Add(frnewdown.DirectoryEdit1.Text);//Destino
      downitem.SubItems.Add(frnewdown.ComboBox1.Text);//Motor
      downitem.SubItems.Add(frnewdown.Edit2.Text);//Parametros
      downitem.SubItems.Add('0');//status
      downitem.SubItems.Add(inttostr(frmain.lvMain.Items.Count));//id
      downitem.SubItems.Add(frnewdown.Edit4.Text);//user
      downitem.SubItems.Add(frnewdown.Edit5.Text);//pass
      downitem.SubItems.Add(inttostr(triesrotate));//tries
      downitem.SubItems.Add(uidgen());//uid
      if silent then
        downitem.SubItems.Add('0')
      else
        downitem.SubItems.Add(inttostr(frnewdown.ComboBox2.ItemIndex));//queue
      downitem.SubItems.Add('0');//type
      downitem.SubItems.Add(fcookie);//cookie
      downitem.SubItems.Add(referer);//referer
      downitem.SubItems.Add(post);//post
      downitem.SubItems.Add(header);//header
      downitem.SubItems.Add(useragent);//useragent
      frmain.lvMain.Items.AddItem(downitem);
      tmpindex:=downitem.Index;
      if cola then
      begin
        queuemanual[strtoint(frmain.lvMain.Items[tmpindex].SubItems[columnqueue])]:=true;
        qtimer[strtoint(frmain.lvMain.Items[tmpindex].SubItems[columnqueue])].Enabled:=true;
      end;
      frmain.tvMainSelectionChanged(nil);
      if not silent then
        savemydownloads();
      if iniciar or silent then
      begin
        queuemanual[strtoint(frmain.lvMain.Items[tmpindex].SubItems[columnqueue])]:=true;
        downloadstart(tmpindex,false);
        if frmain.AutoSaveTimer.Enabled=false then
          frmain.AutoSaveTimer.Enabled:=true;
      end;
    end;
  end
  else
  begin
    frmain.MainTrayIconDblClick(nil);
    //frmain.Show;
   end;
end;

procedure downtrayicon.showinmain(Sender:TObject);
begin
  frmain.Show;
  frmain.tvMain.Items[0].Selected:=true;
  frmain.lvMain.MultiSelect:=false;
  frmain.lvMain.Items[self.downindex].Selected:=true;
  frmain.lvMain.MultiSelect:=true;
end;

procedure downtrayicon.contextmenu(Sender:TObject;Boton:TMouseButton;SShift:TShiftState;x:LongInt;y:LongInt);
begin
  numtraydown:=self.downindex;
  if self.downindex<frmain.lvMain.Items.Count then
  begin
    if frmain.lvMain.Items[self.downindex].SubItems[columnstatus]='1' then
    begin
      frmain.mitraydownStart.Enabled:=false;
      frmain.mitraydownStop.Enabled:=true;
    end
    else
    begin
      frmain.mitraydownStart.Enabled:=true;
      frmain.mitraydownStop.Enabled:=false;
    end;
  end
  else
  begin
    self.Hide;
    frmain.pmTrayDown.Close;
  end;
end;

procedure setfirefoxintegration();
var
  firefoxprofpath:string='';
  firefoxusrpath:string='';
  flashgotpath:string='';
  i:integer=0;
  itemfolder:TSearchRec;
  extensionini:TIniFile;
  firefoxpref:TStringList;
  {$IFDEF WINDOWS}registro:TRegistry;{$ENDIF}
  okextini:boolean=false;
begin
  try
    flashgotpath:=ExtractFilePath(Application.Params[0])+'{19503e42-ca3c-4c27-b1e2-9cdb2170ee34}.xpi';
    {$IFDEF UNIX}
    firefoxusrpath:=ExtractFilePath(UTF8ToSys(GetUserDir()))+'.mozilla'+pathdelim+'firefox'+pathdelim;
    {$ENDIF}
    {$IFDEF WINDOWS}
    registro:=TRegistry.Create;
    registro.RootKey:=HKEY_CURRENT_USER;
    registro.OpenKey('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\',false);
    firefoxusrpath:=SysToUTF8(registro.ReadString('AppData')+PathDelim+'Mozilla'+PathDelim+'Firefox'+pathdelim+'Profiles')+pathdelim;
    registro.CloseKey;
    registro.Free;
    //ShowMessage(firefoxusrpath);
    {$ENDIF}
    if DirectoryExists(firefoxusrpath) then
    begin
      if FindFirst(firefoxusrpath+'*.default',faAnyFile,itemfolder)=0 then
      begin
        Repeat
          firefoxprofpath:=firefoxusrpath+itemfolder.Name;
          //ShowMessage(firefoxprofpath);
        Until FindNext(itemfolder)<>0;
      end;
    end;
    if DirectoryExists(firefoxprofpath) then
    begin
      if DirectoryExists(firefoxprofpath+pathdelim+'extensions')=false then
        CreateDir(firefoxprofpath+pathdelim+'extensions');
      if (FileExists(flashgotpath)) and (not FileExists(firefoxprofpath+pathdelim+'extensions'+pathdelim+ExtractFileName(flashgotpath))) then
      begin
        CopyFile(flashgotpath,firefoxprofpath+pathdelim+'extensions'+pathdelim+ExtractFileName(flashgotpath));
      end
      else
      //ShowMessage('Flashgot not found!!!');
      if FileExists(firefoxprofpath+pathdelim+'extensions.ini') then
      begin
        extensionini:=TIniFile.Create(firefoxprofpath+pathdelim+'extensions.ini');
        while extensionini.ValueExists('ExtensionDirs','Extension'+inttostr(i)) do
        begin
          if extensionini.ReadString('ExtensionDirs','Extension'+inttostr(i),'')=firefoxprofpath+pathdelim+'extensions'+pathdelim+ExtractFileName(flashgotpath) then
            okextini:=true;
          inc(i);
        end;
        if okextini=false then
        begin
          extensionini.WriteString('ExtensionDirs','Extension'+inttostr(i),firefoxprofpath+pathdelim+'extensions'+pathdelim+ExtractFileName(flashgotpath));
          extensionini.UpdateFile;
        end;
        extensionini.Destroy;
      end;
    end;
    if FileExists(firefoxprofpath+pathdelim+'prefs.js') then
    begin
      firefoxpref:=TStringList.Create;
      firefoxpref.LoadFromFile(firefoxprofpath+pathdelim+'prefs.js');
      if Pos('user_pref("flashgot.custom", "AWGG");',firefoxpref.Text)<1 then
        firefoxpref.Add('user_pref("flashgot.custom", "AWGG");');
      if Pos('user_pref("flashgot.custom.AWGG.args", "[URL] -n [FNAME] -c [CFILE] -r [REFERER] -p [POST]  -h [COOKIE] -u [UA]");',firefoxpref.Text)<1 then
        firefoxpref.Add('user_pref("flashgot.custom.AWGG.args", "[URL] -n [FNAME] -c [CFILE] -r [REFERER] -p [POST]  -h [COOKIE] -u [UA]");');
      if Pos('user_pref("flashgot.custom.AWGG.exe", "'+StringReplace(Application.Params[0],'\','\\',[rfReplaceAll])+'");',firefoxpref.Text)<1 then
        firefoxpref.Add('user_pref("flashgot.custom.AWGG.exe", "'+StringReplace(Application.Params[0],'\','\\',[rfReplaceAll])+'");');
      if Pos('user_pref("flashgot.defaultDM", "AWGG");',firefoxpref.Text)<1 then
        firefoxpref.Add('user_pref("flashgot.defaultDM", "AWGG");');
      if Pos('{19503e42-ca3c-4c27-b1e2-9cdb2170ee34}.xpi\",\"e\":true',firefoxpref.Text)<1 then
        firefoxpref.Add('user_pref("extensions.xpiState", "{\"app-profile\":{\"{19503e42-ca3c-4c27-b1e2-9cdb2170ee34}\":{\"d\":\"'+StringReplace(firefoxprofpath+pathdelim+'extensions'+pathdelim+ExtractFileName(flashgotpath),'\','\\\\',[rfReplaceAll])+'\",\"e\":true,\"v\":\"1.5.6.7\",\"st\":1051365123218}}}");');
      if Pos('user_pref("flashgot.dmchoice", true);',firefoxpref.Text)<1 then
        firefoxpref.Add('user_pref("flashgot.dmchoice", true);');
      if Pos('user_pref("flashgot.dmsopts.AWGG.shownInContextMenu", true);',firefoxpref.Text)<1 then
        firefoxpref.Add('user_pref("flashgot.dmsopts.AWGG.shownInContextMenu", true);');
      if Pos('user_pref("flashgot.media.dm", "AWGG");',firefoxpref.Text)<1 then
        firefoxpref.Add('user_pref("flashgot.media.dm", "AWGG");');
      firefoxpref.SaveToFile(firefoxprofpath+pathdelim+'prefs.js');
      firefoxpref.Clear;
      firefoxpref.Free;
    end;
  except on e:exception do
  end;
end;

end.

