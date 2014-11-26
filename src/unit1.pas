{
   AWGG
   -------------------------------------------------------------------------
   Licence  : GNU GPL v 2.0
   Copyright (C) 2014 Reinier Romero Mir (nenirey@gmail.com)

   Main Dialog window

}
unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, UniqueInstance, Forms,
  Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, Menus, Spin, ComCtrls,
  DateUtils, Process,
  {$IFDEF WINDOWS}Registry, MMSystem,{$ENDIF} Math, Unit2, Unit3, Unit4, Unit5, Unit6, Unit7, Clipbrd, PopupNotifier,
  strutils, LCLType, LCLIntf, types, versionitis, INIFiles, LCLVersion,
  PairSplitter, DefaultTranslator, URIParser;

type
DownThread = class(TThread)
private
  wout:array of string;
  wpr:TStringList;
  wthp:TProcess;
  thid:integer;
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

{type
cntlmthread=class(TThread)
private
  //cout:string;
  cntlmp:TProcess;
  procedure shutdown();
protected
  procedure Execute; override;
  public
    Constructor Create(CreateSuspended:boolean);
end;}

type
soundthread=class(TThread)
private
player:TProcess;
sndfile:string;
protected
  procedure Execute;
  public Constructor Create(CreateSuspended:boolean);
end;

  { TForm1 }

  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    FloatSpinEdit1: TFloatSpinEdit;
    ImageList1: TImageList;
    Label1: TLabel;
    ListView1: TListView;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
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
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    PopupNotifier1: TPopupNotifier;
    SaveDialog1: TSaveDialog;
    SpinEdit1: TSpinEdit;
    Timer1: TTimer;
    Timer2: TTimer;
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
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    TrayIcon1: TTrayIcon;
    UniqueInstance1: TUniqueInstance;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
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
    procedure MenuItem82Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure PairSplitter1ChangeBounds(Sender: TObject);
    procedure PairSplitter1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PairSplitter1Resize(Sender: TObject);
    procedure PopupNotifier1Close(Sender: TObject; var CloseAction: TCloseAction
      );
    procedure Timer1StartTimer(Sender: TObject);
    procedure Timer1StopTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2StartTimer(Sender: TObject);
    procedure Timer2StopTimer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
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
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure TrayIcon1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure UniqueInstance1OtherInstance(Sender: TObject;
      ParamCount: Integer; Parameters: array of String);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  wtp:TProcess;
  onestart:boolean=true;
  hilo:array of DownThread;
  phttp,phttpport,phttps,phttpsport,pftp,pftpport,nphost,puser,ppassword,cntlmhost,cntlmport:string;
  useproxy:integer;
  useaut:boolean;
  starttime,stoptime:TTime;
  startdate,stopdate:TDate;
  allday:boolean;
  shownotifi:boolean;
  hiddenotifi:integer;
  notifipos:integer;
  ddowndir:string;
  clipurl:string;
  clipboardmonitor:boolean;
  columnname,columnurl,columnpercent,columnsize,columncurrent,columnspeed,columnestimate, columndate, columndestiny,columnengine,columnparameters,columnuser,columnpass,columnstatus,columnid, columntries, columnuid:integer;
  columncolaw,columnnamew,columnurlw,columnpercentw,columnsizew,columncurrentw,columnspeedw,columnestimatew,columndatew,columndestinyw,columnenginew,columnparametersw:integer;
  columncolav,columnnamev,columnurlv,columnpercentv,columnsizev,columncurrentv,columnspeedv,columnestimatev,columndatev,columndestinyv,columnenginev,columnparametersv:boolean;
  limited:boolean;
  speedlimit:string;
  maxgdown,dtries,dtimeout,ddelay:integer;
  showstdout:boolean;
  wgetrutebin,aria2crutebin,curlrutebin,axelrutebin,cntlmrutebin:string;
  wgetargs,aria2cargs,curlargs,axelargs,cntlmargs:ansistring;
  wgetdefcontinue,wgetdefnh,wgetdefnd,wgetdefncert:boolean;
  aria2cdefcontinue,aria2cdefallocate:boolean;
  curldefcontinue:boolean;
  autostartwithsystem,autostartshedules,autostartminimized:boolean;
  {$IFDEF WINDOWS}
  registro:TRegistry;
  {$ENDIF}
  configpath,datapath:string;
  domingo,lunes,martes,miercoles,jueves,viernes,sabado:boolean;
  logger:boolean;
  logpath:string;
  showgridlines,showcommandout:boolean;
  splitpos:integer;
  lastmainwindowstate:TWindowstate;
  firsttime:boolean;
  colamanual:boolean;
  {cntlmp:TProcess;
  hilocntlm:cntlmthread;
  cntlmrunning:boolean;}
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
  queuestop:boolean;
  sameproxyforall:boolean;
  function urlexists(url:string):boolean;
  function destinyexists(destiny:string):boolean;
  procedure playsound(soundfile:string);
implementation
{$R *.lfm}
{ TForm1 }
procedure titlegen();
begin
  {$IFDEF alpha}
  Form1.Caption:='AWGG '+Copy(version,0,LastDelimiter('.',version)-1)+' ALPHA BUILD '+Copy(version,LastDelimiter('.',version)+1,Length(version));
  {$ENDIF}
  {$IFDEF beta}
  Form1.Caption:='AWGG '+Copy(version,0,LastDelimiter('.',version)-1)+' BETA';
  {$ENDIF}
  {$IFDEF release}
  Form1.Caption:='AWGG '+Copy(version,0,LastDelimiter('.',version)-1);
  {$ENDIF}
end;
function uidexists(uid:string):boolean;
var n:integer;
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
var tmpuid:integer;
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

procedure stopqueue();
var n:integer;
begin
Form1.Timer2.Enabled:=false;
for n:=0 to Form1.ListView1.Items.Count-1 do
begin
if (Form1.ListView1.Items[n].Checked) and (Form1.ListView1.Items[n].SubItems[columnstatus]='1') then
hilo[strtoint(Form1.ListView1.Items[n].SubItems[columnid])].shutdown();
end;
end;

function urlexists(url:string):boolean;
var ni:integer;
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
var ni:integer;
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

{procedure cntlmthread.Execute;
var wrn:integer;
    //msg:ansistring;
begin
if FileExists(cntlmrutebin) then
begin
cntlmp.Executable:=cntlmrutebin;
cntlmp.Options:=[poUsePipes,poStderrToOutPut,poNoConsole];
////Parametros generales
if WordCount(cntlmargs,[' '])>0 then
        begin
        for wrn:=1 to WordCount(cntlmargs,[' ']) do
        cntlmp.Parameters.Add(ExtractWord(wrn,cntlmargs,[' ']));
        end;
cntlmp.Parameters.Add('-fl');//No deamon and listen host port
cntlmp.Parameters.Add(cntlmhost+':'+cntlmport);
cntlmp.Parameters.Add('-u');
cntlmp.Parameters.Add(puser);
cntlmp.Parameters.Add('-p');
cntlmp.Parameters.Add(ppassword);
cntlmp.Parameters.Add(phttp+':'+phttpport);
cntlmp.Execute;
cntlmrunning:=true;
while cntlmp.Running do
     begin
     sleep(1000);
     end;
cntlmp.Free;
cntlmrunning:=false;
end;
end;

constructor cntlmthread.Create(CreateSuspended:boolean);
begin
cntlmrunning:=false;
FreeOnTerminate:=True;
inherited Create(CreateSuspended);
cntlmp:=TProcess.Create(nil)
end;

procedure cntlmthread.shutdown;
begin
cntlmp.Terminate(0);
end;
}

constructor soundthread.Create(CreateSuspended:boolean);
begin
inherited Create(CreateSuspended);
player:=TProcess.Create(nil);
sndfile:='';
end;

procedure soundthread.Execute;
var engine:string;
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
end;

{procedure runcntlm();
begin
if not cntlmrunning then
begin
hilocntlm:=cntlmthread.Create(true);
hilocntlm.Start;
end;
end;}

procedure playsound(soundfile:string);
begin

{$IFDEF WINDOWS}
sndPlaySound(pchar(UTF8ToSys(soundfile)), snd_Async or snd_NoDefault);
{$ELSE}
hilosnd:=soundthread.Create(true);
hilosnd.sndfile:=soundfile;
hilosnd.Execute;
{$ENDIF}

end;

procedure rebuildids();
var x:integer;
begin
for x:=0 to Form1.ListView1.Items.Count-1 do
    begin
    if Form1.ListView1.Items[x].SubItems[columnstatus]='1' then
    hilo[strtoint(Form1.ListView1.Items[x].SubItems[columnid])].thid:=x;
    end;
end;
procedure updatelangstatus();
var x:integer;
begin
for x:=0 to Form1.ListView1.Items.Count-1 do
    begin
    case Form1.ListView1.Items[x].SubItems[columnstatus] of
    '0':Form1.ListView1.Items[x].Caption:=rsForm.statuspaused.Caption;
    '1':Form1.ListView1.Items[x].Caption:=rsForm.statusinprogres.Caption;
    '2':Form1.ListView1.Items[x].Caption:=rsForm.statusstoped.Caption;
    '3':Form1.ListView1.Items[x].Caption:=rsForm.statuscomplete.Caption;
    end;
    end;
end;

