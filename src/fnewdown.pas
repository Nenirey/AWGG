unit fnewdown;
{
  New download form of AWGG

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
  Classes, SysUtils, Forms, Controls, Dialogs, StdCtrls,
  EditBtn, Buttons, fstrings, freplace, fconfirm, fvideoformat, URIParser, LCLIntF, FileUtil, LazFileUtils, LazUTF8;

type

  { Tfrnewdown }

  Tfrnewdown = class(TForm)
    btnDeleteFilter: TSpeedButton;
    btnNoForceNames: TSpeedButton;
    btnStart: TBitBtn;
    btnToQueue: TButton;
    btnCancel: TButton;
    btnPaused: TButton;
    cbEngine: TComboBox;
    cbQueue: TComboBox;
    cbDestination: TComboBox;
    deDestination: TDirectoryEdit;
    edtURL: TEdit;
    edtParameters: TEdit;
    edtFileName: TEdit;
    edtUser: TEdit;
    edtPassword: TEdit;
    lblURL: TLabel;
    lblDestination: TLabel;
    lblEngine: TLabel;
    lblParameters: TLabel;
    lblFileName: TLabel;
    lblUser: TLabel;
    lblPassword: TLabel;
    lblQueue: TLabel;
    btnAddQueue: TSpeedButton;
    btnSchedule: TSpeedButton;
    btnCategoryGo: TSpeedButton;
    btnGoDestination: TSpeedButton;
    btnMore: TSpeedButton;
    btnToUp: TSpeedButton;
    btnToEnd: TSpeedButton;
    btnAddToFilter: TSpeedButton;
    btnForceNames: TSpeedButton;
    procedure btnDeleteFilterClick(Sender: TObject);
    procedure btnForceNamesClick(Sender: TObject);
    procedure btnMoreClick(Sender: TObject);
    procedure btnNoForceNamesClick(Sender: TObject);
    procedure btnToEndClick(Sender: TObject);
    procedure btnToUpClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnToQueueClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnPausedClick(Sender: TObject);
    procedure cbDestinationChange(Sender: TObject);
    procedure cbEngineChange(Sender: TObject);
    procedure deDestinationAcceptDirectory(Sender: TObject; var Value: String);
    procedure deDestinationChange(Sender: TObject);
    procedure edtURLChange(Sender: TObject);
    procedure edtFileNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure btnAddQueueClick(Sender: TObject);
    procedure btnScheduleClick(Sender: TObject);
    procedure btnCategoryGoClick(Sender: TObject);
    procedure btnGoDestinationClick(Sender: TObject);
    procedure btnAddToFilterClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frnewdown: Tfrnewdown;
  //downitem:TListItem;
  iniciar,agregar,cola,updateurl:Boolean;
  function checkandclose(auto:boolean=false):boolean;
implementation
uses fmain,fconfig;
{$R *.lfm}

function checkandclose(auto:boolean=false):boolean;
var
  found:boolean;
begin
  freplace.accept:=true;
  updateurl:=false;
  if (frnewdown.edtFileName.Text<>'') and (frnewdown.btnToQueue.Visible=true) then
  begin
    frreplace.rbAutoRename.Checked:=true;
    found:=destinyexists(frnewdown.deDestination.Text+pathdelim+frnewdown.edtFileName.Text);
    while ((FileExists(UTF8ToSys(frnewdown.deDestination.Text+pathdelim+frnewdown.edtFileName.Text))) and ((found) and (frreplace.rbOverwrite.Checked=false))) and (frreplace.rbUpdateURL.Checked=false) do
    begin
      found:=destinyexists(frnewdown.deDestination.Text+pathdelim+frnewdown.edtFileName.Text);
      frreplace.rbUpdateURL.Enabled:=found;
      frreplace.rbOverwrite.Enabled:=FileExists(UTF8ToSys(frnewdown.deDestination.Text+pathdelim+frnewdown.edtFileName.Text));
      if (FileExists(UTF8ToSys(frnewdown.deDestination.Text+pathdelim+frnewdown.edtFileName.Text))) and ((found) and (frreplace.rbOverwrite.Checked=false)) then
      begin
        frreplace.rbAutoRename.Checked:=true;
        frreplace.edtFileName.Text:='_'+frnewdown.edtFileName.Text;
        while (destinyexists(frnewdown.deDestination.Text+pathdelim+frreplace.edtFileName.Text)) or (FileExists(frnewdown.deDestination.Text+pathdelim+frreplace.edtFileName.Text))  do
          frreplace.edtFileName.Text:='_'+frreplace.edtFileName.Text;
        if auto=false then
        begin
         frreplace.ShowModal;
        end
        else
         freplace.accept:=true;
        if freplace.accept then
          frnewdown.edtFileName.Text:=frreplace.edtFileName.Text
        else
          break;
      end;
    end;
  end;
  updateurl:=frreplace.rbUpdateURL.Checked;
    if updateurl and freplace.accept then
    begin
      destinyexists(frnewdown.deDestination.Text+pathdelim+frnewdown.edtFileName.Text,frnewdown.edtURL.Caption);
      savemydownloads();
    end;
  if freplace.accept=true then
  begin
    frnewdown.Close;
    result:=true;
  end
  else
  begin
    result:=false;
    agregar:=false;
    cola:=false;
    iniciar:=false;
  end;
end;

procedure Tfrnewdown.btnCancelClick(Sender: TObject);
begin
  agregar:=false;
  frnewdown.edtURL.Caption:='http://';
  frnewdown.Close;
end;

procedure Tfrnewdown.btnPausedClick(Sender: TObject);
begin
  if frnewdown.cbEngine.ItemIndex<>-1 then
  begin
    agregar:=true;
    cola:=false;
    iniciar:=false;
    checkandclose();
  end
  else
    ShowMessage(fstrings.msgmustselectdownloadengine);
end;

procedure Tfrnewdown.cbDestinationChange(Sender: TObject);
var
  newpath:string='';
begin
  newpath:=frnewdown.cbDestination.Text;
  frnewdown.deDestination.Text:=newpath;
  frnewdown.deDestinationAcceptDirectory(nil,newpath);
end;

procedure Tfrnewdown.cbEngineChange(Sender: TObject);
begin
  if frnewdown.cbEngine.Text='youtube-dl' then
    frnewdown.btnMore.Enabled:=true
  else
    frnewdown.btnMore.Enabled:=false;
end;

procedure Tfrnewdown.deDestinationAcceptDirectory(Sender: TObject;
  var Value: String);
var
  ext:string='';
  i,x:integer;
  indice:integer=-1;
  extexists:boolean=false;
begin
  if frnewdown.edtFileName.Caption<>'' then
  begin
    ext:=UpperCase(Copy(frnewdown.edtFileName.Caption,LastDelimiter('.',frnewdown.edtFileName.Caption)+1,Length(frnewdown.edtFileName.Caption)));
    if ext <>'' then
    begin
      for i:=0 to Length(categoryextencions)-1 do
      begin
        if categoryextencions[i][0]=Value then
         indice:=i;
        for x:=2 to categoryextencions[i].Count-1 do
        begin
          if UpperCase(categoryextencions[i][x])=ext then
            extexists:=true;
        end;
      end;
      if extexists=false then
      begin
        frconfirm.dlgtext.Caption:=fstrings.newfiletyperememberpath;
        frnewdown.FormStyle:=fsNormal;
        frconfirm.ShowModal;
        frnewdown.FormStyle:=fsSystemStayOnTop;
        if dlgcuestion then
        begin
          if indice=-1 then
          begin
            SetLength(categoryextencions,Length(categoryextencions)+1);
            indice:=Length(categoryextencions)-1;
            categoryextencions[indice]:=TStringList.Create;
            categoryextencions[indice].add(Value);
            categoryextencions[indice].add(ExtractFileName(Value));
          end;
          categoryextencions[indice].add(ext);
          categoryreload();
          frnewdown.cbDestination.ItemIndex:=frnewdown.cbDestination.Items.IndexOf(value);
        end;
      end;
    end;
  end;
end;

procedure Tfrnewdown.deDestinationChange(Sender: TObject);
begin
  frnewdown.cbDestination.Text:=frnewdown.deDestination.Text;
end;

procedure Tfrnewdown.edtURLChange(Sender: TObject);
var
  magnetname:string='';
  i:integer;
begin
  //magnet:?xt=urn:btih:899023C7BD1177A9F2E214372EC5107DD7F7C9EB&dn=The.discovery.2017.1080p-dual-lat.mp4&tr=udp%3a%2f%2ftracker.leechers-paradise.org%3a6969%2fannounce&tr=udp%3a%2f%2ftracker.coppersurfer.tk%3a6969%2fannounce&tr=http%3a%2f%2fipv4.tracker.harry.lu%3a80%2fannounce
  if newdownloadforcenames then
  begin
    frnewdown.edtFileName.Text:=ParseURI(frnewdown.edtURL.Text).document;
    if (Pos('magnet:',frnewdown.edtURL.Text)=1) and (Pos('&dn=',frnewdown.edtURL.Text)>0) then
    begin
      magnetname:=Copy(frnewdown.edtURL.Text,Pos('&dn=',frnewdown.edtURL.Text)+4,Length(frnewdown.edtURL.Text));
      magnetname:=Copy(magnetname,0,Pos('&',magnetname)-1);
      frnewdown.edtFileName.Text:=magnetname;
    end;
  end;
  suggestparameters();
  if ParseURI(frnewdown.edtURL.Text).Host<>'' then
  begin
    frnewdown.btnAddToFilter.Visible:=true;
    frnewdown.btnAddToFilter.Enabled:=true;
    frnewdown.btnDeleteFilter.Visible:=false;
    frnewdown.btnDeleteFilter.Enabled:=true;
  end
  else
  begin
    frnewdown.btnAddToFilter.Enabled:=false;
    frnewdown.btnDeleteFilter.Enabled:=false;
  end;
  for i:=0 to Length(domainfilters)-1 do
  begin
    if LowerCase(domainfilters[i])=LowerCase(ParseURI(frnewdown.edtURL.Text).Host) then
    begin
      frnewdown.btnAddToFilter.Visible:=false;
      frnewdown.btnDeleteFilter.Visible:=true;
    end;
  end;
end;

procedure Tfrnewdown.edtFileNameChange(Sender: TObject);
begin
  case defaultdirmode of
    1:frnewdown.deDestination.Text:=ddowndir;
    2:frnewdown.deDestination.Text:=suggestdir(frnewdown.edtFileName.Text);
  end;
end;

procedure Tfrnewdown.FormCreate(Sender: TObject);
begin
  agregar:=false;
  iniciar:=false;
  cola:=false;
end;

procedure Tfrnewdown.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  //ShowMessage(inttostr(Key));
  Case Key of
    13:frnewdown.btnStartClick(nil);
    27:frnewdown.btnCancelClick(nil);
    113:frnewdown.btnToQueueClick(nil);
    70:if (Shift=[ssAlt]) and frnewdown.btnMore.Enabled then frnewdown.btnMoreClick(nil);
    107:if Shift=[ssAlt] then frnewdown.btnAddQueueClick(nil);
    83:if Shift=[ssAlt] then frnewdown.btnScheduleClick(nil);
    36:if Shift=[ssAlt] then frnewdown.btnToEndClick(nil);
    35:if Shift=[ssAlt] then frnewdown.btnToUpClick(nil);
    67:if Shift=[ssAlt] then frnewdown.btnCategoryGoClick(nil);
    80:if Shift=[ssAlt] then frnewdown.btnPausedClick(nil);
  end;
end;

procedure Tfrnewdown.FormKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure Tfrnewdown.FormShow(Sender: TObject);
begin
  reloaddowndirs();
  frnewdown.cbEngineChange(nil);
  firstnormalshow:=true;
  frnewdown.cbDestination.Text:=frnewdown.deDestination.Text;
  frnewdown.btnToUp.Visible:=false;
  frnewdown.btnNoForceNames.Visible:=not newdownloadforcenames;
  frnewdown.btnForceNames.Visible:=newdownloadforcenames;
end;

procedure Tfrnewdown.btnAddQueueClick(Sender: TObject);
var
  i:integer;
begin
  newqueue();
  frnewdown.cbQueue.Items.Clear;
  for i:=0 to Length(queues)-1 do
  begin
    frnewdown.cbQueue.Items.Add(queuenames[i]);
  end;
  frnewdown.cbQueue.ItemIndex:=Length(queues)-1;
end;

procedure Tfrnewdown.btnScheduleClick(Sender: TObject);
begin
  frnewdown.FormStyle:=fsNormal;
  frconfig.pcConfig.ActivePageIndex:=1;
  frconfig.tvConfig.Items[frconfig.pcConfig.ActivePageIndex].Selected:=true;
  configdlg();
  frconfig.cbQueue.ItemIndex:=frnewdown.cbQueue.ItemIndex;
  frconfig.ShowModal;
  frnewdown.cbQueue.ItemIndex:=frconfig.cbQueue.ItemIndex;
  frnewdown.FormStyle:=fsSystemStayOnTop;
  suggestparameters();
end;

procedure Tfrnewdown.btnCategoryGoClick(Sender: TObject);
begin
  frnewdown.FormStyle:=fsNormal;
  frconfig.pcConfig.ActivePageIndex:=5;
  frconfig.tvConfig.Items[frconfig.pcConfig.ActivePageIndex].Selected:=true;
  configdlg();
  frconfig.ShowModal;
  categoryreload();
  frnewdown.FormStyle:=fsSystemStayOnTop;
end;

procedure Tfrnewdown.btnGoDestinationClick(Sender: TObject);
begin
  if not OpenURL(frnewdown.deDestination.Text) then
    OpenURL(ExtractShortPathName(UTF8ToSys(frnewdown.deDestination.Text)));
end;

procedure Tfrnewdown.btnAddToFilterClick(Sender: TObject);
begin
  SetLength(domainfilters,Length(domainfilters)+1);
  domainfilters[Length(domainfilters)-1]:=ParseURI(frnewdown.edtURL.Text).Host;
  activedomainfilter:=true;
  frnewdown.btnAddToFilter.Visible:=false;
  frnewdown.btnDeleteFilter.Visible:=true;
end;

procedure Tfrnewdown.btnToQueueClick(Sender: TObject);
begin
  if frnewdown.cbEngine.ItemIndex<>-1 then
  begin
    agregar:=true;
    cola:=true;
    iniciar:=false;
    checkandclose();
  end
  else
    ShowMessage(fstrings.msgmustselectdownloadengine);
end;

procedure Tfrnewdown.btnStartClick(Sender: TObject);
begin
  if frnewdown.cbEngine.ItemIndex<>-1 then
  begin
    agregar:=true;
    iniciar:=true;
    checkandclose();
  end
  else
    ShowMessage(fstrings.msgmustselectdownloadengine);
end;

procedure Tfrnewdown.btnMoreClick(Sender: TObject);
var
  ext:string='';
  fid:string='';
begin
  if Pos('--all-subs',LowerCase(frnewdown.edtParameters.Text))>0 then
    frvideoformat.chDownSubtitle.Checked:=true
  else
    frvideoformat.chDownSubtitle.Checked:=false;

  if Pos('--yes-playlist',LowerCase(frnewdown.edtParameters.Text))>0 then
    frvideoformat.chDownPlayList.Checked:=true
  else
    frvideoformat.chDownPlayList.Checked:=false;

  if frnewdown.edtFileName.Text='' then
  begin
    getyoutubename(frnewdown.edtURL.Text);
    frvideoformat.lblVideoName.Caption:=videonameloading;
    frvideoformat.lblName.Caption:='';
    fvideoformat.vname:='';
  end
  else
  begin
    frvideoformat.lblVideoName.Caption:=videoname;
    frvideoformat.lblName.Caption:=frnewdown.edtFileName.Text;
    fvideoformat.vname:=frnewdown.edtFileName.Text;
  end;
  getyoutubeformats(frnewdown.edtURL.Text);
  frnewdown.FormStyle:=fsNormal;
  frvideoformat.lblSelectFormat.Caption:=videoformatloading;
  frvideoformat.ShowModal;
  if (fvideoformat.accept) and (frnewdown.edtFileName.Text='') and (fvideoformat.vname<>'') then
    frnewdown.edtFileName.Text:=fvideoformat.vname;
  if (fvideoformat.accept) and (frvideoformat.lvFormats.ItemIndex<>-1) then
  begin
    if frnewdown.edtParameters.Text='' then
      frnewdown.edtParameters.Text:='-f '+frvideoformat.lvFormats.Items[frvideoformat.lvFormats.ItemIndex].SubItems[1]
    else
    begin
      if Pos('-f',LowerCase(frnewdown.edtParameters.Text))<=0 then
        frnewdown.edtParameters.Text:=frnewdown.edtParameters.Text+' -f '+frvideoformat.lvFormats.Items[frvideoformat.lvFormats.ItemIndex].SubItems[1]
      else
      begin
        fid:=Copy(frnewdown.edtParameters.Text,Pos('-f ',frnewdown.edtParameters.Text)+3,Length(frnewdown.edtParameters.Text));
        if Pos(' ',fid)>0 then
          fid:=Copy(fid,0,Pos(' ',fid)-1);
        fid:='-f '+fid;
        frnewdown.edtParameters.Text:=StringReplace(frnewdown.edtParameters.Text,fid,'-f '+frvideoformat.lvFormats.Items[frvideoformat.lvFormats.ItemIndex].SubItems[1],[rfReplaceAll]);
      end;
    end;
    if frnewdown.edtFileName.Text<>'' then
    begin
      ext:=Copy(frnewdown.edtFileName.Text,LastDelimiter('.',frnewdown.edtFileName.Text)+1,Length(frnewdown.edtFileName.Text));
      if length(ext)>4 then
        frnewdown.edtFileName.Text:=frnewdown.edtFileName.Text+'.'+frvideoformat.lvFormats.Items[frvideoformat.lvFormats.ItemIndex].Caption
      else
        frnewdown.edtFileName.Text:=Copy(frnewdown.edtFileName.Text,0,LastDelimiter('.',frnewdown.edtFileName.Text))+frvideoformat.lvFormats.Items[frvideoformat.lvFormats.ItemIndex].Caption;
    end;
  end;
  if frvideoformat.chDownSubtitle.Checked then
  begin
    if frnewdown.edtParameters.Text='' then
      frnewdown.edtParameters.Text:='--all-subs'
    else
    begin
      if Pos('--all-subs',LowerCase(frnewdown.edtParameters.Text))=0 then
        frnewdown.edtParameters.Text:=frnewdown.edtParameters.Text+' --all-subs';
    end;
  end
  else
  begin
    frnewdown.edtParameters.Text:=StringReplace(frnewdown.edtParameters.Text,' --all-subs','',[rfReplaceAll]);
    frnewdown.edtParameters.Text:=StringReplace(frnewdown.edtParameters.Text,'--all-subs','',[rfReplaceAll]);
  end;

  if frvideoformat.chDownPlayList.Checked then
  begin
    if frnewdown.edtParameters.Text='' then
      frnewdown.edtParameters.Text:='--yes-playlist'
    else
    begin
      if Pos('--yes-playlist',LowerCase(frnewdown.edtParameters.Text))=0 then
        frnewdown.edtParameters.Text:=frnewdown.edtParameters.Text+' --yes-playlist';
    end;
  end
  else
  begin
    frnewdown.edtParameters.Text:=StringReplace(frnewdown.edtParameters.Text,' --yes-playlist','',[rfReplaceAll]);
    frnewdown.edtParameters.Text:=StringReplace(frnewdown.edtParameters.Text,'--yes-playlist','',[rfReplaceAll]);
  end;
  frnewdown.FormStyle:=fsSystemStayOnTop;
end;

procedure Tfrnewdown.btnNoForceNamesClick(Sender: TObject);
begin
  frnewdown.btnForceNames.Visible:=true;
  frnewdown.btnNoForceNames.Visible:=false;
  frnewdown.edtFileName.Text:=ParseURI(frnewdown.edtURL.Text).document;
  newdownloadforcenames:=true;
  saveconfig;
end;

procedure Tfrnewdown.btnForceNamesClick(Sender: TObject);
begin
  frnewdown.btnForceNames.Visible:=false;
  frnewdown.btnNoForceNames.Visible:=true;
  frnewdown.edtFileName.Text:='';
  newdownloadforcenames:=false;
  saveconfig;
end;

procedure Tfrnewdown.btnDeleteFilterClick(Sender: TObject);
var
  tmpfilters:array of string;
  i,n:integer;
begin
  n:=0;
  for i:=0 to Length(domainfilters)-1 do
  begin
    if domainfilters[i]<>ParseURI(frnewdown.edtURL.Text).Host then
    begin
      SetLength(tmpfilters,Length(tmpfilters)+1);
      tmpfilters[n]:=domainfilters[n];
      inc(n);
    end;
  end;
  SetLength(domainfilters,Length(tmpfilters));
  domainfilters:=tmpfilters;
  frnewdown.btnAddToFilter.Visible:=true;
  frnewdown.btnDeleteFilter.Visible:=false;
end;

procedure Tfrnewdown.btnToEndClick(Sender: TObject);
begin
  frnewdown.btnToUp.Visible:=true;
end;

procedure Tfrnewdown.btnToUpClick(Sender: TObject);
begin
  frnewdown.btnToUp.Visible:=false;
end;


end.

