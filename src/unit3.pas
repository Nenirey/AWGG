unit Unit3;{  Configuration form of AWGG  Copyright (C) 2014 Reinier Romero Mir  nenirey@gmail.com  This library is free software; you can redistribute it and/or modify it  under the terms of the GNU Library General Public License as published by  the Free Software Foundation; either version 2 of the License.  This program is distributed in the hope that it will be useful, but WITHOUT  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License  for more details.  You should have received a copy of the GNU Library General Public License  along with this library; if not, write to the Free Software Foundation,  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.}{$mode objfpc}{$H+}interfaceuses  Classes, SysUtils, FileUtil, Forms, Controls,  Dialogs, ComCtrls, StdCtrls, Spin, EditBtn, ExtCtrls, Buttons, Unit6;type  { TForm3 }  TForm3 = class(TForm)    Button1: TButton;    Button2: TButton;    CheckBox1: TCheckBox;    CheckBox10: TCheckBox;    CheckBox11: TCheckBox;    CheckBox12: TCheckBox;    CheckBox2: TCheckBox;    CheckBox3: TCheckBox;    CheckBox4: TCheckBox;    CheckBox5: TCheckBox;    CheckBox6: TCheckBox;    CheckBox7: TCheckBox;    CheckBox8: TCheckBox;    CheckBox9: TCheckBox;    CheckGroup1: TCheckGroup;    CheckGroup2: TCheckGroup;    CheckGroup3: TCheckGroup;    CheckGroup4: TCheckGroup;    CheckGroup5: TCheckGroup;    CheckGroup6: TCheckGroup;    ComboBox1: TComboBox;    ComboBox2: TComboBox;    ComboBox3: TComboBox;    DateEdit1: TDateEdit;    DateEdit2: TDateEdit;    DirectoryEdit1: TDirectoryEdit;    DirectoryEdit2: TDirectoryEdit;    Edit1: TEdit;    Edit10: TEdit;    Edit2: TEdit;    Edit3: TEdit;    Edit4: TEdit;    Edit5: TEdit;    Edit6: TEdit;    Edit7: TEdit;    Edit8: TEdit;    Edit9: TEdit;    FileNameEdit1: TFileNameEdit;    FileNameEdit2: TFileNameEdit;    FileNameEdit3: TFileNameEdit;    FileNameEdit4: TFileNameEdit;    FileNameEdit6: TFileNameEdit;    FileNameEdit7: TFileNameEdit;    GroupBox1: TGroupBox;    GroupBox2: TGroupBox;    GroupBox3: TGroupBox;    GroupBox4: TGroupBox;    GroupBox5: TGroupBox;    Label1: TLabel;    Label10: TLabel;    Label12: TLabel;    Label13: TLabel;    Label14: TLabel;    Label15: TLabel;    Label16: TLabel;    Label17: TLabel;    Label18: TLabel;    Label19: TLabel;    Label2: TLabel;    Label20: TLabel;    Label21: TLabel;    Label22: TLabel;    Label23: TLabel;    Label24: TLabel;    Label25: TLabel;    Label26: TLabel;    Label27: TLabel;    Label3: TLabel;    Label32: TLabel;    Label33: TLabel;    Label34: TLabel;    Label35: TLabel;    Label36: TLabel;    Label37: TLabel;    Label38: TLabel;    Label39: TLabel;    Label4: TLabel;    Label40: TLabel;    Label41: TLabel;    Label42: TLabel;    Label5: TLabel;    Label6: TLabel;    Label7: TLabel;    Label8: TLabel;    Label9: TLabel;    PageControl1: TPageControl;    Panel1: TPanel;    RadioButton1: TRadioButton;    RadioButton2: TRadioButton;    RadioButton3: TRadioButton;    RadioButton4: TRadioButton;    RadioButton5: TRadioButton;    RadioGroup1: TRadioGroup;    SpeedButton1: TSpeedButton;    SpeedButton2: TSpeedButton;    SpinEdit1: TSpinEdit;    SpinEdit10: TSpinEdit;    SpinEdit11: TSpinEdit;    SpinEdit12: TSpinEdit;    SpinEdit13: TSpinEdit;    SpinEdit14: TSpinEdit;    SpinEdit2: TSpinEdit;    SpinEdit3: TSpinEdit;    SpinEdit4: TSpinEdit;    SpinEdit6: TSpinEdit;    SpinEdit7: TSpinEdit;    SpinEdit8: TSpinEdit;    SpinEdit9: TSpinEdit;    TabSheet1: TTabSheet;    TabSheet10: TTabSheet;    TabSheet11: TTabSheet;    TabSheet15: TTabSheet;    TabSheet16: TTabSheet;    TabSheet17: TTabSheet;    TabSheet18: TTabSheet;    TabSheet2: TTabSheet;    TabSheet3: TTabSheet;    TabSheet4: TTabSheet;    TabSheet5: TTabSheet;    TabSheet6: TTabSheet;    TabSheet7: TTabSheet;    TabSheet8: TTabSheet;    TabSheet9: TTabSheet;    TreeView1: TTreeView;    procedure Button1Click(Sender: TObject);    procedure Button2Click(Sender: TObject);    procedure Button3Click(Sender: TObject);    procedure Button4Click(Sender: TObject);    procedure CheckBox10Change(Sender: TObject);    procedure CheckBox11Change(Sender: TObject);    procedure CheckBox12Change(Sender: TObject);    procedure CheckBox2Change(Sender: TObject);    procedure CheckBox3Change(Sender: TObject);    procedure CheckBox5Change(Sender: TObject);    procedure CheckBox9Change(Sender: TObject);    procedure ComboBox1Change(Sender: TObject);    procedure FormCreate(Sender: TObject);    procedure FormPaint(Sender: TObject);    procedure FormShow(Sender: TObject);    procedure PageControl1Change(Sender: TObject);    procedure SpeedButton1Click(Sender: TObject);    procedure SpeedButton2Click(Sender: TObject);    procedure SpinEdit6EditingDone(Sender: TObject);    procedure SpinEdit7EditingDone(Sender: TObject);    procedure SpinEdit8EditingDone(Sender: TObject);    procedure SpinEdit9EditingDone(Sender: TObject);    procedure TreeView1SelectionChanged(Sender: TObject);  private    { private declarations }  public    { public declarations }  end;var  Form3: TForm3;  setconfig:boolean;implementationUses unit1;{$R *.lfm}{ TForm3 }procedure TForm3.Button2Click(Sender: TObject);beginsetconfig:=false;  Form3.Close;end;procedure TForm3.Button3Click(Sender: TObject);beginplaysound(Form3.FileNameEdit6.Text)end;procedure TForm3.Button4Click(Sender: TObject);beginplaysound(Form3.FileNameEdit7.Text);end;procedure TForm3.CheckBox10Change(Sender: TObject);beginForm3.SpinEdit8.Enabled:=Form3.CheckBox10.Checked;Form3.SpinEdit9.Enabled:=Form3.CheckBox10.Checked;Form3.DateEdit2.Enabled:=(not Form3.CheckBox3.Checked) and Form3.CheckBox10.Checked;end;procedure TForm3.CheckBox11Change(Sender: TObject);begin  Form3.CheckBox3.Enabled:=Form3.CheckBox11.Checked;  Form3.CheckGroup5.Enabled:=Form3.CheckBox11.Checked;  Form3.CheckBox8.Enabled:=Form3.CheckBox11.Checked;  Form3.Label10.Enabled:=Form3.CheckBox11.Checked;  Form3.Label32.Enabled:=Form3.CheckBox11.Checked;  Form3.Label33.Enabled:=Form3.CheckBox11.Checked;  Form3.Label36.Enabled:=Form3.CheckBox11.Checked;  Form3.Checkbox10.Enabled:=Form3.CheckBox11.Checked;  Form3.SpinEdit6.Enabled:=Form3.CheckBox11.Checked;  Form3.SpinEdit7.Enabled:=Form3.CheckBox11.Checked;  Form3.SpinEdit8.Enabled:=Form3.CheckBox11.Checked;  Form3.SpinEdit9.Enabled:=Form3.CheckBox11.Checked;  Form3.DateEdit1.Enabled:=Form3.CheckBox11.Checked;  Form3.DateEdit2.Enabled:=Form3.CheckBox11.Checked;  if Form3.CheckBox11.Checked then  begin  Form3.CheckBox3Change(nil);  Form3.CheckBox10Change(nil);  end;end;procedure TForm3.CheckBox12Change(Sender: TObject);begin  Form3.GroupBox1.Enabled:=Form3.CheckBox12.Checked;end;procedure TForm3.CheckBox2Change(Sender: TObject);beginif Form3.ComboBox1.ItemIndex=2 thenbegin  Form3.Label8.Enabled:=Form3.CheckBox2.Checked;  Form3.Label9.Enabled:=Form3.CheckBox2.Checked;  Form3.Edit5.Enabled:=Form3.CheckBox2.Checked;  Form3.Edit6.Enabled:=Form3.CheckBox2.Checked;end;end;procedure TForm3.CheckBox3Change(Sender: TObject);begin  if CheckBox3.Checked then  begin    Form3.DateEdit1.Enabled:=false;    Form3.DateEdit2.Enabled:=false;    Form3.Label36.Enabled:=false;    CheckGroup5.Enabled:=true;  end  else  begin    Form3.DateEdit1.Enabled:=true;    Form3.DateEdit2.Enabled:=Form3.CheckBox10.Checked;    Form3.Label36.Enabled:=true;    CheckGroup5.Enabled:=false;  end;end;procedure TForm3.CheckBox5Change(Sender: TObject);beginif Form3.ComboBox1.ItemIndex = 2 thenbegin  if CheckBox5.Checked then  begin    Edit2.Text:=Edit1.Text;    Edit3.Text:=Edit1.Text;    SpinEdit2.Value:=SpinEdit1.Value;    SpinEdit3.Value:=SpinEdit1.Value;    Edit2.Enabled:=false;    Edit3.Enabled:=false;    SpinEdit2.Enabled:=false;    SpinEdit3.Enabled:=false;  end  else  begin  Edit2.Enabled:=true;  Edit3.Enabled:=true;  SpinEdit2.Enabled:=true;  SpinEdit3.Enabled:=true;  end;end;end;procedure TForm3.CheckBox9Change(Sender: TObject);begin  Form3.GroupBox5.Enabled:=Form3.CheckBox9.Checked;end;procedure TForm3.ComboBox1Change(Sender: TObject);begin  Case Form3.ComboBox1.ItemIndex of          0,1:begin          Form3.Edit1.Enabled:=false;          Form3.Edit2.Enabled:=false;          Form3.Edit3.Enabled:=false;          Form3.Edit4.Enabled:=false;          Form3.Edit5.Enabled:=false;          Form3.Edit6.Enabled:=false;          Form3.Label1.Enabled:=false;          Form3.Label2.Enabled:=false;          Form3.Label3.Enabled:=false;          Form3.Label4.Enabled:=false;          Form3.Label5.Enabled:=false;          Form3.Label6.Enabled:=false;          Form3.Label7.Enabled:=false;          Form3.Label8.Enabled:=false;          Form3.Label9.Enabled:=false;          Form3.Label27.Enabled:=false;          Form3.SpinEdit1.Enabled:=false;          Form3.SpinEdit2.Enabled:=false;          Form3.SpinEdit3.Enabled:=false;          Form3.CheckBox5.Enabled:=false;          Form3.CheckBox2.Enabled:=false;          end;          2:begin          Form3.Edit1.Enabled:=true;          Form3.Edit2.Enabled:=true;          Form3.Edit3.Enabled:=true;          Form3.Edit4.Enabled:=true;          Form3.Edit5.Enabled:=true;          Form3.Edit6.Enabled:=true;          Form3.Label1.Enabled:=true;          Form3.Label2.Enabled:=true;          Form3.Label3.Enabled:=true;          Form3.Label4.Enabled:=true;          Form3.Label5.Enabled:=true;          Form3.Label6.Enabled:=true;          Form3.Label7.Enabled:=true;          Form3.Label8.Enabled:=true;          Form3.Label9.Enabled:=true;          Form3.Label27.Enabled:=true;          Form3.SpinEdit1.Enabled:=true;          Form3.SpinEdit2.Enabled:=true;          Form3.SpinEdit3.Enabled:=true;          Form3.CheckBox5.Enabled:=true;          Form3.CheckBox2.Enabled:=true;          Form3.CheckBox2Change(nil);          Form3.CheckBox5Change(nil);          end;  end;end;procedure TForm3.FormCreate(Sender: TObject);begin  setconfig:=false;end;procedure TForm3.FormPaint(Sender: TObject);begin  Form3.SpinEdit6EditingDone(nil);  Form3.SpinEdit7EditingDone(nil);  Form3.SpinEdit8EditingDone(nil);  Form3.SpinEdit9EditingDone(nil);end;procedure TForm3.FormShow(Sender: TObject);begin  Form3.ComboBox1Change(nil);  Form3.CheckBox11Change(nil);  Form3.CheckBox2Change(nil);  Form3.CheckBox5Change(nil);  Form3.CheckBox9Change(nil);  Form3.CheckBox12Change(nil);  //Form3.SpinEdit6EditingDone(nil);  //Form3.SpinEdit7EditingDone(nil);  //Form3.SpinEdit8EditingDone(nil);  //Form3.SpinEdit9EditingDone(nil);end;procedure TForm3.PageControl1Change(Sender: TObject);begin  Form3.TreeView1.Items[Form3.PageControl1.ActivePageIndex].Selected:=true;end;procedure TForm3.SpeedButton1Click(Sender: TObject);beginplaysound(Form3.FileNameEdit6.Text);end;procedure TForm3.SpeedButton2Click(Sender: TObject);beginplaysound(Form3.FileNameEdit7.Text);end;procedure TForm3.SpinEdit6EditingDone(Sender: TObject);begin  if (Form3.SpinEdit6.Value<10) then  Form3.SpinEdit6.Text:='0'+inttostr(Form3.SpinEdit6.Value);end;procedure TForm3.SpinEdit7EditingDone(Sender: TObject);begin  if (Form3.SpinEdit7.Value<10) then  Form3.SpinEdit7.Text:='0'+inttostr(Form3.SpinEdit7.Value);end;procedure TForm3.SpinEdit8EditingDone(Sender: TObject);begin  if (Form3.SpinEdit8.Value<10) then  Form3.SpinEdit8.Text:='0'+inttostr(Form3.SpinEdit8.Value);end;procedure TForm3.SpinEdit9EditingDone(Sender: TObject);begin  if (Form3.SpinEdit9.Value<10) then  Form3.SpinEdit9.Text:='0'+inttostr(Form3.SpinEdit9.Value);end;procedure TForm3.TreeView1SelectionChanged(Sender: TObject);begin  Pagecontrol1.TabIndex:=TreeView1.Selected.Index;  Panel1.Caption:=TreeView1.Selected.Text;end;procedure TForm3.Button1Click(Sender: TObject);var validate:boolean;    n:integer;beginvalidate:=false;if Form3.CheckBox3.Checked thenbeginfor n:=0 to Form3.CheckGroup5.Items.Count-1 dobeginif Form3.CheckGroup5.Checked[n] thenvalidate:=true;end;endelsevalidate:=true;if validate thenbeginsetconfig:=true;Form3.Close;endelsebeginShowMessage(rsForm.msgmustselectweekday.Caption);Form3.TabSheet2.Show;end;end;end.