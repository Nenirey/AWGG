unit Unit2;
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
  EditBtn, Buttons, Unit6, Unit8, Unit7, URIParser, LCLIntF, FileUtil;

type

  { TForm2 }

  TForm2 = class(TForm)
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
  Form2: TForm2;
  //downitem:TListItem;
  iniciar,agregar,cola,updateurl:Boolean;
  function checkandclose(auto:boolean=false):boolean;
implementation
uses Unit1,Unit3;
{$R *.lfm}

function checkandclose(auto:boolean=false):boolean;
var
  found:boolean;
begin
  accept:=true;
  updateurl:=false;
  if (Form2.Edit3.Text<>'') and (Form2.Button1.Visible=true) then
  begin
    Form6.RadioButton2.Checked:=true;
    found:=destinyexists(Form2.DirectoryEdit1.Text+pathdelim+Form2.Edit3.Text);
    while ((FileExists(Form2.DirectoryEdit1.Text+pathdelim+Form2.Edit3.Text)) or ((found) and (Form6.RadioButton1.Checked=false))) and (Form6.RadioButton4.Checked=false) do
    begin
      found:=destinyexists(Form2.DirectoryEdit1.Text+pathdelim+Form2.Edit3.Text);
      Form6.RadioButton4.Enabled:=found;
      Form6.RadioButton1.Enabled:=(not found);
      if (FileExists(Form2.DirectoryEdit1.Text+pathdelim+Form2.Edit3.Text)) or ((found) and (Form6.RadioButton1.Checked=false)) then
      begin
        Form6.RadioButton2.Checked:=true;
        Form6.Edit1.Text:='_'+Form2.Edit3.Text;
        while (destinyexists(Form2.DirectoryEdit1.Text+pathdelim+Form6.Edit1.Text)) or (FileExists(Form2.DirectoryEdit1.Text+pathdelim+Form6.Edit1.Text))  do
          Form6.Edit1.Text:='_'+Form6.Edit1.Text;
        if auto=false then
        begin
         Form6.ShowModal;
        end
        else
         accept:=true;
        if accept=true then
          Form2.Edit3.Text:=Form6.Edit1.Text
        else
         break;
      end;
    end;
  end;
  updateurl:=Form6.RadioButton4.Checked;
    if updateurl then
    begin
      destinyexists(Form2.DirectoryEdit1.Text+pathdelim+Form2.Edit3.Text,Form2.Edit1.Caption);
      savemydownloads();
    end;
  if accept=true then
  begin
    Form2.Close;
    result:=true;
  end
  else
    result:=false;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  agregar:=false;
  Form2.Close;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  if Form2.ComboBox1.ItemIndex<>-1 then
  begin
    agregar:=true;
    iniciar:=true;
    checkandclose();
  end
  else
    ShowMessage(rsForm.msgmustselectdownloadengine.Caption);
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  if Form2.ComboBox1.ItemIndex<>-1 then
  begin
    agregar:=true;
    cola:=false;
    iniciar:=false;
    checkandclose();
  end
  else
    ShowMessage(rsForm.msgmustselectdownloadengine.Caption);
end;

procedure TForm2.ComboBox3Change(Sender: TObject);
begin
  Form2.DirectoryEdit1.Text:=Form2.ComboBox3.Text;
end;

procedure TForm2.DirectoryEdit1AcceptDirectory(Sender: TObject;
  var Value: String);
var
  ext:string='';
  i,x:integer;
  indice:integer=-1;
  extexists:boolean=false;
begin
  if Form2.Edit3.Caption<>'' then
  begin
    ext:=UpperCase(Copy(Form2.Edit3.Caption,LastDelimiter('.',Form2.Edit3.Caption)+1,Length(Form2.Edit3.Caption)));
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
        dlgForm.dlgtext.Caption:=rsForm.newfiletyperememberpath.Caption;
        Form2.FormStyle:=fsNormal;
        dlgForm.ShowModal;
        Form2.FormStyle:=fsSystemStayOnTop;
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

procedure TForm2.DirectoryEdit1Change(Sender: TObject);
begin
  Form2.ComboBox3.Text:=Form2.DirectoryEdit1.Text;
end;

procedure TForm2.Edit1Change(Sender: TObject);
begin
  Form2.Edit3.Text:=ParseURI(Form2.Edit1.Text).document;
end;

procedure TForm2.Edit3Change(Sender: TObject);
begin
  case defaultdirmode of
    1:Form2.DirectoryEdit1.Text:=ddowndir;
    2:Form2.DirectoryEdit1.Text:=suggestdir(Form2.Edit3.Text);
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  agregar:=false;
  iniciar:=false;
  cola:=false;
end;

procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  //ShowMessage(inttostr(Key));
  Case Key of
    13:Form2.Button3Click(nil);
    27:Form2.Button2Click(nil);
    113:Form2.Button1Click(nil);
  end;
end;

procedure TForm2.FormKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TForm2.FormShow(Sender: TObject);
var
  i:integer;
begin
  Form2.ComboBox3.Items.Clear;
  for i:=0 to Length(categoryextencions)-1 do
  begin
    Form2.ComboBox3.Items.Add(categoryextencions[i][0]);
  end;
end;

procedure TForm2.SpeedButton1Click(Sender: TObject);
var
  i:integer;
begin
  newqueue();
  Form2.ComboBox2.Items.Clear;
  for i:=0 to Length(queues)-1 do
  begin
    Form2.ComboBox2.Items.Add(queuenames[i]);
  end;
  Form2.ComboBox2.ItemIndex:=Length(queues)-1;
end;

procedure TForm2.SpeedButton2Click(Sender: TObject);
begin
  Form2.FormStyle:=fsNormal;
  Form3.PageControl1.ActivePageIndex:=1;
  Form3.TreeView1.Items[Form3.PageControl1.ActivePageIndex].Selected:=true;
  configdlg();
  Form3.ComboBox4.ItemIndex:=Form2.ComboBox2.ItemIndex;
  Form3.ShowModal;
  Form2.ComboBox2.ItemIndex:=Form3.ComboBox4.ItemIndex;
  Form2.FormStyle:=fsSystemStayOnTop;
end;

procedure TForm2.SpeedButton3Click(Sender: TObject);
begin
  Form2.FormStyle:=fsNormal;
  Form3.PageControl1.ActivePageIndex:=5;
  Form3.TreeView1.Items[Form3.PageControl1.ActivePageIndex].Selected:=true;
  configdlg();
  Form3.ShowModal;
  categoryreload();
  Form2.FormStyle:=fsSystemStayOnTop;
end;

procedure TForm2.SpeedButton4Click(Sender: TObject);
begin
  if not OpenURL(Form2.DirectoryEdit1.Text) then
    OpenURL(ExtractShortPathName(UTF8ToSys(Form2.DirectoryEdit1.Text)));
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  if Form2.ComboBox1.ItemIndex<>-1 then
  begin
    agregar:=true;
    cola:=true;
    iniciar:=false;
    checkandclose();
  end
  else
    ShowMessage(rsForm.msgmustselectdownloadengine.Caption);
end;

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
  if Form2.ComboBox1.ItemIndex<>-1 then
  begin
    agregar:=true;
    iniciar:=true;
    checkandclose();
  end
  else
    ShowMessage(rsForm.msgmustselectdownloadengine.Caption);
end;

end.

