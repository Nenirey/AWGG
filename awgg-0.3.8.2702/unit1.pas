unit Unit1;

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
  Classes, SysUtils, FileUtil, SynHighlighterAny,
  synhighlighterunixshellscript, SynEdit, UniqueInstance, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ExtCtrls, Menus, Spin, ComCtrls, DateUtils,
  Process,
  {$IFDEF WINDOWS}Registry, MMSystem,{$ENDIF} Math, Unit2, Unit3, Unit4, Unit5, Unit6, Unit7, Unit9, Clipbrd, PopupNotifier,
  strutils, LCLType, LCLIntf, types, versionitis, INIFiles, LCLVersion,
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

  { TForm1 }

  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    FloatSpinEdit1: TFloatSpinEdit;
    ImageList1: TImageList;
    Label1: TLabel;
    ListView1: TListView;
    ListView2: TListView;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    MenuItem32: TMenuItem;
    MenuItem33: TMenuItem;
    MenuItem34: TMenuItem;
    MenuItem35: TMenuItem;
    MenuItem36: TMenuItem;
    MenuItem37: TMenuItem;
    MenuItem38: TMenuItem;
    MenuItem39: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem40: TMenuItem;
    MenuItem41: TMenuItem;
    MenuItem42: TMenuItem;
    MenuItem43: TMenuItem;
    MenuItem44: TMenuItem;
    MenuItem45: TMenuItem;
    MenuItem46: TMenuItem;
    MenuItem47: TMenuItem;
    MenuItem48: TMenuItem;
    MenuItem49: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem50: TMenuItem;
    MenuItem51: TMenuItem;
    MenuItem52: TMenuItem;
    MenuItem53: TMenuItem;
    MenuItem54: TMenuItem;
    MenuItem55: TMenuItem;
    MenuItem56: TMenuItem;
    MenuItem57: TMenuItem;
    MenuItem58: TMenuItem;
    MenuItem59: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem60: TMenuItem;
    MenuItem61: TMenuItem;
    MenuItem62: TMenuItem;
    MenuItem63: TMenuItem;
    MenuItem64: TMenuItem;
    MenuItem65: TMenuItem;
    MenuItem66: TMenuItem;
    MenuItem67: TMenuItem;
    MenuItem68: TMenuItem;
    MenuItem69: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem70: TMenuItem;
    MenuItem71: TMenuItem;
    MenuItem72: TMenuItem;
    MenuItem73: TMenuItem;
    MenuItem74: TMenuItem;
    MenuItem75: TMenuItem;
    MenuItem76: TMenuItem;
    MenuItem77: TMenuItem;
    MenuItem78: TMenuItem;
    MenuItem79: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem80: TMenuItem;
    MenuItem81: TMenuItem;
    MenuItem82: TMenuItem;
    MenuItem83: TMenuItem;
    MenuItem84: TMenuItem;
    MenuItem85: TMenuItem;
    MenuItem86: TMenuItem;
    MenuItem87: TMenuItem;
    MenuItem88: TMenuItem;
    MenuItem89: TMenuItem;
    MenuItem9: TMenuItem;
    MenuItem90: TMenuItem;
    MenuItem91: TMenuItem;
    MenuItem92: TMenuItem;
    MenuItem93: TMenuItem;
    OpenDialog1: TOpenDialog;
    PairSplitter1: TPairSplitter;
    PairSplitter2: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    PairSplitterSide3: TPairSplitterSide;
    PairSplitterSide4: TPairSplitterSide;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    PopupMenu4: TPopupMenu;
    PopupNotifier1: TPopupNotifier;
    ProgressBar1: TProgressBar;
    SaveDialog1: TSaveDialog;
    SpinEdit1: TSpinEdit;
    SynEdit1: TSynEdit;
    SynUNIXShellScriptSyn1: TSynUNIXShellScriptSyn;
    Timer1: TTimer;
    Timer3: TTimer;
    Timer4: TTimer;
    Timer6: TTimer;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton2: TToolButton;
    ToolButton20: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    ToolButton23: TToolButton;
    ToolButton24: TToolButton;
    ToolButton25: TToolButton;
    ToolButton26: TToolButton;
    ToolButton27: TToolButton;
    ToolButton28: TToolButton;
    ToolButton29: TToolButton;
    ToolButton3: TToolButton;
    ToolButton30: TToolButton;
    ToolButton31: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    TrayIcon1: TTrayIcon;
    TreeView1: TTreeView;
    UniqueInstance1: TUniqueInstance;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ListView2Click(Sender: TObject);
    procedure ListView2SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem20Click(Sender: TObject);
    procedure MenuItem21Click(Sender: TObject);
    procedure MenuItem22Click(Sender: TObject);
    procedure MenuItem23Click(Sender: TObject);
    procedure MenuItem24Click(Sender: TObject);
    procedure MenuItem25Click(Sender: TObject);
    procedure MenuItem26Click(Sender: TObject);
    procedure MenuItem27Click(Sender: TObject);
    procedure MenuItem28Click(Sender: TObject);
    procedure MenuItem29Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem30Click(Sender: TObject);
    procedure MenuItem31Click(Sender: TObject);
    procedure MenuItem33Click(Sender: TObject);
    procedure MenuItem34Click(Sender: TObject);
    procedure MenuItem36Click(Sender: TObject);
    procedure MenuItem37Click(Sender: TObject);
    procedure MenuItem38Click(Sender: TObject);
    procedure MenuItem39Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem40Click(Sender: TObject);
    procedure MenuItem41Click(Sender: TObject);
    procedure MenuItem42Click(Sender: TObject);
    procedure MenuItem43Click(Sender: TObject);
    procedure MenuItem44Click(Sender: TObject);
    procedure MenuItem45Click(Sender: TObject);
    procedure MenuItem46Click(Sender: TObject);
    procedure MenuItem47Click(Sender: TObject);
    procedure MenuItem48Click(Sender: TObject);
    procedure MenuItem49Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem50Click(Sender: TObject);
    procedure MenuItem51Click(Sender: TObject);
    procedure MenuItem52Click(Sender: TObject);
    procedure MenuItem53Click(Sender: TObject);
    procedure MenuItem54Click(Sender: TObject);
    procedure MenuItem55Click(Sender: TObject);
    procedure MenuItem56Click(Sender: TObject);
    procedure MenuItem57Click(Sender: TObject);
    procedure MenuItem58Click(Sender: TObject);
    procedure MenuItem59Click(Sender: TObject);
    procedure MenuItem60Click(Sender: TObject);
    procedure MenuItem61Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem71Click(Sender: TObject);
    procedure MenuItem72Click(Sender: TObject);
    procedure MenuItem82Click(Sender: TObject);
    procedure MenuItem83Click(Sender: TObject);
    procedure MenuItem84Click(Sender: TObject);
    procedure MenuItem85Click(Sender: TObject);
    procedure MenuItem88Click(Sender: TObject);
    procedure MenuItem89Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem91Click(Sender: TObject);
    procedure MenuItem92Click(Sender: TObject);
    procedure PairSplitter1ChangeBounds(Sender: TObject);
    procedure PairSplitter1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PairSplitter1Resize(Sender: TObject);
    procedure PairSplitter2ChangeBounds(Sender: TObject);
    procedure PairSplitter2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PairSplitter2Resize(Sender: TObject);
    procedure PopupNotifier1Close(Sender: TObject; var CloseAction: TCloseAction
      );
    procedure Timer1Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Timer4StartTimer(Sender: TObject);
    procedure Timer4StopTimer(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure Timer6Timer(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure ToolButton12Click(Sender: TObject);
    procedure ToolButton14Click(Sender: TObject);
    procedure ToolButton15Click(Sender: TObject);
    procedure ToolButton16Click(Sender: TObject);
    procedure ToolButton17Click(Sender: TObject);
    procedure ToolButton19Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton20Click(Sender: TObject);
    procedure ToolButton22Click(Sender: TObject);
    procedure ToolButton23Click(Sender: TObject);
    procedure ToolButton24Click(Sender: TObject);
    procedure ToolButton25Click(Sender: TObject);
    procedure ToolButton26Click(Sender: TObject);
    procedure ToolButton28Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton31Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure TrayIcon1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TreeView1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure TreeView1DblClick(Sender: TObject);
    procedure TreeView1Edited(Sender: TObject; Node: TTreeNode; var S: string);
    procedure TreeView1Editing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure TreeView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TreeView1SelectionChanged(Sender: TObject);
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
  Form1: TForm1;
  wtp:TProcess;
  onestart:boolean=true;
  hilo:array of DownThread;
  phttp,phttpport,phttps,phttpsport,pftp,pftpport,nphost,puser,ppassword,cntlmhost,cntlmport:string;
  useproxy:integer;
  useaut:boolean;
  shownotifi:boolean;
  hiddenotifi:integer;
  notifipos:integer;
  ddowndir:string='';
  clipboardmonitor:boolean;
  columnname,columnurl,columnpercent,columnsize,columncurrent,columnspeed,columnestimate, columndate, columndestiny,columnengine,columnparameters,columnuser,columnpass,columnstatus,columnid, columntries, columnuid, columntype, columnqueue, columncookie:integer;
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
  showgridlines,showcommandout:boolean;
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
  function urlexists(url:string):boolean;
  function destinyexists(destiny:string):boolean;
  function suggestdir(doc:string):string;
  procedure playsound(soundfile:string);
  procedure newqueue();
  procedure setconfig();
  procedure enginereload();
  procedure configdlg();
  procedure poweroff;
  procedure savemydownloads;
  procedure stopqueue(indice:integer);
implementation
{$R *.lfm}
{ TForm1 }
resourcestring
startqueuesystray='Start queue';
stopqueuesystray='Stop queue';
folderdownname='Downloads';
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
      trayicons[x].PopUpMenu:=Form1.PopupMenu4;
      trayicons[x].OnDblClick:=@trayicons[x].showinmain;
    end;
    if x<Form1.ListView1.Items.Count then
    begin
      if (Form1.ListView1.Items[x].SubItems[columnstatus]='1') and showdowntrayicon then
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
  for i:=0 to Form1.ListView2.Items.Count-1 do
  begin
    if Form1.ListView2.Items[i].SubItems[columnuid]=uid then
      result:=i;
  end;
end;

procedure newdownqueues();
var
  i:integer;
begin
  Form2.ComboBox2.Items.Clear;
  for i:=0 to Length(queues)-1 do
    Form2.ComboBox2.Items.Add(queuenames[i]);
end;

procedure newgrabberqueues();
var
  i:integer;
begin
  Form7.ComboBox1.Items.Clear;
  for i:=0 to Length(queues)-1 do
    Form7.ComboBox1.Items.Add(queuenames[i]);
end;

procedure queueindexselect();
begin
  Form2.ComboBox2.ItemIndex:=0;
  Form7.ComboBox1.ItemIndex:=0;
  if (Form1.TreeView1.SelectionCount>0) then
  begin
    if Form1.TreeView1.Selected.Level>0 then
    begin
      case Form1.TreeView1.Selected.Parent.Index of
        1:begin//colas
            Form2.ComboBox2.ItemIndex:=Form1.TreeView1.Selected.Index;
            Form7.ComboBox1.ItemIndex:=Form1.TreeView1.Selected.Index;
          end;
      end;
    end;
  end;
end;

procedure queuemenu.sendtoqueue(Sender:TObject);
var
  i:integer;
begin
  if (Form1.ListView1.ItemIndex<>-1) or (Form1.ListView1.SelCount>0) then
  begin
    for i:=0 to Form1.ListView1.Items.Count-1 do
    begin
      if Form1.ListView1.Items[i].Selected then
        Form1.ListView1.Items[i].SubItems[columnqueue]:=inttostr(Form1.MenuItem86.IndexOf(self));
    end;
  end;
  Form1.TreeView1SelectionChanged(nil);
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
  tmptreeindex: integer;
begin
  if Form1.TreeView1.Items.SelectionCount>0 then
    tmptreeindex:=Form1.TreeView1.Selected.AbsoluteIndex;

  Form1.TreeView1.Items[1].DeleteChildren;
  Form1.MenuItem86.Clear;

  for i:=Form1.PopupMenu1.Items.Count-1 downto 0 do
  begin
    if (Form1.PopupMenu1.Items[i].ImageIndex=7) or (Form1.PopupMenu1.Items[i].ImageIndex=8) then
      Form1.PopupMenu1.Items.Delete(i);
  end;

  for i:=0 to Length(queues)-1 do
  begin
    qtimer[i].qtindex:=i;
    stimer[i].stindex:=i;
    treeitem:=TTreeNode.Create(Form1.TreeView1.Items);
    treeitem:=Form1.TreeView1.Items.AddChild(Form1.TreeView1.Items[1],queuenames[i]);

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

    menuitem:=queuemenu.Create(Form1.MenuItem86);
    menuitem.Caption:=queuenames[i];
    menuitem.ImageIndex:=40;
    menuitem.OnClick:=@menuitem.sendtoqueue;
    stmenu:=stqueuemenu.Create(Form1.PopupMenu1);
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
    Form1.PopupMenu1.Items.Insert(Form1.PopupMenu1.Items.Count-4,stmenu);
    Form1.MenuItem86.Add(menuitem);
  end;

  Form1.TreeView1.Items[1].Expand(true);
  if (tmptreeindex>=0) and (tmptreeindex<Form1.TreeView1.Items.Count) then
    Form1.TreeView1.Items[tmptreeindex].Selected:=true;
end;

procedure categoryreload();
var
  treeitem:TTreeNode;
  i:integer;
begin
  Form1.TreeView1.Items.TopLvlItems[3].DeleteChildren;
  for i:=0 to Length(categoryextencions)-1 do
  begin
    treeitem:=TTreeNode.Create(Form1.TreeView1.Items);
    treeitem:=Form1.TreeView1.Items.AddChild(Form1.TreeView1.Items.TopLvlItems[3],categoryextencions[i][1]);
    treeitem.ImageIndex:=23;
    treeitem.SelectedIndex:=23;
  end;
  treeitem:=TTreeNode.Create(Form1.TreeView1.Items);
  treeitem:=Form1.TreeView1.Items.AddChild(Form1.TreeView1.Items.TopLvlItems[3],categoryothers);
  treeitem.ImageIndex:=23;
  treeitem.SelectedIndex:=23;
  Form1.TreeView1.Items.TopLvlItems[3].Expand(true);
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
  dlgForm.dlgtext.Caption:=rsForm.dlgdeletequeue.Caption;
  dlgForm.ShowModal;
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
      Form1.TreeView1.Items[1].Selected:=true;
      newdownqueues();
      queuesreload();
    end;
  end;

  for i:=0 to Form1.ListView1.Items.Count-1 do
  begin
    if Form1.ListView1.Items[i].SubItems[columnqueue]=inttostr(indice) then
      Form1.ListView1.Items[i].SubItems[columnqueue]:='0';
    if strtoint(Form1.ListView1.Items[i].SubItems[columnqueue])>=indice then
      Form1.ListView1.Items[i].SubItems[columnqueue]:=inttostr(strtoint(Form1.ListView1.Items[i].SubItems[columnqueue])-1);
  end;
end;

procedure newqueue();
var
  nam:string;
begin
  nam:=rsForm.queuename.Caption+' '+inttostr(Length(queues)+1);

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

  qtimer[Length(queues)-1]:=queuetimer.Create(Form1);
  qtimer[Length(queues)-1].Enabled:=false;
  qtimer[Length(queues)-1].qtindex:=Length(queues)-1;
  qtimer[Length(queues)-1].OnTimer:=@qtimer[Length(queues)-1].ontime;
  qtimer[Length(queues)-1].OnStartTimer:=@qtimer[Length(queues)-1].ontimestart;
  qtimer[Length(queues)-1].OnStopTimer:=@qtimer[Length(queues)-1].ontimestop;
  qtimer[Length(queues)-1].Interval:=1000;

  stimer[Length(queues)-1]:=sheduletimer.Create(Form1);
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
  Form1.Caption:='AWGG '+Copy(version,0,LastDelimiter('.',version)-1)+' ALPHA BUILD '+Copy(version,LastDelimiter('.',version)+1,Length(version));

  {$IFDEF alpha}
    Form1.Caption:='AWGG '+Copy(version,0,LastDelimiter('.',version)-1)+' ALPHA BUILD '+Copy(version,LastDelimiter('.',version)+1,Length(version));
  {$ENDIF}

  {$IFDEF beta}
    Form1.Caption:='AWGG '+Copy(version,0,LastDelimiter('.',version)-1)+' BETA';
  {$ENDIF}

  {$IFDEF release}
    Form1.Caption:='AWGG '+Copy(version,0,LastDelimiter('.',version)-1);
  {$ENDIF}

  {$IFDEF alpha64}
    Form1.Caption:='AWGG '+Copy(version,0,LastDelimiter('.',version)-1)+' ALPHA BUILD '+Copy(version,LastDelimiter('.',version)+1,Length(version));
  {$ENDIF}

  {$IFDEF beta64}
    Form1.Caption:='AWGG '+Copy(version,0,LastDelimiter('.',version)-1)+' BETA';
  {$ENDIF}

  {$IFDEF release64}
    Form1.Caption:='AWGG '+Copy(version,0,LastDelimiter('.',version)-1);
  {$ENDIF}
end;
function uidexists(uid:string):boolean;
var
  n:integer;
  match:boolean;
begin
  match:=false;
  for n:=0 to Form1.ListView1.Items.Count-1 do
  begin
    if Form1.ListView1.items[n].SubItems[columnuid]=uid then
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
  for n:=0 to Form1.ListView1.Items.Count-1 do
  begin
    if (Form1.ListView1.Items[n].SubItems[columnqueue]=inttostr(indice)) and (Form1.ListView1.Items[n].SubItems[columnstatus]='1') then
      hilo[strtoint(Form1.ListView1.Items[n].SubItems[columnid])].shutdown();
  end;
end;

function urlexists(url:string):boolean;
var
  ni:integer;
  uexists:boolean;
begin
  uexists:=false;
  for ni:=0 to Form1.ListView1.Items.Count-1 do
  begin
    if Form1.ListView1.Items[ni].SubItems[columnurl] = url then
      uexists:=true;
  end;
  result:=uexists;
end;

function destinyexists(destiny:string):boolean;
var
  ni:integer;
  pathnodelim:string;
  downexists:boolean;
begin
  downexists:=false;
  for ni:=0 to Form1.ListView1.Items.Count-1 do
  begin
    pathnodelim:=Form1.ListView1.Items[ni].SubItems[columndestiny];
    if ExpandFileName(pathnodelim+pathdelim+Form1.ListView1.Items[ni].SubItems[columnname]) = ExpandFileName(destiny) then
      downexists:=true;
  end;
  result:=downexists;
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
  SetLength(trayicons,Form1.ListView1.Items.Count);
  for x:=0 to Form1.ListView1.Items.Count-1 do
  begin
    if Form1.ListView1.Items[x].SubItems[columnstatus]='1' then
      hilo[strtoint(Form1.ListView1.Items[x].SubItems[columnid])].thid:=x;
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
        trayicons[x].PopUpMenu:=Form1.PopupMenu4;
        trayicons[x].OnDblClick:=@trayicons[x].showinmain;
      end;
    except on e:exception do
    end;
    if (Form1.ListView1.Items[x].SubItems[columnstatus]='1') and showdowntrayicon then
      trayicons[x].Show;
  end;
  if Form1.ListView2.Visible then
  begin
    for x:=0 to Form1.ListView2.Items.Count-1 do
    begin
      if Form1.ListView2.Items[x].SubItems[columnstatus]='1' then
        hilo[strtoint(Form1.ListView2.Items[x].SubItems[columnid])].thid2:=x;
    end;
  end;
end;

procedure movestepup(steps:integer);
begin
  if (Form1.ListView1.SelCount>0) and (steps>=0) then
  begin
    Form1.ListView1.MultiSelect:=false;
    Form1.ListView1.Items.Move(Form1.ListView1.ItemIndex,steps);
    Form1.ListView1.MultiSelect:=true;
    rebuildids();
    if Form1.ListView2.Visible then
      Form1.TreeView1SelectionChanged(nil);
  end;
end;

procedure moveonestepup();
var
  i:integer;
  indexup:integer;
begin
  for i:=0 to Form1.ListView1.Items.Count-1 do
  begin
    if (Form1.ListView1.Items[i].SubItems[columnqueue]=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnqueue]) and (i<Form1.ListView1.ItemIndex) then
      indexup:=i;
  end;
  if (Form1.ListView1.SelCount>0) and (indexup>=0) and (indexup<Form1.ListView1.Items.Count) then
  begin
    Form1.ListView1.MultiSelect:=false;
    Form1.ListView1.Items.Move(Form1.ListView1.ItemIndex,indexup);
    Form1.ListView1.MultiSelect:=true;
    rebuildids();
    if Form1.ListView2.Visible then
      Form1.TreeView1SelectionChanged(nil);
  end;
end;

procedure movestepdown(steps:integer);
begin
  if (Form1.ListView1.SelCount>0) and (steps<Form1.ListView1.Items.Count) then
  begin
    Form1.ListView1.MultiSelect:=false;
    Form1.ListView1.Items.Move(Form1.ListView1.ItemIndex,steps);
    Form1.ListView1.MultiSelect:=true;
    rebuildids();
    if Form1.ListView2.Visible then
      Form1.TreeView1SelectionChanged(nil);
  end;
end;

procedure moveonestepdown(indice:integer;numsteps:integer=0);
var
  i:integer;
  indexdown:integer;
begin
  for i:=0 to Form1.ListView1.Items.Count-1 do
  begin
    if (Form1.ListView1.Items[i].SubItems[columnqueue]=Form1.ListView1.Items[indice].SubItems[columnqueue]) and (i>indice+numsteps) then
    begin
      indexdown:=i;
      break;
    end;
  end;
  if (indexdown<Form1.ListView1.Items.Count) then
  begin
    Form1.ListView1.MultiSelect:=false;
    Form1.ListView1.Items.Move(indice,indexdown);
    Form1.ListView1.MultiSelect:=true;
    rebuildids();
    if Form1.ListView2.Visible then
      Form1.TreeView1SelectionChanged(nil);
  end;
end;

procedure updatelangstatus();
var
  x:integer;
begin
  for x:=0 to Form1.ListView1.Items.Count-1 do
  begin
    case Form1.ListView1.Items[x].SubItems[columnstatus] of
      '0':Form1.ListView1.Items[x].Caption:=rsForm.statuspaused.Caption;
      '1':Form1.ListView1.Items[x].Caption:=rsForm.statusinprogres.Caption;
      '2':Form1.ListView1.Items[x].Caption:=rsForm.statusstoped.Caption;
      '3':Form1.ListView1.Items[x].Caption:=rsForm.statuscomplete.Caption;
      '4':Form1.ListView1.Items[x].Caption:=rsForm.statuserror.Caption;
    end;
  end;
  for x:=0 to Form1.ListView2.Columns.Count-1 do
    Form1.ListView2.Columns[x].Caption:=Form1.ListView1.Columns[x].Caption;

  Form1.TreeView1.Items[0].Text:=rsform.alldowntreename.Caption;
  Form1.TreeView1.Items[1].Text:=rsform.queuestreename.Caption;
  Form1.TreeView1.Items[1].Items[0].Text:=rsform.queuemainname.Caption;
  Form1.TreeView1.Items[Form1.TreeView1.Items[1].Count+2].Text:=rsform.filtresname.Caption;
  Form1.TreeView1.Items[Form1.TreeView1.Items[1].Count+3].Text:=rsform.statuscomplete.Caption;
  Form1.TreeView1.Items[Form1.TreeView1.Items[1].Count+4].Text:=rsform.statusinprogres.Caption;
  Form1.TreeView1.Items[Form1.TreeView1.Items[1].Count+5].Text:=rsform.statusstoped.Caption;
  Form1.TreeView1.Items[Form1.TreeView1.Items[1].Count+6].Text:=rsform.statuserror.Caption;
  Form1.TreeView1.Items[Form1.TreeView1.Items[1].Count+7].Text:=rsform.statuspaused.Caption;
  Form1.TreeView1.Items.TopLvlItems[3].Text:=categoryfilter;
  Form3.TreeView1.Items[0].Text:=Form3.TabSheet1.Caption;
  Form3.TreeView1.Items[1].Text:=Form3.TabSheet2.Caption;
  Form3.TreeView1.Items[2].Text:=Form3.TabSheet3.Caption;
  Form3.TreeView1.Items[3].Text:=Form3.TabSheet17.Caption;
  Form3.TreeView1.Items[4].Text:=Form3.TabSheet4.Caption;
  Form3.TreeView1.Items[5].Text:=Form3.TabSheet5.Caption;
  Form3.TreeView1.Items[6].Text:=Form3.TabSheet6.Caption;
  Form3.TreeView1.Items[7].Text:=Form3.TabSheet7.Caption;
  Form3.TreeView1.Items[8].Text:=Form3.TabSheet8.Caption;
  Form3.TreeView1.Items[9].Text:=Form3.TabSheet11.Caption;
  Form3.TreeView1.Items[10].Text:=Form3.TabSheet9.Caption;
  Form3.TreeView1.Items[11].Text:=Form3.TabSheet10.Caption;
  Form3.TreeView1.Items[12].Text:=Form3.TabSheet15.Caption;
  Form3.TreeView1.Items[13].Text:=Form3.TabSheet16.Caption;
  Form3.TreeView1.Items[14].Text:=Form3.TabSheet18.Caption;
  Form1.TreeView1.Items.TopLvlItems[3][Form1.TreeView1.Items.TopLvlItems[3].SubTreeCount-2].Text:=categoryothers;
  Form3.Panel1.Caption:=Form3.PageControl1.Pages[Form3.PageControl1.TabIndex].Caption;
  Form3.CheckGroup5.Items[0]:=rsForm.sunday.Caption;
  Form3.CheckGroup5.Items[1]:=rsForm.monday.Caption;
  Form3.CheckGroup5.Items[2]:=rsForm.tuesday.Caption;
  Form3.CheckGroup5.Items[3]:=rsForm.wednesday.Caption;
  Form3.CheckGroup5.Items[4]:=rsForm.thursday.Caption;
  Form3.CheckGroup5.Items[5]:=rsForm.friday.Caption;
  Form3.CheckGroup5.Items[6]:=rsForm.saturday.Caption;
  Form3.CheckGroup4.Items[0]:=rsForm.runwiththesystem.Caption;
  Form3.CheckGroup4.Items[1]:=rsForm.startinthesystray.Caption;
  queuenames[0]:=rsform.queuemainname.Caption;
  if Form3.ComboBox4.Items.Count>0 then
    Form3.ComboBox4.Items[0]:=rsform.queuemainname.Caption;
  Form3.ComboBox1.Items[0]:=rsform.proxynot.Caption;
  Form3.ComboBox1.Items[1]:=rsform.proxysystem.Caption;
  Form3.ComboBox1.Items[2]:=rsform.proxymanual.Caption;
  Form3.CheckGroup1.Items[0]:=wgetdefarg1;
  Form3.CheckGroup1.Items[1]:=wgetdefarg2;
  Form3.CheckGroup1.Items[2]:=wgetdefarg3;
  Form3.CheckGroup1.Items[3]:=wgetdefarg4;
  Form3.CheckGroup2.Items[0]:=aria2defarg1;
  Form3.CheckGroup2.Items[1]:=aria2defarg2;
  Form3.CheckGroup3.Items[0]:=curldefarg1;
  queuesreload();
  newdownqueues();
end;

procedure enginereload();
begin
  Form2.ComboBox1.Items.Clear;
  Form3.ComboBox3.Items.Clear;

  if FileExistsUTF8(aria2crutebin) then
  begin
    Form2.ComboBox1.Items.Add('aria2c');
    Form3.ComboBox3.Items.Add('aria2c');
  end;

  if FileExistsUTF8(axelrutebin) then
  begin
    Form2.ComboBox1.Items.Add('axel');
    Form3.ComboBox3.Items.Add('axel');
  end;

  if FileExistsUTF8(curlrutebin) then
  begin
    Form2.ComboBox1.Items.Add('curl');
    Form3.ComboBox3.Items.Add('curl');
  end;

  if FileExistsUTF8(wgetrutebin) then
  begin
    Form2.ComboBox1.Items.Add('wget');
    Form3.ComboBox3.Items.Add('wget');
  end;

  //if FileExistsUTF8(lftprutebin) then
  //begin
    //Form2.ComboBox1.Items.Add('lftp');
    //Form3.ComboBox3.Items.Add('lftp');
  //end;

  //Seleccionar wget por defecto
  Form2.ComboBox1.ItemIndex:=Form2.ComboBox1.Items.IndexOf(defaultengine);
  Form3.ComboBox3.ItemIndex:=Form3.ComboBox3.Items.IndexOf(defaultengine);
  if Form2.ComboBox1.ItemIndex=-1 then
    Form2.ComboBox1.ItemIndex:=0;
  if Form3.ComboBox3.ItemIndex=-1 then
    Form3.ComboBox3.ItemIndex:=0;
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
  columncolaw:=Form1.ListView1.Column[0].Width;
  columnnamew:=Form1.ListView1.Column[columnname+1].Width;
  columnurlw:=Form1.ListView1.Column[columnurl+1].Width;
  columnpercentw:=Form1.ListView1.Column[columnpercent+1].Width;
  columnsizew:=Form1.ListView1.Column[columnsize+1].Width;
  columncurrentw:=Form1.ListView1.Column[columncurrent+1].Width;
  columnspeedw:=Form1.ListView1.Column[columnspeed+1].Width;
  columnestimatew:=Form1.ListView1.Column[columnestimate+1].Width;
  columndatew:=Form1.ListView1.Column[columndate+1].Width;
  columndestinyw:=Form1.ListView1.Column[columndestiny+1].Width;
  columnenginew:=Form1.ListView1.Column[columnengine+1].Width;
  columnparametersw:=Form1.ListView1.Column[columnparameters+1].Width;
  columncolav:=Form1.ListView1.Column[0].Visible;
  columnnamev:=Form1.ListView1.Column[columnname+1].Visible;
  columnurlv:=Form1.ListView1.Column[columnurl+1].Visible;
  columnpercentv:=Form1.ListView1.Column[columnpercent+1].Visible;
  columnsizev:=Form1.ListView1.Column[columnsize+1].Visible;
  columnspeedv:=Form1.ListView1.Column[columnspeed+1].Visible;
  columnestimatev:=Form1.ListView1.Column[columnestimate+1].Visible;
  columndatev:=Form1.ListView1.Column[columndate+1].Visible;
  columndestinyv:=Form1.ListView1.Column[columndestiny+1].Visible;
  columnenginev:=Form1.ListView1.Column[columnengine+1].Visible;
  columnparametersv:=Form1.ListView1.Column[columnparameters+1].Visible;
  limited:=Form1.CheckBox1.Checked;
  speedlimit:=Form1.FloatSpinEdit1.Text;
  maxgdown:=Form1.SpinEdit1.Value;
  showstdout:=Form1.MenuItem53.Checked;
  showgridlines:=Form1.ListView1.GridLines;
  showcommandout:=Form1.SynEdit1.Visible;
  showdowntrayicon:=Form1.MenuItem4.Checked;
  if showcommandout then
    splitpos:=Form1.PairSplitter1.Position;
  splithpos:=Form1.PairSplitter2.Position;
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
    ShowMessage(rsForm.msgerrorconfigsave.caption+e.ToString);
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
    useglobaluseragent:=iniconfigfile.ReadBool('Config','useglobaluseragent',false);
    globaluseragent:=iniconfigfile.ReadString('Config','globaluseragent','Mozilla/5.0');
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
    Form1.ListView1.Column[0].Width:=columncolaw;
    Form1.ListView1.Column[columnname+1].Width:=columnnamew;
    Form1.ListView1.Column[columnurl+1].Width:=columnurlw;
    Form1.ListView1.Column[columnpercent+1].Width:=columnpercentw;
    Form1.ListView1.Column[columnsize+1].Width:=columnsizew;
    Form1.ListView1.Column[columncurrent+1].Width:=columncurrentw;
    Form1.ListView1.Column[columnspeed+1].Width:=columnspeedw;
    Form1.ListView1.Column[columnestimate+1].Width:=columnestimatew;
    Form1.ListView1.Column[columndate+1].Width:=columndatew;
    Form1.ListView1.Column[columndestiny+1].Width:=columndestinyw;
    Form1.ListView1.Column[columnengine+1].Width:=columnenginew;
    Form1.ListView1.Column[columnparameters+1].Width:=columnparametersw;
    Form1.ListView1.Column[0].Visible:=columncolav;
    Form1.ListView1.Column[columnname+1].Visible:=columnnamev;
    Form1.ListView1.Column[columnurl+1].Visible:=columnurlv;
    Form1.ListView1.Column[columnpercent+1].Visible:=columnpercentv;
    Form1.ListView1.Column[columnsize+1].Visible:=columnsizev;
    Form1.ListView1.Column[columncurrent+1].Visible:=columncurrentv;
    Form1.ListView1.Column[columnspeed+1].Visible:=columnspeedv;
    Form1.ListView1.Column[columnestimate+1].Visible:=columnestimatev;
    Form1.ListView1.Column[columndate+1].Visible:=columndatev;
    Form1.ListView1.Column[columndestiny+1].Visible:=columndestinyv;
    Form1.ListView1.Column[columnengine+1].Visible:=columnenginev;
    Form1.ListView1.Column[columnparameters+1].Visible:=columnparametersv;

    Form1.MenuItem36.Checked:=columncolav;
    Form1.MenuItem37.Checked:=columnnamev;
    Form1.MenuItem38.Checked:=columnsizev;
    Form1.MenuItem23.Checked:=columncurrentv;
    Form1.MenuItem39.Checked:=columnurlv;
    Form1.MenuItem40.Checked:=columnspeedv;
    Form1.MenuItem41.Checked:=columnpercentv;
    Form1.MenuItem42.Checked:=columnestimatev;
    Form1.MenuItem82.Checked:=columndatev;
    Form1.MenuItem43.Checked:=columndestinyv;
    Form1.MenuItem44.Checked:=columnenginev;
    Form1.MenuItem24.Checked:=columnparametersv;
    Form1.ListView1.GridLines:=showgridlines;
    Form1.ListView2.GridLines:=showgridlines;
    Form1.CheckBox1.Checked:=limited;
    Form1.FloatSpinEdit1.Value:=strtofloat(speedlimit);
    Form1.SpinEdit1.Value:=maxgdown;
    Form1.MenuItem53.Checked:=showstdout;
    Form1.SynEdit1.Visible:=showcommandout;
    Form1.MenuItem53.Checked:=showcommandout;
    Form1.MenuItem53.Enabled:=showcommandout;
    Form1.MenuItem33.Checked:=showcommandout;
    Form1.MenuItem25.Checked:=showgridlines;
    Form1.Timer4.Enabled:=clipboardmonitor;
    Form1.ToolButton31.Down:=clipboardmonitor;
    Form1.MenuItem4.Checked:=showdowntrayicon;
    //if splitpos<20 then
      //splitpos:=20;
    //if splitpos>Form1.PairSplitter1.Height-20 then
      //splitpos:=splitpos-20;
    splitpos:=Round(Form1.PairSplitter1.Height/1.5);
    if showstdout then
      Form1.PairSplitter1.Position:=splitpos
    else
      Form1.PairSplitter1.Position:=Form1.PairSplitter1.Height;
    Form1.PairSplitter2.Position:=splithpos;
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
    Form1.Timer4.Enabled:=clipboardmonitor;
  except on e:exception do
    //ShowMessage(e.Message);
  end;
end;

procedure setconfig();
begin
  useproxy:=Form3.ComboBox1.ItemIndex;
  phttp:=Form3.Edit1.Text;
  phttpport:=Form3.SpinEdit1.Text;
  phttps:=Form3.Edit2.Text;
  phttpsport:=Form3.SpinEdit2.Text;
  pftp:=Form3.Edit3.Text;
  pftpport:=Form3.SpinEdit3.Text;
  nphost:=Form3.Edit4.Text;
  useaut:=Form3.CheckBox2.Checked;
  puser:=Form3.Edit5.Text;
  ppassword:=Form3.Edit6.Text;
  shownotifi:=Form3.CheckBox4.Checked;
  hiddenotifi:=Form3.SpinEdit4.Value;
  clipboardmonitor:=Form3.CheckBox6.Checked;
  Form1.Timer4.Enabled:=clipboardmonitor;
  ddowndir:=Form3.DirectoryEdit1.Text;
  dotherdowndir:=ddowndir+pathdelim+'Others';
  wgetrutebin:=Form3.FiLeNameEdit1.Text;
  aria2crutebin:=Form3.FiLeNameEdit2.Text;
  curlrutebin:=Form3.FiLeNameEdit3.Text;
  axelrutebin:=Form3.FileNameEdit4.Text;
  wgetargs:=Form3.Edit7.Text;
  aria2cargs:=Form3.Edit8.Text;
  curlargs:=Form3.Edit9.Text;
  axelargs:=Form3.Edit10.Text;
  wgetdefcontinue:=Form3.CheckGroup1.Checked[0];
  wgetdefnh:=Form3.CheckGroup1.Checked[1];
  wgetdefnd:=Form3.CheckGroup1.Checked[2];
  wgetdefncert:=Form3.CheckGroup1.Checked[3];
  aria2cdefcontinue:=Form3.CheckGroup2.Checked[0];
  aria2cdefallocate:=Form3.CheckGroup2.Checked[1];
  aria2splitsize:=Form3.Edit12.Text;
  aria2splitnum:=Form3.SpinEdit5.Value;
  aria2split:=Form3.CheckBox15.Checked;
  curldefcontinue:=Form3.CheckGroup3.Checked[0];
  autostartwithsystem:=Form3.CheckGroup4.Checked[0];
  autostartminimized:=Form3.CheckGroup4.Checked[1];
  logger:=Form3.Checkbox1.Checked;
  logpath:=Form3.DirectoryEdit2.Text;
  notifipos:=Form3.RadioGroup1.ItemIndex;
  dtimeout:=Form3.SpinEdit10.Value;
  dtries:=Form3.SpinEdit11.Value;
  ddelay:=Form3.SpinEdit12.Value;
  deflanguage:=Form3.ComboBox2.Text;
  defaultengine:=Form3.ComboBox3.Text;
  playsounds:=Form3.CheckBox7.Checked;
  queuelimits[Form3.ComboBox4.ItemIndex]:=Form3.CheckBox8.Checked;
  queuepoweroff[Form3.ComboBox4.ItemIndex]:=Form3.CheckBox13.Checked;
  queuerotate:=Form3.CheckBox9.Checked;
  downcompsound:=Form3.FileNameEdit6.Text;
  downstopsound:=Form3.FileNameEdit7.Text;
  triesrotate:=Form3.SpinEdit13.Value;
  if Form3.RadioButton1.Checked then
    rotatemode:=0;
  if Form3.RadioButton2.Checked then
    rotatemode:=1;
  if Form3.RadioButton3.Checked then
    rotatemode:=2;
  queuedelay:=Form3.SpinEdit14.Value;
  useglobaluseragent:=Form3.CheckBox14.Checked;
  globaluseragent:=Form3.Edit11.Text;
  sameproxyforall:=Form3.CheckBox5.Checked;
  loadhistorylog:=Form3.CheckBox12.Checked;
  if Form3.RadioButton4.Checked=true then
    loadhistorymode:=1;
  if Form3.RadioButton5.Checked=true then
    loadhistorymode:=2;
  if Form3.RadioButton6.Checked=true then
    defaultdirmode:=1;
  if Form3.RadioButton7.Checked=true then
    defaultdirmode:=2;
  qtimerenable[Form3.ComboBox4.ItemIndex]:=Form3.CheckBox11.Checked;
  qallday[Form3.ComboBox4.ItemIndex]:=Form3.CheckBox3.Checked;
  queuestarttimes[Form3.ComboBox4.ItemIndex]:=strtotime(inttostr(Form3.SpinEdit6.Value)+':'+inttostr(Form3.SpinEdit7.Value)+':00');
  queuestoptimes[Form3.ComboBox4.ItemIndex]:=strtotime(inttostr(Form3.SpinEdit8.Value)+':'+inttostr(Form3.SpinEdit9.Value)+':00');
  queuestartdates[Form3.ComboBox4.ItemIndex]:=Form3.DateEdit1.Date;
  qstop[Form3.ComboBox4.ItemIndex]:=Form3.CheckBox10.Checked;
  queuestopdates[Form3.ComboBox4.ItemIndex]:=Form3.DateEdit2.Date;
  qdomingo[Form3.ComboBox4.ItemIndex]:=Form3.CheckGroup5.Checked[0];
  qlunes[Form3.ComboBox4.ItemIndex]:=Form3.CheckGroup5.Checked[1];
  qmartes[Form3.ComboBox4.ItemIndex]:=Form3.CheckGroup5.Checked[2];
  qmiercoles[Form3.ComboBox4.ItemIndex]:=Form3.CheckGroup5.Checked[3];
  qjueves[Form3.ComboBox4.ItemIndex]:=Form3.CheckGroup5.Checked[4];
  qviernes[Form3.ComboBox4.ItemIndex]:=Form3.CheckGroup5.Checked[5];
  qsabado[Form3.ComboBox4.ItemIndex]:=Form3.CheckGroup5.Checked[6];
  if Form3.ListBox1.ItemIndex<>-1 then
    categoryextencionstmp[Form3.ListBox1.ItemIndex][0]:=Form3.DirectoryEdit3.Text;
  categoryextencions:=categoryextencionstmp;
  SetDefaultLang(deflanguage);
  updatelangstatus();
  titlegen();
  saveconfig();
  stimer[Form3.ComboBox4.ItemIndex].Enabled:=qtimerenable[Form3.ComboBox4.ItemIndex];
  categoryreload();
end;

procedure configdlg();
var
  itemfile:TSearchRec;
  i:integer;
begin
  try
    Form3.ComboBox1.ItemIndex:=useproxy;
    Form3.Edit1.Text:=phttp;
    Form3.SpinEdit1.Value:=strtoint(phttpport);
    Form3.Edit2.Text:=phttps;
    Form3.SpinEdit2.Value:=strtoint(phttpsport);
    Form3.Edit3.Text:=pftp;
    Form3.SpinEdit3.Value:=strtoint(pftpport);
    Form3.Edit4.Text:=nphost;
    Form3.CheckBox2.Checked:=useaut;
    Form3.Edit5.Text:=puser;
    Form3.Edit6.Text:=ppassword;
    Form3.CheckBox6.Checked:=clipboardmonitor;
    Form3.DirectoryEdit1.Text:=ddowndir;
    Form3.CheckBox4.Checked:=shownotifi;
    Form3.SpinEdit4.Value:=hiddenotifi;
    Form3.FiLeNameEdit1.Text:=wgetrutebin;
    Form3.FiLeNameEdit2.Text:=aria2crutebin;
    Form3.FiLeNameEdit3.Text:=curlrutebin;
    Form3.FileNameEdit4.Text:=axelrutebin;
    Form3.Edit7.Text:=wgetargs;
    Form3.Edit8.Text:=aria2cargs;
    Form3.Edit9.Text:=curlargs;
    Form3.Edit10.Text:=axelargs;
    Form3.CheckGroup1.Checked[0]:=wgetdefcontinue;
    Form3.CheckGroup1.Checked[1]:=wgetdefnh;
    Form3.CheckGroup1.Checked[2]:=wgetdefnd;
    Form3.CheckGroup1.Checked[3]:=wgetdefncert;
    Form3.CheckGroup2.Checked[0]:=aria2cdefcontinue;
    Form3.CheckGroup2.Checked[1]:=aria2cdefallocate;
    Form3.SpinEdit5.Value:=aria2splitnum;
    Form3.Edit12.Text:=aria2splitsize;
    Form3.CheckBox15.Checked:=aria2split;
    Form3.CheckGroup3.Checked[0]:=curldefcontinue;
    Form3.CheckGroup4.Checked[0]:=autostartwithsystem;
    Form3.CheckGroup4.Checked[1]:=autostartminimized;
    Form3.Checkbox1.Checked:=logger;
    Form3.DirectoryEdit2.Text:=logpath;
    Form3.RadioGroup1.ItemIndex:=notifipos;
    Form3.SpinEdit10.Value:=dtimeout;
    Form3.SpinEdit11.Value:=dtries;
    Form3.SpinEdit12.Value:=ddelay;
    Case useproxy of
      0,1:
        begin
          Form3.Edit1.Enabled:=false;
          Form3.Edit2.Enabled:=false;
          Form3.Edit3.Enabled:=false;
          Form3.Edit4.Enabled:=false;
          Form3.Edit5.Enabled:=false;
          Form3.Edit6.Enabled:=false;
          Form3.Label1.Enabled:=false;
          Form3.Label2.Enabled:=false;
          Form3.Label3.Enabled:=false;
          Form3.Label4.Enabled:=false;
          Form3.Label5.Enabled:=false;
          Form3.Label6.Enabled:=false;
          Form3.Label7.Enabled:=false;
          Form3.Label8.Enabled:=false;
          Form3.Label9.Enabled:=false;
          Form3.Label27.Enabled:=false;
          Form3.SpinEdit1.Enabled:=false;
          Form3.SpinEdit2.Enabled:=false;
          Form3.SpinEdit3.Enabled:=false;
          Form3.CheckBox5.Enabled:=false;
          Form3.CheckBox2.Enabled:=false;
        end;
      2,3:
        begin
          Form3.Edit1.Enabled:=true;
          Form3.Edit2.Enabled:=true;
          Form3.Edit3.Enabled:=true;
          Form3.Edit4.Enabled:=true;
          Form3.Edit5.Enabled:=true;
          Form3.Edit6.Enabled:=true;
          Form3.Label1.Enabled:=true;
          Form3.Label2.Enabled:=true;
          Form3.Label3.Enabled:=true;
          Form3.Label4.Enabled:=true;
          Form3.Label5.Enabled:=true;
          Form3.Label6.Enabled:=true;
          Form3.Label7.Enabled:=true;
          Form3.Label8.Enabled:=true;
          Form3.Label9.Enabled:=true;
          Form3.Label27.Enabled:=true;
          Form3.SpinEdit1.Enabled:=true;
          Form3.SpinEdit2.Enabled:=true;
          Form3.SpinEdit3.Enabled:=true;
          Form3.CheckBox5.Enabled:=true;
          Form3.CheckBox2.Enabled:=true;
        end;
    end;
    Form3.ComboBox2.Items.Clear;
    if FindFirst(ExtractFilePath(UTF8ToSys(Application.Params[0]))+pathdelim+'languages'+pathdelim+'awgg.*.po',faAnyFile,itemfile)=0 then
    begin
      Repeat
        try
          Form3.ComboBox2.Items.Add(Copy(itemfile.name,Pos('awgg.',itemfile.name)+5,Pos('.po',itemfile.name)-6));
        except
        on E:Exception do ShowMessage('The file '+itemfile.Name+' of language is not valid');
        end;
      Until FindNext(itemfile)<>0;
    end;
    Form3.ComboBox2.ItemIndex:=Form3.ComboBox2.Items.IndexOf(deflanguage);
    enginereload();
    Form3.CheckBox7.Checked:=playsounds;
    Form3.CheckBox9.Checked:=queuerotate;
    Form3.FileNameEdit6.Text:=downcompsound;
    Form3.FileNameEdit7.Text:=downstopsound;
    Form3.SpinEdit13.Value:=triesrotate;
    if rotatemode=0 then
      Form3.RadioButton1.Checked:=true;
    if rotatemode=1 then
      Form3.RadioButton2.Checked:=true;
    if rotatemode=2 then
      Form3.RadioButton3.Checked:=true;
    Form3.SpinEdit14.Value:=queuedelay;
    Form3.CheckBox14.Checked:=useglobaluseragent;
    Form3.Edit11.Text:=globaluseragent;
    Form3.CheckBox5.Checked:=sameproxyforall;
    Form3.CheckBox12.Checked:=loadhistorylog;
    if loadhistorymode=1 then
      Form3.RadioButton4.Checked:=true;
    if loadhistorymode=2 then
      Form3.RadioButton5.Checked:=true;
    Form3.ComboBox4.Items.Clear;
    for i:=0 to Length(queues)-1 do
    begin
      Form3.ComboBox4.Items.Add(queuenames[i]);
    end;
    ///////////////////////
    Form3.ComboBox4.ItemIndex:=0;
    if (Form1.TreeView1.SelectionCount>0) then
    begin
      if Form1.TreeView1.Selected.Level>0 then
      begin
        case Form1.TreeView1.Selected.Parent.Index of
          1:begin//colas
              Form3.ComboBox4.ItemIndex:=Form1.TreeView1.Selected.Index;
            end;
        end;
      end;
    end;
    ///////////////////////
    Form3.CheckBox11.Checked:=qtimerenable[Form3.ComboBox4.ItemIndex];
    Form3.CheckBox3.Checked:=qallday[Form3.ComboBox4.ItemIndex];
    Form3.SpinEdit6.Value:=HourOf(queuestarttimes[Form3.ComboBox4.ItemIndex]);
    Form3.SpinEdit7.Value:=MinuteOf(queuestarttimes[Form3.ComboBox4.ItemIndex]);
    Form3.DateEdit1.Date:=queuestartdates[Form3.ComboBox4.ItemIndex];
    Form3.CheckBox10.Checked:=qstop[Form3.ComboBox4.ItemIndex];
    Form3.SpinEdit8.Value:=HourOf(queuestoptimes[Form3.ComboBox4.ItemIndex]);
    Form3.SpinEdit9.Value:=MinuteOf(queuestoptimes[Form3.ComboBox4.ItemIndex]);
    Form3.DateEdit2.Date:=queuestopdates[Form3.ComboBox4.ItemIndex];
    Form3.CheckGroup5.Checked[0]:=qdomingo[Form3.ComboBox4.ItemIndex];
    Form3.CheckGroup5.Checked[1]:=qlunes[Form3.ComboBox4.ItemIndex];
    Form3.CheckGroup5.Checked[2]:=qmartes[Form3.ComboBox4.ItemIndex];
    Form3.CheckGroup5.Checked[3]:=qmiercoles[Form3.ComboBox4.ItemIndex];
    Form3.CheckGroup5.Checked[4]:=qjueves[Form3.ComboBox4.ItemIndex];
    Form3.CheckGroup5.Checked[5]:=qviernes[Form3.ComboBox4.ItemIndex];
    Form3.CheckGroup5.Checked[6]:=qsabado[Form3.ComboBox4.ItemIndex];
    Form3.CheckBox8.Checked:=queuelimits[Form3.ComboBox4.ItemIndex];
    Form3.CheckBox13.Checked:=queuepoweroff[Form3.ComboBox4.ItemIndex];
    case defaultdirmode of
      1:Form3.RadioButton6.Checked:=true;
      2:Form3.RadioButton6.Checked:=false;
    end;
    categoryextencionstmp:=categoryextencions;
  except on e:exception do
    ShowMessage(e.Message);
  end;
end;

procedure startsheduletimer();
begin
  if Form1.TreeView1.SelectionCount>0 then
  begin
    if Form1.TreeView1.Selected.Level>0 then
    begin
      case Form1.TreeView1.Selected.Parent.Index of
        1:begin//colas
            if qtimerenable[Form1.TreeView1.Selected.Index] then
              stimer[Form1.TreeView1.Selected.Index].Enabled:=true
            else
            begin
              Form3.PageControl1.TabIndex:=1;
              configdlg();
              Form3.ShowModal;
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
  Form1.Timer3.Enabled:=false;
  Form1.Timer4.Enabled:=false;
  for i:=0 to Length(queues)-1 do
  begin
    stimer[i].Enabled:=false;
    qtimer[i].Enabled:=false;
  end;
  for  i:=0 to Form1.ListView1.Items.Count-1 do
  begin
    try
      if Form1.ListView1.Items[i].SubItems[columnstatus]='1' then
      begin
      if force then
        hilo[strtoint(Form1.ListView1.Items[i].SubItems[columnid])].wthp.Terminate(0)
      else
        hilo[strtoint(Form1.ListView1.Items[i].SubItems[columnid])].shutdown();
      end;
      sleep(1);
    except on e:exception do
    end;
  end;
  if Form1.ListView1.ItemIndex<>-1 then
  begin
    Form1.ToolButton3.Enabled:=true;
    Form1.ToolButton4.Enabled:=false;
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
  if Not DirectoryExistsUTF8(Form1.ListView1.Items[indice].SubItems[columndestiny]) then
  begin
    ForceDirectory(Form1.ListView1.Items[indice].SubItems[columndestiny]);
  end;
  if indice<>-1 then
  begin
    if Form1.ListView1.Items[indice].SubItems[columnstatus]<>'1' then
    begin
      tmps:=TstringList.Create;
      if Form1.ListView1.Items[indice].SubItems[columntype]='0' then
      begin
        ///////////////////***WGET****////////////////////
        if Form1.ListView1.Items[indice].SubItems[columnengine]='wget' then
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
          if WordCount(Form1.ListView1.Items[indice].SubItems[columnparameters],[' '])>0 then
          begin
            for wrn:=1 to WordCount(Form1.ListView1.Items[indice].SubItems[columnparameters],[' ']) do
              tmps.Add(ExtractWord(wrn,Form1.ListView1.Items[indice].SubItems[columnparameters],[' ']));
          end;
          tmps.Add('-e');
          tmps.Add('recursive=off');//Descativar para la opcion -O
          tmps.Add('-S');//Mouestra la respuesta del servidor
          if Form1.ListView1.Items[indice].SubItems[columnname]<>'' then
          begin
            tmps.Add('-O');
            tmps.Add(UTF8ToSys(Form1.ListView1.Items[indice].SubItems[columnname]));
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
          if Form1.CheckBox1.Checked then
            tmps.Add('--limit-rate='+floattostr(Form1.FloatSpinEdit1.Value)+'k');//limite de velocidad
          if wgetdefnh then
            tmps.Add('-nH');//No crear directorios del Host
          if wgetdefnd then
            tmps.Add('-nd');//No crear directorios
          if wgetdefncert then
            tmps.Add('--no-check-certificate');//No verificar certificados SSL
          tmps.Add('-P');//Destino de la descarga
          tmps.Add('"'+ExtractShortPathName(UTF8ToSys(Form1.ListView1.Items[indice].SubItems[columndestiny]))+'"');
          tmps.Add('-t');
          tmps.Add(inttostr(dtries));
          tmps.Add('-T');
          tmps.Add(inttostr(dtimeout));
          tmps.Add('-w');
          tmps.Add(inttostr(ddelay));
          if (Form1.ListView1.Items[indice].SubItems[columnuser]<>'') and (Form1.ListView1.Items[indice].SubItems[columnpass]<>'') then
          begin
            if UpperCase(Copy(Form1.ListView1.Items[indice].SubItems[columnurl],0,3))='HTT' then
            begin
              tmps.Add('--http-user='+Form1.ListView1.Items[indice].SubItems[columnuser]);
              tmps.Add('--http-password='+Form1.ListView1.Items[indice].SubItems[columnpass]);
            end;
            if UpperCase(Copy(Form1.ListView1.Items[indice].SubItems[columnurl],0,3))='FTP' then
            begin
              tmps.Add('--ftp-user='+Form1.ListView1.Items[indice].SubItems[columnuser]);
              tmps.Add('--ftp-password='+Form1.ListView1.Items[indice].SubItems[columnpass]);
            end;
          end;
          if useglobaluseragent then
            tmps.Add('--user-agent="'+globaluseragent+'"');
          if Form1.ListView1.Items[indice].SubItems[columncookie]<>'' then
          begin
            tmps.Add('--content-disposition');
            tmps.Add('--load-cookies='+Form1.ListView1.Items[indice].SubItems[columncookie]);
          end;
          if FileExists(Form1.ListView1.Items[indice].SubItems[columnurl]) then
            tmps.Add('-i');//Fichero de entrada
          tmps.Add(Form1.ListView1.Items[indice].SubItems[columnurl]);
        end;
        /////////////////***END***//////////////////

        /////////////////***ARIA2***///////////////
        if Form1.ListView1.Items[indice].SubItems[columnengine] = 'aria2c' then
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
          if WordCount(Form1.ListView1.Items[indice].SubItems[columnparameters],[' '])>0 then
          begin
            for wrn:=1 to WordCount(Form1.ListView1.Items[indice].SubItems[columnparameters],[' ']) do
              tmps.Add(ExtractWord(wrn,Form1.ListView1.Items[indice].SubItems[columnparameters],[' ']));
          end;
          tmps.Add('--check-certificate=false');//Ignorar certificados
          tmps.Add('--summary-interval=1');//intervalo del sumario de descargas
          if Form1.ListView1.Items[indice].SubItems[columnname]<>'' then
          begin
            tmps.Add('-o');
            tmps.Add(UTF8ToSys(Form1.ListView1.Items[indice].SubItems[columnname]));
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
          tmps.Add(ExtractShortPathName(UTF8ToSys(Form1.ListView1.Items[indice].SubItems[columndestiny])));
          if Form1.CheckBox1.Checked then
            tmps.Add('--max-download-limit='+floattostr(Form1.FloatSpinEdit1.Value)+'K');
          tmps.Add('-m');
          tmps.Add(inttostr(dtries));
          tmps.Add('-t');
          tmps.Add(inttostr(dtimeout));
          tmps.Add('--retry-wait='+inttostr(ddelay));
          if (Form1.ListView1.Items[indice].SubItems[columnuser]<>'') and (Form1.ListView1.Items[indice].SubItems[columnpass]<>'') then
          begin
            if UpperCase(Copy(Form1.ListView1.Items[indice].SubItems[columnurl],0,3))='HTT' then
            begin
              tmps.Add('--http-user='+Form1.ListView1.Items[indice].SubItems[columnuser]);
              tmps.Add('--http-passwd='+Form1.ListView1.Items[indice].SubItems[columnpass]);
            end;
            if UpperCase(Copy(Form1.ListView1.Items[indice].SubItems[columnurl],0,3))='FTP' then
            begin
              tmps.Add('--ftp-user='+Form1.ListView1.Items[indice].SubItems[columnuser]);
              tmps.Add('--ftp-passwd='+Form1.ListView1.Items[indice].SubItems[columnpass]);
            end;
          end;
          if useglobaluseragent then
            tmps.Add('--user-agent="'+globaluseragent+'"');
          if Form1.ListView1.Items[indice].SubItems[columncookie]<>'' then
          begin
            tmps.Add('--load-cookies='+Form1.ListView1.Items[indice].SubItems[columncookie]);
          end;
          tmps.Add(Form1.ListView1.Items[indice].SubItems[columnurl]);
        end;
        ///////////////***END***////////////////

        //////////////***CURL***////////////////
        if Form1.ListView1.Items[indice].SubItems[columnengine] = 'curl' then
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
          if WordCount(Form1.ListView1.Items[indice].SubItems[columnparameters],[' '])>0 then
          begin
            for wrn:=1 to WordCount(Form1.ListView1.Items[indice].SubItems[columnparameters],[' ']) do
              tmps.Add(ExtractWord(wrn,Form1.ListView1.Items[indice].SubItems[columnparameters],[' ']));
          end;
          tmps.Add('-k');//Ignorar certificados
          tmps.Add('-i');//Muestra la respuesta del servidor
          if Form1.ListView1.Items[indice].SubItems[columnname]<>'' then
          begin
            tmps.Add('-o');
            tmps.Add('"'+UTF8ToSys(Form1.ListView1.Items[indice].SubItems[columnname])+'"');
          end;
          tmps.Add('-O');
          if curldefcontinue and (not restart) then
          begin
            tmps.Add('-C');
            tmps.Add('-');
          end;
          if Form1.CheckBox1.Checked then
          begin
            tmps.Add('--limit-rate');
            tmps.Add(inttostr(round(Form1.FloatSpinEdit1.Value))+'K');
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
          if (Form1.ListView1.Items[indice].SubItems[columnuser]<>'') and (Form1.ListView1.Items[indice].SubItems[columnpass]<>'') then
          begin
            tmps.Add('-u');
            tmps.Add(Form1.ListView1.Items[indice].SubItems[columnuser]+':'+Form1.ListView1.Items[indice].SubItems[columnpass]);
          end;
          if useglobaluseragent then
          begin
            tmps.Add('-A');
            tmps.Add('"'+globaluseragent+'"');
          end;
          if Form1.ListView1.Items[indice].SubItems[columncookie]<>'' then
          begin
            tmps.Add('-b');
            tmps.Add(Form1.ListView1.Items[indice].SubItems[columncookie]);
          end;
          tmps.Add(Form1.ListView1.Items[indice].SubItems[columnurl]);
        end;
        /////////////////***END***////////////////////

        /////////////////***AXEL***//////////////////
        if Form1.ListView1.Items[indice].SubItems[columnengine] = 'axel' then
        begin
          ////Parametros generales
          if WordCount(axelargs,[' '])>0 then
          begin
            for wrn:=1 to WordCount(axelargs,[' ']) do
              tmps.Add(ExtractWord(wrn,axelargs,[' ']));
          end;
          ////Parametros para cada descarga
          if WordCount(Form1.ListView1.Items[indice].SubItems[columnparameters],[' '])>0 then
          begin
           for wrn:=1 to WordCount(Form1.ListView1.Items[indice].SubItems[columnparameters],[' ']) do
             tmps.Add(ExtractWord(wrn,Form1.ListView1.Items[indice].SubItems[columnparameters],[' ']));
          end;
          if Form1.CheckBox1.Checked then
          begin
            tmps.Add('-s');
            tmps.Add(floattostr(Form1.FloatSpinEdit1.Value*1024));
          end;
          tmps.Add('-v');
          tmps.Add('-a');
          case useproxy of
            0:tmps.Add('-N');
           {3:begin
           //Tal vez modificar la configuracion de .axelrc al vuelo
              end;}
          end;
          if Form1.ListView1.Items[indice].SubItems[columnname]<>'' then
          begin
            tmps.Add('-o');
            tmps.Add(UTF8ToSys(Form1.ListView1.Items[indice].SubItems[columndestiny]+pathdelim+Form1.ListView1.Items[indice].SubItems[columnname]));
          end;
          tmps.Add(Form1.ListView1.Items[indice].SubItems[columnurl]);
        end;
        ///////////////////***END***///////////////////

        ///////////////////***LFTP***//////////////////
        if Form1.ListView1.Items[indice].SubItems[columnengine] = 'lftp' then
        begin
          ////Parametros generales
          if WordCount(lftpargs,[' '])>0 then
          begin
            for wrn:=1 to WordCount(lftpargs,[' ']) do
              tmps.Add(ExtractWord(wrn,lftpargs,[' ']));
          end;
          ////Parametros para cada descarga
          if WordCount(Form1.ListView1.Items[indice].SubItems[columnparameters],[' '])>0 then
          begin
            for wrn:=1 to WordCount(Form1.ListView1.Items[indice].SubItems[columnparameters],[' ']) do
              tmps.Add(ExtractWord(wrn,Form1.ListView1.Items[indice].SubItems[columnparameters],[' ']));
          end;
          if Form1.CheckBox1.Checked then
          begin
            //tmps.Add('-s');
            //tmps.Add(floattostr(Form1.FloatSpinEdit1.Value*1024));
          end;
          case useproxy of
            0:
            begin
              tmps.Add('-c');
              {$IFDEF UNIX}
                tmps.Add('pget -c -n 4 "'+Form1.ListView1.Items[indice].SubItems[columnurl]+'" -o "'+ExtractShortPathName(Form1.ListView1.Items[indice].SubItems[columnname])+'"');
              {$ENDIF}
              {$IFDEF WINDOWS}
                tmps.Add('"pget -c -n 4 '+Form1.ListView1.Items[indice].SubItems[columnurl]+' -o '+ExtractShortPathName(Form1.ListView1.Items[indice].SubItems[columnname])+'"');
              {$ENDIF}
            end;
            2:
            begin
              tmps.Add('-c');
              {$IFDEF UNIX}
                tmps.Add('set http:proxy "http://'+puser+':'+ppassword+'@'+phttp+':'+phttpport+'" && pget -c -n 4 "'+Form1.ListView1.Items[indice].SubItems[columnurl]+'" -o "'+ExtractShortPathName(Form1.ListView1.Items[indice].SubItems[columnname])+'"');
              {$ENDIF}
              {$IFDEF WINDOWS}
                tmps.Add('set http:proxy http://'+puser+':'+ppassword+'@'+phttp+':'+phttpport+' && pget -c -n 4 '+Form1.ListView1.Items[indice].SubItems[columnurl]+' -o "'+ExtractShortPathName(Form1.ListView1.Items[indice].SubItems[columnname])+'"');
              {$ENDIF}
            end;
          end;
          if Form1.ListView1.Items[indice].SubItems[columnname]<>'' then
          begin
            //tmps.Add('-c');
            //tmps.Add('pget -c -n 8 '+Form1.ListView1.Items[indice].SubItems[columnurl]+'" -o "'+ExtractShortPathName(Form1.ListView1.Items[indice].SubItems[columnname])+'"');
          end
          else
          begin
            tmps.Add('-e');
            tmps.Add('pget "'+Form1.ListView1.Items[indice].SubItems[columnurl]+'"');
          end;
        end;
        //////////////////////***END***////////////////////
      end;

      if Form1.ListView1.Items[indice].SubItems[columntype] = '1' then
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
        //Parametros por descargas
        if WordCount(Form1.ListView1.Items[indice].SubItems[columnparameters],[' '])>0 then
        begin
          for wrn:=1 to WordCount(Form1.ListView1.Items[indice].SubItems[columnparameters],[' ']) do
            tmps.Add(ExtractWord(wrn,Form1.ListView1.Items[indice].SubItems[columnparameters],[' ']));
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
        if Form1.CheckBox1.Checked then
          tmps.Add('--limit-rate='+floattostr(Form1.FloatSpinEdit1.Value)+'k');//limite de velocidad
        if wgetdefncert then
          tmps.Add('--no-check-certificate');//No verificar certificados SSL
        tmps.Add('-P');//Destino de la descarga
        tmps.Add(ExtractShortPathName(Form1.ListView1.Items[indice].SubItems[columndestiny]));
        tmps.Add('-t');
        tmps.Add(inttostr(dtries));
        tmps.Add('-T');
        tmps.Add(inttostr(dtimeout));
        if (Form1.ListView1.Items[indice].SubItems[columnuser]<>'') and (Form1.ListView1.Items[indice].SubItems[columnpass]<>'') then
        begin
          if UpperCase(Copy(Form1.ListView1.Items[indice].SubItems[columnurl],0,3))='HTT' then
          begin
            tmps.Add('--http-user='+Form1.ListView1.Items[indice].SubItems[columnuser]);
            tmps.Add('--http-password='+Form1.ListView1.Items[indice].SubItems[columnpass]);
          end;
          if UpperCase(Copy(Form1.ListView1.Items[indice].SubItems[columnurl],0,3))='FTP' then
          begin
            tmps.Add('--ftp-user='+Form1.ListView1.Items[indice].SubItems[columnuser]);
            tmps.Add('--ftp-password='+Form1.ListView1.Items[indice].SubItems[columnpass]);
          end;
        end;
        if FileExists(Form1.ListView1.Items[indice].SubItems[columnurl]) then
          tmps.Add('-i');//Fichero de entrada
        tmps.Add(Form1.ListView1.Items[indice].SubItems[columnurl]);
      end;
    Form1.ListView1.Items[indice].SubItems[columnstatus]:='1';
    Form1.ListView1.Items[indice].Caption:=rsForm.statusinprogres.Caption;
    if Form1.ListView1.Items[indice].SubItems[columntype] = '0' then
      Form1.ListView1.Items[indice].ImageIndex:=2;
    if Form1.ListView1.Items[indice].SubItems[columntype] = '1' then
      Form1.ListView1.Items[indice].ImageIndex:=52;
    downid:=strtoint(Form1.ListView1.Items[indice].SubItems[columnid]);

    //El tama;o del array de hilos no debe ser menor que el propio id o la catidad de items
    if downid>=Form1.ListView1.Items.Count then
      thnum:=downid
    else
      thnum:=Form1.ListView1.Items.Count;
    SetLength(hilo,thnum);
    SetLength(trayicons,thnum);
    if Assigned(trayicons[downid])=false then
    begin
      trayicons[downid]:=downtrayicon.Create(nil);
      trayicons[downid].Visible:=showdowntrayicon;
      trayicons[downid].downindex:=downid;
      trayicons[downid].OnDblClick:=@trayicons[downid].showinmain;
      trayicons[downid].OnMouseDown:=@trayicons[downid].contextmenu;
      trayicons[downid].PopUpMenu:=Form1.PopupMenu4;
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
    if (Form1.ListView2.Visible) then
    begin
      rebuildids();
      //Form1.TreeView1SelectionChanged(nil);
      hilo[downid].thid2:=finduid(Form1.ListView1.Items[indice].SubItems[columnuid]);
      if (Form1.ListView2.Items.Count>hilo[downid].thid2) then
      begin
        if (Form1.ListView1.Items[indice].SubItems[columnuid]=Form1.ListView2.Items[hilo[downid].thid2].SubItems[columnuid]) then
        begin
          Form1.ListView2.Items[hilo[downid].thid2].SubItems[columnstatus]:='1';
          Form1.ListView2.Items[hilo[downid].thid2].Caption:=rsForm.statusinprogres.Caption;
          if Form1.ListView2.Items[hilo[downid].thid2].SubItems[columntype] = '0' then
            Form1.ListView2.Items[hilo[downid].thid2].ImageIndex:=2;
          if Form1.ListView2.Items[hilo[downid].thid2].SubItems[columntype] = '1' then
            Form1.ListView2.Items[hilo[downid].thid2].ImageIndex:=52;
        end;
      end;
    end;
    Form1.ToolButton3.Enabled:=false;
    Form1.ToolButton4.Enabled:=true;
    Form1.ToolButton22.Enabled:=false;
    end;
  end
  else
    Form1.SynEdit1.Lines.Add(rsForm.msgmustselectdownload.Caption);
  if columncolav then
  begin
    Form1.ListView1.Columns[0].Width:=columncolaw;
    Form1.ListView2.Columns[0].Width:=columncolaw;
  end;
end;

procedure queuetimer.ontime(Sender:TObject);
var
  i,maxcdown:integer;
begin
  maxcdown:=0;
  for i:=0 to Form1.ListView1.Items.Count-1 do
  begin
    if (Form1.ListView1.Items[i].SubItems[columnstatus]='1') and (Form1.ListView1.Items[i].SubItems[columnqueue]=inttostr(self.qtindex)) then
      inc(maxcdown);
  end;
  for i:=0 to Form1.ListView1.Items.Count-1 do
  begin
    if (Form1.ListView1.Items[i].SubItems[columnqueue]=inttostr(self.qtindex)) and (maxcdown<Form1.SpinEdit1.Value) and ((Form1.ListView1.Items[i].SubItems[columnstatus]='') or (Form1.ListView1.Items[i].SubItems[columnstatus]='2') or (Form1.ListView1.Items[i].SubItems[columnstatus]='0') or (Form1.ListView1.Items[i].SubItems[columnstatus]='4')) and (strtoint(Form1.ListView1.Items[i].SubItems[columntries])>0) then
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
  Form1.ToolButton9.Enabled:=false;
  Form1.ToolButton11.Enabled:=true;
  Form1.TreeView1.Items[1].Items[self.qtindex].ImageIndex:=46;
  Form1.TreeView1.Items[1].Items[self.qtindex].SelectedIndex:=46;
  Form1.TreeView1.Items[1].Items[self.qtindex].StateIndex:=40;
  Form1.PopupMenu1.Items[self.qtindex+5].Caption:=stopqueuesystray+' ('+queuenames[self.qtindex]+')';
  Form1.PopupMenu1.Items[self.qtindex+5].ImageIndex:=8;
  for n:=0 to Form1.ListView1.Items.Count-1 do
  begin
    if Form1.ListView1.Items[n].SubItems[columnqueue]=inttostr(self.qtindex) then
      Form1.ListView1.Items[n].SubItems[columntries]:=inttostr(triesrotate);
  end;
end;

procedure queuetimer.ontimestop(Sender:TObject);
begin
  Form1.ToolButton9.Enabled:=true;
  Form1.ToolButton11.Enabled:=false;
  Form1.TreeView1.Items[1].Items[self.qtindex].ImageIndex:=47;
  Form1.TreeView1.Items[1].Items[self.qtindex].SelectedIndex:=47;
  Form1.TreeView1.Items[1].Items[self.qtindex].StateIndex:=40;
  Form1.PopupMenu1.Items[self.qtindex+5].Caption:=startqueuesystray+' ('+queuenames[self.qtindex]+')';
  Form1.PopupMenu1.Items[self.qtindex+5].ImageIndex:=7;
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
      if qstop[self.stindex] then
        checkstop:=(hora<=queuestoptimes[self.stindex])
      else
        checkstop:=true;
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
        Form1.CheckBox1.Checked:=false;
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
  Form1.ToolButton15.Enabled:=false;
  Form1.ToolButton16.Enabled:=true;
end;

procedure sheduletimer.onstimestop(Sender:TObject);
begin
  Form1.ToolButton15.Enabled:=true;
  Form1.ToolButton16.Enabled:=false;
end;

procedure restartdownload(indice:integer;ahora:boolean);
begin
  if Form1.ListView1.Items[indice].SubItems[columnstatus] <> '1' then
  begin
    if Form1.ListView1.Items[indice].SubItems[columntype]='0' then
    begin
      if FileExists(UTF8ToSys(Form1.ListView1.Items[indice].SubItems[columndestiny]+pathdelim+Form1.ListView1.Items[indice].SubItems[columnname])) then
        SysUtils.DeleteFile(UTF8ToSys(Form1.ListView1.Items[indice].SubItems[columndestiny]+pathdelim+Form1.ListView1.Items[indice].SubItems[columnname]));

      if (Form1.ListView1.Items[indice].SubItems[columnengine]='aria2c') and (FileExists(UTF8ToSys(Form1.ListView1.Items[indice].SubItems[columndestiny]+pathdelim+Form1.ListView1.Items[indice].SubItems[columnname])+'.aria2')) then
        SysUtils.DeleteFile(UTF8ToSys(Form1.ListView1.Items[indice].SubItems[columndestiny]+pathdelim+Form1.ListView1.Items[indice].SubItems[columnname])+'.aria2');

      if (Form1.ListView1.Items[indice].SubItems[columnengine]='axel') and (FileExists(UTF8ToSys(Form1.ListView1.Items[indice].SubItems[columndestiny]+pathdelim+Form1.ListView1.Items[indice].SubItems[columnname])+'.st')) then
        SysUtils.DeleteFile(UTF8ToSys(Form1.ListView1.Items[indice].SubItems[columndestiny]+pathdelim+Form1.ListView1.Items[indice].SubItems[columnname])+'.st');

      if (Form1.ListView1.Items[indice].SubItems[columnengine]='lftp') and (FileExists(UTF8ToSys(Form1.ListView1.Items[indice].SubItems[columndestiny]+pathdelim+Form1.ListView1.Items[indice].SubItems[columnname])+'.lftp-pget-status')) then
        SysUtils.DeleteFile(UTF8ToSys(Form1.ListView1.Items[indice].SubItems[columndestiny]+pathdelim+Form1.ListView1.Items[indice].SubItems[columnname])+'.lftp-pget-status');

      if FileExists(UTF8ToSys(datapath+pathdelim+Form1.ListView1.Items[indice].SubItems[columnuid])+'.status') then
        SysUtils.DeleteFile(UTF8ToSys(datapath+pathdelim+Form1.ListView1.Items[indice].SubItems[columnuid])+'.status');

      Form1.ListView1.Items[indice].ImageIndex:=18;
    end;
    if Form1.ListView1.Items[indice].SubItems[columntype] = '1' then
    begin
      if FileExists(UTF8ToSys(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columndestiny]+pathdelim+StringReplace(ParseURI(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnurl]).Host+ParseURI(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnurl]).Path,'/',pathdelim,[rfReplaceAll])+pathdelim+'index.html')) then
        DeleteFile(UTF8ToSys(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columndestiny]+pathdelim+StringReplace(ParseURI(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnurl]).Host+ParseURI(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnurl]).Path,'/',pathdelim,[rfReplaceAll])+pathdelim+'index.html'));
      Form1.ListView1.Items[indice].ImageIndex:=51;
    end;
    Form1.ListView1.Items[indice].Caption:=rsForm.statuspaused.Caption;
    Form1.ListView1.Items[indice].SubItems[columnstatus]:='0';
    Form1.ListView1.Items[indice].SubItems[columnpercent]:='0%';
    Form1.ListView1.Items[indice].SubItems[columnspeed]:='--';
    Form1.ListView1.Items[indice].SubItems[columnestimate]:='--';
    Form1.ListView1.Items[indice].SubItems[columncurrent]:='0';
    if Form1.ListView2.Visible then
      Form1.TreeView1SelectionChanged(nil);
    if ahora then
    begin
      queuemanual[strtoint(Form1.ListView1.Items[indice].SubItems[columnqueue])]:=true;
      downloadstart(indice,true);
    end;
  end;
