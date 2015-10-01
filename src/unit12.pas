unit Unit12;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls,
  ComCtrls;

type

  { TForm10 }

  TForm10 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
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
  Form10: TForm10;

implementation
uses Unit1;
{ TForm10 }

procedure TForm10.Button1Click(Sender: TObject);
begin
  copywork[self.id].stop;
end;

procedure TForm10.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  copywork[self.id].stop;
end;

{$R *.lfm}

end.