procedure enginereload();
begin
Form2.ComboBox1.Items.Clear;
Form3.ComboBox3.Items.Clear;
if (FileExists(aria2crutebin)) then
begin
Form2.ComboBox1.Items.Add('aria2c');
Form3.ComboBox3.Items.Add('aria2c');
end;
if (FileExists(axelrutebin)) then
begin
Form2.ComboBox1.Items.Add('axel');
Form3.ComboBox3.Items.Add('axel');
end;
if (FileExists(curlrutebin)) then
begin
Form2.ComboBox1.Items.Add('curl');
Form3.ComboBox3.Items.Add('curl');
end;
if (FileExists(wgetrutebin)) then
begin
Form2.ComboBox1.Items.Add('wget');
Form3.ComboBox3.Items.Add('wget');
end;
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
var soutput:TStringList;
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
var iniconfigfile:TMEMINIFile;
begin
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
showcommandout:=Form1.Memo1.Visible;
if showcommandout then
splitpos:=Form1.PairSplitter1.Position;
try
iniconfigfile:=TMEMINIFile.Create(configpath+'awgg.ini');
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
iniconfigfile.WriteBool('Config','allday',allday);
iniconfigfile.WriteDate('Config','startdate',startdate);
iniconfigfile.WriteTime('Config','starttime',starttime);
iniconfigfile.WriteDate('Config','stopdate',stopdate);
iniconfigfile.WriteTime('Config','stoptime',stoptime);
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
//iniconfigfile.WriteString('Config','cntlmrutebin',cntlmrutebin);
iniconfigfile.WriteString('Config','wgetargs',wgetargs);
iniconfigfile.WriteString('Config','aria2cargs',aria2cargs);
iniconfigfile.WriteString('Config','curlargs',curlargs);
iniconfigfile.WriteString('Config','axelargs',axelargs);
//iniconfigfile.WriteString('Config','cntlmargs',cntlmargs);
iniconfigfile.WriteBool('Config','wgetdefcontinue',wgetdefcontinue);
iniconfigfile.WriteBool('Config','wgetdefnh',wgetdefnh);
iniconfigfile.WriteBool('Config','wgetdefnd',wgetdefnd);
iniconfigfile.WriteBool('Config','wgetdefncert',wgetdefncert);
iniconfigfile.WriteBool('Config','aria2cdefcontinue',aria2cdefcontinue);
iniconfigfile.WriteBool('Config','aria2cdefallocate',aria2cdefallocate);
iniconfigfile.WriteBool('Config','curldefcontinue',curldefcontinue);
iniconfigfile.WriteBool('Config','autostartwithsystem',autostartwithsystem);
iniconfigfile.WriteBool('Config','autostartshedules',autostartshedules);
iniconfigfile.WriteBool('Config','autostartminimized',autostartminimized);
iniconfigfile.WriteBool('Config','domingo',domingo);
iniconfigfile.WriteBool('Config','lunes',lunes);
iniconfigfile.WriteBool('Config','martes',martes);
iniconfigfile.WriteBool('Config','miercoles',miercoles);
iniconfigfile.WriteBool('Config','jueves',jueves);
iniconfigfile.WriteBool('Config','viernes',viernes);
iniconfigfile.WriteBool('Config','sabado',sabado);
iniconfigfile.WriteBool('Config','logger',logger);
iniconfigfile.WriteString('Config','logpath',logpath);
iniconfigfile.WriteBool('Config','showgridlines',showgridlines);
iniconfigfile.WriteBool('Config','showcommandout',showcommandout);
iniconfigfile.WriteInteger('Config','notifipos',notifipos);
iniconfigfile.WriteInteger('Config','splitpos',splitpos);
case lastmainwindowstate of
wsNormal:iniconfigfile.WriteString('Config','lastmainwindowstate','wsNormal');
wsMaximized:iniconfigfile.WriteString('Config','lastmainwindowstate','wsMaximized');
end;
iniconfigfile.WriteInteger('Config','dtries',dtries);
iniconfigfile.WriteInteger('Config','dtimeout',dtimeout);
iniconfigfile.WriteInteger('Config','ddelay',ddelay);
//iniconfigfile.WriteString('Config','cntlmhost',cntlmhost);
//iniconfigfile.WriteString('Config','cntlmport',cntlmport);
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
iniconfigfile.WriteBool('Config','queuestop',queuestop);
iniconfigfile.WriteBool('Config','sameproxyforall',sameproxyforall);
iniconfigfile.UpdateFile;
iniconfigfile.Free;
autostart();
except on e:exception do
ShowMessage(rsForm.msgerrorconfigsave.caption+e.ToString);
end;
end;
procedure loadconfig();
var iniconfigfile:TINIFile;
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
allday:=iniconfigfile.ReadBool('Config','allday',false);
startdate:=iniconfigfile.ReadDate('Config','startdate',date());
starttime:=iniconfigfile.ReadTime('Config','starttime',time());
stopdate:=iniconfigfile.ReadDate('Config','stopdate',date());
stoptime:=iniconfigfile.ReadTime('Config','stoptime',time());
shownotifi:=iniconfigfile.ReadBool('Config','shownotifi',true);
hiddenotifi:=iniconfigfile.ReadInteger('Config','hiddenotifi',5);
clipboardmonitor:=iniconfigfile.ReadBool('Config','clipboardmonitor',true);
ddowndir:=iniconfigfile.ReadString('Config','ddowndir',ddowndir);
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
columndatev:=iniconfigfile.ReadBool('Config','columndatev',true);
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
//cntlmrutebin:=iniconfigfile.ReadString('Config','cntlmrutebin',cntlmrutebin);
wgetargs:=iniconfigfile.ReadString('Config','wgetargs',wgetargs);
aria2cargs:=iniconfigfile.ReadString('Config','aria2cargs',aria2cargs);
curlargs:=iniconfigfile.ReadString('Config','curlargs',curlargs);
axelargs:=iniconfigfile.ReadString('Config','axelargs',axelargs);
//cntlmargs:=iniconfigfile.ReadString('Config','cntlmargs',cntlmargs);
wgetdefcontinue:=iniconfigfile.ReadBool('Config','wgetdefcontinue',true);
wgetdefnh:=iniconfigfile.ReadBool('Config','wgetdefnh',true);
wgetdefnd:=iniconfigfile.ReadBool('Config','wgetdefnd',true);
wgetdefncert:=iniconfigfile.ReadBool('Config','wgetdefncert',true);
aria2cdefcontinue:=iniconfigfile.ReadBool('Config','aria2cdefcontinue',true);
aria2cdefallocate:=iniconfigfile.ReadBool('Config','aria2cdefallocate',true);
curldefcontinue:=iniconfigfile.ReadBool('Config','curldefcontinue',true);
autostartwithsystem:=iniconfigfile.ReadBool('Config','autostartwithsystem',false);
autostartshedules:=iniconfigfile.ReadBool('Config','autostartshedules',false);
autostartminimized:=iniconfigfile.ReadBool('Config','autostartminimized',false);
domingo:=iniconfigfile.ReadBool('Config','domingo',false);
lunes:=iniconfigfile.ReadBool('Config','lunes',false);
martes:=iniconfigfile.ReadBool('Config','martes',false);
miercoles:=iniconfigfile.ReadBool('Config','miercoles',false);
jueves:=iniconfigfile.ReadBool('Config','jueves',false);
viernes:=iniconfigfile.ReadBool('Config','viernes',false);
sabado:=iniconfigfile.ReadBool('Config','sabado',false);
logger:=iniconfigfile.ReadBool('Config','logger',true);
logpath:=iniconfigfile.ReadString('Config','logpath',ddowndir+pathdelim+'logs');
showgridlines:=iniconfigfile.ReadBool('Config','showgridlines',false);
showcommandout:=iniconfigfile.ReadBool('Config','showcommandout',false);
notifipos:=iniconfigfile.ReadInteger('Config','notifipos',2);
splitpos:=iniconfigfile.ReadInteger('Config','splitpos',270);
case iniconfigfile.ReadString('Config','lastmainwindowstate','wsNormal') of
'wsNormal':lastmainwindowstate:=wsNormal;
'wsMaximized':lastmainwindowstate:=wsMaximized;
end;
dtries:=iniconfigfile.ReadInteger('Config','dtries',10);
dtimeout:=iniconfigfile.ReadInteger('Config','dtimeout',10);
ddelay:=iniconfigfile.ReadInteger('Config','ddelay',5);
//cntlmhost:=iniconfigfile.ReadString('Config','cntlmhost','127.0.0.1');
//cntlmport:=iniconfigfile.ReadString('Config','cntlmport','8080');
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
queuestop:=iniconfigfile.ReadBool('Config','queuestop',false);
sameproxyforall:=iniconfigfile.ReadBool('Config','sameproxyforall',false);
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
Form1.CheckBox1.Checked:=limited;
Form1.FloatSpinEdit1.Value:=strtofloat(speedlimit);
Form1.SpinEdit1.Value:=maxgdown;
Form1.MenuItem53.Checked:=showstdout;
Form1.Memo1.Visible:=showcommandout;
Form1.MenuItem53.Checked:=showcommandout;
Form1.MenuItem53.Enabled:=showcommandout;
Form1.MenuItem33.Checked:=showcommandout;
Form1.MenuItem25.Checked:=showgridlines;
Form1.Timer4.Enabled:=clipboardmonitor;
   if splitpos<20 then
   splitpos:=20;
   if splitpos>Form1.PairSplitter1.Height-20 then
   splitpos:=splitpos-20;
if showstdout then
Form1.PairSplitter1.Position:=splitpos
else
Form1.PairSplitter1.Position:=Form1.PairSplitter1.Height;
{$IFDEF UNIX}
if not FileExists(wgetrutebin) then
wgetrutebin:='/usr/bin/wget';
if not FileExists(wgetrutebin) then
wgetrutebin:=ExtractFilePath(Application.Params[0])+'wget';
if not FileExists(aria2crutebin) then
aria2crutebin:='/usr/bin/aria2c';
if not FileExists(aria2crutebin) then
aria2crutebin:=ExtractFilePath(Application.Params[0])+'aria2c';
if not FileExists(curlrutebin) then
curlrutebin:='/usr/bin/curl';
if not FileExists(curlrutebin) then
curlrutebin:=ExtractFilePath(Application.Params[0])+'curl';
if not FileExists(axelrutebin) then
axelrutebin:='/usr/bin/axel';
if not FileExists(axelrutebin) then
axelrutebin:=ExtractFilePath(Application.Params[0])+'axel';
//if not FileExists(cntlmrutebin) then
//cntlmrutebin:='/usr/bin/cntlm';
//if not FileExists(cntlmrutebin) then
//cntlmrutebin:=ExtractFilePath(Application.Params[0])+'cntlm';
{$ENDIF}
{$IFDEF WINDOWS}
if not FileExists(wgetrutebin) then
wgetrutebin:=ExtractFilePath(Application.Params[0])+'wget.exe';
if not FileExists(aria2crutebin) then
aria2crutebin:=ExtractFilePath(Application.Params[0])+'aria2c.exe';
if not FileExists(curlrutebin) then
curlrutebin:=ExtractFilePath(Application.Params[0])+'curl.exe';
if not FileExists(axelrutebin) then
axelrutebin:=ExtractFilePath(Application.Params[0])+'axel.exe';
//if not FileExists(cntlmrutebin) then
//cntlmrutebin:=ExtractFilePath(Application.Params[0])+'cntlm.exe';
{$ENDIF}
Form1.Timer1.Enabled:=autostartshedules;
if not DirectoryExists(ddowndir) then
CreateDir(ddowndir);
Form1.Timer4.Enabled:=clipboardmonitor;
except on e:exception do
//ShowMessage(e.Message);
end;
end;