end;

procedure DownThread.update;
var
  porciento, velocidad, tamano, tiempo, descargado:String;
  icono:TBitmap;
  statusfile:TextFile;
begin
  porciento:='';
  velocidad:='';
  tamano:='';
  tiempo:='';
  descargado:='';
  if (Form1.ListView1.ItemIndex>-1) and (Form1.MenuItem53.Checked) and (thid=Form1.ListView1.ItemIndex) then
  begin
    if Length(Form1.SynEdit1.Lines.Text)>0 then
      Form1.SynEdit1.SelStart:=Length(Form1.SynEdit1.Lines.Text);
    Form1.SynEdit1.SelEnd:=Length(Form1.SynEdit1.Lines.Text)+1;
    Form1.SynEdit1.InsertTextAtCaret(wout[thid]);
  end;

  /////////////////***WGET***/////////////////////
  if Form1.ListView1.Items[thid].SubItems[columnengine] = 'wget' then
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
      descargado:=Copy(descargado,0,Pos(' ',descargado));
    end;
  end;
  ///////////////////***END***///////////////////

  ///////////////////***ARIA2***///////////////////
  if Form1.ListView1.Items[thid].SubItems[columnengine] = 'aria2c' then
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
  if Form1.ListView1.Items[thid].SubItems[columnengine] = 'curl' then
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
  if Form1.ListView1.Items[thid].SubItems[columnengine] = 'axel' then
  begin
    if Pos('File size: ',wout[thid])>0 then
      tamano:=Copy(wout[thid],Pos('File size: ',wout[thid])+11,length(wout[thid]));
    tamano:=Copy(tamano,0,Pos('bytes',tamano)-1);
    if FileExists(Form1.ListView1.Items[thid].SubItems[columndestiny]+pathdelim+UTF8ToSys(Form1.ListView1.Items[thid].SubItems[columnname])) then
      descargado:=inttostr(FileSize(Form1.ListView1.Items[thid].SubItems[columndestiny]+pathdelim+Form1.ListView1.Items[thid].SubItems[columnname]));
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
  if Form1.ListView1.Items[thid].SubItems[columnengine] = 'lftp' then
  begin
    //LFTP UPDATE ****
  end;
  ////////////////////***END***//////////////////////////

  if descargado<>'' then
    Form1.ListView1.Items[thid].SubItems[columncurrent]:=AnsiReplaceStr(descargado,LineEnding,'');
  if porciento<>'' then
    Form1.ListView1.Items[thid].SubItems[columnpercent]:=AnsiReplaceStr(porciento,LineEnding,'');
  if velocidad<>'' then
    Form1.ListView1.Items[thid].SubItems[columnspeed]:=AnsiReplaceStr(velocidad,LineEnding,'');
  if tiempo<>'' then
    Form1.ListView1.Items[thid].SubItems[columnestimate]:=AnsiReplaceStr(tiempo,LineEnding,'');
  if tamano<>'' then
    Form1.ListView1.Items[thid].SubItems[columnsize]:=AnsiReplaceStr(tamano,LineEnding,'');
  ////////////////////////////////////
  if (Form1.ListView2.Visible) then
  begin
    if (Form1.ListView2.Items.Count>thid2) then
    begin
      if (Form1.ListView1.Items[thid].SubItems[columnuid]=Form1.ListView2.Items[thid2].SubItems[columnuid]) then
      begin
        if descargado<>'' then
          Form1.ListView2.Items[thid2].SubItems[columncurrent]:=AnsiReplaceStr(descargado,LineEnding,'');
        if porciento<>'' then
          Form1.ListView2.Items[thid2].SubItems[columnpercent]:=AnsiReplaceStr(porciento,LineEnding,'');
        if velocidad<>'' then
          Form1.ListView2.Items[thid2].SubItems[columnspeed]:=AnsiReplaceStr(velocidad,LineEnding,'');
        if tiempo<>'' then
          Form1.ListView2.Items[thid2].SubItems[columnestimate]:=AnsiReplaceStr(tiempo,LineEnding,'');
        if tamano<>'' then
          Form1.ListView2.Items[thid2].SubItems[columnsize]:=AnsiReplaceStr(tamano,LineEnding,'');
      end;
    end;
  end;
  ////////////////////////////////////
  try
    if (porciento<>'') and (thid=Form1.ListView1.ItemIndex) then
    begin
      Form1.ProgressBar1.Position:=strtoint(Copy(porciento,0,Pos('%',porciento)-1));
    end;
  except on e:exception do
  end;

  if descargado = '' then
  begin
    descargado:=Form1.ListView1.Items[thid].SubItems[columncurrent];
    if descargado = '' then
      descargado:='-';
  end;
  if porciento = '' then
  begin
    porciento:=Form1.ListView1.Items[thid].SubItems[columnpercent];
    if porciento = '' then
      porciento:='-';
  end;
  if tiempo = '' then
  begin
    tiempo:=Form1.ListView1.Items[thid].SubItems[columnestimate];
    if tiempo = '' then
      tiempo:='-';
  end;

  try
    AssignFile(statusfile,datapath+PathDelim+Form1.ListView1.Items[thid].SubItems[columnuid]+'.status');
    if fileExists(configpath+PathDelim+Form1.ListView1.Items[thid].SubItems[columnuid]+'.status')=false then
      ReWrite(statusfile);
    Write(statusfile,Form1.ListView1.Items[thid].SubItems[columnstatus]+'/'+descargado+'/'+porciento+'/'+tiempo);
    CloseFile(statusfile);
  except on e:exception do
    CloseFile(statusfile);
  end;
  //Talvez con un icono independiente por cada descarga
  icono:=TBitmap.Create();
  icono.Width:=Form1.TrayIcon1.Icon.Width;
  icono.Height:=Form1.TrayIcon1.Icon.Height;
  icono.Canvas.Brush.Color:=clWhite;
  icono.Canvas.Pen.Color:=clBlack;
  icono.Canvas.Pen.Width:=3;
  if Form1.ListView1.Items[thid].SubItems[columnstatus]='1' then
    icono.Canvas.Font.Color:=clBlack
  else
    icono.Canvas.Font.Color:=clRed;
  icono.Canvas.Font.Bold:=true;
  icono.Canvas.Font.Quality:=fqAntialiased;
  {$IFDEF UNIX}
    icono.Canvas.Font.Size:=14;
  {$ENDIF}
  {$IFDEF WINDOWS}
    icono.Canvas.Font.Size:=16;
  {$ENDIF}
  icono.Canvas.Rectangle(0,0,icono.Width,icono.Height);
  porciento:=StringReplace(porciento,'%','',[rfReplaceAll]);
  porciento:=StringReplace(porciento,' ','',[rfReplaceAll]);
  if length(porciento)<2 then
    porciento:=' '+porciento;
  icono.Canvas.TextOut(3,4,porciento);
  trayicons[thid].Icon.Canvas.Brush.Color:=clWhite;
  trayicons[thid].Icon.Assign(icono);
  trayicons[thid].Animate:=true;///////////Esto es necesario para Qt si no el icono no se actualiza
  trayicons[thid].AnimateInterval:=0;//////y un intervalo que no parpadee
  trayicons[thid].Hint:=Form1.ListView1.Items[thid].SubItems[columnname]+' '+velocidad;
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
    inidownloadsfile.WriteInteger('Total','value',Form1.ListView1.Items.Count);
    for wn:=0 to Form1.ListView1.Items.Count-1 do
    begin
      if Form1.ListView1.Items[wn].SubItems[columnstatus]<> '1' then
      begin
        inidownloadsfile.WriteString('Download'+inttostr(wn),'columnstatus',Form1.ListView1.Items[wn].SubItems[columnstatus]);
        inidownloadsfile.WriteInteger('Download'+inttostr(wn),'icon',Form1.ListView1.Items[wn].ImageIndex);
        inidownloadsfile.WriteString('Download'+inttostr(wn),'status',Form1.ListView1.Items[wn].Caption);
      end
      else
      begin
        inidownloadsfile.WriteString('Download'+inttostr(wn),'columnstatus','2');
        inidownloadsfile.WriteInteger('Download'+inttostr(wn),'icon',3);
        inidownloadsfile.WriteString('Download'+inttostr(wn),'status','Detenido');
      end;
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnname',Form1.ListView1.Items[wn].SubItems[columnname]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnsize',Form1.ListView1.Items[wn].SubItems[columnsize]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columncurrent',Form1.ListView1.Items[wn].SubItems[columncurrent]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnurl',Form1.ListView1.Items[wn].SubItems[columnurl]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnspeed',Form1.ListView1.Items[wn].SubItems[columnspeed]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnpercent',Form1.ListView1.Items[wn].SubItems[columnpercent]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnestimate',Form1.ListView1.Items[wn].SubItems[columnestimate]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columndate',Form1.ListView1.Items[wn].SubItems[columndate]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columndestiny',Form1.ListView1.Items[wn].SubItems[columndestiny]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnengine',Form1.ListView1.Items[wn].SubItems[columnengine]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnparameters',Form1.ListView1.Items[wn].SubItems[columnparameters]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnuser',Form1.ListView1.Items[wn].SubItems[columnuser]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnpass',Form1.ListView1.Items[wn].SubItems[columnpass]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnuid',Form1.ListView1.Items[wn].SubItems[columnuid]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columnqueue',Form1.ListView1.Items[wn].SubItems[columnqueue]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columntype',Form1.ListView1.Items[wn].SubItems[columntype]);
      inidownloadsfile.WriteString('Download'+inttostr(wn),'columncookie',Form1.ListView1.Items[wn].SubItems[columncookie]);
    end;
    if (Form1.ListView1.Items.Count=0) and inidownloadsfile.SectionExists('Download0') then
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
  defaultdir:string;
