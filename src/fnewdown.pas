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
    BitBtn1: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    Button4: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    DirectoryEdit1: TDirectoryEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure DirectoryEdit1AcceptDirectory(Sender: TObject; var Value: String);
    procedure DirectoryEdit1Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
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
  if (frnewdown.Edit3.Text<>'') and (frnewdown.Button1.Visible=true) then
  begin
    frreplace.RadioButton2.Checked:=true;
    found:=destinyexists(frnewdown.DirectoryEdit1.Text+pathdelim+frnewdown.Edit3.Text);
    while ((FileExists(frnewdown.DirectoryEdit1.Text+pathdelim+frnewdown.Edit3.Text)) or ((found) and (frreplace.RadioButton1.Checked=false))) and (frreplace.RadioButton4.Checked=false) do
    begin
      found:=destinyexists(frnewdown.DirectoryEdit1.Text+pathdelim+frnewdown.Edit3.Text);
      frreplace.RadioButton4.Enabled:=found;
      frreplace.RadioButton1.Enabled:=(not found);
      if (FileExists(frnewdown.DirectoryEdit1.Text+pathdelim+frnewdown.Edit3.Text)) or ((found) and (frreplace.RadioButton1.Checked=false)) then
      begin
        frreplace.RadioButton2.Checked:=true;
        frreplace.Edit1.Text:='_'+frnewdown.Edit3.Text;
        while (destinyexists(frnewdown.DirectoryEdit1.Text+pathdelim+frreplace.Edit1.Text)) or (FileExists(frnewdown.DirectoryEdit1.Text+pathdelim+frreplace.Edit1.Text))  do
          frreplace.Edit1.Text:='_'+frreplace.Edit1.Text;
        if auto=false then
        begin
         frreplace.ShowModal;
        end
        else
         accept:=true;
        if accept=true then
          frnewdown.Edit3.Text:=frreplace.Edit1.Text
        else
         break;
      end;
    end;
  end;
  updateurl:=frreplace.RadioButton4.Checked;
    if updateurl then
    begin
      destinyexists(frnewdown.DirectoryEdit1.Text+pathdelim+frnewdown.Edit3.Text,frnewdown.Edit1.Caption);
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

procedure Tfrnewdown.Button2Click(Sender: TObject);
begin
  agregar:=false;
  frnewdown.Close;
end;

procedure Tfrnewdown.Button3Click(Sender: TObject);
begin
  if frnewdown.ComboBox1.ItemIndex<>-1 then
  begin
    agregar:=true;
    iniciar:=true;
    checkandclose();
  end
  else
    ShowMessage(frstrings.msgmustselectdownloadengine.Caption);
end;

procedure Tfrnewdown.Button4Click(Sender: TObject);
begin
  if frnewdown.ComboBox1.ItemIndex<>-1 then
  begin
    agregar:=true;
    cola:=false;
    iniciar:=false;
    checkandclose();
  end
  else
    ShowMessage(frstrings.msgmustselectdownloadengine.Caption);
end;

procedure Tfrnewdown.ComboBox3Change(Sender: TObject);
var
  newpath:string='';
begin
  newpath:=frnewdown.ComboBox3.Text;
  frnewdown.DirectoryEdit1.Text:=newpath;
  frnewdown.DirectoryEdit1AcceptDirectory(nil,newpath);
end;

procedure Tfrnewdown.DirectoryEdit1AcceptDirectory(Sender: TObject;
  var Value: String);
var
  ext:string='';
  i,x:integer;
  indice:integer=-1;
  extexists:boolean=false;
begin
  if frnewdown.Edit3.Caption<>'' then
  begin
    ext:=UpperCase(Copy(frnewdown.Edit3.Caption,LastDelimiter('.',frnewdown.Edit3.Caption)+1,Length(frnewdown.Edit3.Caption)));
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
        frconfirm.dlgtext.Caption:=frstrings.newfiletyperememberpath.Caption;
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

procedure Tfrnewdown.DirectoryEdit1Change(Sender: TObject);
begin
  frnewdown.ComboBox3.Text:=frnewdown.DirectoryEdit1.Text;
end;

procedure Tfrnewdown.Edit1Change(Sender: TObject);
begin
  frnewdown.Edit3.Text:=ParseURI(frnewdown.Edit1.Text).document;
end;

procedure Tfrnewdown.Edit3Change(Sender: TObject);
begin
  case defaultdirmode of
    1:frnewdown.DirectoryEdit1.Text:=ddowndir;
    2:frnewdown.DirectoryEdit1.Text:=suggestdir(frnewdown.Edit3.Text);
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
    13:frnewdown.Button3Click(nil);
    27:frnewdown.Button2Click(nil);
    113:frnewdown.Button1Click(nil);
  end;
end;

procedure Tfrnewdown.FormKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure Tfrnewdown.FormShow(Sender: TObject);
var
  i:integer;
begin
  frnewdown.ComboBox3.Items.Clear;
  for i:=0 to Length(categoryextencions)-1 do
  begin
    frnewdown.ComboBox3.Items.Add(categoryextencions[i][0]);
  end;
end;

procedure Tfrnewdown.SpeedButton1Click(Sender: TObject);
var
  i:integer;
begin
  newqueue();
  frnewdown.ComboBox2.Items.Clear;
  for i:=0 to Length(queues)-1 do
  begin
    frnewdown.ComboBox2.Items.Add(queuenames[i]);
  end;
  frnewdown.ComboBox2.ItemIndex:=Length(queues)-1;
end;

procedure Tfrnewdown.SpeedButton2Click(Sender: TObject);
begin
  frnewdown.FormStyle:=fsNormal;
  frconfig.PageControl1.ActivePageIndex:=1;
  frconfig.tvConfig.Items[frconfig.PageControl1.ActivePageIndex].Selected:=true;
  configdlg();
  frconfig.ComboBox4.ItemIndex:=frnewdown.ComboBox2.ItemIndex;
  frconfig.ShowModal;
  frnewdown.ComboBox2.ItemIndex:=frconfig.ComboBox4.ItemIndex;
  frnewdown.FormStyle:=fsSystemStayOnTop;
end;

procedure Tfrnewdown.SpeedButton3Click(Sender: TObject);
begin
  frnewdown.FormStyle:=fsNormal;
  frconfig.PageControl1.ActivePageIndex:=5;
  frconfig.tvConfig.Items[frconfig.PageControl1.ActivePageIndex].Selected:=true;
  configdlg();
  frconfig.ShowModal;
  categoryreload();
  frnewdown.FormStyle:=fsSystemStayOnTop;
end;

procedure Tfrnewdown.SpeedButton4Click(Sender: TObject);
begin
  if not OpenURL(frnewdown.DirectoryEdit1.Text) then
    OpenURL(ExtractShortPathName(UTF8ToSys(frnewdown.DirectoryEdit1.Text)));
end;

procedure Tfrnewdown.Button1Click(Sender: TObject);
begin
  if frnewdown.ComboBox1.ItemIndex<>-1 then
  begin
    agregar:=true;
    cola:=true;
    iniciar:=false;
    checkandclose();
  end
  else
    ShowMessage(frstrings.msgmustselectdownloadengine.Caption);
end;

procedure Tfrnewdown.BitBtn1Click(Sender: TObject);
begin
  if frnewdown.ComboBox1.ItemIndex<>-1 then
  begin
    agregar:=true;
    iniciar:=true;
    checkandclose();
  end
  else
    ShowMessage(frstrings.msgmustselectdownloadengine.Caption);
end;

end.

