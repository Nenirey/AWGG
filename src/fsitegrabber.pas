unit fsitegrabber;
{
  New site grabber form of AWGG

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
  Forms, Controls, StdCtrls,
  EditBtn, ComCtrls, Spin, Buttons;

type

  { Tfrsitegrabber }

  Tfrsitegrabber = class(TForm)
    btnFinish: TButton;
    btnCancel: TButton;
    btnBack: TButton;
    btnNext: TButton;
    chLinkToLocal: TCheckBox;
    chFollowFTPLink: TCheckBox;
    chNoParentLink: TCheckBox;
    chPageRequisites: TCheckBox;
    chSpanHosts: TCheckBox;
    chFollowRelativeLink: TCheckBox;
    cbQueue: TComboBox;
    deDestination: TDirectoryEdit;
    edtURL: TEdit;
    edtSiteName: TEdit;
    edtUser: TEdit;
    edtPassword: TEdit;
    edtUserAgent: TEdit;
    gbFileRejectFilter: TGroupBox;
    gbDomainRejectFilter: TGroupBox;
    gbFollowDomainFilter: TGroupBox;
    gbIncludeDirectory: TGroupBox;
    gbExcludeDirectory: TGroupBox;
    gbFileAcceptFilter: TGroupBox;
    gbFollowTags: TGroupBox;
    gbIgnoreTags: TGroupBox;
    bgAuthentication: TGroupBox;
    lblURL: TLabel;
    lblSiteName: TLabel;
    lblDestination: TLabel;
    lblUser: TLabel;
    lblPassword: TLabel;
    lblQueue: TLabel;
    lblMaxLevel: TLabel;
    lblWelcome: TLabel;
    lblUserAgent: TLabel;
    mFileRejectFilter: TMemo;
    mDomainRejectFilter: TMemo;
    mFollowDomainFilter: TMemo;
    mIncludeDirectory: TMemo;
    mExcludeDirectory: TMemo;
    mFileAcceptFilter: TMemo;
    mFollowTags: TMemo;
    mIgnoreTags: TMemo;
    PageControl1: TPageControl;
    btnAddQueue: TSpeedButton;
    btnSchedule: TSpeedButton;
    seMaxLevel: TSpinEdit;
    tsWelcome: TTabSheet;
    tsBasicOptions: TTabSheet;
    tsFilters: TTabSheet;
    tsDirectory: TTabSheet;
    tsTags: TTabSheet;
    procedure btnFinishClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure edtURLChange(Sender: TObject);
    procedure edtSiteNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAddQueueClick(Sender: TObject);
    procedure btnScheduleClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frsitegrabber: Tfrsitegrabber;
  grbadd:boolean;
implementation
uses fmain, fconfig;
{$R *.lfm}

{ Tfrsitegrabber }

procedure validatesite();
begin
  if (Length(frsitegrabber.edtSiteName.Text)>0) and (Length(frsitegrabber.edtURL.Text)>0) then
  begin
    frsitegrabber.btnFinish.Enabled:=true;
    frsitegrabber.btnNext.Enabled:=true;
  end
  else
  begin
    frsitegrabber.btnFinish.Enabled:=false;
    frsitegrabber.btnNext.Enabled:=false;
  end;
end;

procedure Tfrsitegrabber.FormCreate(Sender: TObject);
begin
  grbadd:=false;
  frsitegrabber.btnBack.Enabled:=false;
  validatesite();
end;

procedure Tfrsitegrabber.btnAddQueueClick(Sender: TObject);
var
  i:integer;
begin
  newqueue();
  frsitegrabber.cbQueue.Items.Clear;
  for i:=0 to Length(queues)-1 do
  begin
    frsitegrabber.cbQueue.Items.Add(queuenames[i]);
  end;
  frsitegrabber.cbQueue.ItemIndex:=Length(queues)-1;
end;

procedure Tfrsitegrabber.btnScheduleClick(Sender: TObject);
begin
  frsitegrabber.FormStyle:=fsNormal;
  frconfig.pcConfig.ActivePageIndex:=1;
  frconfig.tvConfig.Items[frconfig.pcConfig.ActivePageIndex].Selected:=true;
  configdlg();
  frconfig.cbQueue.ItemIndex:=frsitegrabber.cbQueue.ItemIndex;
  frconfig.cbQueueChange(nil);
  frconfig.ShowModal;
  frsitegrabber.cbQueue.ItemIndex:=frconfig.cbQueue.ItemIndex;
  frsitegrabber.FormStyle:=fsSystemStayOnTop;
end;

procedure Tfrsitegrabber.btnFinishClick(Sender: TObject);
begin
  grbadd:=true;
  frsitegrabber.Close;
end;

procedure Tfrsitegrabber.btnCancelClick(Sender: TObject);
begin
  grbadd:=false;
  frsitegrabber.Close;
end;

procedure Tfrsitegrabber.btnBackClick(Sender: TObject);
begin
  if frsitegrabber.PageControl1.TabIndex>0 then
    frsitegrabber.PageControl1.TabIndex:=frsitegrabber.PageControl1.TabIndex-1;
  if frsitegrabber.PageControl1.TabIndex=0 then
    frsitegrabber.btnBack.Enabled:=false;
  frsitegrabber.btnNext.Enabled:=true;
end;

procedure Tfrsitegrabber.btnNextClick(Sender: TObject);
begin
  if frsitegrabber.PageControl1.TabIndex<frsitegrabber.PageControl1.PageCount-1 then
    frsitegrabber.PageControl1.TabIndex:=frsitegrabber.PageControl1.TabIndex+1;
  if (frsitegrabber.PageControl1.TabIndex=frsitegrabber.PageControl1.PageCount-1) then
    frsitegrabber.btnNext.Enabled:=false;
  frsitegrabber.btnBack.Enabled:=true;
end;

procedure Tfrsitegrabber.edtURLChange(Sender: TObject);
begin
  validatesite();
end;

procedure Tfrsitegrabber.edtSiteNameChange(Sender: TObject);
begin
  validatesite();
end;

end.