begin
  Form1.OpenDialog1.Execute;
  if {$IFDEF LCLQT}(Form1.OpenDialog1.UserChoice=1){$else}Form1.OpenDialog1.FileName<>''{$endif} then
  begin
    urls:=TStringList.Create;
    urls.LoadFromFile(Form1.OpenDialog1.FileName);
    for nurl:=0 to urls.Count-1 do
    begin
      if urlexists(urls[nurl])=false then
      begin
        case defaultdirmode of
          1:defaultdir:=ddowndir;
          2:defaultdir:=suggestdir(ParseURI(urls[nurl]).Document);
        end;
        imitem:=TListItem.Create(Form1.ListView1.Items);
        imitem.Caption:=rsForm.statuspaused.Caption;
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
        imitem.SubItems.Add(inttostr(Form1.ListView1.Items.Count));//id
        imitem.SubItems.Add('');//user
        imitem.SubItems.Add('');//pass
        imitem.SubItems.Add(inttostr(triesrotate));//tries
        imitem.SubItems.Add(uidgen());//uid
        imitem.SubItems.Add('0');//queue
        imitem.SubItems.Add('0');//type
        imitem.SubItems.Add('');//cookie
        Form1.ListView1.Items.AddItem(imitem);
      end;
    end;
    urls.Destroy;
  end;
  Form1.TreeView1SelectionChanged(nil);
  savemydownloads();
