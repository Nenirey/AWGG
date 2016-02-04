unit fvideoformat;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ButtonPanel, ComCtrls;

type

  { Tfrvideoformat }

  Tfrvideoformat = class(TForm)
    bpSelectFormat: TButtonPanel;
    btnReload: TButton;
    chDownSubtitle: TCheckBox;
    lblName: TLabel;
    lblVideoName: TLabel;
    lblSelectFormat: TLabel;
    lvFormats: TListView;
    procedure btnReloadClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frvideoformat: Tfrvideoformat;
  accept:boolean=false;
  vname:string='';
implementation
uses fmain,fnewdown,fstrings;
{$R *.lfm}

{ Tfrvideoformat }

procedure Tfrvideoformat.OKButtonClick(Sender: TObject);
begin
  accept:=true;
end;

procedure Tfrvideoformat.btnReloadClick(Sender: TObject);
begin
  frvideoformat.lblSelectFormat.Caption:=videoformatloading;
  frvideoformat.lblVideoName.Caption:=videonameloading;
  frvideoformat.lblName.Caption:='';
  vname:='';
  getyoutubeformats(frnewdown.edtURL.Text);
  getyoutubename(frnewdown.edtURL.Text);
end;

end.