procedure configdlg();
var itemfile:TSearchRec;
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
  Form3.CheckBox3.Checked:=allday;
  Form3.CheckBox6.Checked:=clipboardmonitor;
  Form3.DirectoryEdit1.Text:=ddowndir;
  Form3.CheckBox11.Checked:=autostartshedules;
  if allday then
  begin
    Form3.DateEdit1.Enabled:=false;
    Form3.DateEdit2.Enabled:=false;
    Form3.Label36.Enabled:=false;
    Form3.CheckGroup5.Enabled:=true;
  end
  else
  begin
    Form3.DateEdit1.Enabled:=true;
    Form3.DateEdit2.Enabled:=true;
    Form3.Label36.Enabled:=true;
    Form3.CheckGroup5.Enabled:=false;
  end;
  Form3.SpinEdit6.Value:=HourOf(starttime);
  Form3.SpinEdit7.Value:=MinuteOf(starttime);
  Form3.SpinEdit8.Value:=HourOf(stoptime);
  Form3.SpinEdit9.Value:=MinuteOf(stoptime);
  Form3.DateEdit1.Date:=startdate;
  Form3.DateEdit2.Date:=stopdate;
  Form3.CheckBox4.Checked:=shownotifi;
  Form3.SpinEdit4.Value:=hiddenotifi;
  Form3.FiLeNameEdit1.Text:=wgetrutebin;
  Form3.FiLeNameEdit2.Text:=aria2crutebin;
  Form3.FiLeNameEdit3.Text:=curlrutebin;
  Form3.FileNameEdit4.Text:=axelrutebin;
  //Form3.FileNameEdit5.Text:=cntlmrutebin;
  //Form3.Edit12.Text:=cntlmhost;
  //Form3.SpinEdit5.Value:=strtoint(cntlmport);
  Form3.Edit7.Text:=wgetargs;
  Form3.Edit8.Text:=aria2cargs;
  Form3.Edit9.Text:=curlargs;
  Form3.Edit10.Text:=axelargs;
  //Form3.Edit11.Text:=cntlmargs;
  Form3.CheckGroup1.Checked[0]:=wgetdefcontinue;
  Form3.CheckGroup1.Checked[1]:=wgetdefnh;
  Form3.CheckGroup1.Checked[2]:=wgetdefnd;
  Form3.CheckGroup1.Checked[3]:=wgetdefncert;
  Form3.CheckGroup2.Checked[0]:=aria2cdefcontinue;
  Form3.CheckGroup2.Checked[1]:=aria2cdefallocate;
  Form3.CheckGroup3.Checked[0]:=curldefcontinue;
  Form3.CheckGroup4.Checked[0]:=autostartwithsystem;
  Form3.CheckGroup4.Checked[1]:=autostartminimized;
   Form3.CheckGroup5.Checked[0]:=domingo;
  Form3.CheckGroup5.Checked[1]:=lunes;
  Form3.CheckGroup5.Checked[2]:=martes;
  Form3.CheckGroup5.Checked[3]:=miercoles;
  Form3.CheckGroup5.Checked[4]:=jueves;
  Form3.CheckGroup5.Checked[5]:=viernes;
  Form3.CheckGroup5.Checked[6]:=sabado;
  Form3.Checkbox1.Checked:=logger;
  Form3.DirectoryEdit2.Text:=logpath;
  Form3.RadioGroup1.ItemIndex:=notifipos;
  Form3.SpinEdit10.Value:=dtimeout;
  Form3.SpinEdit11.Value:=dtries;
  Form3.SpinEdit12.Value:=ddelay;
  Case useproxy of
          0,1:begin
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
          2,3:begin
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
Form3.ComboBox2.Items.Clear;
if FindFirst(ExtractFilePath(Application.Params[0])+pathdelim+'languages'+pathdelim+'awgg.*.po',faAnyFile,itemfile)=0 then
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
Form3.CheckBox8.Checked:=sheduledisablelimits;
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
Form3.CheckBox10.Checked:=queuestop;
Form3.SpinEdit8.Enabled:=queuestop;
Form3.SpinEdit9.Enabled:=queuestop;
Form3.DateEdit2.Enabled:=queuestop;
Form3.CheckBox5.Checked:=sameproxyforall;
  except on e:exception do
  ShowMessage(e.Message);
  end;
  Form3.ShowModal;
  if setconfig then
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
  autostartshedules:=Form3.CheckBox11.Checked;
  allday:=Form3.CheckBox3.Checked;
  starttime:=strtotime(inttostr(Form3.SpinEdit6.Value)+':'+inttostr(Form3.SpinEdit7.Value)+':00');
  stoptime:=strtotime(inttostr(Form3.SpinEdit8.Value)+':'+inttostr(Form3.SpinEdit9.Value)+':00');
  startdate:=Form3.DateEdit1.Date;
  stopdate:=Form3.DateEdit2.Date;
  shownotifi:=Form3.CheckBox4.Checked;
  hiddenotifi:=Form3.SpinEdit4.Value;
  clipboardmonitor:=Form3.CheckBox6.Checked;
  Form1.Timer4.Enabled:=clipboardmonitor;
  ddowndir:=Form3.DirectoryEdit1.Text;
  wgetrutebin:=Form3.FiLeNameEdit1.Text;
  aria2crutebin:=Form3.FiLeNameEdit2.Text;
  curlrutebin:=Form3.FiLeNameEdit3.Text;
  axelrutebin:=Form3.FileNameEdit4.Text;
  //cntlmrutebin:=Form3.FileNameEdit5.Text;
  wgetargs:=Form3.Edit7.Text;
  aria2cargs:=Form3.Edit8.Text;
  curlargs:=Form3.Edit9.Text;
  axelargs:=Form3.Edit10.Text;
  //cntlmargs:=Form3.Edit11.Text;
  //cntlmhost:=Form3.Edit12.Text;
  //cntlmport:=inttostr(Form3.SpinEdit5.Value);
  wgetdefcontinue:=Form3.CheckGroup1.Checked[0];
  wgetdefnh:=Form3.CheckGroup1.Checked[1];
  wgetdefnd:=Form3.CheckGroup1.Checked[2];
  wgetdefncert:=Form3.CheckGroup1.Checked[3];
  aria2cdefcontinue:=Form3.CheckGroup2.Checked[0];
  aria2cdefallocate:=Form3.CheckGroup2.Checked[1];
  curldefcontinue:=Form3.CheckGroup3.Checked[0];
  autostartwithsystem:=Form3.CheckGroup4.Checked[0];
  autostartminimized:=Form3.CheckGroup4.Checked[1];
  domingo:=Form3.CheckGroup5.Checked[0];
  lunes:=Form3.CheckGroup5.Checked[1];
  martes:=Form3.CheckGroup5.Checked[2];
  miercoles:=Form3.CheckGroup5.Checked[3];
  jueves:=Form3.CheckGroup5.Checked[4];
  viernes:=Form3.CheckGroup5.Checked[5];
  sabado:=Form3.CheckGroup5.Checked[6];
  logger:=Form3.Checkbox1.Checked;
  logpath:=Form3.DirectoryEdit2.Text;
  notifipos:=Form3.RadioGroup1.ItemIndex;
  dtimeout:=Form3.SpinEdit10.Value;
  dtries:=Form3.SpinEdit11.Value;
  ddelay:=Form3.SpinEdit12.Value;
  deflanguage:=Form3.ComboBox2.Text;
  defaultengine:=Form3.ComboBox3.Text;
  playsounds:=Form3.CheckBox7.Checked;
  sheduledisablelimits:=Form3.CheckBox8.Checked;
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
queuestop:=Form3.CheckBox10.Checked;
sameproxyforall:=Form3.CheckBox5.Checked;
  {if useproxy=3 then
  runcntlm()
  else
  begin
  if cntlmrunning then
  hilocntlm.shutdown();
  end;}
  SetDefaultLang(deflanguage);
  updatelangstatus();
  titlegen();
  saveconfig();
  end;
Form1.Timer1.Enabled:=autostartshedules;
end;

procedure startsheduletimer();
begin
if autostartshedules then
Form1.Timer1.Enabled:=true
else
begin
Form3.PageControl1.ActivePageIndex:=1;
Form3.TreeView1.Items[Form3.PageControl1.ActivePageIndex].Selected:=true;
configdlg();
end;
end;

procedure stopall(force:boolean);
var i:integer;
begin
Form1.Timer1.Enabled:=false;
Form1.Timer2.Enabled:=false;
Form1.Timer3.Enabled:=false;
Form1.Timer4.Enabled:=false;
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
var tmps,wgetc,aria2cc,curlc:TStringList;
    uandp:string;
    wrn:integer;
    thnum:integer;
    downid:integer;
begin
if indice<>-1 then
begin
if Form1.ListView1.Items[indice].SubItems[columnstatus]<>'1' then
begin
if DirectoryExists(Form1.ListView1.Items[indice].SubItems[columndestiny]) then
begin
tmps:=TstringList.Create;
if Form1.ListView1.Items[indice].SubItems[columnengine]='wget' then
begin
////USAR un archivo de configuracion limpio
{$IFDEF UNIX}
try
if FileExists(configpath+'.wgetrc')=false then
begin
wgetc:=TStringList.Create;
wgetc.Add('#This is a WGET config file created by AWGG, please not change it.');
wgetc.Add('passive_ftp = on');
wgetc.Add('recursive = off');
wgetc.SaveToFile(configpath+'.wgetrc');
end;
tmps.Add('--config='+ExtractShortPathName(configpath)+'.wgetrc');
except on e:exception do
end;
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
{3:begin
tmps.Add('-e');
tmps.Add('http_proxy=http://'+Copy(puser,0,Pos('@',puser)-1)+':'+ppassword+'@'+cntlmhost+':'+cntlmport+'/');
tmps.Add('-e');
tmps.Add('https_proxy=http://'+Copy(puser,0,Pos('@',puser)-1)+':'+ppassword+'@'+cntlmhost+':'+cntlmport+'/');
tmps.Add('-e');
tmps.Add('ftp_proxy=http://'+Copy(puser,0,Pos('@',puser)-1)+':'+ppassword+'@'+cntlmhost+':'+cntlmport+'/');
if nphost<>'' then
begin
tmps.Add('-e');
tmps.Add('no_proxy="'+nphost+'"');
end;
end;}
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
tmps.Add(ExtractShortPathName(Form1.ListView1.Items[indice].SubItems[columndestiny]));
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
if FileExists(Form1.ListView1.Items[indice].SubItems[columnurl]) then
tmps.Add('-i');//Fichero de entrada
tmps.Add(Form1.ListView1.Items[indice].SubItems[columnurl]);
end;
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
////Parametros para cada descarga
if WordCount(Form1.ListView1.Items[indice].SubItems[columnparameters],[' '])>0 then
        begin
        for wrn:=1 to WordCount(Form1.ListView1.Items[indice].SubItems[columnparameters],[' ']) do
        tmps.Add(ExtractWord(wrn,Form1.ListView1.Items[indice].SubItems[columnparameters],[' ']));
        end;