end;

procedure exportdownloads();
var
  nurl:integer;
  urlist:TStringList;
begin
  Form1.SaveDialog1.Execute;
  if {$IFDEF LCLQT}Form1.SaveDialog1.UserChoice=1{$else}Form1.SaveDialog1.FileName<>''{$endif} then
  begin
    urlist:=TstringList.Create;
    for nurl:=0 to Form1.ListView1.Items.Count-1 do
    begin
      urlist.Add(Form1.ListView1.Items[nurl].SubItems[columnurl]);
    end;
    urlist.SaveToFile(Form1.SaveDialog1.FileName);
  end;
end;

procedure deleteitems(delfile:boolean);
var
  i,total,n:integer;
  nombres:string;
begin
  nombres:='';
  SetLength(trayicons,Form1.ListView1.Items.Count);
  if (Form1.ListView1.SelCount>0) or (Form1.ListView1.ItemIndex<>-1) then
  begin
    n:=0;
    if Form1.ListView1.SelCount>1 then
    begin
      for i:=0 to Form1.ListView1.Items.Count-1 do
      begin
        if (Form1.ListView1.Items[i].Selected) then
        begin
          if (Length(nombres)<100) and (n<5) then
          begin
            inc(n);
            nombres:=nombres+Form1.ListView1.Items[i].SubItems[columnname]+#10;
          end;
        end;
      end;
      if Form1.ListView1.SelCount>n then
      nombres:=nombres+'...';
    end
    else
      nombres:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnname];
    total:=Form1.ListView1.Items.Count-1;
    dlgForm.Caption:=rsForm.dlgconfirm.Caption;
    if delfile then
      dlgForm.dlgtext.Caption:=rsForm.dlgdeletedownandfile.Caption+' ['+inttostr(Form1.ListView1.SelCount)+']'+#10#13+#10#13+nombres
    else
      dlgForm.dlgtext.Caption:=rsForm.dlgdeletedown.Caption+' ['+inttostr(Form1.ListView1.SelCount)+']'+#10#13+#10#13+nombres;
    dlgForm.ShowModal;
    if dlgcuestion then
    begin
      for i:=total downto 0 do
      begin
        if (Form1.ListView1.Items[i].Selected) and (Form1.ListView1.Items[i].SubItems[columnstatus]<>'1') then
        begin
          //Borrar tambien el historial de la descarga antes de borrar.
          if FileExists(UTF8ToSys(logpath+pathdelim+Form1.ListView1.Items[i].SubItems[columnname])+'.log') then
            SysUtils.DeleteFile(UTF8ToSys(logpath+pathdelim+Form1.ListView1.Items[i].SubItems[columnname])+'.log');
          if FileExists(UTF8ToSys(datapath+pathdelim+Form1.ListView1.Items[i].SubItems[columnuid])+'.status') then
            SysUtils.DeleteFile(UTF8ToSys(datapath+pathdelim+Form1.ListView1.Items[i].SubItems[columnuid])+'.status');
          if Form1.ListView1.Items[i].SubItems[columnname] <> '' then
          begin
            if FileExists(UTF8ToSys(Form1.ListView1.Items[i].SubItems[columndestiny]+pathdelim+Form1.ListView1.Items[i].SubItems[columnname])) and delfile and (Form1.ListView1.Items[i].SubItems[columntype]='0') then
              SysUtils.DeleteFile(UTF8ToSys(Form1.ListView1.Items[i].SubItems[columndestiny]+pathdelim+Form1.ListView1.Items[i].SubItems[columnname]));
          end;
          if Form1.ListView1.ItemIndex=i then
            Form1.SynEdit1.Lines.Clear;
          refreshicons();
          Form1.ListView1.Items.Delete(i);
        end;
      end;
      rebuildids();
      savemydownloads();
      Form1.ProgressBar1.Position:=0;
      if Form1.ListView2.Visible then
        Form1.TreeView1SelectionChanged(nil);
    end;
  end
  else
    ShowMessage(rsForm.msgmustselectdownload.Caption);
