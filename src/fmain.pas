unit fmain;

{
  Main form of AWGG

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
  Classes, SysUtils, FileUtil, LazFileUtils, LazUTF8,
  synhighlighterunixshellscript, SynEdit, UniqueInstance, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ExtCtrls, Menus, Spin, ComCtrls, DateUtils,
  Process, {$IFDEF UNIX}BaseUnix,{$ENDIF}
  {$IFDEF WINDOWS}Registry, MMSystem, Windows,{$ENDIF}fddbox, Math, fnewdown, fconfig, fabout, fstrings, flang, freplace, fsitegrabber, fnotification, fcopymove, fconfirm, fvideoformat, Clipbrd,
  strutils, LCLIntf, types, versionitis, INIFiles, LCLVersion,
  PairSplitter, LCLTranslator, URIParser, fphttpclient, Base64, MD5;

type
  TOnWriteStream = procedure(Sender: TObject; APos: Int64) of object;

type
    TDownloadStream = class(TStream)
  private
    FOnWriteStream: TOnWriteStream;
    FStream: TStream;
  public
    constructor Create(AStream: TStream);
    destructor Destroy; override;
    function Read(var Buffer; Count: LongInt): LongInt; override;
    function Write(const Buffer; Count: LongInt): LongInt; override;
    function Seek(Offset: LongInt; Origin: Word): LongInt; override;
    procedure DoProgress;
  published
    property OnWriteStream: TOnWriteStream read FOnWriteStream write FOnWriteStream;
  end;

type
  TUpdateThread=Class(TThread)
  Private
  DHTTPClient:TFPHTTPClient;
  RS:TStringList;
  internet:boolean;
  URL,DPath:string;
  descargado,descargando:boolean;
  tmpsize:int64;
  FS:TDownloadStream;
  updatecurrentpos:int64;
  updatefsize:int64;
  updatefname:string;
  updatemsgerror:string;
  procedure DoOnWriteStream(Sender: TObject; APos: Int64);
  procedure showrs;
  procedure stop;
  protected
    procedure Execute; override;
  public
    constructor Create;
 end;


type
  TConnectionThread=Class(TThread)
  Private
  DHTTPClient:TFPHTTPClient;
  ifstop,internetchange,nointernetchange:boolean;
  procedure showrs;
  procedure stop;
  protected
    procedure Execute; override;
  public
    constructor Create;
 end;

type
  DownThread = class(TThread)
private
  wout:string;
  wpr:TStringList;
  wthp:TProcess;
  thid:integer;
  thid2:integer;
  tries:integer;
  completado:boolean;
  manualshutdown:boolean;
  logrename:boolean;
  trayiconfontsize:integer;
  youtubedlthexternal:string;
  youtubeuri:string;
  youtubeplaylist:boolean;
  procedure update;
  procedure changestatus;
  procedure prepare;
  procedure prestop;
  procedure shutdown;
protected
  procedure Execute; override;
public
  Constructor Create(CreateSuspended:boolean;tmps:TStringList);
end;

type
  GetThread = class(TThread)
private
  gout:string;
  gpr:TStringList;
  gthp:TProcess;
  completado:boolean;
  manualshutdown:boolean;
  gengine:string;
  downloadid:string;
  ///////Type of get work
  ///////0=Get video formats for youtube-dl
  ///////1=Get video name
  ///////2=Update video names
  ///////3=Check for software updates
  worktype:integer;
  procedure update;
  procedure prepare();
  procedure shutdown();
protected
  procedure Execute; override;
public
  Constructor Create(CreateSuspended:boolean;gparams:TStringList);
end;

{$IFDEF MSWINDOWS}
{$ELSE}
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
{$ENDIF}

type
  copythread=class(TThread)
private
  pform:Tfrcopymove;
  percent:integer;
  canceling:boolean;
  delsrc:boolean;
  total:integer;
  errormsg:string;
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
    ilTrayIcon: TImageList;
    lblMaxDownInProgress: TLabel;
    lvMain: TListView;
    lvFilter: TListView;
    miliMoveBottom: TMenuItem;
    miliMoveTop: TMenuItem;
    miliMoveDown: TMenuItem;
    miliMoveUp: TMenuItem;
    miliPosition: TMenuItem;
    milistClearComplete: TMenuItem;
    mimainCheckUpdate: TMenuItem;
    mimainDonate: TMenuItem;
    mitraydownContinueLater: TMenuItem;
    milistContinueLaterDown: TMenuItem;
    mitraydownCancel: TMenuItem;
    milistCancelDown: TMenuItem;
    miMainInTray: TMenuItem;
    mimainShowInTray: TMenuItem;
    miline27: TMenuItem;
    miTrayAbout: TMenuItem;
    miline26: TMenuItem;
    miDropbox: TMenuItem;
    mimainddbox: TMenuItem;
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
    mimainFile: TMenuItem;
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
    mimainAddGrabber: TMenuItem;
    miAddGrabber: TMenuItem;
    mimainHelp: TMenuItem;
    miline14: TMenuItem;
    mimainHomePage: TMenuItem;
    milistShowTrayIcon: TMenuItem;
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
    tbCancelDown: TToolButton;
    tbContinueLater: TToolButton;
    UpdateInfoTimer: TTimer;
    tvMain: TTreeView;
    UniqueInstance1: TUniqueInstance;
    procedure ApplicationProperties1Exception(Sender: TObject; E: Exception);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure hintTimerTimer(Sender: TObject);
    procedure lvFilterDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lvFilterEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure lvFilterMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lvMainColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvMainContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure lvMainDblClick(Sender: TObject);
    procedure lvMainDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lvMainEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure lvMainKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvMainMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure lvMainSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lvFilterSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure miDropboxClick(Sender: TObject);
    procedure miliMoveBottomClick(Sender: TObject);
    procedure miliMoveDownClick(Sender: TObject);
    procedure miliMoveTopClick(Sender: TObject);
    procedure miliMoveUpClick(Sender: TObject);
    procedure milistCancelDownClick(Sender: TObject);
    procedure milistContinueLaterDownClick(Sender: TObject);
    procedure milistMoveFilesClick(Sender: TObject);
    procedure micommandClearClick(Sender: TObject);
    procedure micommandCopyClick(Sender: TObject);
    procedure micommandSelectAllClick(Sender: TObject);
    procedure mimainCheckUpdateClick(Sender: TObject);
    procedure mimainddboxClick(Sender: TObject);
    procedure mimainDonateClick(Sender: TObject);
    procedure mimainShowInTrayClick(Sender: TObject);
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
    procedure mitraydownCancelClick(Sender: TObject);
    procedure mitraydownContinueLaterClick(Sender: TObject);
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
    procedure tbCancelDownClick(Sender: TObject);
    procedure tbContinueLaterClick(Sender: TObject);
    procedure tbStopQueueClick(Sender: TObject);
    procedure tbStopAllClick(Sender: TObject);
    procedure ToolButton14Click(Sender: TObject);
    procedure tbStartSchedulerClick(Sender: TObject);
    procedure tbStopSchedulerClick(Sender: TObject);
    procedure tbExitClick(Sender: TObject);
    procedure tbSteepUpClick(Sender: TObject);
    procedure tbAddDownClick(Sender: TObject;showdlg:boolean=true);
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
    procedure tvMainDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure tvMainEdited(Sender: TObject; Node: TTreeNode; var S: string);
    procedure tvMainEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure tvMainKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tvMainSelectionChanged(Sender: TObject);
    procedure UniqueInstance1OtherInstance(Sender: TObject;
      ParamCount: Integer; Parameters: array of String);
    procedure UpdateInfoTimerStartTimer(Sender: TObject);
    procedure UpdateInfoTimerStopTimer(Sender: TObject);
    procedure UpdateInfoTimerTimer(Sender: TObject);
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

const
  awgg_path='%AWGG_PATH%'+pathdelim;

var
  frmain: Tfrmain;
  wtp:TProcess;
  onestart:boolean=true;
  hilo:array of DownThread;
  customgetformats:GetThread;
  customgetname:GetThread;
  copywork:array of copythread;
  phttp,phttpport,phttps,phttpsport,pftp,pftpport,nphost,puser,ppassword,cntlmhost,cntlmport:string;
  useproxy:integer;
  useaut:boolean;
  shownotifi,shownotificomplete,shownotifierror,shownotifiinternet,shownotifinointernet:boolean;
  usesysnotifi:boolean;
  hiddenotifi:integer;
  notifipos:integer;
  ddowndir:string='';
  clipboardmonitor:boolean;
  //columnstatus 0=Paused 1=In progress, 2=Stopped, 3=Complete, 4=Error, 5=Canceled
  columnname,columnurl,columnpercent,columnsize,columncurrent,columnspeed,columnestimate, columndate, columndestiny,columnengine,columnparameters,columnuser,columnpass,columnstatus,columnid, columntries, columnuid, columntype, columnqueue, columncookie, columnreferer, columnpost, columnheader, columnuseragent:integer;
  columncolaw,columnnamew,columnurlw,columnpercentw,columnsizew,columncurrentw,columnspeedw,columnestimatew,columndatew,columndestinyw,columnenginew,columnparametersw:integer;
  columncolav,columnnamev,columnurlv,columnpercentv,columnsizev,columncurrentv,columnspeedv,columnestimatev,columndatev,columndestinyv,columnenginev,columnparametersv:boolean;
  limited:boolean;
  speedlimit:string;
  maxgdown,dtries,dtimeout,ddelay:integer;
  showstdout:boolean;
  wgetrutebin,aria2crutebin,curlrutebin,axelrutebin,youtubedlrutebin:UTF8string;
  wgetargs,aria2cargs,curlargs,axelargs,youtubedlargs,youtubedlextdown:string;
  wgetdefcontinue,wgetdefnh,wgetdefnd,wgetdefncert:boolean;
  aria2cdefcontinue,aria2cdefallocate:boolean;
  youtubedluseextdown:boolean;
  aria2splitsize:string;
  aria2splitnum:integer;
  aria2split:boolean;
  youtubedldefcontinue,curldefcontinue:boolean;
  autostartwithsystem, autostartminimized:boolean;
  configpath,datapath:string;
  logger:boolean;
  logpath:string;
  showgridlines,showcommandout,showtreeviewpanel:boolean;
  splitpos,splithpos:integer;
  lastmainwindowstate:TWindowstate;
  firsttime:boolean;
  {$IFDEF MSWINDOWS}
  {$ELSE}
  hilosnd:soundthread;
  {$ENDIF}
  deflanguage:string;
  firststart:boolean;
  defaultengine:string;
  playsounds,playsoundcomplete,playsounderror,playsoundinternet,playsoundnointernet:boolean;
  downcompsound,downstopsound,internetsound,nointernetsound:string;
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
  queuestarttimes:array of System.TTime;
  queuestoptimes:array of System.TTime;
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
  queuestarttimestmp:array of System.TTime;
  queuestoptimestmp:array of System.TTime;
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
  firstnormalshow:boolean;
  dropboxonstart,silentdropbox:boolean;
  showmainintray:boolean;
  StartDragIndex:integer=-1;
  frddboxLeft,frddboxTop,frddboxSize:integer;
  domainfilters:array of string;
  activedomainfilter:boolean;
  params:array of string;
  paramscount:longint;
  queueindex:integer;
  internetchecker:TConnectionThread;
  internet:boolean;
  internetcheck:boolean;
  interneturl:string;
  internetinterval:integer;
  queuemainstop:boolean=false;
  newdownloadforcenames:boolean;
  currentdir:string;
  autoupdate,autoupdatearia2,autoupdateaxel,autoupdatecurl,autoupdateyoutubedl,autoupdatewget:boolean;
  Updater,UpdaterMain,UpdaterAria2,UpdaterAxel,UpdaterCurl,UpdaterYoutubedl,UpdaterWget:TUpdateThread;
  updateinprogress:boolean;
  aria2md5,axelmd5,curlmd5,youtubedlmd5,wgetmd5,mainmd5:string;
  function urlexists(url:string):boolean;
  function destinyexists(destiny:string;newurl:string=''):boolean;
  function suggestdir(doc:string):string;
  function uidgen():string;
  procedure playsound(soundfile:string);
  procedure newqueue();
  procedure setconfig();
  procedure enginereload();
  procedure configdlg();
  procedure poweroff;
  procedure savemydownloads;
  procedure saveconfig;
  procedure stopqueue(indice:integer);
  procedure setfirefoxintegration();
  procedure createnewnotifi(title:string;name:string;note:string;fpath:string;ok:boolean;uid:string;simulation:integer=-1);
  procedure categoryreload();
  procedure downloadstart(indice:integer;restart:boolean);
  procedure queueindexselect();
  procedure suggestparameters();
  procedure getyoutubeformats(URL:String);
  procedure getyoutubename(URL:String);
  procedure reloaddowndirs();
  procedure parseparameters;
  procedure runprocess(binary:string;params:array of string);
  function EncodeBase64(Data: AnsiString): AnsiString;
  function DecodeBase64(Data: AnsiString): AnsiString;
  procedure checkforupdates;
implementation
{$R *.lfm}
{ Tfrmain }

//********************************************************
function CopyFileAttributes(const sourcefile,destinationfile:string):boolean;
var
  fileinfo:{$ifdef unix}
             stat;
           {$endif}
           {$ifdef windows}
             longint;
           {$endif}
begin
  if (fileexists(sourcefile) and fileexists(destinationfile)) then
  begin
    {$ifdef unix}
    exit((fpstat(sourcefile,fileinfo)=0)and(fpchmod(destinationfile,fileinfo.st_mode)=0));
    {$endif}
    {$ifdef windows}
    fileinfo:=filegetattr(sourcefile);
    {$ENDIF}
  end;
  result:=false;
end;

//********************************************************

procedure checkforupdates;
begin
  frconfig.btnUpdateCheckNow.Enabled:=false;
  frmain.mimainCheckUpdate.Enabled:=false;
  Updater:=TUpdateThread.Create;
  {$IFDEF cpui386}
    {$IFDEF MSWINDOWS}
      Updater.URL:='https://raw.githubusercontent.com/Nenirey/AWGG-UPDATES/master/Windows/32bits/update.ini';
    {$ENDIF}
    {$IF DEFINED(FREEBSD)}
       Updater.URL:='https://raw.githubusercontent.com/Nenirey/AWGG-UPDATES/master/FreeBSD/32bits/update.ini';
    {$ENDIF}
    {$IFDEF LINUX}
       Updater.URL:='https://raw.githubusercontent.com/Nenirey/AWGG-UPDATES/master/Linux/32bits/update.ini';
    {$ENDIF}
  {$ENDIF}
  {$IFDEF cpux86_64}
    {$IFDEF MSWINDOWS}
      Updater.URL:='https://raw.githubusercontent.com/Nenirey/AWGG-UPDATES/master/Windows/64bits/update.ini';
    {$ENDIF}
    {$IF DEFINED(FREEBSD)}
      Updater.URL:='https://raw.githubusercontent.com/Nenirey/AWGG-UPDATES/master/FreeBSD/64bits/update.ini';
    {$ENDIF}
    {$IFDEF LINUX}
      Updater.URL:='https://raw.githubusercontent.com/Nenirey/AWGG-UPDATES/master/Linux/64bits/update.ini';
    {$ENDIF}
  {$ENDIF}
  Updater.updatefname:='update.ini';
  Updater.DPath:=configpath;
  Updater.Start;
  frconfig.lblUpdateInfo.Caption:=fstrings.msgupdatechecking;
  frconfig.pbUpdate.Style:=pbstMarquee;
  frmain.UpdateInfoTimer.Enabled:=true;
end;

/////////////////////////******Internal updater implementation**************//////////////////////
constructor TDownloadStream.Create(AStream: TStream);
begin
  inherited Create;
  FStream := AStream;
  FStream.Position := 0;
end;

destructor TDownloadStream.Destroy;
begin
  FStream.Free;
  inherited Destroy;
end;

function TDownloadStream.Read(var Buffer; Count: LongInt): LongInt;
begin
  Result := FStream.Read(Buffer, Count);
end;

function TDownloadStream.Write(const Buffer; Count: LongInt): LongInt;
begin
  Result := FStream.Write(Buffer, Count);
  DoProgress;
end;

function TDownloadStream.Seek(Offset: LongInt; Origin: Word): LongInt;
begin
  Result := FStream.Seek(Offset, Origin);
end;

procedure TDownloadStream.DoProgress;
begin
  if Assigned(FOnWriteStream) then
    FOnWriteStream(Self, Self.Position);
end;

constructor TUpdateThread.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
  DHTTPClient := TFPHTTPClient.Create(nil);
  RS:=TStringList.Create;
  internet:=false;
  descargado:=false;
end;

procedure TUpdateThread.stop;
begin
  if Assigned(DHTTPClient) then
  begin
    DHTTPClient.Terminate;
    while DHTTPClient.Terminated=false do
    begin
      sleep(10);
    end;
  end;
end;

procedure TUpdateThread.DoOnWriteStream(Sender:TObject;APos:Int64);
begin
  updatecurrentpos:=APos;
  if updateFSize=0 then
  begin
    if DHTTPClient.ResponseHeaders.Values['Content-Length']<>'' then
        updateFSize:=strtoint(DHTTPClient.ResponseHeaders.Values['Content-Length'])+tmpsize;
  end;
  if updatefname='' then
  begin
    if (DHTTPClient.ResponseHeaders.Values['Content-Disposition']<>'') and (Pos('filename=',DHTTPClient.ResponseHeaders.Values['Content-Disposition'])>0) then
      updatefname:=Copy(DHTTPClient.ResponseHeaders.Values['Content-Disposition'],Pos('filename=',DHTTPClient.ResponseHeaders.Values['Content-Disposition'])+9,Length(DHTTPClient.ResponseHeaders.Values['Content-Disposition']))
    else
      updatefname:='unamefile';
    updatefname:=StringReplace(updatefname,'"','',[rfReplaceAll]);
    updatefname:=StringReplace(updatefname,';','',[rfReplaceAll]);
  end;
  if (updatecurrentpos=updateFSize) and (DHTTPClient.ResponseHeaders.Values['Server']<>' NetEngine Server 1.0') then
    descargado:=true;
end;

procedure TUpdateThread.showrs;
var
  newsini:TINIFile;
  aria2new,axelnew,curlnew,youtubedlnew,wgetnew:string;
begin
  frmain.UpdateInfoTimer.Enabled:=false;
  frconfig.btnUpdateCheckNow.Enabled:=true;
  frmain.mimainCheckUpdate.Enabled:=true;
  if descargado then
  begin
    try
      if FileExistsUTF8(dpath+updatefname) then
      begin
        DeleteFileUTF8(dpath+updatefname);
      end;
      RenameFileUTF8(dpath+updatefname+'.part',dpath+updatefname);
    except on e:exception do
    end;
    case LowerCase(updatefname) of
      'update.ini':
      begin
        newsini:=TINIFile.Create(dpath+updatefname);
        aria2new:=newsini.ReadString('Update','aria2new','');
        aria2md5:=newsini.ReadString('Update','aria2md5','');
        axelnew:=newsini.ReadString('Update','axelnew','');
        axelmd5:=newsini.ReadString('Update','axelmd5','');
        curlnew:=newsini.ReadString('Update','curlnew','');
        curlmd5:=newsini.ReadString('Update','curlmd5','');
        youtubedlnew:=newsini.ReadString('Update','youtubedlnew','');
        youtubedlmd5:=newsini.ReadString('Update','youtubedlmd5','');
        wgetnew:=newsini.ReadString('Update','wgetnew','');
        wgetmd5:=newsini.ReadString('Update','wgetmd5','');

        frconfig.btnUpdateCheckNow.Enabled:=false;
        frmain.mimainCheckUpdate.Enabled:=false;

        if (aria2new<>'') and (aria2md5<>'') and (aria2md5<>MD5Print(MD5File(aria2crutebin))) and autoupdatearia2 then
        begin
          frmain.UpdateInfoTimer.Enabled:=true;
          UpdaterAria2:=TUpdateThread.Create;
          UpdaterAria2.URL:=aria2new;
          UpdaterAria2.updatefname:='aria2c'{$IFDEF MSWINDOWS}+'.exe'{$ENDIF};
          UpdaterAria2.DPath:=configpath+'Engines'+pathdelim;
          UpdaterAria2.Start;
        end;

        if (axelnew<>'') and (axelmd5<>'') and (axelmd5<>MD5Print(MD5File(axelrutebin))) and autoupdateaxel then
        begin
          frmain.UpdateInfoTimer.Enabled:=true;
          UpdaterAxel:=TUpdateThread.Create;
          UpdaterAxel.URL:=axelnew;
          UpdaterAxel.updatefname:='axel'{$IFDEF MSWINDOWS}+'.exe'{$ENDIF};
          UpdaterAxel.DPath:=configpath+'Engines'+pathdelim;
          UpdaterAxel.Start;
        end;

        if (curlnew<>'') and (curlmd5<>'') and (curlmd5<>MD5Print(MD5File(curlrutebin))) and autoupdatecurl then
        begin
          frmain.UpdateInfoTimer.Enabled:=true;
          UpdaterCurl:=TUpdateThread.Create;
          UpdaterCurl.URL:=curlnew;
          UpdaterCurl.updatefname:='curl'{$IFDEF MSWINDOWS}+'.exe'{$ENDIF};
          UpdaterCurl.DPath:=configpath+'Engines'+pathdelim;
          UpdaterCurl.Start;
        end;

        if (youtubedlnew<>'') and (youtubedlmd5<>'') and (youtubedlmd5<>MD5Print(MD5File(youtubedlrutebin))) and autoupdateyoutubedl then
        begin
          frmain.UpdateInfoTimer.Enabled:=true;
          UpdaterYoutubedl:=TUpdateThread.Create;
          UpdaterYoutubedl.URL:=youtubedlnew;
          UpdaterYoutubedl.updatefname:='youtube-dl'{$IFDEF MSWINDOWS}+'.exe'{$ENDIF};
          UpdaterYoutubedl.DPath:=configpath+'Engines'+pathdelim;
          UpdaterYoutubedl.Start;
        end;

        if (wgetnew<>'') and (wgetmd5<>'') and (wgetmd5<>MD5Print(MD5File(wgetrutebin))) and autoupdatewget then
        begin
          frmain.UpdateInfoTimer.Enabled:=true;
          UpdaterWget:=TUpdateThread.Create;
          UpdaterWget.URL:=wgetnew;
          UpdaterWget.updatefname:='wget'{$IFDEF MSWINDOWS}+'.exe'{$ENDIF};
          UpdaterWget.DPath:=configpath+'Engines'+pathdelim;
          UpdaterWget.Start;
        end;
      end;

      'aria2c','aria2c.exe':
      begin
        if MD5Print(MD5File(dpath+updatefname))=aria2md5 then
        begin
          {$IFDEF UNIX}
          CopyFileAttributes(Application.Params[0],dpath+updatefname);
          {$ENDIF}
          aria2crutebin:=dpath+updatefname;
          frconfig.fneAria2Path.Text:=dpath+updatefname;
          saveconfig;
        end;
      end;

      'axel','axel.exe':
      begin
        if MD5Print(MD5File(dpath+updatefname))=axelmd5 then
        begin
          {$IFDEF UNIX}
          CopyFileAttributes(Application.Params[0],dpath+updatefname);
          {$ENDIF}
          axelrutebin:=dpath+updatefname;
          frconfig.fneAxelPath.Text:=dpath+updatefname;
          saveconfig;
        end;
      end;
      'curl','curl.exe':
      begin
        if MD5Print(MD5File(dpath+updatefname))=curlmd5 then
        begin
          {$IFDEF UNIX}
          CopyFileAttributes(Application.Params[0],dpath+updatefname);
          {$ENDIF}
          curlrutebin:=dpath+updatefname;
          frconfig.fneCurlPath.Text:=dpath+updatefname;
          saveconfig;
        end;
      end;
      'youtube-dl','youtube-dl.exe':
      begin
        if MD5Print(MD5File(dpath+updatefname))=youtubedlmd5 then
        begin
          {$IFDEF UNIX}
          CopyFileAttributes(Application.Params[0],dpath+updatefname);
          {$ENDIF}
          youtubedlrutebin:=dpath+updatefname;
          frconfig.fneYoutubedlPath.Text:=dpath+updatefname;
          saveconfig;
        end;
      end;
      'wget','wget.exe':
      begin
        if MD5Print(MD5File(dpath+updatefname))=wgetmd5 then
        begin
          {$IFDEF UNIX}
          CopyFileAttributes(Application.Params[0],dpath+updatefname);
          {$ENDIF}
          wgetrutebin:=dpath+updatefname;
          frconfig.fneWgetPath.Text:=dpath+updatefname;
          saveconfig;
        end;
      end;
    end;
    if updateinprogress=false then
    begin
      frconfig.lblUpdateInfo.Caption:=fstrings.msguptodate;
      frconfig.pbUpdate.Style:=pbstNormal;
      frconfig.pbUpdate.Position:=0;
      frconfig.btnUpdateCheckNow.Enabled:=true;
      frmain.mimainCheckUpdate.Enabled:=true;
    end
    else
    begin
      frconfig.btnUpdateCheckNow.Enabled:=false;
      frmain.mimainCheckUpdate.Enabled:=false;
    end;
  end
  else
  begin
    frconfig.lblUpdateInfo.Caption:=updatemsgerror;
    frconfig.pbUpdate.Style:=pbstNormal;
    frconfig.pbUpdate.Position:=0;
    updateinprogress:=false;
  end;
end;

procedure TUpdateThread.Execute;
begin
  descargado:=false;
  descargando:=false;
  try
    while(updateinprogress)do
      sleep(1000);
    updateinprogress:=true;
    case useproxy of
    0,1:begin
          //DHTTPClient.Proxy.Host:= '';
          //DHTTPClient.Proxy.UserName:= '';
          //DHTTPClient.Proxy.Password:= '';
        end;
    2:begin
        DHTTPClient.Proxy.Host:= phttp;
        DHTTPClient.Proxy.Port:= strtoint(phttpport);
        if useaut then
        begin
          DHTTPClient.Proxy.UserName:= puser;
          DHTTPClient.Proxy.Password:= ppassword;
        end;
      end;
    end;
    DHTTPClient.AllowRedirect:=true;
    DHTTPClient.IOTimeout:=5000;
    DHTTPClient.AddHeader('Connection','Keep-Alive');
    if DirectoryExistsUTF8(dpath)=false then
      CreateDirUTF8(dpath);
    if FileExistsUTF8(dpath+updatefname+'.part') then
    begin
      tmpsize:=LazFileUtils.FileSizeUtf8(dpath+updatefname+'.part');
      DHTTPClient.AddHeader('Range','bytes='+floattostr(tmpsize)+'-');
      FS := TDownloadStream.Create(TFileStream.Create(dpath+updatefname+'.part', fmOpenReadWrite));
    end
    else
    begin
      tmpsize:=0;
      FS := TDownloadStream.Create(TFileStream.Create(dpath+updatefname+'.part', fmCreate));
    end;
    updatecurrentpos:=tmpsize;
    FS.FOnWriteStream := @DoOnWriteStream;
    FS.Position:=tmpsize;
    descargando:=true;
    DHTTPClient.HTTPMethod('GET', URL, FS, []);
    //After this point not execution no continue before complete the method
    FS.Free;
    RS.AddStrings(DHTTPClient.ResponseHeaders);
    updateinprogress:=false;
    descargando:=false;
    Synchronize(@showrs);
    self.Terminate;
    except on e:exception do
    begin
      updatemsgerror:=e.Message;
      descargado:=false;
      descargando:=false;
      Synchronize(@showrs);
      FS.Free;
      self.Terminate;
    end;
  end;
end;

////////////////////////************************E N D*************************//////////////////////

procedure writestatus(downid:integer);
var
  statusfile:TextFile;
begin
 try
   AssignFile(statusfile,datapath+PathDelim+frmain.lvMain.Items[downid].SubItems[columnuid]+'.status');
   if fileExists(configpath+PathDelim+frmain.lvMain.Items[downid].SubItems[columnuid]+'.status')=false then
     ReWrite(statusfile);
   Write(statusfile,frmain.lvMain.Items[downid].SubItems[columnstatus]+'/'+frmain.lvMain.Items[downid].SubItems[columncurrent]+'/'+frmain.lvMain.Items[downid].SubItems[columnpercent]+'/'+frmain.lvMain.Items[downid].SubItems[columnestimate]);
   CloseFile(statusfile);
 except on e:exception do
   CloseFile(statusfile);
 end;
end;

procedure hiddetrayicon(downtag:integer);
var
  n:integer;
begin
  if Assigned(trayicons) then
  begin
    for n:=0 to Length(trayicons)-1 do
    begin
       if Assigned(trayicons[n]) then
       begin
         if trayicons[n].downindex=downtag then
         begin
           trayicons[n].Icon.Clear;
           trayicons[n].Visible:=false;
         end;
       end;
    end;
  end;
end;

function EncodeBase64(Data: AnsiString): AnsiString;
var
  StringStream1,
  StringStream2: TStringStream;
begin
  Result:= EmptyStr;
  if Data = EmptyStr then Exit;
  StringStream1:= TStringStream.Create(Data);
  try
    StringStream1.Position:= 0;
    StringStream2:= TStringStream.Create(EmptyStr);
    try
      with TBase64EncodingStream.Create(StringStream2) do
        try
          CopyFrom(StringStream1, StringStream1.Size);
        finally
          Free;
        end;
      Result:= StringStream2.DataString;
    finally
      StringStream2.Free;
    end;
 finally
   StringStream1.Free;
 end;
end;

function DecodeBase64(Data: AnsiString): AnsiString;
var
  StringStream1,
  StringStream2: TStringStream;
  Base64DecodingStream: TBase64DecodingStream;
begin
  Result:= EmptyStr;
  if Data = EmptyStr then Exit;
  StringStream1:= TStringStream.Create(Data);
  try
    StringStream1.Position:= 0;
    StringStream2:= TStringStream.Create(EmptyStr);
    try
      Base64DecodingStream:= TBase64DecodingStream.Create(StringStream1);
      with StringStream2 do
        try
          CopyFrom(Base64DecodingStream, Base64DecodingStream.Size);
        finally
          Base64DecodingStream.Free;
        end;
      Result:= StringStream2.DataString;
    finally
      StringStream2.Free;
    end;
 finally
   StringStream1.Free;
 end;
end;

constructor TConnectionThread.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
  DHTTPClient := TFPHTTPClient.Create(nil);
  internetchange:=true;
  nointernetchange:=true;
  internet:=false;
  ifstop:=true;
end;

procedure TConnectionThread.showrs;
begin
  try
    if internet then
    begin
      if Assigned(qtimer[0]) then
      begin
        if (queuemainstop=false) then
        begin
          queuemanual[0]:=true;
          qtimer[0].Interval:=1000;
          qtimer[0].Enabled:=true;;
        end;
        if shownotifi and shownotifiinternet and internetchange then
          createnewnotifi('AWGG','',msginternetconnection+lineending+DHTTPClient.ResponseHeaders.Values['Server'],'',true,'');
        if playsounds and playsoundinternet and internetchange then
          playsound(internetsound);
        frmain.MainTrayIcon.Animate:=false;
        frmain.MainTrayIcon.Icon:=Application.Icon;
        internetchange:=false;
        nointernetchange:=true;
      end;
    end
    else
    begin
      if shownotifi and shownotifinointernet and nointernetchange then
          createnewnotifi('AWGG','',msgnointernetconnection+lineending+DHTTPClient.ResponseHeaders.Values['Server'],'',false,'');
      if playsounds and playsoundnointernet and nointernetchange then
        playsound(nointernetsound);
      frmain.MainTrayIcon.Icons:=frmain.ilTrayIcon;
      frmain.MainTrayIcon.Animate:=true;
      nointernetchange:=false;
      internetchange:=true;
    end;
  except on e:exception do
  end;
end;

procedure TConnectionThread.stop;
begin
  DHTTPClient.Terminate;
  ifstop:=false;
  DHTTPClient.Destroy;
end;

procedure TConnectionThread.Execute;
var
  firsttime:boolean;
  ctryn:integer;
begin
 firsttime:=true;
  try
    while ifstop do
    begin
      if firsttime=false then
        sleep(internetInterval*1000);
      try
        internet:=false;
        firsttime:=false;
        ctryn:=5;
        case useproxy of
        0,1:begin
              //DHTTPClient.Proxy.Host:= '';
              //DHTTPClient.Proxy.UserName:= '';
              //DHTTPClient.Proxy.Password:= '';
            end;
        2:begin
            DHTTPClient.Proxy.Host:= phttp;
            DHTTPClient.Proxy.Port:= strtoint(phttpport);
            if useaut then
            begin
              DHTTPClient.Proxy.UserName:= puser;
              DHTTPClient.Proxy.Password:= ppassword;
            end;
          end;
        end;
        DHTTPClient.KeepConnection:=false;
        DHTTPClient.IOTimeout:=5000;
        DHTTPClient.HTTPMethod('HEAD',InternetURL,nil,[200]);
        //One connection can lost but 5 not
        while (DHTTPClient.ResponseHeaders.Count=0) and (ctryn>0) do
        begin
          dec(ctryn);
          DHTTPClient.HTTPMethod('HEAD',InternetURL,nil,[200]);
          Sleep(500);
        end;
        if (DHTTPClient.ResponseHeaders.Count>0) and (DHTTPClient.ResponseHeaders.Values['Server']<>' NetEngine Server 1.0') then
          internet:=true
        else
          internet:=false;
        Synchronize(@showrs);
        DHTTPClient.Terminate;
      except on e:exception do
        begin
          internet:=false;
          Synchronize(@showrs);
        end;
      end;
    end;
    self.Terminate;
  except on e:exception do
  end;
end;

procedure runprocess(binary:string;params:array of string);
var
  proc:TProcess;
begin
  proc:=TProcess.Create(nil);
  proc.Executable:=binary;
  proc.Parameters.AddStrings(params);
  proc.Execute;
end;

procedure reloaddowndirs();
var
  i:integer;
begin
  frnewdown.cbDestination.Items.Clear;
  frnewdown.cbDestination.Items.Add(UTF8ToSys(ddowndir));
  for i:=0 to Length(categoryextencions)-1 do
  begin
    frnewdown.cbDestination.Items.Add(categoryextencions[i][0]);
  end;
  frnewdown.cbDestination.Items.Add(UTF8ToSys(dotherdowndir));
end;

procedure wgetparameters(var tmps:TStringList;indice:integer;restart:boolean=false);
var
  uandp:string;
  wrn:integer;
  thnum:integer;
  downid:integer;
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
  if (WordCount(frmain.lvMain.Items[indice].SubItems[columnparameters],[' '])>0) and (frmain.lvMain.Items[indice].SubItems[columnengine]='wget') then
  begin
    for wrn:=1 to WordCount(frmain.lvMain.Items[indice].SubItems[columnparameters],[' ']) do
      tmps.Add(ExtractWord(wrn,frmain.lvMain.Items[indice].SubItems[columnparameters],[' ']));
  end;
  tmps.Add('-S');//Mouestra la respuesta del servidor
  tmps.Add('-e');
  tmps.Add('recursive=off');//Descativar para la opcion -O
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
  if frmain.lvMain.Items[indice].SubItems[columnname]<>'' then
  begin
    tmps.Add('-P');//Destino de la descarga
    tmps.Add(ExtractShortPathName(UTF8ToSys(frmain.lvMain.Items[indice].SubItems[columndestiny])));
  end;
  tmps.Add('-t');
  tmps.Add(inttostr(dtries));
  tmps.Add('-T');
  tmps.Add(inttostr(dtimeout));
  //Use this because -w wait to at the beginning and --waitretry only on retry
  tmps.Add('--waitretry');
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
end;

procedure aria2parameters(var tmps:TStringList;indice:integer;restart:boolean=false);
var
  uandp:string;
  wrn:integer;
  thnum:integer;
  downid:integer;
begin
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
  if (WordCount(frmain.lvMain.Items[indice].SubItems[columnparameters],[' '])>0) and (frmain.lvMain.Items[indice].SubItems[columnengine]='aria2c') then
  begin
    for wrn:=1 to WordCount(frmain.lvMain.Items[indice].SubItems[columnparameters],[' ']) do
      tmps.Add(ExtractWord(wrn,frmain.lvMain.Items[indice].SubItems[columnparameters],[' ']));
  end;
  tmps.Add('--check-certificate=false');//Ignorar certificados
  tmps.Add('--summary-interval=1');//intervalo del sumario de descargas
  tmps.Add('--auto-file-renaming=false');
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
    if sameproxyforall or (youtubedluseextdown and (frmain.lvMain.Items[indice].SubItems[columnengine]='youtube-dl')) then
    begin
      tmps.Add('--all-proxy');
      if useaut then
       tmps.Add('http://'+puser+':'+ppassword+'@'+phttp+':'+phttpport)
      else
        tmps.Add('http://'+phttp+':'+phttpport);
    end
    else
    begin
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
  end;
  tmps.Add('-d');
  tmps.Add(ExtractShortPathName(ExpandFileName(UTF8ToSys(frmain.lvMain.Items[indice].SubItems[columndestiny]))));
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
end;

procedure curlparameters(var tmps:TStringList;indice:integer;restart:boolean=false);
var
  wrn:integer;
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
  if (WordCount(frmain.lvMain.Items[indice].SubItems[columnparameters],[' '])>0) and (frmain.lvMain.Items[indice].SubItems[columnengine]='curl') then
  begin
    for wrn:=1 to WordCount(frmain.lvMain.Items[indice].SubItems[columnparameters],[' ']) do
      tmps.Add(ExtractWord(wrn,frmain.lvMain.Items[indice].SubItems[columnparameters],[' ']));
  end;
  tmps.Add('-k');//Ignorar certificados
  tmps.Add('-v');//Mas infomracion (optener el nombre de archivo)
  if frmain.lvMain.Items[indice].SubItems[columnname]<>'' then
  begin
    tmps.Add('-i');//Mostrar respuesta del servidor
    tmps.Add('-o');
    tmps.Add(UTF8ToSys(frmain.lvMain.Items[indice].SubItems[columnname]));
  end
  else
    tmps.Add('-J');//La salida es el nombre real del fichero
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
end;

procedure axelparameters(var tmps:TStringList;indice:integer;restart:boolean=false);
var
  wrn:integer;
begin
  ////Parametros generales
  if WordCount(axelargs,[' '])>0 then
  begin
    for wrn:=1 to WordCount(axelargs,[' ']) do
      tmps.Add(ExtractWord(wrn,axelargs,[' ']));
  end;
  ////Parametros para cada descarga
  if (WordCount(frmain.lvMain.Items[indice].SubItems[columnparameters],[' '])>0) and (frmain.lvMain.Items[indice].SubItems[columnengine]='axel') then
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
end;

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
    pform.Caption:=fstrings.fileoperationmove
  else
    pform.Caption:=fileoperationcopy;
  pform.Show;
end;

procedure copythread.Execute;
var
  FromF, ToF : TFileStream;
  Buffer: array[0..$10000 -1] of byte;
  NumRead,i: Integer;
  FromSize:Int64;
  TotalSize:Int64=0;
  CurrentTotal:Int64;
begin
  for i:=0 to source.Count-1 do
  begin
    findex:=i;
    FromF := TFileStream.Create(UTF8ToSys(Source[i]), fmOpenRead or fmShareDenyNone);
    TotalSize+=FromF.Size;
    FromF.Free;
  end;
  CurrentTotal:=0;
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
          FromSize:=FromF.Size;
          //ToF.Size:=FromSize;//Tomar espacio a ocupar
          ToF.Position := 0;
          FromF.Position := 0;
          NumRead := FromF.Read(Buffer[0], $10000);
          while (NumRead > 0) and (self.canceling=false) do begin
            ToF.Write(Buffer[0], NumRead);
            NumRead := FromF.Read(Buffer[0], $10000);
            //percent:=Round((ToF.Size/FromF.Size) * 100);
            CurrentTotal+=NumRead;
            percent:=Round((ToF.Position/FromSize) * 100);
            total:=Round((CurrentTotal/TotalSize) * 100);
            if percent<> pform.pbCopyMove.Position then
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
      errormsg:=e.Message;
      synchronize(@prepare);
      canceling:=true;
    end;
    end;
    try
      if delsrc and (canceling=false) and FileExists(UTF8ToSys(Source[i])) then
        SysUtils.DeleteFile(UTF8ToSys(Source[i]));
    except on e:exception do
    end;
  end;
  source.Free;
  synchronize(@prepare);
end;

procedure copythread.update;
begin
  pform.pbCopyMove.Position:=percent;
  pform.pbTotal.Position:=total;
  if delsrc then
    pform.Caption:=inttostr(total)+'% '+inttostr(findex+1)+'/'+inttostr(source.Count)+' '+fileoperationmove
  else
    pform.Caption:=inttostr(total)+'% '+inttostr(findex+1)+'/'+inttostr(source.Count)+' '+fileoperationcopy;
  pform.lblFrom.Caption:=strshort(format(transfromlabel,[source[findex]]),85);
  pform.lblTo.Caption:=strshort(format(transdestinationlabel,[destination+pathdelim+ExtractFilename(Source[findex])]),85);
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
   begin
     if delsrc then
       MessageDlg(Application.Title,Format(msgmoveoperationerror,[errormsg]), mtError, [mbOK], 0)
     else
       MessageDlg(Application.Title,Format(msgcopyoperationerror,[errormsg]), mtError, [mbOK], 0);
   end;
   pform.Hide;
 end;
 self.Terminate;
end;

procedure copythread.stop;
begin
 canceling:=true;
end;

procedure createnewnotifi(title:string;name:string;note:string;fpath:string;ok:boolean;uid:string;simulation:integer=-1);
var
  ABitmap:Graphics.TBitmap;
  posicion:integer;
begin
  if usesysnotifi then
  begin
    frmain.MainTrayIcon.BalloonHint:=title+lineending+name+lineending+note;
    {$IFDEF MSWINDOWS}
    {$ELSE}
    frmain.MainTrayIcon.BalloonTitle:='AWGG';
    {$ENDIF}
    frmain.MainTrayIcon.BalloonTimeout:=hiddenotifi*1000;
    if ok then
      frmain.MainTrayIcon.BalloonFlags:=bfInfo
    else
      frmain.MainTrayIcon.BalloonFlags:=bfError;
    frmain.MainTrayIcon.ShowBalloonHint;
  end
  else
  begin
    notiforms:=Tfrnotification.Create(frmain);
    notiforms.notiuid:=uid;
    ABitmap:=Graphics.TBitmap.Create;
    ABitmap.Monochrome:=true;
    ABitmap.Width:=notiforms.Width;
    ABitmap.Height:=notiforms.Height;
    ABitmap.Canvas.Brush.Color:=clBlack;
    ABitmap.Canvas.FillRect(0, 0, notiforms.Width, notiforms.Height);
    ABitmap.Canvas.Brush.Color:=clWhite;
    ABitmap.Canvas.RoundRect(0, 0, notiforms.Width, notiforms.Height, 20, 20);
    if fpath<>'' then
    begin
      notiforms.btnStartDown.Visible:=true;
      notiforms.btnGoPath.Visible:=true;
      notiforms.btnOpenFile.Visible:=true;
      notiforms.btnCopyTo.Visible:=true;
      notiforms.btnMoveTo.Visible:=true;
      notiforms.btnGoPath.Enabled:=ok;
      notiforms.btnOpenFile.Enabled:=ok;
      notiforms.btnCopyTo.Enabled:=ok;
      notiforms.btnMoveTo.Enabled:=ok;
    end
    else
    begin
      notiforms.btnStartDown.Visible:=false;
      notiforms.btnGoPath.Visible:=false;
      notiforms.btnOpenFile.Visible:=false;
      notiforms.btnCopyTo.Visible:=false;
      notiforms.btnMoveTo.Visible:=false;
      notiforms.btnGoPath.Enabled:=ok;
      notiforms.btnOpenFile.Enabled:=ok;
      notiforms.btnCopyTo.Enabled:=ok;
      notiforms.btnMoveTo.Enabled:=ok;
    end;
    if (uid='') then
      notiforms.btnStartDown.Enabled:=false
    else
      notiforms.btnStartDown.Enabled:=not ok;
    notiforms.btnGoPath.OnClick:=notiforms.btnGoPath.OnClick;
    notiforms.btnOpenFile.OnClick:=notiforms.btnOpenFile.OnClick;
    notiforms.btnClose.OnClick:=notiforms.btnClose.OnClick;
    notiforms.btnCopyTo.OnClick:=notiforms.btnCopyTo.OnClick;
    notiforms.btnMoveTo.OnClick:=notiforms.btnMoveTo.OnClick;
    notiforms.OnMouseEnter:=notiforms.OnMouseEnter;
    notiforms.OnMouseLeave:=notiforms.OnMouseLeave;
    notiforms.btnStartDown.OnClick:=notiforms.btnStartDown.OnClick;
    notiforms.OnClick:=notiforms.OnClick;
    notiforms.lblFileName.Caption:=name;
    notiforms.lblDescriptionError.Caption:=note;
    notiforms.lblTitle.Caption:=title;
    notiforms.lblDescriptionError.Hint:=note;
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
    notiforms.HideTimer.Interval:=hiddenotifi*1000;
    notiforms.HideTimer.Enabled:=true;
    {$IFDEF LCLGTK2}
      notiforms.ShowInTaskBar:=stNever;
    {$ENDIF}
    {$IFDEF LCLQT5}
      notiforms.ShowInTaskBar:=stNever;
    {$ENDIF}
    notiforms.Show;
    notiforms.SetShape(ABitmap);
    FreeAndNil(ABitmap);
    frmain.tbrMain.Refresh;
  end;
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
    end;
  'aria2c','youtube-dl':
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
  'axel':
    begin
     tempstr:=floattostr(size);
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

{procedure refreshicons;
{ TODO -oSegator -cInterface : A best way to associate trayicon with the thread }
var
  x:integer;
begin
  for x:=0 to Length(trayicons)-1 do
  begin
    if Assigned(trayicons[x]) then
    begin
      try
        trayicons[x].Icon.Clear;
        trayicons[x].Visible:=false;
      except on e:exception do
      end;
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
      try
        if (frmain.lvMain.Items[x].SubItems[columnstatus]='1') and showdowntrayicon then
          trayicons[x].Show;
      except on e:exception do
      end;
    end;
  end;
end;}

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
  SetLength(categoryextencions,7);
  categoryextencions[0]:=TStringList.Create;
  categoryextencions[0].Add(ddowndir+pathdelim+categorycompressed);
  categoryextencions[0].Add(categorycompressed);
  categoryextencions[0].AddStrings(['ZIP','RAR','7Z','7ZIP','CAB','GZ','TAR','XZ','BZ2','LZMA']);
  categoryextencions[1]:=TStringList.Create;
  categoryextencions[1].Add(ddowndir+pathdelim+categoryprograms);
  categoryextencions[1].Add(categoryprograms);
  categoryextencions[1].AddStrings(['EXE','MSI','COM','BAT','PY','SH','HTA','JAR','APK','DMG']);
  categoryextencions[2]:=TStringList.Create;
  categoryextencions[2].Add(ddowndir+pathdelim+categoryimages);
  categoryextencions[2].Add(categoryimages);
  categoryextencions[2].AddStrings(['JPG','JPE','JPEG','PNG','GIF','BMP','ICO','CUR','ANI']);
  categoryextencions[3]:=TStringList.Create;
  categoryextencions[3].Add(ddowndir+pathdelim+categorydocuments);
  categoryextencions[3].Add(categorydocuments);
  categoryextencions[3].AddStrings(['DOC','DOCX','XLS','XLSX','PPT','PPS','PPTX','PPSX','TXT','PDF','HTM','HTML','MHT','RTF','ODF','ODT','ODS','PHP']);
  categoryextencions[4]:=TStringList.Create;
  categoryextencions[4].Add(ddowndir+pathdelim+categoryvideos);
  categoryextencions[4].Add(categoryvideos);
  categoryextencions[4].AddStrings(['MPG','MPE','MPEG','MP4','MOV','FLV','AVI','ASF','WMV','MKV','VOB','IFO','RMVB','DIVX','3GP','3GP2','SWF','MPV','M4V','WEBM','AMV']);
  categoryextencions[5]:=TStringList.Create;
  categoryextencions[5].Add(ddowndir+pathdelim+categorymusic);
  categoryextencions[5].Add(categorymusic);
  categoryextencions[5].AddStrings(['MP3','OGG','WAV','WMA','AMR','MIDI','M4A']);
  categoryextencions[6]:=TStringList.Create;
  categoryextencions[6].Add(ddowndir+pathdelim+'Torrents');
  categoryextencions[6].Add(categorytorrents);
  categoryextencions[6].AddStrings(['TORRENT']);
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
  frnewdown.cbQueue.Items.Clear;
  for i:=0 to Length(queues)-1 do
    frnewdown.cbQueue.Items.Add(queuenames[i]);
end;

procedure newgrabberqueues();
var
  i:integer;
begin
  frsitegrabber.cbQueue.Items.Clear;
  for i:=0 to Length(queues)-1 do
    frsitegrabber.cbQueue.Items.Add(queuenames[i]);
end;

procedure queueindexselect();
begin
  if frnewdown.cbQueue.Items.Count>=queueindex then
    frnewdown.cbQueue.ItemIndex:=queueindex;
  if frsitegrabber.cbQueue.Items.Count>=queueindex then
    frsitegrabber.cbQueue.ItemIndex:=queueindex;
  if (frmain.tvMain.SelectionCount>0) and frmain.Active then
  begin
    if frmain.tvMain.Selected.Level>0 then
    begin
      case frmain.tvMain.Selected.Parent.Index of
        1:begin//colas
            frnewdown.cbQueue.ItemIndex:=frmain.tvMain.Selected.Index;
            frsitegrabber.cbQueue.ItemIndex:=frmain.tvMain.Selected.Index;
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
      begin
        frmain.lvMain.Items[i].SubItems[columnqueue]:=inttostr(frmain.milistSendToQueue.IndexOf(self));
        frmain.lvMain.Items[i].SubItems[columntries]:=inttostr(triesrotate);
      end;
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
    frmain.pmTrayIcon.Items.Insert(frmain.pmTrayIcon.Items.IndexOf(frmain.miline3),stmenu);
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
  begin
    frnewdown.cbDestination.Items.Clear;
    frnewdown.cbDestination.Items.Add(UTF8ToSys(ddowndir));
  end;
  for i:=0 to Length(categoryextencions)-1 do
  begin
    treeitem:=TTreeNode.Create(frmain.tvMain.Items);
    treeitem:=frmain.tvMain.Items.AddChild(frmain.tvMain.Items.TopLvlItems[3],categoryextencions[i][1]);
    treeitem.ImageIndex:=23;
    treeitem.SelectedIndex:=23;
    if Assigned(frnewdown) then
      reloaddowndirs();
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
  frconfirm.dlgtext.Caption:=fstrings.dlgdeletequeue+#10#13+#10#13+queuenames[indice];
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
  nam:=fstrings.queuename+' '+inttostr(Length(queues)+1);

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
  if FileExists(currentdir+'awgg.ini') then
    frmain.Caption:=frmain.Caption+' '+fstrings.portablemode;
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

procedure downthread_shutdown(t:DownThread);
begin
  // This helper tries to protect the DownThread object from
  // being used after it was terminated.
  // This, however, does not guarantee 100% protection in case
  // of multi-threading, when another thread may be destroying
  // this object while it is being used here.
  if Assigned(t) and (not t.Terminated) then
    t.shutdown();
end;

procedure stopqueue(indice:integer);
var
  n:integer;
begin
  qtimer[indice].Enabled:=false;
  if indice=0 then
    queuemainstop:=true;
  for n:=0 to frmain.lvMain.Items.Count-1 do
  begin
    if (Assigned(hilo)) and (Length(hilo)>=strtoint(frmain.lvMain.Items[n].SubItems[columnid])) and (frmain.lvMain.Items[n].SubItems[columnqueue]=inttostr(indice)) and (frmain.lvMain.Items[n].SubItems[columnstatus]='1') then
      downthread_shutdown(hilo[strtoint(frmain.lvMain.Items[n].SubItems[columnid])]);
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

procedure suggestparameters();
begin
  case LowerCase(ParseURI(frnewdown.edtURL.Text).Host) of
    'www.youtube.com',
    'www.vimeo.com',
    'www.smotri.com',
    'youtu.be':
  begin
    if frnewdown.cbEngine.Items.IndexOf('youtube-dl')<>-1 then
    begin
      frnewdown.cbEngine.ItemIndex:=frnewdown.cbEngine.Items.IndexOf('youtube-dl');
      frnewdown.edtFileName.Text:='';
      frnewdown.btnMore.Enabled:=true;
      if defaultdirmode=2 then
      begin
        frnewdown.deDestination.Text:=suggestdir('video.flv');
        frnewdown.cbDestination.ItemIndex:=frnewdown.cbDestination.Items.IndexOf(frnewdown.deDestination.Text);
      end;
    end;
  end;
  else
  begin
    frnewdown.cbEngine.ItemIndex:=frnewdown.cbEngine.Items.IndexOf(defaultengine);
    if frnewdown.cbEngine.ItemIndex=-1 then
      frnewdown.cbEngine.ItemIndex:=0;
    frnewdown.btnMore.Enabled:=false;
  end;
  end;
  case LowerCase(Copy(frnewdown.edtFileName.Text,LastDelimiter('.',frnewdown.edtFileName.Text)+1,Length(frnewdown.edtFileName.Text))) of
  'torrent','meta4','metalink':
    begin
    if frnewdown.cbEngine.Items.IndexOf('aria2c')<>-1 then
      frnewdown.cbEngine.ItemIndex:=frnewdown.cbEngine.Items.IndexOf('aria2c');
    end;
  end;
  if Pos('magnet:',frnewdown.edtURL.Text)=1 then
  begin
    if frnewdown.cbEngine.Items.IndexOf('aria2c')<>-1 then
      frnewdown.cbEngine.ItemIndex:=frnewdown.cbEngine.Items.IndexOf('aria2c');
  end;
end;

{$IFDEF MSWINDOWS}
{$ELSE}
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
    player.Options:=[{poUsePipes,poStderrToOutPut,}poNoConsole];
    player.Executable:=engine;
    player.Parameters.Add(sndfile);
    player.Execute;
  end;
  while player.Running do;
    hilosnd.Terminate;
end;
{$ENDIF}

procedure playsound(soundfile:string);
begin
  if Pos(pathdelim,soundfile)=0 then
    soundfile:=ExtractFilePath(UTF8ToSys(Application.Params[0]))+pathdelim+soundfile;
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

procedure movestepup(downitemindex:integer;steps:integer);
begin
  if (downitemindex<>-1) and (steps>=0) then
  begin
    frmain.lvMain.MultiSelect:=false;
    frmain.lvMain.Items.Move(downitemindex,steps);
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
  if (frmain.lvMain.SelCount>0) and (steps<=frmain.lvMain.Items.Count) then
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
      '0':frmain.lvMain.Items[x].Caption:=fstrings.statuspaused;
      '1':frmain.lvMain.Items[x].Caption:=fstrings.statusinprogres;
      '2':frmain.lvMain.Items[x].Caption:=fstrings.statusstoped;
      '3':frmain.lvMain.Items[x].Caption:=fstrings.statuscomplete;
      '4':frmain.lvMain.Items[x].Caption:=fstrings.statuserror;
      '5':frmain.lvMain.Items[x].Caption:=fstrings.statuscanceled;
    end;
  end;
  for x:=0 to frmain.lvFilter.Columns.Count-1 do
    frmain.lvFilter.Columns[x].Caption:=frmain.lvMain.Columns[x].Caption;

  frmain.tvMain.Items[0].Text:=fstrings.alldowntreename;
  frmain.tvMain.Items[1].Text:=fstrings.queuestreename;
  if frmain.tvMain.Items[1].Count>0 then
    frmain.tvMain.Items[1].Items[0].Text:=fstrings.queuemainname;
  frmain.tvMain.Items[frmain.tvMain.Items[1].Count+2].Text:=fstrings.filtresname;
  frmain.tvMain.Items[frmain.tvMain.Items[1].Count+3].Text:=fstrings.statuscomplete;
  frmain.tvMain.Items[frmain.tvMain.Items[1].Count+4].Text:=fstrings.statusinprogres;
  frmain.tvMain.Items[frmain.tvMain.Items[1].Count+5].Text:=fstrings.statusstoped;
  frmain.tvMain.Items[frmain.tvMain.Items[1].Count+6].Text:=fstrings.statuserror;
  frmain.tvMain.Items[frmain.tvMain.Items[1].Count+7].Text:=fstrings.statuscanceled;
  frmain.tvMain.Items[frmain.tvMain.Items[1].Count+8].Text:=fstrings.statuspaused;
  frmain.tvMain.Items.TopLvlItems[3].Text:=categoryfilter;
  frmain.tvMain.Items.TopLvlItems[3][frmain.tvMain.Items.TopLvlItems[3].SubTreeCount-2].Text:=categoryothers;
  if Assigned(frconfig) then
  begin
    frconfig.tvConfig.Items[0].Text:=frconfig.tsProxy.Caption;
    frconfig.tvConfig.Items[1].Text:=frconfig.tsScheduler.Caption;
    frconfig.tvConfig.Items[2].Text:=frconfig.tsNotifications.Caption;
    frconfig.tvConfig.Items[3].Text:=frconfig.tsSounds.Caption;
    frconfig.tvConfig.Items[4].Text:=frconfig.tsClipboardm.Caption;
    frconfig.tvConfig.Items[5].Text:=frconfig.tsInternetMonitor.Caption;
    frconfig.tvConfig.Items[6].Text:=frconfig.tsFolders.Caption;
    frconfig.tvConfig.Items[7].Text:=frconfig.tsWget.Caption;
    frconfig.tvConfig.Items[8].Text:=frconfig.tsAria2.Caption;
    frconfig.tvConfig.Items[9].Text:=frconfig.tsCurl.Caption;
    frconfig.tvConfig.Items[10].Text:=frconfig.tsAxel.Caption;
    frconfig.tvConfig.Items[11].Text:=frconfig.tsYoutubedl.Caption;
    frconfig.tvConfig.Items[12].Text:=frconfig.tsAutomation.Caption;
    frconfig.tvConfig.Items[13].Text:=frconfig.tsLogs.Caption;
    frconfig.tvConfig.Items[14].Text:=frconfig.tsDownOptions.Caption;
    frconfig.tvConfig.Items[15].Text:=frconfig.tsLang.Caption;
    frconfig.tvConfig.Items[16].Text:=frconfig.tsQueue.Caption;
    frconfig.tvConfig.Items[17].Text:=frconfig.tsIntegration.Caption;
    frconfig.tvConfig.Items[18].Text:=frconfig.tsUpdates.Caption;

    frconfig.pConfigInfo.Caption:=frconfig.pcConfig.Pages[frconfig.pcConfig.TabIndex].Caption;
    frconfig.chgWeekDays.Items[0]:=fstrings.sunday;
    frconfig.chgWeekDays.Items[1]:=fstrings.monday;
    frconfig.chgWeekDays.Items[2]:=fstrings.tuesday;
    frconfig.chgWeekDays.Items[3]:=fstrings.wednesday;
    frconfig.chgWeekDays.Items[4]:=fstrings.thursday;
    frconfig.chgWeekDays.Items[5]:=fstrings.friday;
    frconfig.chgWeekDays.Items[6]:=fstrings.saturday;
    frconfig.chgAutomation.Items[0]:=fstrings.runwiththesystem;
    frconfig.chgAutomation.Items[1]:=fstrings.startinthesystray;
    if frconfig.cbQueue.Items.Count>0 then
      frconfig.cbQueue.Items[0]:=fstrings.queuemainname;
    frconfig.cbProxy.Items[0]:=fstrings.proxynot;
    frconfig.cbProxy.Items[1]:=fstrings.proxysystem;
    frconfig.cbProxy.Items[2]:=fstrings.proxymanual;
    frconfig.chgWgetDefArguments.Items[0]:=wgetdefarg1;
    frconfig.chgWgetDefArguments.Items[1]:=wgetdefarg2;
    frconfig.chgWgetDefArguments.Items[2]:=wgetdefarg3;
    frconfig.chgWgetDefArguments.Items[3]:=wgetdefarg4;
    frconfig.chgAria2DefArguments.Items[0]:=aria2defarg1;
    frconfig.chgAria2DefArguments.Items[1]:=aria2defarg2;
    frconfig.chgCurlDefArguments.Items[0]:=curldefarg1;
  end;
  queuenames[0]:=fstrings.queuemainname;
  queuesreload();
  if Assigned(frnewdown) then
    newdownqueues();
end;

procedure enginereload();
begin
  frnewdown.cbEngine.Items.Clear;
  frconfig.cbDefEngine.Items.Clear;
  frconfig.cbytexternaldown.Items.Clear;

  if FileExistsUTF8(aria2crutebin) then
  begin
    frnewdown.cbEngine.Items.Add('aria2c');
    frconfig.cbDefEngine.Items.Add('aria2c');
    frconfig.cbytexternaldown.Items.Add('aria2c');
  end;

  if FileExistsUTF8(axelrutebin) then
  begin
    frnewdown.cbEngine.Items.Add('axel');
    frconfig.cbDefEngine.Items.Add('axel');
    frconfig.cbytexternaldown.Items.Add('axel');
  end;

  if FileExistsUTF8(curlrutebin) then
  begin
    frnewdown.cbEngine.Items.Add('curl');
    frconfig.cbDefEngine.Items.Add('curl');
    frconfig.cbytexternaldown.Items.Add('curl');
  end;

  if FileExistsUTF8(wgetrutebin) then
  begin
    frnewdown.cbEngine.Items.Add('wget');
    frconfig.cbDefEngine.Items.Add('wget');
    frconfig.cbytexternaldown.Items.Add('wget');
  end;

  if FileExistsUTF8(youtubedlrutebin) then
  begin
    frnewdown.cbEngine.Items.Add('youtube-dl');
    frconfig.cbDefEngine.Items.Add('youtube-dl');
  end;

  //Seleccionar wget por defecto
  frnewdown.cbEngine.ItemIndex:=frnewdown.cbEngine.Items.IndexOf(defaultengine);
  frconfig.cbDefEngine.ItemIndex:=frconfig.cbDefEngine.Items.IndexOf(defaultengine);
  frconfig.cbytexternaldown.ItemIndex:=frconfig.cbytexternaldown.Items.IndexOf('aria2c');
  if frnewdown.cbEngine.ItemIndex=-1 then
    frnewdown.cbEngine.ItemIndex:=0;
  if frconfig.cbDefEngine.ItemIndex=-1 then
    frconfig.cbDefEngine.ItemIndex:=0;
  if frconfig.cbytexternaldown.ItemIndex=-1 then
    frconfig.cbytexternaldown.ItemIndex:=0;
  defaultengine:=frnewdown.cbEngine.Caption;
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
  dropboxonstart:=frmain.miDropbox.Checked;
  showmainintray:=frmain.mimainShowInTray.Checked;
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
    iniconfigfile.WriteString('Config','puser',EncodeBase64(puser));
    iniconfigfile.WriteString('Config','ppassword',EncodeBase64(ppassword));
    iniconfigfile.WriteBool('Config','shownotifi',shownotifi);
    iniconfigfile.WriteBool('Config','shownotificomplete',shownotificomplete);
    iniconfigfile.WriteBool('Config','shownotifierror',shownotifierror);
    iniconfigfile.WriteBool('Config','shownotifiinternet',shownotifiinternet);
    iniconfigfile.WriteBool('Config','shownotifinointernet',shownotifinointernet);
    iniconfigfile.WriteInteger('Config','hiddenotifi',hiddenotifi);
    iniconfigfile.WriteBool('Config','usesysnotifi',usesysnotifi);
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
    iniconfigfile.WriteString('Config','wgetrutebin',StringReplace(wgetrutebin,currentdir,awgg_path,[rfReplaceAll]));
    iniconfigfile.WriteString('Config','aria2crutebin',StringReplace(aria2crutebin,currentdir,awgg_path,[rfReplaceAll]));
    iniconfigfile.WriteString('Config','curlrutebin',StringReplace(curlrutebin,currentdir,awgg_path,[rfReplaceAll]));
    iniconfigfile.WriteString('Config','axelrutebin',StringReplace(axelrutebin,currentdir,awgg_path,[rfReplaceAll]));
    iniconfigfile.WriteString('Config','youtubedlrutebin',StringReplace(youtubedlrutebin,currentdir,awgg_path,[rfReplaceAll]));
    iniconfigfile.WriteString('Config','wgetargs',wgetargs);
    iniconfigfile.WriteString('Config','aria2cargs',aria2cargs);
    iniconfigfile.WriteString('Config','curlargs',curlargs);
    iniconfigfile.WriteString('Config','axelargs',axelargs);
    iniconfigfile.WriteString('Config','youtubedlargs',youtubedlargs);
    iniconfigfile.WriteString('Config','youtubedlextdown',youtubedlextdown);
    iniconfigfile.WriteBool('Config','youtubedluseextdown',youtubedluseextdown);
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
    iniconfigfile.WriteBool('Config','youtubedldefcontinue',youtubedldefcontinue);
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
    iniconfigfile.WriteBool('Config','playsoundcomplete',playsoundcomplete);
    iniconfigfile.WriteBool('Config','playsounderror',playsounderror);
    iniconfigfile.WriteBool('Config','playsoundinternet',playsoundinternet);
    iniconfigfile.WriteBool('Config','playsoundnointernet',playsoundnointernet);
    iniconfigfile.WriteString('Config','downcompsound',StringReplace(downcompsound,currentdir,awgg_path,[rfReplaceAll]));
    iniconfigfile.WriteString('Config','downstopsound',StringReplace(downstopsound,currentdir,awgg_path,[rfReplaceAll]));
    iniconfigfile.WriteString('Config','internetsound',StringReplace(internetsound,currentdir,awgg_path,[rfReplaceAll]));
    iniconfigfile.WriteString('Config','nointernetsound',StringReplace(nointernetsound,currentdir,awgg_path,[rfReplaceAll]));
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
    iniconfigfile.WriteBool('Config','dropboxonstart',dropboxonstart);
    iniconfigfile.WriteBool('Config','silentdropbox',silentdropbox);
    iniconfigfile.WriteBool('Config','showmainintray',showmainintray);
    //Window position and size
    if frmain.WindowState<>wsMaximized then
    begin
      iniconfigfile.WriteInteger('Config','mainwindowxpos',frmain.Left);
      iniconfigfile.WriteInteger('Config','mainwindowypos',frmain.Top);
      iniconfigfile.WriteInteger('Config','mainwindowwidth',frmain.Width);
      iniconfigfile.WriteInteger('Config','mainwindowheight',frmain.Height);
    end;
    //Dropbox position and size
    iniconfigfile.WriteInteger('Config','dropboxxpos',frddbox.Left);
    iniconfigfile.WriteInteger('Config','dropboxypos',frddbox.Top);
    iniconfigfile.WriteInteger('Config','dropboxsize',frddbox.Width);
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
    /////////////Domain clipbiard monitor filter
    iniconfigfile.WriteBool('Config','activedomainfilter',activedomainfilter);
    iniconfigfile.WriteInteger('Filters','count',Length(domainfilters));
    for i:=0 to Length(domainfilters)-1 do
    begin
      iniconfigfile.WriteString('Domain'+inttostr(i),'Name',domainfilters[i]);
    end;
    //////////////////////////////
    iniconfigfile.WriteBool('Config','internetcheck',internetCheck);
    iniconfigfile.WriteString('Config','interneturl',internetURL);
    iniconfigfile.WriteInteger('Config','internetinterval',internetInterval);
    iniconfigfile.WriteBool('Config','newdownloadforcenames',newdownloadforcenames);
    /////////////////////////Updates///////////////////////////
    iniconfigfile.WriteBool('Config','autoupdate',autoupdate);
    iniconfigfile.WriteBool('Config','autoupdatearia2',autoupdatearia2);
    iniconfigfile.WriteBool('Config','autoupdateaxel',autoupdateaxel);
    iniconfigfile.WriteBool('Config','autoupdatecurl',autoupdatecurl);
    iniconfigfile.WriteBool('Config','autoupdateyoutubedl',autoupdateyoutubedl);
    iniconfigfile.WriteBool('Config','autoupdatewget',autoupdatewget);
    iniconfigfile.UpdateFile;
    iniconfigfile.Free;
    autostart();
  except on e:exception do
    ShowMessage(fstrings.msgerrorconfigsave+e.ToString);
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
    puser:=DecodeBase64(iniconfigfile.ReadString('Config','puser',''));
    ppassword:=DecodeBase64(iniconfigfile.ReadString('Config','ppassword',''));
    shownotifi:=iniconfigfile.ReadBool('Config','shownotifi',true);
    shownotificomplete:=iniconfigfile.ReadBool('Config','shownotificomplete',true);
    shownotifierror:=iniconfigfile.ReadBool('Config','shownotifierror',true);
    shownotifiinternet:=iniconfigfile.ReadBool('Config','shownotifiinternet',false);
    shownotifinointernet:=iniconfigfile.ReadBool('Config','shownotifinointernet',false);
    hiddenotifi:=iniconfigfile.ReadInteger('Config','hiddenotifi',5);
    usesysnotifi:=iniconfigfile.ReadBool('Config','usesysnotifi',false);
    clipboardmonitor:=iniconfigfile.ReadBool('Config','clipboardmonitor',true);
    ddowndir:=iniconfigfile.ReadString('Config','ddowndir',ddowndir);
    dotherdowndir:=ddowndir+pathdelim+categoryothers;
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
    wgetrutebin:=StringReplace(iniconfigfile.ReadString('Config','wgetrutebin',wgetrutebin),awgg_path,currentdir,[rfReplaceAll]);
    aria2crutebin:=StringReplace(iniconfigfile.ReadString('Config','aria2crutebin',aria2crutebin),awgg_path,currentdir,[rfReplaceAll]);
    curlrutebin:=StringReplace(iniconfigfile.ReadString('Config','curlrutebin',curlrutebin),awgg_path,currentdir,[rfReplaceAll]);
    axelrutebin:=StringReplace(iniconfigfile.ReadString('Config','axelrutebin',axelrutebin),awgg_path,currentdir,[rfReplaceAll]);
    youtubedlrutebin:=StringReplace(iniconfigfile.ReadString('Config','youtubedlrutebin',youtubedlrutebin),awgg_path,currentdir,[rfReplaceAll]);
    wgetargs:=iniconfigfile.ReadString('Config','wgetargs',wgetargs);
    aria2cargs:=iniconfigfile.ReadString('Config','aria2cargs',aria2cargs);
    curlargs:=iniconfigfile.ReadString('Config','curlargs',curlargs);
    axelargs:=iniconfigfile.ReadString('Config','axelargs',axelargs);
    youtubedlargs:=iniconfigfile.ReadString('Config','youtubedlargs',youtubedlargs);
    youtubedlextdown:=iniconfigfile.ReadString('Config','youtubedlextdown','wget');
    youtubedluseextdown:=iniconfigfile.ReadBool('Config','youtubedluseextdown',false);
    wgetdefcontinue:=iniconfigfile.ReadBool('Config','wgetdefcontinue',true);
    wgetdefnh:=iniconfigfile.ReadBool('Config','wgetdefnh',true);
    wgetdefnd:=iniconfigfile.ReadBool('Config','wgetdefnd',true);
    wgetdefncert:=iniconfigfile.ReadBool('Config','wgetdefncert',true);
    aria2cdefcontinue:=iniconfigfile.ReadBool('Config','aria2cdefcontinue',true);
    aria2cdefallocate:=iniconfigfile.ReadBool('Config','aria2cdefallocate',true);
    aria2splitsize:=iniconfigfile.ReadString('Config','aria2splitsize','1M');
    aria2splitnum:=iniconfigfile.ReadInteger('Config','aria2splitnum',4);
    aria2split:=iniconfigfile.ReadBool('Config','aria2split',true);
    curldefcontinue:=iniconfigfile.ReadBool('Config','curldefcontinue',true);
    youtubedldefcontinue:=iniconfigfile.ReadBool('Config','youtubedldefcontinue',true);
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
    dtimeout:=iniconfigfile.ReadInteger('Config','dtimeout',20);
    ddelay:=iniconfigfile.ReadInteger('Config','ddelay',5);
    deflanguage:=iniconfigfile.ReadString('Config','deflanguage','en');
    firststart:=iniconfigfile.ReadBool('Config','firststart',true);
    defaultengine:=iniconfigfile.ReadString('Config','defaultengine','wget');
    playsounds:=iniconfigfile.ReadBool('Config','playsounds',true);
    playsoundcomplete:=iniconfigfile.ReadBool('Config','playsoundcomplete',true);
    playsounderror:=iniconfigfile.ReadBool('Config','playsounderror',true);
    playsoundinternet:=iniconfigfile.ReadBool('Config','playsoundinternet',false);
    playsoundnointernet:=iniconfigfile.ReadBool('Config','playsoundnointernet',false);
    downcompsound:=StringReplace(iniconfigfile.ReadString('Config','downcompsound',currentdir+'complete.wav'),awgg_path,currentdir,[rfReplaceAll]);
    downstopsound:=StringReplace(iniconfigfile.ReadString('Config','downstopsound',currentdir+'stopped.wav'),awgg_path,currentdir,[rfReplaceAll]);
    internetsound:=StringReplace(iniconfigfile.ReadString('Config','internetsound',currentdir+'internet.wav'),awgg_path,currentdir,[rfReplaceAll]);
    nointernetsound:=StringReplace(iniconfigfile.ReadString('Config','nointernetsound',currentdir+'nointernet.wav'),awgg_path,currentdir,[rfReplaceAll]);
    sheduledisablelimits:=iniconfigfile.ReadBool('Config','sheduledisablelimits',false);
    queuerotate:=iniconfigfile.ReadBool('Config','queuerotate',false);
    triesrotate:=iniconfigfile.ReadInteger('Config','triesrotate',5);
    rotatemode:=iniconfigfile.ReadInteger('Config','rotatemode',0);
    queuedelay:=iniconfigfile.ReadInteger('Config','queuedelay',1);
    sameproxyforall:=iniconfigfile.ReadBool('Config','sameproxyforall',false);
    loadhistorylog:=iniconfigfile.ReadBool('Config','loadhistorylog',false);
    loadhistorymode:=iniconfigfile.ReadInteger('Config','loadhistorymode',2);
    defaultdirmode:=iniconfigfile.ReadInteger('Config','defaultdirmode',2);
    showtreeviewpanel:=iniconfigfile.ReadBool('Config','showtreeviewpanel',true);
    useglobaluseragent:=iniconfigfile.ReadBool('Config','useglobaluseragent',false);
    globaluseragent:=iniconfigfile.ReadString('Config','globaluseragent','Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1145.0 Safari/537.1');
    portablemode:=iniconfigfile.ReadBool('Config','portablemode',false);
    dropboxonstart:=iniconfigfile.ReadBool('Config','dropboxonstart',true);
    silentdropbox:=iniconfigfile.ReadBool('Config','silentdropbox',false);
    {$IFDEF WINDOWS}
    showmainintray:=iniconfigfile.ReadBool('Config','showmainintray',true);
    showdowntrayicon:=iniconfigfile.ReadBool('Config','showdowntrayicon',true);
    {$ELSE}
    showmainintray:=iniconfigfile.ReadBool('Config','showmainintray',false);
    showdowntrayicon:=iniconfigfile.ReadBool('Config','showdowntrayicon',false);
    {$ENDIF}
    if firststart then
      frmain.Position:=poScreenCenter;
    //Main window position and size
    frmain.Top:=iniconfigfile.ReadInteger('Config','mainwindowypos',frmain.Top);
    frmain.Left:=iniconfigfile.ReadInteger('Config','mainwindowxpos',frmain.Left);
    frmain.Width:=iniconfigfile.ReadInteger('Config','mainwindowwidth',frmain.Width);
    frmain.Height:=iniconfigfile.ReadInteger('Config','mainwindowheight',frmain.Height);
    //Dropbox position and size
    frddboxLeft:=iniconfigfile.ReadInteger('Config','dropboxxpos',Screen.WorkAreaWidth-40);
    frddboxTop:=iniconfigfile.ReadInteger('Config','dropboxypos',Screen.WorkAreaHeight-40);
    frddboxSize:=iniconfigfile.ReadInteger('Config','dropboxsize',40);
    //Internet check
    internetCheck:=iniconfigfile.ReadBool('Config','internetcheck',true);
    internetURL:=iniconfigfile.ReadString('Config','interneturl','http://www.google.com/');
    internetInterval:=iniconfigfile.ReadInteger('Config','internetinterval',10);
    newdownloadforcenames:=iniconfigfile.ReadBool('Config','newdownloadforcenames',true);
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
    /////Filtros
    activedomainfilter:=iniconfigfile.ReadBool('Config','activedomainfilter',false);
    if iniconfigfile.ValueExists('Filters','count') then
    begin
      SetLength(domainfilters,iniconfigfile.ReadInteger('Filters','count',0));
      for i:=0 to (iniconfigfile.ReadInteger('Filters','count',0)-1) do
      begin
        domainfilters[i]:=iniconfigfile.ReadString('Domain'+inttostr(i),'Name','');
      end;
    end;
    ////////////Updates
    autoupdate:=iniconfigfile.ReadBool('Config','autoupdate',true);
    autoupdatearia2:=iniconfigfile.ReadBool('Config','autoupdatearia2',true);
    autoupdateaxel:=iniconfigfile.ReadBool('Config','autoupdateaxel',true);
    autoupdatecurl:=iniconfigfile.ReadBool('Config','autoupdatecurl',true);
    autoupdateyoutubedl:=iniconfigfile.ReadBool('Config','autoupdateyoutubedl',true);
    autoupdatewget:=iniconfigfile.ReadBool('Config','autoupdatewget',true);
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
    frmain.MainTrayIcon.Visible:=showmainintray;
    frmain.miMainInTray.Checked:=showmainintray;
    frmain.mimainShowInTray.Checked:=showmainintray;
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
      if not FileExistsUTF8(youtubedlrutebin) then
        youtubedlrutebin:='/usr/bin/youtube-dl';
      if not FileExistsUTF8(youtubedlrutebin) then
        youtubedlrutebin:=ExtractFilePath(Application.Params[0])+'youtube-dl';
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
      if not FileExists(youtubedlrutebin) then
        youtubedlrutebin:=ExtractFilePath(Application.Params[0])+'youtube-dl.exe';
      {$ELSE}
      if not FileExistsUTF8(wgetrutebin) then
        wgetrutebin:=SysToUTF8(ExtractFilePath(Application.Params[0])+'wget.exe');
      if not FileExistsUTF8(aria2crutebin) then
        aria2crutebin:=SysToUTF8(ExtractFilePath(Application.Params[0])+'aria2c.exe');
      if not FileExistsUTF8(curlrutebin) then
        curlrutebin:=SysToUTF8(ExtractFilePath(Application.Params[0])+'curl.exe');
      if not FileExistsUTF8(axelrutebin) then
        axelrutebin:=SysToUTF8(ExtractFilePath(Application.Params[0])+'axel.exe');
      if not FileExistsUTF8(youtubedlrutebin) then
        youtubedlrutebin:=SysToUTF8(ExtractFilePath(Application.Params[0])+'youtube-dl.exe');
      {$ENDIF}
    {$ENDIF}
    frmain.ClipboardTimer.Enabled:=clipboardmonitor;
  except on e:exception do
    //ShowMessage(e.Message);
  end;
end;

procedure setconfig();
var
  i:integer;
  imonitorchanges:boolean=false;
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
  shownotifi:=frconfig.chShowNotifications.Checked;
  shownotificomplete:=frconfig.chNotifiOnDownloadComplete.Checked;
  shownotifierror:=frconfig.chNotifiOnDownloaderror.Checked;
  shownotifiinternet:=frconfig.chNotifiOnInternet.Checked;
  shownotifinointernet:=frconfig.chNotifiOnNoInternet.Checked;
  hiddenotifi:=frconfig.seHideSeconds.Value;
  clipboardmonitor:=frconfig.chClipboardMonitor.Checked;
  frmain.ClipBoardTimer.Enabled:=clipboardmonitor;
  ddowndir:=frconfig.deDownFolder.Text;
  dotherdowndir:=ddowndir+pathdelim+categoryothers;
  wgetrutebin:=StringReplace(frconfig.fneWgetpath.Text,awgg_path,currentdir,[rfReplaceAll]);
  aria2crutebin:=StringReplace(frconfig.fneAria2Path.Text,awgg_path,currentdir,[rfReplaceAll]);
  curlrutebin:=StringReplace(frconfig.fneCurlPath.Text,awgg_path,currentdir,[rfReplaceAll]);
  axelrutebin:=StringReplace(frconfig.fneAxelPath.Text,awgg_path,currentdir,[rfReplaceAll]);
  youtubedlrutebin:=StringReplace(frconfig.fneYoutubedlPath.Text,awgg_path,currentdir,[rfReplaceAll]);
  wgetargs:=frconfig.edtWgetAdditionalArgs.Text;
  aria2cargs:=frconfig.edtAria2AdditionalArgs.Text;
  curlargs:=frconfig.edtCurlAdditionalArgs.Text;
  axelargs:=frconfig.edtAxelAdditionalArgs.Text;
  youtubedlargs:=frconfig.edtYoutubedlAdditionalArgs.Text;
  youtubedluseextdown:=frconfig.chytUseExternalDown.Checked;
  youtubedlextdown:=frconfig.cbytexternaldown.Text;
  wgetdefcontinue:=frconfig.chgWgetDefArguments.Checked[0];
  wgetdefnh:=frconfig.chgWgetDefArguments.Checked[1];
  wgetdefnd:=frconfig.chgWgetDefArguments.Checked[2];
  wgetdefncert:=frconfig.chgWgetDefArguments.Checked[3];
  aria2cdefcontinue:=frconfig.chgAria2DefArguments.Checked[0];
  aria2cdefallocate:=frconfig.chgAria2DefArguments.Checked[1];
  aria2splitsize:=frconfig.edtAria2SplitSize.Text;
  aria2splitnum:=frconfig.seAria2Connections.Value;
  aria2split:=frconfig.chAria2UseMultiConnections.Checked;
  curldefcontinue:=frconfig.chgCurlDefArguments.Checked[0];
  autostartwithsystem:=frconfig.chgAutomation.Checked[0];
  autostartminimized:=frconfig.chgAutomation.Checked[1];
  logger:=frconfig.chSaveDownLogs.Checked;
  logpath:=frconfig.deLogsPath.Text;
  notifipos:=frconfig.rgPosition.ItemIndex;
  usesysnotifi:=frconfig.chSysNotifications.Checked;
  dtimeout:=frconfig.seDownTimeOut.Value;
  dtries:=frconfig.seDownTries.Value;
  ddelay:=frconfig.seDownDelayTries.Value;
  deflanguage:=frconfig.cbDefLanguage.Text;
  defaultengine:=frconfig.cbDefEngine.Text;
  playsounds:=frconfig.chPlaySounds.Checked;
  playsoundcomplete:=frconfig.chSoundDownComplete.Checked;
  playsounderror:=frconfig.chSoundDownError.Checked;
  playsoundInternet:=frconfig.chSoundInternet.Checked;
  playsoundNoInternet:=frconfig.chSoundNoInternet.Checked;
  queuelimits[frconfig.cbQueue.ItemIndex]:=frconfig.chDisableLimits.Checked;
  queuepoweroff[frconfig.cbQueue.ItemIndex]:=frconfig.chShutdown.Checked;
  queuerotate:=frconfig.chQueueRotate.Checked;
  downcompsound:=StringReplace(frconfig.fneSoundComplete.Text,awgg_path,currentdir,[rfReplaceAll]);
  downstopsound:=StringReplace(frconfig.fneSoundStopped.Text,awgg_path,currentdir,[rfReplaceAll]);
  internetsound:=StringReplace(frconfig.fneSoundInternet.Text,awgg_path,currentdir,[rfReplaceAll]);
  nointernetsound:=StringReplace(frconfig.fneSoundNoInternet.Text,awgg_path,currentdir,[rfReplaceAll]);
  triesrotate:=frconfig.seQueueTriesRotate.Value;
  if frconfig.rbQueueRMOneStep.Checked then
    rotatemode:=0;
  if frconfig.rbQueueRMToEnd.Checked then
    rotatemode:=1;
  if frconfig.rbQueueRMTwoStop.Checked then
    rotatemode:=2;
  queuedelay:=frconfig.seQueueDelaySec.Value;
  useglobaluseragent:=frconfig.chDownUseAgent.Checked;
  globaluseragent:=frconfig.edtDownAgent.Text;
  sameproxyforall:=frconfig.chSameProxy.Checked;
  loadhistorylog:=frconfig.chLoadLogs.Checked;
  if frconfig.rbLogsLoadAll.Checked=true then
    loadhistorymode:=1;
  if frconfig.rbLogsLoadLines.Checked=true then
    loadhistorymode:=2;
  if frconfig.rbCategoryOneFolder.Checked=true then
    defaultdirmode:=1;
  if frconfig.rbCategoryByType.Checked=true then
    defaultdirmode:=2;
  qtimerenable[frconfig.cbQueue.ItemIndex]:=frconfig.chEnableScheduler.Checked;
  qallday[frconfig.cbQueue.ItemIndex]:=frconfig.chDaily.Checked;

  queuestarttimes[frconfig.cbQueue.ItemIndex]:=frconfig.dtpStartQueue.Time;
  queuestoptimes[frconfig.cbQueue.ItemIndex]:=frconfig.dtpStopQueue.Time;

  queuestartdates[frconfig.cbQueue.ItemIndex]:=frconfig.deStartQueue.Date;
  qstop[frconfig.cbQueue.ItemIndex]:=frconfig.chStopQueue.Checked;
  queuestopdates[frconfig.cbQueue.ItemIndex]:=frconfig.deStopQueue.Date;
  qdomingo[frconfig.cbQueue.ItemIndex]:=frconfig.chgWeekDays.Checked[0];
  qlunes[frconfig.cbQueue.ItemIndex]:=frconfig.chgWeekDays.Checked[1];
  qmartes[frconfig.cbQueue.ItemIndex]:=frconfig.chgWeekDays.Checked[2];
  qmiercoles[frconfig.cbQueue.ItemIndex]:=frconfig.chgWeekDays.Checked[3];
  qjueves[frconfig.cbQueue.ItemIndex]:=frconfig.chgWeekDays.Checked[4];
  qviernes[frconfig.cbQueue.ItemIndex]:=frconfig.chgWeekDays.Checked[5];
  qsabado[frconfig.cbQueue.ItemIndex]:=frconfig.chgWeekDays.Checked[6];
  activedomainfilter:=frconfig.chIgnoreFilter.Checked;
  if (internetcheck<>frconfig.chInternetCheck.Checked) then
    imonitorchanges:=true;
  internetcheck:=frconfig.chInternetCheck.Checked;
  internetURL:=frconfig.edtInternetURL.Text;
  internetInterval:=frconfig.seInternetInterval.Value;
  autoupdate:=frconfig.chAutoCheckUpdate.Checked;
  autoupdatearia2:=frconfig.chUpdateAria2.Checked;
  autoupdateaxel:=frconfig.chUpdateAxel.Checked;
  autoupdatecurl:=frconfig.chUpdateCurl.Checked;
  autoupdateyoutubedl:=frconfig.chUpdateYoutubedl.Checked;
  autoupdatewget:=frconfig.chUpdateWget.Checked;
  silentdropbox:=frconfig.chSilentDropMode.Checked;
  SetLength(domainfilters,frconfig.lbDomains.Items.Count);
  for i:=0 to frconfig.lbDomains.Items.Count-1 do
  begin
    domainfilters[i]:=frconfig.lbDomains.Items[i];
  end;
  if frconfig.lbCategory.ItemIndex<>-1 then
    categoryextencionstmp[frconfig.lbCategory.ItemIndex][0]:=frconfig.deCategoryDownFolder.Text;
  categoryextencions:=categoryextencionstmp;
  SetDefaultLang(deflanguage);
  updatelangstatus();
  titlegen();
  saveconfig();
  stimer[frconfig.cbQueue.ItemIndex].Enabled:=qtimerenable[frconfig.cbQueue.ItemIndex];
  categoryreload();
  try
    if imonitorchanges then
    begin
      if internetcheck then
      begin
        internetchecker:=TConnectionThread.Create;
        internetchecker.Start;
      end
      else
      begin
        internet:=false;
        if Assigned(internetchecker) then
          internetchecker.stop;
        frmain.MainTrayIcon.Animate:=false;
        frmain.MainTrayIcon.Icon:=Application.Icon;
      end;
    end;
  except on e:exception do
  end;
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
    frconfig.chClipboardMonitor.Checked:=clipboardmonitor;
    frconfig.deDownFolder.Text:=ddowndir;
    frconfig.chShowNotifications.Checked:=shownotifi;
    frconfig.chNotifiOnDownloadComplete.Checked:=shownotificomplete;
    frconfig.chNotifiOnDownloadError.Checked:=shownotifierror;
    frconfig.chNotifiOnInternet.Checked:=shownotifiinternet;
    frconfig.chNotifiOnNointernet.Checked:=shownotifinointernet;
    frconfig.chSysNotifications.Checked:=usesysnotifi;
    frconfig.seHideSeconds.Value:=hiddenotifi;
    frconfig.fneWgetpath.Text:=StringReplace(wgetrutebin,currentdir,awgg_path,[rfReplaceAll]);
    frconfig.fneAria2Path.Text:=StringReplace(aria2crutebin,currentdir,awgg_path,[rfReplaceAll]);
    frconfig.fneCurlPath.Text:=StringReplace(curlrutebin,currentdir,awgg_path,[rfReplaceAll]);
    frconfig.fneAxelPath.Text:=StringReplace(axelrutebin,currentdir,awgg_path,[rfReplaceAll]);
    frconfig.fneYoutubedlPath.Text:=StringReplace(youtubedlrutebin,currentdir,awgg_path,[rfReplaceAll]);
    frconfig.edtWgetAdditionalArgs.Text:=wgetargs;
    frconfig.edtAria2AdditionalArgs.Text:=aria2cargs;
    frconfig.edtCurlAdditionalArgs.Text:=curlargs;
    frconfig.edtAxelAdditionalArgs.Text:=axelargs;
    frconfig.edtYoutubedlAdditionalArgs.Text:=youtubedlargs;
    frconfig.chytUseExternalDown.Checked:=youtubedluseextdown;
    frconfig.chytUseExternalDownChange(nil);
    frconfig.chgWgetDefArguments.Checked[0]:=wgetdefcontinue;
    frconfig.chgWgetDefArguments.Checked[1]:=wgetdefnh;
    frconfig.chgWgetDefArguments.Checked[2]:=wgetdefnd;
    frconfig.chgWgetDefArguments.Checked[3]:=wgetdefncert;
    frconfig.chgAria2DefArguments.Checked[0]:=aria2cdefcontinue;
    frconfig.chgAria2DefArguments.Checked[1]:=aria2cdefallocate;
    frconfig.seAria2Connections.Value:=aria2splitnum;
    frconfig.edtAria2SplitSize.Text:=aria2splitsize;
    frconfig.chAria2UseMultiConnections.Checked:=aria2split;
    frconfig.chgCurlDefArguments.Checked[0]:=curldefcontinue;
    frconfig.chgAutomation.Checked[0]:=autostartwithsystem;
    frconfig.chgAutomation.Checked[1]:=autostartminimized;
    frconfig.chSaveDownLogs.Checked:=logger;
    frconfig.deLogsPath.Text:=logpath;
    frconfig.rgPosition.ItemIndex:=notifipos;
    frconfig.seDownTimeOut.Value:=dtimeout;
    frconfig.seDownTries.Value:=dtries;
    frconfig.seDownDelayTries.Value:=ddelay;
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
    frconfig.cbDefLanguage.Items.Clear;
    if FindFirst(ExtractFilePath(UTF8ToSys(Application.Params[0]))+pathdelim+'languages'+pathdelim+'awgg.*.po',faAnyFile,itemfile)=0 then
    begin
      Repeat
        try
          frconfig.cbDefLanguage.Items.Add(Copy(itemfile.name,Pos('awgg.',itemfile.name)+5,Pos('.po',itemfile.name)-6));
        except
        on E:Exception do ShowMessage('The file '+itemfile.Name+' of language is not valid');
        end;
      Until FindNext(itemfile)<>0;
    end;
    frconfig.cbDefLanguage.ItemIndex:=frconfig.cbDefLanguage.Items.IndexOf(deflanguage);
    enginereload();
    frconfig.cbytexternaldown.ItemIndex:=frconfig.cbytexternaldown.Items.IndexOf(youtubedlextdown);
    if frconfig.cbytexternaldown.ItemIndex=-1 then
      frconfig.cbytexternaldown.ItemIndex:=0;
    frconfig.chPlaySounds.Checked:=playsounds;
    frconfig.chSoundDownComplete.Checked:=playsoundcomplete;
    frconfig.chSoundDownError.Checked:=playsounderror;
    frconfig.chSoundInternet.Checked:=playsoundinternet;
    frconfig.chSoundNoInternet.Checked:=playsoundnointernet;
    frconfig.chQueueRotate.Checked:=queuerotate;
    frconfig.fneSoundComplete.Text:=StringReplace(downcompsound,currentdir,awgg_path,[rfReplaceAll]);
    frconfig.fneSoundStopped.Text:=StringReplace(downstopsound,currentdir,awgg_path,[rfReplaceAll]);
    frconfig.fneSoundInternet.Text:=StringReplace(internetsound,currentdir,awgg_path,[rfReplaceAll]);
    frconfig.fneSoundNoInternet.Text:=StringReplace(nointernetsound,currentdir,awgg_path,[rfReplaceAll]);
    frconfig.seQueueTriesRotate.Value:=triesrotate;
    if rotatemode=0 then
      frconfig.rbQueueRMOneStep.Checked:=true;
    if rotatemode=1 then
      frconfig.rbQueueRMToEnd.Checked:=true;
    if rotatemode=2 then
      frconfig.rbQueueRMTwoStop.Checked:=true;
    frconfig.seQueueDelaySec.Value:=queuedelay;
    frconfig.chDownUseAgent.Checked:=useglobaluseragent;
    frconfig.edtDownAgent.Text:=globaluseragent;
    frconfig.chSameProxy.Checked:=sameproxyforall;
    frconfig.chLoadLogs.Checked:=loadhistorylog;
    if loadhistorymode=1 then
      frconfig.rbLogsLoadAll.Checked:=true;
    if loadhistorymode=2 then
      frconfig.rbLogsLoadLines.Checked:=true;
    frconfig.cbQueue.Items.Clear;
    for i:=0 to Length(queues)-1 do
    begin
      frconfig.cbQueue.Items.Add(queuenames[i]);
    end;
    ///////////////////////
    frconfig.cbQueue.ItemIndex:=0;
    if (frmain.tvMain.SelectionCount>0) then
    begin
      if frmain.tvMain.Selected.Level>0 then
      begin
        case frmain.tvMain.Selected.Parent.Index of
          1:begin//colas
              frconfig.cbQueue.ItemIndex:=frmain.tvMain.Selected.Index;
            end;
        end;
      end;
    end;
    ///////////////////////
    frconfig.chEnableScheduler.Checked:=qtimerenable[frconfig.cbQueue.ItemIndex];
    frconfig.chDaily.Checked:=qallday[frconfig.cbQueue.ItemIndex];
    frconfig.dtpStartQueue.Time:=queuestarttimes[frconfig.cbQueue.ItemIndex];
    frconfig.deStartQueue.Date:=queuestartdates[frconfig.cbQueue.ItemIndex];
    frconfig.chStopQueue.Checked:=qstop[frconfig.cbQueue.ItemIndex];
    frconfig.dtpStopQueue.Time:=queuestoptimes[frconfig.cbQueue.ItemIndex];
    frconfig.deStopQueue.Date:=queuestopdates[frconfig.cbQueue.ItemIndex];
    frconfig.chgWeekDays.Checked[0]:=qdomingo[frconfig.cbQueue.ItemIndex];
    frconfig.chgWeekDays.Checked[1]:=qlunes[frconfig.cbQueue.ItemIndex];
    frconfig.chgWeekDays.Checked[2]:=qmartes[frconfig.cbQueue.ItemIndex];
    frconfig.chgWeekDays.Checked[3]:=qmiercoles[frconfig.cbQueue.ItemIndex];
    frconfig.chgWeekDays.Checked[4]:=qjueves[frconfig.cbQueue.ItemIndex];
    frconfig.chgWeekDays.Checked[5]:=qviernes[frconfig.cbQueue.ItemIndex];
    frconfig.chgWeekDays.Checked[6]:=qsabado[frconfig.cbQueue.ItemIndex];
    frconfig.chDisableLimits.Checked:=queuelimits[frconfig.cbQueue.ItemIndex];
    frconfig.chShutdown.Checked:=queuepoweroff[frconfig.cbQueue.ItemIndex];
    frconfig.chIgnoreFilter.Checked:=activedomainfilter;
    frconfig.chIgnoreFilterChange(nil);
    frconfig.chInternetCheck.Checked:=internetcheck;
    frconfig.edtInternetURL.Text:=internetURL;
    frconfig.seInternetInterval.Value:=internetInterval;
    frconfig.lbDomains.Clear;
    for i:=0 to Length(domainfilters)-1 do
    begin
      frconfig.lbDomains.Items.Add(domainfilters[i]);
    end;
    case defaultdirmode of
      1:frconfig.rbCategoryOneFolder.Checked:=true;
      2:frconfig.rbCategoryOneFolder.Checked:=false;
    end;
    frconfig.chAutoCheckUpdate.Checked:=autoupdate;
    frconfig.chUpdateAria2.Checked:=autoupdatearia2;
    frconfig.chUpdateAxel.Checked:=autoupdateaxel;
    frconfig.chUpdateCurl.Checked:=autoupdatecurl;
    frconfig.chUpdateYoutubedl.Checked:=autoupdateyoutubedl;
    frconfig.chUpdateWget.Checked:=autoupdatewget;
    frconfig.chSilentDropMode.Checked:=silentdropbox;
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
              frconfig.pcConfig.TabIndex:=1;
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
      if (Assigned(hilo)) and (Length(hilo)>=strtoint(frmain.lvMain.Items[i].SubItems[columnid])) and (frmain.lvMain.Items[i].SubItems[columnstatus]='1') then
      begin
      if force then
        hilo[strtoint(frmain.lvMain.Items[i].SubItems[columnid])].wthp.Terminate(0)
      else
        downthread_shutdown(hilo[strtoint(frmain.lvMain.Items[i].SubItems[columnid])]);
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
  foundindex:integer;
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
          wgetparameters(tmps,indice,restart);
          if FileExists(frmain.lvMain.Items[indice].SubItems[columnurl]) then
            tmps.Add('-i');//Fichero de entrada
          tmps.Add(frmain.lvMain.Items[indice].SubItems[columnurl]);
        end;
        /////////////////***END***//////////////////

        /////////////////***ARIA2***///////////////
        if frmain.lvMain.Items[indice].SubItems[columnengine] = 'aria2c' then
        begin
          aria2parameters(tmps,indice,restart);
          tmps.Add(frmain.lvMain.Items[indice].SubItems[columnurl]);
        end;
        ///////////////***END***////////////////

        //////////////***CURL***////////////////
        if frmain.lvMain.Items[indice].SubItems[columnengine] = 'curl' then
        begin
          curlparameters(tmps,indice,restart);
          tmps.Add(frmain.lvMain.Items[indice].SubItems[columnurl]);
        end;
        /////////////////***END***////////////////////

        /////////////////***AXEL***//////////////////
        if frmain.lvMain.Items[indice].SubItems[columnengine] = 'axel' then
        begin
          axelparameters(tmps,indice,restart);
          tmps.Add(frmain.lvMain.Items[indice].SubItems[columnurl]);
        end;
        ///////////////////***END***///////////////////

        ///////////////////***YOUTUBE-DL***//////////////////
        if frmain.lvMain.Items[indice].SubItems[columnengine] = 'youtube-dl' then
        begin
          ////Parametros generales
          if WordCount(youtubedlargs,[' '])>0 then
          begin
            for wrn:=1 to WordCount(youtubedlargs,[' ']) do
              tmps.Add(ExtractWord(wrn,youtubedlargs,[' ']));
          end;
          ////Parametros para cada descarga
          if WordCount(frmain.lvMain.Items[indice].SubItems[columnparameters],[' '])>0 then
          begin
            for wrn:=1 to WordCount(frmain.lvMain.Items[indice].SubItems[columnparameters],[' ']) do
              tmps.Add(ExtractWord(wrn,frmain.lvMain.Items[indice].SubItems[columnparameters],[' ']));
          end;

          ////Use for external downloader if no playlist
          if youtubedluseextdown and (tmps.IndexOf('--yes-playlist')=-1) and (youtubedlextdown<>'') then
          begin
            tmps.Add('-g');
            tmps.Add('--get-filename');
          end;

          tmps.Add('--socket-timeout');
          tmps.Add(inttostr(dtimeout));

          tmps.Add('-R');
          tmps.Add(inttostr(dtries));

          //No needed
          {if (frmain.lvMain.Items[indice].SubItems[columncookie]<>'') and FileExists(frmain.lvMain.Items[indice].SubItems[columncookie]) then
          begin
            tmps.Add('--cookies');
            tmps.Add(frmain.lvMain.Items[indice].SubItems[columncookie]);
          end;}

          if frmain.lvMain.Items[indice].SubItems[columnuseragent]<>'' then
          begin
            tmps.Add('--user-agent');
            tmps.Add('"'+frmain.lvMain.Items[indice].SubItems[columnuseragent]+'"');
          end
          else
          begin
            if useglobaluseragent then
            begin
              tmps.Add('--user-agent');
              tmps.Add('"'+globaluseragent+'"');
            end;
          end;

          if (frmain.lvMain.Items[indice].SubItems[columnreferer]<>'') then
          begin
            tmps.Add('--referer');
            tmps.Add(frmain.lvMain.Items[indice].SubItems[columnreferer]);
          end;

          if frmain.lvMain.Items[indice].SubItems[columnheader]<>'' then
          begin
            tmps.Add('--add-header');
            tmps.add('"'+StringReplace(frmain.lvMain.Items[indice].SubItems[columnheader],'=',':',[rfReplaceAll])+'"');
          end;

          if (frmain.lvMain.Items[indice].SubItems[columnuser]<>'') and (frmain.lvMain.Items[indice].SubItems[columnpass]<>'') then
          begin
            tmps.Add('-u');
            tmps.Add(frmain.lvMain.Items[indice].SubItems[columnuser]);
            tmps.Add('-p');
            tmps.Add(frmain.lvMain.Items[indice].SubItems[columnpass]);
          end;

          if (frmain.lvMain.Items[indice].SubItems[columnuser]='') and (frmain.lvMain.Items[indice].SubItems[columnpass]<>'') then
          begin
            tmps.Add('--video-password');
            tmps.Add(frmain.lvMain.Items[indice].SubItems[columnpass]);
          end;

          //Defaults parameters for compatibility
          tmps.Add('--ignore-config');

          //No playlist if not declare
          if tmps.IndexOf('--yes-playlist')=-1 then
            tmps.Add('--no-playlist')
          else
            tmps.Add('-i');

          //Always use the best format if no declare other
          if tmps.IndexOf('-f')=-1 then
            tmps.Add('-f best');
          tmps.Add('-c');
          tmps.Add('--no-part');
          //tmps.Add('-v');
          tmps.Add('--newline');
          tmps.Add('--no-check-certificate');

          case useproxy of
            0:
            begin
              tmps.Add('--proxy');
              tmps.Add('""');
            end;
            2:
            begin
              tmps.Add('--proxy');
              if useaut then
                tmps.Add('http://'+puser+':'+ppassword+'@'+phttp+':'+phttpport)
              else
                tmps.Add('http://'+phttp+':'+phttpport);
            end;
          end;
          if (frmain.lvMain.Items[indice].SubItems[columnname]<>'') and (tmps.IndexOf('--yes-playlist')=-1) then
          begin
            tmps.Add('--o');
            tmps.Add(UTF8ToSys(frmain.lvMain.Items[indice].SubItems[columnname]));
          end;
          tmps.Add(frmain.lvMain.Items[indice].SubItems[columnurl]);
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
    frmain.lvMain.Items[indice].Caption:=fstrings.statusstarting;
    if frmain.lvMain.Items[indice].SubItems[columntype] = '0' then
      frmain.lvMain.Items[indice].ImageIndex:=2;
    if frmain.lvMain.Items[indice].SubItems[columntype] = '1' then
      frmain.lvMain.Items[indice].ImageIndex:=52;
    downid:=strtoint(frmain.lvMain.Items[indice].SubItems[columnid]);

    //El tama;o del array de hilos no debe ser menor que el propio id o la cantidad de items
    if downid>=frmain.lvMain.Items.Count then
      thnum:=downid
    else
      thnum:=frmain.lvMain.Items.Count;
    SetLength(hilo,thnum);
    SetLength(trayicons,thnum);
    if Assigned(trayicons[indice])=false then
    begin
      trayicons[indice]:=downtrayicon.Create(nil);
      trayicons[indice].Visible:=showdowntrayicon;
      trayicons[indice].downindex:=downid;
      trayicons[indice].OnDblClick:=@trayicons[indice].showinmain;
      trayicons[indice].OnMouseDown:=@trayicons[indice].contextmenu;
      trayicons[indice].PopUpMenu:=frmain.pmTrayDown;
    end
    else
    begin
      try
        trayicons[indice].Visible:=showdowntrayicon;
      except on e:exception do
      end;
    end;
    hilo[downid]:=DownThread.Create(true,tmps);
    //SetLength(hilo[downid].wout,thnum);
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
          frmain.lvFilter.Items[hilo[downid].thid2].Caption:=fstrings.statusstarting;
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
    frmain.SynEdit1.Lines.Add(fstrings.msgmustselectdownload);
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
        if iniciar and frnewdown.btnPaused.Visible then
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
    //if (maxcdown>=frmain.seMaxDownInProgress.Value) then
      //break;
  end;
  //if (maxcdown<frmain.seMaxDownInProgress.Value) then
  //begin
    for i:=0 to frmain.lvMain.Items.Count-1 do
    begin
      if (frmain.lvMain.Items[i].SubItems[columnqueue]=inttostr(self.qtindex)) then
      begin
        if (maxcdown<frmain.seMaxDownInProgress.Value) and ((frmain.lvMain.Items[i].SubItems[columnstatus]='') or (frmain.lvMain.Items[i].SubItems[columnstatus]='0') or (frmain.lvMain.Items[i].SubItems[columnstatus]='2') or (frmain.lvMain.Items[i].SubItems[columnstatus]='4')) and ((strtoint(frmain.lvMain.Items[i].SubItems[columntries])>0) or (frmain.lvMain.Items[i].SubItems[columnstatus]='0')) then
        begin
          if (self.qtindex<>0) then
          begin
            inc(maxcdown);
            downloadstart(i,false);
          end
          else
          begin
            //This is for no start main queue downloads if no internet connection.
            if ((internet and internetcheck) or (internetcheck=false)) and (queuemanual[self.qtindex]) then
            begin
              inc(maxcdown);
              downloadstart(i,false);
            end;
          end;
        end;
      end;
    end;
  //end;
  /////Stop de queue if not more to down and was start manual
  if (maxcdown=0) and queuemanual[self.qtindex] then
    self.Enabled:=false;
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
  frmain.pmTrayIcon.Items[self.qtindex+frmain.pmTrayIcon.Items.IndexOf(frmain.miline2)+1].Caption:=stopqueuesystray+' ('+queuenames[self.qtindex]+')';
  frmain.pmTrayIcon.Items[self.qtindex+frmain.pmTrayIcon.Items.IndexOf(frmain.miline2)+1].ImageIndex:=8;
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
  frmain.pmTrayIcon.Items[self.qtindex+frmain.pmTrayIcon.Items.IndexOf(frmain.miline2)+1].Caption:=startqueuesystray+' ('+queuenames[self.qtindex]+')';
  frmain.pmTrayIcon.Items[self.qtindex+frmain.pmTrayIcon.Items.IndexOf(frmain.miline2)+1].ImageIndex:=7;
end;

procedure sheduletimer.onstime(Sender:TObject);
var
  hora:System.TTime;
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
    //All day
    if qallday[self.stindex] then
    begin
      checkstart:=(hora>=queuestarttimes[self.stindex]);
      if queuestarttimes[self.stindex]>=queuestoptimes[self.stindex] then
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
        if self.stindex=0 then
          queuemainstop:=true;
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

procedure restartdownload(ahora:boolean;update:boolean=true);
var
  i:integer;
begin
  for i:=0 to frmain.lvMain.Items.Count-1 do
  begin
    if frmain.lvMain.Items[i].Selected then
    begin
      if frmain.lvMain.Items[i].SubItems[columnstatus] <> '1' then
      begin
        if frmain.lvMain.Items[i].SubItems[columntype]='0' then
        begin
          if FileExists(UTF8ToSys(frmain.lvMain.Items[i].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[i].SubItems[columnname])) then
            SysUtils.DeleteFile(UTF8ToSys(frmain.lvMain.Items[i].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[i].SubItems[columnname]));

          if (frmain.lvMain.Items[i].SubItems[columnengine]='aria2c') and (FileExists(UTF8ToSys(frmain.lvMain.Items[i].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[i].SubItems[columnname])+'.aria2')) then
            SysUtils.DeleteFile(UTF8ToSys(frmain.lvMain.Items[i].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[i].SubItems[columnname])+'.aria2');

          if (frmain.lvMain.Items[i].SubItems[columnengine]='axel') and (FileExists(UTF8ToSys(frmain.lvMain.Items[i].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[i].SubItems[columnname])+'.st')) then
            SysUtils.DeleteFile(UTF8ToSys(frmain.lvMain.Items[i].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[i].SubItems[columnname])+'.st');

          if (frmain.lvMain.Items[i].SubItems[columnengine]='youtube-dl') and (FileExists(UTF8ToSys(frmain.lvMain.Items[i].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[i].SubItems[columnname])+'.part')) then
            SysUtils.DeleteFile(UTF8ToSys(frmain.lvMain.Items[i].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[i].SubItems[columnname])+'.part');

          if FileExists(UTF8ToSys(datapath+pathdelim+frmain.lvMain.Items[i].SubItems[columnuid])+'.status') then
            SysUtils.DeleteFile(UTF8ToSys(datapath+pathdelim+frmain.lvMain.Items[i].SubItems[columnuid])+'.status');

          frmain.lvMain.Items[i].ImageIndex:=18;
        end;
        if frmain.lvMain.Items[i].SubItems[columntype] = '1' then
        begin
          if FileExists(UTF8ToSys(frmain.lvMain.Items[i].SubItems[columndestiny]+pathdelim+StringReplace(ParseURI(frmain.lvMain.Items[i].SubItems[columnurl]).Host+ParseURI(frmain.lvMain.Items[i].SubItems[columnurl]).Path,'/',pathdelim,[rfReplaceAll])+pathdelim+'index.html')) then
            SysUtils.DeleteFile(UTF8ToSys(frmain.lvMain.Items[i].SubItems[columndestiny]+pathdelim+StringReplace(ParseURI(frmain.lvMain.Items[i].SubItems[columnurl]).Host+ParseURI(frmain.lvMain.Items[i].SubItems[columnurl]).Path,'/',pathdelim,[rfReplaceAll])+pathdelim+'index.html'));
          frmain.lvMain.Items[i].ImageIndex:=51;
        end;
        frmain.lvMain.Items[i].Caption:=fstrings.statuspaused;
        frmain.lvMain.Items[i].SubItems[columnstatus]:='0';
        frmain.lvMain.Items[i].SubItems[columnpercent]:='-';
        frmain.lvMain.Items[i].SubItems[columnspeed]:='--';
        frmain.lvMain.Items[i].SubItems[columnestimate]:='--';
        frmain.lvMain.Items[i].SubItems[columncurrent]:='0';
        frmain.lvMain.Items[i].SubItems[columntries]:=inttostr(dtries);
        if ahora then
        begin
          queuemanual[strtoint(frmain.lvMain.Items[i].SubItems[columnqueue])]:=true;
          downloadstart(i,true);
        end;
      end;
    end;
  end;
  if frmain.lvFilter.Visible and update then
    frmain.tvMainSelectionChanged(nil);
end;

procedure DownThread.update;
var
  porciento:string='';
  velocidad:string='';
  tamano:string='';
  tiempo:string='';
  descargado:string='';
  nombre:string='';
  icono:Graphics.TBitmap;
  statusfile:TextFile;
  th,tw, sli:integer;
  itemfile:TSearchRec;
  sltofindtext:TStringList;
  tmppercent:integer;
  tmpsize:extended;
begin
  if (frmain.lvMain.ItemIndex>-1) and (frmain.micommandFollow.Checked) and (thid=frmain.lvMain.ItemIndex) then
  begin
    if Length(frmain.SynEdit1.Lines.Text)>0 then
      frmain.SynEdit1.SelStart:=Length(frmain.SynEdit1.Lines.Text);
    frmain.SynEdit1.SelEnd:=Length(frmain.SynEdit1.Lines.Text)+1;
    frmain.SynEdit1.InsertTextAtCaret(wout);
  end;
  /////////////////***WGET***/////////////////////
  if (frmain.lvMain.Items[thid].SubItems[columnengine] = 'wget') or (youtubedlthexternal='wget') or ((youtubedlextdown='wget') and youtubedluseextdown and (frmain.lvMain.Items[thid].SubItems[columnengine]='youtube-dl')) then
  begin
    if Pos(#10+'Longitud: ',wout)>0 then
    begin
      tamano:=Copy(wout,Pos(#10+'Longitud: ',wout)+10,length(wout));
      tamano:=Copy(tamano,Pos('(',tamano)+1,length(tamano));
      tamano:=Copy(tamano,0,Pos(')',tamano)-1);
    end;
    if Pos(#10+'Length: ',wout)>0 then
    begin
      tamano:=Copy(wout,Pos(#10+'Length: ',wout)+8,length(wout));
      tamano:=Copy(tamano,Pos('(',tamano)+1,length(tamano));
      tamano:=Copy(tamano,0,Pos(')',tamano)-1);
    end;

    if Pos(' guardado [',wout)>0 then
    begin
      descargado:=Copy(wout,Pos(' guardado [',wout)+11,length(wout));
      descargado:=Copy(tamano,0,Pos('/',tamano)-1);
    end;
    if Pos(' saved [',wout)>0 then
    begin
      descargado:=Copy(wout,Pos(' saved [',wout)+8,length(wout));
      descargado:=Copy(tamano,0,Pos('/',tamano)-1);
    end;
    if Pos('/',tamano)>0 then
      tamano:='';
    //wget 1.16 cambios en la salida
    if (Pos('% [',wout)>0) or (Pos('%[',wout)>0)  then
    begin
      if (Pos('% [',wout)>0) then
      begin
        porciento:=Copy(wout,Pos('% [',wout)-2,3);
        velocidad:=Copy(wout,Pos('/s',wout)-6,8);
      end
      else
      begin
        porciento:=Copy(wout,Pos('%[',wout)-2,3);
        velocidad:=Copy(wout,Pos('/s ',wout)-7,9);
      end;
      descargado:=Copy(wout,Pos(']',wout)+1,Length(wout));
      descargado:=ExtractWord(1,descargado,[' ']);
      if Pos(':',descargado)>0 then
        descargado:='';
      if Pos('T.E. ',wout)>0 then
      begin
        tiempo:=Copy(wout,Pos('T.E. ',wout)+5,length(wout));
      end;
      if Pos(' eta ',wout)>0 then
      begin
        tiempo:=Copy(wout,Pos(' eta ',wout)+5,length(wout));
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
    if Pos(' guardado [',wout)>0 then
    begin
      descargado:=Copy(wout,Pos(' guardado [',wout)+11,length(wout));
      descargado:=Copy(descargado,0,Pos('/',descargado)-1);
    end;
    if Pos(' saved [',wout)>0 then
    begin
      descargado:=Copy(wout,Pos(' saved [',wout)+8,length(wout));
      descargado:=Copy(descargado,0,Pos('/',descargado)-1);
    end;
    if Pos('<=>',wout)>0 then
    begin
      if Pos('B/s ',wout)>0 then
        velocidad:=Copy(wout,Pos('B/s ',wout)-6,9)
      else
        velocidad:=Copy(wout,Pos('/s ',wout)-5,7);
      descargado:=Copy(wout,Pos('] ',wout)+2,Length(wout));
      //descargado:=Copy(descargado,0,Pos(' ',descargado));
      descargado:=ExtractWord(1,descargado,[' ']);
    end;
    /////Extract the file name from the output if filename is ''
    if frmain.lvMain.Items[thid].SubItems[columnname]='' then
    begin
      if (Pos(': `',wout)>0) and (Pos(LineEnding,wout)>0) then
      begin
        nombre:=Copy(wout,Pos(': `',wout)+3,Length(wout));
        nombre:=Copy(nombre,0,Pos(LineEnding,nombre)-2);
      end;
      if (Pos(': “',wout)>0) and (Pos(LineEnding,wout)>0) then
      begin
        nombre:=Copy(wout,Pos(': “',wout)+5,Length(wout));
        nombre:=Copy(nombre,0,Pos(LineEnding,nombre)-4);
      end;
      if (Pos(': ''',wout)>0) and (Pos(LineEnding,wout)>0) then
      begin
        nombre:=Copy(wout,Pos(': ''',wout)+3,Length(wout));
        nombre:=Copy(nombre,0,Pos(LineEnding,nombre)-2);
      end;

      if Pos('/',nombre)>0 then
          nombre:=Copy(nombre,LastDelimiter('/',nombre)+1,Length(nombre));
      if Pos('\',nombre)>0 then
          nombre:=Copy(nombre,LastDelimiter('\',nombre)+1,Length(nombre));
      frmain.lvMain.Items[thid].SubItems[columnname]:=nombre;
      logrename:=true;
    end;
  end;
  ///////////////////***END***///////////////////

  ///////////////////***ARIA2***///////////////////
  if (frmain.lvMain.Items[thid].SubItems[columnengine] = 'aria2c') or (youtubedlthexternal='aria2c') or ((youtubedlextdown='aria2c') and youtubedluseextdown and (frmain.lvMain.Items[thid].SubItems[columnengine]='youtube-dl')) then
  begin
    /////When a metalink or torrent complete he continue as P2P server
    if (frmain.lvMain.Items[thid].SubItems[columnstatus]<>'3') and (Pos('magnet:',frmain.lvMain.Items[thid].SubItems[columnurl])=1) then
    begin
      if Pos(' SEED(0.',wout)>0 then
      begin
        frmain.lvMain.Items[thid].SubItems[columnstatus]:='3';
        frmain.lvMain.Items[thid].Caption:=fstrings.statuscomplete;
        frmain.lvMain.Items[thid].SubItems[columnpercent]:='100%';
        frmain.lvMain.Items[thid].SubItems[columnestimate]:='--';
        frmain.lvMain.Items[thid].SubItems[columnspeed]:='--';
        frmain.lvMain.Items[thid].StateIndex:=4;
        if frmain.lvFilter.Visible then
        begin
          frmain.lvFilter.Items[thid2].SubItems[columnstatus]:='3';
          frmain.lvFilter.Items[thid2].Caption:=fstrings.statuscomplete;
          frmain.lvFilter.Items[thid2].SubItems[columnpercent]:='100%';
          frmain.lvFilter.Items[thid2].SubItems[columnestimate]:='--';
          frmain.lvFilter.Items[thid2].SubItems[columnspeed]:='--';
          frmain.lvFilter.Items[thid2].StateIndex:=4;
        end;
      end;
    end;
    if Pos('%) ',wout)>0 then
    begin
      porciento:=Copy(wout,Pos('B(',wout)+2,length(wout));
      porciento:=Copy(porciento,0,Pos('%)',porciento));
      if Pos(' ETA:',wout)>0 then
      begin
        tiempo:=Copy(wout,Pos(' ETA:',wout)+5,length(wout));
        tiempo:=Copy(tiempo,0,Pos(']',tiempo)-1);
      end;
      if Pos(' SIZE:',wout)>0 then
      begin
        tamano:=Copy(wout,Pos('B/',wout)+2,length(wout));
        tamano:=Copy(tamano,0,Pos('(',tamano)-1);
        descargado:=Copy(wout,Pos(' SIZE:',wout)+6,length(wout));
        descargado:=Copy(descargado,0,Pos('/',descargado)-1);
      end;
      //aria2 1.18 cambios en la salida
      if Pos('[#',wout)>0 then
      begin
        tamano:=Copy(wout,Pos('B/',wout)+2,length(wout));
        tamano:=Copy(tamano,0,Pos('(',tamano)-1);
        descargado:=Copy(wout,Pos('[#',wout)+9,length(wout));
        descargado:=Copy(descargado,0,Pos('/',descargado)-1);
      end;
    end;
    if (Pos('[',wout)>0) and (Pos(']',wout)>0) then
    begin
      velocidad:=Copy(wout,Pos('[',wout),Length(wout));
      velocidad:=Copy(velocidad,0,Pos(']',velocidad));
      if Pos(' SPD:',velocidad)>0 then
        velocidad:=Copy(velocidad,Pos(' SPD:',velocidad)+5,length(velocidad))
      else
      begin
        if Pos(' DL:',velocidad)>0 then
          velocidad:=Copy(velocidad,Pos(' DL:',velocidad)+4,length(velocidad))
        else
          velocidad:='';
      end;
      if Pos('Bs]',velocidad)>0 then
        velocidad:=Copy(velocidad,0,Pos('Bs]',velocidad));
      if Pos('B]',velocidad)>0 then
        velocidad:=Copy(velocidad,0,Pos('B]',velocidad));
      if Pos('Bs ETA:',velocidad)>0 then
        velocidad:=Copy(velocidad,0,Pos('Bs ETA:',velocidad));
      if Pos('B ETA:',velocidad)>0 then
        velocidad:=Copy(velocidad,0,Pos('B ETA:',velocidad));
      //Case metalink, torrent etc
      if Pos('B UL:',velocidad)>0 then
        velocidad:=Copy(velocidad,0,Pos('B UL:',velocidad));
    end;
    if (porciento='') and (frmain.lvMain.Items[thid].SubItems[columnpercent]='-')   then
    begin
      if FindFirst(UTF8ToSys(frmain.lvMain.Items[thid].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[thid].SubItems[columnname]),faAnyFile,itemfile)=0 then
      begin
        Repeat
          try
            descargado:=prettysize(itemfile.Size,'aria2c',-1);
          except
          on E:Exception do
          end;
        Until FindNext(itemfile)<>0;
      end;
    end;
    /////Extract the file name from the output if filename is ''
    if frmain.lvMain.Items[thid].SubItems[columnname]='' then
    begin
      if (Pos('FILE: ',wout)>0) then
      begin
        nombre:=Copy(wout,Pos('FILE: ',wout)+6,Length(wout));
        nombre:=Copy(nombre,0,Pos(#10,nombre)-1);
        if Pos('/',nombre)>0 then
          nombre:=Copy(nombre,LastDelimiter('/',nombre)+1,Length(nombre));
        if Pos('\',nombre)>0 then
          nombre:=Copy(nombre,LastDelimiter('\',nombre)+1,Length(nombre));
        frmain.lvMain.Items[thid].SubItems[columnname]:=nombre;
        logrename:=true;
      end;
    end;
  end;
  /////////////////////***END***//////////////////////

  ////////////////////***CURL***//////////////////////
  if (frmain.lvMain.Items[thid].SubItems[columnengine] = 'curl') or (youtubedlthexternal='curl') or ((youtubedlextdown='curl') and youtubedluseextdown and (frmain.lvMain.Items[thid].SubItems[columnengine]='youtube-dl')) then
  begin
    if (Pos(':',wout)>0) and (WordCount(wout,[' '])=13) then
    begin
      porciento:=ExtractWord(WordCount(wout,[' '])-11,wout,[' '])+'%';
      velocidad:=ExtractWord(WordCount(wout,[' ']),wout,[' ']);
      tiempo:=ExtractWord(WordCount(wout,[' '])-1,wout,[' ']);
      tamano:=ExtractWord(WordCount(wout,[' '])-10,wout,[' ']);
      descargado:=ExtractWord(WordCount(wout,[' '])-8,wout,[' ']);
    end;
    ///with not support ranges
    if (Pos(':',wout)>0) and (WordCount(wout,[' '])=12) then
    begin
      velocidad:=ExtractWord(WordCount(wout,[' ']),wout,[' ']);
      descargado:=ExtractWord(2,wout,[' ']);
    end;
    /////Extract the file name from the output if filename is ''
    if frmain.lvMain.Items[thid].SubItems[columnname]='' then
    begin
      if (Pos('< Content-Disposition: attachment; filename="',wout)>0) and (Pos(LineEnding,wout)>0) then
      begin
        nombre:=Copy(wout,Pos('< Content-Disposition: attachment; filename="',wout)+45,Length(wout));
        nombre:=Copy(nombre,0,Pos('";',nombre)-1);
        if Pos('/',nombre)>0 then
          nombre:=Copy(nombre,LastDelimiter('/',nombre)+1,Length(nombre));
        if Pos('\',nombre)>0 then
          nombre:=Copy(nombre,LastDelimiter('\',nombre)+1,Length(nombre));
        frmain.lvMain.Items[thid].SubItems[columnname]:=SysToUTF8(nombre);
        logrename:=true;
      end;
    end;
  end;
  ///////////////////***END***////////////////////////

  ///////////////////***AXEL***////////////////////////
  if (frmain.lvMain.Items[thid].SubItems[columnengine] = 'axel') or (youtubedlthexternal='axel') or ((youtubedlextdown='axel') and youtubedluseextdown and (frmain.lvMain.Items[thid].SubItems[columnengine]='youtube-dl')) then
  begin
    if Pos('File size: ',wout)>0 then
      tamano:=Copy(wout,Pos('File size: ',wout)+11,length(wout));
    tamano:=Copy(tamano,0,Pos('bytes',tamano)-1);
     if (Pos('%] [',wout)>0) and (WordCount(wout,[']'])>=4) then
    begin
      porciento:=ExtractWord(1,wout,[']']);
      porciento:=Copy(porciento,Pos('[',porciento)+1,length(porciento)-1);
      velocidad:=ExtractWord(WordCount(wout,[']'])-1,wout,[']']);
      velocidad:=Copy(velocidad,Pos('[',velocidad)+1,length(velocidad)-1);
      tiempo:=ExtractWord(4,wout,[']']);
      tiempo:=Copy(tiempo,Pos('[',tiempo)+1,length(tiempo)-1);
    end;
    if Length(tiempo)>8 then
      tiempo:='';
    if (porciento <>'') and (frmain.lvMain.Items[thid].SubItems[columnsize]<>'') then
    begin
      try
        porciento:=StringReplace(porciento,' ','',[rfReplaceAll]);
        descargado:=inttostr(Round(strtoint(StringReplace(frmain.lvMain.Items[thid].SubItems[columnsize],' ','',[rfReplaceAll]))*strtoint(StringReplace(porciento,'%','',[rfReplaceAll])) div 100));
      except on e:exception do
      end;
    end
    else
    begin
      if FindFirst(UTF8ToSys(frmain.lvMain.Items[thid].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[thid].SubItems[columnname]),faAnyFile,itemfile)=0 then
      begin
        Repeat
          try
            descargado:=prettysize(itemfile.Size,'axel',-1);
          except
          on E:Exception do
          end;
        Until FindNext(itemfile)<>0;
      end;
    end;
    /////Extract the file name from the output if filename is ''
    if frmain.lvMain.Items[thid].SubItems[columnname]='' then
    begin
      if (Pos('Opening output file ',wout)>0) {and (Pos(LineEnding,wout)>0)} then
      begin
        nombre:=Copy(wout,Pos('Opening output file ',wout)+20,Length(wout));
        if Pos('State file found:',nombre)>0 then
          nombre:=Copy(nombre,0,Pos('State file found:',nombre)-2)
        else
          nombre:=Copy(nombre,0,Pos(#10,nombre)-1);

        if Pos('/',nombre)>0 then
          nombre:=Copy(nombre,LastDelimiter('/',nombre)+1,Length(nombre));
        if Pos('\',nombre)>0 then
          nombre:=Copy(nombre,LastDelimiter('\',nombre)+1,Length(nombre));
        frmain.lvMain.Items[thid].SubItems[columnname]:=nombre;
        logrename:=true;
      end;
    end;
  end;
  ////////////////////***END***////////////////////////////

  ////////////////////***YOUTUBE-DL***///////////////////////////
  if frmain.lvMain.Items[thid].SubItems[columnengine] = 'youtube-dl' then
  begin
    if ((Pos('[download]  ',wout)>0) and (Pos('in',wout)<1)) and (((youtubedluseextdown=false) and (youtubedlthexternal='')) or youtubeplaylist)  then
    begin
      porciento:=ExtractWord(WordCount(wout,[' '])-6,wout,[' ']);
      if Pos('.',porciento)>0 then
        porciento:=Copy(porciento,0,Pos('.',porciento)-1)+'%';
      velocidad:=ExtractWord(WordCount(wout,[' '])-2,wout,[' ']);
      tiempo:=ExtractWord(WordCount(wout,[' ']),wout,[' ']);
      tamano:=ExtractWord(WordCount(wout,[' '])-4,wout,[' ']);
    end;

    ///Determine the downloaded size base on the percent
    if (youtubedlthexternal='') and ((youtubedluseextdown=false) or youtubeplaylist) then
    begin
      if frmain.lvMain.Items[thid].SubItems[columnsize]<>'' then
      begin
        try
          tmppercent:=strtoint(StringReplace(frmain.lvMain.Items[thid].SubItems[columnpercent],'%','',[rfReplaceAll]));
          if Pos('GiB',frmain.lvMain.Items[thid].SubItems[columnsize])>0 then
          begin
            tmpsize:=strtofloat(StringReplace(StringReplace(frmain.lvMain.Items[thid].SubItems[columnsize],'GiB','',[rfReplaceAll]),'.',',',[rfReplaceAll]));
            descargado:=prettysize(Round(tmppercent*0.01*(tmpsize*1024*1024*1024)),'youtube-dl',-2,'.');
          end;
          if Pos('MiB',frmain.lvMain.Items[thid].SubItems[columnsize])>0 then
          begin
            tmpsize:=strtofloat(StringReplace(StringReplace(frmain.lvMain.Items[thid].SubItems[columnsize],'MiB','',[rfReplaceAll]),'.',',',[rfReplaceAll]));
            descargado:=prettysize(Round(tmppercent*0.01*(tmpsize*1024*1024)),'youtube-dl',-2,'.');
          end;
          if Pos('KiB',frmain.lvMain.Items[thid].SubItems[columnsize])>0 then
          begin
            tmpsize:=strtofloat(StringReplace(StringReplace(frmain.lvMain.Items[thid].SubItems[columnsize],'KiB','',[rfReplaceAll]),'.',',',[rfReplaceAll]));
            descargado:=prettysize(Round(tmppercent*0.01*(tmpsize*1024)),'youtube-dl',-2,'.');
          end;
        except on E:Exception do
          //descargado:=e.message;
        end;
      end
      else
      begin
        if FindFirst(UTF8ToSys(frmain.lvMain.Items[thid].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[thid].SubItems[columnname]),faAnyFile,itemfile)=0 then
        begin
          Repeat
            try
              descargado:=prettysize(itemfile.Size,'youtube-dl',-2,'.');
            except
            on E:Exception do
            end;
          Until FindNext(itemfile)<>0;
        end;
      end;
    end;

    /////Extract the file name from the output if filename is ''
    if ((frmain.lvMain.Items[thid].SubItems[columnname]='') and (youtubedluseextdown=false)) or youtubeplaylist then
    begin
      if (Pos('[download] Destination: ',wout)>0) and (Pos(#10,wout)>0) then
      begin
        nombre:=Copy(wout,Pos('[download] Destination: ',wout)+24,Length(wout));
        nombre:=Copy(nombre,0,Pos(#10,nombre)-1);
        if Pos('/',nombre)>0 then
          nombre:=Copy(nombre,LastDelimiter('/',nombre)+1,Length(nombre));
        if Pos('\',nombre)>0 then
          nombre:=Copy(nombre,LastDelimiter('\',nombre)+1,Length(nombre));
        frmain.lvMain.Items[thid].SubItems[columnname]:=SysToUTF8(nombre);
        logrename:=true;
      end;
    end;
    if youtubedluseextdown and (youtubeplaylist=false) and (youtubeuri='') then
    begin
      if ((Pos('http://',wout)>0) or (Pos('https://',wout)>0)) and (Pos('ERROR:',wout)<1) then
      begin
        sltofindtext:=TStringList.Create;
        sltofindtext.AddText(wout);
        for sli:=0 to sltofindtext.Count-1 do
        begin
          //ShowMessage(sltofindtext[sli]);
          if ((Pos('http://',sltofindtext[sli])=1) or (Pos('https://',sltofindtext[sli])=1)) then
          begin
            youtubeuri:=sltofindtext[sli];
            break;
          end;
        end;
        {youtubeuri:=ExtractWord(WordCount(wout,[#10])-1,wout,[#10]);
        //The first URL is the video
        if Pos('http',ExtractWord(WordCount(wout,[#10])-2,wout,[#10]))>0 then
          youtubeuri:=ExtractWord(WordCount(wout,[#10])-2,wout,[#10]);
        //ShowMessage(youtubeuri);

        youtubeuri:=StringReplace(youtubeuri,LineEnding,'',[rfReplaceAll]);
        youtubeuri:=StringReplace(youtubeuri,#10,'',[rfReplaceAll]);
        youtubeuri:=StringReplace(youtubeuri,#13,'',[rfReplaceAll]);
        youtubeuri:=StringReplace(youtubeuri,#10#13,'',[rfReplaceAll]);
        youtubeuri:=StringReplace(youtubeuri,#13#10,'',[rfReplaceAll]);}

        if (frmain.lvMain.Items[thid].SubItems[columnname]='') then
        begin
          nombre:=ExtractWord(WordCount(wout,[#10]),wout,[#10]);
          //ShowMessage(nombre);

          nombre:=StringReplace(nombre,LineEnding,'',[rfReplaceAll]);
          nombre:=StringReplace(nombre,#10,'',[rfReplaceAll]);
          nombre:=StringReplace(nombre,#13,'',[rfReplaceAll]);
          nombre:=StringReplace(nombre,#10#13,'',[rfReplaceAll]);
          nombre:=StringReplace(nombre,#13#10,'',[rfReplaceAll]);
          frmain.lvMain.Items[thid].SubItems[columnname]:=SysToUTF8(nombre);
          logrename:=true;
        end;
        //ShowMessage('youtubeuri: '+youtubeuri);
        //ShowMessage('nombre: '+nombre);
      end;
    end;
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
        if (nombre<>'') and (frmain.lvFilter.Items[thid2].SubItems[columnname]='') then
          frmain.lvFilter.Items[thid2].SubItems[columnname]:=AnsiReplaceStr(nombre,LineEnding,'');
      end;
    end;
  end;
  ////////////////////////////////////
  try
    if (porciento<>'') and (thid=frmain.lvMain.ItemIndex) then
    begin
      frmain.pbMain.Style:=pbstNormal;
      //if (strtoint(Copy(porciento,0,Pos('%',porciento)-1))<=100) and (strtoint(Copy(porciento,0,Pos('%',porciento)-1))>=0) then
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
  if trayicons[thid].Visible then
  begin
  icono:=Graphics.TBitmap.Create();
  if internet then
  begin
    icono.Width:=frmain.MainTrayIcon.Icon.Width;
    icono.Height:=frmain.MainTrayIcon.Icon.Height;
  end
  else
  begin
    icono.Width:=32;
    icono.Height:=32;
  end;
  icono.Canvas.Brush.Color:=clWhite;
  icono.Canvas.Pen.Color:=clBlack;
  if frmain.lvMain.Items[thid].SubItems[columnstatus]='1' then
    icono.Canvas.Font.Color:=clBlack
  else
    icono.Canvas.Font.Color:=clRed;
  icono.Canvas.Font.Bold:=true;
  icono.Canvas.Font.Quality:=fqAntialiased;
  icono.Canvas.Font.Size:=trayiconfontsize;
  icono.Canvas.Pen.Width:=1;
  icono.Canvas.Rectangle(1,1,icono.Width,icono.Height);
  icono.Canvas.Pen.Width:=3;
  if porciento<>'-' then
  begin
    porciento:=StringReplace(porciento,'%','',[rfReplaceAll]);
  end
  else
    porciento:='?';

   porciento:=StringReplace(porciento,' ','',[rfReplaceAll]);
   porciento:=StringReplace(porciento,LineEnding,'',[rfReplaceAll]);
   porciento:=StringReplace(porciento,#10,'',[rfReplaceAll]);
   porciento:=StringReplace(porciento,#13,'',[rfReplaceAll]);

  while(icono.Canvas.TextWidth(porciento)>(icono.Width-4)) or (icono.Canvas.TextHeight(porciento)>(icono.Height-2)) and (Length(porciento)<6) do
  begin
    icono.Canvas.Font.Size:=icono.Canvas.Font.Size-1;
    trayiconfontsize:=icono.Canvas.Font.Size;
  end;


  th:=icono.Canvas.TextHeight(porciento);
  tw:=icono.Canvas.TextWidth(porciento);

  icono.Canvas.TextOut(Round((icono.Width-tw)/2),Round((icono.Height-th)/2),porciento);
  trayicons[thid].Icon.Canvas.Brush.Color:=clWhite;
  trayicons[thid].Icon.Assign(icono);
  {$IFDEF LCLQT OR LCLQT5}
  trayicons[thid].Animate:=true;///////////In QT the icon not update without this
  trayicons[thid].AnimateInterval:=0;//////and the interval must by the minimun for not blink
  {$ENDIF}
  trayicons[thid].Hint:=frmain.lvMain.Items[thid].SubItems[columnname]+' '+velocidad;
  icono.Destroy;
  end;
end;

procedure DownThread.changestatus;
begin
  frmain.lvMain.Items[thid].Caption:=fstrings.statusinprogres;
  if frmain.lvFilter.Visible then
  begin
    if (frmain.lvFilter.Items.Count>thid2) then
      frmain.lvFilter.Items[thid2].Caption:=fstrings.statusinprogres;
  end;
end;

Constructor GetThread.Create(CreateSuspended:boolean;gparams:TStringList);
begin
  FreeOnTerminate:=True;
  inherited Create(CreateSuspended);
  gthp:=TProcess.Create(nil);
  gpr:=TStringList.Create;
  gpr.AddStrings(gparams);
  completado:=false;
  manualshutdown:=false;
end;

procedure GetThread.update;
begin
  case worktype of
    0:////Get video formats for youtube-dl
    begin
      if Length(frvideoformat.lblSelectFormat.Caption)<(Length(videoformatloading)+25) then
      begin
        frvideoformat.lblSelectFormat.Caption:=frvideoformat.lblSelectFormat.Caption+'.';
      end
      else
        frvideoformat.lblSelectFormat.Caption:=videoformatloading;
    end;
    1:////Get video name for youtube-dl
    begin
      if Length(frvideoformat.lblVideoName.Caption)<(Length(videonameloading)+25) then
      begin
        frvideoformat.lblVideoName.Caption:=frvideoformat.lblVideoName.Caption+'.';
      end
      else
        frvideoformat.lblVideoName.Caption:=videonameloading;
    end;
    2:////Update video names
    begin

    end;
    3:////Check for software updates
    begin

    end;
  end;
end;

procedure GetThread.prepare;
var
  slformats,slvname:TStringList;
  i:integer;
  lvItem:TListItem;
  tmpvname:string='';
begin
  case worktype of
    0:////Get video formats for youtube-dl
    begin
      if Pos('[info] Available formats for',gout)>0 then
      begin
        gout:=Copy(gout,Pos('[info] Available formats for',gout),Length(gout));
        slformats:=TStringList.Create;
        slformats.AddText(gout);
        frvideoformat.lblSelectFormat.Caption:=videoselectformat;
      for i:=2 to slformats.Count-1 do
      begin
        if ExtractWord(2,slformats[i],[' '])<>'code' then
        begin
          lvItem:=TListItem.Create(frvideoformat.lvFormats.Items);
          lvitem.Caption:=ExtractWord(2,slformats[i],[' ']);
          lvitem.SubItems.Add(Copy(slformats[i],Pos(ExtractWord(3,slformats[i],[' ']),slformats[i]),Length(slformats[i])));
          lvitem.SubItems.Add(ExtractWord(1,slformats[i],[' ']));
          frvideoformat.lvFormats.Items.AddItem(lvItem);
        end;
      end;
      end
      else
        frvideoformat.lblSelectFormat.Caption:=errorloadingformat;
      frvideoformat.btnReload.Enabled:=true;
    end;
    1:////Get video name for youtube-dl
    begin
      if Pos('ERROR:',gout)<1 then
      begin
        slvname:=TStringList.Create;
        slvname.AddText(gout);
        fvideoformat.vname:=SysToUTF8(StringReplace(slvname[slvname.Count-1],LineEnding,'',[rfReplaceAll]));
        frvideoformat.lblName.Caption:=fvideoformat.vname;
        frvideoformat.lblVideoName.Caption:=videoname;
        slvname.Destroy;
      end
      else
        frvideoformat.lblVideoName.Caption:=errorloadingname;
      frvideoformat.btnReload.Enabled:=true;
    end;
    2:////Update video names
    begin
      if Pos('ERROR:',gout)<1 then
      begin
        slvname:=TStringList.Create;
        slvname.AddText(gout);
        for i:=0 to frmain.lvMain.Items.Count-1 do
        begin
          if (frmain.lvMain.Items[i].SubItems[columnid]=downloadid) and (frmain.lvMain.Items[i].SubItems[columnname]='') then
          begin
            tmpvname:=SysToUTF8(StringReplace(slvname[slvname.Count-1],LineEnding,'',[rfReplaceAll]));
            frmain.lvMain.Items[i].SubItems[columnname]:=tmpvname;
          end;
          if FileExists(UTF8ToSys(frmain.lvMain.Items[i].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[i].SubItems[columnname])) then
            frmain.lvMain.Items[i].StateIndex:=4;
        end;
        if frmain.lvFilter.Visible then
        begin
          for i:=0 to frmain.lvFilter.Items.Count-1 do
          begin
             if (frmain.lvFilter.Items[i].SubItems[columnid]=downloadid) then
             begin
               frmain.lvFilter.Items[i].SubItems[columnname]:=tmpvname;
               frmain.lvFilter.Items[i].StateIndex:=4;
             end;
          end;
        end;
        slvname.Destroy;
        savemydownloads();
      end;
      //else
        //ShowMessage('Error al optener el nombre de '+self.downloadid);
    end;
  end;
end;

procedure GetThread.shutdown;
var
  milisegundos:integer;
begin
  manualshutdown:=true;
  milisegundos:=1000;
  while (gthp.Running) and (milisegundos>0) do
  begin
    Dec(milisegundos);
    Sleep(10);
    Application.ProcessMessages;
  end;
  if (gthp.Running) then
  begin
    gthp.Terminate(0);
    prepare();
  end;
end;

procedure GetThread.Execute;
var
  CharBuffer: array [0..2047] of char;
  ReadCount: integer;
begin
  completado:=false;
  gthp.Options:=[poUsePipes,poStderrToOutPut,poNoConsole];
  Case gengine of
    'wget':
    begin
      gthp.Executable:=UTF8ToSys(wgetrutebin);
    end;
    'aria2c':
    begin
      gthp.Executable:=UTF8ToSys(aria2crutebin);
    end;
    'curl':
    begin
      gthp.Executable:=UTF8ToSys(curlrutebin);
    end;
    'axel':
    begin
      gthp.Executable:=UTF8ToSys(axelrutebin);
    end;
    'youtube-dl':
    begin
      gthp.Executable:=UTF8ToSys(youtubedlrutebin);
     end;
  end;
  gthp.Parameters.AddStrings(gpr);
  gpr.Free;
  try
    gthp.Execute;

    while (gthp.Running or (gthp.Output.NumBytesAvailable > 0)) and (not manualshutdown) do
    begin
      {$IFDEF UNIX}
        if gthp.Output.NumBytesAvailable > 0 then
        begin
      {$ENDIF}
          ReadCount := Min(2048, gthp.Output.NumBytesAvailable); //Solo leer hasta llenar el buffer
          gthp.Output.Read(CharBuffer, ReadCount);
          if worktype=0 then
            gout+=Copy(CharBuffer, 0, ReadCount)
          else
            gout:=Copy(CharBuffer, 0, ReadCount);
          if (Pos('(OK):download',gout)>0) or (Pos('100%[',gout)>0) or (Pos('%AWGG100OK%',gout)>0) or (Pos('[100%]',gout)>0) or (Pos(' guardado [',gout)>0) or (Pos(' saved [',gout)>0) or (Pos('ERROR 400: Bad Request.',gout)>0) or (Pos('The file is already fully retrieved; nothing to do.',gout)>0) or (Pos('El fichero ya ha sido totalmente recuperado, no hay nada que hacer.',gout)>0) then
            completado:=true;
      {$IFDEF UNIX}
        end;
      {$ENDIF}
        Synchronize(@update);
        sleep(1000);//Sin esto el consumo de CPU es muy alto
    end;
  Except on E:Exception do
    begin
    //gout:='ERROR!**** '+E.ToString; //Solo para debug
    //Synchronize(@update);                 //Solo para debug
    end;
  end;
  Synchronize(@prepare);
  if manualshutdown then
  begin
    {$IFDEF UNIX}
    fpKill(gthp.ProcessID,SIGTERM);
    fpKill(gthp.ProcessID,SIGKILL);
    {$ELSE}
    gthp.Terminate(0);
    {$ENDIF}
  end;
  gthp.Destroy;
  self.Terminate;
end;

{Constructor ClipboardThread.Create(CreateSuspended:boolean);
begin
  FreeOnTerminate:=True;
  inherited Create(CreateSuspended);
  uri:='';
end;

procedure ClipboardThread.update;
begin
  //frmain.Caption:=uri;
end;

procedure ClipboardThread.prepare;
begin
  frnewdown.edtURL.Text:=uri;
  frmain.tbAddDownClick(nil);
end;

procedure ClipboardThread.Execute;
var
  cbn:integer;
  noesta:boolean;
  tmpclip:string='';
begin
  Repeat
    noesta:=true;
    Synchronize(@prepare);
    if ClipBoard.HasFormat(CF_TEXT) then
    begin
    if uri<>ClipBoard.AsText then
    begin
      uri:=ClipBoard.AsText;
      tmpclip:=Copy(uri,0,6);
      if (tmpclip='http:/') or (tmpclip='https:') or (tmpclip='ftp://') then
      begin
        for cbn:=0 to frmain.lvMain.Items.Count-1 do
        begin
          if uri=frmain.lvMain.Items[cbn].SubItems[columnurl] then
            noesta:=false;
        end;
        end;
        if noesta then
        begin
          //frmain.ClipBoardTimer.Enabled:=false;
          Synchronize(@prepare);
          //frmain.ClipBoardTimer.Enabled:=true;
        end;
      end;
      tmpclip:='';
      Synchronize(@update);
    end;
    Sleep(5000);
  Until false;
end;}

procedure getyoutubeformats(URL:String);
var
  gparams:TStringList;
  lvItem:TListItem;
  vformats:TStringList;
  i:integer;
begin
  frvideoformat.lvFormats.Items.Clear;
  ////Add a list of default formats
  vformats:=TStringList.Create;
  vformats.Add('mp4');
  vformats.Add('mkv');
  vformats.Add('webm');
  vformats.Add('flv');
  vformats.Add('3gp');
  for i:=0 to vformats.Count-1 do
  begin
    lvItem:=TListItem.Create(frvideoformat.lvFormats.Items);
    lvitem.Caption:=vformats[i];
    lvitem.SubItems.Add(Format(commonvideodescription,[vformats[i]]));
    lvitem.SubItems.Add(vformats[i]);
    frvideoformat.lvFormats.Items.AddItem(lvItem);
    lvItem:=TListItem.Create(frvideoformat.lvFormats.Items);
  end;
  vformats.Clear;
  vformats.Add('m4a');
  for i:=0 to vformats.Count-1 do
  begin
    lvItem:=TListItem.Create(frvideoformat.lvFormats.Items);
    lvitem.Caption:=vformats[i];
    lvitem.SubItems.Add(Format(commonaudiodescription,[vformats[i]]));
    lvitem.SubItems.Add(vformats[i]);
    frvideoformat.lvFormats.Items.AddItem(lvItem);
    lvItem:=TListItem.Create(frvideoformat.lvFormats.Items);
  end;
  ////End list
  frvideoformat.btnReload.Enabled:=false;
  gparams:=TStringList.Create;
  gparams.Add('--ignore-config');
  gparams.Add('--no-playlist');
  gparams.Add('-c');
  gparams.Add('--no-part');
  //gparams.Add('-v');
  //gparams.Add('--newline');
  gparams.Add('--no-check-certificate');
  case useproxy of
    2:
    begin
      gparams.Add('--proxy');
      if useaut then
        gparams.Add('http://'+puser+':'+ppassword+'@'+phttp+':'+phttpport)
      else
        gparams.Add('http://'+phttp+':'+phttpport);
    end;
  end;

  if (frnewdown.edtUser.Caption<>'') and (frnewdown.edtPassword.Caption<>'') then
  begin
    gparams.Add('-u');
    gparams.Add(frnewdown.edtUser.Caption);
    gparams.Add('-p');
    gparams.Add(frnewdown.edtPassword.Caption);
  end;

  if (frnewdown.edtUser.Caption='') and (frnewdown.edtPassword.Caption<>'') then
  begin
    gparams.Add('--video-password');
    gparams.Add(frnewdown.edtPassword.Caption);
  end;

  gparams.Add('-F');
  gparams.Add(URL);
  customgetformats:=GetThRead.Create(true,gparams);
  customgetformats.gengine:='youtube-dl';
  customgetformats.worktype:=0;
  customgetformats.Start;
end;

procedure getyoutubename(URL:String);
var
  gparams:TStringList;
  i:integer;
begin
  ////End list
  frvideoformat.btnReload.Enabled:=false;
  gparams:=TStringList.Create;
  gparams.Add('--ignore-config');
  gparams.Add('--no-playlist');
  gparams.Add('-c');
  gparams.Add('--no-part');
  gparams.Add('--get-filename');
  //gparams.Add('--newline');
  gparams.Add('--no-check-certificate');
  case useproxy of
    2:
    begin
      gparams.Add('--proxy');
      if useaut then
        gparams.Add('http://'+puser+':'+ppassword+'@'+phttp+':'+phttpport)
      else
        gparams.Add('http://'+phttp+':'+phttpport);
    end;
  end;

  if (frnewdown.edtUser.Caption<>'') and (frnewdown.edtPassword.Caption<>'') then
  begin
    gparams.Add('-u');
    gparams.Add(frnewdown.edtUser.Caption);
    gparams.Add('-p');
    gparams.Add(frnewdown.edtPassword.Caption);
  end;

  if (frnewdown.edtUser.Caption='') and (frnewdown.edtPassword.Caption<>'') then
  begin
    gparams.Add('--video-password');
    gparams.Add(frnewdown.edtPassword.Caption);
  end;
  gparams.Add(URL);
  customgetname:=GetThRead.Create(true,gparams);
  customgetname.gengine:='youtube-dl';
  customgetname.worktype:=1;
  customgetname.Start;
end;

procedure updatevideonames(di:string);
var
  gparams:TStringList;
  i:integer;
begin
  for i:=0 to frmain.lvMain.Items.Count-1 do
  begin
    if (frMain.lvMain.Items[i].SubItems[columnname]='') and (frMain.lvMain.Items[i].SubItems[columnengine]='youtube-dl') and (frMain.lvMain.Items[i].SubItems[columnid]=di) then
    begin
      gparams:=TStringList.Create;
      gparams.Add('--ignore-config');
      gparams.Add('--no-playlist');
      gparams.Add('-c');
      gparams.Add('--no-part');
      gparams.Add('--get-filename');
      gparams.Add('--no-check-certificate');
      case useproxy of
        2:
        begin
          gparams.Add('--proxy');
          if useaut then
            gparams.Add('http://'+puser+':'+ppassword+'@'+phttp+':'+phttpport)
          else
            gparams.Add('http://'+phttp+':'+phttpport);
        end;
      end;

      if (frMain.lvMain.Items[i].SubItems[columnuser]<>'') and (frMain.lvMain.Items[i].SubItems[columnpass]<>'') then
      begin
        gparams.Add('-u');
        gparams.Add(frMain.lvMain.Items[i].SubItems[columnuser]);
        gparams.Add('-p');
        gparams.Add(frMain.lvMain.Items[i].SubItems[columnuser]);
      end;

      if (frMain.lvMain.Items[i].SubItems[columnuser]='') and (frMain.lvMain.Items[i].SubItems[columnpass]<>'') then
      begin
        gparams.Add('--video-password');
        gparams.Add(frMain.lvMain.Items[i].SubItems[columnpass]);
      end;
      gparams.Add(frMain.lvMain.Items[i].SubItems[columnurl]);
      customgetname:=GetThRead.Create(true,gparams);
      customgetname.gengine:='youtube-dl';
      customgetname.worktype:=2;
      customgetname.downloadid:=frMain.lvMain.Items[i].SubItems[columnid];
      customgetname.Start;
      gparams.Destroy
    end;
  end;
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
        inidownloadsfile.WriteString('Download'+inttostr(wn),'status',fstrings.statusstoped);
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
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnuser',EncodeBase64(frmain.lvMain.Items[wn].SubItems[columnuser]));
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnpass',EncodeBase64(frmain.lvMain.Items[wn].SubItems[columnpass]));
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
  enginereload();
  frmain.odlgImportdown.Filter:=filterforcenames+'|*.*|'+filternoforcenames+'|*';
  frmain.odlgImportdown.Execute;
  if {$IFDEF LCLQT}(frmain.odlgImportdown.UserChoice=1){$else}{$IFDEF LCLQT5}(frmain.odlgImportdown.UserChoice=1){$ELSE}frmain.odlgImportdown.FileName<>''{$endif}{$ENDIF} then
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
        imitem.Caption:=fstrings.statuspaused;
        imitem.ImageIndex:=18;
        if frmain.odlgImportdown.FilterIndex=1 then
        begin
          fname:=ParseURI(urls[nurl]).Document;
          while destinyexists(defaultdir+pathdelim+fname) do
            fname:='_'+fname;
          imitem.SubItems.Add(fname);//Nombre de archivo
        end
        else
          imitem.SubItems.Add('');
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
  if {$IFDEF LCLQT}frmain.sdlgExportDown.UserChoice=1{$else}{$IFDEF LCLQT5}frmain.sdlgExportDown.UserChoice=1{$ELSE}frmain.sdlgExportDown.FileName<>''{$endif}{$ENDIF} then
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
    frconfirm.Caption:=fstrings.dlgconfirm;
    if delfile then
      frconfirm.dlgtext.Caption:=fstrings.dlgdeletedownandfile+' ['+inttostr(frmain.lvMain.SelCount)+']'+#10#13+#10#13+nombres
    else
      frconfirm.dlgtext.Caption:=fstrings.dlgdeletedown+' ['+inttostr(frmain.lvMain.SelCount)+']'+#10#13+#10#13+nombres;
    frconfirm.ShowModal;
    if dlgcuestion then
    begin
      for i:=total downto 0 do
      begin
        if (frmain.lvMain.Items[i].Selected) and (frmain.lvMain.Items[i].SubItems[columnstatus]<>'1') then
        begin
          //Borrar tambien el historial de la descarga antes de borrar.
          if frmain.lvMain.Items[i].SubItems[columnname]<>'' then
          begin
            if FileExists(UTF8ToSys(logpath+pathdelim+frmain.lvMain.Items[i].SubItems[columnname])+'.log') then
              SysUtils.DeleteFile(UTF8ToSys(logpath+pathdelim+frmain.lvMain.Items[i].SubItems[columnname])+'.log');
            if FileExists(UTF8ToSys(frmain.lvMain.Items[i].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[i].SubItems[columnname])) and delfile and (frmain.lvMain.Items[i].SubItems[columntype]='0') then
              SysUtils.DeleteFile(UTF8ToSys(frmain.lvMain.Items[i].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[i].SubItems[columnname]));
          end
          else
          begin
            if FileExists(UTF8ToSys(logpath+pathdelim+frmain.lvMain.Items[i].SubItems[columnuid])+'.log') then
              SysUtils.DeleteFile(UTF8ToSys(logpath+pathdelim+frmain.lvMain.Items[i].SubItems[columnuid])+'.log');
          end;
          if FileExists(datapath+pathdelim+frmain.lvMain.Items[i].SubItems[columnuid]+'.status') then
            SysUtils.DeleteFile(datapath+pathdelim+frmain.lvMain.Items[i].SubItems[columnuid]+'.status');

          if frmain.lvMain.ItemIndex=i then
            frmain.SynEdit1.Lines.Clear;
          //refreshicons();
          frmain.lvMain.Items.Delete(i);
          hiddetrayicon(i);
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
    ShowMessage(fstrings.msgmustselectdownload);
end;

procedure clearcompletedownloads;
var
  i:integer;
begin
  SetLength(trayicons,frmain.lvMain.Items.Count);
  frconfirm.Caption:=fstrings.dlgconfirm;
  frconfirm.dlgtext.Caption:=msgclearcomplete;
  frconfirm.ShowModal;
  if dlgcuestion then
  begin
    for i:=frmain.lvMain.Items.Count-1 downto 0 do
    begin
      if (frmain.lvMain.Items[i].SubItems[columnstatus]='3') then
      begin
        //Borrar tambien el historial de la descarga antes de borrar.
        if FileExists(UTF8ToSys(logpath+pathdelim+frmain.lvMain.Items[i].SubItems[columnuid])+'.log') then
          SysUtils.DeleteFile(UTF8ToSys(logpath+pathdelim+frmain.lvMain.Items[i].SubItems[columnuid])+'.log');
        if FileExists(datapath+pathdelim+frmain.lvMain.Items[i].SubItems[columnuid]+'.status') then
            SysUtils.DeleteFile(datapath+pathdelim+frmain.lvMain.Items[i].SubItems[columnuid]+'.status');
        if frmain.lvMain.ItemIndex=i then
          frmain.SynEdit1.Lines.Clear;
        frmain.lvMain.Items.Delete(i);
        hiddetrayicon(i);
      end;
    end;
    rebuildids();
    savemydownloads();
    frmain.pbMain.Position:=0;
    if frmain.lvFilter.Visible then
      frmain.tvMainSelectionChanged(nil);
  end;
end;

procedure DownThread.prestop;
begin
  frmain.lvMain.Items[thid].Caption:=fstrings.statusstopping;
  if frmain.lvFilter.Visible then
  begin
    if (frmain.lvFilter.Items.Count>thid2) then
      frmain.lvFilter.Items[thid2].Caption:=fstrings.statusstopping;
  end;
end;

procedure DownThread.shutdown;
begin
  manualshutdown:=true;
  Synchronize(@prestop);
end;

procedure DownThread.Execute;
var
  CharBuffer: array [0..2048] of char;
  ReadCount: integer;
  logfile:TextFile;
  strlogfile:string;
  {$IFDEF WINDOWS}
  ProcessHandle: THandle;
  {$ENDIF}
  tmps:TStringList;
  procedure readoutput;
  begin
    {$IFDEF UNIX}
    //if wthp.Output.NumBytesAvailable > 0 then
    //begin
    {$ENDIF}
      ReadCount := Min(2048, wthp.Output.NumBytesAvailable);
      wthp.Output.Read(CharBuffer, ReadCount);
      wout:=Copy(CharBuffer, 0, ReadCount);
    {$IFDEF UNIX}
    //end;
    {$ENDIF}
    Synchronize(@update);
    try
      if logger then
        Write(logfile,AnsiReplaceStr(AnsiReplaceStr(wout,#13,#10),#10,LineEnding));
    except on e:exception do
    end;
    if (Pos('(OK):download',wout)>0) or (Pos('- Download has already completed:',wout)>0) or (Pos('100%[',wout)>0) or (Pos('%AWGG100OK%',wout)>0) or (Pos('[100%]',wout)>0) or (Pos(' guardado [',wout)>0) or (Pos(' saved [',wout)>0) or (Pos('ERROR 400: Bad Request.',wout)>0) or (Pos('The file is already fully retrieved; nothing to do.',wout)>0) or (Pos('El fichero ya ha sido totalmente recuperado, no hay nada que hacer.',wout)>0) and (frmain.lvMain.Items[thid].SubItems[columntype]='0') then
    completado:=true;
    if (Pos('FINISHED --',wout)>0) or (Pos('Downloaded: ',wout)>0) and (frmain.lvMain.Items[thid].SubItems[columntype]='1') then
    completado:=true;
    //youtube-dl not complete if all playlist was download
    if youtubeplaylist=false then
    begin
      if ((Pos('[download] 100% of ',wout)>0) or (Pos('[download] '+frmain.lvMain.Items[thid].SubItems[columnname]+' has already been downloaded',wout)>0)) and (frmain.lvMain.Items[thid].SubItems[columntype]='0') then
        completado:=true;
    end
    else
    begin
      if (Pos('[download] Finished downloading playlist:',wout)>0) then
        completado:=true;
    end;
    if (Pos('* Connection #0 to host localhost left intact',wout)>0) then
    completado:=true;
    ///This is for the internet login of ETECSA
    if (Pos('Server: NetEngine Server 1.0',wout)>0) and (Pos('Content-Type: text/html',wout)>0) then
      completado:=false;
  end;

  function TrayOrRunning:boolean;
  var
    ptray:boolean=false;
  begin
    if (wthp.Running=false)  and (manualshutdown=false) then
    begin
      readoutput;
      if (tries>0) and (completado=false) and (frmain.lvMain.Items[thid].SubItems[columnengine]='youtube-dl') and ((youtubedluseextdown=false) or youtubeplaylist) and (youtubedlthexternal='')  then
      begin
        wthp.Execute;
        tries-=1;
        ptray:=true;
      end
      else
        ptray:=false;
    end;
   result:=(wthp.Running or ptray);
  end;
begin
  completado:=false;
  wthp.Options:=[poUsePipes,poStderrToOutPut,poNoConsole];
  Case frmain.lvMain.Items[thid].SubItems[columnengine] of
    'wget':wthp.Executable:=UTF8ToSys(wgetrutebin);
    'aria2c':wthp.Executable:=UTF8ToSys(aria2crutebin);
    'curl':wthp.Executable:=UTF8ToSys(curlrutebin);
    'axel':wthp.Executable:=UTF8ToSys(axelrutebin);
    'youtube-dl':
    begin
      {OK TODO : When ytd use external downloader can not kill the child process }
      wthp.Executable:=UTF8ToSys(youtubedlrutebin);
      if wpr.IndexOf('--external-downloader')<>-1 then
        youtubedlthexternal:=LowerCase(Copy(wpr[wpr.IndexOf('--external-downloader')+1],LastDelimiter(pathdelim,wpr[wpr.IndexOf('--external-downloader')+1])+1,Length(wpr[wpr.IndexOf('--external-downloader')+1])));
      if Pos('.',youtubedlthexternal)>0 then
        youtubedlthexternal:=Copy(youtubedlthexternal,0,LastDelimiter('.',youtubedlthexternal)-1);
    end;
  end;
  wthp.Parameters.AddStrings(wpr);

  //wpr.LineBreak:=' ';
  //wout:='********'+wpr.Text+'********';
  //Synchronize(@update);
  //Can not @update before this because this cause write in datapath
  if Not DirectoryExists(datapath) then
    CreateDir(datapath);
  wthp.CurrentDirectory:=UTF8ToSys(frmain.lvMain.Items[thid].SubItems[columndestiny]);
  try
    wthp.Execute;
    try
      if logger then
      begin
        if Not DirectoryExists(logpath) then
          CreateDir(UTF8ToSys(logpath));
        //If better if the log have a safe name
        //if frmain.lvMain.Items[thid].SubItems[columnname]<>'' then
          //strlogfile:=UTF8ToSys(logpath)+PathDelim+UTF8ToSys(frmain.lvMain.Items[thid].SubItems[columnname])+'.log'
        //else
        strlogfile:=UTF8ToSys(logpath)+PathDelim+UTF8ToSys(frmain.lvMain.Items[thid].SubItems[columnuid])+'.log';
        AssignFile(logfile,strlogfile);
        if fileExists(strlogfile) then
          Append(logfile)
        else
          ReWrite(logfile);
      end;
      Synchronize(@changestatus);
    except on e:exception do
    end;
    while (TrayOrRunning or (wthp.Output.NumBytesAvailable > 0)) and (not manualshutdown) do
    begin
      readoutput;
      sleep(1000);//Sin esto el consumo de CPU es muy alto
    end;
    //IF Youtube external use execute the external engine
    if (youtubedluseextdown) and (youtubeplaylist=false) and (youtubeuri<>'') and (frmain.lvMain.Items[thid].SubItems[columnengine]='youtube-dl') then
    begin
      wthp.Parameters.Clear;
      tmps:=TStringList.Create;
      Case youtubedlextdown of
      'wget':
      begin
        wthp.Executable:=UTF8ToSys(wgetrutebin);
        wgetparameters(tmps,thid);
      end;
      'aria2c':
      begin
        wthp.Executable:=UTF8ToSys(aria2crutebin);
        aria2parameters(tmps,thid);
      end;
      'curl':
      begin
        wthp.Executable:=UTF8ToSys(curlrutebin);
        curlparameters(tmps,thid);
      end;
      'axel':
      begin
        wthp.Executable:=UTF8ToSys(axelrutebin);
        axelparameters(tmps,thid);
      end;
      end;
      tmps.Add(youtubeuri);
      wthp.Parameters.AddStrings(tmps);
      //tmps.LineBreak:=' ';
      //wout:='[EXTERNAL] '+wthp.Executable+' '+tmps.Text;
      //Synchronize(@update);
      wthp.Execute;
      tmps.Free;
    end;
    while (TrayOrRunning or (wthp.Output.NumBytesAvailable > 0)) and (not manualshutdown) do
    begin
      readoutput;
      sleep(1000);//Sin esto el consumo de CPU es muy alto
    end;
  Except on E:Exception do
  begin
    //wout:='ERROR!**** '+E.ToString; //Solo para debug
    //Synchronize(@update);                 //Solo para debug
  end;
  end;
  Synchronize(@prepare);
  wout:=LineEnding+datetostr(Date())+' '+timetostr(Time())+#10#13+'Exit code=['+inttostr(wthp.ExitStatus)+']';
  Synchronize(@update);
  if logger then
  begin
    Write(logfile,wout);
    CloseFile(logfile);
  end;
  if manualshutdown then
  begin
    {$IFDEF UNIX}
    fpKill(wthp.ProcessID,SIGTERM);
    fpKill(wthp.ProcessID,SIGKILL);
    //fpKill(wthp.ProcessID,SIGABRT);
    //fpKill(wthp.ProcessID,SIGKILL);
    {$ELSE}
    {$IFDEF WINDOWS}
      ProcessHandle:=OpenProcess(WINDOWS.SYNCHRONIZE or PROCESS_TERMINATE, False, wthp.ProcessID);
      try
        if ProcessHandle<>0 then
        begin
          if TerminateProcess(ProcessHandle,0)=false then
            wthp.Terminate(0);
        end;
      finally
        CloseHandle(ProcessHandle);
      end;
    {$ENDIF ELSE}
    wthp.Terminate(0);
    {$ENDIF}
  end;
  wpr.Free;
  wthp.Destroy;
  if logrename or (frmain.lvMain.Items[thid].SubItems[columnengine]='youtube-dl') then
  begin
    if FileExists(UTF8ToSys(frmain.lvMain.Items[thid].SubItems[columndestiny])+pathdelim+frmain.lvMain.Items[thid].SubItems[columnname]) then
      RenameFile(UTF8ToSys(frmain.lvMain.Items[thid].SubItems[columndestiny])+pathdelim+frmain.lvMain.Items[thid].SubItems[columnname],UTF8ToSys(frmain.lvMain.Items[thid].SubItems[columndestiny]+pathdelim+frmain.lvMain.Items[thid].SubItems[columnname]));
  end;
  //Is better if the log have a safe name
  {if logrename and logger then
  begin
    if FileUtil.CopyFile(strlogfile,UTF8ToSys(logpath)+PathDelim+UTF8ToSys(frmain.lvMain.Items[thid].SubItems[columnname]+'.log')) then
      SysUtils.DeleteFile(strlogfile);
  end;}
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
      ////In some cases with cautive portal and rediection wget report "The file is already fully retrieved; nothing to do." but is not true
      ///Adjust size
      {if (Pos(',',frmain.lvMain.Items[thid].SubItems[columnsize])>0) then
        punto:=',';
      if (Pos('.',frmain.lvMain.Items[thid].SubItems[columnsize])>0) then
        punto:='.';
      if punto<>'' then
        tmpsize:=prettysize(strtoint(frmain.lvMain.Items[thid].SubItems[columncurrent]),'wget',-1,punto)
      else
        tmpsize:=prettysize(strtoint(frmain.lvMain.Items[thid].SubItems[columncurrent]),'wget',0,punto);
      frmain.lvMain.Items[thid].SubItems[columncurrent]:=tmpsize;
      if frmain.lvMain.Items[thid].SubItems[columnsize]<>frmain.lvMain.Items[thid].SubItems[columncurrent] then
        completado:=false;}
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
    if (frmain.lvFilter.Items.Count>=thid2) and (frmain.lvFilter.Items.Count>0) then
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
    frmain.lvMain.Items[thid].Caption:=fstrings.statuscomplete;
    frmain.lvMain.Items[thid].SubItems[columnpercent]:='100%';
    frmain.lvMain.Items[thid].SubItems[columnestimate]:='--';
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
      frmain.lvFilter.Items[thid2].Caption:=fstrings.statuscomplete;
      frmain.lvFilter.Items[thid2].SubItems[columnpercent]:='100%';
      //tama;o automatico
      frmain.lvFilter.Items[thid2].SubItems[columncurrent]:=frmain.lvMain.Items[thid].SubItems[columncurrent];
      frmain.lvFilter.Items[thid2].SubItems[columnspeed]:='--';
      if frmain.lvFilter.Items[thid2].SubItems[columntype] = '0' then
        frmain.lvFilter.Items[thid2].ImageIndex:=4;
      if frmain.lvFilter.Items[thid2].SubItems[columntype] = '1' then
        frmain.lvFilter.Items[thid2].ImageIndex:=54;
    end;
    if (shownotifi) and shownotificomplete and (frmain.Focused=false) then
    begin
      //////Many notifi forms
      //if frmain.lvMain.Items[thid].SubItems[columnname]<>'' then
        createnewnotifi(fstrings.popuptitlecomplete,frmain.lvMain.Items[thid].SubItems[columnname],'',frmain.lvMain.Items[thid].SubItems[columndestiny],true,frmain.lvMain.Items[thid].SubItems[columnuid]);
      //else
        //createnewnotifi(rsForm.popuptitlecomplete.Caption,frmain.lvMain.Items[thid].SubItems[columnurl],'',frmain.lvMain.Items[thid].SubItems[columndestiny],true);
      //////
    end;
    try
      if playsounds and playsoundcomplete and (frmain.Focused=false) then
        playsound(downcompsound);
    except on e:exception do
    end;
    trayicons[thid].Animate:=false;
    trayicons[thid].Icon.Clear;
    trayicons[thid].Visible:=false;
  end
  else
  begin
    if manualshutdown then
    begin
      if frmain.lvMain.Items[thid].SubItems[columnstatus]<>'5' then
        frmain.lvMain.Items[thid].SubItems[columnstatus]:='4'
      else
        frmain.lvMain.Items[thid].SubItems[columnstatus]:='5';

      if frmain.lvMain.Items[thid].SubItems[columnstatus]='4' then
        frmain.lvMain.Items[thid].Caption:=fstrings.statusstoped
      else
        frmain.lvMain.Items[thid].Caption:=fstrings.statuscanceled;

      if (frmain.lvMain.Items[thid].SubItems[columntype] = '0') and (frmain.lvMain.Items[thid].SubItems[columnstatus]='4') then
        frmain.lvMain.Items[thid].ImageIndex:=3;
      if (frmain.lvMain.Items[thid].SubItems[columntype] = '0') and (frmain.lvMain.Items[thid].SubItems[columnstatus]='5') then
        frmain.lvMain.Items[thid].ImageIndex:=63;

      if frmain.lvMain.Items[thid].SubItems[columntype] = '1' then
        frmain.lvMain.Items[thid].ImageIndex:=53;
      if otherlistview then
      begin
        if frmain.lvMain.Items[thid].SubItems[columnstatus]<>'5' then
          frmain.lvFilter.Items[thid2].SubItems[columnstatus]:='4'
        else
          frmain.lvFilter.Items[thid2].SubItems[columnstatus]:='5;';

        if frmain.lvMain.Items[thid].SubItems[columnstatus]='4' then
          frmain.lvFilter.Items[thid2].Caption:=fstrings.statusstoped
        else
          frmain.lvFilter.Items[thid2].Caption:=fstrings.statuscanceled;

        if frmain.lvMain.Items[thid2].SubItems[columntype] = '0' then
          frmain.lvFilter.Items[thid2].ImageIndex:=3;
        if frmain.lvFilter.Items[thid2].SubItems[columntype] = '1' then
          frmain.lvFilter.Items[thid2].ImageIndex:=53;
      end;
    end
    else
    begin
      frmain.lvMain.Items[thid].SubItems[columnstatus]:='4';
      frmain.lvMain.Items[thid].Caption:=fstrings.statuserror;
      if frmain.lvMain.Items[thid].SubItems[columntype] = '0' then
        frmain.lvMain.Items[thid].ImageIndex:=9;
      if frmain.lvMain.Items[thid].SubItems[columntype] = '1' then
        frmain.lvMain.Items[thid].ImageIndex:=53;
      if otherlistview then
      begin
        frmain.lvFilter.Items[thid2].SubItems[columnstatus]:='4';
        frmain.lvFilter.Items[thid2].Caption:=fstrings.statuserror;
        if frmain.lvMain.Items[thid2].SubItems[columntype] = '0' then
          frmain.lvFilter.Items[thid2].ImageIndex:=9;
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
      frmain.lvFilter.Items[thid2].SubItems[columnspeed]:='--';
    if frmain.lvMain.ItemIndex=thid then
    begin
      frmain.tbStartDown.Enabled:=true;
      frmain.tbStopDown.Enabled:=false;
      frmain.tbRestartNow.Enabled:=true;
      frmain.tbRestartLater.Enabled:=true;
    end;
    if manualshutdown=false then
    begin
      ///Show only if not left tries or queue is stopped
      if shownotifi and shownotifierror and ((qtimer[strtoint(frmain.lvMain.Items[thid].SubItems[columnqueue])].Enabled=false) or (strtoint(frmain.lvMain.Items[thid].SubItems[columntries])<=1)) then
      begin
        outlines:=TStringList.Create;
        outlines.Add(datetostr(Date()));
        outlines.Add(timetostr(Time()));
        outlines.AddText(wout);
        createnewnotifi(fstrings.popuptitlestoped,frmain.lvMain.Items[thid].SubItems[columnname],outlines.Strings[outlines.Count-1]+outlines.Strings[outlines.Count-2],frmain.lvMain.Items[thid].SubItems[columndestiny],false,frmain.lvMain.Items[thid].SubItems[columnuid]);
        outlines.Destroy;
      end;
      if frmain.lvMain.Items[thid].SubItems[columntries]<>'' then
      begin
        frmain.lvMain.Items[thid].SubItems[columntries]:=inttostr(strtoint(frmain.lvMain.Items[thid].SubItems[columntries])-1);
      end;
      //////Move the download if an error occur
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
        if playsounds and playsounderror and ((qtimer[strtoint(frmain.lvMain.Items[thid].SubItems[columnqueue])].Enabled=false) or (strtoint(frmain.lvMain.Items[thid].SubItems[columntries])<=1)) then
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
  savemydownloads;
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
  logrename:=false;
  {$IFDEF LCLGTK2}
  trayiconfontsize:=100;
  {$ELSE}
  trayiconfontsize:=14;
  {$ENDIF}
  tries:=dtries;
  youtubedlthexternal:='';
  youtubeuri:='';
  if wpr.IndexOf('--yes-playlist')=-1 then
    youtubeplaylist:=false
  else
    youtubeplaylist:=true;
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
      //The caption is determine by the status
      //fitem.Caption:=inidownloadsfile.ReadString('Download'+inttostr(ns),'status','');
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
      {if inidownloadsfile.ReadString('Download'+inttostr(ns),'columnstatus','0')<>'1' then
        fitem.SubItems[columnstatus]:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columnstatus','0')
      else
        fitem.SubItems[columnstatus]:='2';}
      fitem.SubItems.Add(inttostr(ns));
      fitem.SubItems.Add('');
      fitem.SubItems[columnuser]:=DecodeBase64(inidownloadsfile.ReadString('Download'+inttostr(ns),'columnuser',''));
      fitem.SubItems.Add('');
      fitem.SubItems[columnpass]:=DecodeBase64(inidownloadsfile.ReadString('Download'+inttostr(ns),'columnpass',''));
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
        ftext.Destroy;
      end
      else
        statusstr:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columnstatus','0');
      Case statusstr of
        '0':
        begin
          fitem.Caption:=fstrings.statuspaused;
          fitem.SubItems[columnstatus]:=statusstr;
          if fitem.SubItems[columntype] = '0' then
            fitem.ImageIndex:=18;
          if fitem.SubItems[columntype] = '1' then
            fitem.ImageIndex:=51;
        end;
        '1':
        begin
          fitem.Caption:=fstrings.statuserror;
          fitem.SubItems[columnstatus]:='4';
          if fitem.SubItems[columntype] = '0' then
            fitem.ImageIndex:=9;
          if fitem.SubItems[columntype] = '1' then
            fitem.ImageIndex:=53;
        end;
        '2':
        begin
          fitem.Caption:=fstrings.statusstoped;
          fitem.SubItems[columnstatus]:=statusstr;
          if fitem.SubItems[columntype] = '0' then
            fitem.ImageIndex:=3;
          if fitem.SubItems[columntype] = '1' then
            fitem.ImageIndex:=53;
        end;
        '3':
        begin
          fitem.Caption:=fstrings.statuscomplete;
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
          fitem.Caption:=fstrings.statuserror;
          fitem.SubItems[columnstatus]:=statusstr;
          if fitem.SubItems[columntype] = '0' then
            fitem.ImageIndex:=9;
          if fitem.SubItems[columntype] = '1' then
            fitem.ImageIndex:=53;
        end;
        '5':
        begin
          fitem.Caption:=fstrings.statuscanceled;
          fitem.SubItems[columnstatus]:=statusstr;
          if fitem.SubItems[columntype] = '0' then
            fitem.ImageIndex:=63;
          if fitem.SubItems[columntype] = '1' then
            fitem.ImageIndex:=53;
        end;
        else
        begin
          fitem.Caption:=fstrings.statuserror;
          fitem.SubItems[columnstatus]:=statusstr;
          if fitem.SubItems[columntype] = '0' then
            fitem.ImageIndex:=9;
          if fitem.SubItems[columntype] = '1' then
            fitem.ImageIndex:=53;
        end;
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
    frconfirm.Caption:=fstrings.dlgconfirm;
    frconfirm.dlgtext.Caption:=fstrings.msgcloseinprogressdownload;
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
    if Assigned(trayicons) then
    begin
      for n:=0 to Length(trayicons)-1 do
      begin
        if Assigned(trayicons[n]) then
        begin
          trayicons[n].Visible:=false;
          trayicons[n].Destroy;
        end;
      end;
    end;
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
  CanClose:=false;
  saveconfig();
end;

procedure Tfrmain.ApplicationProperties1Exception(Sender: TObject; E: Exception);
var exceptstr:System.Text;
begin
  try
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
    {$IFDEF LCLGTk}
    Writeln(exceptstr,'Widget Type: GTK');
    {$ENDIF}
    {$IFDEF LCLGTk2}
    Writeln(exceptstr,'Widget Type: GTK2');
    {$ENDIF}
    {$IFDEF LCLGTk3}
    Writeln(exceptstr,'Widget Type: GTK3');
    {$ENDIF}
    {$IFDEF LCLQT}
    Writeln(exceptstr,'Widget Type: QT');
    {$ENDIF}
    {$IFDEF LCLQT5}
    Writeln(exceptstr,'Widget Type: QT5');
    {$ENDIF}
    {$IFDEF LCLWince}
    Writeln(exceptstr,'Widget Type: Wince');
    {$ENDIF}
    {$IFDEF LCLWin32}
    Writeln(exceptstr,'Widget Type: Win32');
    {$ENDIF}
    {$IFDEF LCLWIN64}
    Writeln(exceptstr,'Widget Type: Win64');
    {$ENDIF}
    {$IFDEF LCLCocoa}
    Writeln(exceptstr,'Widget Type: Cocoa');
    {$ENDIF}
    {$IFDEF LCLCarbon}
    Writeln(exceptstr,'Widget Type: Carbon');
    {$ENDIF}
    Writeln(exceptstr,'');
    Writeln(exceptstr,Exception(ExceptObject).ClassName+':'+Exception(ExceptObject).Message+#10#13);
    System.DumpExceptionBackTrace(exceptstr);
    Writeln(exceptstr,'------------------------------------------');
    CloseFile(exceptstr);
    {$IFDEF BETA}
    case MessageDlg(Application.Title,format(msgerrorinforme,[SysToUTF8(configpath+'awgg.err'),e.Message]), mtError, [mbOK,mbCancel,mbIgnore], 0) of
     1:OpenURL('mailto:nenirey@gmail.com?subject=AWGG;body='+e.Message);//Ok
     2:Application.Terminate();//Cancel
     5:;//Ignore
    end;
    {$ENDIF}
  except on e:exception do
  end;
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
  currentdir:=SysToUTF8(ExtractFilePath(Application.Params[0]));
  if FileExists(currentdir+'awgg.ini') then //For portable version
    configpath:=currentdir
  else
    configpath:=GetAppConfigDir(false);
  datapath:=configpath+PathDelim+'Data';
  {$IFDEF UNIX}
    if FileExists(currentdir+'wget') then
      wgetrutebin:=awgg_path+'wget';
    if FileExists('/usr/bin/wget') then
      wgetrutebin:='/usr/bin/wget';
    if FileExists(currentdir+'aria2c') then
      aria2crutebin:=awgg_path+'aria2c';
    if FileExists('/usr/bin/aria2c') then
      aria2crutebin:='/usr/bin/aria2c';
    if FileExists(currentdir+'curl') then
      curlrutebin:=awgg_path+'curl';
    if FileExists('/usr/bin/curl') then
      curlrutebin:='/usr/bin/curl';
    if FileExists(currentdir+'axel') then
      axelrutebin:=awgg_path+'axel';
    if FileExists('/usr/bin/axel') then
      axelrutebin:='/usr/bin/axel';
    if FileExists(currentdir+'youtube-dl') then
      youtubedlrutebin:=awgg_path+'youtube-dl';
    if FileExists('/usr/bin/youtube-dl') then
      youtubedlrutebin:='/usr/bin/youtube-dl';
  {$ENDIF}
  {$IFDEF WINDOWS}
    if FileExists(currentdir+'wget.exe') then
      wgetrutebin:=awgg_path+'wget.exe';
    if FileExists(currentdir+'aria2c.exe') then
      aria2crutebin:=awgg_path+'aria2c.exe';
    if FileExists(currentdir+'curl.exe') then
      curlrutebin:=awgg_path+'curl.exe';
    if FileExists(currentdir+'axel.exe') then
      axelrutebin:=awgg_path+'axel.exe';
    if FileExists(currentdir+'youtube-dl.exe') then
      youtubedlrutebin:=awgg_path+'youtube-dl.exe';
  {$ENDIF}
  loadmydownloads();
  loadconfig();
  categoryreload();
  SetDefaultLang(deflanguage);
  titlegen();
  if not firststart then
    updatelangstatus();
  frmain.FirstStartTimer.Enabled:=true;
  onestart:=false;
  frmain.lvFilter.Columns:=frmain.lvMain.Columns;
end;

procedure Tfrmain.FormWindowStateChange(Sender: TObject);
begin
  if frmain.WindowState<>wsMinimized then
  lastmainwindowstate:=frmain.WindowState;
  {$IFDEF WINDOWS}
  if (frmain.WindowState=wsMinimized) and frmain.mimainddbox.Checked then
  begin
    frmain.WindowState:=lastmainwindowstate;
    frmain.Visible:=false;
    frmain.mimainddboxClick(nil);
    frmain.mimainddboxClick(nil);
  end;
  {$ENDIF}
end;

procedure Tfrmain.hintTimerTimer(Sender: TObject);
begin

end;

procedure Tfrmain.lvFilterDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Assigned(frmain.lvFilter.GetItemAt(x,y)) then
  begin
    accept:=true;
    StartDragIndex:=frmain.lvMain.Selected.Index;
  end
  else
  begin
    accept:=false;
    StartDragIndex:=-1;
  end;
end;

procedure Tfrmain.lvFilterEndDrag(Sender, Target: TObject; X, Y: Integer);
var
  i,indice,endindex:integer;
  itemuid:string;
begin
  if Assigned(frmain.lvFilter.GetItemAt(x,y)) and (StartDragIndex<>-1)  then
  begin
    itemuid:=frmain.lvFilter.GetItemAt(x,y).SubItems[columnuid];
    endindex:=frmain.lvFilter.GetItemAt(x,y).Index;
  //////////////////////////////
    for i:=0 to frmain.lvMain.Items.Count-1 do
    begin
      if frmain.lvMain.Items[i].SubItems[columnuid]=itemuid then
      begin
        indice:=i;
        break;
      end;
    end;
  /////////////////////////////
    if endindex>StartDragIndex then
      movestepdown(indice);
    if endindex<StartDragIndex then
      movestepup(StartDragIndex,indice);
  end
  else
  begin
    if Assigned(frmain.tvMain.GetNodeAt(X,Y)) then
    begin
      if Assigned(frmain.tvMain.GetNodeAt(X,Y).Parent) then
      begin
        if frmain.tvMain.GetNodeAt(X,Y).Parent.Index=1 then
        begin
          itemuid:=inttostr(frmain.tvMain.GetNodeAt(X,Y).Index);
          for i:=0 to frmain.lvMain.Items.Count-1 do
          begin
            if frmain.lvMain.Items[i].Selected then
            begin
              frmain.lvMain.Items[i].SubItems[columnqueue]:=itemuid;
              frmain.lvMain.Items[i].SubItems[columntries]:=inttostr(triesrotate);
            end;
          end;
          frmain.tvMainSelectionChanged(nil);
        end;
      end;
    end;
  end;
  StartDragIndex:=-1;
end;

procedure Tfrmain.lvFilterMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  frmain.lvFilter.ShowHint:=false;
  if Assigned(frmain.lvFilter.GetItemAt(x,y)) then
  begin
    try
      frmain.lvFilter.Hint:=frmain.lvFilter.GetItemAt(x,y).SubItems[columnname]+
      #10#13+frmain.lvMain.Column[columnurl+1].Caption+': '+frmain.lvFilter.GetItemAt(x,y).SubItems[columnurl]+
      #10#13+frmain.lvMain.Column[columndestiny+1].Caption+': '+frmain.lvFilter.GetItemAt(x,y).SubItems[columndestiny]+
      #10#13+fstrings.queuename+': '+queuenames[strtoint(frmain.lvFilter.GetItemAt(x,y).SubItems[columnqueue])]+
      #10#13+frmain.lvMain.Column[columnengine+1].Caption+': '+frmain.lvFilter.GetItemAt(x,y).SubItems[columnengine];
      frmain.lvFilter.ShowHint:=true;
    except on e:exception do
    end;
    frmain.lvFilter.DragMode:=dmAutomatic;
  end
  else
  begin
    frmain.lvFilter.DragMode:=dmManual;
    frmain.lvFilter.ShowHint:=false;
  end;
end;

procedure Tfrmain.lvMainColumnClick(Sender: TObject; Column: TListColumn);
var
  n:integer;
begin
  for n:=0 to frmain.lvMain.Columns.Count-1 do
  begin
    //frmain.lvMain.Columns[n].Caption:=AnsiReplaceStr(frmain.lvMain.Columns[n].Caption,'  ٧','');
    //frmain.lvMain.Columns[n].Caption:=AnsiReplaceStr(frmain.lvMain.Columns[n].Caption,'  ٨','');
    //if Column.Index<>n then
      frmain.lvMain.Column[n].ImageIndex:=-1;
    if (frmain.lvFilter.Visible) then
    begin
      //frmain.lvFilter.Columns[n].Caption:=AnsiReplaceStr(frmain.lvFilter.Columns[n].Caption,'  ٧','');
      //frmain.lvFilter.Columns[n].Caption:=AnsiReplaceStr(frmain.lvFilter.Columns[n].Caption,'  ٨','');
      //if Column.Index<>n then
        frmain.lvFilter.Column[n].ImageIndex:=-1;
    end;
  end;
  if frmain.lvMain.SortDirection=sdAscending then
  begin
    frmain.lvMain.SortDirection:=sdDescending;
    {$IFDEF LCLQT}
    {$ELSE}
      {$IFDEF LCLQT5}
      {$ELSE}
      //Column.Caption:=Column.Caption+'  ٧';
      Column.ImageIndex:=68;
      {$ENDIF}
    {$ENDIF}
  end
  else
  begin
    frmain.lvMain.SortDirection:=sdAscending;
    {$IFDEF LCLQT}
    {$ELSE}
      {$IFDEF LCLQT5}
      {$ELSE}
      //Column.Caption:=Column.Caption+'  ٨';
      Column.ImageIndex:=69;
      {$ENDIF}
    {$ENDIF}
  end;
  frmain.lvMain.SortColumn:=column.Index;
  frmain.lvMain.SortType:=stText;
  if (frmain.lvFilter.Visible) then
  begin
    frmain.lvFilter.SortColumn:=Column.Index;
    frmain.lvFilter.SortType:=stText;
    frmain.tvMainSelectionChanged(nil);
  end;
  rebuildids();
  if frmain.lvMain.Visible then
    columncolaw:=frmain.lvMain.Columns[0].Width
  else
    columncolaw:=frmain.lvFilter.Columns[0].Width;
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
      '2','4','5':
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

procedure Tfrmain.lvMainDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Assigned(frmain.lvMain.GetItemAt(x,y)) then
  begin
    accept:=true;
    StartDragIndex:=frmain.lvMain.Selected.Index;
  end
  else
  begin
    accept:=false;
    StartDragIndex:=-1;
  end;
end;

procedure Tfrmain.lvMainEndDrag(Sender, Target: TObject; X, Y: Integer);
var
  i:integer;
  itemuid:string;
begin
  if Assigned(frmain.lvMain.GetItemAt(x,y)) and (StartDragIndex<>-1)  then
  begin
    if frmain.lvMain.GetItemAt(x,y).Index>StartDragIndex then
      movestepdown(frmain.lvMain.GetItemAt(x,y).Index);
    if frmain.lvMain.GetItemAt(x,y).Index<StartDragIndex then
      movestepup(StartDragIndex,frmain.lvMain.GetItemAt(x,y).Index);
  end
  else
  begin
    if Assigned(frmain.tvMain.GetNodeAt(X,Y)) then
    begin
      if Assigned(frmain.tvMain.GetNodeAt(X,Y).Parent) then
      begin
        if frmain.tvMain.GetNodeAt(X,Y).Parent.Index=1 then
        begin
          itemuid:=inttostr(frmain.tvMain.GetNodeAt(X,Y).Index);
          for i:=0 to frmain.lvMain.Items.Count-1 do
          begin
            if frmain.lvMain.Items[i].Selected then
            begin
              frmain.lvMain.Items[i].SubItems[columnqueue]:=itemuid;
              frmain.lvMain.Items[i].SubItems[columntries]:=inttostr(triesrotate);
            end;
        end;
        frmain.tvMainSelectionChanged(nil);
        end;
      end;
    end;
  end;
  StartDragIndex:=-1;
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

procedure Tfrmain.lvMainMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  frmain.lvMain.ShowHint:=false;
  if Assigned(frmain.lvMain.GetItemAt(x,y)) then
  begin
    try
      frmain.lvMain.Hint:=frmain.lvMain.GetItemAt(x,y).SubItems[columnname]+
      #10#13+frmain.lvMain.Column[columnurl+1].Caption+': '+frmain.lvMain.GetItemAt(x,y).SubItems[columnurl]+
      #10#13+frmain.lvMain.Column[columndestiny+1].Caption+': '+frmain.lvMain.GetItemAt(x,y).SubItems[columndestiny]+
      #10#13+fstrings.queuename+': '+queuenames[strtoint(frmain.lvMain.GetItemAt(x,y).SubItems[columnqueue])]+
      #10#13+frmain.lvMain.Column[columnengine+1].Caption+': '+frmain.lvMain.GetItemAt(x,y).SubItems[columnengine];
      frmain.lvMain.ShowHint:=true;
    except on e:exception do
    end;
    frmain.lvMain.DragMode:=dmAutomatic;
  end
  else
  begin
    frmain.lvMain.ShowHint:=false;
    frmain.lvMain.DragMode:=dmManual;
  end;
end;

procedure Tfrmain.lvMainSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  lastlines:TStringList;
  percent:string;
  flog:string;
begin
  if (frmain.lvMain.ItemIndex<>-1) and (frmain.lvMain.SelCount=1) then
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
    if FileExists(UTF8ToSys(logpath+pathdelim+Item.SubItems[columnname])+'.log') then
      flog:=UTF8ToSys(logpath+pathdelim+Item.SubItems[columnname])+'.log'
    else
      if FileExists(UTF8ToSys(logpath+pathdelim+Item.SubItems[columnuid])+'.log') then
        flog:=UTF8ToSys(logpath+pathdelim+Item.SubItems[columnuid])+'.log';
    if FileExists(UTF8ToSys(flog)) and (frmain.SynEdit1.Visible) and (loadhistorylog) then
    begin
      try
        lastlines:=TStringList.Create;
        lastlines.LoadFromFile(UTF8ToSys(flog));
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

procedure Tfrmain.miDropboxClick(Sender: TObject);
begin
  frmain.mimainddboxClick(nil);
end;

procedure Tfrmain.miliMoveBottomClick(Sender: TObject);
begin
  movestepdown(frmain.lvMain.Items.Count-1);
end;

procedure Tfrmain.miliMoveDownClick(Sender: TObject);
begin
  if frmain.lvMain.ItemIndex<>-1 then
    moveonestepdown(frmain.lvMain.ItemIndex);
end;

procedure Tfrmain.miliMoveTopClick(Sender: TObject);
begin
  movestepup(frmain.lvMain.ItemIndex,0);
end;

procedure Tfrmain.miliMoveUpClick(Sender: TObject);
begin
  moveonestepup();
end;

procedure Tfrmain.milistCancelDownClick(Sender: TObject);
begin
  frmain.tbStopDownClick(tbCancelDown);
end;

procedure Tfrmain.milistContinueLaterDownClick(Sender: TObject);
begin
  frmain.tbContinueLaterClick(nil);
end;

procedure Tfrmain.milistMoveFilesClick(Sender: TObject);
var
  i:integer;
begin
  frmain.SelectDirectoryDialog1.Execute;
  //if (frmain.SelectDirectoryDialog1.FileName<>'') then
  if {$IFDEF LCLQT}(frmain.SelectDirectoryDialog1.UserChoice=1){$else}{$IFDEF LCLQT5}(frmain.SelectDirectoryDialog1.UserChoice=1){$ELSE}frmain.SelectDirectoryDialog1.FileName<>''{$endif}{$ENDIF} then
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

procedure Tfrmain.mimainCheckUpdateClick(Sender: TObject);
begin
  frconfig.pcConfig.ActivePageIndex:=18;
  frconfig.tvConfig.Items[frconfig.pcConfig.ActivePageIndex].Selected:=true;
  configdlg();
  frconfig.Show;
  frconfig.btnUpdateCheckNowClick(nil);
end;

procedure Tfrmain.mimainddboxClick(Sender: TObject);
begin
  if frddbox.Visible =false then
  begin
    frddbox.Width:=frddboxSize;
    frddbox.Height:=frddboxSize;
    frddbox.Top:=frddboxTop;
    frddbox.Left:=frddboxLeft;
    frddbox.Show;
    {$IFDEF LCLQT}
    frddbox.FormStyle:=fsSystemStayOnTop;
    frddbox.ShowInTaskBar:=stNever;
    {$ENDIF}
    {$IFDEF LCLQT5}
    frddbox.FormStyle:=fsSystemStayOnTop;
    frddbox.ShowInTaskBar:=stNever;
    {$ENDIF}
    {$IFDEF LCLGTK2}
    frddbox.ShowInTaskBar:=stNever;
    {$ENDIF}
    frddbox.frddboximgLogo.Show;
    {$IFDEF WINDOWS}
    {$ELSE}
    frddbox.edtDrop.Visible:=true;
    frddbox.edtDrop.Visible:=false;
    frddbox.getCurPosTimer.Enabled:=true;
    {$ENDIF}
  end
  else
  begin
    frddbox.getCurPosTimer.Enabled:=false;
    frddbox.Hide;
  end;
  frmain.mimainddbox.Checked:=frddbox.Visible;
  frmain.midropbox.Checked:=frddbox.Visible;
end;

procedure Tfrmain.mimainDonateClick(Sender: TObject);
begin
  OpenURL('https://sites.google.com/site/awggproject/home/dona');
end;

procedure Tfrmain.mimainShowInTrayClick(Sender: TObject);
begin
   frmain.MainTrayIcon.Visible:=not frmain.MainTrayIcon.Visible;
   frmain.mimainShowInTray.Checked:=frmain.MainTrayIcon.Visible;
   frmain.mimainInTray.Checked:=frmain.MainTrayIcon.Visible;
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
  frabout.lblAboutName.Caption:='AWGG';
  frabout.lblAboutVersion.Caption:='(Advanced WGET GUI)'+#10#13+'Version: '+versionitis.version+#10#13+'Compiled using:'+#10#13+{$IFDEF TYPHON}'CodeTyphon: '{$ELSE}'Lazarus: '{$ENDIF}+lcl_version+#10#13+'FPC: '+versionitis.fpcversion+#10#13+'Platform: '+cpu+'-'+versionitis.targetos+'-'+widgetset;
  frabout.mAboutText.Text:=abouttext;
  frabout.lblWebLink.Caption:='http://sites.google.com/site/awggproject';
  frabout.Show;
end;

procedure Tfrmain.milistPropertiesClick(Sender: TObject);
type
  TPropState = (PropInitValue, PropSameValue, PropDifferentValue);
var
  tmpstr:string='';
  paramlist:string='';
  i:integer;

  deDestinationText:string='';
  edtParametersText:string='';
  edtPasswordText:string='';
  edtUserText:string='';
  cbEngineItemText:string='';
  cbQueueItemText:string='';

  deDestinationTextPropState:TPropState=PropInitValue;
  edtParametersTextPropState:TPropState=PropInitValue;
  edtPasswordTextPropState:TPropState=PropInitValue;
  edtUserTextPropState:TPropState=PropInitValue;
  cbEngineItemTextPropState:TPropState=PropInitValue;
  cbQueueItemTextPropState:TPropState=PropInitValue;

begin
  if frmain.lvMain.ItemIndex<>-1 then
  begin
    //////THIS ORDER IS IMPORTANT/////////
    with frmain.lvMain.Items[frmain.lvMain.ItemIndex] do
    begin
      frnewdown.edtURL.Text:=SubItems[columnurl];
      frnewdown.edtFileName.Text:=SubItems[columnname];
      frnewdown.deDestination.Text:=SubItems[columndestiny];
      enginereload();
      frnewdown.cbQueue.Items.Clear;
      for i:=0 to Length(queues)-1 do
      begin
       frnewdown.cbQueue.Items.Add(queuenames[i]);
      end;
      frnewdown.cbEngine.ItemIndex:=frnewdown.cbEngine.Items.IndexOf(SubItems[columnengine]);
      frnewdown.edtParameters.Text:=SubItems[columnparameters];
      frmain.ClipBoardTimer.Enabled:=false;
      frnewdown.edtUser.Text:=SubItems[columnuser];
      frnewdown.edtPassword.Text:=SubItems[columnpass];
    end;
    ///////CONFIRM DIALOG MODE///////////
    if frmain.lvMain.SelCount>1 then
    begin
      // collecting the selected items' information
      for i:=0 to frmain.lvMain.Items.Count-1 do
      begin
        with frmain.lvMain.Items[i] do
        begin
          if Selected and (SubItems[columntype] = '0') and ((SubItems[columnstatus]='0') or (SubItems[columnstatus]='3')) then
          begin
            if deDestinationTextPropState = PropSameValue then
            begin
              if deDestinationText <> SubItems[columndestiny] then
                deDestinationTextPropState := PropDifferentValue;
            end
            else if deDestinationTextPropState = PropInitValue then
            begin
              deDestinationText := SubItems[columndestiny];
              deDestinationTextPropState := PropSameValue;
            end;
                         if edtParametersTextPropState = PropSameValue then
            begin
              if edtParametersText <> SubItems[columnparameters] then
                edtParametersTextPropState := PropDifferentValue;
            end
            else if edtParametersTextPropState = PropInitValue then
            begin
              edtParametersText := SubItems[columnparameters];
              edtParametersTextPropState := PropSameValue;
            end;
                         if edtPasswordTextPropState = PropSameValue then
            begin
              if edtPasswordText <> SubItems[columnpass] then
                edtPasswordTextPropState := PropDifferentValue;
            end
            else if edtPasswordTextPropState = PropInitValue then
            begin
              edtPasswordText := SubItems[columnpass];
              edtPasswordTextPropState := PropSameValue;
            end;
                         if edtUserTextPropState = PropSameValue then
            begin
              if edtUserText <> SubItems[columnuser] then
                edtUserTextPropState := PropDifferentValue;
            end
            else if edtUserTextPropState = PropInitValue then
            begin
              edtUserText := SubItems[columnuser];
              edtUserTextPropState := PropSameValue;
            end;
                         if cbEngineItemTextPropState = PropSameValue then
            begin
              if cbEngineItemText <> SubItems[columnengine] then
                cbEngineItemTextPropState := PropDifferentValue;
            end
            else if cbEngineItemTextPropState = PropInitValue then
            begin
              cbEngineItemText := SubItems[columnengine];
              cbEngineItemTextPropState := PropSameValue;
            end;
                         if cbQueueItemTextPropState = PropSameValue then
            begin
              if cbQueueItemText <> SubItems[columnqueue] then
                cbQueueItemTextPropState := PropDifferentValue;
            end
            else if cbQueueItemTextPropState = PropInitValue then
            begin
              cbQueueItemText := SubItems[columnqueue];
              cbQueueItemTextPropState := PropSameValue;
            end;
                         if (deDestinationTextPropState = PropDifferentValue) and
               (edtParametersTextPropState = PropDifferentValue) and
               (edtPasswordTextPropState = PropDifferentValue) and
               (edtUserTextPropState = PropDifferentValue) and
               (cbEngineItemTextPropState = PropDifferentValue) and
               (cbQueueItemTextPropState = PropDifferentValue) then
            begin
              // all the properties have different values:
              // no reason to continue the loop
              break;
            end;
          end;
        end;
      end;
      frnewdown.edtURL.Text:='';
      frnewdown.edtURL.Enabled:=false;
      frnewdown.edtFileName.Text:='';
      frnewdown.edtFileName.Enabled:=false;
      frnewdown.btnForceNames.Enabled:=false;
      frnewdown.btnCategoryGo.Enabled:=false;
      frnewdown.Caption:=fstrings.titlepropertiesdown+' ['+inttostr(frmain.lvMain.SelCount)+']';
      frnewdown.btnToQueue.Visible:=false;
      frnewdown.btnPaused.Visible:=false;
      frnewdown.btnStart.Caption:=fstrings.btnpropertiesok;
      frnewdown.btnStart.GlyphShowMode:=gsmNever;
      frnewdown.cbDestination.Text:=fstrings.nochangefield;

      if deDestinationTextPropState = PropSameValue then
        frnewdown.deDestination.Text:=deDestinationText
      else
        frnewdown.deDestination.Text:=fstrings.nochangefield;
      if cbEngineItemTextPropState = PropSameValue then
        frnewdown.cbEngine.ItemIndex:=frnewdown.cbEngine.Items.IndexOf(cbEngineItemText)
      else
      begin
        frnewdown.cbEngine.Items.Add(fstrings.nochangefield);
        frnewdown.cbEngine.ItemIndex:=frnewdown.cbEngine.Items.IndexOf(fstrings.nochangefield);
      end;
      if edtParametersTextPropState = PropSameValue then
        frnewdown.edtParameters.Text:=edtParametersText
      else
        frnewdown.edtParameters.Text:=fstrings.nochangefield;
      if edtPasswordTextPropState = PropSameValue then
        frnewdown.edtPassword.Text:=edtPasswordText
      else
        frnewdown.edtPassword.Text:=fstrings.nochangefield;
      if edtUserTextPropState = PropSameValue then
        frnewdown.edtUser.Text:=edtUserText
      else
        frnewdown.edtUser.Text:=fstrings.nochangefield;
      if cbQueueItemTextPropState = PropSameValue then
        frnewdown.cbQueue.ItemIndex:=strtoint(cbQueueItemText)
      else
      begin
        frnewdown.cbQueue.Items.Add(fstrings.nochangefield);
        frnewdown.cbQueue.ItemIndex:=frnewdown.cbQueue.Items.IndexOf(fstrings.nochangefield);
      end;
    end
    else
    begin
      frnewdown.edtURL.Enabled:=true;
      frnewdown.edtFileName.Enabled:=true;
      frnewdown.btnForceNames.Enabled:=true;
      frnewdown.btnCategoryGo.Enabled:=true;
      frnewdown.Caption:=fstrings.titlepropertiesdown;
      frnewdown.btnToQueue.Visible:=false;
      frnewdown.btnPaused.Visible:=false;
      frnewdown.btnStart.Caption:=fstrings.btnpropertiesok;
      frnewdown.btnStart.GlyphShowMode:=gsmNever;
      frnewdown.cbQueue.ItemIndex:=strtoint(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnqueue]);
    end;
    ////////////////////////////////////
    if firstnormalshow=false then
    begin
      //frnewdown.Show;
      //frnewdown.btnCancelClick(nil);
      frnewdown.Update;
      firstnormalshow:=true;
    end;
    frnewdown.ShowModal;
    ///////NEW DOWNLOAD DIALOG MODE///////////
    frnewdown.Caption:=fstrings.titlenewdown;
    frnewdown.btnToQueue.Visible:=true;
    frnewdown.btnPaused.Visible:=true;
    frnewdown.btnStart.Caption:=fstrings.btnnewdownstartnow;
    frnewdown.btnStart.GlyphShowMode:=gsmApplication;
    frnewdown.UpdateRolesForForm;
    frnewdown.edtURL.Enabled:=true;
    frnewdown.edtFileName.Enabled:=true;
    frnewdown.btnForceNames.Enabled:=true;
    frnewdown.btnCategoryGo.Enabled:=true;
    ////////////////////////////////////
    frmain.ClipBoardTimer.Enabled:=clipboardmonitor;
    if agregar then
    begin
      if frmain.lvMain.SelCount>1 then
      begin
        for i:=0 to frmain.lvMain.Items.Count-1 do
        begin
          //// Change only the normal download type and with pause, complete status
          with frmain.lvMain.Items[i] do
          begin
            if Selected and (SubItems[columntype] = '0') and ((SubItems[columnstatus]='0') or (SubItems[columnstatus]='3')) then
            begin
              if frnewdown.deDestination.Text<>fstrings.nochangefield then
                SubItems[columndestiny]:=frnewdown.deDestination.Text;
              if frnewdown.cbEngine.Text<>fstrings.nochangefield then
                SubItems[columnengine]:=frnewdown.cbEngine.Text;
              if frnewdown.edtParameters.Text<>fstrings.nochangefield then
                SubItems[columnparameters]:=frnewdown.edtParameters.Text;
              if frnewdown.edtUser.Text<>fstrings.nochangefield then
                SubItems[columnuser]:=frnewdown.edtUser.Text;
              if frnewdown.edtPassword.Text<>fstrings.nochangefield then
                SubItems[columnpass]:=frnewdown.edtPassword.Text;
              if (frnewdown.cbQueue.ItemIndex>=0) and (frnewdown.cbQueue.Text<>fstrings.nochangefield) then
                SubItems[columnqueue]:=inttostr(frnewdown.cbQueue.ItemIndex);
            end;
          end;
        end;
      end
      else
      begin
        with frmain.lvMain.Items[frmain.lvMain.ItemIndex] do
        begin
          // Note:
          // Attempts to set an empty file-name/download-URL/destination-dir
          // for already completed downloads are ignored.
          if (SubItems[columnstatus] <> '3') or (frnewdown.edtFileName.Text <> '') or
             (not FileExists(UTF8ToSys(SubItems[columndestiny] + pathdelim + SubItems[columnname]))) then
            SubItems[columnname]:=frnewdown.edtFileName.Text;
          if (SubItems[columnstatus] <> '3') or (frnewdown.edtURL.Text <> '') then
            SubItems[columnurl]:=frnewdown.edtURL.Text;
          if (SubItems[columnstatus] <> '3') or (frnewdown.deDestination.Text <> '') or
             (not DirectoryExists(UTF8ToSys(SubItems[columndestiny]))) then
            SubItems[columndestiny]:=frnewdown.deDestination.Text;
          SubItems[columnengine]:=frnewdown.cbEngine.Text;
          SubItems[columnparameters]:=frnewdown.edtParameters.Text;
          SubItems[columnuser]:=frnewdown.edtUser.Text;
          SubItems[columnpass]:=frnewdown.edtPassword.Text;
          if frnewdown.cbQueue.ItemIndex>=0 then
            SubItems[columnqueue]:=inttostr(frnewdown.cbQueue.ItemIndex);
          end;
      end;
      frmain.tvMainSelectionChanged(nil);
      savemydownloads();
    end;
    frnewdown.edtURL.Caption:='http://';
    with frmain.lvMain.Items[frmain.lvMain.ItemIndex] do
    begin
      if SubItems[columntype] = '1' then
      begin
        newgrabberqueues();
        frsitegrabber.cbQueue.ItemIndex:=strtoint(SubItems[columnqueue]);
        frsitegrabber.edtSiteName.Text:=SubItems[columnname];
        frsitegrabber.edtURL.Text:=SubItems[columnurl];
        frsitegrabber.deDestination.Text:=SubItems[columndestiny];
        frsitegrabber.edtUser.Text:=SubItems[columnuser];
        frsitegrabber.edtPassword.Text:=SubItems[columnpass];
        frsitegrabber.cbQueue.ItemIndex:=strtoint(SubItems[columnqueue]);
        if Pos('-k',SubItems[columnparameters])>0 then
          frsitegrabber.chLinkToLocal.Checked:=true
        else
          frsitegrabber.chLinkToLocal.Checked:=false;
        if Pos('--follow-ftp',SubItems[columnparameters])>0 then
          frsitegrabber.chFollowFTPLink.Checked:=true
        else
          frsitegrabber.chFollowFTPLink.Checked:=false;
        if Pos('-np',SubItems[columnparameters])>0 then
          frsitegrabber.chNoParentLink.Checked:=true
        else
          frsitegrabber.chNoParentLink.Checked:=false;
        if Pos('-p',SubItems[columnparameters])>0 then
          frsitegrabber.chPageRequisites.Checked:=true
        else
          frsitegrabber.chPageRequisites.Checked:=false;
        if Pos('-H',SubItems[columnparameters])>0 then
          frsitegrabber.chSpanHosts.Checked:=true
        else
          frsitegrabber.chSpanHosts.Checked:=false;
        if Pos('-L',SubItems[columnparameters])>0 then
          frsitegrabber.chFollowRelativeLink.Checked:=true
        else
          frsitegrabber.chFollowRelativeLink.Checked:=false;
        if Pos('-l ',SubItems[columnparameters])>0 then
        begin
          tmpstr:=SubItems[columnparameters];
          tmpstr:=Copy(tmpstr,Pos('-l ',tmpstr)+3,Length(tmpstr));
          tmpstr:=Copy(tmpstr,0,Pos(' ',tmpstr)-1);
          //ShowMessage(tmpstr);
          frsitegrabber.seMaxLevel.Value:=strtoint(tmpstr);
        end
        else
          frsitegrabber.seMaxLevel.Value:=5;
        if Pos('-R "',SubItems[columnparameters])>0 then
        begin
          tmpstr:=SubItems[columnparameters];
          tmpstr:=Copy(tmpstr,Pos('-R "',tmpstr)+4,Length(tmpstr));
          tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
          //ShowMessage(tmpstr);
          frsitegrabber.mFileRejectFilter.Text:=tmpstr;
        end
        else
          frsitegrabber.mFileRejectFilter.Text:='';
        if Pos('-A "',SubItems[columnparameters])>0 then
        begin
          tmpstr:=SubItems[columnparameters];
          tmpstr:=Copy(tmpstr,Pos('-A "',tmpstr)+4,Length(tmpstr));
          tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
          //ShowMessage(tmpstr);
          frsitegrabber.mFileAcceptFilter.Text:=tmpstr;
        end
        else
          frsitegrabber.mFileAcceptFilter.Text:='';
        if Pos('-D "',SubItems[columnparameters])>0 then
        begin
          tmpstr:=SubItems[columnparameters];
          tmpstr:=Copy(tmpstr,Pos('-D "',tmpstr)+4,Length(tmpstr));
          tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
          //ShowMessage(tmpstr);
          frsitegrabber.mFollowDomainFilter.Text:=tmpstr;
        end
        else
          frsitegrabber.mFollowDomainFilter.Text:='';
        if Pos('--exclude-domains "',SubItems[columnparameters])>0 then
        begin
          tmpstr:=SubItems[columnparameters];
          tmpstr:=Copy(tmpstr,Pos('--exclude-domains "',tmpstr)+19,Length(tmpstr));
          tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
          //ShowMessage(tmpstr);
          frsitegrabber.mDomainRejectFilter.Text:=tmpstr;
        end
        else
          frsitegrabber.mDomainRejectFilter.Text:='';
        if Pos('-I "',SubItems[columnparameters])>0 then
        begin
          tmpstr:=SubItems[columnparameters];
          tmpstr:=Copy(tmpstr,Pos('-I "',tmpstr)+4,Length(tmpstr));
          tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
          //ShowMessage(tmpstr);
          frsitegrabber.mIncludeDirectory.Text:=tmpstr;
        end
        else
          frsitegrabber.mIncludeDirectory.Text:='';
        if Pos('-X "',SubItems[columnparameters])>0 then
        begin
          tmpstr:=SubItems[columnparameters];
          tmpstr:=Copy(tmpstr,Pos('-X "',tmpstr)+4,Length(tmpstr));
          tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
          //ShowMessage(tmpstr);
          frsitegrabber.mExcludeDirectory.Text:=tmpstr;
        end
        else
          frsitegrabber.mExcludeDirectory.Text:='';
        if Pos('--follow-tags="',SubItems[columnparameters])>0 then
        begin
          tmpstr:=SubItems[columnparameters];
          tmpstr:=Copy(tmpstr,Pos('--follow-tags="',tmpstr)+15,Length(tmpstr));
          tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
          //ShowMessage(tmpstr);
          frsitegrabber.mFollowTags.Text:=tmpstr;
        end
        else
          frsitegrabber.mFollowTags.Text:='';
        if Pos('--ignore-tags="',SubItems[columnparameters])>0 then
        begin
          tmpstr:=SubItems[columnparameters];
          tmpstr:=Copy(tmpstr,Pos('--ignore-tags="',tmpstr)+15,Length(tmpstr));
          tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
          //ShowMessage(tmpstr);
          frsitegrabber.mIgnoreTags.Text:=tmpstr;
        end
        else
          frsitegrabber.mIgnoreTags.Text:='';
        if Pos('-U "',SubItems[columnparameters])>0 then
        begin
          tmpstr:=SubItems[columnparameters];
          tmpstr:=Copy(tmpstr,Pos('-U "',tmpstr)+4,Length(tmpstr));
          tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
          //ShowMessage(tmpstr);
          frsitegrabber.edtUserAgent.Text:=tmpstr;
        end
        else
          frsitegrabber.edtUserAgent.Text:='';
        frsitegrabber.PageControl1.TabIndex:=0;
        frmain.ClipBoardTimer.Enabled:=false;
        frsitegrabber.ShowModal;
        frmain.ClipBoardTimer.Enabled:=clipboardmonitor;
        if grbadd then
        begin
          paramlist:=paramlist+'-l '+inttostr(frsitegrabber.seMaxLevel.Value);
          if frsitegrabber.chLinkToLocal.Checked then
            paramlist:=paramlist+' -k';
          if frsitegrabber.chFollowFTPLink.Checked then
            paramlist:=paramlist+' --follow-ftp';
          if frsitegrabber.chNoParentLink.Checked then
            paramlist:=paramlist+' -np';
          if frsitegrabber.chPageRequisites.Checked then
            paramlist:=paramlist+' -p';
          if frsitegrabber.chSpanHosts.Checked then
            paramlist:=paramlist+' -H';
          if frsitegrabber.chFollowRelativeLink.Checked then
            paramlist:=paramlist+' -L';
          if Length(frsitegrabber.mFileRejectFilter.Lines.Text)>0 then
            paramlist:=paramlist+' -R "'+frsitegrabber.mFileRejectFilter.Lines.Text+'"';
          if Length(frsitegrabber.mDomainRejectFilter.Lines.Text)>0 then
            paramlist:=paramlist+' --exclude-domains "'+frsitegrabber.mDomainRejectFilter.Lines.Text+'"';
          if Length(frsitegrabber.mFollowDomainFilter.Lines.Text)>0 then
            paramlist:=paramlist+' -D "'+frsitegrabber.mFollowDomainFilter.Lines.Text+'"';
          if Length(frsitegrabber.mIncludeDirectory.Lines.Text)>0 then
            paramlist:=paramlist+' -I "'+frsitegrabber.mIncludeDirectory.Lines.Text+'"';
          if Length(frsitegrabber.mExcludeDirectory.Lines.Text)>0 then
            paramlist:=paramlist+' -X "'+frsitegrabber.mExcludeDirectory.Lines.Text+'"';
          if Length(frsitegrabber.mFileAcceptFilter.Lines.Text)>0 then
            paramlist:=paramlist+' -A "'+frsitegrabber.mFileAcceptFilter.Lines.Text+'"';
          if Length(frsitegrabber.mFollowTags.Lines.Text)>0 then
            paramlist:=paramlist+' --follow-tags="'+frsitegrabber.mFollowTags.Lines.Text+'"';
          if Length(frsitegrabber.mIgnoreTags.Lines.Text)>0 then
            paramlist:=paramlist+' --ignore-tags="'+frsitegrabber.mIgnoreTags.Lines.Text+'"';
          if Length(frsitegrabber.edtUserAgent.Text)>0 then
            paramlist:=paramlist+' -U "'+frsitegrabber.edtUserAgent.Text+'"';
          SubItems[columnname]:=frsitegrabber.edtSiteName.Text;//Nombre del sitio
          SubItems[columnurl]:=frsitegrabber.edtURL.Text;//URL
          SubItems[columndestiny]:=frsitegrabber.deDestination.Text;//Destino
          SubItems[columnparameters]:=paramlist;//Parametros
          SubItems[columnuser]:=frsitegrabber.edtUser.Text;//user
          SubItems[columnpass]:=frsitegrabber.edtPassword.Text;//pass
          SubItems[columnqueue]:=inttostr(frsitegrabber.cbQueue.ItemIndex);//queue
          frmain.tvMainSelectionChanged(nil);
          savemydownloads();
        end;
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
  frconfig.pcConfig.ActivePageIndex:=1;
  frconfig.tvConfig.Items[frconfig.pcConfig.ActivePageIndex].Selected:=true;
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
begin
  frmain.mimainSelectAllClick(nil);
  frmain.tbStartDownClick(nil);
end;

procedure Tfrmain.mimainStopAllClick(Sender: TObject);
begin
  frmain.mimainSelectAllClick(nil);
  frmain.tbStopAllClick(nil);
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
    if FileExists(UTF8ToSys(logpath+pathdelim+frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnuid])+'.log') then
      OpenURL(ExtractShortPathName(UTF8ToSys(logpath+pathdelim+frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnuid])+'.log'))
    else
      ShowMessage(fstrings.msgnoexisthistorylog);
  end;
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
begin
  frconfirm.Caption:=fstrings.dlgconfirm;
  frconfirm.dlgtext.Caption:=fstrings.dlgrestartalldownloads;
  frconfirm.ShowModal;
  if dlgcuestion then
  begin
    frmain.mimainSelectAllClick(nil);
    restartdownload(true,true);
  end;
end;

procedure Tfrmain.mimainDeleteAllClick(Sender: TObject);
begin
  clearcompletedownloads;
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
      ShowMessage(fstrings.msgnoexistfolder+' '+frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columndestiny]);
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
        ShowMessage(fstrings.msgfilenoexist);
    end;
  end;
end;

procedure Tfrmain.milistOpenURLClick(Sender: TObject);
begin
  if frmain.lvMain.ItemIndex<>-1 then
    OpenURL(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnurl]);
end;

procedure Tfrmain.mimainRestartAllLaterClick(Sender: TObject);
begin
  frconfirm.Caption:=fstrings.dlgconfirm;
  frconfirm.dlgtext.Caption:=fstrings.dlgrestartalldownloadslatter;
  frconfirm.ShowModal;
  if dlgcuestion then
  begin
    frmain.mimainSelectAllClick(nil);
    restartdownload(false,true);
  end;
end;

procedure Tfrmain.milistRestartLaterClick(Sender: TObject);
begin
  if frmain.lvMain.ItemIndex<>-1 then
  begin
    frconfirm.Caption:=fstrings.dlgconfirm;
    if frmain.lvMain.SelCount<2 then
      frconfirm.dlgtext.Caption:=fstrings.dlgrestartselecteddownloadletter+#10#13+#10#13+frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnname]
    else
      frconfirm.dlgtext.Caption:=fstrings.dlgrestartselecteddownloadletter+#10#13+#10#13+inttostr(frmain.lvMain.SelCount);
    frconfirm.ShowModal;
    if dlgcuestion then
    begin
      restartdownload(false);
    end;
  end;
end;

procedure Tfrmain.milistSteepUpClick(Sender: TObject);
begin
  movestepup(frmain.lvMain.ItemIndex,frmain.lvMain.ItemIndex-1);
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
        try
          if frmain.lvMain.Items[i].SubItems[columnstatus]='1' then
            trayicons[i].Visible:=true;
        except on e:exception do
        end;
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
  movestepup(frmain.lvMain.ItemIndex,0);
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
    frconfirm.Caption:=fstrings.dlgconfirm;
    frconfirm.dlgtext.Caption:=fstrings.dlgclearhistorylogfile;
    frconfirm.ShowModal;
    if dlgcuestion then
    begin
      if FileExists(UTF8ToSys(logpath+pathdelim+frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnname])+'.log') then
        SysUtils.DeleteFile(UTF8ToSys(logpath+pathdelim+frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnname])+'.log')
      else
        if FileExists(UTF8ToSys(logpath+pathdelim+frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnuid])+'.log') then
          SysUtils.DeleteFile(ExtractShortPathName(UTF8ToSys(logpath+pathdelim+frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnuid])+'.log'));
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

procedure Tfrmain.mitraydownCancelClick(Sender: TObject);
begin
  if (Assigned(hilo)) and (Length(hilo)>=strtoint(frmain.lvMain.Items[numtraydown].SubItems[columnid])) and (frmain.lvMain.Items[numtraydown].SubItems[columnstatus]='1') then
  begin
    downthread_shutdown(hilo[strtoint(frmain.lvMain.Items[numtraydown].SubItems[columnid])]);
    frmain.lvMain.Items[numtraydown].SubItems[columnstatus]:='5';
  end;
  if (frmain.lvMain.Items[numtraydown].SubItems[columnstatus]<>'1') then
  begin
    frmain.lvMain.Items[numtraydown].ImageIndex:=63;
    frmain.lvMain.Items[numtraydown].SubItems[columnstatus]:='5';
    frmain.lvMain.Items[numtraydown].Caption:=fstrings.statuscanceled;
    writestatus(numtraydown);
  end;
  if qtimer[strtoint(frmain.lvMain.Items[numtraydown].SubItems[columnqueue])].Enabled then
      frmain.lvMain.Items[numtraydown].SubItems[columntries]:='0';
end;

procedure Tfrmain.mitraydownContinueLaterClick(Sender: TObject);
begin
  if frmain.lvMain.Items[numtraydown].SubItems[columnstatus] <> '1' then
  begin
    if frmain.lvMain.Items[numtraydown].SubItems[columntype]='0' then
    begin
      frmain.lvMain.Items[numtraydown].ImageIndex:=18;
    end;
    if frmain.lvMain.Items[numtraydown].SubItems[columntype] = '1' then
    begin
      frmain.lvMain.Items[numtraydown].ImageIndex:=51;
    end;
    frmain.lvMain.Items[numtraydown].Caption:=fstrings.statuspaused;
    frmain.lvMain.Items[numtraydown].SubItems[columnstatus]:='0';
    frmain.lvMain.Items[numtraydown].SubItems[columntries]:=inttostr(dtries);
    writestatus(numtraydown);
  end;
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
  if (Assigned(hilo)) and (Length(hilo)>=strtoint(frmain.lvMain.Items[numtraydown].SubItems[columnid])) and (frmain.lvMain.Items[numtraydown].SubItems[columnstatus]='1') then
    downthread_shutdown(hilo[strtoint(frmain.lvMain.Items[numtraydown].SubItems[columnid])]);
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
  frconfig.tvConfig.Items[frconfig.pcConfig.ActivePageIndex].Selected:=true;
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
    try
      trayicons[frmain.lvMain.ItemIndex].Visible:=not trayicons[frmain.lvMain.ItemIndex].Visible;
      frmain.milistShowTrayIcon.Checked:=trayicons[frmain.lvMain.ItemIndex].Visible;
    except on e:exception do
    end;
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
  //if (frmain.SelectDirectoryDialog1.FileName<>'') then
  if {$IFDEF LCLQT}(frmain.SelectDirectoryDialog1.UserChoice=1){$else}{$IFDEF LCLQT5}(frmain.SelectDirectoryDialog1.UserChoice=1){$ELSE}frmain.SelectDirectoryDialog1.FileName<>''{$endif}{$ENDIF} then
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
  tmpclip2:string='';
begin
  noesta:=true;
  if ClipBoard.HasFormat(CF_TEXT) then
  begin
  if sameclip<>ClipBoard.AsText then
  begin
    sameclip:=ClipBoard.AsText;
    tmpclip:=Copy(sameclip,0,6);
    tmpclip2:=Copy(sameclip,0,7);
    if (tmpclip='http:/') or (tmpclip='https:') or (tmpclip='ftp://') or (tmpclip2='magnet:') then
    begin
      for cbn:=0 to frmain.lvMain.Items.Count-1 do
      begin
        if sameclip=frmain.lvMain.Items[cbn].SubItems[columnurl] then
          noesta:=false;
      end;
      if activedomainfilter then
      begin
        for cbn:=0 to Length(domainfilters)-1 do
        begin
          if ParseURI(sameclip).Host=domainfilters[cbn] then
            noesta:=false;
        end;
      end;
      if noesta then
      begin
        frmain.ClipBoardTimer.Enabled:=false;
        frnewdown.edtURL.Text:=sameclip;
        tbAddDownClick(nil);
        frmain.ClipBoardTimer.Enabled:=true;
      end;
    end;
    tmpclip:='';
    tmpclip2:='';
  end;
  end;
end;

procedure Tfrmain.FirstStartTimerTimer(Sender: TObject);
var
  i:integer;
  itemfile:TSearchRec;
begin
  newdownqueues();
  frmain.FirstStartTimer.Enabled:=false;
  if firststart then
  begin
    frlang.cbLang.Items.Clear;
    if FindFirst(ExtractFilePath(UTF8ToSys(Application.Params[0]))+pathdelim+'languages'+pathdelim+'awgg.*.po',faAnyFile,itemfile)=0 then
    begin
      Repeat
        try
          frlang.cbLang.Items.Add(Copy(itemfile.name,Pos('awgg.',itemfile.name)+5,Pos('.po',itemfile.name)-6));
        except
        on E:Exception do ShowMessage('The file '+itemfile.Name+' of language is not valid');
        end;
      Until FindNext(itemfile)<>0;
    end;
    if frlang.cbLang.Items.Count>0 then
    begin
      frmain.ClipBoardTimer.Enabled:=false;
      frlang.cbLang.ItemIndex:=0;
      frlang.ShowModal;
      deflanguage:=frlang.cbLang.Text;
      frmain.ClipBoardTimer.Enabled:=clipboardmonitor;
    end;
    SetDefaultLang(deflanguage);
    updatelangstatus();
    if FileExists(currentdir+'awgg.ini') then //For portable version
    begin
      ddowndir:=downloadpathname;
    end
    else
    begin
      //On windows vista and letter is the same path for all lang
      {$IFDEF WINDOWS}
      if DirectoryExistsUTF8(GetUserDir+'Downloads') then
        ddowndir:=GetUserDir+'Downloads'
      else
        ddowndir:=GetUserDir+downloadpathname;//if not exists create one with the translate name
      {$ELSE}
      ddowndir:=GetUserDir+downloadpathname;
      {$ENDIF}
    end;
    logpath:=ddowndir+pathdelim+'logs';
    if not DirectoryExists(ddowndir) then
      CreateDir(ddowndir);
    defaultcategory();
    categoryreload();
  end;
  dotherdowndir:=ddowndir+pathdelim+categoryothers;
  updatelangstatus();
  titlegen();
  firststart:=false;
  for i:=0 to Application.ParamCount-1 do
  begin
    SetLength(params,i+1);
    params[i]:=Application.Params[i];
  end;
  ParamsCount:=Application.ParamCount;
  parseparameters;
  if dropboxonstart then
    frmain.mimainddboxClick(nil);
  if autostartminimized then
  begin
    frmain.WindowState:=wsMinimized;
    frmain.Hide;
  end
  else
    frmain.WindowState:=lastmainwindowstate;
  if internetcheck then
  begin
    internetchecker:=TConnectionThread.Create;
    internetchecker.Start;
  end;
  if autoupdate then
    checkforupdates;
end;

procedure Tfrmain.tbCancelDownClick(Sender: TObject);
begin
  frmain.tbStopDownClick(tbCancelDown);
end;

procedure Tfrmain.tbContinueLaterClick(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to frmain.lvMain.Items.Count-1 do
  begin
    if frmain.lvMain.Items[i].Selected then
    begin
      if frmain.lvMain.Items[i].SubItems[columnstatus] <> '1' then
      begin
        if frmain.lvMain.Items[i].SubItems[columntype]='0' then
        begin
          frmain.lvMain.Items[i].ImageIndex:=18;
        end;
        if frmain.lvMain.Items[i].SubItems[columntype] = '1' then
        begin
          frmain.lvMain.Items[i].ImageIndex:=51;
        end;
        frmain.lvMain.Items[i].Caption:=fstrings.statuspaused;
        frmain.lvMain.Items[i].SubItems[columnstatus]:='0';
        frmain.lvMain.Items[i].SubItems[columntries]:=inttostr(dtries);
        writestatus(i);
      end;
    end;
  end;
  if frmain.lvFilter.Visible then
    frmain.tvMainSelectionChanged(nil);
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

procedure Tfrmain.tbAddDownClick(Sender: TObject;showdlg:boolean=true);
var
  downitem:TListItem;
  tmpindex,i:integer;
  tmpclip:string='';
  magnetname:string='';
begin
  if Sender<>nil then
    showdlg:=true;
  if (frnewdown.edtURL.Text='http://') or (frnewdown.edtURL.Text='') or (Sender<>nil) then
  begin
    tmpclip:=ClipBoard.AsText;
    if (Pos('http://',tmpclip)=1) or (Pos('https://',tmpclip)=1) or (Pos('ftp://',tmpclip)=1) or (Pos('magnet:',tmpclip)=1) then
      frnewdown.edtURL.Text:=tmpclip
    else
      frnewdown.edtURL.Text:='http://';
    tmpclip:='';
  end;
  if newdownloadforcenames then
  begin
    frnewdown.edtFileName.Text:=ParseURI(frnewdown.edtURL.Text).Document;
    if (Pos('magnet:',frnewdown.edtURL.Text)=1) and (Pos('&dn=',frnewdown.edtURL.Text)>0) then
    begin
      magnetname:=Copy(frnewdown.edtURL.Text,Pos('&dn=',frnewdown.edtURL.Text)+4,Length(frnewdown.edtURL.Text));
      magnetname:=Copy(magnetname,0,Pos('&',magnetname)-1);
      frnewdown.edtFileName.Text:=magnetname;
    end;
  end
  else
    frnewdown.edtFileName.Text:='';
  case defaultdirmode of
    1:frnewdown.deDestination.Text:=ddowndir;
    2:frnewdown.deDestination.Text:=suggestdir(frnewdown.edtFileName.Text);
  end;
  frnewdown.edtParameters.Text:='';
  frnewdown.edtUser.Text:='';
  frnewdown.edtPassword.Text:='';
  frnewdown.cbEngine.ItemIndex:=frnewdown.cbEngine.Items.IndexOf(defaultengine);
  frmain.ClipBoardTimer.Enabled:=false;//Descativar temporalmete el clipboardmonitor
  //Recargar engines
  enginereload();
  //Reload queues
  frnewdown.cbQueue.Items.Clear;
  for i:=0 to Length(queues)-1 do
  begin
    frnewdown.cbQueue.Items.Add(queuenames[i]);
  end;
  ///Select the best parameters
  suggestparameters();
  queueindexselect();
  if (frnewdown.Visible=false) or (showdlg=false) then
  begin
    //frnewdown.Hide;
    //frnewdown.Visible:=false;
    if showdlg then
      frnewdown.ShowModal
    else
      frnewdown.btnStartClick(nil);
    frmain.ClipBoardTimer.Enabled:=clipboardmonitor;//Activar el clipboardmonitor.
    if (agregar {or (showdlg=false)}) and (updateurl=false) then
    begin
      downitem:=TListItem.Create(frmain.lvMain.Items);
      downitem.Caption:=fstrings.statuspaused;
      downitem.ImageIndex:=18;
      downitem.SubItems.Add(frnewdown.edtFileName.Text);//Nombre de archivo
      downitem.SubItems.Add('');//Tama;o
      downitem.SubItems.Add('');//Descargado
      downitem.SubItems.Add(frnewdown.edtURL.Text);//URL
      downitem.SubItems.Add('');//Velocidad
      downitem.SubItems.Add('');//Porciento
      downitem.SubItems.Add('');//Estimado
      downitem.SubItems.Add(datetostr(Date())+' '+timetostr(Time()));//Fecha
      downitem.SubItems.Add(frnewdown.deDestination.Text);//Destino
      downitem.SubItems.Add(frnewdown.cbEngine.Text);//Motor
      downitem.SubItems.Add(frnewdown.edtParameters.Text);//Parametros
      downitem.SubItems.Add('0');//status
      downitem.SubItems.Add(inttostr(frmain.lvMain.Items.Count));//id
      downitem.SubItems.Add(frnewdown.edtUser.Text);//user
      downitem.SubItems.Add(frnewdown.edtPassword.Text);//pass
      downitem.SubItems.Add(inttostr(triesrotate));//tries
      downitem.SubItems.Add(uidgen());//uid
      downitem.SubItems.Add(inttostr(frnewdown.cbQueue.ItemIndex));//queue
      downitem.SubItems.Add('0');//type
      downitem.SubItems.Add('');//cookie
      downitem.SubItems.Add('');//referer
      downitem.SubItems.Add('');//post
      downitem.SubItems.Add('');//header
      downitem.SubItems.Add('');//useragent
      frmain.lvMain.Items.AddItem(downitem);
      frnewdown.edtURL.Text:='http://';
      tmpindex:=downitem.Index;
      if frnewdown.btnToUp.Visible then
      begin
        movestepup(tmpindex,0);
        tmpindex:=0;
      end;
      if cola then
      begin
        queuemanual[strtoint(frmain.lvMain.Items[tmpindex].SubItems[columnqueue])]:=true;
        qtimer[strtoint(frmain.lvMain.Items[tmpindex].SubItems[columnqueue])].Enabled:=true;
      end;
      frmain.tvMainSelectionChanged(nil);
      savemydownloads();
      if iniciar {or (showdlg=false)} then
      begin
        queuemanual[strtoint(frmain.lvMain.Items[tmpindex].SubItems[columnqueue])]:=true;
        downloadstart(tmpindex,false);
      end
      else
      begin
        if frmain.lvMain.Items[tmpindex].SubItems[columnengine]='youtube-dl' then
          updatevideonames(frmain.lvMain.Items[tmpindex].SubItems[columnid]);
      end;
      queueindex:=frnewdown.cbQueue.ItemIndex;
    end;
  end
  else
    frnewdown.Show;
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
    frconfirm.Caption:=fstrings.dlgconfirm;
    if frmain.lvMain.SelCount<2 then
      frconfirm.dlgtext.Caption:=fstrings.dlgrestartselecteddownload+#10#13+#10#13+frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnname]
    else
      frconfirm.dlgtext.Caption:=fstrings.dlgrestartselecteddownload+#10#13+#10#13+inttostr(frmain.lvMain.SelCount);
    frconfirm.ShowModal;
    if dlgcuestion then
    begin
      restartdownload(true);
    end;
  end;
end;

procedure Tfrmain.tbToUpClick(Sender: TObject);
begin
  movestepup(frmain.lvMain.ItemIndex,0);
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
  frsitegrabber.edtSiteName.Text:='';
  if Length(ClipBoard.AsText)<=256 then
  tmpclip:=ClipBoard.AsText;
  if (Pos('http://',tmpclip)=1) or (Pos('https://',tmpclip)=1) or (Pos('ftp://',tmpclip)=1) then
    frsitegrabber.edtURL.Text:=tmpclip
  else
    frsitegrabber.edtURL.Text:='http://';
  tmpclip:='';
  frsitegrabber.edtSiteName.Text:=ParseURI(frsitegrabber.edtURL.Text).Host;
  frsitegrabber.deDestination.Text:=ddowndir+pathdelim+'Sites';
  if not DirectoryExists(ddowndir+pathdelim+'Sites') then
    CreateDir(ddowndir+pathdelim+'Sites');
  frsitegrabber.edtUser.Text:='';
  frsitegrabber.edtPassword.Text:='';
  frsitegrabber.edtUserAgent.Text:=globaluseragent;
  frsitegrabber.cbQueue.ItemIndex:=frsitegrabber.cbQueue.Items.IndexOf(defaultengine);
  frmain.ClipBoardTimer.Enabled:=false;//Descativar temporalmete el clipboardmonitor
  newgrabberqueues();
  queueindexselect();
  frsitegrabber.PageControl1.PageIndex:=0;
  if frsitegrabber.Visible=false then
    frsitegrabber.ShowModal;
  frmain.ClipBoardTimer.Enabled:=clipboardmonitor;//Activar el clipboardmonitor.
  if grbadd then
  begin
    paramlist:=paramlist+'-l '+inttostr(frsitegrabber.seMaxLevel.Value);
    if frsitegrabber.chLinkToLocal.Checked then
      paramlist:=paramlist+' -k';
    if frsitegrabber.chFollowFTPLink.Checked then
     paramlist:=paramlist+' --follow-ftp';
    if frsitegrabber.chNoParentLink.Checked then
      paramlist:=paramlist+' -np';
    if frsitegrabber.chPageRequisites.Checked then
      paramlist:=paramlist+' -p';
    if frsitegrabber.chSpanHosts.Checked then
      paramlist:=paramlist+' -H';
    if frsitegrabber.chFollowRelativeLink.Checked then
      paramlist:=paramlist+' -L';
    if Length(frsitegrabber.mFileRejectFilter.Lines.Text)>0 then
      paramlist:=paramlist+' -R "'+frsitegrabber.mFileRejectFilter.Lines.Text+'"';
    if Length(frsitegrabber.mDomainRejectFilter.Lines.Text)>0 then
      paramlist:=paramlist+' --exclude-domains "'+frsitegrabber.mDomainRejectFilter.Lines.Text+'"';
    if Length(frsitegrabber.mFollowDomainFilter.Lines.Text)>0 then
      paramlist:=paramlist+' -D "'+frsitegrabber.mFollowDomainFilter.Lines.Text+'"';
    if Length(frsitegrabber.mIncludeDirectory.Lines.Text)>0 then
      paramlist:=paramlist+' -I "'+frsitegrabber.mIncludeDirectory.Lines.Text+'"';
    if Length(frsitegrabber.mExcludeDirectory.Lines.Text)>0 then
      paramlist:=paramlist+' -X "'+frsitegrabber.mExcludeDirectory.Lines.Text+'"';
    if Length(frsitegrabber.mFileAcceptFilter.Lines.Text)>0 then
      paramlist:=paramlist+' -A "'+frsitegrabber.mFileAcceptFilter.Lines.Text+'"';
    if Length(frsitegrabber.mFollowTags.Lines.Text)>0 then
      paramlist:=paramlist+' --follow-tags="'+frsitegrabber.mFollowTags.Lines.Text+'"';
    if Length(frsitegrabber.mIgnoreTags.Lines.Text)>0 then
      paramlist:=paramlist+' --ignore-tags="'+frsitegrabber.mIgnoreTags.Lines.Text+'"';
    if Length(frsitegrabber.edtUserAgent.Text)>0 then
      paramlist:=paramlist+' -U "'+frsitegrabber.edtUserAgent.Text+'"';
    downitem:=TListItem.Create(frmain.lvMain.Items);
    downitem.Caption:=fstrings.statuspaused;
    downitem.ImageIndex:=51;
    downitem.SubItems.Add(frsitegrabber.edtSiteName.Text);//Nombre del sitio
    downitem.SubItems.Add('');//Tama;o
    downitem.SubItems.Add('');//Descargado
    downitem.SubItems.Add(frsitegrabber.edtURL.Text);//URL
    downitem.SubItems.Add('');//Velocidad
    downitem.SubItems.Add('');//Porciento
    downitem.SubItems.Add('');//Estimado
    downitem.SubItems.Add(datetostr(Date())+' '+timetostr(Time()));//Fecha
    downitem.SubItems.Add(frsitegrabber.deDestination.Text);//Destino
    downitem.SubItems.Add('wget');//Motor
    downitem.SubItems.Add(paramlist);//Parametros
    downitem.SubItems.Add('0');//status
    downitem.SubItems.Add(inttostr(frmain.lvMain.Items.Count));//id
    downitem.SubItems.Add(frsitegrabber.edtUser.Text);//user
    downitem.SubItems.Add(frsitegrabber.edtPassword.Text);//pass
    downitem.SubItems.Add(inttostr(triesrotate));//tries
    downitem.SubItems.Add(uidgen());//uid
    downitem.SubItems.Add(inttostr(frsitegrabber.cbQueue.ItemIndex));//queue
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
  {if clipboardmonitor=false then
  begin
    ClipBoardmth:=ClipBoardThread.Create(true);
    ClipBoardmth.Start;
  end
  else
  begin
    if Assigned(ClipBoardmth) then
      ClipBoardmth.Terminate;
  end;}
end;

procedure Tfrmain.tbDelDownDiskClick(Sender: TObject);
begin
  deleteitems(true);
end;

procedure Tfrmain.tbStartDownClick(Sender: TObject);
var
  i:integer;
begin
  if frmain.lvMain.ItemIndex<>-1 then
  begin
    if frmain.lvMain.SelCount>1 then
    begin
      for i:=0 to frmain.lvMain.Items.Count-1 do
      begin
        if frmain.lvMain.Items[i].Selected then
        begin
          queuemanual[strtoint(frmain.lvMain.Items[i].SubItems[columnqueue])]:=true;
          downloadstart(i,false);
        end;
      end;
    end
    else
    begin
      queuemanual[strtoint(frmain.lvMain.Items[frmain.lvMain.ItemIndex].SubItems[columnqueue])]:=true;
      downloadstart(frmain.lvMain.ItemIndex,false);
    end;
  end
  else
    ShowMessage(fstrings.msgmustselectdownload);
end;

procedure Tfrmain.tbStopDownClick(Sender: TObject);
var
  i:integer;
begin
  if frmain.lvMain.ItemIndex<>-1 then
  begin
    try
      for i:=0 to frmain.lvMain.Items.Count-1 do
      begin
        if frmain.lvMain.Items[i].Selected then
        begin
          if (Assigned(hilo)) and (Length(hilo)>=strtoint(frmain.lvMain.Items[i].SubItems[columnid])) and (frmain.lvMain.Items[i].SubItems[columnstatus]='1') then
          begin
            downthread_shutdown(hilo[strtoint(frmain.lvMain.Items[i].SubItems[columnid])]);
            if Sender=tbCancelDown then
              frmain.lvMain.Items[i].SubItems[columnstatus]:='5';
            if qtimer[strtoint(frmain.lvMain.Items[i].SubItems[columnqueue])].Enabled then
              frmain.lvMain.Items[i].SubItems[columntries]:='0';
          end;
          if frmain.lvMain.Items[i].SubItems[columnstatus]<>'1' then
          begin
            if Sender=tbCancelDown then
            begin
              frmain.lvMain.Items[i].ImageIndex:=63;
              frmain.lvMain.Items[i].SubItems[columnstatus]:='5';
              frmain.lvMain.Items[i].Caption:=fstrings.statuscanceled;
              writestatus(i);
            end;
          end;
        end;
      end;
      if frmain.lvFilter.Visible and (Sender=tbCancelDown) then
        frmain.tvMainSelectionChanged(nil);
      frmain.tbStartDown.Enabled:=true;
      frmain.tbStopDown.Enabled:=false;
      frmain.tbRestartNow.Enabled:=true;
      frmain.tbRestartLater.Enabled:=true;
    except on e:exception do
    end;
  end
  else
    ShowMessage(fstrings.msgmustselectdownload);
end;

procedure Tfrmain.tbConfigClick(Sender: TObject);
begin
  frconfig.tvConfig.Items[frconfig.pcConfig.ActivePageIndex].Selected:=true;
  configdlg();
  frconfig.Show;
end;

procedure Tfrmain.tbSchedulerClick(Sender: TObject);
begin
  frconfig.pcConfig.ActivePageIndex:=1;
  frconfig.tvConfig.Items[frconfig.pcConfig.ActivePageIndex].Selected:=true;
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
          queuemainstop:=false;
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
        queuemainstop:=false;
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
            ShowMessage(fstrings.msgnoexistfolder+' '+categoryextencions[frmain.tvMain.Selected.Index][0]);
        end
        else
        begin
          if DirectoryExists(UTF8ToSys(dotherdowndir)) then
          begin
            if not OpenURL(dotherdowndir) then
              OpenURL(ExtractShortPathName(UTF8ToSys(dotherdowndir)));
          end
          else
            ShowMessage(fstrings.msgnoexistfolder+' '+dotherdowndir);
        end;
      end;
    end;
  end;
end;

procedure Tfrmain.tvMainDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Assigned(frmain.tvMain.GetNodeAt(X,Y)) then
  begin
    if Assigned(frmain.tvMain.GetNodeAt(X,Y).Parent) then
    begin
      if frmain.tvMain.GetNodeAt(X,Y).Parent.Index=1 then
      begin
        Accept:=true;
      end
      else
        Accept:=false;
    end
    else
      Accept:=false;
  end
  else
    Accept:=false;
  StartDragIndex:=-1;
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
            frnewdown.cbQueue.Items[frmain.tvMain.Selected.Index]:=s;
            if qtimer[frmain.tvMain.Selected.Index].Enabled then
              frmain.pmTrayIcon.Items[frmain.tvMain.Selected.Index+frmain.pmTrayIcon.Items.IndexOf(frmain.miline2)+1].Caption:=stopqueuesystray+' ('+s+')'
            else
              frmain.pmTrayIcon.Items[frmain.tvMain.Selected.Index+frmain.pmTrayIcon.Items.IndexOf(frmain.miline2)+1].Caption:=startqueuesystray+' ('+s+')';
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
            4:sts:='5';
            5:sts:='0';
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
  i:integer;
begin
  onestart:=false;
  if ParamCount>0 then
  begin
    for i:=0 to ParamCount-1 do
    begin
      SetLength(params,i+1);
      params[i]:=Parameters[i];
    end;
    ParamsCount:=ParamCount;
    parseparameters;
  end
  else
  begin
    frmain.MainTrayIconDblClick(nil);
    //frmain.Show;
   end;
end;

procedure Tfrmain.UpdateInfoTimerStartTimer(Sender: TObject);
begin
  //updatefname:='';
  //updatefsize:=0;
  //updatecurrentpos:=0;
end;

procedure Tfrmain.UpdateInfoTimerStopTimer(Sender: TObject);
begin
  //frconfig.btnUpdateCheckNow.Enabled:=true;
end;

procedure Tfrmain.UpdateInfoTimerTimer(Sender: TObject);
begin
  frconfig.btnUpdateCheckNow.Enabled:=false;
  frmain.mimainCheckUpdate.Enabled:=false;
  if frconfig.pbUpdate.Position>0 then
    frconfig.pbUpdate.Style:=pbstNormal;
  if Assigned(UpdaterAria2) then
  begin
    with UpdaterAria2 do
    begin
      if (updatecurrentpos<>0) and descargando then
      begin
        if updatefsize>0 then
          frconfig.pbUpdate.Position:=Round((updatecurrentpos/updatefsize)*100);
        frconfig.lblUpdateInfo.Caption:=updatefname;
      end;
    end;
  end;
  if Assigned(UpdaterAxel) then
  begin
    with UpdaterAxel do
    begin
      if (updatecurrentpos<>0) and descargando then
      begin
        if updatefsize>0 then
          frconfig.pbUpdate.Position:=Round((updatecurrentpos/updatefsize)*100);
        frconfig.lblUpdateInfo.Caption:=updatefname;
      end;
    end;
  end;
  if Assigned(UpdaterCurl) then
  begin
    with UpdaterCurl do
    begin
      if (updatecurrentpos<>0) and descargando then
      begin
        if updatefsize>0 then
          frconfig.pbUpdate.Position:=Round((updatecurrentpos/updatefsize)*100);
        frconfig.lblUpdateInfo.Caption:=updatefname;
      end;
    end;
  end;
  if Assigned(UpdaterYoutubedl) then
  begin
    with UpdaterYoutubedl do
    begin
      if (updatecurrentpos<>0) and descargando then
      begin
        if updatefsize>0 then
          frconfig.pbUpdate.Position:=Round((updatecurrentpos/updatefsize)*100);
        frconfig.lblUpdateInfo.Caption:=updatefname;
      end;
    end;
  end;
  if Assigned(UpdaterWget) then
  begin
    with UpdaterWget do
    begin
      if (updatecurrentpos<>0) and descargando then
      begin
        if updatefsize>0 then
          frconfig.pbUpdate.Position:=Round((updatecurrentpos/updatefsize)*100);
        frconfig.lblUpdateInfo.Caption:=updatefname;
      end;
    end;
  end;
end;

procedure downtrayicon.showinmain(Sender:TObject);
begin
  frmain.WindowState:=lastmainwindowstate;
  frmain.Show;
  if frmain.tvMain.Items.Count-1>=self.downindex then
  begin
    frmain.tvMain.Items[0].Selected:=true;
    frmain.lvMain.MultiSelect:=false;
    frmain.lvMain.Items[self.downindex].Selected:=true;
    frmain.lvMain.MultiSelect:=true;
  end;
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
        FileUtil.CopyFile(flashgotpath,firefoxprofpath+pathdelim+'extensions'+pathdelim+ExtractFileName(flashgotpath));
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

procedure parseparameters;
var
  downitem:TListItem;
  tmpindex,i,n:integer;
  fcookie:string='';
  fname:string='';
  referer:string='';
  post:string='';
  header:string='';
  url:string='';
  urls:TStringList;
  useragent:string='';
  magnetname:string='';
  silent:boolean=false;
  //tmpstr:string='';
begin
  if (ParamsCount>0) then
  begin
    urls:=TStringList.Create;
    for i:=0 to ParamsCount-1 do
    begin
      if Params[i]='-s' then
        silent:=true;
      if (Params[i]='-n') and (ParamsCount>i) then
      begin
        for n:=i to ParamsCount do
        begin
          if (Params[n+1]<>'-c') and (Params[n+1]<>'-s') and (Params[n+1]<>'-r') and (Params[n+1]<>'-p') and (Params[n+1]<>'-h') and (Params[n+1]<>'-u') then
            fname:=fname+SystoUTF8(Params[n+1])+' '
          else
          break;
        end;
        fname:=Copy(fname,0,Length(fname)-1);
      end;
      if (Params[i]='-c') and (ParamsCount>i) then
      begin
        if (Copy(Params[i+1],0,1)<>'-') then
          fcookie:=Params[i+1];
      end;
      if (Params[i]='-r') and (ParamsCount>i) then
      begin
        for n:=i to ParamsCount-1 do
        begin
          if (Params[n+1]<>'-n') and (Params[n+1]<>'-c') and (Params[n+1]<>'-u') and (Params[n+1]<>'-s') then
            referer:=referer+Params[n+1]+'%20'
          else
            break;
          referer:=Copy(referer,0,length(referer)-3);
        end;
      end;
      if (Params[i]='-p') and (ParamsCount>i) then
      begin
        if (Copy(Params[i+1],0,1)<>'-') then
          post:=Params[i+1];
      end;
      if (Params[i]='-h') and (ParamsCount>i) then
      begin
        if (Copy(Params[i+1],0,1)<>'-') then
          header:=Params[i+1];
      end;
      if (Params[i]='-u') and (ParamsCount>i) then
      begin
        for n:=i to ParamsCount-1 do
        begin
          if (Params[n+1]<>'-n') and (Params[n+1]<>'-c') and (Params[n+1]<>'-r') and (Params[n+1]<>'-s') then
            useragent:=useragent+Params[n+1]+' '
          else
            break;
          useragent:=Copy(useragent,0,length(useragent)-1);
        end;
      end;
      if ((Pos('http://',Params[i])=1) or (Pos('https://',Params[i])=1) or (Pos('ftp://',Params[i])=1) or (Pos('magnet:',Params[i])=1)) and (url='') then
      begin
        for n:=i to ParamsCount-1 do
        begin
          //ShowMessage(Params[n]);
          if (Params[n]<>'-n') and (Params[n]<>'-c') and (Params[n]<>'-r') and (Params[n]<>'-u') and (Params[n]<>'-s') then
            url:=url+Params[n]+'%20'
          else
          begin
            url:=Copy(url,0,length(url)-3);
            break;
          end;
        end;
      end;
      //tmpstr:=tmpstr+' '+Params[i];
    end;
    //ShowMessage(tmpstr);

    //Batch implementation
    url:=StringReplace(url,'%20http://',lineending+'http://',[rfReplaceAll]);
    url:=StringReplace(url,'%20https://',lineending+'https://',[rfReplaceAll]);
    url:=StringReplace(url,'%20ftp://',lineending+'ftp://',[rfReplaceAll]);
    url:=StringReplace(url,'%20magnet:',lineending+'magnet:',[rfReplaceAll]);
    urls.AddText(url);
    //ShowMessage(inttostr(urls.Count));
    frmain.ClipBoardTimer.Enabled:=false;//Desactivar temporalmente el clipboard monitor
    for n:=0 to urls.Count-1 do
    begin
      frnewdown.edtURL.Text:=urls[n];
      if fname<>'' then
        frnewdown.edtFileName.Text:=fname
      else
      begin
        frnewdown.edtFileName.Text:=ParseURI(frnewdown.edtURL.Text).Document;
        if (Pos('magnet:',urls[n])=1) and (Pos('&dn=',urls[n])>0) then
        begin
          magnetname:=Copy(urls[n],Pos('&dn=',urls[n])+4,Length(urls[n]));
          magnetname:=Copy(magnetname,0,Pos('&',magnetname)-1);
          frnewdown.edtFileName.Text:=magnetname;
        end;
      end;
      case defaultdirmode of
        1:frnewdown.deDestination.Text:=ddowndir;
        2:frnewdown.deDestination.Text:=suggestdir(frnewdown.edtFileName.Text);
      end;
      frnewdown.edtParameters.Text:='';
      frnewdown.edtUser.Text:='';
      frnewdown.edtPassword.Text:='';
      frnewdown.cbEngine.ItemIndex:=frnewdown.cbEngine.Items.IndexOf(defaultengine);
      enginereload();
      suggestparameters();
      if frnewdown.cbQueue.ItemIndex=-1 then
        frnewdown.cbQueue.ItemIndex:=0;
      queueindexselect();
      agregar:=false;
      iniciar:=false;
      if (frnewdown.Visible=false) and (silent=false) and (urls.Count=1) then
        frnewdown.ShowModal;
      if (urls.Count>1) then
        checkandclose(true);
      if silent then
        silent:=checkandclose(true);
      if (agregar or silent or (urls.Count>1)) and (updateurl=false) then
      begin
        downitem:=TListItem.Create(frmain.lvMain.Items);
        downitem.Caption:=fstrings.statuspaused;
        downitem.ImageIndex:=18;
        downitem.SubItems.Add(frnewdown.edtFileName.Text);//Nombre de archivo
        downitem.SubItems.Add('');//Tama;o
        downitem.SubItems.Add('');//Descargado
        downitem.SubItems.Add(frnewdown.edtURL.Text);//URL
        downitem.SubItems.Add('');//Velocidad
        downitem.SubItems.Add('');//Porciento
        downitem.SubItems.Add('');//Estimado
        downitem.SubItems.Add(datetostr(Date())+' '+timetostr(Time()));//Fecha
        downitem.SubItems.Add(frnewdown.deDestination.Text);//Destino
        downitem.SubItems.Add(frnewdown.cbEngine.Text);//Motor
        downitem.SubItems.Add(frnewdown.edtParameters.Text);//Parametros
        downitem.SubItems.Add('0');//status
        downitem.SubItems.Add(inttostr(frmain.lvMain.Items.Count));//id
        downitem.SubItems.Add(frnewdown.edtUser.Text);//user
        downitem.SubItems.Add(frnewdown.edtPassword.Text);//pass
        downitem.SubItems.Add(inttostr(triesrotate));//tries
        downitem.SubItems.Add(uidgen());//uid
        if silent then
          downitem.SubItems.Add('0')//silent defualt queue
        else
          downitem.SubItems.Add(inttostr(frnewdown.cbQueue.ItemIndex));//queue
        downitem.SubItems.Add('0');//type
        downitem.SubItems.Add(fcookie);//cookie
        downitem.SubItems.Add(referer);//referer
        downitem.SubItems.Add(post);//post
        downitem.SubItems.Add(header);//header
        downitem.SubItems.Add(useragent);//useragent
        frmain.lvMain.Items.AddItem(downitem);
        tmpindex:=downitem.Index;
        if frnewdown.btnToUp.Visible then
        begin
          movestepup(tmpindex,0);
          tmpindex:=0;
        end;
        if cola or (urls.Count>1) then
        begin
          queuemanual[strtoint(frmain.lvMain.Items[tmpindex].SubItems[columnqueue])]:=true;
          qtimer[strtoint(frmain.lvMain.Items[tmpindex].SubItems[columnqueue])].Enabled:=true;
        end;
        if iniciar or silent then
        begin
          queuemanual[strtoint(frmain.lvMain.Items[tmpindex].SubItems[columnqueue])]:=true;
          downloadstart(tmpindex,false);
        end;
        if iniciar=false then
        begin
          if frmain.lvMain.Items[tmpindex].SubItems[columnengine]='youtube-dl' then
            updatevideonames(frmain.lvMain.Items[tmpindex].SubItems[columnid]);
        end;
      end;
      frmain.ClipBoardTimer.Enabled:=clipboardmonitor;//Avtivar el clipboardmonitor
      frmain.tvMainSelectionChanged(nil);
      savemydownloads();
    end;
  end;
end;

end.