tmps.Add('--check-certificate=false');//Ignorar certificados
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
{3:begin
if nphost<>'' then
tmps.Add('--no-proxy="'+nphost+'"');
tmps.Add('--http-proxy='+cntlmhost+':'+cntlmport);
tmps.Add('--https-proxy='+cntlmhost+':'+cntlmport);
tmps.Add('--ftp-proxy='+cntlmhost+':'+cntlmport);
end;}
end;
tmps.Add('-d');
tmps.Add(ExtractShortPathName(Form1.ListView1.Items[indice].SubItems[columndestiny]));
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
tmps.Add(Form1.ListView1.Items[indice].SubItems[columnurl]);
end;
if Form1.ListView1.Items[indice].SubItems[columnengine] = 'curl' then
begin
//Usar un archivo de configuracion limpio
try
if FileExists(configpath+'curl.conf')=false then
begin
curlc:=TStringList.Create;
curlc.Add('#This is a cURL config file created by AWGG, please not change it.');
curlc.SaveToFile(configpath+'curl.conf');
tmps.Add('-config');
end;
tmps.Add(ExtractShortPathName(configpath)+'curl.conf');
except on e:exception do
end;
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
tmps.Add(UTF8ToSys(Form1.ListView1.Items[indice].SubItems[columnname]));
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
0:begin
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
{3:begin
tmps.Add('--proxy1.0');
tmps.Add(cntlmhost+':'+cntlmport);
if nphost<>'' then
begin
tmps.Add('--noproxy');
tmps.Add('"'+nphost+'"');
end;
end;}
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
tmps.Add(Form1.ListView1.Items[indice].SubItems[columnurl]);
end;
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
Form1.ListView1.Items[indice].SubItems[columnstatus]:='1';
Form1.ListView1.Items[indice].Caption:=rsForm.statusinprogres.Caption;
Form1.ListView1.Items[indice].ImageIndex:=2;
downid:=strtoint(Form1.ListView1.Items[indice].SubItems[columnid]);
//El tama;o del array de hilos no debe ser menor que el propio id o la catidad de items
if downid>=Form1.ListView1.Items.Count then
thnum:=downid
else
thnum:=Form1.ListView1.Items.Count;
SetLength(hilo,thnum);
hilo[downid]:=DownThread.Create(true,tmps);
SetLength(hilo[downid].wout,thnum);
hilo[downid].thid:=indice;
if Assigned(hilo[downid].FatalException) then
    raise hilo[downid].FatalException;
hilo[downid].Start;
tmps.Free;
Form1.ToolButton3.Enabled:=false;
Form1.ToolButton4.Enabled:=true;
Form1.ToolButton22.Enabled:=false;
end
else
begin
Form1.Memo1.Lines.Add(rsForm.msgnoexistfolder.Caption+Form1.ListView1.Items[indice].SubItems[columndestiny]);
Form1.ListView1.Items[indice].Checked:=false;
end;
end;
end
else
Form1.Memo1.Lines.Add(rsForm.msgmustselectdownload.Caption);
end;

procedure restartdownload(indice:integer;ahora:boolean);
begin
  if FileExists(Form1.ListView1.Items[indice].SubItems[columndestiny]+pathdelim+UTF8ToSys(Form1.ListView1.Items[indice].SubItems[columnname])) then
  DeleteFile(Form1.ListView1.Items[indice].SubItems[columndestiny]+pathdelim+UTF8ToSys(Form1.ListView1.Items[indice].SubItems[columnname]));

  if (Form1.ListView1.Items[indice].SubItems[columnengine]='aria2c') and (FileExists(Form1.ListView1.Items[indice].SubItems[columndestiny]+pathdelim+UTF8ToSys(Form1.ListView1.Items[indice].SubItems[columnname])+'.aria2')) then
  DeleteFile(Form1.ListView1.Items[indice].SubItems[columndestiny]+pathdelim+UTF8ToSys(Form1.ListView1.Items[indice].SubItems[columnname])+'.aria2');

  if (Form1.ListView1.Items[indice].SubItems[columnengine]='axel') and (FileExists(Form1.ListView1.Items[indice].SubItems[columndestiny]+pathdelim+UTF8ToSys(Form1.ListView1.Items[indice].SubItems[columnname])+'.st')) then
  DeleteFile(Form1.ListView1.Items[indice].SubItems[columndestiny]+pathdelim+UTF8ToSys(Form1.ListView1.Items[indice].SubItems[columnname])+'.st');

  if FileExists(datapath+pathdelim+Form1.ListView1.Items[indice].SubItems[columnuid]+'.status') then
  DeleteFile(datapath+pathdelim+Form1.ListView1.Items[indice].SubItems[columnuid]+'.status');

  colamanual:=true;

  Form1.ListView1.Items[indice].ImageIndex:=18;
  Form1.ListView1.Items[indice].Caption:=rsForm.statuspaused.Caption;
  Form1.ListView1.Items[indice].SubItems[columnstatus]:='0';

  if ahora then
  downloadstart(indice,true);
end;

procedure DownThread.update;
var porciento, velocidad, tamano, tiempo, descargado:String;
    //icono:TBitmap;
    statusfile:TextFile;
begin
porciento:='';
velocidad:='';
tamano:='';
tiempo:='';
descargado:='';
if (Form1.ListView1.ItemIndex>-1) and (Form1.MenuItem53.Checked) and (thid=Form1.ListView1.ItemIndex) then
begin
Form1.Memo1.Text:=Form1.Memo1.Text+wout[thid];
Form1.Memo1.SelStart:=Form1.Memo1.GetTextLen;
Form1.Memo1.SelLength:=0;
end;
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
if Pos('% [',wout[thid])>0 then
begin
porciento:=Copy(wout[thid],Pos('% [',wout[thid])-2,3);
velocidad:=Copy(wout[thid],Pos('/s ',wout[thid])-5,7);
descargado:=Copy(wout[thid],Pos('] ',wout[thid])+2,Length(wout[thid]));
descargado:=Copy(descargado,0,Pos(' ',descargado));
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
velocidad:=Copy(wout[thid],Pos('/s ',wout[thid])-5,7);
descargado:=Copy(wout[thid],Pos('] ',wout[thid])+2,Length(wout[thid]));
descargado:=Copy(descargado,0,Pos(' ',descargado));
end;
end;
if Form1.ListView1.Items[thid].SubItems[columnengine] = 'aria2c' then
begin
if Pos('%) ',wout[thid])>0 then
begin
porciento:=Copy(wout[thid],Pos('B(',wout[thid])+2,length(wout[thid]));
porciento:=Copy(porciento,0,Pos('%)',porciento));
velocidad:=Copy(wout[thid],Pos(' SPD:',wout[thid])+5,length(wout[thid]));
velocidad:=Copy(velocidad,0,Pos('Bs ETA:',velocidad)+1);
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
end;
end;
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
{ TODO 2 -oSegator -cinterface : Homogenizar la salida de los deferentes motores de descarga. }
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
end;

//Talvez con un icono independiente por cada descarga
//icono:=TBitmap.Create();
//icono.Width:=Form1.TrayIcon1.Icon.Width;
//icono.Height:=Form1.TrayIcon1.Icon.Height;
//icono.Canvas.Brush.Color:=clWhite;
//icono.Canvas.Pen.Color:=clGreen;
//{$IFDEF UNIX}
//icono.Canvas.Font.Size:=75;
//{$ENDIF}
//{$IFDEF WINDOWS}
//icono.Canvas.Font.Size:=20;
//{$ENDIF}
//icono.Canvas.TextOut(0,0,porcientobandeja);
//Form1.TrayIcon1.Icon.Assign(icono);
//icono.Destroy;
end;
procedure savemydownloads();
var wn:integer;
    inidownloadsfile:TMEMINIFile;
begin
try
if FileExists(configpath+'awgg.dat') then
begin
CopyFile(ExtractShortPathName(configpath)+'awgg.dat',ExtractShortPathName(configpath)+'awgg.dat.bak',[cffOverwriteFile]);
DeleteFile(configpath+'awgg.dat');
end;
inidownloadsfile:=TMEMINIFile.Create(configpath+'awgg.dat');
   for wn:=0 to Form1.ListView1.Items.Count-1 do
   begin
   inidownloadsfile.WriteInteger('Total','value',Form1.ListView1.Items.Count);
   inidownloadsfile.WriteBool('Download'+inttostr(wn),'checked',Form1.ListView1.Items[wn].Checked);
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
   end;
if (Form1.ListView1.Items.Count=0) and inidownloadsfile.SectionExists('Download0') then
begin
inidownloadsfile.EraseSection('Download0');
inidownloadsfile.WriteInteger('Total','value',0);
end;
//*****Quedan restos de las descargas anteriores******
inidownloadsfile.UpdateFile;
inidownloadsfile.Free;
if FileExists(configpath+'awgg.dat.bak') then
DeleteFile(configpath+'awgg.dat.bak');
except on e:exception do
ShowMessage(rsForm.msgerrordownlistsave.Caption+' '+e.Message);
end;
end;

procedure importdownloads();
var urls:TStringList;
    nurl:integer;
    imitem:TListItem;
    fname:string;
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
  imitem:=TListItem.Create(Form1.ListView1.Items);
  imitem.Caption:=rsForm.statuspaused.Caption;
  imitem.ImageIndex:=18;
  fname:=ParseURI(urls[nurl]).Document;
  while destinyexists(ddowndir+pathdelim+fname) do
  fname:='_'+fname;
  imitem.SubItems.Add(fname);//Nombre de archivo
  imitem.SubItems.Add('');//Tama;o
  imitem.SubItems.Add('');//Descargado
  imitem.SubItems.Add(urls[nurl]);//URL
  imitem.SubItems.Add('');//Velocidad
  imitem.SubItems.Add('');//Porciento
  imitem.SubItems.Add('');//Estimado
  imitem.SubItems.Add(datetostr(Date())+' '+timetostr(Time()));//Fecha
  imitem.SubItems.Add(ddowndir);//Destino
  imitem.SubItems.Add(defaultengine);//Motor
  imitem.SubItems.Add('');//Parametros
  imitem.SubItems.Add('0');//status
  imitem.SubItems.Add(inttostr(Form1.ListView1.Items.Count));//id
  imitem.SubItems.Add('');//user
  imitem.SubItems.Add('');//pass
  imitem.SubItems.Add(inttostr(triesrotate));//tries
  imitem.SubItems.Add(uidgen());//uid
  Form1.ListView1.Items.AddItem(imitem);
  end;
end;
urls.Destroy;
end;
savemydownloads();
end;

procedure exportdownloads();
var nurl:integer;
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
var i,total:integer;
begin
if Form1.ListView1.ItemIndex<>-1 then
begin
total:=Form1.ListView1.Items.Count-1;
dlgForm.Caption:=rsForm.dlgconfirm.Caption;
if delfile then
dlgForm.dlgtext.Caption:=rsForm.dlgdeletedownandfile.Caption
else
dlgForm.dlgtext.Caption:=rsForm.dlgdeletedown.Caption;
dlgForm.ShowModal;
if dlgcuestion then
begin
for i:=total downto 0 do
begin
if (Form1.ListView1.Items[i].Selected) and (Form1.ListView1.Items[i].SubItems[columnstatus]<>'1') then
begin
//Borrar tambien el historial de la descarga antes de borrar.
if FileExists(logpath+pathdelim+UTF8ToSys(Form1.ListView1.Items[i].SubItems[columnname])+'.log') then
   DeleteFile(logpath+pathdelim+UTF8ToSys(Form1.ListView1.Items[i].SubItems[columnname])+'.log');
if FileExists(datapath+pathdelim+Form1.ListView1.Items[i].SubItems[columnuid]+'.status') then
   DeleteFile(datapath+pathdelim+Form1.ListView1.Items[i].SubItems[columnuid]+'.status');
if Form1.ListView1.Items[i].SubItems[columnname] <> '' then
begin
if FileExists(Form1.ListView1.Items[i].SubItems[columndestiny]+pathdelim+UTF8ToSys(Form1.ListView1.Items[i].SubItems[columnname])) and delfile then
   DeleteFile(Form1.ListView1.Items[i].SubItems[columndestiny]+pathdelim+UTF8ToSys(Form1.ListView1.Items[i].SubItems[columnname]));