end;

procedure DownThread.shutdown;
begin
  manualshutdown:=true;
  if Form1.ListView1.Items[thid].SubItems[columnengine]='lftp' then
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
  Case Form1.ListView1.Items[thid].SubItems[columnengine] of
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
  //wout[thid]:=#10#13+'Executing: '+wthp.Executable+' '+AnsiReplacestr(wthp.Parameters.Text,LineEnding,' ');
  if Not DirectoryExists(datapath) then
    CreateDir(datapath);
  Synchronize(@update);
  wthp.CurrentDirectory:=UTF8ToSys(Form1.ListView1.Items[thid].SubItems[columndestiny]);
  try
    wthp.Execute;
    try
      if logger then
      begin
        if Not DirectoryExists(logpath) then
          CreateDir(UTF8ToSys(logpath));
        AssignFile(logfile,UTF8ToSys(logpath)+PathDelim+UTF8ToSys(Form1.ListView1.Items[thid].SubItems[columnname])+'.log');
        if fileExists(logpath+PathDelim+UTF8ToSys(Form1.ListView1.Items[thid].SubItems[columnname])+'.log') then
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
          if (Pos('(OK):download',wout[thid])>0) or (Pos('100%[',wout[thid])>0) or (Pos('%AWGG100OK%',wout[thid])>0) or (Pos('[100%]',wout[thid])>0) or (Pos(' guardado [',wout[thid])>0) or (Pos(' saved [',wout[thid])>0) or (Pos('ERROR 400: Bad Request.',wout[thid])>0) or (Pos('The file is already fully retrieved; nothing to do.',wout[thid])>0) or (Pos('El fichero ya ha sido totalmente recuperado, no hay nada que hacer.',wout[thid])>0) and (Form1.ListView1.Items[thid].SubItems[columntype]='0') then
            completado:=true;
          if (Pos('FINISHED --',wout[thid])>0) or (Pos('Downloaded: ',wout[thid])>0) and (Form1.ListView1.Items[thid].SubItems[columntype]='1') then
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
begin
  otherlistview:=false;
  case Form1.ListView1.Items[thid].SubItems[columnengine] of
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
  if (Form1.ListView2.Visible) then
  begin
    if (Form1.ListView2.Items.Count>=thid2) then
    begin
      if (Form1.ListView1.Items[thid].SubItems[columnuid]=Form1.ListView2.Items[thid2].SubItems[columnuid]) then
      begin
        otherlistview:=true;
      end;
    end;
  end;
  if completado then
  begin
    qtimer[strtoint(Form1.ListView1.Items[thid].SubItems[columnqueue])].Interval:=1000;
    Form1.ListView1.Items[thid].SubItems[columnstatus]:='3';
    Form1.ListView1.Items[thid].Caption:=rsForm.statuscomplete.Caption;
    Form1.ListView1.Items[thid].SubItems[columnpercent]:='100%';
    if Form1.ListView1.ItemIndex=thid then
      Form1.ProgressBar1.Position:=100;
    Form1.ListView1.Items[thid].SubItems[columnspeed]:='--';
    if Form1.ListView1.Items[thid].SubItems[columntype] = '0' then
      Form1.ListView1.Items[thid].ImageIndex:=4;
    if Form1.ListView1.Items[thid].SubItems[columntype] = '1' then
      Form1.ListView1.Items[thid].ImageIndex:=54;
    if otherlistview then
    begin
      Form1.ListView2.Items[thid2].SubItems[columnstatus]:='3';
      Form1.ListView2.Items[thid2].Caption:=rsForm.statuscomplete.Caption;
      Form1.ListView2.Items[thid2].SubItems[columnpercent]:='100%';
      Form1.ListView2.Items[thid2].SubItems[columnspeed]:='--';
      if Form1.ListView2.Items[thid2].SubItems[columntype] = '0' then
        Form1.ListView2.Items[thid2].ImageIndex:=4;
      if Form1.ListView2.Items[thid2].SubItems[columntype] = '1' then
        Form1.ListView2.Items[thid2].ImageIndex:=54;
    end;
    if (shownotifi) and (Form1.Focused=false) then
    begin
      Form1.PopupNotifier1.Title:=rsForm.popuptitlecomplete.Caption;
      if Form1.ListView1.Items[thid].SubItems[columnname]<>'' then
        Form1.PopupNotifier1.Text:=Form1.ListView1.Items[thid].SubItems[columnname]
      else
        Form1.PopupNotifier1.Text:=Form1.ListView1.Items[thid].SubItems[columnurl];
      case notifipos of
        0: Form1.PopupNotifier1.ShowAtPos(0,0);
        1: Form1.PopupNotifier1.ShowAtPos(Round(Screen.Width/4),0);
        2: Form1.PopupNotifier1.ShowAtPos(Screen.Width,0);
        3: Form1.PopupNotifier1.ShowAtPos(0,Round(Screen.Height/3));
        4: Form1.PopupNotifier1.ShowAtPos(Round(Screen.Width/4),Round(Screen.Height/3));
        5: Form1.PopupNotifier1.ShowAtPos(Screen.Width,Round(Screen.Height/3));
        6: Form1.PopupNotifier1.ShowAtPos(0,Screen.Height);
        7: Form1.PopupNotifier1.ShowAtPos(Round(Screen.Width/4),Screen.Height);
        8: Form1.PopupNotifier1.ShowAtPos(Screen.Width,Screen.Height);
      end;
      Form1.Timer3.Interval:=hiddenotifi*1000;
      try
        if playsounds then
          playsound(downcompsound);
      except on e:exception do
      end;
      Form1.Timer3.Enabled:=true;
    end;
    trayicons[thid].Animate:=false;
    trayicons[thid].Icon.Clear;
    trayicons[thid].Visible:=false;
  end
  else
  begin
    if manualshutdown then
    begin
      Form1.ListView1.Items[thid].SubItems[columnstatus]:='2';
      Form1.ListView1.Items[thid].Caption:=rsForm.statusstoped.Caption;
      if Form1.ListView1.Items[thid].SubItems[columntype] = '0' then
        Form1.ListView1.Items[thid].ImageIndex:=3;
      if Form1.ListView1.Items[thid].SubItems[columntype] = '1' then
        Form1.ListView1.Items[thid].ImageIndex:=53;
      if otherlistview then
      begin
        Form1.ListView2.Items[thid2].SubItems[columnstatus]:='2';
        Form1.ListView2.Items[thid2].Caption:=rsForm.statusstoped.Caption;
        if Form1.ListView1.Items[thid2].SubItems[columntype] = '0' then
          Form1.ListView2.Items[thid2].ImageIndex:=3;
        if Form1.ListView2.Items[thid2].SubItems[columntype] = '1' then
          Form1.ListView2.Items[thid2].ImageIndex:=53;
      end;
    end
    else
    begin
      Form1.ListView1.Items[thid].SubItems[columnstatus]:='4';
      Form1.ListView1.Items[thid].Caption:=rsForm.statuserror.Caption;
      if Form1.ListView1.Items[thid].SubItems[columntype] = '0' then
        Form1.ListView1.Items[thid].ImageIndex:=3;
      if Form1.ListView1.Items[thid].SubItems[columntype] = '1' then
        Form1.ListView1.Items[thid].ImageIndex:=53;
      if otherlistview then
      begin
        Form1.ListView2.Items[thid2].SubItems[columnstatus]:='4';
        Form1.ListView2.Items[thid2].Caption:=rsForm.statuserror.Caption;
        if Form1.ListView1.Items[thid2].SubItems[columntype] = '0' then
          Form1.ListView2.Items[thid2].ImageIndex:=3;
        if Form1.ListView2.Items[thid2].SubItems[columntype] = '1' then
          Form1.ListView2.Items[thid2].ImageIndex:=53;
      end;
      if qtimer[strtoint(Form1.ListView1.Items[thid].SubItems[columnqueue])].Enabled then
      begin
        qtimer[strtoint(Form1.ListView1.Items[thid].SubItems[columnqueue])].Interval:=queuedelay*1000;
      end;
    end;
    Form1.ListView1.Items[thid].SubItems[columnspeed]:='--';
    if otherlistview then
      Form1.ListView1.Items[thid].SubItems[columnspeed]:='--';
    if Form1.ListView1.ItemIndex=thid then
    begin
      Form1.ToolButton3.Enabled:=true;
      Form1.ToolButton4.Enabled:=false;
      Form1.ToolButton22.Enabled:=true;
    end;
    if (shownotifi) and (manualshutdown=false) then
    begin
      outlines:=TStringList.Create;
      outlines.Add(datetostr(Date()));
      outlines.Add(timetostr(Time()));
      outlines.AddText(wout[thid]);
      Form1.PopupNotifier1.Title:=rsForm.popuptitlestoped.Caption;
      if Form1.ListView1.Items[thid].SubItems[columnname]<>'' then
        Form1.PopupNotifier1.Text:=Form1.ListView1.Items[thid].SubItems[columnname]+#10#13+outlines.Strings[outlines.Count-1]+outlines.Strings[outlines.Count-2]
      else
        Form1.PopupNotifier1.Text:=Form1.ListView1.Items[thid].SubItems[columnurl]+#10#13+outlines.Strings[outlines.Count-1]+outlines.Strings[outlines.Count-2];
      outlines.Destroy;
      case notifipos of
        0: Form1.PopupNotifier1.ShowAtPos(0,0);
        1: Form1.PopupNotifier1.ShowAtPos(Round(Screen.Width/4),0);
        2: Form1.PopupNotifier1.ShowAtPos(Screen.Width,0);
        3: Form1.PopupNotifier1.ShowAtPos(0,Round(Screen.Height/3));
        4: Form1.PopupNotifier1.ShowAtPos(Round(Screen.Width/4),Round(Screen.Height/3));
        5: Form1.PopupNotifier1.ShowAtPos(Screen.Width,Round(Screen.Height/3));
        6: Form1.PopupNotifier1.ShowAtPos(0,Screen.Height);
        7: Form1.PopupNotifier1.ShowAtPos(Round(Screen.Width/4),Screen.Height);
        8: Form1.PopupNotifier1.ShowAtPos(Screen.Width,Screen.Height);
      end;
      if Form1.ListView1.Items[thid].SubItems[columntries]<>'' then
        Form1.ListView1.Items[thid].SubItems[columntries]:=inttostr(strtoint(Form1.ListView1.Items[thid].SubItems[columntries])-1);
      //////Mover la descarga si ocurrio un error
      if qtimer[strtoint(Form1.ListView1.Items[thid].SubItems[columnqueue])].Enabled and queuerotate then
      begin
        if thid<Form1.ListView1.Items.Count-1 then
        begin
          Form1.ListView1.MultiSelect:=false;
          if rotatemode=0 then
            moveonestepdown(thid);
          if rotatemode=1 then
            Form1.ListView1.Items.Move(thid,Form1.ListView1.Items.Count-1);
          if rotatemode=2 then
          begin
            if (thid+1)<(Form1.ListView1.Items.Count-1) then
              moveonestepdown(thid,1)
            else
              moveonestepdown(thid);
          end;
          Form1.ListView1.MultiSelect:=true;
          rebuildids();
          if Form1.ListView2.Visible then
            Form1.TreeView1SelectionChanged(nil);
        end;
      end;
      Form1.Timer3.Interval:=hiddenotifi*1000;
      try
        if playsounds then
          playsound(downstopsound);
      except on e:exception do
      end;
      Form1.Timer3.Enabled:=true;
    end;
  end;
  if columncolav then
  begin
    Form1.ListView1.Columns[0].Width:=columncolaw;
    Form1.ListView2.Columns[0].Width:=columncolaw;
  end;
  {$IFDEF LCLGTK2}
    if columncolav then
    begin
      Form1.ListView1.Columns[0].Width:=columncolaw;
      Form1.ListView2.Columns[0].Width:=columncolaw;
    end;
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
      fitem:=TListItem.Create(Form1.ListView1.Items);
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
      fitem.SubItems[columnspeed]:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columnspeed','');
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
      fitem.SubItems.Add('');
      fitem.SubItems[columntype]:=inttostr(inidownloadsfile.ReadInteger('Download'+inttostr(ns),'columntype',0));
      fitem.SubItems.Add('');
      fitem.SubItems[columncookie]:=inidownloadsfile.ReadString('Download'+inttostr(ns),'columncookie','');
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
              fitem.ImageIndex:=4;
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
      Form1.ListView1.Items.AddItem(fitem);
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
    qdomingo[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'domingo',false);
    qlunes[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'lunes',false);
    qmartes[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'martes',false);
    qmiercoles[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'miercoles',false);
    inidownloadsfile.ReadBool('Queue'+inttostr(ns),'jueves',false);
    qjueves[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'jueves',false);
    qviernes[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'viernes',false);
    qsabado[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'sabado',false);
    qstop[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'stop',false);
    qallday[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'allday',false);
    qtimerenable[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'timerenable',false);
    queuelimits[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'limits',false);
    queuepoweroff[ns]:=inidownloadsfile.ReadBool('Queue'+inttostr(ns),'poweroff',false);
    queuesheduledone[ns]:=false;
    qtimer[ns]:=queuetimer.Create(Form1);
    qtimer[ns].Enabled:=false;
    qtimer[ns].qtindex:=ns;
    qtimer[ns].OnTimer:=@qtimer[ns].ontime;
    qtimer[ns].OnStartTimer:=@qtimer[ns].ontimestart;
    qtimer[ns].OnStopTimer:=@qtimer[ns].ontimestop;
    qtimer[ns].Interval:=1000;
    stimer[ns]:=sheduletimer.Create(Form1);
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
  for n:=0 to Form1.ListView1.Items.Count-1 do
  begin
    if Form1.ListView1.Items[n].SubItems[columnstatus]='1' then
      enprogreso:=true;
  end;
  if enprogreso then
  begin
    dlgForm.Caption:=rsForm.dlgconfirm.Caption;
    dlgForm.dlgtext.Caption:=rsForm.msgcloseinprogressdownload.Caption;
    dlgForm.ShowModal;
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
  Form1.Caption:='Turning off...';
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

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  Form1.Visible:=false;
  TrayIcon1.Visible:=true;
  CanClose:=false;
  saveconfig();
end;


procedure TForm1.FormCreate(Sender: TObject);
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
  Form1.Timer6.Enabled:=true;
  onestart:=false;
  if autostartminimized then
  begin
    Form1.WindowState:=wsMinimized;
    Form1.Hide;
  end
  else
    Form1.WindowState:=lastmainwindowstate;
  Form1.ListView2.Columns:=Form1.ListView1.Columns;
end;

procedure TForm1.FormResize(Sender: TObject);
begin

end;

procedure TForm1.FormWindowStateChange(Sender: TObject);
begin
  if Form1.WindowState<>wsMinimized then
  lastmainwindowstate:=Form1.WindowState;
end;

procedure TForm1.ListView1Click(Sender: TObject);
begin
  columncolaw:=Form1.ListView1.Columns[0].Width;
end;

procedure TForm1.ListView1ColumnClick(Sender: TObject; Column: TListColumn);
//var
//  n:integer;
begin
  //Commentado temporalmente porque afecta el orden de todas las colas
  //for n:=0 to Form1.ListView1.Columns.Count-1 do
  //begin
  //  Form1.ListView1.Columns[n].Caption:=AnsiReplaceStr(Form1.ListView1.Columns[n].Caption,'  ٧','');
  //  Form1.ListView1.Columns[n].Caption:=AnsiReplaceStr(Form1.ListView1.Columns[n].Caption,'  ٨','');
  //  if (Form1.ListView2.Visible) then
  //  begin
  //    Form1.ListView2.Columns[n].Caption:=AnsiReplaceStr(Form1.ListView2.Columns[n].Caption,'  ٧','');
  //    Form1.ListView2.Columns[n].Caption:=AnsiReplaceStr(Form1.ListView2.Columns[n].Caption,'  ٨','');
  //  end;
  //end;
  //if Form1.ListView1.SortDirection=sdAscending then
  //begin
  //  Form1.ListView1.SortDirection:=sdDescending;
  //  {$IFDEF LCLQT}
  //  {$ELSE}
  //    Column.Caption:=Column.Caption+'  ٧';
  //  {$ENDIF}
  //end
  //else
  //begin
  //  Form1.ListView1.SortDirection:=sdAscending;
  //  {$IFDEF LCLQT}
  //  {$ELSE}
  //    Column.Caption:=Column.Caption+'  ٨';
  //  {$ENDIF}
  //end;
  //Form1.ListView1.SortColumn:=column.Index;
  //Form1.ListView1.SortType:=stText;
  //if (Form1.ListView2.Visible) then
  //begin
  //  Form1.ListView2.SortColumn:=Column.Index;
  //  Form1.ListView2.SortType:=stText;
  //  Form1.TreeView1SelectionChanged(nil);
  //end;
  //rebuildids();
  if Form1.ListView1.Visible then
    columncolaw:=Form1.ListView1.Columns[0].Width
  else
    columncolaw:=Form1.ListView2.Columns[0].Width;
end;


procedure TForm1.ListView1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  if Form1.ListView1.SelCount>0 then
  begin
    case Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnstatus] of
      '0':
      begin
        Form1.MenuItem27.Enabled:=true;
        Form1.MenuItem28.Enabled:=false;
        Form1.MenuItem29.Enabled:=true;
        Form1.MenuItem48.Enabled:=true;
        Form1.MenuItem58.Enabled:=true;
        Form1.MenuItem13.Enabled:=true;
        Form1.MenuItem11.Enabled:=true;
        Form1.MenuItem45.Enabled:=false;
      end;
      '1':
      begin
        Form1.MenuItem27.Enabled:=false;
        Form1.MenuItem28.Enabled:=true;
        Form1.MenuItem29.Enabled:=false;
        Form1.MenuItem48.Enabled:=false;
        Form1.MenuItem58.Enabled:=false;
        Form1.MenuItem13.Enabled:=false;
        Form1.MenuItem11.Enabled:=false;
        Form1.MenuItem45.Enabled:=false;
      end;
      '2','4':
      begin
        Form1.MenuItem27.Enabled:=true;
        Form1.MenuItem28.Enabled:=false;
        Form1.MenuItem29.Enabled:=true;
        Form1.MenuItem48.Enabled:=true;
        Form1.MenuItem58.Enabled:=true;
        Form1.MenuItem13.Enabled:=true;
        Form1.MenuItem11.Enabled:=true;
        Form1.MenuItem45.Enabled:=false;
      end;
      '3':
      begin
        Form1.MenuItem27.Enabled:=true;
        Form1.MenuItem28.Enabled:=false;
        Form1.MenuItem29.Enabled:=true;
        Form1.MenuItem48.Enabled:=true;
        Form1.MenuItem58.Enabled:=true;
        Form1.MenuItem13.Enabled:=true;
        Form1.MenuItem11.Enabled:=true;
        Form1.MenuItem45.Enabled:=true;
      end;
    end;
    if (Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnstatus]='1') then
    begin
      Form1.MenuItem92.Enabled:=true;
      if Assigned(trayicons[Form1.ListView1.ItemIndex]) then
        Form1.MenuItem92.Checked:=trayicons[Form1.ListView1.ItemIndex].Visible
    end
    else
    begin
      Form1.MenuItem92.Enabled:=false;
    end;
    handled:=true;
    Form1.PopupMenu2.PopUp;
  end;
end;
procedure TForm1.ListView1DblClick(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  begin
    if (Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnstatus]='') or (Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnstatus]='2') or (Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnstatus]='3') or (Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnstatus]='0')or (Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnstatus]='4') then
    begin
      queuemanual[strtoint(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnqueue])]:=true;
      downloadstart(Form1.ListView1.ItemIndex,false);
    end
    else
    begin
      hilo[strtoint(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnid])].shutdown();
      Form1.ToolButton3.Enabled:=true;
      Form1.ToolButton4.Enabled:=false;
    end;
  end;
end;

procedure TForm1.ListView1KeyDown(Sender: TObject; var Key: Word;
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
    13: Form1.ListView1DblClick(nil);
    45,107:Form1.ToolButton1Click(nil);
  end;
end;

procedure TForm1.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  lastlines:TStringList;
  percent:string;
begin
  if (Form1.ListView1.ItemIndex<>-1) then
  begin
    if Form1.Listview1.Items[Form1.ListView1.ItemIndex].SubItems[columnstatus]='1' then
    begin
      Form1.ToolButton3.Enabled:=false;
      Form1.ToolButton4.Enabled:=true;
      Form1.ToolButton22.Enabled:=false;
    end
    else
    begin
      Form1.ToolButton3.Enabled:=true;
      Form1.ToolButton4.Enabled:=false;
      Form1.ToolButton22.Enabled:=true;
    end;
    Form1.SynEdit1.Lines.Clear;
    if FileExists(UTF8ToSys(logpath)+pathdelim+UTF8ToSys(Form1.Listview1.Items[Form1.ListView1.ItemIndex].SubItems[columnname])+'.log') and (Form1.SynEdit1.Visible) and (loadhistorylog) then
    begin
      try
        lastlines:=TStringList.Create;
        lastlines.LoadFromFile(UTF8ToSys(logpath)+pathdelim+UTF8ToSys(Form1.Listview1.Items[Form1.ListView1.ItemIndex].SubItems[columnname])+'.log');
        if (lastlines.Count>=20) and (loadhistorymode=2) then
        begin
          Form1.SynEdit1.Lines.Add(lastlines[lastlines.Count-20]);
          Form1.SynEdit1.Lines.Add(lastlines[lastlines.Count-19]);
          Form1.SynEdit1.Lines.Add(lastlines[lastlines.Count-18]);
          Form1.SynEdit1.Lines.Add(lastlines[lastlines.Count-17]);
          Form1.SynEdit1.Lines.Add(lastlines[lastlines.Count-16]);
          Form1.SynEdit1.Lines.Add(lastlines[lastlines.Count-15]);
          Form1.SynEdit1.Lines.Add(lastlines[lastlines.Count-14]);
          Form1.SynEdit1.Lines.Add(lastlines[lastlines.Count-13]);
          Form1.SynEdit1.Lines.Add(lastlines[lastlines.Count-12]);
          Form1.SynEdit1.Lines.Add(lastlines[lastlines.Count-11]);
          Form1.SynEdit1.Lines.Add(lastlines[lastlines.Count-10]);
          Form1.SynEdit1.Lines.Add(lastlines[lastlines.Count-9]);
          Form1.SynEdit1.Lines.Add(lastlines[lastlines.Count-8]);
          Form1.SynEdit1.Lines.Add(lastlines[lastlines.Count-7]);
          Form1.SynEdit1.Lines.Add(lastlines[lastlines.Count-6]);
          Form1.SynEdit1.Lines.Add(lastlines[lastlines.Count-5]);
          Form1.SynEdit1.Lines.Add(lastlines[lastlines.Count-4]);
          Form1.SynEdit1.Lines.Add(lastlines[lastlines.Count-3]);
          Form1.SynEdit1.Lines.Add(lastlines[lastlines.Count-2]);
          Form1.SynEdit1.Lines.Add(lastlines[lastlines.Count-1]);
        end
        else
          Form1.SynEdit1.Lines:=lastlines;
        lastlines.Destroy;
        if Length(Form1.SynEdit1.Lines.Text)>0 then
          Form1.SynEdit1.SelStart:=Length(Form1.SynEdit1.Lines.Text);
        Form1.SynEdit1.SelEnd:=Length(Form1.SynEdit1.Lines.Text);
      except on e:exception do
        //Form1.SynEdit1.Lines.Add(e.ToString);
      end;
    end;
    percent:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnpercent];
    try
      if percent<>'' then
        Form1.ProgressBar1.Position:=strtoint(Copy(percent,0,Pos('%',percent)-1))
      else
        Form1.ProgressBar1.Position:=0;
    except on e:exception do
      Form1.ProgressBar1.Position:=0;
    end;
  end;
