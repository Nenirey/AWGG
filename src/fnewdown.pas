unit fnewdown;
{
  New download form of AWGG

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
  Classes, SysUtils, Forms, Controls, Dialogs, StdCtrls,
  EditBtn, Buttons, fstrings, freplace, fconfirm, URIParser, LCLIntF, FileUtil;

type

  { Tfrnewdown }

  Tfrnewdown = class(TForm)
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
    procedure btnStartClick(Sender: TObject);
    procedure btnToQueueClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnPausedClick(Sender: TObject);
    procedure cbDestinationChange(Sender: TObject);
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
  accept:=true;
  updateurl:=false;
  if (frnewdown.edtFileName.Text<>'') and (frnewdown.btnToQueue.Visible=true) then
  begin
    frreplace.rbAutoRename.Checked:=true;
    found:=destinyexists(frnewdown.deDestination.Text+pathdelim+frnewdown.edtFileName.Text);
    while ((FileExists(frnewdown.deDestination.Text+pathdelim+frnewdown.edtFileName.Text)) or ((found) and (frreplace.rbOverwrite.Checked=false))) and (frreplace.rbUpdateURL.Checked=false) do
    begin
      found:=destinyexists(frnewdown.deDestination.Text+pathdelim+frnewdown.edtFileName.Text);
      frreplace.rbUpdateURL.Enabled:=found;
      frreplace.rbOverwrite.Enabled:=(not found);
      if (FileExists(frnewdown.deDestination.Text+pathdelim+frnewdown.edtFileName.Text)) or ((found) and (frreplace.rbOverwrite.Checked=false)) then
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
         accept:=true;
        if accept=true then
          frnewdown.edtFileName.Text:=frreplace.edtFileName.Text
        else
         break;
      end;
    end;
  end;
  updateurl:=frreplace.rbUpdateURL.Checked;
    if updateurl then
    begin
      destinyexists(frnewdown.deDestination.Text+pathdelim+frnewdown.edtFileName.Text,frnewdown.edtURL.Caption);
      savemydownloads();
    end;
  if accept=true then
  begin
    frnewdown.Close;
    result:=true;
  end
  else
    result:=false;
end;

procedure Tfrnewdown.btnCancelClick(Sender: TObject);
begin
  agregar:=false;
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
begin
  frnewdown.edtFileName.Text:=ParseURI(frnewdown.edtURL.Text).document;
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
  end;
end;

procedure Tfrnewdown.FormKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure Tfrnewdown.FormShow(Sender: TObject);
var
  i:integer;
begin
  frnewdown.cbDestination.Items.Clear;
  for i:=0 to Length(categoryextencions)-1 do
  begin
    frnewdown.cbDestination.Items.Add(categoryextencions[i][0]);
  end;
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
  frconfig.PageControl1.ActivePageIndex:=1;
  frconfig.tvConfig.Items[frconfig.PageControl1.ActivePageIndex].Selected:=true;
  configdlg();
  frconfig.cbQueue.ItemIndex:=frnewdown.cbQueue.ItemIndex;
  frconfig.ShowModal;
  frnewdown.cbQueue.ItemIndex:=frconfig.cbQueue.ItemIndex;
  frnewdown.FormStyle:=fsSystemStayOnTop;
end;

procedure Tfrnewdown.btnCategoryGoClick(Sender: TObject);
begin
  frnewdown.FormStyle:=fsNormal;
  frconfig.PageControl1.ActivePageIndex:=5;
  frconfig.tvConfig.Items[frconfig.PageControl1.ActivePageIndex].Selected:=true;
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

end.

