unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, Unit6, Unit8;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ComboBox1: TComboBox;
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
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form2: TForm2;
  //downitem:TListItem;
  iniciar,agregar,cola:Boolean;
implementation
uses Unit1;
{$R *.lfm}

{ TForm2 }
{function destinyexists(destiny:string):boolean;
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
end;}
{function urlexists(url:string):boolean;
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
end;}
procedure checkandclose();
var found:boolean;
begin
accept:=true;
if (Form2.Edit3.Text<>'') and (Form2.Button1.Visible=true) then
begin
Form6.RadioButton2.Checked:=true;
found:=destinyexists(Form2.DirectoryEdit1.Text+pathdelim+Form2.Edit3.Text);
while (FileExists(Form2.DirectoryEdit1.Text+pathdelim+Form2.Edit3.Text)) or ((found) and (Form6.RadioButton1.Checked=false)) do
begin
found:=destinyexists(Form2.DirectoryEdit1.Text+pathdelim+Form2.Edit3.Text);
if (FileExists(Form2.DirectoryEdit1.Text+pathdelim+Form2.Edit3.Text)) or ((found) and (Form6.RadioButton1.Checked=false)) then
begin
Form6.RadioButton2.Checked:=true;
Form6.Edit1.Text:='_'+Form2.Edit3.Text;
while (destinyexists(Form2.DirectoryEdit1.Text+pathdelim+Form6.Edit1.Text)) or (FileExists(Form2.DirectoryEdit1.Text+pathdelim+Form6.Edit1.Text)) do
Form6.Edit1.Text:='_'+Form6.Edit1.Text;
Form6.Label4.Caption:=Form2.Edit3.Text;
Form6.Label3.Caption:=Form2.DirectoryEdit1.Text;
Form6.ShowModal;
if accept=true then
Form2.Edit3.Text:=Form6.Edit1.Text
else
break;
end;
end;
end;
if accept=true then
Form2.Close;
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
  27:checkandclose();
  113:Form2.Button1Click(nil);
  end;
end;

procedure TForm2.FormKeyPress(Sender: TObject; var Key: char);
begin

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

end.