end;
Form1.ListView1.Items.Delete(i);
end;
end;
rebuildids();
savemydownloads();
end;
end
else
ShowMessage(rsForm.msgmustselectdownload.Caption);
end;
procedure DownThread.shutdown;
begin
manualshutdown:=true;
end;

procedure DownThread.Execute;
var CharBuffer: array [0..2047] of char;
    ReadCount: integer;
    logfile:TextFile;
begin
completado:=false;
wthp.Options:=[poUsePipes,poStderrToOutPut,poNoConsole];
Case Form1.ListView1.Items[thid].SubItems[columnengine] of
        'wget':begin
        wthp.Executable:=wgetrutebin;
        end;
        'aria2c':begin
        wthp.Executable:=aria2crutebin;
        end;
        'curl':begin
        wthp.Executable:=curlrutebin;
        end;
        'axel':begin
        wthp.Executable:=axelrutebin;
        end;
end;
wthp.Parameters.AddStrings(wpr);
wpr.Free;
wout[thid]:=#10#13+'Executing: '+wthp.Executable+' '+AnsiReplacestr(wthp.Parameters.Text,LineEnding,' ');
if Not DirectoryExists(datapath) then
CreateDir(datapath);
Synchronize(@update);
wthp.CurrentDirectory:=ExtractShortPathName(Form1.ListView1.Items[thid].SubItems[columndestiny]);
try
wthp.Execute;
try
if logger then
begin
if Not DirectoryExists(logpath) then
CreateDir(logpath);
AssignFile(logfile,logpath+PathDelim+UTF8ToSys(Form1.ListView1.Items[thid].SubItems[columnname])+'.log');
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
           if (Pos('(OK):download',wout[thid])>0) or (Pos('100%[',wout[thid])>0) or (Pos('%AWGG100OK%',wout[thid])>0) or (Pos('[100%]',wout[thid])>0) or (Pos(' guardado [',wout[thid])>0) or (Pos(' saved [',wout[thid])>0) then
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
//Synchronize(@update);
Synchronize(@prepare);
wout[thid]:=LineEnding+datetostr(Date())+' '+timetostr(Time())+' Exit code=['+inttostr(wthp.ExitStatus)+']';
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
var outlines:TStringList;
    cachefile:TextFile;
begin
case Form1.ListView1.Items[thid].SubItems[columnengine] of
        'wget':begin
        case wthp.ExitStatus of
        259,1:completado:=false;
        //0:completado:=true; //Al detener el wget produce el codigo cero tambien
        end;
        end;
        'aria2c':begin
        case wthp.ExitStatus of
        259,1,-1:completado:=false;
        0:completado:=true;
        end;
        end;
        'curl':begin
        case wthp.ExitStatus of
        259,7,18,1:completado:=false;
        0:completado:=true;
        end;
        end;
end;
//Quitar de la cola si se completo
if completado  then
Form1.ListView1.Items[thid].Checked:=false;
if completado then
begin
Form1.ListView1.Items[thid].SubItems[columnstatus]:='3';
Form1.ListView1.Items[thid].Caption:=rsForm.statuscomplete.Caption;
Form1.ListView1.Items[thid].SubItems[columnpercent]:='100%';
Form1.ListView1.Items[thid].SubItems[columnspeed]:='--';
Form1.ListView1.Items[thid].ImageIndex:=4;
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
end
else
begin
Form1.ListView1.Items[thid].SubItems[columnstatus]:='2';
Form1.ListView1.Items[thid].Caption:=rsForm.statusstoped.Caption;
Form1.ListView1.Items[thid].ImageIndex:=3;
Form1.ListView1.Items[thid].SubItems[columnspeed]:='--';
if Form1.ListView1.ItemIndex=thid then
begin
Form1.ToolButton3.Enabled:=true;
Form1.ToolButton4.Enabled:=false;
Form1.ToolButton22.Enabled:=true;
end;
if (shownotifi) and (Form1.Focused=false) then
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
if Form1.ListView1.Items[thid].Checked and Form1.Timer2.Enabled and queuerotate then
begin
if thid<Form1.ListView1.Items.Count-1 then
begin
Form1.ListView1.MultiSelect:=false;
if rotatemode=0 then
Form1.ListView1.Items.Move(thid,thid+1);
if rotatemode=1 then
Form1.ListView1.Items.Move(thid,Form1.ListView1.Items.Count-1);
if rotatemode=2 then
begin
if thid+1<Form1.ListView1.Items.Count-1 then
Form1.ListView1.Items.Move(thid,thid+2)
else
Form1.ListView1.Items.Move(thid,thid+1);
end;
Form1.ListView1.MultiSelect:=true;
rebuildids();
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
{try
if logger then
begin
if Not DirectoryExists(logpath) then
CreateDir(logpath);
AssignFile(cachefile,logpath+PathDelim+UTF8ToSys(Form1.ListView1.Items[thid].SubItems[columnname])+'.cache');
if fileExists(logpath+PathDelim+UTF8ToSys(Form1.ListView1.Items[thid].SubItems[columnname])+'.cache') then
DeleteFile(logpath+PathDelim+UTF8ToSys(Form1.ListView1.Items[thid].SubItems[columnname])+'.cache')
else
ReWrite(cachefile);
end;
Write(cachefile,wout[thid]);
CloseFile(cachefile);
except on e:exception do
end;}
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
var fitem:TListItem;
    inidownloadsfile:TINIFile;
    ns,nt:integer;
    downloadsconfig:string;
    ftext:TStringList;
begin
if FileExists(configpath+'awgg.dat.bak') then
downloadsconfig:=configpath+'awgg.dat.bak'
else
downloadsconfig:=configpath+'awgg.dat';

inidownloadsfile:=TINIFile.Create(downloadsconfig);
if FileExists(configpath+'awgg.dat') then
begin
nt:=inidownloadsfile.ReadInteger('Total','value',0);
for ns:=0 to nt-1 do
begin
try
fitem:=TListItem.Create(Form1.ListView1.Items);
fitem.Checked:=inidownloadsfile.ReadBool('Download'+inttostr(ns),'checked',false);
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
if FileExists(datapath+pathdelim+fitem.SubItems[columnuid]+'.status') then
begin
ftext:=TStringList.Create;
ftext.LoadFromFile(datapath+pathdelim+fitem.SubItems[columnuid]+'.status');
fitem.SubItems[columncurrent]:=ExtractWord(2,ftext.Strings[0],['/']);
fitem.SubItems[columnpercent]:=ExtractWord(3,ftext.Strings[0],['/']);
fitem.SubItems[columnestimate]:=ExtractWord(4,ftext.Strings[0],['/']);
ftext.Destroy;
end;
Form1.ListView1.Items.AddItem(fitem);
except on e:exception do
//ShowMessage('Error loading download list '+e.Message);
end;
end;
inidownloadsfile.Free;
end;
end;
procedure saveandexit();
var enprogreso, confirmar:boolean;
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
  {if cntlmrunning then
  hilocntlm.shutdown();}
  Application.Terminate;
end;
end;


procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  Form1.Visible:=false;
  TrayIcon1.Visible:=true;
  CanClose:=false;
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
{columnnamew:=50;
columnurlw:=50;
columnpercentw:=50;
columnsizew:=50;
columncurrentw:=60;
columnspeedw:=50;
columnestimatew:=50;
columndestinyw:=50;
columnenginew:=50;
columnparametersw:=50;
columncolaw:=100;}
phttpport:='3128';
phttpsport:='3128';
pftpport:='3128';
startdate:=Date();
starttime:=Time();
stopdate:=Date();
stoptime:=Time();
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
ddowndir:=GetUserDir()+'Downloads';
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
{$ENDIF}
{$IFDEF WINDOWS}
if FileExists(ExtractFilePath(Application.Params[0])+'wget.exe') then
wgetrutebin:=ExtractFilePath(Application.Params[0])+'wget.exe';

if FileExists(ExtractFilePath(Application.Params[0])+'aria2c.exe') then
aria2crutebin:=ExtractFilePath(Application.Params[0])+'aria2c.exe';

if FileExists(ExtractFilePath(Application.Params[0])+'curl.exe') then
curlrutebin:=ExtractFilePath(Application.Params[0])+'curl.exe';
if FileExists(ExtractFilePath(Application.Params[0])+'axel.exe') then
axelrutebin:=ExtractFilePath(Application.Params[0])+'axel.exe';
{$ENDIF}
loadmydownloads();
loadconfig();
SetDefaultLang(deflanguage);
titlegen();
{if useproxy=3 then
runcntlm();}
Form1.Timer6.Enabled:=true;
onestart:=false;
if autostartminimized then
begin
Form1.WindowState:=wsMinimized;
Form1.Hide;
end
else
Form1.WindowState:=lastmainwindowstate;
end;

procedure TForm1.FormWindowStateChange(Sender: TObject);
begin
  if Form1.WindowState<>wsMinimized then
  lastmainwindowstate:=Form1.WindowState;
end;

procedure TForm1.ListView1ColumnClick(Sender: TObject; Column: TListColumn);
var n:integer;
begin
for n:=0 to Form1.ListView1.Columns.Count-1 do
begin
//Form1.ListView1.Columns[n].ImageIndex:=-1;
Form1.ListView1.Columns[n].Caption:=AnsiReplaceStr(Form1.ListView1.Columns[n].Caption,'  ٧','');
Form1.ListView1.Columns[n].Caption:=AnsiReplaceStr(Form1.ListView1.Columns[n].Caption,'  ٨','');
end;
if Form1.ListView1.SortDirection=sdAscending then
begin
Form1.ListView1.SortDirection:=sdDescending;
//Column.ImageIndex:=28;
{$IFDEF LCLQT}
{$ELSE}
Column.Caption:=Column.Caption+'  ٧';
{$ENDIF}
end
else
begin
Form1.ListView1.SortDirection:=sdAscending;
//Column.ImageIndex:=29;
{$IFDEF LCLQT}
{$ELSE}
Column.Caption:=Column.Caption+'  ٨';
{$ENDIF}
end;
Form1.ListView1.SortColumn:=column.Index;
Form1.ListView1.SortType:=stText;
rebuildids();
end;


