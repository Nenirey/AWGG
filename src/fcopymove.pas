unit fcopymove;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls,
  ComCtrls;

type

  { Tfrcopymove }

  Tfrcopymove = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    ProgressBar1: TProgressBar;
    procedure Button1Click(Sender: TObject);
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

procedure Tfrcopymove.Button1Click(Sender: TObject);
begin
  copywork[self.id].stop;
end;

procedure Tfrcopymove.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  copywork[self.id].stop;
end;

{$R *.lfm}

end.

