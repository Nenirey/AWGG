unit Unit9;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, ExtCtrls, ComCtrls, Spin, Buttons;

type

  { TForm7 }

  TForm7 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    ComboBox1: TComboBox;
    DirectoryEdit1: TDirectoryEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    GroupBox9: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    Memo5: TMemo;
    Memo6: TMemo;
    Memo7: TMemo;
    Memo8: TMemo;
    PageControl1: TPageControl;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpinEdit1: TSpinEdit;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form7: TForm7;
  grbadd:boolean;
implementation
uses Unit1, Unit3;
{$R *.lfm}

{ TForm7 }

procedure validatesite();
begin
if (Length(Form7.Edit2.Text)>0) and (Length(Form7.Edit1.Text)>0) then
begin
Form7.Button1.Enabled:=true;
Form7.Button4.Enabled:=true;
end
else
begin
Form7.Button1.Enabled:=false;
Form7.Button4.Enabled:=false;
end;
end;

procedure TForm7.FormCreate(Sender: TObject);
begin
  grbadd:=false;
  Form7.Button3.Enabled:=false;
  validatesite();
end;

procedure TForm7.SpeedButton1Click(Sender: TObject);
var i:integer;
begin
newqueue();
  Form7.ComboBox1.Items.Clear;
for i:=0 to Length(queues)-1 do
    begin
    Form7.ComboBox1.Items.Add(queuenames[i]);
    end;
Form7.ComboBox1.ItemIndex:=Length(queues)-1;
end;

procedure TForm7.SpeedButton2Click(Sender: TObject);
begin
  Form3.PageControl1.ActivePageIndex:=1;
  Form3.TreeView1.Items[Form3.PageControl1.ActivePageIndex].Selected:=true;
  configdlg();
  Form3.ComboBox4.ItemIndex:=Form7.ComboBox1.ItemIndex;
  Form3.ComboBox4Change(nil);
  Form3.ShowModal;
  Form7.ComboBox1.ItemIndex:=Form3.ComboBox4.ItemIndex;
end;

procedure TForm7.Button1Click(Sender: TObject);
begin
  grbadd:=true;
  Form7.Close;
end;

procedure TForm7.Button2Click(Sender: TObject);
begin
  grbadd:=false;
  Form7.Close;
end;

procedure TForm7.Button3Click(Sender: TObject);
begin
  if Form7.PageControl1.TabIndex>0 then
  Form7.PageControl1.TabIndex:=Form7.PageControl1.TabIndex-1;
  if Form7.PageControl1.TabIndex=0 then
  Form7.Button3.Enabled:=false;
  Form7.Button4.Enabled:=true;
end;

procedure TForm7.Button4Click(Sender: TObject);
begin
  if Form7.PageControl1.TabIndex<Form7.PageControl1.PageCount-1 then
  Form7.PageControl1.TabIndex:=Form7.PageControl1.TabIndex+1;
  if (Form7.PageControl1.TabIndex=Form7.PageControl1.PageCount-1) then
  Form7.Button4.Enabled:=false;
  Form7.Button3.Enabled:=true;
end;

procedure TForm7.Edit1Change(Sender: TObject);
begin
  validatesite();
end;

procedure TForm7.Edit2Change(Sender: TObject);
begin
  validatesite();
end;

end.