procedure TForm1.ListView1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
if Form1.ListView1.ItemIndex<>-1 then
begin
case Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnstatus] of
 '0':begin
 Form1.MenuItem27.Enabled:=true;
 Form1.MenuItem28.Enabled:=false;
 Form1.MenuItem29.Enabled:=true;
 Form1.MenuItem48.Enabled:=true;
 Form1.MenuItem58.Enabled:=true;
 Form1.MenuItem13.Enabled:=true;
 Form1.MenuItem11.Enabled:=true;
 end;
 '1':begin
 Form1.MenuItem27.Enabled:=false;
 Form1.MenuItem28.Enabled:=true;
 Form1.MenuItem29.Enabled:=false;
 Form1.MenuItem48.Enabled:=false;
 Form1.MenuItem58.Enabled:=false;
 Form1.MenuItem13.Enabled:=false;
 Form1.MenuItem11.Enabled:=false;
 end;
 '2':begin
 Form1.MenuItem27.Enabled:=true;
 Form1.MenuItem28.Enabled:=false;
 Form1.MenuItem29.Enabled:=true;
 Form1.MenuItem48.Enabled:=true;
 Form1.MenuItem58.Enabled:=true;
 Form1.MenuItem13.Enabled:=true;
 Form1.MenuItem11.Enabled:=true;
 end;
 '3':begin
 Form1.MenuItem27.Enabled:=true;
 Form1.MenuItem28.Enabled:=false;
 Form1.MenuItem29.Enabled:=true;
 Form1.MenuItem48.Enabled:=true;
 Form1.MenuItem58.Enabled:=true;
 Form1.MenuItem13.Enabled:=true;
 Form1.MenuItem11.Enabled:=true;
 end;
 end;
Form1.PopupMenu2.PopUp;
end;
end;
procedure TForm1.ListView1DblClick(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  begin
  if (Form1.ListView1.ItemFocused.SubItems[columnstatus]='') or (Form1.ListView1.ItemFocused.SubItems[columnstatus]='2') or (Form1.ListView1.ItemFocused.SubItems[columnstatus]='3') or (Form1.ListView1.ItemFocused.SubItems[columnstatus]='0') then
  begin
  colamanual:=true;
  downloadstart(Form1.ListView1.ItemIndex,false);
  end
  else
  begin
  Form1.ListView1.ItemFocused.Checked:=false;
  hilo[Form1.ListView1.ItemIndex].shutdown();
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
  46,109:begin
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
var //logfile:TextFile;
    //tmpstr,tmpstr2:string;
    //nl,ni:integer;
    lastlines:TStringList;
begin
//tmpstr:='';
//tmpstr2:='';
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
  Form1.Memo1.Lines.Clear;
  {if FileExists(logpath+pathdelim+UTF8ToSys(Form1.Listview1.Items[Form1.ListView1.ItemIndex].SubItems[columnname])+'.log') and (Form1.Memo1.Visible) then
  begin
  try
  lastlines:=TStringList.Create;
  lastlines.LoadFromFile(logpath+pathdelim+UTF8ToSys(Form1.Listview1.Items[Form1.ListView1.ItemIndex].SubItems[columnname])+'.log');
  if lastlines.Count>=20 then
  begin
  Form1.Memo1.Lines.Add(lastlines[lastlines.Count-19]);
  Form1.Memo1.Lines.Add(lastlines[lastlines.Count-18]);
  Form1.Memo1.Lines.Add(lastlines[lastlines.Count-17]);
  Form1.Memo1.Lines.Add(lastlines[lastlines.Count-16]);
  Form1.Memo1.Lines.Add(lastlines[lastlines.Count-15]);
  Form1.Memo1.Lines.Add(lastlines[lastlines.Count-14]);
  Form1.Memo1.Lines.Add(lastlines[lastlines.Count-13]);
  Form1.Memo1.Lines.Add(lastlines[lastlines.Count-12]);
  Form1.Memo1.Lines.Add(lastlines[lastlines.Count-11]);
  Form1.Memo1.Lines.Add(lastlines[lastlines.Count-10]);
  Form1.Memo1.Lines.Add(lastlines[lastlines.Count-9]);
  Form1.Memo1.Lines.Add(lastlines[lastlines.Count-8]);
  Form1.Memo1.Lines.Add(lastlines[lastlines.Count-7]);
  Form1.Memo1.Lines.Add(lastlines[lastlines.Count-6]);
  Form1.Memo1.Lines.Add(lastlines[lastlines.Count-5]);
  Form1.Memo1.Lines.Add(lastlines[lastlines.Count-4]);
  Form1.Memo1.Lines.Add(lastlines[lastlines.Count-3]);
  Form1.Memo1.Lines.Add(lastlines[lastlines.Count-2]);
  Form1.Memo1.Lines.Add(lastlines[lastlines.Count-1]);
  end
  else
  Form1.Memo1.Lines:=lastlines;
  lastlines.Destroy;
  Form1.Memo1.SelStart:=Form1.Memo1.GetTextLen;
  Form1.Memo1.SelLength:=0;
  except on e:exception do
  Form1.Memo1.Lines.Add(e.ToString);
  end;
  end;}
  {if fileExists(logpath+PathDelim+UTF8ToSys(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnname])+'.cache') and (Form1.Listview1.Items[Form1.ListView1.ItemIndex].SubItems[columnstatus]<>'1') and (Form1.Memo1.Visible) then
  begin
  try
  Form1.Memo1.Lines.LoadFromFile(logpath+PathDelim+UTF8ToSys(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnname])+'.cache');
  Form1.Memo1.SelStart:=Form1.Memo1.GetTextLen;
  Form1.Memo1.SelLength:=0;
  except on e:exception do
  end;
  end;}
end;
end;

procedure TForm1.MenuItem10Click(Sender: TObject);
var widgetset:String;
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
Form4.Label1.Caption:='AWGG';
Form4.Label2.Caption:='(Advanced WGET GUI)'+#10#13+'Version: '+versionitis.version+#10#13+'Compiled using:'+#10#13+'Lazarus: '+lcl_version+#10#13+'FPC: '+versionitis.fpcversion+#10#13+'Platform: '+versionitis.targetcpu+'-'+versionitis.targetos+'-'+widgetset;
Form4.Memo1.Text:='Created By Reinier Romero Mir'+#13+'Email: nenirey@gmail.com'+#13+'Copyright© 2014'+#13+'The project uses the following third party resources:'+#10#13+'Silk icons set 1.3 by Mark James'+#13+'http://www.famfamfam.com/lab/icons/silk/'+#10#13+'Tango Icon Library'+#13+'http://tango.freedesktop.org/Tango_Icon_Library'+#10#13+'aria2'+#13+'http://aria2.sourceforge.net/'+#10#13+'Wget'+#13+'http://www.gnu.org/software/wget/'+#10#13+'cURL'+#13+'http://curl.haxx.se/'+#10#13+'Axel'+#13+'http://axel.alioth.debian.org/'+#10#13+'Cntlm'+#13+'http://cntlm.sourceforge.net/';
Form4.Label3.Caption:='http://sites.google.com/site/awggproject';
Form4.Show;
end;

procedure TForm1.MenuItem11Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  begin
  Form2.Edit3.Text:=Form1.ListView1.ItemFocused.SubItems[columnname];
  Form2.Edit1.Text:=Form1.ListView1.ItemFocused.SubItems[columnurl];
  Form2.DirectoryEdit1.Text:=Form1.ListView1.ItemFocused.SubItems[columndestiny];
  enginereload();
  Form2.ComboBox1.ItemIndex:=Form2.ComboBox1.Items.IndexOf(Form1.ListView1.ItemFocused.SubItems[columnengine]);
  Form2.Edit2.Text:=Form1.ListView1.ItemFocused.SubItems[columnparameters];
  Form1.Timer4.Enabled:=false;
  Form2.Edit4.Text:=Form1.ListView1.ItemFocused.SubItems[columnuser];
  Form2.Edit5.Text:=Form1.ListView1.ItemFocused.SubItems[columnpass];
  ///////CONFIRM DIALOG MODE///////////
  Form2.Caption:=rsForm.titlepropertiesdown.Caption;
  Form2.Button1.Visible:=false;
  Form2.Button4.Visible:=false;
  Form2.Button3.Caption:=rsForm.btnpropertiesok.Caption;
  ////////////////////////////////////
  Form2.ShowModal;
  ///////NEW DOWNLOAD DIALOG MODE///////////
  Form2.Caption:=rsForm.titlenewdown.Caption;
  Form2.Button1.Visible:=true;
  Form2.Button4.Visible:=true;
  Form2.Button3.Caption:=rsForm.btnnewdownstartnow.Caption;
  ////////////////////////////////////
  Form1.Timer4.Enabled:=clipboardmonitor;
  if agregar then
  begin
  Form1.ListView1.ItemFocused.SubItems[columnname]:=Form2.Edit3.Text;
  Form1.ListView1.ItemFocused.SubItems[columnurl]:=Form2.Edit1.Text;
  Form1.ListView1.ItemFocused.SubItems[columndestiny]:=Form2.DirectoryEdit1.Text;
  Form1.ListView1.ItemFocused.SubItems[columnengine]:=Form2.ComboBox1.Text;
  Form1.ListView1.ItemFocused.SubItems[columnparameters]:=Form2.Edit2.Text;
  Form1.ListView1.ItemFocused.SubItems[columnuser]:=Form2.Edit4.Text;
  Form1.ListView1.ItemFocused.SubItems[columnpass]:=Form2.Edit5.Text;
  savemydownloads();
  end;
end;
end;

procedure TForm1.MenuItem12Click(Sender: TObject);
begin
   if Form1.ListView1.ItemIndex<>-1 then
   ClipBoard.AsText:=Form1.ListView1.ItemFocused.SubItems[columnurl];
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
var x:integer;
begin
for x:=0 to Form1.ListView1.Items.Count-1 do
begin
Form1.ListView1.Items[x].Checked:=true;
end;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
Form1.TrayIcon1DblClick(nil);
end;

procedure TForm1.MenuItem20Click(Sender: TObject);
var x:integer;
begin
for x:=0 to Form1.ListView1.Items.Count-1 do
begin
Form1.ListView1.Items[x].Checked:=false;
end;
end;

procedure TForm1.MenuItem21Click(Sender: TObject);
var x:integer;
begin
colamanual:=true;
for x:=0 to Form1.ListView1.Items.Count-1 do
begin
downloadstart(x,false);
end;
end;

procedure TForm1.MenuItem22Click(Sender: TObject);
var x:integer;
begin
for x:=0 to Form1.ListView1.Items.Count-1 do
begin
if Form1.ListView1.Items[x].SubItems[columnstatus]='1' then
begin
Form1.ListView1.Items[x].Checked:=false;
hilo[strtoint(Form1.ListView1.Items[x].SubItems[columnid])].shutdown();
end;
end;
end;

procedure TForm1.MenuItem23Click(Sender: TObject);
begin
  Form1.ListView1.Column[columncurrent+1].Visible:=not Form1.ListView1.Column[columncurrent+1].Visible;
  Form1.MenuItem23.Checked:=Form1.ListView1.Column[columncurrent+1].Visible;
end;

procedure TForm1.MenuItem24Click(Sender: TObject);
begin
  Form1.ListView1.Column[columnparameters+1].Visible:=not Form1.ListView1.Column[columnparameters+1].Visible;
  Form1.MenuItem24.Checked:=Form1.ListView1.Column[columnparameters+1].Visible;
end;

procedure TForm1.MenuItem25Click(Sender: TObject);
begin
Form1.ListView1.GridLines:=not Form1.ListView1.GridLines;
Form1.MenuItem25.Checked:=Form1.ListView1.GridLines;
end;