end;

procedure TForm1.ListView2Click(Sender: TObject);
begin
  columncolaw:=Form1.ListView2.Columns[0].Width;
end;

procedure TForm1.ListView2SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  indice,x:integer;
begin
  if (Form1.ListView1.Items.Count>0) then
  begin
    if item.SubItems[columnstatus] = '1' then
      indice:=hilo[strtoint(item.SubItems[columnid])].thid
    else
    begin
      for x:=0 to Form1.ListView1.Items.Count-1 do
      begin
        if Form1.ListView1.Items[x].SubItems[columnuid]=Item.SubItems[columnuid] then
          indice:=x;
      end;
    end;
    if (Form1.ListView2.SelCount>1) and (indice<Form1.ListView1.Items.Count) then
    begin
      Form1.ListView1.Items[indice].Selected:=true;
      Form1.ListView1.ItemIndex:=indice;
    end
    else
    begin
      if Form1.ListView1.SelCount>1 then
      begin
        for x:=0 to Form1.ListView1.Items.Count-1 do
          Form1.ListView1.Items[x].Selected:=false;
      end;
      Form1.ListView1.MultiSelect:=false;
      if (indice <> -1) and (indice<Form1.ListView1.Items.Count) then
        Form1.ListView1.ItemIndex:=indice;
      Form1.ListView1.MultiSelect:=true;
    end;
  end;
end;

procedure TForm1.MenuItem10Click(Sender: TObject);
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
  Form4.Label1.Caption:='AWGG';
  Form4.Label2.Caption:='(Advanced WGET GUI)'+#10#13+'Version: '+versionitis.version+#10#13+'Compiled using:'+#10#13+'Lazarus: '+lcl_version+#10#13+'FPC: '+versionitis.fpcversion+#10#13+'Platform: '+cpu+'-'+versionitis.targetos+'-'+widgetset;
  Form4.Memo1.Text:=abouttext;
  Form4.Label3.Caption:='http://sites.google.com/site/awggproject';
  Form4.Show;
end;

procedure TForm1.MenuItem11Click(Sender: TObject);
var
  tmpstr:string='';
  paramlist:string='';
begin
  if Form1.ListView1.ItemIndex<>-1 then
  begin
    if Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columntype] = '0' then
    begin
      Form2.Edit3.Text:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnname];
      Form2.Edit1.Text:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnurl];
      Form2.DirectoryEdit1.Text:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columndestiny];
      enginereload();
      Form2.ComboBox1.ItemIndex:=Form2.ComboBox1.Items.IndexOf(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnengine]);
      Form2.Edit2.Text:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters];
      Form1.Timer4.Enabled:=false;
      Form2.Edit4.Text:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnuser];
      Form2.Edit5.Text:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnpass];
      ///////CONFIRM DIALOG MODE///////////
      Form2.Caption:=rsForm.titlepropertiesdown.Caption;
      Form2.Button1.Visible:=false;
      Form2.Button4.Visible:=false;
      Form2.BitBtn1.Caption:=rsForm.btnpropertiesok.Caption;
      Form2.BitBtn1.GlyphShowMode:=gsmNever;
      ////////////////////////////////////
      Form2.ComboBox2.ItemIndex:=strtoint(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnqueue]);
      Form2.ShowModal;
      ///////NEW DOWNLOAD DIALOG MODE///////////
      Form2.Caption:=rsForm.titlenewdown.Caption;
      Form2.Button1.Visible:=true;
      Form2.Button4.Visible:=true;
      Form2.BitBtn1.Caption:=rsForm.btnnewdownstartnow.Caption;
      Form2.BitBtn1.GlyphShowMode:=gsmApplication;
      ////////////////////////////////////
      Form1.Timer4.Enabled:=clipboardmonitor;
      if agregar then
      begin
        Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnname]:=Form2.Edit3.Text;
        Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnurl]:=Form2.Edit1.Text;
        Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columndestiny]:=Form2.DirectoryEdit1.Text;
        Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnengine]:=Form2.ComboBox1.Text;
        Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters]:=Form2.Edit2.Text;
        Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnuser]:=Form2.Edit4.Text;
        Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnpass]:=Form2.Edit5.Text;
        Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnqueue]:=inttostr(Form2.ComboBox2.ItemIndex);
        Form1.TreeView1SelectionChanged(nil);
        savemydownloads();
      end;
    end;
    if Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columntype] = '1' then
    begin
      newgrabberqueues();
      Form7.ComboBox1.ItemIndex:=strtoint(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnqueue]);
      Form7.Edit2.Text:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnname];
      Form7.Edit1.Text:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnurl];
      Form7.DirectoryEdit1.Text:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columndestiny];
      Form7.Edit3.Text:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnuser];
      Form7.Edit4.Text:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnpass];
      Form7.ComboBox1.ItemIndex:=strtoint(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnqueue]);
      if Pos('-k',Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters])>0 then
        Form7.CheckBox1.Checked:=true
      else
        Form7.CheckBox1.Checked:=false;
      if Pos('--follow-ftp',Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters])>0 then
        Form7.CheckBox2.Checked:=true
      else
        Form7.CheckBox2.Checked:=false;
      if Pos('-np',Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters])>0 then
        Form7.CheckBox3.Checked:=true
      else
        Form7.CheckBox3.Checked:=false;
      if Pos('-p',Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters])>0 then
        Form7.CheckBox4.Checked:=true
      else
        Form7.CheckBox4.Checked:=false;
      if Pos('-H',Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters])>0 then
        Form7.CheckBox5.Checked:=true
      else
        Form7.CheckBox5.Checked:=false;
      if Pos('-L',Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters])>0 then
        Form7.CheckBox6.Checked:=true
      else
        Form7.CheckBox6.Checked:=false;
      if Pos('-l ',Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters])>0 then
      begin
        tmpstr:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters];
        tmpstr:=Copy(tmpstr,Pos('-l ',tmpstr)+3,Length(tmpstr));
        tmpstr:=Copy(tmpstr,0,Pos(' ',tmpstr)-1);
        //ShowMessage(tmpstr);
        Form7.SpinEdit1.Value:=strtoint(tmpstr);
      end
      else
        Form7.Spinedit1.Value:=5;
      if Pos('-R "',Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters])>0 then
      begin
        tmpstr:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters];
        tmpstr:=Copy(tmpstr,Pos('-R "',tmpstr)+4,Length(tmpstr));
        tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
        //ShowMessage(tmpstr);
        Form7.Memo1.Text:=tmpstr;
      end
      else
        Form7.Memo1.Text:='';
      if Pos('-A "',Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters])>0 then
      begin
        tmpstr:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters];
        tmpstr:=Copy(tmpstr,Pos('-A "',tmpstr)+4,Length(tmpstr));
        tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
        //ShowMessage(tmpstr);
        Form7.Memo6.Text:=tmpstr;
      end
      else
        Form7.Memo6.Text:='';
      if Pos('-D "',Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters])>0 then
      begin
        tmpstr:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters];
        tmpstr:=Copy(tmpstr,Pos('-D "',tmpstr)+4,Length(tmpstr));
        tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
        //ShowMessage(tmpstr);
        Form7.Memo3.Text:=tmpstr;
      end
      else
        Form7.Memo3.Text:='';
      if Pos('--exclude-domains "',Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters])>0 then
      begin
        tmpstr:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters];
        tmpstr:=Copy(tmpstr,Pos('--exclude-domains "',tmpstr)+19,Length(tmpstr));
        tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
        //ShowMessage(tmpstr);
        Form7.Memo2.Text:=tmpstr;
      end
      else
        Form7.Memo2.Text:='';
      if Pos('-I "',Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters])>0 then
      begin
        tmpstr:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters];
        tmpstr:=Copy(tmpstr,Pos('-I "',tmpstr)+4,Length(tmpstr));
        tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
        //ShowMessage(tmpstr);
        Form7.Memo4.Text:=tmpstr;
      end
      else
        Form7.Memo4.Text:='';
      if Pos('-X "',Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters])>0 then
      begin
        tmpstr:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters];
        tmpstr:=Copy(tmpstr,Pos('-X "',tmpstr)+4,Length(tmpstr));
        tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
        //ShowMessage(tmpstr);
        Form7.Memo5.Text:=tmpstr;
      end
      else
        Form7.Memo5.Text:='';
      if Pos('--follow-tags="',Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters])>0 then
      begin
        tmpstr:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters];
        tmpstr:=Copy(tmpstr,Pos('--follow-tags="',tmpstr)+15,Length(tmpstr));
        tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
        //ShowMessage(tmpstr);
        Form7.Memo7.Text:=tmpstr;
      end
      else
        Form7.Memo7.Text:='';
      if Pos('--ignore-tags="',Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters])>0 then
      begin
        tmpstr:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters];
        tmpstr:=Copy(tmpstr,Pos('--ignore-tags="',tmpstr)+15,Length(tmpstr));
        tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
        //ShowMessage(tmpstr);
        Form7.Memo8.Text:=tmpstr;
      end
      else
        Form7.Memo8.Text:='';
      if Pos('-U "',Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters])>0 then
      begin
        tmpstr:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters];
        tmpstr:=Copy(tmpstr,Pos('-U "',tmpstr)+4,Length(tmpstr));
        tmpstr:=Copy(tmpstr,0,Pos('"',tmpstr)-1);
        //ShowMessage(tmpstr);
        Form7.Edit5.Text:=tmpstr;
      end
      else
        Form7.Edit5.Text:='';
      Form7.PageControl1.TabIndex:=0;
      Form1.Timer4.Enabled:=false;
      Form7.ShowModal;
      Form1.Timer4.Enabled:=clipboardmonitor;
      if grbadd then
      begin
        paramlist:=paramlist+'-l '+inttostr(Form7.SpinEdit1.Value);
        if Form7.CheckBox1.Checked then
          paramlist:=paramlist+' -k';
        if Form7.CheckBox2.Checked then
          paramlist:=paramlist+' --follow-ftp';
        if Form7.CheckBox3.Checked then
          paramlist:=paramlist+' -np';
        if Form7.CheckBox4.Checked then
          paramlist:=paramlist+' -p';
        if Form7.CheckBox5.Checked then
          paramlist:=paramlist+' -H';
        if Form7.CheckBox6.Checked then
          paramlist:=paramlist+' -L';
        if Length(Form7.Memo1.Lines.Text)>0 then
          paramlist:=paramlist+' -R "'+Form7.Memo1.Lines.Text+'"';
        if Length(Form7.Memo2.Lines.Text)>0 then
          paramlist:=paramlist+' --exclude-domains "'+Form7.Memo2.Lines.Text+'"';
        if Length(Form7.Memo3.Lines.Text)>0 then
          paramlist:=paramlist+' -D "'+Form7.Memo3.Lines.Text+'"';
        if Length(Form7.Memo4.Lines.Text)>0 then
          paramlist:=paramlist+' -I "'+Form7.Memo4.Lines.Text+'"';
        if Length(Form7.Memo5.Lines.Text)>0 then
          paramlist:=paramlist+' -X "'+Form7.Memo5.Lines.Text+'"';
        if Length(Form7.Memo6.Lines.Text)>0 then
          paramlist:=paramlist+' -A "'+Form7.Memo6.Lines.Text+'"';
        if Length(Form7.Memo7.Lines.Text)>0 then
          paramlist:=paramlist+' --follow-tags="'+Form7.Memo7.Lines.Text+'"';
        if Length(Form7.Memo8.Lines.Text)>0 then
          paramlist:=paramlist+' --ignore-tags="'+Form7.Memo8.Lines.Text+'"';
        if Length(Form7.Edit5.Text)>0 then
          paramlist:=paramlist+' -U "'+Form7.Edit5.Text+'"';
        Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnname]:=Form7.Edit2.Text;//Nombre del sitio
        Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnurl]:=Form7.Edit1.Text;//URL
        Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columndestiny]:=Form7.DirectoryEdit1.Text;//Destino
        Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnparameters]:=paramlist;//Parametros
        Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnuser]:=Form7.Edit3.Text;//user
        Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnpass]:=Form7.Edit4.Text;//pass
        Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnqueue]:=inttostr(Form7.ComboBox1.ItemIndex);//queue
        Form1.TreeView1SelectionChanged(nil);
        savemydownloads();
      end;
    end;
  end;
end;

procedure TForm1.MenuItem12Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  ClipBoard.AsText:=Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnurl];
end;

procedure TForm1.MenuItem13Click(Sender: TObject);
begin
  deleteitems(false);
end;

procedure TForm1.MenuItem14Click(Sender: TObject);
begin
  stopall(false);
end;

procedure TForm1.MenuItem15Click(Sender: TObject);
begin
  Form3.PageControl1.ActivePageIndex:=1;
  Form3.TreeView1.Items[Form3.PageControl1.ActivePageIndex].Selected:=true;
  configdlg();
  Form3.Show;
end;

procedure TForm1.MenuItem16Click(Sender: TObject);
begin
  ToolButton1Click(nil);
end;

procedure TForm1.MenuItem17Click(Sender: TObject);
begin
  deleteitems(false);
end;

procedure TForm1.MenuItem19Click(Sender: TObject);
var
  x:integer;
begin
  if Form1.ListView1.Visible then
  begin
    for x:=0 to Form1.ListView1.Items.Count-1 do
    begin
      Form1.ListView1.Items[x].Selected:=true;
    end;
  end
  else
  begin
    for x:=0 to Form1.ListView2.Items.Count-1 do
    begin
      Form1.ListView2.Items[x].Selected:=true;
    end;
  end;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  Form1.TrayIcon1DblClick(nil);
end;

procedure TForm1.MenuItem20Click(Sender: TObject);
var
  x:integer;
begin
  for x:=0 to Form1.ListView1.Items.Count-1 do
  begin
    Form1.ListView1.Items[x].Selected:=false;
  end;
  Form1.TreeView1SelectionChanged(nil);
end;

procedure TForm1.MenuItem21Click(Sender: TObject);
var
  x:integer;
begin
  for x:=0 to Form1.ListView1.Items.Count-1 do
  begin
    queuemanual[strtoint(Form1.ListView1.Items[x].SubItems[columnqueue])]:=true;
    downloadstart(x,false);
  end;
end;

procedure TForm1.MenuItem22Click(Sender: TObject);
var
  x:integer;
begin
  for x:=0 to Form1.ListView1.Items.Count-1 do
  begin
    if Form1.ListView1.Items[x].SubItems[columnstatus]='1' then
    begin
    hilo[strtoint(Form1.ListView1.Items[x].SubItems[columnid])].shutdown();
    end;
  end;
end;

procedure TForm1.MenuItem23Click(Sender: TObject);
begin
  Form1.ListView1.Column[columncurrent+1].Visible:=not Form1.ListView1.Column[columncurrent+1].Visible;
  Form1.ListView2.Column[columncurrent+1].Visible:=not Form1.ListView2.Column[columncurrent+1].Visible;
  Form1.MenuItem23.Checked:=Form1.ListView1.Column[columncurrent+1].Visible;
end;

procedure TForm1.MenuItem24Click(Sender: TObject);
begin
  Form1.ListView1.Column[columnparameters+1].Visible:=not Form1.ListView1.Column[columnparameters+1].Visible;
  Form1.ListView2.Column[columnparameters+1].Visible:=not Form1.ListView2.Column[columnparameters+1].Visible;
  Form1.MenuItem24.Checked:=Form1.ListView1.Column[columnparameters+1].Visible;
end;

procedure TForm1.MenuItem25Click(Sender: TObject);
begin
  Form1.ListView1.GridLines:=not Form1.ListView1.GridLines;
  Form1.ListView2.GridLines:=not Form1.ListView2.GridLines;
  Form1.MenuItem25.Checked:=Form1.ListView1.GridLines;
end;

procedure TForm1.MenuItem26Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  begin
    if FileExists(UTF8ToSys(logpath+pathdelim+Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnname])+'.log') then
      OpenURL(ExtractShortPathName(UTF8ToSys(logpath+pathdelim+Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnname])+'.log'))
    else
      ShowMessage(rsForm.msgnoexisthistorylog.Caption);
  end;
end;

procedure TForm1.MenuItem27Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  begin
    queuemanual[strtoint(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnqueue])]:=true;
    downloadstart(Form1.ListView1.ItemIndex,false);
  end;
end;

procedure TForm1.MenuItem28Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
    hilo[strtoint(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnid])].shutdown();
end;

procedure TForm1.MenuItem29Click(Sender: TObject);
begin
  Form1.ToolButton22Click(nil);
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  saveandexit();
end;

procedure TForm1.MenuItem30Click(Sender: TObject);
var
  x:integer;
begin
  dlgForm.Caption:=rsForm.dlgconfirm.Caption;
  dlgForm.dlgtext.Caption:=rsForm.dlgrestartalldownloads.Caption;
  dlgForm.ShowModal;
  if dlgcuestion then
  begin
    for x:=0 to Form1.ListView1.Items.Count-1 do
    begin
      if Form1.ListView1.Items[x].Subitems[columnstatus]<>'1' then
      begin
        queuemanual[strtoint(Form1.ListView1.Items[x].SubItems[columnqueue])]:=true;
        restartdownload(x,true);
      end;
    end;
  end;
end;

procedure TForm1.MenuItem31Click(Sender: TObject);
begin
  Form1.MenuItem19Click(nil);
  deleteitems(false);
  savemydownloads();
end;

procedure TForm1.MenuItem33Click(Sender: TObject);
begin
  if splitpos<50 then
    splitpos:=50;
  if splitpos>Form1.PairSplitter1.Height-50 then
    splitpos:=splitpos-50;
  if Form1.SynEdit1.Visible then
  begin
    splitpos:=Form1.PairSplitter1.Position;
  end;
  Form1.SynEdit1.Visible:=not Form1.SynEdit1.Visible;
  MenuItem33.Checked:=Form1.SynEdit1.Visible;
  if Form1.SynEdit1.Visible then
    Form1.PairSplitter1.Position:=splitpos
  else
    Form1.PairSplitter1.Position:=Form1.PairSplitter1.Height;
  Form1.MenuItem53.Checked:=Form1.SynEdit1.Visible;
  Form1.MenuItem53.Enabled:=Form1.SynEdit1.Visible;
  if Form1.SynEdit1.Visible=false then
    Form1.SynEdit1.Lines.Clear;
end;

procedure TForm1.MenuItem34Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  begin
    if DirectoryExists(UTF8ToSys(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columndestiny])) then
    begin
      if not OpenURL(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columndestiny]) then
        OpenURL(ExtractShortPathName(UTF8ToSys(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columndestiny])));
    end
    else
      ShowMessage(rsForm.msgnoexistfolder.Caption+' '+Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columndestiny]);
  end;
end;

procedure TForm1.MenuItem36Click(Sender: TObject);
begin
  Form1.ListView1.Column[0].Visible:=not Form1.ListView1.Column[0].Visible;
  Form1.ListView2.Column[0].Visible:=not Form1.ListView2.Column[0].Visible;
  Form1.MenuItem36.Checked:=Form1.ListView1.Column[0].Visible;
end;

procedure TForm1.MenuItem37Click(Sender: TObject);
begin
  Form1.ListView1.Column[columnname+1].Visible:=not Form1.ListView1.Column[columnname+1].Visible;
  Form1.ListView2.Column[columnname+1].Visible:=not Form1.ListView2.Column[columnname+1].Visible;
  Form1.MenuItem37.Checked:=Form1.ListView1.Column[columnname+1].Visible;
end;

procedure TForm1.MenuItem38Click(Sender: TObject);
begin
  Form1.ListView1.Column[columnsize+1].Visible:=not Form1.ListView1.Column[columnsize+1].Visible;
  Form1.ListView2.Column[columnsize+1].Visible:=not Form1.ListView2.Column[columnsize+1].Visible;
  Form1.MenuItem38.Checked:=Form1.ListView1.Column[columnsize+1].Visible;
end;

procedure TForm1.MenuItem39Click(Sender: TObject);
begin
  Form1.ListView1.Column[columnurl+1].Visible:=not Form1.ListView1.Column[columnurl+1].Visible;
  Form1.ListView2.Column[columnurl+1].Visible:=not Form1.ListView2.Column[columnurl+1].Visible;
  Form1.MenuItem39.Checked:=Form1.ListView1.Column[columnurl+1].Visible;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  if Form1.TreeView1.SelectionCount>0 then
  begin
    if Form1.TreeView1.Selected.Level>0 then
    begin
      case Form1.TreeView1.Selected.Parent.Index of
        1:
        begin//colas
          queuemanual[Form1.TreeView1.Selected.Index]:=true;
          qtimer[Form1.TreeView1.Selected.Index].Interval:=1000;
          qtimer[Form1.TreeView1.Selected.Index].Enabled:=true;
        end;
      end;
    end;
  end;
end;

procedure TForm1.MenuItem40Click(Sender: TObject);
begin
  Form1.ListView1.Column[columnspeed+1].Visible:=not Form1.ListView1.Column[columnspeed+1].Visible;
  Form1.ListView2.Column[columnspeed+1].Visible:=not Form1.ListView2.Column[columnspeed+1].Visible;
  Form1.MenuItem40.Checked:=Form1.ListView1.Column[columnspeed+1].Visible;
end;

