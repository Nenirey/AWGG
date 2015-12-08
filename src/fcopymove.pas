unit fcopymove;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls,
  ComCtrls;

type

  { Tfrcopymove }

  Tfrcopymove = class(TForm)
    btnCancel: TButton;
    lblFrom: TLabel;
    lblTo: TLabel;
    pbCopyMove: TProgressBar;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
  private
    { private declarations }
  public
    { public declarations }
  id:integer;
  end;

var
  frcopymove: Tfrcopymove;

implementation
uses fmain;
{ Tfrcopymove }

procedure Tfrcopymove.btnCancelClick(Sender: TObject);
begin
  copywork[self.id].stop;
end;

procedure Tfrcopymove.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  copywork[self.id].stop;
end;

{$R *.lfm}

end.