procedure TForm1.MenuItem26Click(Sender: TObject);
begin
if Form1.ListView1.ItemIndex<>-1 then
begin
  if FileExists(logpath+pathdelim+UTF8ToSys(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnname])+'.log') then
  OpenURL(ExtractShortPathName(logpath+pathdelim+UTF8ToSys(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnname])+'.log'))
  else
  ShowMessage(rsForm.msgnoexisthistorylog.Caption);
end;
end;

procedure TForm1.MenuItem27Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  begin
  colamanual:=true;
  downloadstart(Form1.ListView1.ItemIndex,false);
  end;
end;

procedure TForm1.MenuItem28Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  hilo[Form1.ListView1.ItemIndex].shutdown();
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
var x:integer;
begin
dlgForm.Caption:=rsForm.dlgconfirm.Caption;
dlgForm.dlgtext.Caption:=rsForm.dlgrestartalldownloads.Caption;
dlgForm.ShowModal;
  if dlgcuestion then
  begin
  colamanual:=true;
  for x:=0 to Form1.ListView1.Items.Count-1 do
  begin
  if Form1.ListView1.Items[x].Subitems[columnstatus]<>'1' then
  restartdownload(x,true);
  end;
  end;
end;

procedure TForm1.MenuItem31Click(Sender: TObject);
begin
dlgForm.Caption:=rsForm.dlgconfirm.Caption;
dlgForm.dlgtext.Caption:=rsForm.dlgdeletealldownloads.Caption;
dlgForm.ShowModal;
  if dlgcuestion then
  begin
  stopall(false);
  Form1.ListView1.Items.Clear;
  end;
  savemydownloads();
end;

procedure TForm1.MenuItem33Click(Sender: TObject);
begin
if splitpos<20 then
splitpos:=20;
if splitpos>Form1.PairSplitter1.Height-20 then
splitpos:=splitpos-20;
   if Form1.Memo1.Visible then
   begin
   splitpos:=Form1.PairSplitter1.Position;
   end;
   Form1.Memo1.Visible:=not Form1.Memo1.Visible;
   MenuItem33.Checked:=Form1.Memo1.Visible;
   if Form1.Memo1.Visible then
   Form1.PairSplitter1.Position:=splitpos
   else
   Form1.PairSplitter1.Position:=Form1.PairSplitter1.Height;
Form1.MenuItem53.Checked:=Form1.Memo1.Visible;
Form1.MenuItem53.Enabled:=Form1.Memo1.Visible;
if Form1.Memo1.Visible=false then
Form1.Memo1.Lines.Clear;
end;

procedure TForm1.MenuItem34Click(Sender: TObject);
begin
if Form1.ListView1.ItemIndex<>-1 then
begin
  if DirectoryExists(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columndestiny]) then
  OpenURL(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columndestiny])
  else
  ShowMessage(rsForm.msgnoexistfolder.Caption+' '+Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columndestiny]);
end;
end;

procedure TForm1.MenuItem36Click(Sender: TObject);
begin
  Form1.ListView1.Column[0].Visible:=not Form1.ListView1.Column[0].Visible;
  Form1.MenuItem36.Checked:=Form1.ListView1.Column[0].Visible;
end;

procedure TForm1.MenuItem37Click(Sender: TObject);
begin
  Form1.ListView1.Column[columnname+1].Visible:=not Form1.ListView1.Column[columnname+1].Visible;
  Form1.MenuItem37.Checked:=Form1.ListView1.Column[columnname+1].Visible;
end;

procedure TForm1.MenuItem38Click(Sender: TObject);
begin
  Form1.ListView1.Column[columnsize+1].Visible:=not Form1.ListView1.Column[columnsize+1].Visible;
  Form1.MenuItem38.Checked:=Form1.ListView1.Column[columnsize+1].Visible;

end;

procedure TForm1.MenuItem39Click(Sender: TObject);
begin
  Form1.ListView1.Column[columnurl+1].Visible:=not Form1.ListView1.Column[columnurl+1].Visible;
  Form1.MenuItem39.Checked:=Form1.ListView1.Column[columnurl+1].Visible;

end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
colamanual:=true;
  Form1.Timer2.Enabled:=true;
end;

procedure TForm1.MenuItem40Click(Sender: TObject);
begin
  Form1.ListView1.Column[columnspeed+1].Visible:=not Form1.ListView1.Column[columnspeed+1].Visible;
  Form1.MenuItem40.Checked:=Form1.ListView1.Column[columnspeed+1].Visible;

end;

procedure TForm1.MenuItem41Click(Sender: TObject);
begin
  Form1.ListView1.Column[columnpercent+1].Visible:=not Form1.ListView1.Column[columnpercent+1].Visible;
  Form1.MenuItem41.Checked:=Form1.ListView1.Column[columnpercent+1].Visible;

end;

procedure TForm1.MenuItem42Click(Sender: TObject);
begin
  Form1.ListView1.Column[columnestimate+1].Visible:=not Form1.ListView1.Column[columnestimate+1].Visible;
  Form1.MenuItem42.Checked:=Form1.ListView1.Column[columnestimate+1].Visible;

end;

procedure TForm1.MenuItem43Click(Sender: TObject);
begin
  Form1.ListView1.Column[columndestiny+1].Visible:=not Form1.ListView1.Column[columndestiny+1].Visible;
  Form1.MenuItem43.Checked:=Form1.ListView1.Column[columndestiny+1].Visible;

end;

procedure TForm1.MenuItem44Click(Sender: TObject);
begin
  Form1.ListView1.Column[columnengine+1].Visible:=not Form1.ListView1.Column[columnengine+1].Visible;
  Form1.MenuItem44.Checked:=Form1.ListView1.Column[columnengine+1].Visible;

end;

procedure TForm1.MenuItem45Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  begin
  if FileExists(Form1.ListView1.ItemFocused.SubItems[columndestiny]+pathdelim+UTF8ToSys(Form1.ListView1.ItemFocused.SubItems[columnname])) then
  OpenURL(Form1.ListView1.ItemFocused.SubItems[columndestiny]+pathdelim+UTF8ToSys(Form1.ListView1.ItemFocused.SubItems[columnname]))
  else
  ShowMessage(rsForm.msgfilenoexist.Caption);
  end;
end;

procedure TForm1.MenuItem46Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  OpenURL(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnurl]);
end;

procedure TForm1.MenuItem47Click(Sender: TObject);
var x:integer;
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
  if Form1.ListView1.ItemIndex>0 then
  begin
  Form1.ListView1.MultiSelect:=false;
  Form1.ListView1.Items.Move(Form1.ListView1.ItemIndex,Form1.ListView1.ItemIndex-1);
  Form1.ListView1.MultiSelect:=true;
  rebuildids();
  end;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  stopqueue();
end;

procedure TForm1.MenuItem50Click(Sender: TObject);
begin
  if (Form1.ListView1.ItemIndex>=0) and (Form1.ListView1.ItemIndex<Form1.ListView1.Items.Count-1) then
  begin
  Form1.ListView1.MultiSelect:=false;
  Form1.ListView1.Items.Move(Form1.ListView1.ItemIndex,Form1.ListView1.ItemIndex+1);
  Form1.ListView1.MultiSelect:=true;
  rebuildids();
  end;
end;

procedure TForm1.MenuItem51Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex>0 then
  begin
  Form1.ListView1.MultiSelect:=false;
  Form1.ListView1.Items.Move(Form1.ListView1.ItemIndex,0);
  Form1.ListView1.MultiSelect:=true;
  rebuildids();
  end;
end;

procedure TForm1.MenuItem52Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  begin
  Form1.ListView1.MultiSelect:=false;
  Form1.ListView1.Items.Move(Form1.ListView1.ItemIndex,Form1.ListView1.Items.Count-1);
  Form1.ListView1.MultiSelect:=true;
  rebuildids();
  end;
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
  colamanual:=true;
  Form1.Timer2.Enabled:=true;
end;

procedure TForm1.MenuItem57Click(Sender: TObject);
begin
 stopqueue();
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
  if FileExists(logpath+pathdelim+UTF8ToSys(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnname])+'.log') then
  DeleteFile(logpath+pathdelim+UTF8ToSys(Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[columnname])+'.log');
  end;
  Form1.Memo1.Lines.Clear;
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
  Timer1.Enabled:=false;
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
saveandexit();
end;

procedure TForm1.MenuItem82Click(Sender: TObject);
begin
  Form1.ListView1.Column[columndate+1].Visible:=not Form1.ListView1.Column[columndate+1].Visible;
  Form1.MenuItem82.Checked:=Form1.ListView1.Column[columndate+1].Visible;
end;

procedure TForm1.MenuItem8Click(Sender: TObject);
begin
  //Form3.PageControl1.ActivePageIndex:=0;
  Form3.TreeView1.Items[Form3.PageControl1.ActivePageIndex].Selected:=true;
  configdlg();
end;

procedure TForm1.PairSplitter1ChangeBounds(Sender: TObject);
begin
  if splitpos<20 then
   splitpos:=20;
   if Form1.PairSplitter1.Position>Form1.PairSplitter1.Height-20 then
   splitpos:=splitpos-20;
  if Form1.Memo1.Visible then
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
  if Form1.Memo1.Visible then
  splitpos:=Form1.PairSplitter1.Position;
end;