procedure TForm1.MenuItem41Click(Sender: TObject);
begin
  Form1.ListView1.Column[columnpercent+1].Visible:=not Form1.ListView1.Column[columnpercent+1].Visible;
  Form1.ListView2.Column[columnpercent+1].Visible:=not Form1.ListView2.Column[columnpercent+1].Visible;
  Form1.MenuItem41.Checked:=Form1.ListView1.Column[columnpercent+1].Visible;
end;

procedure TForm1.MenuItem42Click(Sender: TObject);
begin
  Form1.ListView1.Column[columnestimate+1].Visible:=not Form1.ListView1.Column[columnestimate+1].Visible;
  Form1.ListView2.Column[columnestimate+1].Visible:=not Form1.ListView2.Column[columnestimate+1].Visible;
  Form1.MenuItem42.Checked:=Form1.ListView1.Column[columnestimate+1].Visible;
end;

procedure TForm1.MenuItem43Click(Sender: TObject);
begin
  Form1.ListView1.Column[columndestiny+1].Visible:=not Form1.ListView1.Column[columndestiny+1].Visible;
  Form1.ListView2.Column[columndestiny+1].Visible:=not Form1.ListView2.Column[columndestiny+1].Visible;
  Form1.MenuItem43.Checked:=Form1.ListView1.Column[columndestiny+1].Visible;
end;

procedure TForm1.MenuItem44Click(Sender: TObject);
begin
  Form1.ListView1.Column[columnengine+1].Visible:=not Form1.ListView1.Column[columnengine+1].Visible;
  Form1.ListView2.Column[columnengine+1].Visible:=not Form1.ListView2.Column[columnengine+1].Visible;
  Form1.MenuItem44.Checked:=Form1.ListView1.Column[columnengine+1].Visible;
end;

procedure TForm1.MenuItem45Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  begin
    if Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columntype]='0' then
    begin
      if FileExists(UTF8ToSys(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columndestiny]+pathdelim+Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnname])) then
        OpenURL(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columndestiny]+pathdelim+Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnname])
      else
        ShowMessage(rsForm.msgfilenoexist.Caption);
    end;
  end;
end;

procedure TForm1.MenuItem46Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
    OpenURL(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnurl]);
end;

procedure TForm1.MenuItem47Click(Sender: TObject);
var
  x:integer;
begin
  dlgForm.Caption:=rsForm.dlgconfirm.Caption;
  dlgForm.dlgtext.Caption:=rsForm.dlgrestartalldownloadslatter.Caption;
  dlgForm.ShowModal;
  if dlgcuestion then
  begin
    for x:=0 to Form1.ListView1.Items.Count-1 do
    begin
      if Form1.ListView1.Items[x].Subitems[columnstatus]<>'1' then
        restartdownload(x,false);
    end;
  end;
  Form1.TreeView1SelectionChanged(nil);
end;

procedure TForm1.MenuItem48Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  begin
    dlgForm.Caption:=rsForm.dlgconfirm.Caption;
    dlgForm.dlgtext.Caption:=rsForm.dlgrestartselecteddownloadletter.Caption;
    dlgForm.ShowModal;
    if dlgcuestion then
    begin
      restartdownload(Form1.ListView1.ItemIndex,false);
    end;
  end;
end;

procedure TForm1.MenuItem49Click(Sender: TObject);
begin
  movestepup(Form1.ListView1.ItemIndex-1);
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
var
  i:integer;
begin
  Form1.MenuItem4.Checked:=not Form1.MenuItem4.Checked;
  showdowntrayicon:=Form1.MenuItem4.Checked;
  for i:=0 to Length(trayicons)-1 do
  begin
    if Assigned(trayicons[i]) then
    begin
      if showdowntrayicon then
      begin
        if Form1.ListView1.Items[i].SubItems[columnstatus]='1' then
          trayicons[i].Visible:=true;
      end
      else
        trayicons[i].Visible:=false;
    end;
  end;
end;

procedure TForm1.MenuItem50Click(Sender: TObject);
begin
  movestepdown(Form1.ListView1.ItemIndex+1);
end;

procedure TForm1.MenuItem51Click(Sender: TObject);
begin
  movestepup(0);
end;

procedure TForm1.MenuItem52Click(Sender: TObject);
begin
  movestepdown(Form1.ListView1.Items.Count-1);
end;

procedure TForm1.MenuItem53Click(Sender: TObject);
begin
  Form1.MenuItem53.Checked:=not Form1.MenuItem53.Checked;
end;

procedure TForm1.MenuItem54Click(Sender: TObject);
begin
  importdownloads();
end;

procedure TForm1.MenuItem55Click(Sender: TObject);
begin
  exportdownloads();
end;

procedure TForm1.MenuItem56Click(Sender: TObject);
begin
  if Form1.TreeView1.SelectionCount>0 then
  begin
    if Form1.TreeView1.Selected.Level>0 then
    begin
      case Form1.TreeView1.Selected.Parent.Index of
        1:
        begin//colas
          queuemanual[Form1.TreeView1.Selected.Index]:=true;
          qtimer[Form1.TreeView1.Selected.Index].Interval:=1000;
          qtimer[Form1.TreeView1.Selected.Index].Enabled:=true;
        end;
      end;
    end;
  end;
end;

procedure TForm1.MenuItem57Click(Sender: TObject);
begin
  if Form1.TreeView1.SelectionCount>0 then
  begin
    if Form1.TreeView1.Selected.Level>0 then
    begin
      case Form1.TreeView1.Selected.Parent.Index of
        1:
        begin//colas
          stopqueue(Form1.TreeView1.Selected.Index);
        end;
      end;
    end;
  end;
end;

procedure TForm1.MenuItem58Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  begin
    dlgForm.Caption:=rsForm.dlgconfirm.Caption;
    dlgForm.dlgtext.Caption:=rsForm.dlgclearhistorylogfile.Caption;
    dlgForm.ShowModal;
    if dlgcuestion then
    begin
      if FileExists(UTF8ToSys(logpath+pathdelim+Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnname])+'.log') then
        SysUtils.DeleteFile(UTF8ToSys(logpath+pathdelim+Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnname])+'.log');
    end;
    Form1.SynEdit1.Lines.Clear;
  end;
end;

procedure TForm1.MenuItem59Click(Sender: TObject);
begin
  ToolButton1Click(nil);
end;

procedure TForm1.MenuItem60Click(Sender: TObject);
begin
  startsheduletimer();
end;

procedure TForm1.MenuItem61Click(Sender: TObject);
begin
  if Form1.ListView1.Items[numtraydown].SubItems[columnstatus]<>'1' then
  begin
    downloadstart(numtraydown,false);
  end;
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
  saveandexit();
end;

procedure TForm1.MenuItem71Click(Sender: TObject);
begin
  if Form1.ListView1.Items[numtraydown].SubItems[columnstatus]='1' then
    hilo[strtoint(Form1.ListView1.Items[numtraydown].SubItems[columnid])].shutdown()
end;

procedure TForm1.MenuItem72Click(Sender: TObject);
begin
  trayicons[numtraydown].Visible:=false;
end;

procedure TForm1.MenuItem82Click(Sender: TObject);
begin
  Form1.ListView1.Column[columndate+1].Visible:=not Form1.ListView1.Column[columndate+1].Visible;
  Form1.ListView2.Column[columndate+1].Visible:=not Form1.ListView2.Column[columndate+1].Visible;
  Form1.MenuItem82.Checked:=Form1.ListView1.Column[columndate+1].Visible;
end;

procedure TForm1.MenuItem83Click(Sender: TObject);
begin
  newqueue();
end;

procedure TForm1.MenuItem84Click(Sender: TObject);
begin
  deletequeue(Form1.TreeView1.Selected.Index);
end;

procedure TForm1.MenuItem85Click(Sender: TObject);
begin
  Form1.TreeView1.Selected.EditText;
end;

procedure TForm1.MenuItem88Click(Sender: TObject);
begin
  Form1.ToolButton28Click(nil);
end;

procedure TForm1.MenuItem89Click(Sender: TObject);
begin
  Form1.ToolButton28Click(nil);
end;

procedure TForm1.MenuItem8Click(Sender: TObject);
begin
  Form3.TreeView1.Items[Form3.PageControl1.ActivePageIndex].Selected:=true;
  configdlg();
  Form3.Show;
end;

procedure TForm1.MenuItem91Click(Sender: TObject);
begin
  OpenURL('http://sites.google.com/site/awggproject');
end;

procedure TForm1.MenuItem92Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  begin
    trayicons[Form1.ListView1.ItemIndex].Visible:=not trayicons[Form1.ListView1.ItemIndex].Visible;
    Form1.MenuItem92.Checked:=trayicons[Form1.ListView1.ItemIndex].Visible;
  end;
end;

procedure TForm1.PairSplitter1ChangeBounds(Sender: TObject);
begin
  splitpos:=Round(Form1.PairSplitter1.Height/1.3);
  if Form1.SynEdit1.Visible then
    Form1.PairSplitter1.Position:=splitpos
  else
    Form1.PairSplitter1.Position:=Form1.PairSplitter1.Height;
end;

procedure TForm1.PairSplitter1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  splitpos:=Form1.PairSplitter1.Position;
end;

procedure TForm1.PairSplitter1Resize(Sender: TObject);
begin
  if Form1.SynEdit1.Visible then
    splitpos:=Form1.PairSplitter1.Position;
end;

procedure TForm1.PairSplitter2ChangeBounds(Sender: TObject);
begin
  splithpos:=Form1.PairSplitter2.Position;
end;

procedure TForm1.PairSplitter2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  splithpos:=Form1.PairSplitter2.Position;
end;

procedure TForm1.PairSplitter2Resize(Sender: TObject);
begin
  splithpos:=Form1.PairSplitter2.Position;
end;

procedure TForm1.PopupNotifier1Close(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if (CloseAction<>caNone) and  (CloseAction<>caFree) and (Form1.Visible=false) then
    Form1.Show;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  savemydownloads();
  Form1.Timer1.Enabled:=false;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
begin
  Form1.PopupNotifier1.Hide;
  Form1.Timer3.Enabled:=false;
end;

procedure TForm1.Timer4StartTimer(Sender: TObject);
begin
  Form1.ToolButton31.Down:=Form1.Timer4.Enabled;
end;

procedure TForm1.Timer4StopTimer(Sender: TObject);
begin
  Form1.ToolButton31.Down:=Form1.Timer4.Enabled;
end;

procedure TForm1.Timer4Timer(Sender: TObject);
var
  cbn:integer;
  noesta:boolean;
  tmpclip:string='';
begin
  noesta:=true;
  if sameclip<>ClipBoard.AsText then
  begin
    sameclip:=ClipBoard.AsText;
    tmpclip:=Copy(sameclip,0,6);
    if (tmpclip='http:/') or (tmpclip='https:') or (tmpclip='ftp://') then
    begin
      for cbn:=0 to Form1.ListView1.Items.Count-1 do
      begin
        if sameclip=Form1.ListView1.Items[cbn].SubItems[columnurl] then
          noesta:=false;
      end;
      if noesta then
      begin
        Form1.Timer4.Enabled:=false;
        ToolButton1Click(nil);
        Form1.Timer4.Enabled:=true;
      end;
    end;
    tmpclip:='';
  end;
end;

procedure TForm1.Timer6Timer(Sender: TObject);
var
  downitem:TListItem;
  tmpindex,i:integer;
  itemfile:TSearchRec;
  fcookie:string='';
  fname:string='';
  url:string='';
  silent:boolean=false;
begin
  newdownqueues();
  Form1.Timer6.Enabled:=false;
  if firststart then
  begin
    Form5.ComboBox1.Items.Clear;
    if FindFirst(ExtractFilePath(UTF8ToSys(Application.Params[0]))+pathdelim+'languages'+pathdelim+'awgg.*.po',faAnyFile,itemfile)=0 then
    begin
      Repeat
        try
          Form5.ComboBox1.Items.Add(Copy(itemfile.name,Pos('awgg.',itemfile.name)+5,Pos('.po',itemfile.name)-6));
        except
        on E:Exception do ShowMessage('The file '+itemfile.Name+' of language is not valid');
        end;
      Until FindNext(itemfile)<>0;
    end;
    if Form5.ComboBox1.Items.Count>0 then
    begin
      Form5.ComboBox1.ItemIndex:=0;
      Form5.ShowModal;
      deflanguage:=Form5.ComboBox1.Text;
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
        if Application.Params[i+1]<>'-c' then
          fname:=Application.Params[i+1];
      end;
      if (Application.Params[i]='-c') and (Application.ParamCount>i) then
        fcookie:=Application.Params[i+1];
      if (Pos('http://',Application.Params[i])=1) or (Pos('https://',Application.Params[i])=1) or (Pos('ftp://',Application.Params[i])=1) then
        url:=Application.Params[i];
    end;
    Form2.Edit1.Text:=url;
    if fname<>'' then
      Form2.Edit3.Text:=fname
    else
      Form2.Edit3.Text:=ParseURI(Form2.Edit1.Text).Document;
    case defaultdirmode of
      1:Form2.DirectoryEdit1.Text:=ddowndir;
      2:Form2.DirectoryEdit1.Text:=suggestdir(Form2.Edit3.Text);
    end;
    Form2.Edit2.Text:='';
    Form2.Edit4.Text:='';
    Form2.Edit5.Text:='';
    Form2.ComboBox1.ItemIndex:=Form2.ComboBox1.Items.IndexOf(defaultengine);
    Form1.Timer4.Enabled:=false;//Desactivar temporalmente el clipboard monitor
    enginereload();
    if Form2.ComboBox2.ItemIndex=-1 then
      Form2.ComboBox2.ItemIndex:=0;
    //queueindexselect();
    if (Form2.Visible=false) and (silent=false) then
      Form2.ShowModal;
    if silent then
      silent:=checkandclose(true);
    Form1.Timer4.Enabled:=clipboardmonitor;//Avtivar el clipboardmonitor
    if agregar or silent then
    begin
      downitem:=TListItem.Create(Form1.ListView1.Items);
      downitem.Caption:=rsForm.statuspaused.Caption;
      downitem.ImageIndex:=18;
      downitem.SubItems.Add(Form2.Edit3.Text);//Nombre de archivo
      downitem.SubItems.Add('');//Tama;o
      downitem.SubItems.Add('');//Descargado
      downitem.SubItems.Add(Form2.Edit1.Text);//URL
      downitem.SubItems.Add('');//Velocidad
      downitem.SubItems.Add('');//Porciento
      downitem.SubItems.Add('');//Estimado
      downitem.SubItems.Add(datetostr(Date())+' '+timetostr(Time()));//Fecha
      downitem.SubItems.Add(Form2.DirectoryEdit1.Text);//Destino
      downitem.SubItems.Add(Form2.ComboBox1.Text);//Motor
      downitem.SubItems.Add(Form2.Edit2.Text);//Parametros
      downitem.SubItems.Add('0');//status
      downitem.SubItems.Add(inttostr(Form1.ListView1.Items.Count));//id
      downitem.SubItems.Add(Form2.Edit4.Text);//user
      downitem.SubItems.Add(Form2.Edit5.Text);//pass
      downitem.SubItems.Add(inttostr(triesrotate));//tries
      downitem.SubItems.Add(uidgen());//uid
      if silent then
        downitem.SubItems.Add('0')//silent defualt queue
      else
        downitem.SubItems.Add(inttostr(Form2.ComboBox2.ItemIndex));//queue
      downitem.SubItems.Add('0');//type
      downitem.SubItems.Add(fcookie);//cookie
      Form1.ListView1.Items.AddItem(downitem);
      tmpindex:=downitem.Index;
      if cola then
      begin
        queuemanual[strtoint(Form1.ListView1.Items[tmpindex].SubItems[columnqueue])]:=true;
        qtimer[strtoint(Form1.ListView1.Items[tmpindex].SubItems[columnqueue])].Enabled:=true;
      end;
      Form1.TreeView1SelectionChanged(nil);
      savemydownloads();
      if iniciar or silent then
      begin
        downloadstart(tmpindex,false);
      end;
    end;
  end;
  silent:=false;
end;

procedure TForm1.ToolButton11Click(Sender: TObject);
begin
  if Form1.TreeView1.SelectionCount>0 then
  begin
    if Form1.TreeView1.Selected.Level>0 then
    begin
      case Form1.TreeView1.Selected.Parent.Index of
        1:
        begin//colas
          stopqueue(Form1.TreeView1.Selected.Index);
        end;
      end;
    end;
  end;
end;

procedure TForm1.ToolButton12Click(Sender: TObject);
begin
  stopall(false);
end;

procedure TForm1.ToolButton14Click(Sender: TObject);
begin
  Form1.SynEdit1.Lines.Clear;
end;

procedure TForm1.ToolButton15Click(Sender: TObject);
begin
  startsheduletimer();
end;

procedure TForm1.ToolButton16Click(Sender: TObject);
begin
  if Form1.TreeView1.SelectionCount>0 then
  begin
    if Form1.TreeView1.Selected.Level>0 then
    begin
      case Form1.TreeView1.Selected.Parent.Index of
        1:
        begin//colas
          stimer[Form1.TreeView1.Selected.Index].Enabled:=false;
        end;
      end;
    end;
  end;
end;

procedure TForm1.ToolButton17Click(Sender: TObject);
begin
  saveandexit();
end;

procedure TForm1.ToolButton19Click(Sender: TObject);
begin
  moveonestepup();
end;

procedure TForm1.ToolButton1Click(Sender: TObject);
var
  downitem:TListItem;
  tmpindex:integer;
  tmpclip:string='';
begin
  if Length(ClipBoard.AsText)<=256 then
    tmpclip:=ClipBoard.AsText;
  if (Pos('http://',tmpclip)=1) or (Pos('https://',tmpclip)=1) or (Pos('ftp://',tmpclip)=1) then
    Form2.Edit1.Text:=tmpclip
  else
    Form2.Edit1.Text:='http://';
  tmpclip:='';
  Form2.Edit3.Text:=ParseURI(Form2.Edit1.Text).Document;
  case defaultdirmode of
    1:Form2.DirectoryEdit1.Text:=ddowndir;
    2:Form2.DirectoryEdit1.Text:=suggestdir(Form2.Edit3.Text);
  end;
  Form2.Edit2.Text:='';
  Form2.Edit4.Text:='';
  Form2.Edit5.Text:='';
  Form2.ComboBox1.ItemIndex:=Form2.ComboBox1.Items.IndexOf(defaultengine);
  Form1.Timer4.Enabled:=false;//Descativar temporalmete el clipboardmonitor
  //Recargar engines
  enginereload();
  queueindexselect();
  if Form2.Visible=false then
    Form2.ShowModal;
  Form1.Timer4.Enabled:=clipboardmonitor;//Activar el clipboardmonitor.
  if agregar then
  begin
    downitem:=TListItem.Create(Form1.ListView1.Items);
    downitem.Caption:=rsForm.statuspaused.Caption;
    downitem.ImageIndex:=18;
    downitem.SubItems.Add(Form2.Edit3.Text);//Nombre de archivo
    downitem.SubItems.Add('');//Tama;o
    downitem.SubItems.Add('');//Descargado
    downitem.SubItems.Add(Form2.Edit1.Text);//URL
    downitem.SubItems.Add('');//Velocidad
    downitem.SubItems.Add('');//Porciento
    downitem.SubItems.Add('');//Estimado
    downitem.SubItems.Add(datetostr(Date())+' '+timetostr(Time()));//Fecha
    downitem.SubItems.Add(Form2.DirectoryEdit1.Text);//Destino
    downitem.SubItems.Add(Form2.ComboBox1.Text);//Motor
    downitem.SubItems.Add(Form2.Edit2.Text);//Parametros
    downitem.SubItems.Add('0');//status
    downitem.SubItems.Add(inttostr(Form1.ListView1.Items.Count));//id
    downitem.SubItems.Add(Form2.Edit4.Text);//user
    downitem.SubItems.Add(Form2.Edit5.Text);//pass
    downitem.SubItems.Add(inttostr(triesrotate));//tries
    downitem.SubItems.Add(uidgen());//uid
    downitem.SubItems.Add(inttostr(Form2.ComboBox2.ItemIndex));//queue
    downitem.SubItems.Add('0');//type
    downitem.SubItems.Add('');//cookie
    Form1.ListView1.Items.AddItem(downitem);
    tmpindex:=downitem.Index;
    if cola then
    begin
      queuemanual[strtoint(Form1.ListView1.Items[tmpindex].SubItems[columnqueue])]:=true;
      qtimer[strtoint(Form1.ListView1.Items[tmpindex].SubItems[columnqueue])].Enabled:=true;
    end;
    Form1.TreeView1SelectionChanged(nil);
    savemydownloads();
    if iniciar then
    begin
      downloadstart(tmpindex,false);
    end;
  end;
end;

procedure TForm1.ToolButton20Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  moveonestepdown(Form1.ListView1.ItemIndex);
end;

procedure TForm1.ToolButton22Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  begin
    dlgForm.Caption:=rsForm.dlgconfirm.Caption;
    dlgForm.dlgtext.Caption:=rsForm.dlgrestartselecteddownload.Caption;
    dlgForm.ShowModal;
    if dlgcuestion then
    begin
      restartdownload(Form1.ListView1.ItemIndex,true);
    end;
  end;
end;

procedure TForm1.ToolButton23Click(Sender: TObject);
begin
  movestepup(0);
end;

procedure TForm1.ToolButton24Click(Sender: TObject);
begin
  movestepdown(Form1.ListView1.Items.Count-1);
end;

procedure TForm1.ToolButton25Click(Sender: TObject);
begin
  importdownloads();
end;

procedure TForm1.ToolButton26Click(Sender: TObject);
begin
  exportdownloads();
end;

procedure TForm1.ToolButton28Click(Sender: TObject);
var
  downitem:TListItem;
  tmpclip:string='';
  paramlist:string='';
begin
  if Length(ClipBoard.AsText)<=256 then
  tmpclip:=ClipBoard.AsText;
  if (Pos('http://',tmpclip)=1) or (Pos('https://',tmpclip)=1) or (Pos('ftp://',tmpclip)=1) then
    Form7.Edit1.Text:=tmpclip
  else
    Form7.Edit1.Text:='http://';
  tmpclip:='';
  Form7.Edit2.Text:=ParseURI(Form2.Edit1.Text).Document;
  Form7.DirectoryEdit1.Text:=ddowndir+pathdelim+'Sites';
  if not DirectoryExists(ddowndir+pathdelim+'Sites') then
    CreateDir(ddowndir+pathdelim+'Sites');
  Form7.Edit2.Text:='';
  Form7.Edit3.Text:='';
  Form7.Edit4.Text:='';
  Form7.Edit5.Text:=globaluseragent;
  Form7.ComboBox1.ItemIndex:=Form7.ComboBox1.Items.IndexOf(defaultengine);
  Form1.Timer4.Enabled:=false;//Descativar temporalmete el clipboardmonitor
  newgrabberqueues();
  queueindexselect();
  Form7.PageControl1.PageIndex:=0;
  if Form7.Visible=false then
    Form7.ShowModal;
  Form1.Timer4.Enabled:=clipboardmonitor;//Activar el clipboardmonitor.
  if grbadd then
  begin
    paramlist:=paramlist+'-l '+inttostr(Form7.SpinEdit1.Value);
    if Form7.CheckBox1.Checked then
      paramlist:=paramlist+' -k';
    if Form7.CheckBox2.Checked then
     paramlist:=paramlist+' --follow-ftp';
    if Form7.CheckBox3.Checked then
      paramlist:=paramlist+' -np';
    if Form7.CheckBox4.Checked then
      paramlist:=paramlist+' -p';
    if Form7.CheckBox5.Checked then
      paramlist:=paramlist+' -H';
    if Form7.CheckBox6.Checked then
      paramlist:=paramlist+' -L';
    if Length(Form7.Memo1.Lines.Text)>0 then
      paramlist:=paramlist+' -R "'+Form7.Memo1.Lines.Text+'"';
    if Length(Form7.Memo2.Lines.Text)>0 then
      paramlist:=paramlist+' --exclude-domains "'+Form7.Memo2.Lines.Text+'"';
    if Length(Form7.Memo3.Lines.Text)>0 then
      paramlist:=paramlist+' -D "'+Form7.Memo3.Lines.Text+'"';
    if Length(Form7.Memo4.Lines.Text)>0 then
      paramlist:=paramlist+' -I "'+Form7.Memo4.Lines.Text+'"';
    if Length(Form7.Memo5.Lines.Text)>0 then
      paramlist:=paramlist+' -X "'+Form7.Memo5.Lines.Text+'"';
    if Length(Form7.Memo6.Lines.Text)>0 then
      paramlist:=paramlist+' -A "'+Form7.Memo6.Lines.Text+'"';
    if Length(Form7.Memo7.Lines.Text)>0 then
      paramlist:=paramlist+' --follow-tags="'+Form7.Memo7.Lines.Text+'"';
    if Length(Form7.Memo8.Lines.Text)>0 then
      paramlist:=paramlist+' --ignore-tags="'+Form7.Memo8.Lines.Text+'"';
    if Length(Form7.Edit5.Text)>0 then
      paramlist:=paramlist+' -U "'+Form7.Edit5.Text+'"';
    downitem:=TListItem.Create(Form1.ListView1.Items);
    downitem.Caption:=rsForm.statuspaused.Caption;
    downitem.ImageIndex:=51;
    downitem.SubItems.Add(Form7.Edit2.Text);//Nombre del sitio
    downitem.SubItems.Add('');//Tama;o
    downitem.SubItems.Add('');//Descargado
    downitem.SubItems.Add(Form7.Edit1.Text);//URL
    downitem.SubItems.Add('');//Velocidad
    downitem.SubItems.Add('');//Porciento
    downitem.SubItems.Add('');//Estimado
    downitem.SubItems.Add(datetostr(Date())+' '+timetostr(Time()));//Fecha
    downitem.SubItems.Add(Form7.DirectoryEdit1.Text);//Destino
    downitem.SubItems.Add('wget');//Motor
    downitem.SubItems.Add(paramlist);//Parametros
    downitem.SubItems.Add('0');//status
    downitem.SubItems.Add(inttostr(Form1.ListView1.Items.Count));//id
    downitem.SubItems.Add(Form7.Edit3.Text);//user
    downitem.SubItems.Add(Form7.Edit4.Text);//pass
    downitem.SubItems.Add(inttostr(triesrotate));//tries
    downitem.SubItems.Add(uidgen());//uid
    downitem.SubItems.Add(inttostr(Form7.ComboBox1.ItemIndex));//queue
    downitem.SubItems.Add('1');//type
    downitem.SubItems.Add('');//cookie;
    Form1.ListView1.Items.AddItem(downitem);
    Form1.TreeView1SelectionChanged(nil);
    savemydownloads();
  end;
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
begin
  deleteitems(false);
end;

procedure TForm1.ToolButton31Click(Sender: TObject);
begin
  Form1.Timer4.Enabled:=Form1.ToolButton31.Down;
  clipboardmonitor:=Form1.ToolButton31.Down;
end;

procedure TForm1.ToolButton3Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  begin
    queuemanual[strtoint(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnqueue])]:=true;
    downloadstart(Form1.ListView1.ItemIndex,false);
  end
  else
    ShowMessage(rsForm.msgmustselectdownload.Caption);
end;

procedure TForm1.ToolButton4Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  begin
    hilo[strtoint(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnid])].shutdown();
    Form1.ToolButton3.Enabled:=true;
    Form1.ToolButton4.Enabled:=false;
    Form1.ToolButton22.Enabled:=true;
  end
  else
    ShowMessage(rsForm.msgmustselectdownload.Caption);
end;

procedure TForm1.ToolButton7Click(Sender: TObject);
begin
  Form3.TreeView1.Items[Form3.PageControl1.ActivePageIndex].Selected:=true;
  configdlg();
  Form3.Show;
end;

procedure TForm1.ToolButton8Click(Sender: TObject);
begin
  Form3.PageControl1.ActivePageIndex:=1;
  Form3.TreeView1.Items[Form3.PageControl1.ActivePageIndex].Selected:=true;
  configdlg();
  Form3.Show;
end;

procedure TForm1.ToolButton9Click(Sender: TObject);
begin
  if Form1.TreeView1.SelectionCount>0 then
  begin
    if Form1.TreeView1.Selected.Level>0 then
    begin
      case Form1.TreeView1.Selected.Parent.Index of
        1:
        begin//colas
          queuemanual[Form1.TreeView1.Selected.Index]:=true;
          qtimer[Form1.TreeView1.Selected.Index].Interval:=1000;
          qtimer[Form1.TreeView1.Selected.Index].Enabled:=true;
        end;
      end;
    end;
  end;
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  Form1.TrayIcon1MouseMove(nil,[ssShift], 0, 0);
end;

procedure TForm1.TrayIcon1DblClick(Sender: TObject);
begin
  Form1.WindowState:=lastmainwindowstate;
  if firsttime then
    Form1.Visible:=false;
  firsttime:=false;
  if(not Form2.Visible) and (not Form3.Visible) then
  begin
    Form1.Show;
  end;
  if (Form2.Visible) and (not Form3.Visible) then
    Form2.Show;
  if (not Form2.Visible) and (Form3.Visible) then
    Form3.Show;
end;

procedure TForm1.TrayIcon1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  n,nc:integer;
  strhint:string;
begin
  nc:=0;
  strhint:='';
  for n:=0 to Form1.ListView1.Items.Count-1 do
  begin
    if Form1.ListView1.Items[n].SubItems[columnstatus]='1' then
      strhint+=Form1.ListView1.Items[n].SubItems[columnpercent]+' '+Form1.ListView1.Items[n].SubItems[columnname]+' '+Form1.ListView1.Items[n].SubItems[columnspeed]+' '+Form1.ListView1.Items[n].SubItems[columnestimate]+#10;
    if Form1.ListView1.Items[n].SubItems[columnstatus]='3' then
      inc(nc);
  end;
  Form1.TrayIcon1.Hint:='AWGG ['+inttostr(nc)+'/'+inttostr(Form1.ListView1.Items.Count)+']'+#10+strhint;
end;

procedure TForm1.TreeView1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  if Form1.TreeView1.Items.SelectionCount>0 then
  begin
    if Form1.TreeView1.Selected.Level>0 then
    begin
      case Form1.TreeView1.Selected.Parent.Index of
        1:
        begin
          if Form1.TreeView1.Selected.Index<>0 then
          begin
            Form1.MenuItem83.Enabled:=true;
            Form1.MenuItem84.Enabled:=true;
            Form1.MenuItem85.Enabled:=true;
            Form1.PopupMenu3.PopUp;
          end
          else
          begin
            Form1.MenuItem83.Enabled:=true;
            Form1.MenuItem84.Enabled:=false;
            Form1.MenuItem85.Enabled:=false;
            Form1.PopupMenu3.PopUp;
          end;
        end;
      end;
    end
    else
    begin
      //////elementos de la rais
      case Form1.TreeView1.Selected.Index of
        1:
        begin
          Form1.MenuItem83.Enabled:=true;
          Form1.MenuItem84.Enabled:=false;
          Form1.MenuItem85.Enabled:=false;
          Form1.PopupMenu3.PopUp;
        end;
      end;
    end;
  end;
end;

procedure TForm1.TreeView1DblClick(Sender: TObject);
begin
  if Form1.TreeView1.Selected.Level>0 then
  begin
    case Form1.TreeView1.Selected.Parent.Index of
      3:
      begin//categorias
        if Form1.TreeView1.Selected.Index<Length(categoryextencions) then
        begin
          if DirectoryExists(UTF8ToSys(categoryextencions[Form1.TreeView1.Selected.Index][0])) then
          begin
            if not OpenURL(categoryextencions[Form1.TreeView1.Selected.Index][0]) then
              OpenURL(ExtractShortPathName(UTF8ToSys(categoryextencions[Form1.TreeView1.Selected.Index][0])));
          end
          else
            ShowMessage(rsForm.msgnoexistfolder.Caption+' '+categoryextencions[Form1.TreeView1.Selected.Index][0]);
        end
        else
        begin
          if DirectoryExists(UTF8ToSys(dotherdowndir)) then
          begin
            if not OpenURL(dotherdowndir) then
              OpenURL(ExtractShortPathName(UTF8ToSys(dotherdowndir)));
          end
          else
            ShowMessage(rsForm.msgnoexistfolder.Caption+' '+dotherdowndir);
        end;
      end;
    end;
  end;
end;

procedure TForm1.TreeView1Edited(Sender: TObject; Node: TTreeNode; var S: string
  );
begin
  if Form1.TreeView1.Items.SelectionCount>0 then
  begin
    if Form1.TreeView1.Selected.Level>0 then
    begin
      //elementos de las ramas
      case Form1.TreeView1.Selected.Parent.Index of
        1:
        begin//colas
          if Form1.TreeView1.Selected.Index<>0 then
          begin
            queuenames[Form1.TreeView1.Selected.Index]:=s;
            Form1.MenuItem86.Items[Form1.TreeView1.Selected.Index].Caption:=s;
            Form2.ComboBox2.Items[Form1.TreeView1.Selected.Index]:=s;
            if qtimer[Form1.TreeView1.Selected.Index].Enabled then
              Form1.PopupMenu1.Items[Form1.TreeView1.Selected.Index+5].Caption:=stopqueuesystray+' ('+s+')'
            else
              Form1.PopupMenu1.Items[Form1.TreeView1.Selected.Index+5].Caption:=startqueuesystray+' ('+s+')';
            savemydownloads();
          end;
        end;
      end;
    end;
  end;
end;

procedure TForm1.TreeView1Editing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
  if Form1.TreeView1.Items.SelectionCount>0 then
  begin
    if Form1.TreeView1.Selected.Level>0 then
    begin
      //elementos de las ramas
      if Form1.TreeView1.Selected.Parent.Index<>1 then
        allowedit:=false;
      case Form1.TreeView1.Selected.Parent.Index of
        1:
        begin//colas
          if Form1.TreeView1.Selected.Index=0 then
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

procedure TForm1.TreeView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    46:deletequeue(Form1.TreeView1.Selected.Index);
  end;
end;

procedure TForm1.TreeView1SelectionChanged(Sender: TObject);
var
  i:integer;
  sts:string;
  vitem:TListItem;
begin
  sts:='';
  Form1.ListView2.Items.Clear;
  if (Form1.TreeView1.SelectionCount>0) then
  begin
    Form1.ToolButton9.Enabled:=false;
    Form1.ToolButton11.Enabled:=false;
    Form1.ToolButton15.Enabled:=false;
    Form1.ToolButton16.Enabled:=false;
    if Form1.TreeView1.Selected.Level>0 then
    begin
      if Form1.ListView2.Visible=false then
      begin
        for i:=0 to Form1.ListView1.Columns.Count-1 do
        begin
          Form1.ListView2.Columns[i].Width:=Form1.ListView1.Columns[i].Width;
          Form1.ListView2.Columns[i].Visible:=Form1.ListView1.Columns[i].Visible;
        end;
      end;
      if (Form1.ListView1.ItemIndex=-1) and (Form1.ListView1.Items.Count>0) then
        Form1.ListView1.ItemIndex:=0;
      Form1.ListView1.Visible:=false;
      Form1.ListView2.Visible:=true;
      case Form1.TreeView1.Selected.Parent.Index of
        1:
        begin//colas
          for i:=0 to Form1.ListView1.Items.Count-1 do
          begin
            if Form1.ListView1.Items[i].SubItems[columnqueue]=inttostr(Form1.TreeView1.Selected.Index) then
            begin
              vitem:=TListItem.Create(Form1.ListView2.Items);
              vitem.Caption:=Form1.ListView1.Items[i].Caption;
              vitem.ImageIndex:=Form1.ListView1.Items[i].ImageIndex;
              vitem.SubItems.AddStrings(Form1.ListView1.Items[i].SubItems);
              vitem.Selected:=Form1.ListView1.Items[i].Selected;
              Form1.ListView2.Items.AddItem(vitem);
              vitem.Selected:=Form1.ListView1.Items[i].Selected;
              if Form1.ListView1.Items[i].SubItems[columnstatus]='1' then
              hilo[strtoint(Form1.ListView1.Items[i].SubItems[columnid])].thid2:=vitem.Index;
            end;
          end;
          if qtimer[Form1.TreeView1.Selected.Index].Enabled then
          begin
            Form1.ToolButton9.Enabled:=false;
            Form1.ToolButton11.Enabled:=true;
          end
          else
          begin
            Form1.ToolButton9.Enabled:=true;
            Form1.ToolButton11.Enabled:=false;
          end;

          if stimer[Form1.TreeView1.Selected.Index].Enabled then
          begin
            Form1.ToolButton15.Enabled:=false;
            Form1.ToolButton16.Enabled:=true;
          end
          else
          begin
            Form1.ToolButton15.Enabled:=true;
            Form1.ToolButton16.Enabled:=false;
          end;
        end;
        2:
        begin //filtros
          case Form1.TreeView1.Selected.Index of
            0:sts:='3';
            1:sts:='1';
            2:sts:='2';
            3:sts:='4';
            4:sts:='0';
          end;
          for i:=0 to Form1.ListView1.Items.Count-1 do
          begin
            if Form1.ListView1.Items[i].SubItems[columnstatus]=sts then
            begin
              vitem:=TListItem.Create(Form1.ListView2.Items);
              vitem.Caption:=Form1.ListView1.Items[i].Caption;
              vitem.ImageIndex:=Form1.ListView1.Items[i].ImageIndex;
              vitem.SubItems.AddStrings(Form1.ListView1.Items[i].SubItems);
              vitem.Selected:=Form1.ListView1.Items[i].Selected;
              Form1.ListView2.Items.AddItem(vitem);
              vitem.Selected:=Form1.ListView1.Items[i].Selected;
              if Form1.ListView1.Items[i].SubItems[columnstatus]='1' then
                hilo[strtoint(Form1.ListView1.Items[i].SubItems[columnid])].thid2:=vitem.Index;
            end;
          end;
        end;
        3:
        begin//categorias
          for i:=0 to Form1.ListView1.Items.Count-1 do
          begin
            if Form1.TreeView1.Selected.Index<Length(categoryextencions) then
            begin
              if findcategorydir(Form1.TreeView1.Selected.Index,Form1.ListView1.Items[i].SubItems[columnname]) then
              begin
                vitem:=TListItem.Create(Form1.ListView2.Items);
                vitem.Caption:=Form1.ListView1.Items[i].Caption;
                vitem.ImageIndex:=Form1.ListView1.Items[i].ImageIndex;
                vitem.SubItems.AddStrings(Form1.ListView1.Items[i].SubItems);
                vitem.Selected:=Form1.ListView1.Items[i].Selected;
                Form1.ListView2.Items.AddItem(vitem);
                vitem.Selected:=Form1.ListView1.Items[i].Selected;
                if Form1.ListView1.Items[i].SubItems[columnstatus]='1' then
                  hilo[strtoint(Form1.ListView1.Items[i].SubItems[columnid])].thid2:=vitem.Index;
              end;
            end
            else
            begin
              if not findcategoryall(Form1.ListView1.Items[i].SubItems[columnname]) then
              begin
                vitem:=TListItem.Create(Form1.ListView2.Items);
                vitem.Caption:=Form1.ListView1.Items[i].Caption;
                vitem.ImageIndex:=Form1.ListView1.Items[i].ImageIndex;
                vitem.SubItems.AddStrings(Form1.ListView1.Items[i].SubItems);
                vitem.Selected:=Form1.ListView1.Items[i].Selected;
                Form1.ListView2.Items.AddItem(vitem);
                vitem.Selected:=Form1.ListView1.Items[i].Selected;
                if Form1.ListView1.Items[i].SubItems[columnstatus]='1' then
                  hilo[strtoint(Form1.ListView1.Items[i].SubItems[columnid])].thid2:=vitem.Index;
              end;
            end;
          end;
        end;
      end;
    end
    else
    begin
      if Form1.ListView1.Visible=false then
      begin
        for i:=0 to Form1.ListView1.Columns.Count-1 do
        begin
          Form1.ListView1.Columns[i].Width:=Form1.ListView2.Columns[i].Width;
          Form1.ListView1.Columns[i].Visible:=Form1.ListView2.Columns[i].Visible;
        end;
      end;
      Form1.ListView1.Visible:=true;
      Form1.ListView2.Visible:=false;
    end;
  end;
  {$IFDEF LCLGTK2}
    if columncolav then
    begin
      Form1.ListView1.Columns[0].Width:=columncolaw;
      Form1.ListView2.Columns[0].Width:=columncolaw;
    end;
  {$ENDIF}
end;

procedure TForm1.UniqueInstance1OtherInstance(Sender: TObject;
  ParamCount: Integer; Parameters: array of String);
var
  downitem:TListItem;
  tmpindex,i:integer;
  url:string='';
  fcookie:string='';
  fname:string='';
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
        if Parameters[i+1]<>'-c' then
        fname:=Parameters[i+1];
      end;
      if (Parameters[i]='-c') and (ParamCount>i) then
        fcookie:=Parameters[i+1];
      if (Pos('http://',Parameters[i])=1) or (Pos('https://',Parameters[i])=1) or (Pos('ftp://',Parameters[i])=1) then
        url:=Parameters[i];
    end;
    Form2.Edit1.Text:=url;
    if fname<>'' then
      Form2.Edit3.Text:=fname
    else
      Form2.Edit3.Text:=ParseURI(Form2.Edit1.Text).Document;
    case defaultdirmode of
      1:Form2.DirectoryEdit1.Text:=ddowndir;
      2:Form2.DirectoryEdit1.Text:=suggestdir(Form2.Edit3.Text);
    end;
    Form2.Edit2.Text:='';
    Form2.Edit4.Text:='';
    Form2.Edit5.Text:='';
    Form2.ComboBox1.ItemIndex:=Form2.ComboBox1.Items.IndexOf(defaultengine);
    Form1.Timer4.Enabled:=false;//Desactivar temporalmente el clipboardmonitor
    enginereload();
    if Form2.ComboBox2.ItemIndex=-1 then
      Form2.ComboBox2.ItemIndex:=0;
    //queueindexselect();
    if (Form2.Visible=false) and (silent=false) then
      Form2.ShowModal;
    if silent then
      silent:=checkandclose(true);
    Form1.Timer4.Enabled:=clipboardmonitor;//Activar el clipboardmonitor
    if agregar or silent then
    begin
      downitem:=TListItem.Create(Form1.ListView1.Items);
      downitem.Caption:=rsForm.statuspaused.Caption;
      downitem.ImageIndex:=18;
      downitem.SubItems.Add(Form2.Edit3.Text);//Nombre de archivo
      downitem.SubItems.Add('');//Tama;o
      downitem.SubItems.Add('');//Descargado
      downitem.SubItems.Add(Form2.Edit1.Text);//URL
      downitem.SubItems.Add('');//Velocidad
      downitem.SubItems.Add('');//Porciento
      downitem.SubItems.Add('');//Estimado
      downitem.SubItems.Add(datetostr(Date())+' '+timetostr(Time()));//Fecha
      downitem.SubItems.Add(Form2.DirectoryEdit1.Text);//Destino
      downitem.SubItems.Add(Form2.ComboBox1.Text);//Motor
      downitem.SubItems.Add(Form2.Edit2.Text);//Parametros
      downitem.SubItems.Add('0');//status
      downitem.SubItems.Add(inttostr(Form1.ListView1.Items.Count));//id
      downitem.SubItems.Add(Form2.Edit4.Text);//user
      downitem.SubItems.Add(Form2.Edit5.Text);//pass
      downitem.SubItems.Add(inttostr(triesrotate));//tries
      downitem.SubItems.Add(uidgen());//uid
      if silent then
        downitem.SubItems.Add('0')
      else
        downitem.SubItems.Add(inttostr(Form2.ComboBox2.ItemIndex));//queue
      downitem.SubItems.Add('0');//type
      downitem.SubItems.Add(fcookie);//cookie
      Form1.ListView1.Items.AddItem(downitem);
      tmpindex:=downitem.Index;
      if cola then
      begin
        queuemanual[strtoint(Form1.ListView1.Items[tmpindex].SubItems[columnqueue])]:=true;
        qtimer[strtoint(Form1.ListView1.Items[tmpindex].SubItems[columnqueue])].Enabled:=true;
      end;
      Form1.TreeView1SelectionChanged(nil);
      if not silent then
        savemydownloads();
      if iniciar or silent then
      begin
        downloadstart(tmpindex,false);
        if Form1.Timer1.Enabled=false then
          Form1.Timer1.Enabled:=true;
      end;
    end;
  end
  else
    Form1.Show;
end;

procedure downtrayicon.showinmain(Sender:TObject);
begin
  Form1.Show;
  Form1.TreeView1.Items[0].Selected:=true;
  Form1.ListView1.MultiSelect:=false;
  Form1.ListView1.Items[self.downindex].Selected:=true;
  Form1.ListView1.MultiSelect:=true;
end;

procedure downtrayicon.contextmenu(Sender:TObject;Boton:TMouseButton;SShift:TShiftState;x:LongInt;y:LongInt);
begin
  numtraydown:=self.downindex;
  if self.downindex<Form1.ListView1.Items.Count then
  begin
    if Form1.ListView1.Items[self.downindex].SubItems[columnstatus]='1' then
    begin
      Form1.MenuItem61.Enabled:=false;
      Form1.MenuItem71.Enabled:=true;
    end
    else
    begin
      Form1.MenuItem61.Enabled:=true;
      Form1.MenuItem71.Enabled:=false;
    end;
  end
  else
  begin
    self.Hide;
    Form1.PopupMenu4.Close;
  end;
end;

end.