procedure TForm1.PopupNotifier1Close(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if (CloseAction<>caNone) and  (CloseAction<>caFree) and (Form1.Visible=false) then
  Form1.Show;
end;

procedure TForm1.Timer1StartTimer(Sender: TObject);
begin
Form1.ToolButton15.Enabled:=false;
Form1.ToolButton16.Enabled:=true;
Form1.MenuItem60.Enabled:=false;
Form1.MenuItem61.Enabled:=true;
end;

procedure TForm1.Timer1StopTimer(Sender: TObject);
begin
  Form1.ToolButton15.Enabled:=true;
  Form1.ToolButton16.Enabled:=false;
  Form1.MenuItem60.Enabled:=true;
  Form1.MenuItem61.Enabled:=false;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var hora:TTime;
    fecha:TDate;
    startdatetime:TDatetime;
    stopdatetime:TDateTime;
    i:integer;
    checkstart:boolean;
    checkstop:boolean;
    checkdayweek:boolean;
    diasemana:integer;
    semana:array[1..7] of boolean;
begin
//Esto me quedo lindo :)
semana[1]:=domingo;
semana[2]:=lunes;
semana[3]:=martes;
semana[4]:=miercoles;
semana[5]:=jueves;
semana[6]:=viernes;
semana[7]:=sabado;
hora:=Time();
fecha:=Date();
startdatetime:=StrToDateTime(datetostr(startdate)+' '+timetostr(starttime));
stopdatetime:=StrToDateTime(datetostr(stopdate)+' '+timetostr(stoptime));
diasemana:=DayOfWeek(fecha);

if allday then
begin
checkstart:=(hora>=starttime);
if queuestop then
checkstop:=(hora<=stoptime)
else
checkstop:=true;
checkdayweek:=semana[diasemana];
end
else
begin
checkstart:=(Now()>=startdatetime);
if queuestop then
checkstop:=(Now()<=stopdatetime)
else
checkstop:=true;
checkdayweek:=true;
end;

if (checkstart) and (checkstop) and (checkdayweek) then
begin
  colamanual:=false;
  if sheduledisablelimits then
  Form1.CheckBox1.Checked:=false;
  Form1.Timer2.Enabled:=true;
  Form1.Timer2.Interval:=queuedelay*1000;
end
else
begin
if (colamanual=false) then
begin
stopqueue();
end;
end;
end;

procedure TForm1.Timer2StartTimer(Sender: TObject);
var n:integer;
begin
  Form1.ToolButton9.Enabled:=false;
  Form1.ToolButton11.Enabled:=true;
  Form1.MenuItem3.Enabled:=false;
  Form1.MenuItem4.Enabled:=true;
  for n:=0 to Form1.ListView1.Items.Count-1 do
  Form1.ListView1.Items[n].SubItems[columntries]:=inttostr(triesrotate);
end;

procedure TForm1.Timer2StopTimer(Sender: TObject);
begin
  Form1.ToolButton9.Enabled:=true;
  Form1.ToolButton11.Enabled:=false;
  Form1.MenuItem3.Enabled:=true;
  Form1.MenuItem4.Enabled:=false;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var i,maxcdown:integer;
begin
maxcdown:=0;
for i:=0 to Form1.ListView1.Items.Count-1 do
begin
if (Form1.ListView1.Items[i].SubItems[columnstatus]='1') then
inc(maxcdown);
end;
for i:=0 to Form1.ListView1.Items.Count-1 do
begin
if (Form1.ListView1.Items[i].Checked) and (maxcdown<Form1.SpinEdit1.Value) and ((Form1.ListView1.Items[i].SubItems[columnstatus]='') or (Form1.ListView1.Items[i].SubItems[columnstatus]='2') or (Form1.ListView1.Items[i].SubItems[columnstatus]='0')) and (strtoint(Form1.ListView1.Items[i].SubItems[columntries])>0) then
begin
///////
inc(maxcdown);
downloadstart(i,false);
//////
end;
end;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
begin
  Form1.PopupNotifier1.Hide;
  Form1.Timer3.Enabled:=false;
end;

procedure TForm1.Timer4Timer(Sender: TObject);
var cbn:integer;
    noesta:boolean;
    tmpclip:string;
begin
noesta:=true;
if Length(ClipBoard.AsText) <= 256 then
begin
tmpclip:=ClipBoard.AsText;
  if ((Pos('http://',tmpclip)=1) or (Pos('https://',tmpclip)=1) or (Pos('ftp://',tmpclip)=1)) and (clipurl<>tmpclip) then
  begin
  for cbn:=0 to Form1.ListView1.Items.Count-1 do
  begin
  if Pos(tmpclip,Form1.ListView1.Items[cbn].SubItems[columnurl])>0 then
  noesta:=false;
  end;
  if noesta then
  begin
  Form1.Timer4.Enabled:=false;
  ToolButton1Click(nil);
  Form1.Timer4.Enabled:=true;
  end;
  end;
if ((Pos('http://',tmpclip)=1) or (Pos('https://',tmpclip)=1) or (Pos('ftp://',tmpclip)=1)) then
clipurl:=tmpclip;
end
else
tmpclip:='';
end;

procedure TForm1.Timer6Timer(Sender: TObject);
var downitem:TListItem;
    tmpindex:integer;
    itemfile:TSearchRec;
begin
Form1.Timer6.Enabled:=false;
if firststart then
begin
Form5.ComboBox1.Items.Clear;
if FindFirst(ExtractFilePath(Application.Params[0])+pathdelim+'languages'+pathdelim+'awgg.*.po',faAnyFile,itemfile)=0 then
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
end;
updatelangstatus();
titlegen();
firststart:=false;
if (Application.ParamCount>0) then
begin
  Form2.Edit1.Text:=Application.Params[1];
  Form2.DirectoryEdit1.Text:=ddowndir;
  Form2.Edit2.Text:='';
  if Application.ParamCount>1 then
  Form2.Edit3.Text:=Application.Params[2]
  else
  Form2.Edit3.Text:=ParseURI(Form2.Edit1.Text).Document;
  Form2.Edit4.Text:='';
  Form2.Edit5.Text:='';
  Form2.ComboBox1.ItemIndex:=Form2.ComboBox1.Items.IndexOf(defaultengine);
  Form1.Timer4.Enabled:=false;//Desactivar temporalmente el clipboard monitor
  enginereload();
  if Form2.Visible=false then
  Form2.ShowModal;
  Form1.Timer4.Enabled:=clipboardmonitor;//Avtivar el clipboardmonitor
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
  Form1.ListView1.Items.AddItem(downitem);
  tmpindex:=downitem.Index;
  if cola then
  begin
  Form1.ListView1.Items[tmpindex].Checked:=true;
  colamanual:=true;
  Form1.Timer2.Enabled:=true;
  end;
  savemydownloads();
  if iniciar then
  begin
  downloadstart(tmpindex,false);
  end;
  end;
end;
end;

procedure TForm1.ToolButton11Click(Sender: TObject);
begin
  stopqueue();
end;

procedure TForm1.ToolButton12Click(Sender: TObject);
begin
  stopall(false);
end;

procedure TForm1.ToolButton14Click(Sender: TObject);
begin
  Form1.Memo1.Lines.Clear;
end;

procedure TForm1.ToolButton15Click(Sender: TObject);
begin
  startsheduletimer();
end;

procedure TForm1.ToolButton16Click(Sender: TObject);
begin
  Timer1.Enabled:=false;
end;

procedure TForm1.ToolButton17Click(Sender: TObject);
begin
  saveandexit();
end;

procedure TForm1.ToolButton19Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex>0 then
  begin
  Form1.ListView1.MultiSelect:=false;
  Form1.ListView1.Items.Move(Form1.ListView1.ItemIndex,Form1.ListView1.ItemIndex-1);
  Form1.ListView1.MultiSelect:=true;
  rebuildids();
  end;
end;

procedure TForm1.ToolButton1Click(Sender: TObject);
var downitem:TListItem;
    tmpindex:integer;
begin
{ TODO 4 -oSegator -cmanejo de ficheros : Obtener el nombre y tama;o del archivo antes de descargarlo, para el manejo correcto del fichero y espacio en disco. }
if (Pos('http://',ClipBoard.AsText)=1) or (Pos('https://',ClipBoard.AsText)=1) or (Pos('ftp://',ClipBoard.AsText)=1) then
  Form2.Edit1.Text:=ClipBoard.AsText
  else
  Form2.Edit1.Text:='http://';
Form2.DirectoryEdit1.Text:=ddowndir;
Form2.Edit2.Text:='';
//Form2.Edit3.Text:=ufilename(Form2.Edit1.Text);
Form2.Edit3.Text:=ParseURI(Form2.Edit1.Text).Document;
Form2.Edit4.Text:='';
Form2.Edit5.Text:='';
Form2.ComboBox1.ItemIndex:=Form2.ComboBox1.Items.IndexOf(defaultengine);
Form1.Timer4.Enabled:=false;//Descativar temporalmete el clipboardmonitor
//Recargar engines
enginereload();
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
Form1.ListView1.Items.AddItem(downitem);
tmpindex:=downitem.Index;
if cola then
begin
Form1.ListView1.Items[tmpindex].Checked:=true;
colamanual:=true;
Form1.Timer2.Enabled:=true;
end;
savemydownloads();
if iniciar then
begin
downloadstart(tmpindex,false);
end;
end;
end;

procedure TForm1.ToolButton20Click(Sender: TObject);
begin
  if (Form1.ListView1.ItemIndex>=0) and (Form1.ListView1.ItemIndex<Form1.ListView1.Items.Count-1) then
  begin
  Form1.ListView1.MultiSelect:=false;
  Form1.ListView1.Items.Move(Form1.ListView1.ItemIndex,Form1.ListView1.ItemIndex+1);
  Form1.ListView1.MultiSelect:=true;
  rebuildids();
  end;
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
  if Form1.ListView1.ItemIndex>0 then
  begin
  Form1.ListView1.MultiSelect:=false;
  Form1.ListView1.Items.Move(Form1.ListView1.ItemIndex,0);
  Form1.ListView1.MultiSelect:=true;
  rebuildids();
  end;
end;

procedure TForm1.ToolButton24Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  begin
  Form1.ListView1.MultiSelect:=false;
  Form1.ListView1.Items.Move(Form1.ListView1.ItemIndex,Form1.ListView1.Items.Count-1);
  Form1.ListView1.MultiSelect:=true;
  rebuildids();
  end;
end;

procedure TForm1.ToolButton25Click(Sender: TObject);
begin
  importdownloads();
end;

procedure TForm1.ToolButton26Click(Sender: TObject);
begin
  exportdownloads();
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
begin
deleteitems(false);
end;

procedure TForm1.ToolButton3Click(Sender: TObject);
begin
  if Form1.ListView1.ItemIndex<>-1 then
  begin
  colamanual:=true;
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
  //Form3.PageControl1.ActivePageIndex:=0;
  Form3.TreeView1.Items[Form3.PageControl1.ActivePageIndex].Selected:=true;
  configdlg();
end;

procedure TForm1.ToolButton8Click(Sender: TObject);
begin
  Form3.PageControl1.ActivePageIndex:=1;
  Form3.TreeView1.Items[Form3.PageControl1.ActivePageIndex].Selected:=true;
  configdlg();
end;

procedure TForm1.ToolButton9Click(Sender: TObject);
begin
  colamanual:=true;
  Form1.Timer2.Enabled:=true;
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
var n,nc:integer;
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

procedure TForm1.UniqueInstance1OtherInstance(Sender: TObject;
  ParamCount: Integer; Parameters: array of String);
var downitem:TListItem;
    tmpindex:integer;
begin
onestart:=false;
if ParamCount>0 then
begin
  Form2.Edit1.Text:=Parameters[0];
  Form2.DirectoryEdit1.Text:=ddowndir;
  Form2.Edit2.Text:='';
  if ParamCount>1 then
  Form2.Edit3.Text:=Parameters[1]
  else
  Form2.Edit3.Text:=ParseURI(Form2.Edit1.Text).Document;
  Form2.Edit4.Text:='';
  Form2.Edit5.Text:='';
  Form2.ComboBox1.ItemIndex:=Form2.ComboBox1.Items.IndexOf(defaultengine);
  Form1.Timer4.Enabled:=false;//Desactivar temporalmente el clipboardmonitor
  enginereload();
  if Form2.Visible=false then
  Form2.ShowModal;
  Form1.Timer4.Enabled:=clipboardmonitor;//Activar el clipboardmonitor
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
  Form1.ListView1.Items.AddItem(downitem);
  tmpindex:=downitem.Index;
  if cola then
  begin
  Form1.ListView1.Items[tmpindex].Checked:=true;
  colamanual:=true;
  Form1.Timer2.Enabled:=true;
  end;
  savemydownloads();
  if iniciar then
  begin
  downloadstart(tmpindex,false);
  end;
  end;
end
else
Form1.Show;
end;

end.

